function Invoke-Transmission {
    Param (
        [Parameter(Position = 0, Mandatory=$true, ValueFromPipeline)]
        [string]
        $Message,

        [Parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $ip,

        [Parameter(Position = 2)]
        [ValidateNotNullOrEmpty()]
        [int]
        $port = 9000
    )
    do{
        try   { $client = New-Object System.Net.Sockets.TcpClient $ip, $port } 
        catch { Sleep 1 }
    } while (-not $client.Connected)
    $stream = $client.GetStream()
    $data = [text.Encoding]::Ascii.GetBytes($Message)
    $stream.Write($data,0,$data.length)
    $client.Close()
    $client.Dispose()
}