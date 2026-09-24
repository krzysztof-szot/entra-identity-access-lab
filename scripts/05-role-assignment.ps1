# Baltic Finance Lab
# Day 17 - Privileged role assignment
# Explicit execution and confirmation required

param(
    [Parameter(Mandatory)]
    [string]$TargetUpn,

    [switch]$Execute
)

$ErrorActionPreference = "Stop"

# Target role

$roleName = "Conditional Access Administrator"

# Check Microsoft Graph connection

$context = Get-MgContext

if (-not $context) {
    throw "Connect to Microsoft Graph first."
}

# Require delegated authentication

if ($context.AuthType -ne "Delegated") {
    throw "Delegated authentication required."
}

# Restrict operation to the lab user

if ($TargetUpn -ne "graph.operator@steglitzer1outlook.onmicrosoft.com") {
    throw "Only the Day 17 lab user is allowed."
}

# Retrieve target user

$user = Get-MgUser `
    -UserId $TargetUpn `
    -ErrorAction Stop

# Retrieve role definition

$role = Get-MgRoleManagementDirectoryRoleDefinition `
    -Filter "displayName eq '$roleName'" `
    -ErrorAction Stop

if (-not $role) {
    throw "Role definition not found."
}

# Retrieve existing assignments

$assignments = Get-MgRoleManagementDirectoryRoleAssignment `
    -All `
    -Filter "principalId eq '$($user.Id)'" `
    -ErrorAction Stop

# Check existing tenant-wide assignment

$existing = $assignments |
    Where-Object {
        $_.RoleDefinitionId -eq $role.Id -and
        $_.DirectoryScopeId -eq "/"
    }

if ($existing) {

    Write-Host "Direct tenant-wide role assignment already exists."

    return
}

# Display planned operation

Write-Host "Target: $($user.UserPrincipalName)"
Write-Host "Role: $roleName"
Write-Host "Scope: Tenant"

# Default: read-only validation

if (-not $Execute) {

    Write-Host "Read-only validation completed."
    Write-Host "No role assignment created."

    return
}

# Check write permission

if (
    $context.Scopes -notcontains
    "RoleManagement.ReadWrite.Directory"
) {
    throw "Missing RoleManagement.ReadWrite.Directory."
}

# Require explicit confirmation

$confirmation = Read-Host "Type ASSIGN to continue"

if ($confirmation -cne "ASSIGN") {

    Write-Host "Operation cancelled."

    return
}

# Attempt privileged role assignment

try {

    $assignment = New-MgRoleManagementDirectoryRoleAssignment `
        -PrincipalId $user.Id `
        -RoleDefinitionId $role.Id `
        -DirectoryScopeId "/" `
        -ErrorAction Stop

    Write-Host "Role assignment created."

    $assignment |
        Select-Object PrincipalId,
                      RoleDefinitionId,
                      DirectoryScopeId
}
catch {

    Write-Warning "Role assignment was not completed."

    throw
}