# Change to the directory of the script
$scriptPath = $PSScriptRoot
Set-Location -Path $scriptPath\..\..

# Ensure the Android output directory exists
$outputDirAndroid = Join-Path -Path $PWD -ChildPath "jniLibs"
if (!(Test-Path -Path $outputDirAndroid)) {
    New-Item -ItemType Directory -Path $outputDirAndroid | Out-Null
}

# Build for Android targets
cargo ndk -t armeabi-v7a -t arm64-v8a -t x86_64 -o $outputDirAndroid build --release
Write-Host "Rust libraries for Android built and placed in '$outputDirAndroid'"

# Ensure the Apple output directory exists
$outputDirApple = Join-Path -Path $PWD -ChildPath "appleLibs"
if (!(Test-Path -Path $outputDirApple)) {
    New-Item -ItemType Directory -Path $outputDirApple | Out-Null
}

# Build for Apple targets
$appleTargets = @("x86_64-apple-darwin", "aarch64-apple-darwin")
foreach ($target in $appleTargets) {
    cargo build --release --target $target
    $buildDir = Join-Path -Path $PWD -ChildPath "target\$target\release"
    Copy-Item -Path "$buildDir\*.dylib" -Destination $outputDirApple -Force
}

Write-Host "Rust libraries for Apple built and placed in '$outputDirApple'"

# Read the coycode.toml file using PSToml
$coycodePath = Join-Path -Path $PWD -ChildPath "coycode.toml"
if (Test-Path -Path $coycodePath) {
    try {
        # Parse the TOML file
        $coycodeContent = Get-Content -Path $coycodePath -Raw
        # $sanitizedContent = $coycodeContent -replace '\', '\\'
        Write-Host "HERE 4"$coycodeContent

        Import-Module PSToml
        $tomlContent =  ConvertFrom-Toml $coycodeContent
        # Extract the 'copy_delete_compiled_to' key
        $copyDeleteCompiledTo = $tomlContent.copy_delete_compiled_to
        if ($null -ne $copyDeleteCompiledTo) {
            foreach ($dir in $copyDeleteCompiledTo) {
                if (Test-Path -Path $dir -PathType Container) {
                    # Delete the jniLibs folder in the target directory
                    $jniLibsPath = Join-Path -Path $dir -ChildPath "jniLibs"
                    if (Test-Path -Path $jniLibsPath) {
                        Remove-Item -Path $jniLibsPath -Recurse -Force
                        Write-Host "Deleted 'jniLibs' in directory '$dir'"
                    }
                    # Copy the jniLibs folder from the project root
                    Copy-Item -Path $outputDirAndroid -Destination $dir -Recurse -Force
                    Write-Host "Copied 'jniLibs' from project root to '$dir'"
                } else {
                    Write-Host "Directory '$dir' does not exist. Skipping."
                }
            }
        } else {
            Write-Host "The 'copy_delete_compiled_to' key is not defined in 'coycode.toml'."
        }
    } catch {
        Write-Host "Error reading or parsing 'coycode.toml': $_"
    }
} else {
    Write-Host "The 'coycode.toml' file was not found in the project root."
}