function Zip-Program {
    param([string]$Path, [string]$Version)

    $folderPath = "$PSScriptRoot\Programs\$Path\$Version"
    $zipPath = "$PSScriptRoot\Programs\$Path\$Version.zip"

    Compress-Archive -Path $folderPath -DestinationPath $zipPath -Force
    Remove-Item $folderPath -Recurse -Force
    Split-File $zipPath "$zipPath.shard_" 50MB
    Remove-Item $zipPath -Force
}

function Split-File {
    param([string]$InputFile, [string]$OutputPrefix, [long]$ChunkSize)

    $fileStream = [System.IO.File]::OpenRead($InputFile)
    $buffer = New-Object byte[] $ChunkSize
    $chunkIndex = 0

    while ($bytesRead = $fileStream.Read($buffer, 0, $buffer.Length)) {
        $outputFile = "{0}{1:D2}" -f $OutputPrefix, $chunkIndex
        [System.IO.File]::WriteAllBytes($outputFile, $buffer[0..($bytesRead - 1)])
        $chunkIndex++
    }

    $fileStream.Close()
}

$ErrorActionPreference = "Stop"

Zip-Program "JDK" "17.0.16-amzn"
Zip-Program "JDK" "17.0.16-amzn-fips"
Zip-Program "Ant" "1.10.15"
Zip-Program "Maven" "3.9.11"
Zip-Program "Gradle" "9.1.0"
Zip-Program "Tomcat" "10.1.48"
Zip-Program "Tomcat" "10.1.48-fips"
