#!/bin/bash

# Check if commit message is provided
if [ -z "$1" ]; then
    echo "No commit message provided"
    exit 1
fi

# Get the current git branch
currentBranch=$(git rev-parse --abbrev-ref HEAD)

# Fetch the latest changes from the remote
git fetch origin "$currentBranch"

# Check if there are any changes on the remote
localHash=$(git rev-parse "$currentBranch")
remoteHash=$(git rev-parse "origin/$currentBranch")

if [ "$localHash" != "$remoteHash" ]; then
    echo "Remote has changes. Pull the latest changes before pushing."
    exit 1
fi

# Perform git operations
git add .
git commit -m "$1"
git push -u origin "$currentBranch"
