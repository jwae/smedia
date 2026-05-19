# Demo-Start von smedia

Diese Datei ist die Schnellstart-Variante fuer lokale Demos. Der Standardbetrieb ist Docker-basiert.

## Schnellstart

PowerShell:

```powershell
.\start-demo.ps1
```

Batch:

```bat
start-demo.bat
```

Beide Skripte starten den Produktions-Stack mit:

```powershell
docker compose --env-file .env.docker -f docker-compose.yml up --build -d
```

## Danach erreichbar

- Anwendung: `http://localhost:8080`
- API-Doku: `http://localhost:8080/api/docs`
- Backend direkt: `http://localhost:3001`
- MariaDB auf dem Host: `localhost:3308`

## Stoppen

```powershell
docker compose --env-file .env.docker -f docker-compose.yml down
```

## Voraussetzungen

- Docker Desktop laeuft
- Ports `8080`, `3001` und `3308` sind frei
- `.env.docker` enthaelt die gewuenschten Werte

## Hinweis zu Daten

Der SQL-Import aus `db/init.sql` erfolgt nur beim ersten Start eines leeren MariaDB-Volumes. Falls du einen frischen Demo-Stand brauchst, entferne das zugehoerige Volume bewusst manuell.
