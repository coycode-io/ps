# gita.ps1
param (
    [string]$m
)

git ls-remote > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host 'Unable to connect to GitHub. Exiting...' -ForegroundColor Red
        exit 1
    }

# Check if the commit message is provided
if ([string]::IsNullOrWhiteSpace($m)) {
    $m = Read-Host "Please enter a commit message:"

# Check if the input is null or whitespace
if ([string]::IsNullOrWhiteSpace($m)) {
    $currentDateFormatted = Get-Date -Format "yyyyMMddHHmmss"
$m = "$currentDateFormatted-auto-commit-message"
}
}


# Get the current git branch
$currentBranch = & git rev-parse --abbrev-ref HEAD

# Fetch the latest changes from the remote
git fetch origin $currentBranch

# Get the local and remote commit hashes
$localHash = & git rev-parse $currentBranch
$remoteHash = & git rev-parse origin/$currentBranch

# Check if there are any changes on the remote
if ($localHash -ne $remoteHash) {
    Write-Host "Remote has changes. Pull the latest changes before pushing."
    exit 1
}

# Perform git operations
git add .
git commit -m $m
git push -u origin $currentBranch
