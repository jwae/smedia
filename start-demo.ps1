$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectRoot

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  Write-Host "Docker wurde nicht gefunden. Bitte Docker Desktop installieren oder in PATH verfuegbar machen." -ForegroundColor Red
  exit 1
}

Write-Host "Starte smedia-Demo per Docker..." -ForegroundColor Cyan
docker compose --env-file .env.docker -f docker-compose.yml up --build -d

if ($LASTEXITCODE -ne 0) {
  Write-Host "Der Docker-Start ist fehlgeschlagen." -ForegroundColor Red
  exit $LASTEXITCODE
}

Write-Host ""
Write-Host "Die Demo laeuft jetzt im Hintergrund." -ForegroundColor Green
Write-Host "App:      http://localhost:8080" -ForegroundColor Green
Write-Host "API-Doku: http://localhost:8080/api/docs" -ForegroundColor Green
Write-Host "Backend:  http://localhost:3001" -ForegroundColor Green
Write-Host ""
Write-Host "Logs anzeigen: docker compose --env-file .env.docker -f docker-compose.yml logs -f" -ForegroundColor DarkGray
Write-Host "Stoppen:      docker compose --env-file .env.docker -f docker-compose.yml down" -ForegroundColor DarkGray
