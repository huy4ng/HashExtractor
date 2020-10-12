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
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()
    $byte = New-Object byte[] 1024
    $bytes = $stream.read($byte, 0, $byte.Length)
    $msg += [text.encoding]::ASCII.GetString( (1..$bytes | ForEach-Object { $byte[$_-1] } ) )
    $listener.Stop()
    $listener.Server.Dispose()
    return $msg
}
Invoke-Reciever