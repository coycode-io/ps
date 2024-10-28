#!/bin/bash

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    echo "There are uncommitted changes. Please commit or stash them before updating."
    exit 1
fi

# Fetch the latest changes
git fetch

# Check if the local branch is ahead of the remote branch
if [[ $(git rev-list --left-right --count HEAD...origin/main | awk '{print $1}') -ne 0 ]]; then
    echo "Local branch is ahead of the remote. Push or rebase before fetching."
    exit 1
fi

# Checkout the main branch and pull updates from origin
git checkout main
git pull origin main
