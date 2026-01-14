param (
  [string]$CurrentVersionLong,
  [string]$VimRuntime,
  [switch]$Checkonly,
  [string]$Sessionfile
)

$ErrorActionPreference = "Stop"

# 1. Retrieve the latest release tag from GitHub API
$releaseJson = Invoke-WebRequest -Uri "https://api.github.com/repos/vim/vim-win32-installer/releases/latest" -UseBasicParsing | ConvertFrom-Json
$latestTag = $releaseJson.tag_name

function Convert-TagToVersionLong($tag) {
  if ($tag -match '^v(\d+)\.(\d+)\.(\d+)$') {
    $major = "{0:D2}" -f [int]$matches[1]
    $minor = "{0:D2}" -f [int]$matches[2]
    $patch = "{0:D2}" -f [int]$matches[3]
    return [int]($major + $minor + $patch)
  } else {
    throw "Tag name format unexpected: $tag"
  }
}

$latestVersionLong = Convert-TagToVersionLong $latestTag
$currentVersionLongInt = [int]$CurrentVersionLong

# Exit if current version is up-to-date or newer
if ($currentVersionLongInt -ge $latestVersionLong) {
  Write-Host "Already up to date: current $CurrentVersionLong / latest $latestVersionLong"
  exit 0
} else {
  Write-Host "A new version is available: current $CurrentVersionLong -> latest $latestVersionLong"
}

if ($Checkonly) {
  exit 0
}

# 2. Detect running Vim process and terminate it, remember executable name
$vimProcesses = Get-Process -Name vim, gvim -ErrorAction SilentlyContinue
if (-not $vimProcesses) {
  Write-Host "No running Vim process found."
  $exeToStart = "gvim.exe" # default fallback
} else {
  # Take the first found process and get the executable name
  $process = $vimProcesses | Select-Object -First 1
  Stop-Process -Id $process.Id -Force
  $exeToStart = $process.ProcessName + ".exe" # either vim.exe or gvim.exe
  Write-Host "Terminated running process $exeToStart"
}

# 3. Download and extract the latest 64-bit Vim ZIP archive
$downloadFolder = "$env:TEMP\vim_latest"
$tempExtract = Join-Path $downloadFolder "temp_extract"

New-Item -ItemType Directory -Path $downloadFolder -Force | Out-Null
New-Item -ItemType Directory -Path $tempExtract -Force | Out-Null

$asset = $releaseJson.assets | Where-Object { $_.name -like "*x64.zip" } | Select-Object -First 1
if (-not $asset) {
  Write-Error "64-bit zip archive not found."
  exit 1
}

$zipFilePath = Join-Path $downloadFolder $asset.name
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipFilePath

Write-Host "Extracting archive to $tempExtract ..."
Expand-Archive -Path $zipFilePath -DestinationPath $tempExtract -Force

$prevDir = $VimRuntime + '_prev'
if (Test-Path $prevDir) {
  Write-Host "Removing previous backup folder: $prevDir"
  Remove-Item -Path $prevDir -Recurse -Force
}
if (Test-Path $VimRuntime) {
  Write-Host "Renaming $VimRuntime to backup folder: $prevDir"
  Move-Item $VimRuntime $prevDir
}

$majorMinor = ($latestTag.Replace('v', '').Split('.'))[0..1] -join ''
$internalPath = Join-Path $tempExtract ('vim\vim' + $majorMinor)
Write-Host "Renaming $internalPath to $VimRuntime"
Move-Item $internalPath $VimRuntime

Write-Host "Removing temporary folder: $downloadFolder"
Remove-Item -Path $downloadFolder -Recurse -Force

# 4. Restart the same Vim executable that was previously running
$restoreSession = ''
if (Test-Path $SessionFile) {
  $restoreSEssion = "-S $SessionFile -c `"silent !del $SessionFile 2>nul`" -c `"redraw!`""
}
Write-Host "Restarting $exeToStart ..."
Start-Process -FilePath $VimRuntime\$exeToStart $restoreSession

Write-Host "Update completed."

