# Pfad zum zu überprüfenden Ordner
$Quellpfad = "C:\Pfad\Zum\Zu\Überprüfenden\Ordner"

# Pfad zum Archivverzeichnis
$Archivpfad = "C:\Pfad\Zum\Archivverzeichnis"

# Alter der Dateien, die verschoben werden sollen (in Tagen)
$Alter = 30

# Überprüfen, ob der Quellpfad existiert
if (!(Test-Path -Path $Quellpfad)) {
    Write-Host "Der Quellpfad existiert nicht."
    exit
}

# Überprüfen, ob das Archivverzeichnis existiert, falls nicht, erstellen
if (!(Test-Path -Path $Archivpfad)) {
    New-Item -Path $Archivpfad -ItemType Directory | Out-Null
    Write-Host "Das Archivverzeichnis wurde erstellt."
}

# Alle Dateien im Quellpfad überprüfen
$Dateien = Get-ChildItem -Path $Quellpfad

# Durch jede Datei iterieren
foreach ($Datei in $Dateien) {
    # Überprüfen, ob die Datei älter als das angegebene Alter ist
    if ($Datei.LastWriteTime -lt (Get-Date).AddDays(-$Alter)) {
        # Datei in das Archivverzeichnis verschieben
        Move-Item -Path $Datei.FullName -Destination $Archivpfad -Force
        Write-Host "Die Datei $($Datei.Name) wurde in das Archivverzeichnis verschoben."
    }
}

Write-Host "Datenoptimierung abgeschlossen."