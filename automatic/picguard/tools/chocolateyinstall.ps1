
$ErrorActionPreference = 'Stop'
$url64         = 'https://github.com/picguard/picguard/releases/download/v5.6.0.478/picguard-5.6.0.478-windows-setup-x64.exe'
$urlArm64      = 'https://github.com/picguard/picguard/releases/download/v5.6.0.478/picguard-5.6.0.478-windows-setup-arm64.exe'
$checksum64    = '347d8ce3c045f7ea798091da4c49153f8abbd3d058f80ff932f2a8575b35a8fa'
$checksumArm64 = 'afbb6d2a811e5eac88d643920b92b32f59553f983eeb5f224e984192649669ab'

# OS/CPU
$osIs64  = [Environment]::Is64BitOperatingSystem
$onArm64 = ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -eq 'ARM64')

if (($env:ChocolateyForceX86 -eq 'true')) {
    throw "No 32-bit installer is published (force-x86 set)."
} elseif ($onArm64) {
    $selectedUrl64      = $urlArm64
    $selectedChecksum64 = $checksumArm64
} elseif ($osIs64) {
    $selectedUrl64      = $url64
    $selectedChecksum64 = $checksum64
} else {
    throw "No 32-bit installer is published."
}

if (-not $selectedChecksum64 -or ($selectedChecksum64 -notmatch '^[0-9A-Fa-f]{64}$')) {
    throw "Missing or invalid sha256 checksum format for $selectedUrl64"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  url64bit      = $selectedUrl64

  softwareName  = 'picguard*'

  checksum64    = $selectedChecksum64
  checksumType64= 'sha256'

  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
