# Accept input from the command line
param(
    [Parameter(Mandatory=$true)]
    [string]$input
)

# Import the Active Directory module
Import-Module ActiveDirectory

function check {
    param(
        [string]$userPrincipalName
    )
    # Collect account details
    $user = Get-ADUser -Filter {UserPrincipalName -eq $userPrincipalName} -Properties Title, Department, LastLogonDate, pwdLastSet, Enabled

    # If account is enabled, return properties
    if ($user -ne $null) {
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
}

if (Test-Path $input) {
    Get-Content $input | ForEach-Object {
        check -userPrincipalName $_
    }
} else {
    check -userPrincipalName $input
}