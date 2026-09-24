# Baltic Finance Lab
# Day 17 - User provisioning

param(
    [Parameter(Mandatory)]
    [string]$UserPrincipalName
)

$ErrorActionPreference = "Stop"

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

if ($context.Scopes -notcontains "User.ReadWrite.All") {
    throw "Missing User.ReadWrite.All permission."
}

# Restrict provisioning to the lab user

if ($UserPrincipalName -ne "graph.operator@steglitzer1outlook.onmicrosoft.com") {
    throw "This lab only creates graph.operator."
}

# Check whether the user already exists

$existingUser = Get-MgUser `
    -Filter "userPrincipalName eq '$UserPrincipalName'" `
    -ErrorAction Stop

if ($existingUser) {

    Write-Host "User already exists."
    Write-Host $existingUser.UserPrincipalName

    return
}

# Request temporary password

$securePassword = Read-Host `
    "Enter a strong temporary password" `
    -AsSecureString

$passwordPointer = [IntPtr]::Zero

try {

    $passwordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR(
        $securePassword
    )

    $plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR(
        $passwordPointer
    )

    # Define user properties

    $userParams = @{
        accountEnabled = $true

        displayName = "Graph Automation Operator"

        mailNickname = "graph.operator"

        userPrincipalName = $UserPrincipalName

        department = "IT"

        jobTitle = "Identity Automation Test User"

        passwordProfile = @{
            password = $plainPassword
            forceChangePasswordNextSignIn = $true
        }
    }

    # Create user

    $newUser = New-MgUser `
        -BodyParameter $userParams `
        -ErrorAction Stop

    Write-Host "User created successfully."

    $newUser |
        Select-Object DisplayName, UserPrincipalName

}
finally {

    if ($passwordPointer -ne [IntPtr]::Zero) {

        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR(
            $passwordPointer
        )
    }

    Remove-Variable plainPassword `
        -ErrorAction SilentlyContinue

    Remove-Variable userParams `
        -ErrorAction SilentlyContinue

    Remove-Variable securePassword `
        -ErrorAction SilentlyContinue
}