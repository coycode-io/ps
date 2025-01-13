param (
    [string]$branchName
)
# random
function CreateNewBranch {
    # Check if branchName is not empty
    git ls-remote > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Unable to connect to GitHub. Please check your internet connection or authentication..." -ForegroundColor Red
        exit 1
    }
    if ([string]::IsNullOrEmpty($branchName)) {
        $newBranchName = Read-Host "NEW BRANCH NAME:"
        if ([string]::IsNullOrEmpty($branchName)) {
            $branchName = "auto"
            # Get the current date
    
            $currentDateFormatted = Get-Date -Format "yyyyMMddHHmmss"

            # Concatenate the date components with the provided branch name
            $newBranchName = "$currentDateFormatted-$branchName"
        }
    }


    

    # Check if the current branch is 'main'
    $currentBranch = git rev-parse --abbrev-ref HEAD
    if ($currentBranch -eq "main") {
        # Add changes, commit, and push to 'main' before creating a new branch
        git add .
        git commit -m ("before " + $newBranchName)
        git push -u origin main

        # Checkout a new branch
        git checkout -b $newBranchName
    } else {
        Write-Host "Error: You must be on the 'main' branch to create a new branch."
    }
}

# Call the function to create a new branch
CreateNewBranch