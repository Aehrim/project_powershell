# Define the interval for monitoring in seconds
$monitoringInterval = 3
$allocatedDisk = 25

# Function to retrieve CPU and memory usage
function Get-SystemUsage {
    $cpuUsage = (Get-WmiObject Win32_PerfFormattedData_PerfOS_Processor | Select-Object -ExpandProperty PercentProcessorTime) / (Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty NumberOfLogicalProcessors)
    $memoryUsage = (Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory) / (Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory) * 100
    return @{
        CPUUsage = $cpuUsage
        MemoryUsage = (100 - $memoryUsage)
    }
}

function GetDiskSpace {
    $disk = Get-PSDrive C
    $diskspace = $disk.Free / 1GB
    $OverGB = $disk.TotalSize / 1GB * ($allocatedDisk/100)
    #When Disk Space becomes too full
    if ($diskspace -lt $OverGB) {
        Write-Error "Error: Disk is Nearly Full Please make Some Space on the Disk"
    }
    else {
        Write-Host "Disk Space is Sufficient"
    }
}

# Main monitoring loop
while ($true) {
    $systemUsage = Get-SystemUsage

    # Output current system usage
    Write-Host "CPU Usage: $($systemUsage.CPUUsage)%"
    Write-Host "Memory Usage: $($systemUsage.MemoryUsage)%"
    Write-Host (GetDiskSpace)

    # Wait for the monitoring interval
    Start-Sleep -Seconds $monitoringInterval
}