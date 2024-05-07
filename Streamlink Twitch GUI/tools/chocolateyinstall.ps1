$packageName = 'streamlink-twitch-gui'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$url = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.5.1/streamlink-twitch-gui-v2.5.1-win32-installer.exe"
$hash = "8a6abb6fd02db16e1215f33c7a0a0484a6fe164fa7ee049cc14e9f47784e696f"
$url64 = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.5.1/streamlink-twitch-gui-v2.5.1-win64-installer.exe"
$hash64 = "9ee4b3361011f6463aaef2144068e3a6d11d59b567f4b7efdf67da395b9d42dd"

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
