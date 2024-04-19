# Define source and destination directories
$sourceDirectory = "C:\Path\To\Backup" # Replace with your actual path
$destinationDirectory = "C:\Path\To\Destination" # Replace with your actual path
$deletionDate = (Get-Date).AddDays(2)

# Create destination directory if it does not exist
if (-not (Test-Path -Path $destinationDirectory)) {
    New-Item -Path $destinationDirectory -ItemType Directory
}

# Tar the folder Together or Using the 7Zip4Powershell Module 
function New-Archive {
    # Get current date to create a timestamp for the backup folder
    $dateStamp = Get-Date -Format "yyyyMMdd"
    $tarfile = "$dateStamp_Backup.tar.gz"

    #In Theory with Tar
    cmd.exe /c "tar -cvzf $tarfile $sourceDirectory"
    Move-Item -Path $tarfile -Destination $destinationDirectory 
}

function Test_Age {
    $tarfile = Get-ChildItem -Path $destinationDirectory -Filter "*.tar.gz" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

    # Check if File is Older Than Deletion Date
    if ($tarfile.LastWriteTime -lt $deletionDate) {
        Remove-Item $tarfile.FullName
    }
    else {
        Write-Host "Tarfile Up to Date no Deletion Required"
    }
}

New-Archive
Test_Age

Write-Host "Backup completed successfully."