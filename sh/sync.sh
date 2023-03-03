#!/usr/bin/env bash

# Modpack ID
# Format: <Modpack Host>:<Modpack ID>
# Example: CF:520914
MODPACK_ID="$1"

# debug
cd "$INST_DIR"

# Find the modpack directory
# Some modpacks use `minecraft` and some use `.minecraft`
if [ -d "$INST_DIR/minecraft" ]; then
	MODPACK_DIR="$INST_DIR/minecraft"
elif [ -d "$INST_DIR/.minecraft" ]; then
	MODPACK_DIR="$INST_DIR/.minecraft"
else
	echo "Invalid modpack installation"
	exit 1
fi

cd "$MODPACK_DIR"

# Fetch server pack index
# REMOTE="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/db/serverpacks.sh"
REMOTE="file://$HOME/Projects/ServerPackSync/db/serverpacks.json"
INDEX=$(curl -sSL $REMOTE)

MODS=$(echo "$INDEX" | jq -r ".[\"${MODPACK_ID}\"].extraMods")

# debug
exit 255