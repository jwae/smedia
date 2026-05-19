<script setup>
import { computed, ref, watch } from "vue";
import { storeToRefs } from "pinia";
import { useInventarStore } from "../stores/inventarStore.js";

const apiBase = "/api";

const props = defineProps({
  artikel: { type: Array, required: true },
  offeneAusleihen: { type: Array, required: true },
  apiRequest: { type: Function, required: true }
});

const emit = defineEmits(["zeige-erfolg", "zeige-fehler"]);

const inventarStore = useInventarStore();
const { klassenAusleiher } = storeToRefs(inventarStore);

const formular = ref({
  klasse_ausleiher_id: "",
  artikel_id: "",
  zustand_bei_rueckgabe: "gut",
  kommentar_rueckgabe: ""
});

const laedtVorschlag = ref(false);
const speichertStorno = ref(false);
const drucktStorno = ref(false);
const vorschau = ref(null);
const gespeicherterStorno = ref(null);

const stornierbareArtikel = computed(() => {
  const artikelIdsMitOffenenAusleihen = new Set(
    props.offeneAusleihen
      .map((eintrag) => Number(eintrag.artikel_id))
      .filter(Boolean)
  );

  return props.artikel
    .filter((eintrag) => eintrag.aktiv && artikelIdsMitOffenenAusleihen.has(Number(eintrag.id)))
    .sort((links, rechts) => String(links.titel || "").localeCompare(String(rechts.titel || ""), "de"));
});

const kannVorschlagErzeugen = computed(
  () => Boolean(formular.value.klasse_ausleiher_id) && Boolean(formular.value.artikel_id)
);

const hatStornierbareZeilen = computed(
  () => (vorschau.value?.zeilen || []).some((eintrag) => eintrag.aktiv && eintrag.aktivierbar)
);

const kannDrucken = computed(() => Boolean(gespeicherterStorno.value?.zeilen?.length));

function setzeVorschau(daten) {
  vorschau.value = {
    ...daten,
    zeilen: (daten.zeilen || []).map((eintrag, index) => ({
      ...eintrag,
      listen_id: eintrag.listen_id || `storno-${index + 1}`
    }))
  };
}

function zuruecksetzen() {
  vorschau.value = null;
  gespeicherterStorno.value = null;
}

function statusText(eintrag) {
  if (gespeicherterStorno.value) {
    return eintrag.status;
  }

  if (eintrag.status === "offene Buchung" && !eintrag.aktiv) {
    return "deaktiviert";
  }

  return eintrag.status;
}

function statusKlasse(eintrag) {
  const status = statusText(eintrag);
  return {
    "is-ok": ["offene Buchung", "storniert"].includes(status),
    "is-muted": ["deaktiviert"].includes(status),
    "is-warning": ["keine offene Buchung"].includes(status)
  };
}

function toggleZeile(zeile) {
  if (!zeile.aktivierbar || gespeicherterStorno.value) {
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
    const daten = await props.apiRequest("/storno-assistent/vorschau", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        klasse_ausleiher_id: Number(formular.value.klasse_ausleiher_id),
        artikel_id: Number(formular.value.artikel_id)
      })
    });

    setzeVorschau(daten);
    gespeicherterStorno.value = null;
    emit(
      "zeige-erfolg",
      `${daten.statistik.offene_buchungen} offene Buchungen gefunden, ${daten.statistik.keine_offene_buchung} ohne Treffer.`
    );
  } catch (error) {
    vorschau.value = null;
    gespeicherterStorno.value = null;
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

  speichertStorno.value = true;
  emit("zeige-fehler", "");
  emit("zeige-erfolg", "");

  try {
    const daten = await props.apiRequest("/storno-assistent/uebernehmen", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        klasse_ausleiher_id: Number(formular.value.klasse_ausleiher_id),
        artikel_id: Number(formular.value.artikel_id),
        zustand_bei_rueckgabe: formular.value.zustand_bei_rueckgabe,
        kommentar_rueckgabe: formular.value.kommentar_rueckgabe || null,
        zeilen: vorschau.value.zeilen.map((eintrag) => ({
          listen_id: eintrag.listen_id,
          ausleihe_id: eintrag.ausleihe_id,
          schueler_ausleiher_id: eintrag.schueler_ausleiher_id,
          schueler_name: eintrag.schueler_name,
          klasse: eintrag.klasse,
          inventarnummer: eintrag.inventarnummer,
          seriennummer: eintrag.seriennummer,
          barcode: eintrag.barcode,
          status: statusText(eintrag),
          aktiv: Boolean(eintrag.aktiv),
          aktivierbar: Boolean(eintrag.aktivierbar)
        }))
      })
    });

    gespeicherterStorno.value = daten;
    setzeVorschau(daten);
    emit("zeige-erfolg", daten.meldung);
  } catch (error) {
    emit("zeige-fehler", error.message);
  } finally {
    speichertStorno.value = false;
  }
}

async function stornoDrucken() {
  if (!gespeicherterStorno.value) {
    emit("zeige-fehler", "Bitte zuerst den Vorschlag akzeptieren.");
    return;
  }

  drucktStorno.value = true;
  emit("zeige-fehler", "");

  try {
    const response = await fetch(`${apiBase}/storno-assistent/druck`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        klasse_name: gespeicherterStorno.value.klasse_name,
        artikel_titel: gespeicherterStorno.value.artikel_titel,
        kommentar_rueckgabe: gespeicherterStorno.value.kommentar_rueckgabe || null,
        zustand_bei_rueckgabe: gespeicherterStorno.value.zustand_bei_rueckgabe || null,
        zeilen: gespeicherterStorno.value.zeilen
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
    drucktStorno.value = false;
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
  <section class="storno-assistent">
    <header class="medien-detail-head">
      <div>
        <p class="eyebrow medien-eyebrow">Bereich</p>
        <h2>Storno-Assistent</h2>
        <p class="medien-intro">Offene Buchungen eines Artikels klassenweise pruefen und gesammelt aufheben.</p>
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
          <option v-for="eintrag in stornierbareArtikel" :key="eintrag.id" :value="eintrag.id">
            {{ eintrag.titel }}
          </option>
        </select>
      </label>

      <label class="field">
        <span>Rueckgabezustand</span>
        <select v-model="formular.zustand_bei_rueckgabe">
          <option value="neu">neu</option>
          <option value="sehr_gut">sehr_gut</option>
          <option value="gut">gut</option>
          <option value="gebraucht">gebraucht</option>
          <option value="beschaedigt">beschaedigt</option>
          <option value="unvollstaendig">unvollstaendig</option>
        </select>
      </label>

      <label class="field field-wide">
        <span>Kommentar zur Rueckgabe</span>
        <textarea v-model="formular.kommentar_rueckgabe" rows="2" placeholder="Optionaler Kommentar fuer alle aufgehobenen Buchungen"></textarea>
      </label>
    </div>

    <div class="button-row storno-assistent-actions">
      <button class="primary" type="button" :disabled="laedtVorschlag || !kannVorschlagErzeugen" @click="vorschlagErzeugen">
        {{ laedtVorschlag ? "Buchungen werden geladen..." : "Buchungen anzeigen" }}
      </button>
      <button class="primary" type="button" :disabled="speichertStorno || !vorschau || !hatStornierbareZeilen || Boolean(gespeicherterStorno)" @click="vorschlagAkzeptieren">
        {{ speichertStorno ? "Storno wird gespeichert..." : "Storno akzeptieren" }}
      </button>
      <button class="ghost" type="button" :disabled="drucktStorno || !kannDrucken" @click="stornoDrucken">
        {{ drucktStorno ? "PDF wird erzeugt..." : "Stornoliste drucken" }}
      </button>
    </div>

    <div v-if="!vorschau" class="empty-state">
      Klasse und Artikel waehlen und dann einen Vorschlag erzeugen.
    </div>

    <template v-else>
      <div class="storno-assistent-summary">
        <article class="summary-card">
          <span>Klasse</span>
          <strong>{{ vorschau.klasse_name || "-" }}</strong>
        </article>
        <article class="summary-card">
          <span>Artikel</span>
          <strong>{{ vorschau.artikel_titel || "-" }}</strong>
        </article>
        <article class="summary-card">
          <span>Offene Buchungen</span>
          <strong>{{ vorschau.statistik?.offene_buchungen || 0 }}</strong>
        </article>
        <article class="summary-card">
          <span>Ohne Treffer</span>
          <strong>{{ vorschau.statistik?.keine_offene_buchung || 0 }}</strong>
        </article>
      </div>

      <div class="table-shell inventar-table-shell geraete-table-shell">
        <table class="geraete-table storno-assistent-table">
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
                  :disabled="!eintrag.aktivierbar || Boolean(gespeicherterStorno)"
                  @change="toggleZeile(eintrag)"
                />
              </td>
              <td>{{ eintrag.schueler_name }}</td>
              <td>{{ eintrag.klasse }}</td>
              <td>{{ eintrag.inventarnummer || "-" }}</td>
              <td>{{ eintrag.seriennummer || "-" }}</td>
              <td>{{ eintrag.barcode || "-" }}</td>
              <td>
                <span class="inventar-status" :class="statusKlasse(eintrag)">
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
.storno-assistent {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.storno-assistent-actions {
  justify-content: flex-start;
}

.storno-assistent-summary {
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

.storno-assistent-table .inventar-status.is-ok {
  background: rgba(28, 126, 84, 0.12);
  color: #166646;
}

.storno-assistent-table .inventar-status.is-muted {
  background: rgba(89, 102, 117, 0.12);
  color: #596675;
}

.storno-assistent-table .inventar-status.is-warning {
  background: rgba(201, 124, 23, 0.14);
  color: #995c0a;
}

@media (max-width: 900px) {
  .storno-assistent-actions {
    flex-direction: column;
    align-items: stretch;
  }
}
</style>
