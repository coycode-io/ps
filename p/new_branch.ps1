param (
    [string]$branchName
)

function CreateNewBranch {
    # Check if branchName is not empty
    git ls-remote > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Unable to connect to GitHub. Please check your internet connection or authentication..." -ForegroundColor Red
        exit 1
    }
    if ([string]::IsNullOrEmpty($branchName)) {
        Write-Host "Error: Branch name cannot be empty..." -ForegroundColor Red
        return
    }


    # Get the current date
    $currentDate = Get-Date
    $year = $currentDate.Year.ToString().Substring(2)
    $month = $currentDate.Month.ToString("D2")
    $day = $currentDate.Day.ToString("D2")

    # Concatenate the date components with the provided branch name
    $newBranchName = "$year$month$day$branchName"

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