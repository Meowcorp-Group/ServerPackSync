#!/usr/bin/env bash

# Modpack ID
# Format: <Modpack Host>:<Modpack ID>
# Example: CF:520914
MODPACK_ID="$1"

cd "$INST_MC_DIR"

# Fetch server pack index
# REMOTE="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/db/serverpacks.sh"
REMOTE="file://$HOME/Projects/ServerPackSync/db/serverpacks.json"
INDEX=$(curl -sSL $REMOTE)

MODS=$(echo "$INDEX" | jq -r ".[\"${MODPACK_ID}\"].extraMods")
echo "$MODS"

# debug
exit 255