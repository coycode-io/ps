# Check for uncommitted changes
if ((git status --porcelain) -ne "") {
    Write-Output "There are uncommitted changes. Please commit or stash them before updating."
    exit
}

# Check if the local branch is ahead of the remote branch
$localAhead = (git rev-list --left-right --count HEAD...origin/main)[0] -ne 0
if ($localAhead) {
    Write-Output "Local branch is ahead of the remote. Push or rebase before fetching."
    exit
}

# Fetch the latest changes
git fetch

# Checkout the main branch and pull updates from origin
git checkout main
git pull origin main
