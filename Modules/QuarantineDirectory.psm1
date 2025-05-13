function New-QuarantineFolder {
    param (
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        Write-Host "[-] Quarantine folder not found at '$Path'." -ForegroundColor Red
        return $false
    }

    try {
        $owner = New-Object System.Security.Principal.NTAccount("SYSTEM")
        $acl = Get-Acl -Path $Path
        $acl.SetOwner($owner)
        Write-Host "[+] Owner set to SYSTEM." -ForegroundColor Green

        $acl.Access | ForEach-Object {
            $acl.RemoveAccessRule($_)
        }
        Write-Host "[+] Existing ACL rules removed." -ForegroundColor Green

        $adminSid = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
        $adminGroup = $adminSid.Translate([System.Security.Principal.NTAccount])
        Write-Host "[+] Admin group identified: $adminGroup." -ForegroundColor Green

        $adminWriteOnlyRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $adminGroup,
            "Write",
            "ContainerInherit,ObjectInherit",
            "None",
            "Allow"
        )
        $acl.AddAccessRule($adminWriteOnlyRule)
        Write-Host "[+] Write permission added for $adminGroup." -ForegroundColor Green

        $denyReadRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
            $adminGroup,
            "Read,ReadAndExecute,Delete",
            "ContainerInherit,ObjectInherit",
            "None",
            "Deny"
        )
        $acl.AddAccessRule($denyReadRule)
        Write-Host "[+] Deny permission added for $adminGroup (Read, Execute, Delete)." -ForegroundColor Green

        $acl.AddAccessRule((
            New-Object System.Security.AccessControl.FileSystemAccessRule(
                "SYSTEM",
                "FullControl",
                "ContainerInherit,ObjectInherit",
                "None",
                "Allow"
            )
        ))
        Write-Host "[+] Full control permission added for SYSTEM." -ForegroundColor Green

        Set-Acl -Path $Path -AclObject $acl

        Write-Host "[+] ACLs have been successfully applied to the quarantine folder." -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "[-] ACL setting error: $_" -ForegroundColor Red
        return $false
    }
}



    

function Test-Quarantine {
    param (
        [string]$Path
    )

    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        return $false
    }

    $TestFile = Join-Path -Path $Path -ChildPath "test_quarantine.txt"

    try {
        # Tworzenie pliku testowego
        "test" | Out-File -Encoding UTF8 -FilePath $TestFile -ErrorAction Stop

        # Próba odczytu
        $null = Get-Content $TestFile -ErrorAction Stop

        # Jeśli odczyt się udał — test nie zaliczony
        Remove-Item -Path $TestFile -Force -ErrorAction SilentlyContinue
        return $false
    }
    catch {
        # Odczyt nieudany — test zaliczony
        return $true
    }
}
