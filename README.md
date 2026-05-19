# smedia

`smedia` ist als portables Monorepo mit npm Workspaces, Vue/Vite-Frontend, Express-Backend, gemeinsamer Workspace-Library und Docker-Setup fuer Entwicklung und Produktion aufgebaut.

## Projektuebersicht

- `frontend/`: Vue-3-Anwendung mit Vite und eigenem Build
- `backend/`: Express-API fuer Fachlogik, PDFs, OpenAPI und Datenbankzugriff
- `lib/`: gemeinsames Workspace-Package `@smedia/lib`
- `db/`: Datenbank-Bootstrap mit `init.sql`
- `docker-compose.yml`: Produktions-Stack mit Frontend, Backend und MariaDB
- `docker-compose.dev.yml`: Entwicklungs-Stack fuer Backend und MariaDB

## Monorepo-Struktur

```text
projekt/
├─ package.json
├─ frontend/
├─ backend/
├─ lib/
├─ db/
├─ docker-compose.yml
├─ docker-compose.dev.yml
├─ .env.example
├─ .env.docker
├─ .gitignore
├─ README.md
└─ README-DEMO.md
```

## Voraussetzungen

- Node.js 22+
- npm 10+
- Docker Desktop mit Compose

## Installation

1. Abhaengigkeiten installieren:

```powershell
npm install
```

2. Lokale Konfiguration anlegen:

```powershell
Copy-Item .env.example .env
```

3. Falls du die lokalen Ports oder Zugangsdaten aendern willst, passe `.env` und `.env.docker` an.

## Environment-Dateien

- `.env`: lokale Entwicklung ausserhalb von Docker, wird nicht versioniert
- `.env.example`: sichere Vorlage fuer lokale Entwicklung
- `.env.docker`: Werte fuer Compose und Container-Laufzeit

Wichtig:

- `.env` bleibt lokal und gehoert nie ins Repository.
- `db/init.sql` und `.env.docker` muessen zueinander passen, insbesondere bei `DB_USER`, `DB_PASSWORD` und `DB_NAME`.
- Ein vorhandenes MariaDB-Volume wird nicht automatisch mit neuem `init.sql` ueberschrieben.

## npm Workspaces

Das Root-`package.json` verwaltet drei Workspaces:

- `frontend`
- `backend`
- `lib`

Die gemeinsame Library wird als echtes Workspace-Package eingebunden:

```json
"@smedia/lib": "1.0.0"
```

Dadurch entfallen fragile `file:`-Abhaengigkeiten, und `npm install` verknuepft das lokale Paket ueber die Workspace-Definition sauber im Monorepo.

## Development-Workflow

Empfohlen ist ein gemischter Workflow:

1. Backend und Datenbank in Docker starten:

```powershell
npm run dev:stack
```

2. Frontend lokal mit Vite starten:

```powershell
npm run dev:frontend
```

Ergebnis:

- Frontend lokal: `http://localhost:5173`
- Backend aus Docker: `http://localhost:3001`
- API-Doku: `http://localhost:3001/api/docs`
- MariaDB auf dem Host: `localhost:3308`

Hot Reload:

- Vite aktualisiert das Frontend lokal sofort.
- Das Backend laeuft im Dev-Compose mit `nodemon` und beobachtet `backend/` sowie `lib/`.
- API-Aufrufe gehen im Frontend weiter relativ an `/api`; Vite proxyt automatisch auf das lokale Backend-Port-Mapping.

Optional kannst du das Backend auch lokal starten:

```powershell
npm run dev:backend
```

Dann muss `.env` auf eine erreichbare MariaDB zeigen, zum Beispiel auf den Docker-Port `3308`.

## Produktionsbetrieb

Der Produktions-Stack besteht aus drei Containern:

- `frontend`: Nginx liefert das gebaute Vue-Frontend auf Port `8080`
- `backend`: Node.js/Express auf Port `3001`
- `mariadb`: persistente Datenbank mit automatischem Initialimport

Start:

```powershell
npm run docker:prod
```

Danach erreichbar:

- Anwendung: `http://localhost:8080`
- API-Doku: `http://localhost:8080/api/docs`
- Backend direkt: `http://localhost:3001`

Architektur:

- Nginx liefert die SPA und leitet `/api` an den Backend-Container weiter.
- MariaDB importiert `db/init.sql` automatisch beim ersten Start eines leeren Volumes.
- Die Datenbankdaten bleiben im Docker-Volume `mariadb_data` persistent.

## Typische Docker-Befehle

```powershell
npm run dev:stack
npm run dev:stack:down
npm run dev:stack:logs
npm run docker:prod
npm run docker:prod:down
npm run docker:prod:logs
docker compose --env-file .env.docker -f docker-compose.yml ps
docker volume ls
```

## Demo-Schnellstart

Fuer eine schnelle lokale Vorfuehrung ohne manuelle Compose-Befehle:

```powershell
.\start-demo.ps1
```

oder:

```bat
start-demo.bat
```

Die Demo-Skripte starten den Produktions-Stack im Hintergrund und verweisen anschliessend auf die relevanten URLs.

## Troubleshooting

- `npm install` nach Workspace-Aenderungen immer einmal komplett im Root ausfuehren.
- Wenn `init.sql` geaendert wurde, aber sich nichts aendert, ist meist bereits ein MariaDB-Volume vorhanden.
- Wenn das Frontend lokal laeuft, aber keine API erreicht, pruefe zuerst `npm run dev:stack` und die Portfreigabe `3001`.
- Wenn Docker-Builds alte Artefakte nutzen, starte einmal mit `docker compose ... down --volumes` nur dann, wenn du bewusst lokale DB-Daten verwerfen willst.
- Wenn `@smedia/lib` nicht aufgeloest wird, liegt fast immer eine veraltete `node_modules`-Struktur vor.

## GitHub- und Repo-Empfehlungen

Empfohlene Repository-Beschreibung:

`Monorepo for smedia with Vue/Vite frontend, Express API, MariaDB and Docker-based dev/prod workflows.`

Empfohlene Branch-Struktur:

- `main`: jederzeit stabil und deploybar
- `develop`: optional fuer gebuendelte Integrationen
- `feature/<thema>`: neue Features
- `fix/<thema>`: Bugfixes
- `chore/<thema>`: Infrastruktur, Docs, Refactoring

Empfohlene erste Commit-Reihenfolge:

1. `chore: initialize monorepo workspace structure`
2. `chore: add docker dev and production stacks`
3. `docs: add setup, demo and workflow documentation`

CI/CD-Vorbereitung fuer spaeter:

- Root-Kommandos stabil halten, damit CI nur `npm ci`, `npm run build` und Compose-Builds braucht.
- spaeter getrennte Jobs fuer `frontend`-Build, `backend`-Smoke-Test und Container-Builds anlegen.
- Secrets niemals in `.env.docker` fuer echte Deployments ablegen; dort spaeter GitHub Secrets oder Deployment-Variablen nutzen.
