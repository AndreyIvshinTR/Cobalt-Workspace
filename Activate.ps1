function Setup-JDK {
    $env:JAVA_HOME = Join-Path (Get-Location) "Programs\JDK\17.0.16-amzn"
    $env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
}

function Setup-Ant {
    $env:ANT_HOME = Join-Path (Get-Location) "Programs\Ant\1.10.15"
    $env:PATH = "$env:ANT_HOME\bin;$env:PATH"
}

function Setup-Maven {
    $env:MAVEN_HOME = Join-Path (Get-Location) "Programs\Maven\3.9.11"
    $env:PATH = "$env:MAVEN_HOME\bin;$env:PATH"
}

function Setup-Gradle {
    $env:GRADLE_HOME = Join-Path (Get-Location) "Programs\Gradle\9.1.0"
    $env:PATH = "$env:GRADLE_HOME\bin;$env:PATH"
}

function Setup-Tomcat {
    $env:CATALINA_HOME = Join-Path (Get-Location) "Programs\Tomcat\10.1.48"
    $env:PATH = "$env:CATALINA_HOME\bin;$env:PATH"
}

function Setup-Prompt {
    $script:lastId = -1
    function global:prompt {
        $h = Get-History -Count 1 -ErrorAction SilentlyContinue
        $id = if ($h) { $h.Id } else { -1 }
        if ($id -eq $script:lastId) {
            $currentTop = [Console]::CursorTop
            if ($currentTop -gt 0) {
                [Console]::SetCursorPosition(0, $currentTop - 1)
                Write-Host "│" -NoNewline -ForegroundColor Blue
                $width = [Console]::WindowWidth
                Write-Host (" " * ($width - 1))
                [Console]::SetCursorPosition(0, $currentTop)
            }
            Write-Host "╰─>" -NoNewline -ForegroundColor Blue
            return " "
        }
        $script:lastId = $id
        $p = (Get-Location).Path -replace [regex]::Escape($HOME), "~"
        $b = ""
        if (Get-Command git -ErrorAction SilentlyContinue) {
            $br = git branch --show-current 2>$null
            if ($br) { $b = " ($br)" }
        }
        $t = ""
        if ($h -and $h.CommandLine.Trim()) {
            $d = ($h.EndExecutionTime - $h.StartExecutionTime).TotalSeconds
            if ($d -gt 0.1) { $t = " [{0:F1}s]" -f $d }
        }
        $script:cached = {
            Write-Host "╭─[Cobalt Workspace] " -NoNewline -ForegroundColor Blue
            Write-Host $p -NoNewline -ForegroundColor White
            Write-Host $b -NoNewline -ForegroundColor Yellow
            Write-Host $t -ForegroundColor DarkGray
            Write-Host "╰─>" -NoNewline -ForegroundColor Blue
        }.GetNewClosure()
        & $script:cached
        return " "
    }
}

$ErrorActionPreference = "Stop"
Push-Location (Split-Path $PSCommandPath -Parent)

try {
    Setup-JDK
    Setup-Ant
    Setup-Maven
    Setup-Gradle
    Setup-Tomcat
    Setup-Prompt

    $extension = Join-Path (Split-Path $PSScriptRoot -Parent) "CW.ps1"
    if (Test-Path $extension) {
        . $extension
    }
}
finally {
    Pop-Location
    $ErrorActionPreference = "Continue"
}
