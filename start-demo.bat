@echo off
setlocal EnableExtensions

set "ROOT=%~dp0"
if "%ROOT:~-1%"=="\" set "ROOT=%ROOT:~0,-1%"
cd /D "%ROOT%"

where docker >nul 2>nul
if errorlevel 1 (
  echo Docker wurde nicht gefunden. Bitte Docker Desktop installieren oder in PATH verfuegbar machen.
  pause
  exit /b 1
)

echo Starte smedia-Demo per Docker...
docker compose --env-file .env.docker -f docker-compose.yml up --build -d
if errorlevel 1 (
  echo Der Docker-Start ist fehlgeschlagen.
  pause
  exit /b 1
)

echo.
echo Die Demo laeuft jetzt im Hintergrund.
echo App:      http://localhost:8080
echo API-Doku: http://localhost:8080/api/docs
echo Backend:  http://localhost:3001
echo.
echo Logs anzeigen: docker compose --env-file .env.docker -f docker-compose.yml logs -f
echo Stoppen:      docker compose --env-file .env.docker -f docker-compose.yml down
