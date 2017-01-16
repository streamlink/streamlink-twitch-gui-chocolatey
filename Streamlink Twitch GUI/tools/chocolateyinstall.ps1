$packageName = 'streamlink-twitch-gui'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = "$(Split-Path -parent $toolsDir)"
$extractDir = "$(Split-Path -parent $installDir)"
$downloadPath = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v1.1.1/"

Install-ChocolateyZipPackage `
	-PackageName    $packageName `
	-Url            "$($downloadPath)streamlink-twitch-gui-v1.1.1-win32.zip" `
	-Checksum       "D9B597E35BFE946538E0B5741BFD9E043E71ED924DD812F7E59D3703948AAC49" `
	-ChecksumType   "sha256" `
	-Url64bit       "$($downloadPath)streamlink-twitch-gui-v1.1.1-win64.zip" `
	-Checksum64     "C97195DB4453D09D30F9443C084AF3794CA091FF931F2A826327F9F937EBECF7" `
	-ChecksumType64 "sha256" `
	-UnzipLocation  "$extractDir"

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutFile = Join-Path $desktop "$($packageName).lnk"
$exeFile = Join-Path $installDir "$($packageName).exe"
Install-ChocolateyShortcut -shortcutFilePath $shortcutFile -targetPath $exeFile
