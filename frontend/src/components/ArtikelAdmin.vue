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
const inventarTypen = ref([]);
const herkunft = ref([]);
const artikelKategorien = ref([]);
const ausgewaehlteId = ref(null);
const istNeu = ref(false);
const formular = ref({
  inventar_typ_id: "",
  titel: "",
  interne_bezeichnung: "",
  hersteller: "",
  modellbezeichnung: "",
  artikel_kategorie_id: "",
  herkunft_id: "",
  beschreibung: "",
  aktiv: true
});

const sortierteEintraege = computed(() =>
  [...eintraege.value].sort((a, b) => String(a.titel || "").localeCompare(String(b.titel || ""), "de"))
);

function setzeFormular(eintrag = null) {
  formular.value = {
    inventar_typ_id: eintrag?.inventar_typ_id ?? "",
    titel: eintrag?.titel || "",
    interne_bezeichnung: eintrag?.interne_bezeichnung || "",
    hersteller: eintrag?.hersteller || "",
    modellbezeichnung: eintrag?.modellbezeichnung || "",
    artikel_kategorie_id: eintrag?.artikel_kategorie_id ?? "",
    herkunft_id: eintrag?.herkunft_id ?? "",
    beschreibung: eintrag?.beschreibung || "",
    aktiv: eintrag?.aktiv ?? true
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
    const [artikelResponse, inventarTypenResponse, herkunftResponse, artikelKategorienResponse] = await Promise.all([
      props.apiRequest("/artikel"),
      props.apiRequest("/inventar-typen"),
      props.apiRequest("/herkunft"),
      props.apiRequest("/artikel-kategorien")
    ]);

    eintraege.value = Array.isArray(artikelResponse) ? artikelResponse : [];
    inventarTypen.value = Array.isArray(inventarTypenResponse) ? inventarTypenResponse : [];
    herkunft.value = Array.isArray(herkunftResponse) ? herkunftResponse : [];
    artikelKategorien.value = Array.isArray(artikelKategorienResponse) ? artikelKategorienResponse : [];

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
      inventar_typ_id: formular.value.inventar_typ_id || null,
      titel: formular.value.titel,
      interne_bezeichnung: formular.value.interne_bezeichnung || null,
      beschreibung: formular.value.beschreibung || null,
      hersteller: formular.value.hersteller || null,
      modellbezeichnung: formular.value.modellbezeichnung || null,
      herkunft_id: formular.value.herkunft_id || null,
      artikel_kategorie_id: formular.value.artikel_kategorie_id || null,
      aktiv: formular.value.aktiv
    };

    const response = istNeu.value
      ? await props.apiRequest("/artikel", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload)
        })
      : await props.apiRequest(`/artikel/${ausgewaehlteId.value}`, {
          method: "PATCH",
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

    <div v-if="laedt" class="empty-state">Artikel werden geladen...</div>

    <section v-else class="katalog-admin-layout">
      <aside class="einstellungen-records">
        <div class="einstellungen-records-head">
          <strong>{{ sortierteEintraege.length }} Eintraege</strong>
          <button
            type="button"
            class="secondary icon-toolbar-button"
            title="Neuer Artikel"
            aria-label="Neuer Artikel"
            @click="neuerEintrag"
          >
            <svg viewBox="0 0 24 24" aria-hidden="true">
              <path d="M12 5v14M5 12h14" />
            </svg>
          </button>
        </div>

        <div v-if="sortierteEintraege.length === 0" class="empty-state katalog-empty-state">
          Noch keine Artikel vorhanden.
        </div>

        <button
          v-for="eintrag in sortierteEintraege"
          :key="`artikel-${eintrag.id}`"
          type="button"
          :class="[
            'einstellungen-record',
            !istNeu && ausgewaehlteId === eintrag.id ? 'is-active' : '',
            eintrag.aktiv ? 'is-status-active' : 'is-status-inactive'
          ]"
          @click="waehleEintrag(eintrag)"
        >
          <span class="einstellungen-record-head">
            <span class="einstellungen-record-title">{{ eintrag.titel }}</span>
            <span class="record-meta-row">
              <span class="record-id-badge">ID {{ eintrag.id }}</span>
            </span>
          </span>
        </button>
      </aside>

      <div class="einstellungen-form-panel">
        <div class="einstellungen-stack">
          <article class="einstellungen-card">
            <h3>{{ istNeu ? "Neuer Artikel" : "Artikel bearbeiten" }}</h3>

            <div class="form-grid">
              <label class="field">
                <span>Inventar-Typ</span>
                <select v-model="formular.inventar_typ_id">
                  <option value="">- bitte waehlen -</option>
                  <option v-for="typ in inventarTypen" :key="`typ-${typ.id}`" :value="typ.id">
                    {{ typ.bezeichnung }}
                  </option>
                </select>
              </label>

              <label class="field field-wide">
                <span>Titel</span>
                <input v-model="formular.titel" type="text" maxlength="255" placeholder="z. B. iPad 10. Gen" />
              </label>

              <label class="field">
                <span>Interne Bezeichnung</span>
                <input v-model="formular.interne_bezeichnung" type="text" maxlength="255" />
              </label>

              <label class="field">
                <span>Hersteller</span>
                <input v-model="formular.hersteller" type="text" maxlength="150" />
              </label>

              <label class="field">
                <span>Modellbezeichnung</span>
                <input v-model="formular.modellbezeichnung" type="text" maxlength="150" />
              </label>

              <label class="field">
                <span>Artikel-Kategorie</span>
                <select v-model="formular.artikel_kategorie_id">
                  <option value="">- bitte waehlen -</option>
                  <option v-for="kategorie in artikelKategorien" :key="`kat-${kategorie.id}`" :value="kategorie.id">
                    {{ kategorie.kategorie }}
                  </option>
                </select>
              </label>

              <label class="field">
                <span>Herkunft</span>
                <select v-model="formular.herkunft_id">
                  <option value="">- bitte waehlen -</option>
                  <option v-for="eintrag in herkunft" :key="`herkunft-${eintrag.id}`" :value="eintrag.id">
                    {{ eintrag.bezeichnung }}
                  </option>
                </select>
              </label>

              <label class="field">
                <span>Aktiv</span>
                <div class="toggle-row">
                  <input id="artikel-db-aktiv" v-model="formular.aktiv" type="checkbox" class="toggle-input" />
                  <label for="artikel-db-aktiv" class="toggle-label"><span class="toggle-knob"></span></label>
                  <span class="toggle-text">{{ formular.aktiv ? "Ja" : "Nein" }}</span>
                </div>
              </label>

              <label class="field field-wide">
                <span>Beschreibung</span>
                <textarea v-model="formular.beschreibung" rows="4" placeholder="Optionale Beschreibung"></textarea>
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
