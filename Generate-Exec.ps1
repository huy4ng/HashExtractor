# Write The IP After the Script in the Command Line
$template = Get-Content '.\DoTheThing-Template.ps1' | Out-String
Remove-Item '.\DoTheThing.ps1'
('$ip = ' + "'" + $args[0] + "'" + $template) | Set-Content -Encoding utf8 '.\DoTheThing.ps1'
start-process git-bash
Write-Host "git add 'DoTheThing.ps1';git commit -m 'Create DoTheThing.ps1';git push"