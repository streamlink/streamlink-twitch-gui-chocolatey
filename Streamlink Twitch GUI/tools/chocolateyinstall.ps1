$packageName = 'streamlink-twitch-gui'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$url = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.5.2/streamlink-twitch-gui-v2.5.2-win32-installer.exe"
$hash = "cffe6e5fbc7c615905b24d9dfd45b2a15dc58295000c90d68388af82fd11b995"
$url64 = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.5.2/streamlink-twitch-gui-v2.5.2-win64-installer.exe"
$hash64 = "05805fc009dd5532ff210256aa9190aa7b2c4da196dc3404dd083a8baf571643"

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
