# Write The IP After the Script in the Command Line
$template = Get-Content '.\DoTheThing.ps1' | Out-String
$result = '$ip = ' + $args[0] "`n" + $template
Remove-Item '.\DoTheThing.ps1'
Out-file '.\DoTheThing.ps1' $result
