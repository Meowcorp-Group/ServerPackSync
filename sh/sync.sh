#!/usr/bin/env bash
# ServerPackSync

cd "$INST_MC_DIR"

if [ "$SYNC_DEBUG" = "true" ]; then
	remote="http://127.0.0.1:7171/db/serverpacks.json"
else
	remote="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/db/serverpacks.json"
fi

# Modpack ID
# Format: <Modpack Host>:<Modpack ID>
# Example: CF:520914
modpackID="$1"

# index format
# [
#   {
#     "name": "Emojiful",
#     "host": "CurseForge",
#     "fileName": "Emojiful-Forge-1.19.2-4.0.4-all.jar",
#     "projectID": "284324",
#     "fileID": "4326651"
#   },
#   ...
# ]
indexRemote=$(curl -sSL "$remote" | jq -r ".[\"${modpackID}\"].extraMods")

if [ -n "$(cat "$INST_MC_DIR/sync.json" | jq 'has("mods")')" ]; then
	indexLocal=$(cat "$INST_MC_DIR/sync.json" | jq -r ".mods")
else
	indexLocal="$indexRemote"
	syncJson=$(cat "$INST_MC_DIR/sync.json")
	echo "$syncJson" | jq ".[\"mods\"] = $indexRemote" >"$INST_MC_DIR/sync.json"
fi

# compare local and remote indexes
# and see which mods have different fileIDs


# loop over curseforge mods
# https://edge.forgecdn.net/files/XXXX/XXX/filename.jar
# XXXX/XXX is just the fileID with a slash after the first 4 digits
# for mod in $(echo "$mods" | jq -r ".[] | select(.host == \"CurseForge\") | .fileID"); do
# 	fileID=$(echo "$mod" | cut -c 1-4)/$(echo "$mod" | cut -c 5-)
# 	fileName=$(echo "$mods" | jq -r ".[] | select(.fileID == \"$mod\") | .fileName")
# 	# if file already exists, check if it's the same
# 	if [ ! -f "mods/$fileName" ]; then
# 		echo "Downloading $fileName"
# 		curl -#SL "https://edge.forgecdn.net/files/$fileID/$fileName" -o "mods/$fileName"
# 	else
# 		echo "$fileName already exists, skipping"
# 	fi
# done

# TODO: loop over modrinth mods
# thank you modrinth for having an open api