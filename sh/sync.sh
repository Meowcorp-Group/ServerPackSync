#!/usr/bin/env bash

# Modpack ID
# Format: <Modpack Host>:<Modpack ID>
# Example: CF:520914
MODPACK_ID="$1"

# debug
echo $@
cd "$INST_DIR"
echo $(ls -l)

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
REMOTE="$HOME/Projects/ServerPackSync/db/serverpacks.sh"
INDEX=$(curl -sSL $REMOTE)

echo "$INDEX"

# debug
exit 69420