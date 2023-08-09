$packageName = 'streamlink-twitch-gui'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$url = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.3.0/streamlink-twitch-gui-v2.3.0-win32-installer.exe"
$hash = "d54de84ce44126d5dad06e48b256c4a071143175a36087dac1e4ed2bcaa4c566"
$url64 = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.3.0/streamlink-twitch-gui-v2.3.0-win64-installer.exe"
$hash64 = "90d597fb9e5938155a63b44ee5cc90f5d7cf1fcb8d8929082e689b1128489dfe"

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
