# Define the interval for monitoring in seconds
$monitoringInterval = 5

# Function to retrieve CPU and memory usage
function Get-SystemUsage {
    $cpuUsage = (Get-WmiObject Win32_PerfFormattedData_PerfOS_Processor | Select-Object -ExpandProperty PercentProcessorTime) / (Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty NumberOfLogicalProcessors)
    $memoryUsage = (Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty FreePhysicalMemory) / (Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory) * 100
    return @{
        CPUUsage = $cpuUsage
        MemoryUsage = (100 - $memoryUsage)
    }
}

# Main monitoring loop
while ($true) {
    $systemUsage = Get-SystemUsage

    # Output current system usage
    Write-Host "CPU Usage: $($systemUsage.CPUUsage)%"
    Write-Host "Memory Usage: $($systemUsage.MemoryUsage)%"

    # Wait for the monitoring interval
    Start-Sleep -Seconds $monitoringInterval
}
