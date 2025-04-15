function Get-MainMenu {
    Start-Sleep -Seconds 2
    Clear-Host

    do {
        Clear-Host
        Write-Host '  //===============================\\ '
        Write-Host ' //  '-NoNewline
        Write-Host '        Basic Antivirus' -ForegroundColor Green -NoNewline
        Write-Host '        \\'
        Write-Host '//===================================\\'
        Write-Host '|| 1. Full Scan      | 6.  X         ||' 
        Write-Host '||                   |               ||'
        Write-Host '|| 2. Custom Scan    | 7.  X         ||' 
        Write-Host '||                   |               ||'
        Write-Host '|| 3. Fast Scan      | 8.  X         ||' 
        Write-Host '||                   |               ||'
        Write-Host '|| 4. Malware Search | 9.  X         ||' 
        Write-Host '||                   |               ||'
        Write-Host '|| 5. Magic Numbers  | 10. Help      ||' 
        Write-Host '||                   |               ||'
        Write-Host '\\===================================//'
        $choice = Read-Host ' Choose your option: '

        switch ($choice) {
            1 {
                Start-ScanWithC -Path .\Modules\FilesScanner.exe
                if (-not (Test-Path -Path .\scan.txt))
                {
                    Write-Host "[-] Error Scan Interrupted " -ForegroundColor Red
                }else{Write-Host "[+] Scan End Successfully "  -ForegroundColor Green
                Pause
            }
                
                
            }
    
            2 {

            }
    
            3 {

            }
    
            4 {

            }

            5 {

            }

            6 {

            }

            7 {

            }

            8 {

            }

            9 {

            }
    
            10 {


            }

            Default {
                Write-Host "Invalid selection, please try again." -ForegroundColor Red
            }
        }
    } while ($true)
}