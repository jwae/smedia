<script setup>
import { computed, ref, watch } from "vue";
import { storeToRefs } from "pinia";
import { useInventarStore } from "../stores/inventarStore.js";

const apiBase = "/api";

const props = defineProps({
  artikel: { type: Array, required: true },
  exemplare: { type: Array, required: true },
  apiRequest: { type: Function, required: true }
});

const emit = defineEmits(["zeige-erfolg", "zeige-fehler"]);

const inventarStore = useInventarStore();
const { klassenAusleiher } = storeToRefs(inventarStore);

const formular = ref({
  klasse_ausleiher_id: "",
  artikel_id: "",
  faellig_am: "",
  kommentar_ausgabe: ""
});

const laedtVorschlag = ref(false);
const speichertZuordnung = ref(false);
const drucktZuordnung = ref(false);
const vorschau = ref(null);
const gespeicherteZuordnung = ref(null);

const verfuegbareArtikel = computed(() => {
  const verfuegbareArtikelIds = new Set(
    props.exemplare
      .filter((eintrag) => eintrag.status === "verfuegbar")
      .map((eintrag) => Number(eintrag.artikel_id))
  );

  return props.artikel
    .filter((eintrag) => eintrag.aktiv && verfuegbareArtikelIds.has(Number(eintrag.id)))
    .sort((links, rechts) => String(links.titel || "").localeCompare(String(rechts.titel || ""), "de"));
});

const ausgewaehlteKlasse = computed(
  () => klassenAusleiher.value.find((eintrag) => Number(eintrag.id) === Number(formular.value.klasse_ausleiher_id)) || null
);

const ausgewaehlterArtikel = computed(
  () => props.artikel.find((eintrag) => Number(eintrag.id) === Number(formular.value.artikel_id)) || null
);

const kannVorschlagErzeugen = computed(
  () => Boolean(formular.value.klasse_ausleiher_id) && Boolean(formular.value.artikel_id)
);

const hatVorschlaegeZumSpeichern = computed(
  () => (vorschau.value?.zeilen || []).some((eintrag) => eintrag.aktiv && eintrag.aktivierbar)
);

const kannDrucken = computed(() => Boolean(gespeicherteZuordnung.value?.zeilen?.length));

function setzeVorschau(daten) {
  vorschau.value = {
    ...daten,
    zeilen: (daten.zeilen || []).map((eintrag, index) => ({
      ...eintrag,
      listen_id: eintrag.listen_id || `zeile-${index + 1}`
    }))
  };
}

function zuruecksetzen() {
  vorschau.value = null;
  gespeicherteZuordnung.value = null;
}

function statusText(eintrag) {
  if (gespeicherteZuordnung.value) {
    return eintrag.status;
  }

  if (eintrag.status === "vorgeschlagen" && !eintrag.aktiv) {
    return "deaktiviert";
  }

  return eintrag.status;
}

function statusKlasse(eintrag) {
  const status = statusText(eintrag);
  return {
    "is-ok": ["vorgeschlagen", "zugeordnet"].includes(status),
    "is-muted": ["deaktiviert", "bereits ausgeliehen"].includes(status),
    "is-warning": status === "nicht versorgt"
  };
}

function toggleZeile(zeile) {
  if (!zeile.aktivierbar || gespeicherteZuordnung.value) {
    return;
  }

  zeile.aktiv = !zeile.aktiv;
}

async function vorschlagErzeugen() {
  if (!kannVorschlagErzeugen.value) {
    emit("zeige-fehler", "Bitte zuerst Klasse und Artikel auswaehlen.");
    return;
  }

  laedtVorschlag.value = true;
  emit("zeige-fehler", "");
  emit("zeige-erfolg", "");

  try {
    const daten = await props.apiRequest("/ausgabe-assistent/vorschau", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        klasse_ausleiher_id: Number(formular.value.klasse_ausleiher_id),
        artikel_id: Number(formular.value.artikel_id)
      })
    });

    setzeVorschau(daten);
    gespeicherteZuordnung.value = null;
    emit(
      "zeige-erfolg",
      `${daten.statistik.zugeordnet} Vorschlaege erstellt, ${daten.statistik.nicht_versorgt} nicht versorgt.`
    );
  } catch (error) {
    vorschau.value = null;
    gespeicherteZuordnung.value = null;
    emit("zeige-fehler", error.message);
  } finally {
    laedtVorschlag.value = false;
  }
}

async function vorschlagAkzeptieren() {
  if (!vorschau.value) {
    emit("zeige-fehler", "Bitte zuerst einen Vorschlag erzeugen.");
    return;
  }

  speichertZuordnung.value = true;
  emit("zeige-fehler", "");
  emit("zeige-erfolg", "");

  try {
    const daten = await props.apiRequest("/ausgabe-assistent/uebernehmen", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        klasse_ausleiher_id: Number(formular.value.klasse_ausleiher_id),
        artikel_id: Number(formular.value.artikel_id),
        faellig_am: formular.value.faellig_am || null,
        kommentar_ausgabe: formular.value.kommentar_ausgabe || null,
        zeilen: vorschau.value.zeilen.map((eintrag) => ({
          listen_id: eintrag.listen_id,
          schueler_ausleiher_id: eintrag.schueler_ausleiher_id,
          schueler_name: eintrag.schueler_name,
          klasse: eintrag.klasse,
          exemplar_id: eintrag.exemplar_id,
          inventarnummer: eintrag.inventarnummer,
          seriennummer: eintrag.seriennummer,
          barcode: eintrag.barcode,
          status: statusText(eintrag),
          aktiv: Boolean(eintrag.aktiv),
          aktivierbar: Boolean(eintrag.aktivierbar),
          bestehende_ausleihe: eintrag.bestehende_ausleihe || null
        }))
      })
    });

    gespeicherteZuordnung.value = daten;
    setzeVorschau(daten);
    emit("zeige-erfolg", daten.meldung);
  } catch (error) {
    emit("zeige-fehler", error.message);
  } finally {
    speichertZuordnung.value = false;
  }
}

async function zuordnungDrucken() {
  if (!gespeicherteZuordnung.value) {
    emit("zeige-fehler", "Bitte zuerst den Vorschlag akzeptieren.");
    return;
  }

  drucktZuordnung.value = true;
  emit("zeige-fehler", "");

  try {
    const response = await fetch(`${apiBase}/ausgabe-assistent/druck`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        klasse_name: gespeicherteZuordnung.value.klasse_name,
        artikel_titel: gespeicherteZuordnung.value.artikel_titel,
        faellig_am: gespeicherteZuordnung.value.faellig_am || null,
        kommentar_ausgabe: gespeicherteZuordnung.value.kommentar_ausgabe || null,
        zeilen: gespeicherteZuordnung.value.zeilen
      })
    });

    if (!response.ok) {
      let fehlermeldung = "PDF konnte nicht erzeugt werden.";
      try {
        const daten = await response.json();
        fehlermeldung = daten?.fehler || fehlermeldung;
      } catch {
        // Fallback.
      }
      throw new Error(fehlermeldung);
    }

    const blob = await response.blob();
    const objektUrl = URL.createObjectURL(blob);
    window.open(objektUrl, "_blank", "noopener");
    window.setTimeout(() => URL.revokeObjectURL(objektUrl), 60_000);
  } catch (error) {
    emit("zeige-fehler", error.message);
  } finally {
    drucktZuordnung.value = false;
  }
}

watch(
  () => [formular.value.klasse_ausleiher_id, formular.value.artikel_id],
  () => {
    zuruecksetzen();
  }
);
</script>

<template>
  <section class="ausgabe-assistent">
    <header class="medien-detail-head">
      <div>
        <p class="eyebrow medien-eyebrow">Bereich</p>
        <h2>Ausgabe-Assistent</h2>
        <p class="medien-intro">Gleichartige Artikel schnell und nachvollziehbar an eine komplette Klasse verteilen.</p>
      </div>
    </header>

    <div class="form-grid">
      <label class="field">
        <span>Klasse</span>
        <select v-model="formular.klasse_ausleiher_id">
          <option value="">Bitte waehlen</option>
          <option v-for="eintrag in klassenAusleiher" :key="eintrag.id" :value="eintrag.id">
            {{ eintrag.name }}
          </option>
        </select>
      </label>

      <label class="field">
        <span>Artikel</span>
        <select v-model="formular.artikel_id">
          <option value="">Bitte waehlen</option>
          <option v-for="eintrag in verfuegbareArtikel" :key="eintrag.id" :value="eintrag.id">
            {{ eintrag.titel }}
          </option>
        </select>
      </label>

      <label class="field">
        <span>Faellig am</span>
        <input v-model="formular.faellig_am" type="date" />
      </label>

      <label class="field field-wide">
        <span>Kommentar zur Ausgabe</span>
        <textarea v-model="formular.kommentar_ausgabe" rows="2" placeholder="Optionaler Kommentar fuer alle neu erzeugten Ausleihen"></textarea>
      </label>
    </div>

    <div class="button-row ausgabe-assistent-actions">
      <button class="primary" type="button" :disabled="laedtVorschlag || !kannVorschlagErzeugen" @click="vorschlagErzeugen">
        {{ laedtVorschlag ? "Vorschlag wird erzeugt..." : "Vorschlag erzeugen" }}
      </button>
      <button class="primary" type="button" :disabled="speichertZuordnung || !vorschau || !hatVorschlaegeZumSpeichern || Boolean(gespeicherteZuordnung)" @click="vorschlagAkzeptieren">
        {{ speichertZuordnung ? "Zuordnung wird gespeichert..." : "Vorschlag akzeptieren" }}
      </button>
      <button class="ghost" type="button" :disabled="drucktZuordnung || !kannDrucken" @click="zuordnungDrucken">
        {{ drucktZuordnung ? "PDF wird erzeugt..." : "Zuordnung drucken" }}
      </button>
    </div>

    <div v-if="!vorschau" class="empty-state">
      Klasse und Artikel waehlen und dann einen Vorschlag erzeugen.
    </div>

    <template v-else>
      <div class="ausgabe-assistent-summary">
        <article class="summary-card">
          <span>Klasse</span>
          <strong>{{ vorschau.klasse_name || ausgewaehlteKlasse?.name || "-" }}</strong>
        </article>
        <article class="summary-card">
          <span>Artikel</span>
          <strong>{{ vorschau.artikel_titel || ausgewaehlterArtikel?.titel || "-" }}</strong>
        </article>
        <article class="summary-card">
          <span>Vorgeschlagen</span>
          <strong>{{ vorschau.statistik?.zugeordnet || 0 }}</strong>
        </article>
        <article class="summary-card">
          <span>Nicht versorgt</span>
          <strong>{{ vorschau.statistik?.nicht_versorgt || 0 }}</strong>
        </article>
      </div>

      <div class="table-shell inventar-table-shell geraete-table-shell">
        <table class="geraete-table ausgabe-assistent-table">
          <thead>
            <tr>
              <th class="col-action">Aktiv</th>
              <th>Schueler</th>
              <th>Klasse</th>
              <th>Exemplar</th>
              <th>Seriennummer</th>
              <th>Barcode</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="eintrag in vorschau.zeilen" :key="eintrag.listen_id">
              <td class="col-action">
                <input
                  type="checkbox"
                  :checked="Boolean(eintrag.aktiv)"
                  :disabled="!eintrag.aktivierbar || Boolean(gespeicherteZuordnung)"
                  @change="toggleZeile(eintrag)"
                />
              </td>
              <td>{{ eintrag.schueler_name }}</td>
              <td>{{ eintrag.klasse }}</td>
              <td>
                <span :title="eintrag.bestehende_ausleihe_tooltip || ''">
                  {{ eintrag.inventarnummer || "-" }}
                </span>
              </td>
              <td>
                <span :title="eintrag.bestehende_ausleihe_tooltip || ''">
                  {{ eintrag.seriennummer || "-" }}
                </span>
              </td>
              <td>{{ eintrag.barcode || "-" }}</td>
              <td>
                <span class="inventar-status" :class="statusKlasse(eintrag)" :title="eintrag.bestehende_ausleihe_tooltip || ''">
                  {{ statusText(eintrag) }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </template>
  </section>
</template>

<style scoped>
.ausgabe-assistent {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.ausgabe-assistent-actions {
  justify-content: flex-start;
}

.ausgabe-assistent-summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 12px;
}

.summary-card {
  border: 1px solid rgba(36, 52, 71, 0.12);
  border-radius: 14px;
  padding: 14px 16px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.98), rgba(246, 248, 251, 0.94));
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.summary-card span {
  font-size: 0.82rem;
  color: rgba(36, 52, 71, 0.58);
}

.summary-card strong {
  font-size: 1rem;
  color: #243447;
}

.ausgabe-assistent-table .inventar-status.is-ok {
  background: rgba(28, 126, 84, 0.12);
  color: #166646;
}

.ausgabe-assistent-table .inventar-status.is-muted {
  background: rgba(89, 102, 117, 0.12);
  color: #596675;
}

.ausgabe-assistent-table .inventar-status.is-warning {
  background: rgba(201, 124, 23, 0.14);
  color: #995c0a;
}

@media (max-width: 900px) {
  .ausgabe-assistent-actions {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
