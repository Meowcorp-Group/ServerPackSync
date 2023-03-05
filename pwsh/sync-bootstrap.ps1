#!/usr/bin/env pwsh
# ServerPackSync bootstrap

if ($env:SYNC_DEBUG -eq "true") {
	Write-Warning "Debug mode enabled"
	$remoteVerUrl = "http://127.0.0.1:7171/db/sync.json"
	$remoteUrl = "http://127.0.0.1:7171/pwsh/sync.ps1"
} else {
	$remoteVerUrl = "https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/db/sync.json"
	$remoteUrl = "https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/pwsh/sync.ps1"
}

function tover {
    [CmdletBinding()]
    param (
        [string]$version
    )

    $major = $version.Substring(0, 1)
    $minor = $version.Substring(1, 1)
    $patch = $version.Substring(2, 1)

    "$major.$minor.$patch"
}

$syncJsonPath = Join-Path $env:INST_MC_DIR "sync.json"

$remoteVer = (Invoke-RestMethod -Uri $remoteVerUrl).version

if ((Test-Path $syncJsonPath -PathType Leaf) -and ((Get-Content $syncJsonPath -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue).version)) {
    $localVer = (Get-Content $syncJsonPath | ConvertFrom-Json).version
}
else {
    Write-Output "No sync.json found, creating one..."
    $localVer = 0
    $emptyJson = ConvertTo-Json @{version=$localVer}
    $emptyJson | Out-File -Encoding ascii $syncJsonPath
}

if ($localVer -ne $remoteVer) {
    Write-Output "A new version is available: $remoteVer"
    Write-Output "Updating..."
    $localVer = $remoteVer
    Invoke-WebRequest -Uri $remoteUrl -OutFile (Join-Path $env:INST_MC_DIR "sync.ps1")
    $syncJson = Get-Content $syncJsonPath | ConvertFrom-Json
    $syncJson.version = $remoteVer
    $syncJson.version = [int]$syncJson.version
    $syncJson | ConvertTo-Json | Out-File -Encoding ascii $syncJsonPath
}

$localVersionString = tover $localVer
Write-Host "ServerPackSync $localVersionString"

& (Join-Path $env:INST_MC_DIR "sync.ps1") $args