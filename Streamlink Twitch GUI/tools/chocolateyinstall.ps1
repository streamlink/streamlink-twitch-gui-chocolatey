$packageName = 'streamlink-twitch-gui'
$packageVersion = 'v1.8.1'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$installDir = Split-Path -parent $toolsDir
$downloadPath = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/$packageVersion/"

Install-ChocolateyZipPackage `
	-PackageName    $packageName `
	-Url            "$($downloadPath)streamlink-twitch-gui-$packageVersion-win32.zip" `
	-Checksum       "7bbb6b9e4beb0566fa8ce1ac8af82329f87cb3a097ae2bb5e2f7980512704987" `
	-ChecksumType   "sha256" `
	-Url64bit       "$($downloadPath)streamlink-twitch-gui-$packageVersion-win64.zip" `
	-Checksum64     "c3b31ce1cdfdd5c428296820db647f8ebda000f9a73e793d1f3834c0b035fa82" `
	-ChecksumType64 "sha256" `
	-UnzipLocation  $installDir

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutFile = Join-Path $desktop "$packageName.lnk"
$exeFile = Join-Path (Join-Path $installDir $packageName) "$packageName.exe"
Install-ChocolateyShortcut -shortcutFilePath $shortcutFile -targetPath $exeFile
