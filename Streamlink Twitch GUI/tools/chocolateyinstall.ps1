$packageName = 'streamlink-twitch-gui'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$url = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.5.3/streamlink-twitch-gui-v2.5.3-win32-installer.exe"
$hash = "9cd8194facde5ae53c0bcdddc0702f7a644815bd068a07c2da44684d7139ca8e"
$url64 = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.5.3/streamlink-twitch-gui-v2.5.3-win64-installer.exe"
$hash64 = "4dc4a0652831ca28ebcf67a5ca8c4901a316aa285996ed5eb0a28614ebd1837e"

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
