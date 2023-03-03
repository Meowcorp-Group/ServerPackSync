#!/usr/bin/env bash

# REMOTE="https://raw.githubusercontent.com/Meowcorp-Group/ServerPackSync/main/sh/sync.sh"
REMOTE="$HOME/Projects/ServerPackSync/sh/sync.sh"

curl -sSL $REMOTE | bash -s -- "$@"
