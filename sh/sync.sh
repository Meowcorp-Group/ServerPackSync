#!/usr/bin/env bash

# Modpack Host [CF|MR]
MODPACK_HOST="$1"
# Modpack ID
MODPACK_PID="$2"
# Modpack Version ID / File ID
MODPACK_FID="$3"

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


# debug
exit 69420