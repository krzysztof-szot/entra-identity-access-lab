# Offline regression checks. Run in a fresh PowerShell 7 process with -NoProfile.
# All Microsoft Graph commands are local functions; no SDK or tenant is used.
$ErrorActionPreference = 'Stop'
Import-Module Microsoft.PowerShell.Management, Microsoft.PowerShell.Utility, Microsoft.PowerShell.Security
if (Get-Module Microsoft.Graph*) { throw 'Use a fresh -NoProfile process without Graph modules.' }
$PSModuleAutoLoadingPreference = 'None'

$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$scriptsRoot = Join-Path $repoRoot 'scripts'
$testRoot = Join-Path $repoRoot "local-output/local-tests/$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path "$testRoot/scripts" -Force | Out-Null
Copy-Item "$scriptsRoot/06-export-tenant-state.ps1" "$testRoot/scripts/"
$global:auditchecks = 0

function Assert-True($Condition, $Message) {
    if (-not $Condition) { throw "FAIL: $Message" }
    $global:auditchecks++
    Write-Host "PASS: $Message"
}
function Assert-Throws([scriptblock]$Action, [string]$Pattern) {
    $caught = $null
    try { & $Action | Out-Null } catch { $caught = $_.Exception.Message }
    Assert-True ($null -ne $caught -and $caught -like $Pattern) "Rejects: $Pattern (caught: $caught)"
}
function Reset-Scenario {
    $global:auditcontext = [pscustomobject]@{
        Account = 'adm-lab@steglitzer1outlook.onmicrosoft.com'
        TenantId = '00000000-0000-0000-0000-000000000001'
        AuthType = 'Delegated'
        Scopes = @('User.Read.All','User.ReadWrite.All','Group.Read.All','Group.ReadWrite.All',
            'GroupMember.ReadWrite.All','Application.Read.All','RoleManagement.Read.Directory',
            'RoleManagement.ReadWrite.Directory','Policy.Read.All')
    }
    $global:audituser = [pscustomobject]@{ Id='user-1'; UserPrincipalName='graph.operator@steglitzer1outlook.onmicrosoft.com'; DisplayName='Graph Automation Operator' }
    $global:auditgroups = @([pscustomobject]@{
        Id='group-1'; DisplayName='SG-Graph-Automation-Lab'; SecurityEnabled=$true
        MailEnabled=$false; GroupTypes=@(); IsAssignableToRole=$false; OnPremisesSyncEnabled=$null
    })
    $global:auditmembers = @()
    $global:auditassignments = @()
    $global:auditwrites = 0
    $global:audituserExists = $true
    $global:auditmembershipFailure = $false
    $global:auditcaFailure = $false
    $global:audituserFailure = $false
    $global:auditwriteFailure = $false
    $global:auditconfirmation = 'CANCEL'
}

function Get-MgContext { $global:auditcontext }
function Connect-MgGraph { [CmdletBinding()]param($TenantId,$Scopes,$ContextScope,[switch]$NoWelcome) }
function Get-MgUser {
    [CmdletBinding()]param($UserId,$Filter,[switch]$All,$Property)
    if ($global:audituserFailure) { throw 'Simulated user read failure' }
    if ($Filter -and -not $global:audituserExists) { return }
    $global:audituser
}
function New-MgUser {
    [CmdletBinding()]param($BodyParameter)
    if (-not $BodyParameter.passwordProfile.forceChangePasswordNextSignIn) { throw 'Password change must be required' }
    $global:auditwrites++; $global:audituserExists=$true; $global:audituser
}
function Get-MgGroup {
    [CmdletBinding()]param($Filter,[switch]$All,$Property)
    if ($All) { $global:auditgroups } else { $global:auditgroups | Select-Object -First 1 }
}
function New-MgGroup {
    [CmdletBinding()]param($DisplayName,$MailNickname,[switch]$MailEnabled,[switch]$SecurityEnabled)
    $global:auditwrites++
}
function Get-MgGroupMember {
    [CmdletBinding()]param($GroupId,[switch]$All)
    if ($global:auditmembershipFailure) { throw 'Simulated membership denial' }
    $global:auditmembers
}
function New-MgGroupMemberByRef {
    [CmdletBinding()]param($GroupId,$OdataId)
    $global:auditwrites++; $global:auditmembers=@($global:audituser)
}
function Get-MgRoleManagementDirectoryRoleDefinition {
    [CmdletBinding()]param($Filter,[switch]$All)
    [pscustomobject]@{Id='role-1'; DisplayName='Conditional Access Administrator'}
}
function Get-MgRoleManagementDirectoryRoleAssignment {
    [CmdletBinding()]param($Filter,[switch]$All)
    $global:auditassignments
}
function New-MgRoleManagementDirectoryRoleAssignment {
    [CmdletBinding()]param($PrincipalId,$RoleDefinitionId,$DirectoryScopeId)
    if ($global:auditwriteFailure) { throw 'Simulated 403 Forbidden' }
    $global:auditwrites++
    $global:auditassignments=@([pscustomobject]@{Id='assignment-1'; PrincipalId=$PrincipalId; RoleDefinitionId=$RoleDefinitionId; DirectoryScopeId=$DirectoryScopeId})
    $global:auditassignments
}
function Get-MgApplication { [CmdletBinding()]param([switch]$All) [pscustomobject]@{Id='app-object-1';AppId='app-client-1';DisplayName='Expense Portal'} }
function Get-MgServicePrincipal { [CmdletBinding()]param([switch]$All) [pscustomobject]@{Id='sp-1';AppId='app-client-1';DisplayName='Expense Portal';ServicePrincipalType='Application'} }
function Get-MgIdentityConditionalAccessPolicy {
    [CmdletBinding()]param([switch]$All)
    if ($global:auditcaFailure) { throw 'Simulated CA denial' }
    [pscustomobject]@{Id='policy-1';DisplayName='CA001';State='enabled'}
}
function Read-Host {
    param($Prompt,[switch]$AsSecureString)
    if ($AsSecureString) { ConvertTo-SecureString 'Offline-fixture-only-42!' -AsPlainText -Force }
    else { $global:auditconfirmation }
}

# Verify every Graph command in the scripts resolves to a local fake before execution.
foreach ($file in Get-ChildItem "$scriptsRoot/*.ps1") {
    $tokens=$null; $parseErrors=$null
    $ast=[System.Management.Automation.Language.Parser]::ParseFile($file.FullName,[ref]$tokens,[ref]$parseErrors)
    Assert-True ($parseErrors.Count -eq 0) "PowerShell syntax: $($file.Name)"
    foreach ($command in $ast.FindAll({param($node) $node -is [System.Management.Automation.Language.CommandAst]},$true)) {
        $name=$command.GetCommandName()
        if ($name -like '*-Mg*') {
            if ((Get-Command $name).CommandType -ne 'Function') { throw "Graph command is not mocked: $name" }
        }
    }
}

Reset-Scenario
Assert-Throws { & "$scriptsRoot/01-connect-graph.ps1" -TenantId 'unexpected-tenant' } '*unexpected tenant*'
$target=$global:audituser.UserPrincipalName
$global:auditcontext=$null
Assert-Throws { & "$scriptsRoot/02-create-user.ps1" -UserPrincipalName $target } '*Connect to Microsoft Graph first*'
Reset-Scenario
$global:auditcontext.Account='wrong-operator@example.invalid'
Assert-Throws { & "$scriptsRoot/02-create-user.ps1" -UserPrincipalName $target } '*executed as adm-lab*'
Reset-Scenario
$global:audituserExists=$false
& "$scriptsRoot/02-create-user.ps1" -UserPrincipalName $target | Out-Null
& "$scriptsRoot/02-create-user.ps1" -UserPrincipalName $target | Out-Null
Assert-True ($global:auditwrites -eq 1) 'User provisioning rerun does not duplicate the user'

Reset-Scenario
& "$scriptsRoot/03-create-group.ps1" | Out-Null
Assert-True ($global:auditwrites -eq 0) 'Existing valid group is reused without a write'
$global:auditgroups+= $global:auditgroups[0]
Assert-Throws { & "$scriptsRoot/03-create-group.ps1" } '*Multiple groups*'
Assert-Throws { & "$scriptsRoot/04-group-membership.ps1" -UserPrincipalName $target } '*exactly one lab group*'
foreach ($kind in 'Dynamic','MailEnabled','RoleAssignable','Synchronized','NotSecurity') {
    Reset-Scenario
    switch ($kind) {
        Dynamic { $global:auditgroups[0].GroupTypes=@('DynamicMembership') }
        MailEnabled { $global:auditgroups[0].MailEnabled=$true }
        RoleAssignable { $global:auditgroups[0].IsAssignableToRole=$true }
        Synchronized { $global:auditgroups[0].OnPremisesSyncEnabled=$true }
        NotSecurity { $global:auditgroups[0].SecurityEnabled=$false }
    }
    Assert-Throws { & "$scriptsRoot/03-create-group.ps1" } '*cloud-managed*'
    Assert-Throws { & "$scriptsRoot/04-group-membership.ps1" -UserPrincipalName $target } '*cloud-managed*'
    Assert-True ($global:auditwrites -eq 0) "No mutation of incompatible group: $kind"
}
Reset-Scenario
& "$scriptsRoot/04-group-membership.ps1" -UserPrincipalName $target
& "$scriptsRoot/04-group-membership.ps1" -UserPrincipalName $target
Assert-True ($global:auditwrites -eq 1) 'Membership rerun adds only once'

Reset-Scenario
& "$scriptsRoot/05-role-assignment.ps1" -TargetUpn $target
Assert-True ($global:auditwrites -eq 0) 'Role default is read-only'
& "$scriptsRoot/05-role-assignment.ps1" -TargetUpn $target -Execute
Assert-True ($global:auditwrites -eq 0) 'Role write is cancelled without ASSIGN'
$global:auditconfirmation='ASSIGN'; $global:auditwriteFailure=$true
Assert-Throws { & "$scriptsRoot/05-role-assignment.ps1" -TargetUpn $target -Execute } '*403 Forbidden*'
$global:auditwriteFailure=$false
& "$scriptsRoot/05-role-assignment.ps1" -TargetUpn $target -Execute | Out-Null
& "$scriptsRoot/05-role-assignment.ps1" -TargetUpn $target -Execute | Out-Null
Assert-True ($global:auditwrites -eq 1) 'Existing direct role is not assigned twice'

function Invoke-ExportScenario {
    param([string]$ExpectedStatus)
    $before=@(Get-ChildItem "$testRoot/local-output/day-17" -Directory -ErrorAction SilentlyContinue)
    if ($ExpectedStatus -eq 'Failed') {
        Assert-Throws { & "$testRoot/scripts/06-export-tenant-state.ps1" } '*Simulated user read failure*'
    } else { & "$testRoot/scripts/06-export-tenant-state.ps1" }
    $after=@(Get-ChildItem "$testRoot/local-output/day-17" -Directory)
    $new=@($after | Where-Object FullName -notin $before.FullName)
    Assert-True ($new.Count -eq 1) 'Each export creates a distinct directory'
    $manifest=Get-Content "$($new[0].FullName)/export-status.json" -Raw | ConvertFrom-Json
    Assert-True ($manifest.Status -eq $ExpectedStatus) "Persisted export status: $ExpectedStatus"
    Assert-True ($global:auditwrites -eq 0) 'Export uses no Graph mutation'
    return $new[0].FullName
}
Reset-Scenario
$global:auditmembers=@([pscustomobject]@{Id='unresolved-principal'})
$export=Invoke-ExportScenario Complete
$row=Import-Csv "$export/group-membership.csv"
Assert-True ($row.MemberId -eq 'unresolved-principal' -and $row.GroupId -eq 'group-1') 'Unresolved members retain stable IDs'
Invoke-ExportScenario Complete | Out-Null
$global:auditmembershipFailure=$true
$export=Invoke-ExportScenario Partial
$status=Get-Content "$export/export-status.json" -Raw | ConvertFrom-Json
Assert-True ($status.Issues[0].ObjectId -eq 'group-1') 'Partial membership status identifies the omitted group'
Reset-Scenario
$global:auditcaFailure=$true
Invoke-ExportScenario Partial | Out-Null
Reset-Scenario
$global:auditcontext.Scopes=@($global:auditcontext.Scopes | Where-Object {$_ -ne 'Policy.Read.All'})
Invoke-ExportScenario Partial | Out-Null
Reset-Scenario
$global:audituserFailure=$true
Invoke-ExportScenario Failed | Out-Null
Write-Host "Completed $global:auditchecks offline checks. Fixture exports: $testRoot"
