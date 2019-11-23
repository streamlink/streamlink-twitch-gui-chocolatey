$packageName = 'streamlink-twitch-gui'
$packageVersion = 'v1.9.0'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$installDir = Split-Path -parent $toolsDir
$downloadPath = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/$packageVersion/"

Install-ChocolateyZipPackage `
	-PackageName    $packageName `
	-Url            "$($downloadPath)streamlink-twitch-gui-$packageVersion-win32.zip" `
	-Checksum       "84bec7f3c813a9b49a84d59a83e327b5c6d13be30eba54012009cfd32f823e4a" `
	-ChecksumType   "sha256" `
	-Url64bit       "$($downloadPath)streamlink-twitch-gui-$packageVersion-win64.zip" `
	-Checksum64     "9945397c2ca5e5fbc5a2a5308ab7b6f440564ae3405a0750d193b0bfcf402c77" `
	-ChecksumType64 "sha256" `
	-UnzipLocation  $installDir

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutFile = Join-Path $desktop "$packageName.lnk"
$exeFile = Join-Path (Join-Path $installDir $packageName) "$packageName.exe"
Install-ChocolateyShortcut -shortcutFilePath $shortcutFile -targetPath $exeFile
