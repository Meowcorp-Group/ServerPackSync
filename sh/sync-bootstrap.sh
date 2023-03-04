#!/usr/bin/env bash

# REMOTE_VER_URL="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/db/version.txt"
REMOTE_VER_URL="file://$HOME/Projects/ServerPackSync/db/sync.json"
REMOTE_VER=$(curl -sSL $REMOTE_VER_URL | jq -r ".version")

if [ -f "$INST_MC_DIR/sync.json" ] && cat "$INST_MC_DIR/sync.json" | jq -e 'has("version")' >/dev/null 2>&1; then
	LOCAL_VER=$(cat "$INST_MC_DIR/sync.json" | jq -r ".version")
else
	echo "No sync.json found, creating one..."
	LOCAL_VER="$REMOTE_VER"
	touch "$INST_MC_DIR/sync.json"
	echo '{}' | jq ".version = \"$LOCAL_VER\"" > "$INST_MC_DIR/sync.json"
fi

echo $LOCAL_VER

# REMOTE="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/sh/sync.sh"
REMOTE="file://$HOME/Projects/ServerPackSync/sh/sync.sh"

curl -sSL $REMOTE -o sync.sh

bash sync.sh "$@"
