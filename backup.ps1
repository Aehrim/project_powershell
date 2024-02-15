# Define source and destination directories
$sourceDirectory = "C:\Users\metha\Documents\Develop"
$destinationDirectory = "D:\Backup"

# Create destination directory if it does not exist
if (-not (Test-Path -Path $destinationDirectory)) {
    New-Item -Path $destinationDirectory -ItemType Directory
}

# Get current date to create a timestamp for the backup folder
$dateStamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Create a folder with current date stamp under the destination directory
$backupFolder = Join-Path -Path $destinationDirectory -ChildPath "Backup_$dateStamp"
New-Item -Path $backupFolder -ItemType Directory

# Copy files from source directory to the backup folder
Copy-Item -Path $sourceDirectory\* -Destination $backupFolder -Recurse -Force

Write-Host "Backup completed successfully."
