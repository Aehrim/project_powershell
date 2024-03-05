# Set Policy to Run The Script without Signing
Set-Executionpolicy Unrestricted -Force
# Define source and destination directories
$sourceDirectory = "Hier Pfad zum Backup angeben"
$destinationDirectory = "HIER Destination Pfad am besten Externe Festplatte benutzen"
# If i Decide to use Zip for Powershell Commented for now
# $pathtomodule= ".\7Zip4Powershell"
$deletionDate = Get-Date.AddDays(+2)

# Create destination directory if it does not exist
if (-not (Test-Path -Path $destinationDirectory)) {
    New-Item -Path $destinationDirectory -ItemType Directory
}

# Tar the folder Together or Using the 7Zip4Powershell Module dont know yet wait for VM Install
function Create-Archive {
    # Get current date to create a timestamp for the backup folder
    $dateStamp = Get-Date -Format "MM/dd/yyyy"
    $tarfile = "$dateStamp_Backup.tar.gz"

    #In Theory with Tar
   cmd.exe /c "tar -cvzf $sourceDirectory"
   Move-Item -Path $sourceDirectory\$tarfile -Destination $destinationDirectory 
}

function Test_Age {
    # Check if File is Older Than Deletion Date
    if $tarfile < $deletionDate {
        Remove-Item $tarfile
    }
    else {
        Write-Host "Tarfile Up to Date no Deletion Required"
    }
}

# Create a folder with current date stamp under the destination directory
# $backupFolder = Join-Path -Path $destinationDirectory -ChildPath "Backup_$dateStamp"
# New-Item -Path $backupFolder -ItemType Directory

# Copy files from source directory to the backup folder
# Copy-Item -Path $sourceDirectory\* -Destination $backupFolder -Recurse -Force

Write-Host "Backup completed successfully."
