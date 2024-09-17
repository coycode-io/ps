# Fetch the latest changes from the remote repository
git fetch origin

# Get the local and remote commit hashes
$localHash = git rev-parse HEAD
$remoteHash = git rev-parse origin/$(git rev-parse --abbrev-ref HEAD)

# Check if there are any changes on the remote
if ($localHash -ne $remoteHash) {
    Write-Host "Updates available. Pulling changes..."
    git pull origin $(git rev-parse --abbrev-ref HEAD)
} else {
    Write-Host "No updates available."
}
