# Universal packwiz installer/sync for server or client.
# by IgnasSar
#
# Usage:
#   .\install-mods.ps1 server <branch>   # installs into current directory
#   .\install-mods.ps1 client <branch>   # installs into %appdata%\.minecraft
#
# Example:
#   .\install-mods.ps1 client forge-26.2

param(
    [Parameter(Mandatory=$true)][string]$Side,
    [Parameter(Mandatory=$true)][string]$Branch
)

$ErrorActionPreference = "Stop"

$Repo = "ignassar11/minecraft-forge"

if ($Side -ne "server" -and $Side -ne "client") {
    Write-Host "Error: side must be 'server' or 'client', got '$Side'"
    exit 1
}

if ($Side -eq "server") {
    $TargetDir = (Get-Location).Path
} else {
    $TargetDir = Join-Path $env:APPDATA ".minecraft"
}

$PackUrl = "https://raw.githubusercontent.com/$Repo/$Branch/pack.toml"
$BootstrapJar = Join-Path $TargetDir "packwiz-installer-bootstrap.jar"

Write-Host "Side: $Side"
Write-Host "Branch: $Branch"
Write-Host "Target: $TargetDir"

Write-Host "Checking pack.toml exists on branch '$Branch'..."
try {
    Invoke-WebRequest -Uri $PackUrl -Method Head -UseBasicParsing | Out-Null
} catch {
    Write-Host "Error: no pack.toml found on branch '$Branch'. Check the branch name."
    exit 1
}

if (Test-Path $BootstrapJar) {
    Write-Host "Bootstrap installer already present, skipping download."
} else {
    Write-Host "Downloading packwiz-installer-bootstrap.jar..."
    Invoke-WebRequest -Uri "https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar" -OutFile $BootstrapJar
}

if ($Side -eq "client") {
    Write-Host "Clearing old mods and install state..."
    Remove-Item -Path (Join-Path $TargetDir "mods") -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path (Join-Path $TargetDir "packwiz.json") -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "Server mode: leaving mods\ in place (this folder is also the packwiz source)."
}

Write-Host "Installing mods ($Side)..."
Push-Location $TargetDir
java -jar $BootstrapJar -s $Side $PackUrl
Pop-Location

Write-Host "Done. Mods for branch '$Branch' ($Side) are in $TargetDir\mods"
