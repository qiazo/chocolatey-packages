
$ErrorActionPreference = 'Stop'
$url64         = 'https://github.com/picguard/picguard/releases/download/v5.7.0.479/picguard-5.7.0.479-windows-setup-x64.exe'
$urlArm64      = 'https://github.com/picguard/picguard/releases/download/v5.7.0.479/picguard-5.7.0.479-windows-setup-arm64.exe'
$checksum64    = 'e273008c71287d0bfe80de760773e4316139f13920603e4a200a0740ca7e17e5'
$checksumArm64 = '0afcf74777fee9bc680fc15e1e585a8b8290451f06528be66f462fef34075d9f'

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
