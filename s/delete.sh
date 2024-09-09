#!/bin/bash

function DeleteBranchAndPushToMain {
    # Check if the current branch is not 'main'
    currentBranch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$currentBranch" != "main" ]; then
        # Stage all changes
        git add .

        # Commit changes
        git commit -m "DEL"

        # Get the current branch name
        branchNameX="$currentBranch"

        # Push changes to remote branch
        git push -u origin "$branchNameX"

        # Checkout 'main' branch
        git checkout main

        # Delete the current branch
        git branch -D "$branchNameX"
    else
        echo "Error: You cannot perform this operation while on the 'main' branch."
    fi
}

# Call the function to delete the current branch and push changes to 'main'
DeleteBranchAndPushToMain
