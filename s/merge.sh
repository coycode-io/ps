#!/bin/bash

commitMessage=$1

# Function to merge the current branch to main
MergeBranchToMain() {
    # Check if the commit message is provided
    if [[ -n "$commitMessage" ]]; then
        # Check if the current branch is not 'main'
        currentBranch=$(git rev-parse --abbrev-ref HEAD)
        if [[ "$currentBranch" != "main" ]]; then
            # Stage all changes
            git add .

            # Commit changes with the provided message
            git commit -m "$commitMessage"

            # Push changes to remote branch
            git push -u origin "$currentBranch"

            # Checkout 'main' branch
            git checkout main

            # Merge the current branch into 'main'
            git merge "$currentBranch"
        else
            echo "Error: You cannot perform this operation while on the 'main' branch."
        fi
    else
        echo "Error: Please provide a commit message."
    fi
}

# Call the function to merge the current branch to 'main'
MergeBranchToMain
