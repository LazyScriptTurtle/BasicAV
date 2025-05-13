function Import-BasicAVConfig {
    param (
        [string]$Path = ".\config.json"
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
        return $array | ForEach-Object {
            $expanded = ($_ -replace '\$env:([a-zA-Z_][a-zA-Z0-9_]*)', {
                param($match)
                [Environment]::GetEnvironmentVariable($match.Groups[1].Value)
            })

            [Environment]::ExpandEnvironmentVariables($expanded)
        }
    }

    if ($config.FileHoneypot.TargetFolders) {
        $config.FileHoneypot.TargetFolders = Expand-EnvInArray $config.FileHoneypot.TargetFolders
    }
    if ($config.Scan.Custom) {
        $config.Scan.Custom = Expand-EnvInArray $config.Scan.Custom
    }

    Write-Host "[+] Configuration loaded correctly" -ForegroundColor Green
    return $config
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