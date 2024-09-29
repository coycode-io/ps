# Get the root directory of the current Flutter project
$RootDir = Get-Location

# 1. Add flutter_riverpod package to the current Flutter project
Write-Host "Adding flutter_riverpod to the current Flutter project..."
flutter pub add flutter_riverpod

# 2. Create a new Flutter project with a random 5-digit number
$RandomNumber = Get-Random -Minimum 10000 -Maximum 99999
$NewProjectName = "test_project$RandomNumber"
Write-Host "Creating new Flutter project: $NewProjectName..."
flutter create "$RootDir\$NewProjectName"

# Add flutter_riverpod to the new Flutter project
Write-Host "Adding flutter_riverpod to $NewProjectName..."
Set-Location "$RootDir\$NewProjectName"
flutter pub add flutter_riverpod
Set-Location $RootDir

# 3. Create the lib/providers directory in the current project
Write-Host "Creating lib/providers directory..."
New-Item -ItemType Directory -Path "$RootDir\lib\providers" -Force

# 4. Clone the GitHub repo into a temporary directory
$TempDir = "$RootDir\temp"
Write-Host "Cloning the template repository into $TempDir..."
git clone https://github.com/coycode-io/template_riverpod_notifier.git $TempDir

# 5. Copy the lib/providers content from the cloned repo into the current project's lib/providers
Write-Host "Copying content from the template's lib/providers to the current project's lib/providers..."
Copy-Item -Recurse -Path "$TempDir\lib\providers\*" -Destination "$RootDir\lib\providers"

# 6. Delete the temporary directory
Write-Host "Deleting the temporary directory..."
Remove-Item -Recurse -Force $TempDir

Write-Host "Setup completed successfully."
