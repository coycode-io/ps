# gita.ps1
param (
    [string]$m
)

if (-Not $m) {
    Write-Host "No commit message provided"
    exit 1
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
