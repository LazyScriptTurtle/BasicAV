function Import-BasicAVConfig {
    param (
        [string]$ConfigPath = ".\config.json"
    )

    if (-Not (Test-Path -Path $ConfigPath)) {
        Write-Host "[-] Error: Configuration file does not exist." -ForegroundColor Red
        return $null
    }

    try {
        $config = Get-Content -Raw -Path $ConfigPath | ConvertFrom-Json
    } catch {
        Write-Host "[-] Error: Failed to read or parse the JSON file." -ForegroundColor Red
        return $null
    }


    function Expand-EnvInArray($array) {
        return $array | ForEach-Object { [Environment]::ExpandEnvironmentVariables($_) }
    }


    if ($config.RealTimeMonitor.WatchedPaths) {
        $config.RealTimeMonitor.WatchedPaths = Expand-EnvInArray $config.RealTimeMonitor.WatchedPaths
    }
    if ($config.FileHoneypot.TargetFolders) {
        $config.FileHoneypot.TargetFolders = Expand-EnvInArray $config.FileHoneypot.TargetFolders
    }
    Write-Host "[+] Configuration loaded correctly " -ForegroundColor Green
}

function Test-Administrator  
{  
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if($isAdmin -eq $false)
    {
        Write-Host "[-] Strongly recommend running the program as Administrator. " -ForegroundColor Red
        Write-Host "[!] Do you want to continue Y/N (Yes/No) ? " -ForegroundColor Blue -NoNewline
        do {
        $Choice = Read-Host
        if($Choice.ToUpper() -eq "Y")
        {
            continue
        }
        elseif ($Choice.ToUpper() -eq "N" )
        {
            exit
        }
        else
        {
            Write-Host "[!] Error: Wrong Value " -ForegroundColor Yellow
            Write-Host "[!] Do you want to continue Y/N (Yes/No) ? " -ForegroundColor Blue -NoNewline
        }
    }
    while ($true)
        
    }
    else {
        Write-Host "[+] Priviledge OK " -ForegroundColor Green
    }
}

function Import-BasicAVModules {

    try {
    $AllModule = Get-ChildItem -Path ".\Modules\" -Recurse -Filter "*.psm1" 
    foreach ( $Module in $AllModule)
    {
        Write-Host "[/] Module import $($Module.FullName) $Module ... " -ForegroundColor Cyan
        $ModulePath = $Module.FullName  
        Import-Module $ModulePath -Force -Global
        $loaded = Get-Module | Where-Object { $_.Path -eq $Module.FullName }
        if ($null -ne $loaded)
        {
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

    Write-Host "BasicAV running ..." -ForegroundColor Green
    sleep -Seconds 3
    Write-Host "Chceking Administrators Priviledges ..." -ForegroundColor Green
    Test-Administrator
    Sleep -Seconds 1
    Write-Host "Importing configuration ..." -ForegroundColor Green
    Import-BasicAVConfig
    sleep -Seconds 1
    Write-Host "Configure modules ..." -ForegroundColor Green
    Import-BasicAVModules
    sleep -Seconds 1
    Write-Host ""
    Write-Host "Everything ready " -ForegroundColor Green
    Write-Host "Press key to start menu " -ForegroundColor Blue -NoNewline
    $Interact = Read-Host 
    $Interact
    if ($Interact -ne $null)
    {
        Get-MainMenu
    }
    else {
        Write-Host
        "[-] Error: unexpected value "
    }
}