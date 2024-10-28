# Check for uncommitted changes
$uncommittedChanges = git status --porcelain
if ($uncommittedChanges) {
    Write-Output "There are uncommitted changes. Please commit or stash them before updating."
    exit
}

# Fetch the latest changes (only fetch without merging)
git fetch

# Check if the local branch is ahead of the remote branch
$branchStatus = git rev-list --left-right --count HEAD...origin/main
$localAhead = $branchStatus.Split(" ")[0] -ne 0
if ($localAhead) {
    Write-Output "Local branch is ahead of the remote. Push or rebase before fetching."
    exit
}

# Checkout the main branch and pull updates from origin
git checkout main
git pull origin main
