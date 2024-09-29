# Define the root directory as the parent of the script's location
$scriptPath = $PSScriptRoot
$rootDir = (Get-Item "$scriptPath\..\..").FullName

# 1. Add the latest flutter_riverpod package to pubspec.yaml
Write-Host "Adding flutter_riverpod to pubspec.yaml..."
flutter pub add flutter_riverpod

# 2. Clone the repo coycode-io/template_riverpod_notifier
$tempDir = New-TemporaryFile
Remove-Item $tempDir
New-Item -ItemType Directory -Path $tempDir
Write-Host "Cloning template repository..."
git clone https://github.com/coycode-io/template_riverpod_notifier.git $tempDir

# 3. Copy the folder lib/providers from the cloned repo to the root project's lib/providers
Write-Host "Copying 'lib/providers' from the template to the root project..."
New-Item -ItemType Directory -Path "$rootDir\lib\providers" -Force
Copy-Item -Recurse -Path "$tempDir\lib\providers\*" -Destination "$rootDir\lib\providers"

# 4. Copy the folder test_project from the cloned repo to the root project's lib/providers
Write-Host "Copying 'test_project' to the root project's 'lib/providers'..."
Copy-Item -Recurse -Path "$tempDir\test_project" -Destination "$rootDir\lib\providers"

# Clean up: Remove the temporary directory
Write-Host "Cleaning up temporary files..."
Remove-Item -Recurse -Force $tempDir

Write-Host "Setup completed successfully."
