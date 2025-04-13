function Import-BasicAVConfig {
    param (
        [string]$Path
    )

    if (-Not (Test-Path -Path $Path)) {
        Write-Host "[-] Error: Configuration file does not exist." -ForegroundColor Red
        return $null
    }

    try {
        $config = Get-Content -Raw -Path $Path | ConvertFrom-Json
    }
    catch {
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
            return
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
        return $true
    }
}