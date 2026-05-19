<script setup>
import { computed, ref, watch } from "vue";
import { storeToRefs } from "pinia";
import { useInventarStore } from "../stores/inventarStore.js";

const props = defineProps({
  rueckgabeForm: { type: Object, required: true },
  verlaengerungForm: { type: Object, required: true },
  formatDatum: { type: Function, required: true }
});

const emit = defineEmits(["speichern", "verlaengerung-speichern"]);

const inventarStore = useInventarStore();
const { offeneAusleihen } = storeToRefs(inventarStore);

const offeneAusleiheSuche = ref("");
const verlaengerungSuche = ref("");

const offeneAusleiheSuchoptionen = computed(() =>
  offeneAusleihen.value.map((eintrag) => ({
    id: eintrag.id,
    suchtext: `${eintrag.inventarnummer} - ${eintrag.titel} - ${eintrag.ausleiher_name}`,
    eintrag
  }))
);

function synchronisiereOffeneAusleiheSuche() {
  const ausgewaehlt = offeneAusleiheSuchoptionen.value.find(
    (eintrag) => Number(eintrag.id) === Number(props.rueckgabeForm.ausleihe_id)
  );
  offeneAusleiheSuche.value = ausgewaehlt ? ausgewaehlt.suchtext : "";
}

function uebernehmeOffeneAusleiheSuche(wert) {
  offeneAusleiheSuche.value = wert;

  const gefunden = offeneAusleiheSuchoptionen.value.find((eintrag) => eintrag.suchtext === wert)?.eintrag;

  if (gefunden) {
    props.rueckgabeForm.ausleihe_id = gefunden.id;
    return;
  }

  if (!wert.trim()) {
    props.rueckgabeForm.ausleihe_id = "";
  }
}

function formatFuerDatetimeLocalPlusTage(isoWert, tage) {
  if (!isoWert) return "";

  const datum = new Date(isoWert);

  if (Number.isNaN(datum.getTime())) {
    return "";
  }

  datum.setDate(datum.getDate() + tage);

  const pad = (wert) => String(wert).padStart(2, "0");

  return `${datum.getFullYear()}-${pad(datum.getMonth() + 1)}-${pad(datum.getDate())}T${pad(
    datum.getHours()
  )}:${pad(datum.getMinutes())}`;
}

function synchronisiereVerlaengerungSuche() {
  const ausgewaehlt = offeneAusleiheSuchoptionen.value.find(
    (eintrag) => Number(eintrag.id) === Number(props.verlaengerungForm.ausleihe_id)
  );
  verlaengerungSuche.value = ausgewaehlt ? ausgewaehlt.suchtext : "";
}

function uebernehmeVerlaengerungSuche(wert) {
  verlaengerungSuche.value = wert;

  const gefunden = offeneAusleiheSuchoptionen.value.find((eintrag) => eintrag.suchtext === wert)?.eintrag;

  if (gefunden) {
    props.verlaengerungForm.ausleihe_id = gefunden.id;
    props.verlaengerungForm.faellig_am = formatFuerDatetimeLocalPlusTage(gefunden.faellig_am, 7);
    return;
  }

  if (!wert.trim()) {
    props.verlaengerungForm.ausleihe_id = "";
    props.verlaengerungForm.faellig_am = "";
  }
}

const ausgewaehlteVerlaengerung = computed(
  () =>
    offeneAusleihen.value.find(
      (eintrag) => Number(eintrag.id) === Number(props.verlaengerungForm.ausleihe_id)
    ) || null
);

const ausgewaehlteRueckgabe = computed(
  () =>
    offeneAusleihen.value.find(
      (eintrag) => Number(eintrag.id) === Number(props.rueckgabeForm.ausleihe_id)
    ) || null
);

watch(
  () => [props.rueckgabeForm.ausleihe_id, offeneAusleihen.value.length],
  () => {
    synchronisiereOffeneAusleiheSuche();
  },
  { immediate: true }
);

watch(
  () => [props.verlaengerungForm.ausleihe_id, offeneAusleihen.value.length],
  () => {
    synchronisiereVerlaengerungSuche();
  },
  { immediate: true }
);
</script>

<template>
  <article class="panel">
      <div class="panel-head">
        <h2>Rueckgabe</h2>
        <span class="subtle">{{ offeneAusleihen.length }} offen</span>
      </div>

      <div class="form-grid">
        <label class="field field-wide">
          <span>Offene Ausleihe</span>
          <div class="scanner-input-wrap">
            <input
              :value="offeneAusleiheSuche"
              type="text"
              list="offene-ausleihe-suche-liste"
              placeholder="Offene Ausleihe suchen nach Inventarnummer, Titel oder Ausleiher"
              @input="uebernehmeOffeneAusleiheSuche($event.target.value)"
              @change="uebernehmeOffeneAusleiheSuche($event.target.value)"
            />
            <button
              v-if="offeneAusleiheSuche"
              type="button"
              class="scanner-clear-button"
              aria-label="Offene Ausleihe leeren"
              @click="uebernehmeOffeneAusleiheSuche('')"
            >
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <line x1="18" y1="6" x2="6" y2="18"/>
                <line x1="6" y1="6" x2="18" y2="18"/>
              </svg>
            </button>
          </div>
          <datalist id="offene-ausleihe-suche-liste">
            <option
              v-for="eintrag in offeneAusleiheSuchoptionen"
              :key="eintrag.id"
              :value="eintrag.suchtext"
            />
          </datalist>
        </label>

        <label class="field field-highlight-green">
          <span>Zustand bei Ausgabe</span>
          <input
            :value="ausgewaehlteRueckgabe?.zustand_bei_ausgabe || ''"
            type="text"
            readonly
            placeholder="Noch kein Zustand bekannt"
          />
        </label>

        <label class="field">
          <span>Zustand bei Rueckgabe</span>
          <select v-model="rueckgabeForm.zustand_bei_rueckgabe">
            <option value="neu">neu</option>
            <option value="sehr_gut">sehr_gut</option>
            <option value="gut">gut</option>
            <option value="gebraucht">gebraucht</option>
            <option value="beschaedigt">beschaedigt</option>
            <option value="unvollstaendig">unvollstaendig</option>
          </select>
        </label>

        <label class="field field-wide">
          <span>Kommentar Rueckgabe</span>
          <textarea v-model="rueckgabeForm.kommentar_rueckgabe" rows="3"></textarea>
        </label>
      </div>

      <button class="secondary wide-button" @click="emit('speichern')">
        Rueckgabe verbuchen
      </button>
  </article>

  <article class="panel">
      <div class="panel-head">
        <h2>Verlaengerung</h2>
        <span class="subtle">{{ offeneAusleihen.length }} offen</span>
      </div>

      <div class="form-grid">
        <label class="field field-wide">
          <span>Offene Ausleihe</span>
          <div class="scanner-input-wrap">
            <input
              :value="verlaengerungSuche"
              type="text"
              list="verlaengerung-ausleihe-suche-liste"
              placeholder="Offene Ausleihe suchen nach Inventarnummer, Titel oder Ausleiher"
              @input="uebernehmeVerlaengerungSuche($event.target.value)"
              @change="uebernehmeVerlaengerungSuche($event.target.value)"
            />
            <button
              v-if="verlaengerungSuche"
              type="button"
              class="scanner-clear-button"
              aria-label="Offene Ausleihe fuer Verlaengerung leeren"
              @click="uebernehmeVerlaengerungSuche('')"
            >
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <line x1="18" y1="6" x2="6" y2="18"/>
                <line x1="6" y1="6" x2="18" y2="18"/>
              </svg>
            </button>
          </div>
          <datalist id="verlaengerung-ausleihe-suche-liste">
            <option
              v-for="eintrag in offeneAusleiheSuchoptionen"
              :key="`verlaengerung-${eintrag.id}`"
              :value="eintrag.suchtext"
            />
          </datalist>
        </label>

        <label class="field">
          <span>Ausleiher</span>
          <input
            :value="ausgewaehlteVerlaengerung?.ausleiher_name || ''"
            type="text"
            readonly
            placeholder="Noch kein Ausleiher erkannt"
          />
        </label>

        <label class="field field-wide">
          <span>Exemplar</span>
          <input
            :value="ausgewaehlteVerlaengerung ? `${ausgewaehlteVerlaengerung.inventarnummer} - ${ausgewaehlteVerlaengerung.titel}` : ''"
            type="text"
            readonly
            placeholder="Noch kein Exemplar erkannt"
          />
        </label>

        <label class="field">
          <span>Aktuell faellig</span>
          <input
            :value="ausgewaehlteVerlaengerung?.faellig_am ? formatDatum(ausgewaehlteVerlaengerung.faellig_am) : ''"
            type="text"
            readonly
            placeholder="Keine Frist hinterlegt"
          />
        </label>

        <label class="field field-highlight-blue">
          <span>Neue Faelligkeit</span>
          <input v-model="verlaengerungForm.faellig_am" type="datetime-local" />
        </label>

        <label class="field field-wide">
          <span>Kommentar Verlaengerung</span>
          <textarea v-model="verlaengerungForm.kommentar_verlaengerung" rows="3"></textarea>
        </label>
      </div>

      <button class="petrol wide-button" @click="emit('verlaengerung-speichern')">
        Ausleihe verlaengern
      </button>
  </article>
</template>
