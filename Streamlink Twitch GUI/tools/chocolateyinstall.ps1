$packageName = 'streamlink-twitch-gui'
$packageVersion = 'v1.12.0'
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$installDir = Split-Path -parent $toolsDir
$downloadPath = "https://github.com/streamlink/streamlink-twitch-gui/releases/download/$packageVersion/"

New-Item -ItemType directory $installDir\$packageName\ -EA 0 | Out-Null
New-Item -ItemType file $installDir\$packageName\notification_helper.exe.ignore -EA 0 | Out-Null
New-Item -ItemType directory $installDir\$packageName\bin\ -EA 0 | Out-Null
New-Item -ItemType directory $installDir\$packageName\bin\win64\ -EA 0 | Out-Null
New-Item -ItemType file $installDir\$packageName\bin\win64\snoretoast.exe.ignore -EA 0 | Out-Null
New-Item -ItemType directory $installDir\$packageName\bin\win32\ -EA 0 | Out-Null
New-Item -ItemType file $installDir\$packageName\bin\win32\snoretoast.exe.ignore -EA 0 | Out-Null

Install-ChocolateyZipPackage `
	-PackageName    $packageName `
	-Url            "$($downloadPath)streamlink-twitch-gui-$packageVersion-win32.zip" `
	-Checksum       "1f8edbb60178e6910c98a7922cd058b5bb7c29e90b6c9b2dcfd2c7f76c61e476" `
	-ChecksumType   "sha256" `
	-Url64bit       "$($downloadPath)streamlink-twitch-gui-$packageVersion-win64.zip" `
	-Checksum64     "525cdbb61e113857c0d712f8e7179b44db41f1471a11870d3afa30078ab389b2" `
	-ChecksumType64 "sha256" `
	-UnzipLocation  $installDir

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutFile = Join-Path $desktop "$packageName.lnk"
$exeFile = Join-Path (Join-Path $installDir $packageName) "$packageName.exe"
Install-ChocolateyShortcut -shortcutFilePath $shortcutFile -targetPath $exeFile
