#!/bin/bash

# Check if commit message is provided
if [ -z "$1" ]; then
    echo "No commit message provided"
    exit 1
fi

# Get the current git branch
currentBranch=$(git rev-parse --abbrev-ref HEAD)

# Perform git operations
git add .
git commit -m "$1"
git push -u origin "$currentBranch"
