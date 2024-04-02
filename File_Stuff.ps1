# First of All Powershell is a Pain in The ass Why cant i just use your Typical System Commands instead of these Fancy CMDLETS I would need maybe Half the Code in Linux but thats just me Ranting
# So Whats the Plan Here? We want Optimization for File Management and Stuff for the New Server
# So We create an Archival Function that Iterates Through the Whole Drive (System Data Excluded We dont Want to Accidentally Wipe the System do we now?:D) Comparing The Age of the Data to the Age i Set here
# If the Age is Older than i set here the Archival Function is Triggered which then Archives the Old Files und Moves Them to a Archival Folder  
# In Case the Age equals The Same Day or Just a Bit Older e.g 1 Day ago we Want to create A Host Message that says All Good Sir or some Shit like That
# Archival seems Finished now What exactly should this do?
# It may Seem that i have a Plan Here but i really dont i just did the First Thing that came to mind 

# Set Policy to Run The Script without Signing
Set-Executionpolicy Unrestricted -Force

# Set Root and Possible Archive File
$rootDirectory = "C:\"
$archivedir = "HERE would be the Path to the Archive Dir"

# Get Current Date for Compare Purposes
# $compareDate = Get-Date

# Create Archivedir if it doesnt exist
if (-not (Test-Path -Path $archivedir)) {
    New-Item -Path $archivedir -ItemType Directory
}

function Archival {
    # When a File or Directory is Found in Best Case More than one Pack them in an Archive and move them to $archivedir 
    # if its Only One or 2 Just Copy them and delete the Original if possible
    $filesToArchive = Get-ChildItem -Path $drive.FullName -Exclude "$rootDirectory\Windows\*" -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-2) }

    if ($filesToArchive.Count -gt 2) {
        # Pack the files into an archive and move them to $archivedir
        $archiveName = Join-Path -Path $archivedir -ChildPath ("Archive_" + $drive.Name + "_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".zip")
        Compress-Archive -Path $filesToArchive.FullName -DestinationPath $archiveName
        Remove-Item -Path $filesToArchive.FullName -Force
    }
    elseif ($filesToArchive.Count -gt 0) {
        # Copy the files to $archivedir and delete the original files
        foreach ($file in $filesToArchive) {
            $destinationPath = Join-Path -Path $archivedir -ChildPath $file.Name
            Copy-Item -Path $file.FullName -Destination $destinationPath
            Remove-Item -Path $file.FullName -Force
        }
    }
}

# Archive Data Thats Older than x Days
function CheckAge {
    # Iterate Through whole Drive and Exclude System Critical Files
    $drives = Get-ChildItem -Path $rootDirectory -Recurse -File -Exclude "$rootDirectory\Windows\*"

    foreach ($drive in $drives) {
        # Compare the age of each file in the drive to the set age
        foreach ($file in $drive) {
            if ($file.LastWriteTime -lt (Get-Date).AddDays(-2)) {
                # Call the Archival function to archive the old files
                Archival
                break
            }
        }
    }

    if ($rootDirectory -eq "CheckAge") {
        Write-Host "All Good Files are UptoDate and dont need Archiving"
    }

}