# Contributing

## Branch-Strategie

- `main` bleibt jederzeit stabil und deploybar.
- `develop` ist optional fuer gebuendelte Integration mehrerer Aenderungen.
- Arbeite fuer neue Aufgaben auf Branches wie `feature/<thema>`, `fix/<thema>` oder `chore/<thema>`.

## Empfohlener Ablauf

1. Repository aktualisieren.
2. Neuen Branch von `main` oder `develop` erstellen.
3. Aenderungen lokal testen.
4. Pull Request mit klarer Beschreibung und Testhinweisen erstellen.

## Lokale Checks

Vor einem Pull Request moeglichst mindestens diese Befehle ausfuehren:

```powershell
npm install
npm run build
node --check backend/server.js
docker compose --env-file .env.docker -f docker-compose.yml config
docker compose --env-file .env.docker -f docker-compose.dev.yml config
```

## Commit-Empfehlungen

- `feat:` fuer neue Funktionen
- `fix:` fuer Fehlerbehebungen
- `chore:` fuer Infrastruktur, Tooling und Repo-Pflege
- `docs:` fuer Dokumentation
- `refactor:` fuer interne Umstrukturierungen ohne Fachverhaltensaenderung

## Wichtige Regeln

- Keine echten Secrets committen.
- `.env` bleibt lokal.
- Aenderungen an Docker, Datenbank oder Env-Dateien immer in der Doku mitziehen.
- Bei Monorepo-Aenderungen Auswirkungen auf `frontend`, `backend` und `lib` bewusst pruefen.
