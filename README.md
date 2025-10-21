# Cobalt Workspace
Migrate from `Eclipse` to `Intellij` with this unified java environment
___
#### This project requires:
- PowerShell `7+`
#### This project provides:
- JDK `17.0.16-amzn`, `17.0.16-amzn-fips`
- Ant `1.10.15`
- Maven `3.9.11`
- Gradle `9.1.0`
- Tomcat `10.1.48`, `10.1.48-fips`

#### This project doesn't provide:
- GIT with Commit Signing
- Python with Cloud tool
- Docker
___
### Install
Install this project in your `home` directory and run `Unzip.ps1` to unpack programs:
```powershell
cd $env:HOME
git clone https://github.com/AndreyIvshinTR/Cobalt-Workspace.git CW
.\CW\Unzip.ps1
```
___
### Configure
In the same folder create `CW.ps1` script to add your own extensions to the workspace, 
such as artifactory credentials or Intellij cli shortcut:
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
___
### Usage
This workspace is activated on demand via dot-sourcing `Activate.ps1` that overrides 
java-related environment variables for current terminal session. Launched from such 
terminal `Intellij` inherits these overridden variables, allowing every developer 
to have identical projects setup:
```powershell
. $env:HOME\CW\Acticate.ps1
cd .\Projects\wdp\
gradle cw-install
idea .
```
> Configure Intellij to use provided JDK and local Gradle installation instead of wrapper
___
### Gradle
The essence of the migration is `build.gradle` that provides 3 things:
- Intellij Support - Cobalt Module can be imported as Gradle project
- Ant Interop - regrouped ant goals bound to gradle default task with cache and state management
- Local Tomcat deployment via gradle tasks

Examples:
- [Web Debugger Persistence](https://github.com/tr/cobalt_WebDebuggerPersistence/blob/feat/cw/build.gradle)

This approach allows spending no time for IDE and environment configuration allowing developers save the configuration as the code and get to the project immediately
___
### FIPS
Dot-source `FIPS.ps1` in the already activated workspace to use FIPS-compliant JDK and Tomcat:
```powershell
. $env:HOME\CW\Acticate.ps1
. $env:HOME\CW\FIPS.ps1
```
___
