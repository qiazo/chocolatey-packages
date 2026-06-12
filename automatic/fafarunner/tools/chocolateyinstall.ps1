
$ErrorActionPreference = 'Stop'

$url64         = 'https://github.com/fafarunner/fafarunner/releases/download/v3.1.1.394/fafarunner-3.1.1.394-windows-setup-x64.exe'
$urlArm64      = 'https://github.com/fafarunner/fafarunner/releases/download/v3.1.1.394/fafarunner-3.1.1.394-windows-setup-arm64.exe'
$checksum64    = 'ae583fc496b107331cb75d78f41e4947f599fd63efd53f961d59d2ebd75971f9'
$checksumArm64 = 'ca897099460edede2c453308516b55692fa50c3fb3b3c48f25e7c9b04e8ca5db'

# OS/CPU
$osIs64  = [Environment]::Is64BitOperatingSystem
$onArm64 = ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64')

if (($env:ChocolateyForceX86 -eq 'true')) {
    throw "No 32-bit installer is published for version $version (force-x86 set)."
} elseif ($onArm64) {
    $selectedUrl64      = $urlArm64
    $selectedChecksum64 = $checksumArm64
} elseif ($osIs64) {
    $selectedUrl64      = $url64
    $selectedChecksum64 = $checksum64
} else {
    throw "No 32-bit installer is published for version $version."
}

if (-not $selectedChecksum64 -or ($selectedChecksum64 -notmatch '^[0-9A-Fa-f]{64}$')) {
    throw "Missing or invalid sha256 checksum format for $selectedUrl64"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  url64bit      = $selectedUrl64

  softwareName  = 'fafarunner*'

  checksum64    = $selectedChecksum64
  checksumType64= 'sha256'

  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
