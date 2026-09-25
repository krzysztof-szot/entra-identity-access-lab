# Baltic Finance Lab
# Day 17 - Security group provisioning

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

if ($context.Scopes -notcontains "Group.ReadWrite.All") {
    throw "Missing Group.ReadWrite.All permission."
}

# Check whether the group already exists

$existingGroup = @(
    Get-MgGroup `
        -Filter "displayName eq '$groupName'" `
        -All `
        -Property Id,DisplayName,SecurityEnabled,MailEnabled,GroupTypes,IsAssignableToRole,OnPremisesSyncEnabled `
        -ErrorAction Stop
)

if ($existingGroup.Count -gt 1) {

    throw "Multiple groups found. Review manually."

}

if ($existingGroup.Count -eq 1) {

    $group = $existingGroup[0]

    if ($group.SecurityEnabled -ne $true -or
        $group.MailEnabled -ne $false -or
        @($group.GroupTypes).Count -gt 0 -or
        $group.IsAssignableToRole -eq $true -or
        $group.OnPremisesSyncEnabled -eq $true) {
        throw "Existing lab group must be a cloud-managed, assigned, non-role-assignable security group."
    }

    Write-Host "Group already exists."

    $existingGroup |
        Select-Object DisplayName,
                      SecurityEnabled,
                      MailEnabled

    return
}

# Create static security group

$newGroup = New-MgGroup `
    -DisplayName $groupName `
    -MailNickname "sg-graph-automation-lab" `
    -MailEnabled:$false `
    -SecurityEnabled:$true `
    -ErrorAction Stop

Write-Host "Security group created successfully."

$newGroup |
    Select-Object DisplayName,
                  SecurityEnabled,
                  MailEnabled
