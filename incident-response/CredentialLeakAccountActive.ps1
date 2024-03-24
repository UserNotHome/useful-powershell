# Accept UserPrincipalName from the command line argument
param(
    [Parameter(Mandatory=$true)]
    [string]$userPrincipalName
)

# Import the Active Directory module
Import-Module ActiveDirectory

# Get the user account details including additional properties
$user = Get-ADUser -Filter {UserPrincipalName -eq $userPrincipalName} -Properties Title, Department, LastLogonDate, pwdLastSet, Enabled

# Check if the account is found
if ($user -ne $null) {
    # Check if the account is enabled
    if ($user.Enabled -eq $true) {
        Write-Host "Account Status: Enabled"
        Write-Host "Title: $($user.Title)"
        Write-Host "Department: $($user.Department)"
        Write-Host "Last Logon Date: $($user.LastLogonDate)"
        Write-Host "Password Last Set: $(Get-Date $user.pwdLastSet -Format 'dd-MM-yyyy HH:mm:ss')"
    } else {
        Write-Host "The account is disabled."
    }
} else {
    Write-Host "The account was not found."
}
