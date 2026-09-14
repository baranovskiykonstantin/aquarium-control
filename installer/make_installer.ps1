# Build an offline Windows installer for aquarium-control.
# Adjust the variables below when building on another machine.

$QtRoot     = "C:\Qt"
$QtVersion  = "6.9.3"
$QtKit      = "mingw_64"
$MingwDir   = "Tools\mingw1310_64"
$IfwVersion = "4.9"

$ErrorActionPreference = "Stop"

$InstallerDir = $PSScriptRoot
$ProjectRoot  = Split-Path $InstallerDir -Parent
$BuildDir     = Join-Path $ProjectRoot "build"
$QmlDir       = Join-Path $ProjectRoot "qml"
$ConfigXml    = Join-Path $InstallerDir "config\config.xml"
$PackagesDir  = Join-Path $InstallerDir "packages"
$DataDir      = Join-Path $PackagesDir "aquariumcontrol\data"

$QtBin      = Join-Path $QtRoot "$QtVersion\$QtKit\bin"
$IfwBin     = Join-Path $QtRoot "Tools\QtInstallerFramework\$IfwVersion\bin"
$MingwBin   = Join-Path $QtRoot "$MingwDir\bin"
$Windeployqt   = Join-Path $QtBin "windeployqt.exe"
$BinaryCreator = Join-Path $IfwBin "binarycreator.exe"

function Fail([string]$Message) {
    Write-Host $Message -ForegroundColor Red
    exit 1
}

function Find-ReleaseExe([string]$BuildRoot) {
    $direct = Join-Path $BuildRoot "aquarium-control.exe"
    if (Test-Path $direct) {
        return (Resolve-Path $direct).Path
    }

    $msvcRelease = Join-Path $BuildRoot "Release\aquarium-control.exe"
    if (Test-Path $msvcRelease) {
        return (Resolve-Path $msvcRelease).Path
    }

    $kitRelease = Get-ChildItem -Path $BuildRoot -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like "*Release*" -and $_.Name -notlike "*Debug*" } |
        ForEach-Object { Join-Path $_.FullName "aquarium-control.exe" } |
        Where-Object { Test-Path $_ } |
        Select-Object -First 1
    if ($kitRelease) {
        return (Resolve-Path $kitRelease).Path
    }

    $debugExe = Get-ChildItem -Path $BuildRoot -Recurse -Filter "aquarium-control.exe" -ErrorAction SilentlyContinue |
        Where-Object { $_.DirectoryName -like "*Debug*" } |
        Select-Object -First 1
    if ($debugExe) {
        Fail "Found only a Debug build at '$($debugExe.FullName)'. Build a Release configuration before creating the installer."
    }

    Fail "aquarium-control.exe not found under '$BuildRoot'. Build the application first."
}

if (-not (Test-Path $Windeployqt)) {
    Fail "windeployqt.exe not found at '$Windeployqt'. Check `$QtRoot, `$QtVersion, and `$QtKit."
}
if (-not (Test-Path $BinaryCreator)) {
    Fail "binarycreator.exe not found at '$BinaryCreator'. Check `$QtRoot and `$IfwVersion."
}
if (-not (Test-Path $QmlDir)) {
    Fail "QML directory not found at '$QmlDir'."
}
if (-not (Test-Path $ConfigXml)) {
    Fail "Installer config not found at '$ConfigXml'."
}
if (-not (Test-Path $BuildDir)) {
    Fail "Build directory not found at '$BuildDir'."
}

[xml]$installerConfig = Get-Content -Path $ConfigXml
$AppVersion = $installerConfig.Installer.Version
if ([string]::IsNullOrWhiteSpace($AppVersion)) {
    Fail "Could not read <Version> from '$ConfigXml'."
}

$AppExe = Find-ReleaseExe $BuildDir
$OutputExe = Join-Path $InstallerDir "aquarium-control-$AppVersion-windows_x86_64.exe"

Write-Host "Using executable: $AppExe"
Write-Host "Installer output: $OutputExe"

$pathPrefix = @($QtBin)
if (Test-Path $MingwBin) {
    $pathPrefix += $MingwBin
}
$env:PATH = ($pathPrefix + $env:PATH) -join ";"

$stagingDir = Join-Path ([System.IO.Path]::GetTempPath()) ("aquarium-control-deploy-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $stagingDir | Out-Null

try {
    Copy-Item -Path $AppExe -Destination (Join-Path $stagingDir "aquarium-control.exe")

    $stagedExe = Join-Path $stagingDir "aquarium-control.exe"
    & $Windeployqt `
        --release `
        --compiler-runtime `
        --qmldir $QmlDir `
        --translations en,ru,uk `
        --skip-plugin-types qmltooling `
        --dir $stagingDir `
        $stagedExe
    if ($LASTEXITCODE -ne 0) {
        Fail "windeployqt failed with exit code $LASTEXITCODE."
    }

    if (Test-Path $DataDir) {
        Remove-Item -Path $DataDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $DataDir | Out-Null
    Copy-Item -Path (Join-Path $stagingDir "*") -Destination $DataDir -Recurse

    & $BinaryCreator `
        --offline-only `
        --config $ConfigXml `
        --packages $PackagesDir `
        $OutputExe
    if ($LASTEXITCODE -ne 0) {
        Fail "binarycreator failed with exit code $LASTEXITCODE."
    }
}
finally {
    if (Test-Path $stagingDir) {
        Remove-Item -Path $stagingDir -Recurse -Force
    }
}

Write-Host "Created $OutputExe"
