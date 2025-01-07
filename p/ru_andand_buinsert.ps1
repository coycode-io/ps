# Change to the directory of the script
$scriptPath = $PSScriptRoot
Set-Location -Path $scriptPath\..\..

# Ensure the Android output directory exists
$outputDirAndroid = Join-Path -Path $PWD -ChildPath "jniLibs"
if (!(Test-Path -Path $outputDirAndroid)) {
    New-Item -ItemType Directory -Path $outputDirAndroid | Out-Null
}
$armeabi = "AND-armeabi-v7a"
$arm64 = "AND-arm64-v8a"
$armX8664 = "AND-x86_64"
$appleDarwinX8664 = "APPLE-x86_64-apple-darwin"
$appleDarwinAarch64 = "APPLE-aarch64-apple-darwin"
$architecturesNotBuilt = @($appleDarwinX8664,$appleDarwinAarch64)
$architecturesActuallyBuilt = @()

# Build for Android targets
#cargo ndk -t armeabi-v7a -t arm64-v8a -t x86_64 -o $outputDirAndroid build --release
#Write-Host "Rust libraries for Android built and placed in '$outputDirAndroid'"

try {
    cargo ndk -t armeabi-v7a -o $outputDirAndroid build --release
	$architecturesActuallyBuilt+=$armeabi
} catch {
    $architecturesNotBuilt+=$armeabi
}
try {
    cargo ndk -t arm64-v8a -o $outputDirAndroid build --release
	$architecturesActuallyBuilt+=$arm64
} catch {
    $architecturesNotBuilt+=$arm64
}
try {
    cargo ndk -t x86_64 -o $outputDirAndroid build --release
	$architecturesActuallyBuilt+=$armX8664
} catch {
    $architecturesNotBuilt+=$armX8664
}


# Read the coycode.toml file using PSToml
$coycodePath = Join-Path -Path $PWD -ChildPath "coycode.toml"
if ($architecturesActuallyBuilt.Count -gt 0) {
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
} 
$builtCount = $architecturesActuallyBuilt.Count
$notBuiltCount = $architecturesNotBuilt.Count

# Output successfully built
Write-Output "$builtCount successfully built: $($architecturesActuallyBuilt -join ', ')"

# Output the header for not successfully built
Write-Output "****************************************************"
Write-Output "$notBuiltCount NOT successfully built:"

# Numerate and list the not-built architectures
for ($i = 0; $i -lt $notBuiltCount; $i++) {
    $index = $i + 1
    Write-Output "$index.$($architecturesNotBuilt[$i])"
}

# Footer
Write-Output "****************************************************"