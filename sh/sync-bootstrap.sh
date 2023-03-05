#!/usr/bin/env bash

tover() {
	version="$1"
	echo "${version:0:1}.${version:1:1}.${version:2:1}"
}

# REMOTE_VER_URL="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/db/version.txt"
REMOTE_VER_URL="file://$HOME/Projects/ServerPackSync/db/sync.json"

# REMOTE="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/sh/sync.sh"
REMOTE="file://$HOME/Projects/ServerPackSync/sh/sync.sh"

REMOTE_VER=$(curl -sSL $REMOTE_VER_URL | jq -r ".version")

if [ -f "$INST_MC_DIR/sync.json" ] && cat "$INST_MC_DIR/sync.json" | jq 'has("version")' >/dev/null 2>&1; then
	LOCAL_VER=$(cat "$INST_MC_DIR/sync.json" | jq -r ".version")
else
	echo "No sync.json found, creating one..."
	LOCAL_VER=0
	# echo '{}' | jq ".version = \"$LOCAL_VER\"" >"$INST_MC_DIR/sync.json"
	echo '{}' | jq ".version = 0" >"$INST_MC_DIR/sync.json"
fi

if [ "$LOCAL_VER" != "$REMOTE_VER" ]; then
	echo "A new version is available: $REMOTE_VER"
	echo "Updating..."
	LOCAL_VER=$REMOTE_VER
	curl -#SL $REMOTE -o "$INST_MC_DIR/sync.sh"
	SYNC_JSON=$(cat "$INST_MC_DIR/sync.json")
	echo "$SYNC_JSON" | jq ".version = \"$REMOTE_VER\" | .version |= tonumber" >"$INST_MC_DIR/sync.json"
fi

echo "ServerPackSync $(tover "$LOCAL_VER")"

bash "$INST_MC_DIR/sync.sh" "$@"
