$packageName = 'streamlink-twitch-gui'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$url = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.1.0/streamlink-twitch-gui-v2.1.0-win32-installer.exe"
$hash = "20c129926d7a454c22a476c7fd2c1630ef2f2b57f9a26442b3dc33aeb2a42c70"
$url64 = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v2.1.0/streamlink-twitch-gui-v2.1.0-win64-installer.exe"
$hash64 = "46af3043cc802db5269fbe327023d545916bd51ca296479147c38f8674809f15"

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
