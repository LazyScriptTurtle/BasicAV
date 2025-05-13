
function Import-BasicAVModules {

    try {
        $AllModule = Get-ChildItem -Path ".\Modules\" -Recurse -Filter "*.psm1" 
        foreach ( $Module in $AllModule) {
            Write-Host "[/] Module import $($Module.FullName) $Module ... " -ForegroundColor Cyan
            $ModulePath = $Module.FullName  
            Import-Module $ModulePath -Force -Global
            $loaded = Get-Module | Where-Object { $_.Path -eq $Module.FullName }
            if ($null -ne $loaded) {
                Write-Host "[+] Module $($Module.FullName) was imported. " -ForegroundColor Green 
            }
            else {
                Write-Host "[-] Error module $($Module.FullName) was not imported correctly" -ForegroundColor Red
            }
        }

    }
    catch {
        Write-Host "[-] Listing Module problem Error: $_ " -ForegroundColor Red
    }

}

function Start-BasicAV {
    Write-Host "BasicAV running ..." -ForegroundColor Cyan
    Start-Sleep -Seconds 2

    Write-Host "Configure modules ..." -ForegroundColor Cyan
    Import-BasicAVModules
    Start-Sleep -Seconds 1

    Write-Host "Checking Administrator Privileges ..." -ForegroundColor Cyan
    $CheckPriv = Test-Administrator
    Start-Sleep -Seconds 1

    Write-Host "Importing configuration ..." -ForegroundColor Cyan
    $Global:Config = Import-BasicAVConfig -Path ".\config.json"
    if (-not $Config) {
        Write-Host "[-] Configuration import failed." -ForegroundColor Red
        exit
    }
    # Write-Host "DEBUG: Quarantine path is '$($Config.General.QuarantinePath)'" -ForegroundColor Yellow
    # if (-not (Test-Path -Path $Config.General.QuarantinePath)) {
    #     New-Item -ItemType Directory -Path $Config.General.QuarantinePath -Force | Out-Null
    # }

    Start-Sleep -Seconds 1
    Write-Host "Validating Configuration ..." -ForegroundColor Cyan
    # Configuration-Validate
    Start-Sleep -Seconds 1

    Write-Host "Configuring Quarantine Folder ..." -ForegroundColor Cyan
    if ($CheckPriv -eq $true) {
        $QuarantinePath = $Config.General.QuarantinePath
        if (-not $QuarantinePath) {
            Write-Host "[-] Quarantine path missing in config." -ForegroundColor Red
            exit
        }

        New-QuarantineFolder -Path $QuarantinePath
        if (Test-Quarantine -Path $QuarantinePath) {
            Write-Host "[+] Quarantine has been configured correctly" -ForegroundColor Green
        }
        else {
            Write-Host "[-] Quarantine was not configured correctly" -ForegroundColor Red
            exit
        }
    }
    else {
        Write-Host "[-] Insufficient permissions, please run the program again as Administrator " -ForegroundColor Red
        exit
    }

    Write-Host ""
    Write-Host "Press 'Enter' to start menu " -ForegroundColor Blue -NoNewline
    $Interact = Read-Host
    if ($Interact -ne $null) {
        Get-MainMenu
    }
    else {
        Write-Host "[-] Error: unexpected value"
    }
}
