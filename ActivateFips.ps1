function Setup-JDK-FIPS {
    $env:JAVA_HOME = Join-Path (Get-Location) "Programs\JDK\17.0.16-amzn-fips"
    $env:JAVA_TOOL_OPTIONS="$env:JAVA_TOOL_OPTIONS --module-path=$env:JAVA_HOME\lib\security\bouncycastle -Djavax.net.ssl.trustStorePassword=bouncycastle"
    $env:AWS_USE_FIPS_ENDPOINT="true"
    $env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
}

function Setup-Tomcat-FIPS {
    $env:CATALINA_HOME = Join-Path (Get-Location) "Programs\Tomcat\10.1.48-fips"
    $env:PATH = "$env:CATALINA_HOME\bin;$env:PATH"
}

function Setup-Prompt-FIPS {
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
            Write-Host "[FIPS] " -NoNewline -ForegroundColor Magenta
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
    . (Join-Path (Split-Path $PSCommandPath -Parent) "Activate.ps1")
    Setup-JDK-FIPS
    Setup-Tomcat-FIPS
    Setup-Prompt-FIPS
}
finally {
    Pop-Location
    $ErrorActionPreference = "Continue"
}
