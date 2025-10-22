# Cobalt Workspace
Migrate from `Eclipse` to `Intellij` with this unified java environment
___
### Overview
<img height="200" alt="image" src="https://github.com/user-attachments/assets/1b85e0de-c3aa-4181-85be-7db398ecfc08" />
<img height="200" alt="image" src="https://github.com/user-attachments/assets/3d9711b7-011a-4376-ad8b-41df6880ec1f" />
<br>
<img height="200" alt="image" src="https://github.com/user-attachments/assets/01a03af1-95d1-4d81-a4c2-d69234c4e5f7" />
<img height="200" alt="image" src="https://github.com/user-attachments/assets/1c5c27e7-3779-43e1-9af3-a013b130acd8" />
<br>
<img height="200" alt="image" src="https://github.com/user-attachments/assets/4b96309e-b4b6-4dfa-87b0-0882ce8b80b8" />
<img height="200" alt="image" src="https://github.com/user-attachments/assets/2ead65c0-c70c-4093-b7e3-8420faf9ebc0" />

#### This project requires:
- PowerShell `7+` - see [here](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.5)
#### This project provides:
- JDK `17.0.16-amzn`, `17.0.16-amzn-fips`
- Ant `1.10.15`
- Maven `3.9.11`
- Gradle `9.1.0`
- Tomcat `10.1.48`, `10.1.48-fips`

#### This project doesn't provide:
- `GIT` with `SMIME` - see [here](https://git-scm.com/install/windows) and [here](https://techtoc.thomsonreuters.com/non-functional/security/supply-chain-security/source-code-signing/)
- `Python` with `cloud-tool` - see [here](https://www.python.org/downloads/release/python-3110/) and [here](https://techtoc.thomsonreuters.com/non-functional/cloud-landing-zones/aws-cloud-landing-zones/command-line-access/user_guide/)
- `NPM` - see [here](https://www.freecodecamp.org/news/node-version-manager-nvm-install-guide/)
- `Docker` - see [here](https://podman-desktop.io/downloads/windows) and search for "custom Certificate Authorities" [here](https://podman-desktop.io/docs/proxy) with PEM from [here](https://thomsonreuters.service-now.com/nav_to.do?uri=%2Fkb_view.do%3Fsysparm_article%3DKB0042137) and restart podman machine
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
- [Web Debugger Persistence](https://github.com/tr/cobalt_WebDebuggerPersistence/blob/feat/2242602-fix-entraid-docs/build.gradle)

This approach allows spending no time for IDE and environment configuration allowing developers save the configuration as the code and get to the project immediately
___
### FIPS
Dot-source `FIPS.ps1` in the already activated workspace to use FIPS-compliant JDK and Tomcat:
```powershell
. $env:HOME\CW\FIPS.ps1
```
___
