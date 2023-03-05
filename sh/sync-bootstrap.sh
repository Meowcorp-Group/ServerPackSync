#!/usr/bin/env bash
# ServerPackSync bootstrap

if [ $SYNC_DEBUG = "true" ]; then
	echo -e "\033[1;33mDebug mode enabled\033[0m" >&2
	remote_ver_url="http://127.0.0.1:7171/db/sync.json"
	remote="http://http://127.0.0.1:7171/sh/sync.sh"
else
	remote_ver_url="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/db/sync.json"
	remote="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/sh/sync.sh"
fi

tover() {
    version="$1"
    echo "${version:0:1}.${version:1:1}.${version:2:1}"
}

# Get remote version number
remote_ver=$(curl -sSL "$remote_ver_url" | jq -r ".version")

# Check if sync.json file exists and has a version number
if [ -f "$INST_MC_DIR/sync.json" ] && cat "$INST_MC_DIR/sync.json" | jq 'has("version")' >/dev/null 2>&1; then
    local_ver=$(cat "$INST_MC_DIR/sync.json" | jq -r ".version")
else
    echo "No sync.json found, creating one..."
    local_ver=0
    echo '{}' | jq ".version = 0" >"$INST_MC_DIR/sync.json"
fi

# Update sync.json and sync.sh files if remote version is newer
if [ "$local_ver" != "$remote_ver" ]; then
    echo "A new version is available: $remote_ver"
    echo "Updating..."
    local_ver=$remote_ver
    curl -#SL "$remote" -o "$INST_MC_DIR/sync.sh"
    sync_json=$(cat "$INST_MC_DIR/sync.json")
    echo "$sync_json" | jq ".version = \"$remote_ver\" | .version |= tonumber" >"$INST_MC_DIR/sync.json"
fi

echo "ServerPackSync $(tover "$local_ver")"

# Run the sync.sh script with arguments
bash -e "$INST_MC_DIR/sync.sh" "$@"