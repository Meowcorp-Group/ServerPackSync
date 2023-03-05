function tover {
    param (
        [string]$version
    )

    if ($version.Length -lt 3) {
		Write-Host "Error: Version must be at least 3 characters long"
		return
	}
	$major = $version.Substring(0, 1)
	$minor = $version.Substring(1, 1)
	$patch = $version.Substring(2, 1)

    "$major.$minor.$patch"
}

$REMOTE_VER_URL="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/db/version.txt"
$REMOTE="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/sh/sync.sh"

$REMOTE_VER = (Invoke-WebRequest -Uri $REMOTE_VER_URL | ConvertFrom-Json).version
$REMOTE_VER= $REMOTE_VER_DL.version

if (Test-Path "$env:INST_MC_DIR/sync.json" -PathType Leaf) {
    $LOCAL_VER = (Get-Content "$env:INST_MC_DIR/sync.json" | ConvertFrom-Json).version
}
else {
    Write-Output "No sync.json found, creating one..."
    $LOCAL_VER = 0
    $emptyJson = ConvertTo-Json @{version=$LOCAL_VER}
    $emptyJson | Out-File -Encoding ascii "$env:INST_MC_DIR/sync.json"
}

if ($LOCAL_VER -ne $REMOTE_VER) {
    Write-Output "A new version is available: $REMOTE_VER"
    Write-Output "Updating..."
    $LOCAL_VER = $REMOTE_VER
    Invoke-WebRequest -Uri $REMOTE -OutFile "$env:INST_MC_DIR/sync.sh"
    $SYNC_JSON = Get-Content "$env:INST_MC_DIR/sync.json" | ConvertFrom-Json
    $SYNC_JSON.version = $REMOTE_VER
    $SYNC_JSON.version = [int]$SYNC_JSON.version
    $SYNC_JSON | ConvertTo-Json | Out-File -Encoding ascii "$env:INST_MC_DIR/sync.json"
}


$localVersionString = tover $LOCAL_VER
Write-Host "ServerPackSync $localVersionString"

& "$env:INST_MC_DIR/sync.ps1" $args