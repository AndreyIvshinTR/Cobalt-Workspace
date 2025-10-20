# Cobalt Workspace
Migrate from Eclipse to Intellij with this unified java environment

Install:
```powershell
cd $env:HOME
git clone https://github.com/AndreyIvshinTR/Cobalt-Workspace.git CW
.\CW\Unzip.ps1
```

Configure:
```powershell
cd $env:HOME
Set-Content -Path "CW.ps1" -Value @'
$env:ARTIFACTORY_HOST = "tr1.jfrog.io"
$env:ARTIFACTORY_USER = "*******"
$env:ARTIFACTORY_USERNAME = $env:ARTIFACTORY_USER
$env:ARTIFACTORY_TOKEN = "****************************************************************"
$env:ARTIFACTORY_TOKEN_SECRET_NAME = $env:ARTIFACTORY_TOKEN

Set-Alias -Name idea -Value 'C:\Program Files\JetBrains\IntelliJ\bin\idea64.exe' 
'@ -Encoding UTF8
notepad .\CW.ps1
```

Use:
```powershell
. $env:HOME\CW\Acticate.ps1
cd .\Projects\wdp\
idea .
gradle cw-startup
```
