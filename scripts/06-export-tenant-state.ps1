# Baltic Finance Lab
# Day 17 - Tenant state export
# Local output only

$ErrorActionPreference = "Stop"

# CHECK GRAPH CONNECTION

$context = Get-MgContext

if (-not $context) {
    throw "Connect to Microsoft Graph first."
}

if ($context.Account -ne "adm-lab@steglitzer1outlook.onmicrosoft.com") {
    throw "This lab must be executed as adm-lab."
}

if ($context.AuthType -ne "Delegated") {
    throw "Delegated authentication required."
}

# CHECK REQUIRED READ PERMISSIONS

$requiredScopes = @(
    "User.Read.All"
    "Group.Read.All"
    "Application.Read.All"
    "RoleManagement.Read.Directory"
)

foreach ($scope in $requiredScopes) {

    if ($context.Scopes -notcontains $scope) {
        throw "Missing required permission: $scope"
    }
}

# PREPARE LOCAL OUTPUT

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$runId = [guid]::NewGuid().ToString("N")

$repoRoot = Split-Path -Parent $PSScriptRoot

$root = Join-Path $repoRoot "local-output/day-17"

$output = Join-Path $root "$timestamp-$runId"

New-Item `
    -ItemType Directory `
    -Path $output `
    -Force |
    Out-Null

Write-Host "Starting tenant state export."

# Persist status before reads so an interrupted or failed run cannot look complete.
$issues = [System.Collections.Generic.List[object]]::new()
$manifest = [ordered]@{
    Status = "InProgress"
    TenantId = $context.TenantId
    Account = $context.Account
    StartedAtUtc = [DateTime]::UtcNow.ToString("o")
    CompletedAtUtc = $null
    Issues = @()
}
$manifestPath = Join-Path $output "export-status.json"
$manifest | ConvertTo-Json -Depth 5 | Set-Content -Path $manifestPath -Encoding utf8

try {

# USERS

$users = @(
    Get-MgUser `
        -All `
        -Property Id,DisplayName,UserPrincipalName,Department,AccountEnabled `
        -ErrorAction Stop
)

$users |
    Select-Object Id,
                  DisplayName,
                  UserPrincipalName,
                  Department,
                  AccountEnabled |
    Export-Csv `
        -Path "$output/users.csv" `
        -NoTypeInformation `
        -Encoding utf8

Write-Host "Users exported."

# GROUPS

$groups = @(
    Get-MgGroup -All -ErrorAction Stop
)

$groups |
    Select-Object Id,
                  DisplayName,
                  SecurityEnabled,
                  MailEnabled |
    Export-Csv `
        -Path "$output/groups.csv" `
        -NoTypeInformation `
        -Encoding utf8

Write-Host "Groups exported."

# GROUP MEMBERSHIP

$userLookup = @{}

foreach ($user in $users) {
    $userLookup[$user.Id] = $user.UserPrincipalName
}

$membership = @(
    foreach ($group in $groups) {

        try {

            $members = @(Get-MgGroupMember `
                -GroupId $group.Id `
                -All `
                -ErrorAction Stop)

            foreach ($member in $members) {

                $memberName = "[non-user or unavailable]"

                if ($userLookup.ContainsKey($member.Id)) {
                    $memberName = $userLookup[$member.Id]
                }

                [PSCustomObject]@{
                    GroupId = $group.Id
                    Group  = $group.DisplayName
                    MemberId = $member.Id
                    Member = $memberName
                }
            }
        }
        catch {

            $issues.Add([PSCustomObject]@{
                Section = "GroupMembership"
                ObjectId = $group.Id
                Reason = "Read failed; inspect the local warning."
            })
            Write-Warning "Membership export incomplete for group: $($group.DisplayName)"
            Write-Warning $_.Exception.Message
        }
    }
)

$membership |
    Export-Csv `
        -Path "$output/group-membership.csv" `
        -NoTypeInformation `
        -Encoding utf8

Write-Host "Group membership export completed."

# ROLE DEFINITIONS AND ASSIGNMENTS

$roleDefinitions = @(
    Get-MgRoleManagementDirectoryRoleDefinition `
        -All `
        -ErrorAction Stop
)

$roleLookup = @{}

foreach ($role in $roleDefinitions) {
    $roleLookup[$role.Id] = $role.DisplayName
}

$roleAssignments = @(
    Get-MgRoleManagementDirectoryRoleAssignment `
        -All `
        -ErrorAction Stop
)

$roleReport = @(
    foreach ($assignment in $roleAssignments) {

        $principalName = "[non-user or unavailable]"

        if ($userLookup.ContainsKey($assignment.PrincipalId)) {
            $principalName = $userLookup[$assignment.PrincipalId]
        }

        $roleName = "[role unavailable]"

        if ($roleLookup.ContainsKey($assignment.RoleDefinitionId)) {
            $roleName = $roleLookup[$assignment.RoleDefinitionId]
        }

        [PSCustomObject]@{
            AssignmentId = $assignment.Id
            PrincipalId = $assignment.PrincipalId
            Principal = $principalName
            RoleDefinitionId = $assignment.RoleDefinitionId
            Role = $roleName
            Scope = $assignment.DirectoryScopeId
        }
    }
)

$roleReport |
    Export-Csv `
        -Path "$output/role-assignments.csv" `
        -NoTypeInformation `
        -Encoding utf8

Write-Host "Role assignments exported."

# APP REGISTRATIONS

Get-MgApplication -All -ErrorAction Stop |
    Select-Object Id,AppId,DisplayName |
    Export-Csv `
        -Path "$output/app-registrations.csv" `
        -NoTypeInformation `
        -Encoding utf8

Write-Host "App registrations exported."

# ENTERPRISE APPLICATIONS

Get-MgServicePrincipal -All -ErrorAction Stop |
    Select-Object Id,
                  AppId,
                  DisplayName,
                  ServicePrincipalType |
    Export-Csv `
        -Path "$output/enterprise-applications.csv" `
        -NoTypeInformation `
        -Encoding utf8

Write-Host "Enterprise applications exported."

# CONDITIONAL ACCESS

if ($context.Scopes -contains "Policy.Read.All") {

    try {

        Get-MgIdentityConditionalAccessPolicy `
            -All `
            -ErrorAction Stop |
            Select-Object Id,DisplayName,State |
            Export-Csv `
                -Path "$output/conditional-access.csv" `
                -NoTypeInformation `
                -Encoding utf8

        Write-Host "Conditional Access summary exported."
    }
    catch {

        $issues.Add([PSCustomObject]@{
            Section = "ConditionalAccess"
            ObjectId = $null
            Reason = "Read failed; inspect the local warning."
        })
        Write-Warning "Conditional Access export failed."
        Write-Warning $_.Exception.Message
    }
}
else {

    $issues.Add([PSCustomObject]@{
        Section = "ConditionalAccess"
        ObjectId = $null
        Reason = "Skipped: missing Policy.Read.All."
    })
    Write-Warning "Conditional Access skipped: missing Policy.Read.All."
}

$manifest.Status = if ($issues.Count -gt 0) { "Partial" } else { "Complete" }
}
catch {
    $manifest.Status = "Failed"
    $issues.Add([PSCustomObject]@{
        Section = "Export"
        ObjectId = $null
        Reason = "Terminating error; inspect the local error."
    })
    throw
}
finally {
    $manifest.CompletedAtUtc = [DateTime]::UtcNow.ToString("o")
    $manifest.Issues = $issues.ToArray()
    $manifest | ConvertTo-Json -Depth 5 | Set-Content -Path $manifestPath -Encoding utf8
}

if ($manifest.Status -eq "Partial") {
    Write-Warning "Tenant state export is partial. Review export-status.json before using the CSV files."
}
else {
    Write-Host "Selected tenant state export completed."
}
Write-Host "Files saved to: $output"
