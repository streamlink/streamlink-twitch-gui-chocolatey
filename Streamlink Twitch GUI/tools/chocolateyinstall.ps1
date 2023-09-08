$packageName = 'streamlink-twitch-gui'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$url = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.4.1/streamlink-twitch-gui-v2.4.1-win32-installer.exe"
$hash = "f6cf181780571719fc8eb03492f78352f6bde0fad94f3ed43c6c44fce4745cc6"
$url64 = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.4.1/streamlink-twitch-gui-v2.4.1-win64-installer.exe"
$hash64 = "bac4831d0b1104e63c98cf1815619acfaf9caf3184cc76f4072a48e25039ad79"

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
