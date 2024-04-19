# Set Root and Possible Archive File
$rootDirectory = "C:\"
$archivedir = "C:\Path\To\Archive" # Replace with your actual path

# Create Archivedir if it doesn't exist
if (-not (Test-Path -Path $archivedir)) {
    New-Item -Path $archivedir -ItemType Directory
}

function Archival($drive) {
    $filesToArchive = Get-ChildItem -Path $drive.FullName -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-2) }

    if ($filesToArchive.Count -gt 2) {
        $archiveName = Join-Path -Path $archivedir -ChildPath ("Archive_" + $drive.Name + "_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".zip")
        Compress-Archive -Path $filesToArchive.FullName -DestinationPath $archiveName
        Remove-Item -Path $filesToArchive.FullName -Force
    }
    elseif ($filesToArchive.Count -gt 0) {
        foreach ($file in $filesToArchive) {
            $destinationPath = Join-Path -Path $archivedir -ChildPath $file.Name
            Copy-Item -Path $file.FullName -Destination $destinationPath
            Remove-Item -Path $file.FullName -Force
        }
    }
}

function CheckAge {
    $drives = Get-ChildItem -Path $rootDirectory -Recurse -File -Exclude "$rootDirectory\Windows\*"

    foreach ($drive in $drives) {
        if ($drive.LastWriteTime -lt (Get-Date).AddDays(-2)) {
            Archival $drive
        }
    }

    Write-Host "All Good Files are UptoDate and don't need Archiving"
}