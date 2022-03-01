$packageName = 'streamlink-twitch-gui'
$packageVersion = 'v2.0.0'
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
	-Checksum "ddf865ec7c9885272fb52fb560a16d84328a9594e60211c1dcde1571349541a0" `
	-ChecksumType   "sha256" `
	-Url64bit       "$($downloadPath)streamlink-twitch-gui-$packageVersion-win64.zip" `
	-Checksum64     "75B9CDABEF572CDB3EA61F467443CD9F6C5C463AC87ECF1D0E4DE0123F1D6E5E" `
	-ChecksumType64 "sha256" `
	-UnzipLocation  $installDir

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutFile = Join-Path $desktop "$packageName.lnk"
$exeFile = Join-Path (Join-Path $installDir $packageName) "$packageName.exe"
Install-ChocolateyShortcut -shortcutFilePath $shortcutFile -targetPath $exeFile
