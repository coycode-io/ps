param(
    [string]$htmlREADMEName
)

$htmlLocalDirectory = "HTML-RM\"
$htmlAllDocsDirectory = "C:\Users\blablabylon\Desktop\aaargh.dev\admin\ALL-DOCS\"

$markdownFile = "README.md"

# Constructing full paths for output HTML files
$htmlLocalDirectoryAndFile = Join-Path -Path $htmlLocalDirectory -ChildPath $htmlREADMEName
$htmlAllDocsDirectoryAndFile = Join-Path -Path $htmlAllDocsDirectory -ChildPath $htmlREADMEName

# Command to run Pandoc for the HTML file in the local directory
pandoc -s $markdownFile -o $htmlLocalDirectoryAndFile
Write-Host "HTML file created at: $htmlLocalDirectoryAndFile"

# Command to run Pandoc for the HTML file in the ALL-DOCS directory
pandoc -s $markdownFile -o $htmlAllDocsDirectoryAndFile
Write-Host "HTML file created at: $htmlAllDocsDirectoryAndFile"