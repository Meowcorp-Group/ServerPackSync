# $REMOTE_VER_URL="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/db/version.txt"
$REMOTE_VER_URL="file://$HOME/Documents/Projects/ServerPackSync/db/sync.json"

$REMOTE_VER= Invoke-WebRequest -Uri $REMOTE_VER_URL

Write-Output $REMOTE_VER