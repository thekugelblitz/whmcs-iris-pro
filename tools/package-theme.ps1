$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$themeFolder = Join-Path $projectRoot 'templates\templates\Iris Pro'
$outputFolder = Join-Path $projectRoot 'dist'
if (-not (Test-Path -LiteralPath (Join-Path $themeFolder 'header.tpl'))) {
    throw 'Iris Pro theme is missing.'
}
New-Item -ItemType Directory -Path $outputFolder -Force | Out-Null
$archiveFile = Join-Path $outputFolder 'whmcs-iris-pro.zip'
Compress-Archive -LiteralPath $themeFolder -DestinationPath $archiveFile -Force
Write-Output "Created $archiveFile. Extract into your WHMCS admin templates directory."
