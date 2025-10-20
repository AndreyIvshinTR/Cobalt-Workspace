function Unzip-Program {
    param([string]$Path, [string]$Version)

    $zipPath = "$PSScriptRoot\Programs\$Path\$Version.zip"
    Join-BinaryFiles "$zipPath.shard_*" $zipPath
    Expand-Archive $zipPath -DestinationPath "$PSScriptRoot\Programs\$Path" -Force
    Remove-Item $zipPath -Force
    Remove-Item "$zipPath.shard_0*" -Force
}

﻿function Join-BinaryFiles {
    param([string]$Pattern, [string]$OutputFile)

    $shards = Get-ChildItem $Pattern | Sort-Object Name
    $output = [System.IO.File]::OpenWrite($OutputFile)

    foreach ($shard in $shards) {
        $bytes = [System.IO.File]::ReadAllBytes($shard.FullName)
        $output.Write($bytes, 0, $bytes.Length)
    }

    $output.Close()
}

$ErrorActionPreference = "Stop"

Unzip-Program "JDK" "17.0.16-amzn"
Unzip-Program "JDK" "17.0.16-amzn-fips"
Unzip-Program "Ant" "1.10.15"
Unzip-Program "Maven" "3.9.11"
Unzip-Program "Gradle" "9.1.0"
Unzip-Program "Tomcat" "10.1.48"
Unzip-Program "Tomcat" "10.1.48-fips"
