function DeleteBranchAndPushToMain {
    # Check GitHub connectivity
    git ls-remote > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host 'Unable to connect to GitHub. Exiting...' -ForegroundColor Red
        exit 1
    }

    # Get the current branch
    $currentBranch = git rev-parse --abbrev-ref HEAD
    if ($LASTEXITCODE -ne 0) {
        Write-Host 'Failed to determine the current branch. Ensure you are in a valid Git repository.' -ForegroundColor Red
        exit 1
    }

    # Ensure we are not on the 'main' branch
    if ($currentBranch -ne "main") {
        # Stage all changes
        git add . > $null 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host 'Failed to stage changes. Exiting...' -ForegroundColor Red
            exit 1
        }

        # Commit changes
        git commit -m "DEL" > $null 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host 'Failed to commit changes. Exiting...' -ForegroundColor Red
            exit 1
        }

        # Push changes to remote branch
        git push -u origin $currentBranch > $null 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to push changes for branch '$currentBranch'. Exiting..." -ForegroundColor Red
            exit 1
        }

        # Checkout 'main' branch
        git checkout main > $null 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to switch to 'main' branch.  Exiting..." -ForegroundColor Red
            exit 1
        }

        # Delete the current branch
        git branch -D $currentBranch > $null 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Failed to delete branch '$currentBranch'. Exiting..." -ForegroundColor Red
            exit 1
        }

        Write-Host "Branch '$currentBranch' deleted." -ForegroundColor Green
    } else {
        Write-Host "Error: You cannot perform this operation while on the 'main' branch." -ForegroundColor Yellow
    }
}

# Execute the function
DeleteBranchAndPushToMain