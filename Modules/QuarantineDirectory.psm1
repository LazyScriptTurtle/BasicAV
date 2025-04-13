function New-QuarantineFolder {
    param (
        [string]$Path = "C:\Quarantine"
    )


    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Error "This script must be run as Administrator."
        return
    }


    if (-Not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "[!] Quarantine folder not found - created: $Path" -ForegroundColor Yellow
    } else {
        Write-Host "[+] Quarantine folder already exists: $Path" -ForegroundColor Green
    }

    try {

        icacls $Path /reset
        icacls $Path /inheritance:r


        icacls $Path /remove:g *S-1-1-0


        icacls $Path /grant:r "Administrators:(OI)(CI)(R,W,D)"


        icacls $Path /deny "Administrators:(OI)(CI)(X)"


        $acl = Get-Acl -Path $Path
        $adminSid = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
        $acl.SetOwner($adminSid)
        Set-Acl -Path $Path -AclObject $acl

        Write-Host "[+] Quarantine folder secured: access restricted, execution denied, ownership set." -ForegroundColor Green


        Write-Host "[*] Effective folder permissions:" -ForegroundColor Yellow
        Get-Acl $Path | Format-List

    } catch {
        Write-Host "[-] Error while applying permissions: $_"
    }
}
