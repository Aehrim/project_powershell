# Path to the directory to be checked
$Quellpfad = "C:\Path\To\Directory\To\Be\Checked" # Replace with your actual path

# Path to the archive directory
$Archivpfad = "C:\Path\To\Archive\Directory" # Replace with your actual path

# Age of the files to be moved (in days)
$Alter = 30

# Check if the source path exists
if (!(Test-Path -Path $Quellpfad)) {
    Write-Host "The source path does not exist."
    exit
}

# Check if the archive directory exists, if not, create it
if (!(Test-Path -Path $Archivpfad)) {
    New-Item -Path $Archivpfad -ItemType Directory | Out-Null
    Write-Host "The archive directory has been created."
}

# Check all files in the source path
$Dateien = Get-ChildItem -Path $Quellpfad -File

# Iterate through each file
foreach ($Datei in $Dateien) {
    # Check if the file is older than the specified age
    if ($Datei.LastWriteTime -lt (Get-Date).AddDays(-$Alter)) {
        # Move the file to the archive directory
        Move-Item -Path $Datei.FullName -Destination $Archivpfad
        Write-Host "The file $($Datei.Name) has been moved to the archive directory."
    }
}

Write-Host "Data optimization completed."