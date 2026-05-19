# GEMINI.md - Project Context: smedia (School Media Manager)

## Project Overview
**smedia** is a comprehensive inventory and rental management system designed for schools to manage books, tablets (iPads), and other media equipment. It supports the entire lifecycle of an item, from acquisition and barcode generation to borrowing, returning, damage reporting, and repairs.

### Main Technologies
- **Frontend:** Vue 3 (Composition API), Pinia (State Management), Vue Router, Vite (Build Tool), Vanilla CSS.
- **Backend:** Node.js, Express, MySQL/MariaDB (Database).
- **External APIs:** Integrates with Open Library, Google Books, and Deutsche Nationalbibliothek (DNB) for automated book metadata retrieval.
- **Other:** QR code generation, Barcode scanning support.

---

## Project Structure

### Root Directory
- `package.json`: Main project configuration, scripts, and shared dependencies.
- `openapi.yaml`: Comprehensive API documentation (Swagger/OpenAPI 3.0).
- `backend/`: Express server and database logic.
- `frontend/`: Vue 3 application.
- `sql/`: Database schema and seed data.
- `DB/`: Text-based representations of the database and application structure.
- `barcodes/`: PDF and text files for testing barcode scanners.

### Backend (`/backend`)
- `server.js`: The main Express application containing all API endpoints (Exemplare, Ausleihen, Historie, etc.).
- `db.js`: Database connection pooling using `mysql2/promise`.

### Frontend (`/frontend/src`)
- `main.js`: Entry point for the Vue application.
- `App.vue`: Root component.
- `components/`: Modular UI elements (e.g., `NeueAusleiheModule.vue`, `RueckgabeModule.vue`).
- `views/`: Page-level components (e.g., `MedienverwaltungView.vue`, `BuchungView.vue`).
- `stores/`: Pinia stores for state management (e.g., `inventarStore.js`).
- `composables/`: Reusable logic (e.g., `useScanner.js`, `useAusleihe.js`).

---

## Building and Running

### Prerequisites
- **Node.js:** v18+ recommended.
- **Database:** MariaDB/MySQL instance. The project defaults to port `3307`.

### Commands
| Task | Command |
| :--- | :--- |
| **Install Dependencies** | `npm install` |
| **Run Frontend (Dev)** | `npm run dev` |
| **Run Backend (Dev)** | `npm run dev:api` |
| **Build Frontend** | `npm run build` |
| **Preview Build** | `npm run preview` |

### Environment Variables
The following variables can be configured (defaults are in `backend/db.js` and `backend/server.js`):
- `DB_HOST`: Database host (default: `127.0.0.1`)
- `DB_PORT`: Database port (default: `3307`)
- `DB_USER`: Database user (default: `root`)
- `DB_PASSWORD`: Database password
- `DB_NAME`: Database name (default: `smedia`)
- `API_PORT`: Backend server port (default: `3001`)

---

## Development Conventions

### Architecture Patterns
- **Database Schema:** Articles are split into a general `artikel` table and specific detail tables (`buch_details`, `geraete_details`) to support different media types.
- **Exemplars:** Every physical item is a record in `artikel_exemplare`, identified by a unique `inventarnummer` and `barcode`.
- **Borrowing Logic:** Borrowers (Students, Teachers, Classes) are synchronized from their respective tables into a unified `ausleiher` table for consistent API handling.
- **History:** Almost every action (status change, loan, repair) is recorded in the `historie_eintraege` table.

### Code Style
- **Backend:** Uses ES Modules (`import/export`). Follows a functional approach with helper functions for mapping and calculations.
- **Frontend:** Uses Vue 3 `<script setup>` with the Composition API. Pinia stores are used for central data management (`inventarStore.js`).
- **Styling:** Preference for Vanilla CSS in `style.css` and scoped styles within Vue components.

### Testing
- Barcode testing resources are located in the `barcodes/` directory.
- Sample SQL data for local development is available in `sql/`.
