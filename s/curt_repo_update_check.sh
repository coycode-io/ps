#!/bin/bash

# Fetch the latest changes from the remote repository
git fetch origin

# Check if there are any changes on the remote
localHash=$(git rev-parse HEAD)
remoteHash=$(git rev-parse origin/$(git rev-parse --abbrev-ref HEAD))

if [ "$localHash" != "$remoteHash" ]; then
    echo "Updates available. Pulling changes..."
    git pull origin $(git rev-parse --abbrev-ref HEAD)
else
    echo "No updates available."
fi
