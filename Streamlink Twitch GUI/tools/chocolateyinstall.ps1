$packageName = 'streamlink-twitch-gui'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$url = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.2.0/streamlink-twitch-gui-v2.2.0-win32-installer.exe"
$hash = "b5bc5e1ecc20cd097179edd2c9f7879b471e5666710e61e16b8083fa87117677"
$url64 = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.2.0/streamlink-twitch-gui-v2.2.0-win64-installer.exe"
$hash64 = "23e8cd61160700918f0ab656f72148388a5b6e4c2753a227bce92518badab1ce"

$packageArgs = @{
	packageName    = $packageName
	unzipLocation  = $toolsDir
	fileType       = 'exe'
	url            = $url
	checksum       = $hash
	checksumType   = 'sha256'
	url64bit       = $url64
	checksum64     = $hash64
	checksumType64 = 'sha256'

	softwareName   = 'Streamlink Twitch GUI*'


	silentArgs     = '/S'
	validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

# TODO: Remove the old zip package
# For now, lets just remove the desktop icon
$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutFile = Join-Path $desktop "$packageName.lnk"
if (Test-Path $shortcutFile){
    Remove-Item $shortcutFile
}
# and also remove the bin reference
Uninstall-BinFile `
	-Name $packageName
