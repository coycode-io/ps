# Get the directory where the script is called from (not the script location)
$callingDir = Get-Location

# Get all subdirectories directly under the calling directory (not deeper)
$subDirs = Get-ChildItem -Path $callingDir -Directory

# Loop through each subdirectory
foreach ($dir in $subDirs) {
    # Define the path to portnr.def in the current subdirectory
    $portFile = Join-Path $dir.FullName 'portnr.def'

    # Check if the portnr.def file exists
    if (Test-Path $portFile) {
        # Read the port number from portnr.def
        $portNumber = Get-Content $portFile
        $portNumber = [int]$portNumber.Trim()  # Ensure we trim any spaces or newlines

        Write-Host "Serving directory '$($dir.FullName)' on port $portNumber"

        # Start the HTTP server in the background using Start-Job
        Start-Job -ScriptBlock {
            param ($dir, $portNumber)
            cd $dir
            http-server -p $portNumber --cors -c-1
        } -ArgumentList $dir.FullName, $portNumber
    } else {
        Write-Host "No portnr.def found in '$($dir.FullName)', skipping..."
    }
}

# Change back to the original directory
cd $callingDir
