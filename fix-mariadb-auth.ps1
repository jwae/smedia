$ErrorActionPreference = "Stop"

$projectRoot = $PSScriptRoot

$initSource = Join-Path $projectRoot "db-init-auth-fix.sql"
$initTarget = "C:\tmp\db-init-auth-fix.sql"
$mysqlExe = "D:\MariaDB\bin\mysql.exe"
$myIniPath = "D:\MariaDB\data\my.ini"
$serviceRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\MariaDB2"
$serviceName = "MariaDB2"
$dbPassword = "waT%#219XBdDJ$yI-5Sh"
$normalBinPath = '"D:\MariaDB\bin\mysqld.exe" "--defaults-file=D:\MariaDB\data\my.ini" "MariaDB2"'
$myIniBackupPath = "C:\tmp\my.ini.before-auth-fix.bak"

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  throw "Bitte dieses Skript in einer als Administrator gestarteten PowerShell ausfuehren."
}

if (-not (Test-Path $initSource)) {
  throw "Init-SQL nicht gefunden: $initSource"
}

if (-not (Test-Path "C:\tmp")) {
  New-Item -ItemType Directory -Path "C:\tmp" | Out-Null
}

Copy-Item -LiteralPath $initSource -Destination $initTarget -Force

$restoreMyIni = $false

try {
  Write-Host "Stelle normalen Dienststart sicher ..."
  Set-ItemProperty -Path $serviceRegistryPath -Name ImagePath -Value $normalBinPath

  Write-Host "Sichere my.ini und trage init_file temporaer ein ..."
  Copy-Item -LiteralPath $myIniPath -Destination $myIniBackupPath -Force
  $restoreMyIni = $true
  $myIniContent = Get-Content $myIniPath -Raw
  if ($myIniContent -match "(?im)^\s*init_file\s*=") {
    $myIniContent = [regex]::Replace($myIniContent, "(?im)^\s*init_file\s*=.*(\r?\n)?", "")
  }
  if ($myIniContent -match "(?im)^\[mysqld\]\s*$") {
    $myIniContent = [regex]::Replace(
      $myIniContent,
      "(?im)^(\[mysqld\]\s*\r?\n)",
      "`$1init_file=$initTarget`r`n",
      1
    )
  } else {
    $myIniContent = "[mysqld]`r`ninit_file=$initTarget`r`n`r`n" + $myIniContent.TrimStart()
  }
  Set-Content -LiteralPath $myIniPath -Value $myIniContent -Encoding ASCII

  Write-Host "Stoppe MariaDB-Dienst $serviceName ..."
  sc.exe stop $serviceName | Out-Host
  $deadline = (Get-Date).AddSeconds(30)
  do {
    Start-Sleep -Milliseconds 500
    $service = Get-Service -Name $serviceName
  } while ($service.Status -ne "Stopped" -and (Get-Date) -lt $deadline)

  if ($service.Status -ne "Stopped") {
    throw "MariaDB-Dienst konnte nicht gestoppt werden."
  }

  Write-Host "Starte MariaDB-Dienst einmalig mit Init-SQL ..."
  sc.exe start $serviceName | Out-Host
  $deadline = (Get-Date).AddSeconds(30)
  do {
    Start-Sleep -Milliseconds 500
    $service = Get-Service -Name $serviceName
  } while ($service.Status -ne "Running" -and (Get-Date) -lt $deadline)

  if ($service.Status -ne "Running") {
    throw "MariaDB-Dienst mit Init-SQL konnte nicht gestartet werden."
  }

  Start-Sleep -Seconds 5

  Write-Host "Pruefe App-Benutzer smedia_app ..."
  & $mysqlExe --protocol=TCP --host=127.0.0.1 -u smedia_app -P 3307 --password="$dbPassword" -e "SELECT 1 AS ok;" | Out-Host

  Write-Host "Stoppe Dienst nach Init-SQL wieder ..."
  sc.exe stop $serviceName | Out-Host
  $deadline = (Get-Date).AddSeconds(30)
  do {
    Start-Sleep -Milliseconds 500
    $service = Get-Service -Name $serviceName
  } while ($service.Status -ne "Stopped" -and (Get-Date) -lt $deadline)

  if ($service.Status -ne "Stopped") {
    throw "MariaDB-Dienst konnte nach Init-SQL nicht gestoppt werden."
  }
}
finally {
  if ($restoreMyIni -and (Test-Path $myIniBackupPath)) {
    Write-Host "Stelle my.ini wieder her ..."
    Copy-Item -LiteralPath $myIniBackupPath -Destination $myIniPath -Force
  }
}

Write-Host "Starte MariaDB-Dienst wieder ..."
sc.exe start $serviceName | Out-Host
$deadline = (Get-Date).AddSeconds(30)
do {
  Start-Sleep -Milliseconds 500
  $service = Get-Service -Name $serviceName
} while ($service.Status -ne "Running" -and (Get-Date) -lt $deadline)

if ($service.Status -ne "Running") {
  throw "MariaDB-Dienst konnte nicht wieder gestartet werden."
}

Write-Host "Pruefe Verbindung nach dem Neustart ..."
& $mysqlExe --protocol=TCP --host=127.0.0.1 -u smedia_app -P 3307 --password="$dbPassword" -e "SELECT 1 AS ok;" | Out-Host

Write-Host "MariaDB-Authentifizierung erfolgreich auf Passwort-Login umgestellt."
