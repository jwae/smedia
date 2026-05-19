<script setup>
import AusleihartenAdmin from "../components/AusleihartenAdmin.vue";
import GenericKatalogAdmin from "../components/GenericKatalogAdmin.vue";
import { useDbKataloge } from "../composables/useDbKataloge.js";
import ArtikelKategorienAdmin from "../components/ArtikelKategorienAdmin.vue";
import ArtikelAdmin from "../components/ArtikelAdmin.vue";
import VertragsvorlagenAdmin from "../components/VertragsvorlagenAdmin.vue";

const props = defineProps({
  apiRequest: { type: Function, required: true }
});

const { bereiche, aktiverBereich, aktiverEintrag, wechsleBereich } = useDbKataloge();

function tabellennameFuerBereich(bereichId) {
  return bereichId === "vertrags_vorlagen" ? "vertrags_vorlagen" : bereichId;
}

const faecherConfig = {
  endpoint: "/faecher",
  singularLabel: "Fach",
  pluralLabel: "Faecher",
  newLabel: "Neues Fach",
  editLabel: "Fach bearbeiten",
  titleKey: "bezeichnung",
  fields: [
    { key: "bezeichnung", label: "Bezeichnung", type: "text", maxlength: 100 },
    { key: "kuerzel", label: "Kuerzel", type: "text", maxlength: 10 },
    { key: "aktiv", label: "Aktiv", type: "toggle", defaultValue: true }
  ]
};

const herkunftConfig = {
  endpoint: "/herkunft",
  singularLabel: "Herkunft",
  pluralLabel: "Herkunft",
  newLabel: "Neue Herkunft",
  editLabel: "Herkunft bearbeiten",
  titleKey: "bezeichnung",
  fields: [
    { key: "bezeichnung", label: "Bezeichnung", type: "text", maxlength: 150 },
    { key: "aktiv", label: "Aktiv", type: "toggle", defaultValue: true },
    { key: "notiz", label: "Notiz", type: "textarea", wide: true, rows: 5 }
  ]
};

const inventarTypenConfig = {
  endpoint: "/inventar-typen",
  singularLabel: "Inventar-Typ",
  pluralLabel: "Inventar-Typen",
  newLabel: "Neuer Inventar-Typ",
  editLabel: "Inventar-Typ bearbeiten",
  titleKey: "bezeichnung",
  resources: [{ key: "ausleiharten", path: "/ausleiharten" }],
  fields: [
    { key: "bezeichnung", label: "Bezeichnung", type: "text", maxlength: 50 },
    { key: "ausleihart_id", label: "Ausleihart", type: "select", optionsKey: "ausleiharten", optionLabel: "bezeichnung", optionValue: "id" },
    { key: "aktiv", label: "Aktiv", type: "toggle", defaultValue: true },
    { key: "beschreibung", label: "Beschreibung", type: "textarea", wide: true, rows: 4 }
  ]
};

const standorteConfig = {
  endpoint: "/standorte",
  singularLabel: "Standort",
  pluralLabel: "Standorte",
  newLabel: "Neuer Standort",
  editLabel: "Standort bearbeiten",
  titleKey: "bezeichnung",
  resources: [{ key: "standorte", path: "/standorte" }],
  fields: [
    { key: "bezeichnung", label: "Bezeichnung", type: "text", maxlength: 100 },
    { key: "standort_typ", label: "Standort-Typ", type: "text", maxlength: 50 },
    { key: "parent_id", label: "Parent-Standort", type: "select", optionsKey: "standorte", optionLabel: "bezeichnung", optionValue: "id" },
    { key: "aktiv", label: "Aktiv", type: "toggle", defaultValue: true },
    { key: "beschreibung", label: "Beschreibung", type: "textarea", wide: true, rows: 4 }
  ]
};

const statuskatalogConfig = {
  endpoint: "/statuskatalog",
  singularLabel: "Status",
  pluralLabel: "Statuskatalog",
  newLabel: "Neuer Status",
  editLabel: "Status bearbeiten",
  titleKey: "bezeichnung",
  fields: [
    { key: "bezeichnung", label: "Bezeichnung", type: "text", maxlength: 50 },
    { key: "aktiv", label: "Aktiv", type: "toggle", defaultValue: true },
    { key: "ist_ausleihbar", label: "Ist ausleihbar", type: "toggle", defaultValue: false },
    { key: "beschreibung", label: "Beschreibung", type: "textarea", wide: true, rows: 4 }
  ]
};

const zustandskatalogConfig = {
  endpoint: "/zustandskatalog",
  singularLabel: "Zustand",
  pluralLabel: "Zustandskatalog",
  newLabel: "Neuer Zustand",
  editLabel: "Zustand bearbeiten",
  titleKey: "bezeichnung",
  fields: [
    { key: "bezeichnung", label: "Bezeichnung", type: "text", maxlength: 50 },
    { key: "aktiv", label: "Aktiv", type: "toggle", defaultValue: true },
    { key: "sortierung", label: "Sortierung", type: "text", maxlength: 11 },
    { key: "beschreibung", label: "Beschreibung", type: "textarea", wide: true, rows: 4 }
  ]
};
</script>

<template>
  <section class="einstellungen-layout">
    <aside class="panel einstellungen-nav-panel">
      <p class="eyebrow einstellungen-eyebrow">DB</p>
      <h2>DB-Kataloge</h2>

      <nav class="einstellungen-nav" aria-label="DB-Kataloge">
        <button
          v-for="bereich in bereiche"
          :key="bereich.id"
          type="button"
          :class="['einstellungen-link', aktiverBereich === bereich.id ? 'is-active' : '', 'is-katalog']"
          @click="wechsleBereich(bereich.id)"
        >
          <span class="einstellungen-link-title">{{ bereich.label }}</span>
          <span class="einstellungen-link-copy">{{ bereich.beschreibung }}</span>
        </button>
      </nav>
    </aside>

    <section class="panel einstellungen-detail-panel">
      <header class="einstellungen-detail-head">
        <div>
          <p class="eyebrow einstellungen-eyebrow">Katalog</p>
          <h2>{{ aktiverEintrag.label }}</h2>
          <p class="einstellungen-intro">{{ aktiverEintrag.beschreibung }}</p>
        </div>
        <div class="status-pill">Katalog</div>
      </header>

      <template v-if="aktiverBereich === 'vertrags_vorlagen'">
        <div class="db-content">
          <VertragsvorlagenAdmin :api-request="props.apiRequest" />
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'artikel_kategorie'">
        <div class="db-content">
          <ArtikelKategorienAdmin :api-request="props.apiRequest" />
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'ausleiharten'">
        <div class="db-content">
          <AusleihartenAdmin :api-request="props.apiRequest" />
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'artikel'">
        <div class="db-content">
          <ArtikelAdmin :api-request="props.apiRequest" />
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'faecher'">
        <div class="db-content">
          <GenericKatalogAdmin v-bind="faecherConfig" :api-request="props.apiRequest" />
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'herkunft'">
        <div class="db-content">
          <GenericKatalogAdmin v-bind="herkunftConfig" :api-request="props.apiRequest" />
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'inventar_typen'">
        <div class="db-content">
          <GenericKatalogAdmin v-bind="inventarTypenConfig" :api-request="props.apiRequest" />
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'standorte'">
        <div class="db-content">
          <GenericKatalogAdmin v-bind="standorteConfig" :api-request="props.apiRequest" />
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'statuskatalog'">
        <div class="db-content">
          <GenericKatalogAdmin v-bind="statuskatalogConfig" :api-request="props.apiRequest" />
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'zustandskatalog'">
        <div class="db-content">
          <GenericKatalogAdmin v-bind="zustandskatalogConfig" :api-request="props.apiRequest" />
        </div>
      </template>

      <template v-else>
        <div class="db-content">
          <article class="einstellungen-card">
            <h3>{{ aktiverEintrag.label }}</h3>
            <p class="einstellungen-intro">
              Die Pflegeoberflaeche fuer <code>{{ tabellennameFuerBereich(aktiverBereich) }}</code> ist als eigener
              DB-Bereich vorbereitet und kann hier im gleichen Muster wie bei den bisherigen Systembereichen erweitert
              werden.
            </p>
          </article>
        </div>
      </template>
    </section>
  </section>
</template>

<style scoped>
.einstellungen-layout {
  display: grid;
  grid-template-columns: minmax(260px, 320px) minmax(0, 1fr);
  gap: 20px;
  align-items: start;
}

.einstellungen-nav-panel,
.einstellungen-detail-panel {
  min-height: 720px;
}

.einstellungen-nav-panel {
  position: sticky;
  top: 24px;
  max-height: calc(100vh - 48px);
  display: flex;
  flex-direction: column;
}

.einstellungen-eyebrow {
  margin-bottom: 10px;
}

.einstellungen-intro {
  margin: 10px 0 0;
  color: rgba(36, 52, 71, 0.72);
}

.einstellungen-nav {
  margin-top: 22px;
  display: grid;
  gap: 6px;
  overflow-y: auto;
}

.einstellungen-link {
  text-align: left;
  padding: 8px 14px;
  border-radius: 12px;
  background: rgba(36, 52, 71, 0.05);
  border: 1px solid transparent;
  display: grid;
  gap: 2px;
  transition: background 160ms ease, border-color 160ms ease, transform 160ms ease;
}

.einstellungen-link:hover {
  transform: translateY(-1px);
  background: rgba(36, 52, 71, 0.08);
}

.einstellungen-link.is-active {
  background: linear-gradient(180deg, rgba(42, 157, 143, 0.16), rgba(42, 157, 143, 0.08));
  border-color: rgba(42, 157, 143, 0.24);
}

.einstellungen-link.is-katalog {
  background: rgba(42, 157, 143, 0.15);
}

.einstellungen-link.is-katalog:hover {
  background: rgba(42, 157, 143, 0.22);
}

.einstellungen-link.is-katalog.is-active {
  background: linear-gradient(180deg, rgba(42, 157, 143, 0.32), rgba(42, 157, 143, 0.2));
  border-color: rgba(42, 157, 143, 0.4);
}

.einstellungen-link-title {
  font-weight: 700;
  color: #17324a;
}

.einstellungen-link-copy {
  font-size: 0.88rem;
  color: rgba(36, 52, 71, 0.68);
}

.einstellungen-detail-head {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  align-items: flex-start;
  padding-bottom: 18px;
  border-bottom: 1px solid rgba(36, 52, 71, 0.08);
}

.status-pill {
  white-space: nowrap;
  padding: 8px 12px;
  border-radius: 999px;
  background: rgba(244, 162, 97, 0.14);
  color: #9a5a16;
  font-weight: 700;
  font-size: 0.84rem;
}

.db-content {
  margin-top: 22px;
}

.einstellungen-card {
  border: 1px solid rgba(36, 52, 71, 0.08);
  border-radius: 22px;
  padding: 20px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.92), rgba(245, 250, 252, 0.9));
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.8);
}

.einstellungen-card h3 {
  margin: 0 0 14px;
}

@media (max-width: 1100px) {
  .einstellungen-layout {
    grid-template-columns: 1fr;
  }

  .einstellungen-nav-panel {
    position: static;
    min-height: auto;
  }

  .einstellungen-detail-panel {
    min-height: auto;
  }
}
</style>
