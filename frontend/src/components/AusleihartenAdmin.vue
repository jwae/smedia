<script setup>
import { computed, onMounted, ref } from "vue";

const props = defineProps({
  apiRequest: { type: Function, required: true }
});

const laedt = ref(true);
const speichert = ref(false);
const fehler = ref("");
const erfolg = ref("");
const eintraege = ref([]);
const ausgewaehlteId = ref(null);
const istNeu = ref(false);
const formular = ref({
  bezeichnung: "",
  aktiv: true,
  beschreibung: ""
});

const sortierteEintraege = computed(() =>
  [...eintraege.value].sort((a, b) => String(a.bezeichnung || "").localeCompare(String(b.bezeichnung || ""), "de"))
);

function setzeFormular(eintrag = null) {
  formular.value = {
    bezeichnung: eintrag?.bezeichnung || "",
    aktiv: eintrag?.aktiv ?? true,
    beschreibung: eintrag?.beschreibung || ""
  };
}

function waehleEintrag(eintrag) {
  istNeu.value = false;
  ausgewaehlteId.value = eintrag.id;
  setzeFormular(eintrag);
  fehler.value = "";
  erfolg.value = "";
}

function neuerEintrag() {
  istNeu.value = true;
  ausgewaehlteId.value = null;
  setzeFormular();
  fehler.value = "";
  erfolg.value = "";
}

async function ladeDaten(bevorzugteId = null) {
  laedt.value = true;
  fehler.value = "";

  try {
    const response = await props.apiRequest("/ausleiharten");
    eintraege.value = Array.isArray(response) ? response : [];

    if (bevorzugteId) {
      const ziel = eintraege.value.find((eintrag) => Number(eintrag.id) === Number(bevorzugteId));
      if (ziel) {
        waehleEintrag(ziel);
        return;
      }
    }

    if (!istNeu.value && eintraege.value.length > 0) {
      const bestehendeAuswahl = eintraege.value.find((eintrag) => Number(eintrag.id) === Number(ausgewaehlteId.value));
      waehleEintrag(bestehendeAuswahl || eintraege.value[0]);
      return;
    }

    if (eintraege.value.length === 0) {
      neuerEintrag();
    }
  } catch (error) {
    fehler.value = error.message;
  } finally {
    laedt.value = false;
  }
}

async function speichern() {
  fehler.value = "";
  erfolg.value = "";
  speichert.value = true;

  try {
    const payload = {
      bezeichnung: formular.value.bezeichnung,
      aktiv: formular.value.aktiv,
      beschreibung: formular.value.beschreibung
    };

    const response = istNeu.value
      ? await props.apiRequest("/ausleiharten", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload)
        })
      : await props.apiRequest(`/ausleiharten/${ausgewaehlteId.value}`, {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload)
        });

    erfolg.value = response.meldung || "Datensatz wurde gespeichert.";
    istNeu.value = false;
    await ladeDaten(response.datensatz?.id || null);
  } catch (error) {
    fehler.value = error.message;
  } finally {
    speichert.value = false;
  }
}

onMounted(() => {
  ladeDaten().catch(() => {});
});
</script>

<template>
  <div class="katalog-admin-stack">
    <p v-if="fehler" class="feedback error">{{ fehler }}</p>
    <p v-if="erfolg" class="feedback success">{{ erfolg }}</p>

    <div v-if="laedt" class="empty-state">Ausleiharten werden geladen...</div>

    <section v-else class="katalog-admin-layout">
      <aside class="einstellungen-records">
        <div class="einstellungen-records-head">
          <strong>{{ sortierteEintraege.length }} Eintraege</strong>
          <button
            type="button"
            class="secondary icon-toolbar-button"
            title="Neue Ausleihart"
            aria-label="Neue Ausleihart"
            @click="neuerEintrag"
          >
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <path d="M12 5v14M5 12h14" />
            </svg>
          </button>
        </div>

        <div v-if="sortierteEintraege.length === 0" class="empty-state katalog-empty-state">
          Noch keine Ausleiharten vorhanden.
        </div>

        <button
          v-for="eintrag in sortierteEintraege"
          :key="`ausleihart-${eintrag.id}`"
          type="button"
          :class="[
            'einstellungen-record',
            !istNeu && ausgewaehlteId === eintrag.id ? 'is-active' : '',
            eintrag.aktiv ? 'is-status-active' : 'is-status-inactive'
          ]"
          @click="waehleEintrag(eintrag)"
        >
          <span class="einstellungen-record-head">
            <span class="einstellungen-record-title">{{ eintrag.bezeichnung }}</span>
            <span class="record-meta-row">
              <span class="record-id-badge">ID {{ eintrag.id }}</span>
            </span>
          </span>
        </button>
      </aside>

      <div class="einstellungen-form-panel">
        <div class="einstellungen-stack">
          <article class="einstellungen-card">
            <h3>{{ istNeu ? "Neue Ausleihart" : "Ausleihart bearbeiten" }}</h3>

            <div class="form-grid">
              <label class="field">
                <span>Bezeichnung</span>
                <input v-model="formular.bezeichnung" type="text" maxlength="50" placeholder="z. B. klassensatz" />
              </label>

              <label class="field">
                <span>Aktiv</span>
                <div class="toggle-row">
                  <input id="ausleihart-aktiv" v-model="formular.aktiv" type="checkbox" class="toggle-input" />
                  <label for="ausleihart-aktiv" class="toggle-label"><span class="toggle-knob"></span></label>
                  <span class="toggle-text">{{ formular.aktiv ? "Ja" : "Nein" }}</span>
                </div>
              </label>

              <label class="field field-wide">
                <span>Beschreibung</span>
                <textarea
                  v-model="formular.beschreibung"
                  rows="4"
                  placeholder="Optionale Beschreibung der Ausleihart"
                ></textarea>
              </label>
            </div>
          </article>
        </div>

        <div class="button-row">
          <button class="primary" type="button" :disabled="speichert" @click="speichern">
            {{ speichert ? "Speichert..." : istNeu ? "Anlegen" : "Speichern" }}
          </button>
          <button class="delete-button" type="button" disabled>
            Loeschen
          </button>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.katalog-admin-stack {
  display: grid;
  gap: 18px;
}

.katalog-admin-layout {
  display: grid;
  grid-template-columns: minmax(240px, 300px) minmax(0, 1fr);
  gap: 20px;
}

.einstellungen-records {
  border-right: 1px solid rgba(36, 52, 71, 0.08);
  padding-right: 18px;
  display: grid;
  gap: 8px;
  align-content: start;
  max-height: 780px;
  overflow: auto;
}

.einstellungen-records-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  padding: 0 4px 6px;
}

.einstellungen-record {
  text-align: left;
  padding: 8px 12px;
  border-radius: 14px;
  display: block;
  transition: background 160ms ease, transform 160ms ease;
  border: 1px solid transparent;
}

.einstellungen-record:hover {
  transform: translateY(-1px);
}

.einstellungen-record.is-active {
  box-shadow: inset 0 0 0 2px rgba(23, 50, 74, 0.22);
}

.einstellungen-record.is-status-active {
  background: linear-gradient(180deg, rgba(42, 127, 98, 0.24), rgba(42, 127, 98, 0.16));
  border-color: rgba(42, 127, 98, 0.2);
}

.einstellungen-record.is-status-active:hover {
  background: linear-gradient(180deg, rgba(42, 127, 98, 0.3), rgba(42, 127, 98, 0.2));
}

.einstellungen-record.is-status-inactive {
  background: linear-gradient(180deg, rgba(157, 44, 48, 0.24), rgba(157, 44, 48, 0.16));
  border-color: rgba(157, 44, 48, 0.2);
}

.einstellungen-record.is-status-inactive:hover {
  background: linear-gradient(180deg, rgba(157, 44, 48, 0.3), rgba(157, 44, 48, 0.2));
}

.einstellungen-record-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.einstellungen-record-title {
  font-weight: 700;
  color: #17324a;
}

.record-meta-row {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}

.record-id-badge {
  flex-shrink: 0;
  padding: 4px 8px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.72);
  color: #17324a;
  font-size: 0.72rem;
  font-weight: 700;
}

.einstellungen-form-panel {
  min-width: 0;
}

.einstellungen-stack {
  display: grid;
  gap: 18px;
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

.icon-toolbar-button {
  width: 40px;
  min-width: 40px;
  height: 40px;
  padding: 0;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.icon-toolbar-button svg {
  width: 18px;
  height: 18px;
  fill: none;
  stroke: currentColor;
  stroke-width: 2.2;
  stroke-linecap: round;
}

.katalog-empty-state {
  min-height: 160px;
}

.delete-button {
  margin-left: auto;
  background: linear-gradient(180deg, #fff5f5, #fdeaea);
  border: 1px solid rgba(157, 44, 48, 0.26);
  color: #9d2c30;
}

.delete-button:hover:not(:disabled) {
  background: linear-gradient(180deg, #fdeaea, #f9d9d9);
}

@media (max-width: 1100px) {
  .katalog-admin-layout {
    grid-template-columns: 1fr;
  }

  .einstellungen-records {
    border-right: 0;
    border-bottom: 1px solid rgba(36, 52, 71, 0.08);
    padding-right: 0;
    padding-bottom: 18px;
    max-height: none;
  }
}
</style>
