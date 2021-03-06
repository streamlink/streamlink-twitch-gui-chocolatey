$packageName = 'streamlink-twitch-gui'
$packageVersion = 'v1.11.0'
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
	-Checksum       "FBBE1DF4C7880387088BD6ED783F6F85DE4EC566EADA0E93222416E799CB75E4" `
	-ChecksumType   "sha256" `
	-Url64bit       "$($downloadPath)streamlink-twitch-gui-$packageVersion-win64.zip" `
	-Checksum64     "D60E6355BDF6B916AD8BFDC0607D79005CC860DA530A3F7129A05D3F7538F294" `
	-ChecksumType64 "sha256" `
	-UnzipLocation  $installDir

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutFile = Join-Path $desktop "$packageName.lnk"
$exeFile = Join-Path (Join-Path $installDir $packageName) "$packageName.exe"
Install-ChocolateyShortcut -shortcutFilePath $shortcutFile -targetPath $exeFile
