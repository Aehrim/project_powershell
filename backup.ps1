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

# Tar the folder Together or Using the 7Zip4Powershell Module 
function New-Archive {
    # Get current date to create a timestamp for the backup folder
   # $dateStamp = Get-Date -Format "MM/dd/yyyy"
    $tarfile = "$dateStamp_Backup.tar.gz"

    #In Theory with Tar
   cmd.exe /c "tar -cvzf $sourceDirectory"
   Move-Item -Path $sourceDirectory\$tarfile -Destination $destinationDirectory 
}

function Test_Age {
    # Check if File is Older Than Deletion Date
    if ($tarfile -lt $deletionDate) {
        Remove-Item $tarfile
    }
    else {
        Write-Host "Tarfile Up to Date no Deletion Required"
    }
}


Write-Host "Backup completed successfully."
