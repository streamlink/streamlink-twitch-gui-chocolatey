$packageName = 'streamlink-twitch-gui'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = "$(Split-Path -parent $toolsDir)"
$extractDir = "$(Split-Path -parent $installDir)"

Install-ChocolateyZipPackage `
	-PackageName    $packageName `
	-Url            "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v1.0.1/streamlink-twitch-gui-v1.0.1-win32.zip" `
	-Checksum       "05ce3f496b59c3a71b626c008e311a17f1bc52d0e5aa87873e0d6bc66ef9321a" `
	-ChecksumType   "sha256" `
	-Url64bit       "https://github.com/streamlink/streamlink-twitch-gui/releases/download/v1.0.1/streamlink-twitch-gui-v1.0.1-win64.zip" `
	-Checksum64     "9b0d425c98911344cefed1ab31bddc7f52acad0200b4e320d25ebf7400c31f5c" `
	-ChecksumType64 "sha256" `
	-UnzipLocation  "$extractDir"

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutFile = Join-Path $desktop "$($packageName).lnk"
$exeFile = Join-Path $installDir "$($packageName).exe"
Install-ChocolateyShortcut -shortcutFilePath $shortcutFile -targetPath $exeFile
