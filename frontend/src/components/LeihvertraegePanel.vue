<script setup>
import { computed, onMounted, ref, watch } from "vue";

const apiBase = "/api";

const props = defineProps({
  apiRequest: { type: Function, required: true }
});

const laedt = ref(true);
const laedtGeraete = ref(false);
const erzeugtPdf = ref(false);
const fehler = ref("");
const erfolg = ref("");
const ausleiherListe = ref([]);
const aktiveVorlagen = ref([]);
const auswahl = ref({
  vertragstyp: "tablet",
  ausleiher_id: ""
});
const ausleiherKontext = ref({
  ausleiher: null,
  geraete: []
});
const markierteExemplare = ref([]);

const verfuegbareAusleiher = computed(() =>
  ausleiherListe.value
    .filter((eintrag) => ["schueler", "lehrkraft"].includes(eintrag.ausleiher_typ))
    .sort((left, right) => left.name.localeCompare(right.name, "de"))
);

const aktiveVorlage = computed(
  () => aktiveVorlagen.value.find((eintrag) => eintrag.typ === auswahl.value.vertragstyp) || null
);

async function ladeStammdaten() {
  laedt.value = true;
  fehler.value = "";

  try {
    const [ausleiher, vorlagen] = await Promise.all([
      props.apiRequest("/ausleiher"),
      props.apiRequest("/vertragsvorlagen/aktiv")
    ]);

    ausleiherListe.value = ausleiher;
    aktiveVorlagen.value = vorlagen;
  } catch (error) {
    fehler.value = error.message;
  } finally {
    laedt.value = false;
  }
}

async function ladeGeraete() {
  if (!auswahl.value.ausleiher_id) {
    ausleiherKontext.value = { ausleiher: null, geraete: [] };
    markierteExemplare.value = [];
    return;
  }

  laedtGeraete.value = true;
  fehler.value = "";
  erfolg.value = "";

  try {
    const daten = await props.apiRequest(`/leihvertraege/ausleiher/${auswahl.value.ausleiher_id}/geraete`);
    ausleiherKontext.value = daten;
    markierteExemplare.value = daten.geraete.map((eintrag) => eintrag.artikel_exemplar_id);
  } catch (error) {
    ausleiherKontext.value = { ausleiher: null, geraete: [] };
    markierteExemplare.value = [];
    fehler.value = error.message;
  } finally {
    laedtGeraete.value = false;
  }
}

function toggleExemplar(exemplarId) {
  const vorhandeIds = new Set(markierteExemplare.value);
  if (vorhandeIds.has(exemplarId)) {
    vorhandeIds.delete(exemplarId);
  } else {
    vorhandeIds.add(exemplarId);
  }
  markierteExemplare.value = [...vorhandeIds];
}

async function erzeugePdf() {
  if (!auswahl.value.ausleiher_id) {
    fehler.value = "Bitte zuerst eine Person waehlen.";
    return;
  }

  if (markierteExemplare.value.length === 0) {
    fehler.value = "Bitte mindestens ein Geraet markieren.";
    return;
  }

  erzeugtPdf.value = true;
  fehler.value = "";
  erfolg.value = "";

  try {
    const response = await props.apiRequest("/leihvertraege", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        ausleiher_id: Number(auswahl.value.ausleiher_id),
        vertragstyp: auswahl.value.vertragstyp,
        artikel_exemplar_ids: markierteExemplare.value
      })
    });

    erfolg.value = `${response.meldung} Vorlage v${response.vertrag.vorlagen_version}.`;
    window.open(`${apiBase}/leihvertraege/${response.vertrag.id}/pdf`, "_blank", "noopener");
  } catch (error) {
    fehler.value = error.message;
  } finally {
    erzeugtPdf.value = false;
  }
}

watch(
  () => auswahl.value.ausleiher_id,
  () => {
    ladeGeraete().catch(() => {});
  }
);

onMounted(() => {
  ladeStammdaten().catch(() => {});
});
</script>

<template>
  <div class="leihvertrag-stack">
    <header class="einstellungen-detail-head">
      <div>
        <p class="eyebrow">Leihvertraege</p>
        <h2>Leihvertrag erzeugen</h2>
        <p class="subtle">Schueler oder Lehrkraft waehlen, zugeordnete offene Geraete markieren und als PDF erzeugen.</p>
      </div>
    </header>

    <p v-if="fehler" class="feedback error">{{ fehler }}</p>
    <p v-if="erfolg" class="feedback success">{{ erfolg }}</p>

    <div v-if="laedt" class="empty-state">Leihvertragsdaten werden geladen...</div>
    <template v-else>
      <article class="einstellungen-card">
        <div class="form-grid">
          <label class="field">
            <span>Vertragstyp</span>
            <select v-model="auswahl.vertragstyp">
              <option value="tablet">tablet</option>
              <option value="laptop">laptop</option>
              <option value="wlan">wlan</option>
            </select>
          </label>

          <label class="field field-wide">
            <span>Schueler / Lehrkraft</span>
            <select v-model="auswahl.ausleiher_id">
              <option value="">- bitte waehlen -</option>
              <option v-for="person in verfuegbareAusleiher" :key="person.id" :value="person.id">
                {{ person.name }} · {{ person.ausleiher_typ }}{{ person.klasse_oder_bereich ? ` · ${person.klasse_oder_bereich}` : "" }}
              </option>
            </select>
          </label>
        </div>

        <div v-if="aktiveVorlage" class="helper-text compact-helper">
          Aktive Vorlage: <strong>{{ aktiveVorlage.name }}</strong> · Version {{ aktiveVorlage.version }} · {{ aktiveVorlage.sections.length }} Rechtstext-Abschnitte
        </div>
      </article>

      <article class="einstellungen-card" v-if="ausleiherKontext.ausleiher">
        <div class="section-head-inline">
          <div>
            <h3>Vertragspartner</h3>
            <p class="subtle">{{ ausleiherKontext.ausleiher.name }}</p>
          </div>
          <span class="status-pill">{{ ausleiherKontext.ausleiher.ausleiher_typ }}</span>
        </div>

        <div class="form-grid">
          <div class="field field-static">
            <span>Vorname</span>
            <strong>{{ ausleiherKontext.ausleiher.vorname || "-" }}</strong>
          </div>
          <div class="field field-static">
            <span>Nachname</span>
            <strong>{{ ausleiherKontext.ausleiher.nachname || "-" }}</strong>
          </div>
          <div class="field field-static">
            <span>Klasse / Bereich</span>
            <strong>{{ ausleiherKontext.ausleiher.klasse || ausleiherKontext.ausleiher.klasse_oder_bereich || "-" }}</strong>
          </div>
          <div class="field field-static">
            <span>Geburtsdatum</span>
            <strong>{{ ausleiherKontext.ausleiher.geburtsdatum || "-" }}</strong>
          </div>
        </div>
      </article>

      <article class="einstellungen-card">
        <div class="section-head-inline">
          <div>
            <h3>Registrierte Leihgeraete</h3>
            <p class="subtle">Es werden nur offene Ausleihen der ausgewaehlten Person angeboten.</p>
          </div>
          <span v-if="laedtGeraete" class="subtle">laedt...</span>
        </div>

        <div v-if="!auswahl.ausleiher_id" class="empty-state">Bitte zuerst eine Person waehlen.</div>
        <div v-else-if="laedtGeraete" class="empty-state">Geraete werden geladen...</div>
        <div v-else-if="ausleiherKontext.geraete.length === 0" class="empty-state">Zu dieser Person gibt es aktuell keine offenen Leihgeraete.</div>
        <div v-else class="device-checkbox-list">
          <label
            v-for="eintrag in ausleiherKontext.geraete"
            :key="eintrag.artikel_exemplar_id"
            class="device-checkbox-card"
          >
            <input
              :checked="markierteExemplare.includes(eintrag.artikel_exemplar_id)"
              type="checkbox"
              @change="toggleExemplar(eintrag.artikel_exemplar_id)"
            />
            <div>
              <strong>{{ eintrag.geraetename }}</strong>
              <p>{{ eintrag.inventarnummer }} · Artikel {{ eintrag.artikel_id }}</p>
              <small>Barcode {{ eintrag.barcode || "-" }} · Seriennummer {{ eintrag.seriennummer || "-" }}</small>
            </div>
          </label>
        </div>
      </article>

      <div class="button-row">
        <button class="primary" :disabled="erzeugtPdf || !aktiveVorlage" @click="erzeugePdf">
          {{ erzeugtPdf ? "PDF wird erzeugt..." : "Leihvertrag als PDF erzeugen" }}
        </button>
      </div>
    </template>
  </div>
</template>

<style scoped>
.leihvertrag-stack {
  display: grid;
  gap: 18px;
}

.section-head-inline {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  align-items: flex-start;
  margin-bottom: 16px;
}

.field-static {
  padding: 14px 16px;
  border-radius: 16px;
  background: rgba(36, 52, 71, 0.05);
  border: 1px solid rgba(36, 52, 71, 0.08);
}

.field-static span {
  display: block;
  margin-bottom: 6px;
  color: rgba(36, 52, 71, 0.7);
  font-size: 0.88rem;
}

.device-checkbox-list {
  display: grid;
  gap: 12px;
}

.device-checkbox-card {
  display: grid;
  grid-template-columns: auto 1fr;
  gap: 12px;
  align-items: flex-start;
  padding: 14px 16px;
  border-radius: 16px;
  border: 1px solid rgba(36, 52, 71, 0.1);
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.95), rgba(244, 248, 250, 0.95));
}

.device-checkbox-card input {
  margin-top: 4px;
  width: 18px;
  height: 18px;
}

.device-checkbox-card p,
.device-checkbox-card small {
  display: block;
  margin-top: 4px;
  color: rgba(36, 52, 71, 0.72);
}
</style>
