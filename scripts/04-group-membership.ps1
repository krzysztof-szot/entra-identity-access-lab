# Baltic Finance Lab
# Day 17 - Group membership automation

param(
    [Parameter(Mandatory)]
    [string]$UserPrincipalName
)

$ErrorActionPreference = "Stop"

# Define lab group

$groupName = "SG-Graph-Automation-Lab"

# Check Microsoft Graph connection

$context = Get-MgContext

if (-not $context) {
    throw "Connect to Microsoft Graph first."
}

# Verify administrative identity

if ($context.Account -ne "adm-lab@steglitzer1outlook.onmicrosoft.com") {
    throw "This lab must be executed as adm-lab."
}

# Verify delegated authentication

if ($context.AuthType -ne "Delegated") {
    throw "This lab requires delegated authentication."
}

# Verify required permission

if ($context.Scopes -notcontains "GroupMember.ReadWrite.All") {
    throw "Missing GroupMember.ReadWrite.All permission."
}

# Restrict operation to the lab user

if ($UserPrincipalName -ne "graph.operator@steglitzer1outlook.onmicrosoft.com") {
    throw "Unexpected lab user."
}

# Retrieve existing user

$user = Get-MgUser `
    -UserId $UserPrincipalName `
    -ErrorAction Stop

# Retrieve lab group

$groups = @(
    Get-MgGroup `
        -Filter "displayName eq '$groupName'" `
        -All `
        -Property Id,DisplayName,SecurityEnabled,MailEnabled,GroupTypes,IsAssignableToRole,OnPremisesSyncEnabled `
        -ErrorAction Stop
)

# Require exactly one matching group

if ($groups.Count -ne 1) {
    throw "Expected exactly one lab group."
}

$group = $groups[0]

if ($group.SecurityEnabled -ne $true -or
    $group.MailEnabled -ne $false -or
    @($group.GroupTypes).Count -gt 0 -or
    $group.IsAssignableToRole -eq $true -or
    $group.OnPremisesSyncEnabled -eq $true) {
    throw "Lab membership changes require a cloud-managed, assigned, non-role-assignable security group."
}

# Retrieve existing group members

$members = @(
    Get-MgGroupMember `
        -GroupId $group.Id `
        -All `
        -ErrorAction Stop
)

# Check existing membership

$alreadyMember = $members |
    Where-Object { $_.Id -eq $user.Id }

if ($alreadyMember) {

    Write-Host "User is already a group member."
    Write-Host $user.UserPrincipalName

    return
}

# Add user to the group

New-MgGroupMemberByRef `
    -GroupId $group.Id `
    -OdataId "https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)" `
    -ErrorAction Stop

Write-Host "User added to the group successfully."

Write-Host "User: $($user.UserPrincipalName)"

Write-Host "Group: $($group.DisplayName)"
