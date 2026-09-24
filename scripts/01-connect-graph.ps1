# Baltic Finance Lab
# Day 17 - Microsoft Graph connection

param(
    [Parameter(Mandatory)]
    [string]$TenantId,

    [ValidateSet("Read", "IdentityWrite", "RoleWrite")]
    [string]$Mode = "Read"
)

$ErrorActionPreference = "Stop"

$scopes = switch ($Mode) {

    "Read" {
        @(
            "User.Read.All"
            "Group.Read.All"
            "Application.Read.All"
            "RoleManagement.Read.Directory"
            "Policy.Read.All"
        )
    }

    "IdentityWrite" {
        @(
            "User.ReadWrite.All"
            "User.Read.All"
            "Group.ReadWrite.All"
            "GroupMember.ReadWrite.All"
            "Group.Read.All"
        )
    }

    "RoleWrite" {
        @(
            "User.Read.All"
            "RoleManagement.ReadWrite.Directory"
        )
    }
}

Connect-MgGraph `
    -TenantId $TenantId `
    -Scopes $scopes `
    -ContextScope Process `
    -NoWelcome `
    -ErrorAction Stop

$context = Get-MgContext

if ($context.TenantId -ne $TenantId) {
    throw "Connected to an unexpected tenant."
}

Write-Host "Connected to Microsoft Graph."
Write-Host "Account: $($context.Account)"
Write-Host "Mode: $Mode"
Write-Host "AuthType: $($context.AuthType)"

$context.Scopes |
    Sort-Object
