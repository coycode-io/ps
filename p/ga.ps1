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

git add .
git commit -m $m
git push -u origin $currentBranch