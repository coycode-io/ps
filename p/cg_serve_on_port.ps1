# Get the directory of the current script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Step 1: Read the port number from ccc.config (located in the root directory)
$rootDir = Resolve-Path "$scriptDir\..\..\"
$portNumber = Get-Content "$rootDir\portnr.def"
$portNumber = [int]$portNumber

# Step 2: Check if the repository is up to date
cd $rootDir

$gitStatus = git fetch
if ($LASTEXITCODE -ne 0) {
    throw "Failed to fetch latest changes from Git. Exiting..."
}

$localCommit = git rev-parse @
$remoteCommit = git rev-parse @{u}

if ($localCommit -ne $remoteCommit) {
    Write-Host "New updates available. Pulling changes..."
    $pullResult = git pull
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to update the repository. Exiting..."
    }
} else {
    Write-Host "Repository is already up-to-date."
}

# Step 3: Start the server
http-server -p $portNumber --cors
