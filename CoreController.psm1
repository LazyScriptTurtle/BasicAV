
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
    sleep -Seconds 2
    Write-Host "Configure modules ..." -ForegroundColor Cyan
    Import-BasicAVModules
    sleep -Seconds 1
    Write-Host "Chceking Administrators Priviledges ..." -ForegroundColor Cyan
    $CheckPriv = Test-Administrator
    Sleep -Seconds 1
    Write-Host "Importing configuration ..." -ForegroundColor Cyan
    Import-BasicAVConfig -Path ".\config.json"
    sleep -Seconds 1
    Write-Host "Validate Configuration ..." -ForegroundColor Cyan
   # Configuration-Validate
    sleep -Seconds 1
    Write-Host "Configure Quarantine Folder ..." -ForegroundColor Cyan
    if ($CheckPriv -ne $true)
    {
        Write-Host "[-] Insufficient permissions, please run the program again as Administrator " -ForegroundColor Red
        exit
    }else {
        New-QuarantineFolder -Path ".\Quarantine"
        sleep -Seconds 1
    }
    Write-Host ""
    Write-Host "Press 'Enter' to start menu " -ForegroundColor Blue -NoNewline
    $Interact = Read-Host 
    $Interact
    if ($Interact -ne $null) {
        Get-MainMenu
    }
    else {
        Write-Host
        "[-] Error: unexpected value "
    }
}