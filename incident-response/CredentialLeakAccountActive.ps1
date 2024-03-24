# Accept input from the command line
param(
    [Parameter(Mandatory=$True)]
    [string]$account
)

# Import the Active Directory module
Import-Module ActiveDirectory

function accountCheck($UPN) {
    # Get the account properties
    $user = Get-ADUser -Filter {UserPrincipalName -eq $UPN} -Properties UserPrincipalName, Title, Department, LastLogonDate, passwordLastSet, Enabled
    
    # Us the account valid
    if ($user -ne $null) {
        # Check if the account is enabled
        if ($user.Enabled -eq $true) {
            Write-Host "Account: $($user.UserPrincipalName)"
            Write-Host "Title: $($user.Title)"
            Write-Host "Department: $($user.Department)"
            Write-Host "Last Logon Date: $($user.LastLogonDate)"
            Write-Host "Password Last Set: $(Get-Date $user.passwordLastSet -Format 'dd-MM-yyyy HH:mm:ss')"
            Write-Host "Account Status: Enabled"
        } else {
            Write-Host "The account is disabled."
        }
    } else {
        Write-Host "The account was not found."
    }
}

# Check if the $account is not empty
if (-not [string]::IsNullOrWhiteSpace($account)) {
    # Determine if the input is a file path or a UPN
    if (Test-Path $account) {
        # If it's a file, read UPNs line by line
        $UPNs = Get-Content -Path $account
        foreach ($UPN in $UPNs) {
            accountCheck $UPN
        }
    } else {
        # If it's not a file, assume it is a single UPN
        accountCheck $account
    }
} else {
    Write-Host "Please provide a UserPrincipalName or a path to a file containing UserPrincipalNames."
} 