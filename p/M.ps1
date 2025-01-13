param (
    [string]$commitMessage
)
# that is okay
# that should stay
# yes
function MergeBranchToMain {
    git ls-remote > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Unable to connect to GitHub. Please check your internet connection or authentication." -ForegroundColor Red
    exit 1
}
    # Check if the commit message is provided
    if ([string]::IsNullOrWhiteSpace($commitMessage)) {
        $commitMessage = Read-Host "Please enter a commit message"

# Check if the input is null or whitespace
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "auto-commit-message"
}
    }
        # Check if the current branch is not 'main'
        $currentBranch = git rev-parse --abbrev-ref HEAD
        if ($currentBranch -ne "main") {
            # Stage all changes
            git add .

            # Commit changes with the provided message
            git commit -m $commitMessage

            # Get the current branch name
            $branchNameX = $currentBranch

            # Push changes to remote branch
            git push -u origin $branchNameX

            # Checkout 'main' branch
            git checkout main

            # Merge the current branch into 'main'
            git merge $branchNameX
        } else {
            Write-Host "Error: You cannot perform this operation while on the 'main' branch."
        }
    } 


# Call the function to merge the current branch to 'main'
MergeBranchToMain