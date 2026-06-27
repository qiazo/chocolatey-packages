
$ErrorActionPreference = 'Stop'
$url64         = 'https://github.com/fafarunner/fafarunner/releases/download/v3.2.0.395/fafarunner-3.2.0.395-windows-setup-x64.exe'
$urlArm64      = 'https://github.com/fafarunner/fafarunner/releases/download/v3.2.0.395/fafarunner-3.2.0.395-windows-setup-arm64.exe'
$checksum64    = 'a851b595d582440fe8f214380ca7ba2328cea0ed85b3906bb8365f1c6f78c752'
$checksumArm64 = '3a47067d96dd164b80d5babf6059202ff5642470b67a55b7f0293a0a6df3357a'

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

  softwareName  = 'fafarunner*'

  checksum64    = $selectedChecksum64
  checksumType64= 'sha256'

  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
