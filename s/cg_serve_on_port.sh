#!/bin/bash

# Step 1: Read the port number from ccc.config (located in the root directory)
scriptDir=$(dirname "$0")
rootDir=$(realpath "$scriptDir/../../")
portNumber=$(cat "$rootDir/portnr.def")

# Step 2: Check if the repository is up to date
cd "$rootDir"

git fetch
if [ $? -ne 0 ]; then
    echo "Failed to fetch latest changes from Git. Exiting..."
    exit 1
fi

localCommit=$(git rev-parse @)
remoteCommit=$(git rev-parse @{u})

if [ "$localCommit" != "$remoteCommit" ]; then
    echo "New updates available. Pulling changes..."
    git pull
    if [ $? -ne 0 ]; then
        echo "Failed to update the repository. Exiting..."
        exit 1
    fi
else
    echo "Repository is already up-to-date."
fi

# Step 3: Start the server
http-server -p "$portNumber" --cors

