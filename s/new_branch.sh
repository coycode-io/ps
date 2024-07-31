#!/bin/bash

branchName=$1

function CreateNewBranch {
    # Check if branchName is not empty
    if [ -z "$branchName" ]; then
        echo "Error: Branch name cannot be empty."
        return
    fi

    # Get the current date
    currentDate=$(date +'%y%m%d')

    # Concatenate the date components with the provided branch name
    newBranchName="$currentDate$branchName"

    # Check if the current branch is 'main'
    currentBranch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$currentBranch" = "main" ]; then
        # Add changes, commit, and push to 'main' before creating a new branch
        git add .
        git commit -m "before $newBranchName"
        git push -u origin main

        # Checkout a new branch
        git checkout -b "$newBranchName"
    else
        echo "Error: You must be on the 'main' branch to create a new branch."
    fi
}

# Call the function to create a new branch
CreateNewBranch
