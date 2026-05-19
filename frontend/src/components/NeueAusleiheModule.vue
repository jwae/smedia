<script setup>
import { computed, ref, watch } from "vue";
import { storeToRefs } from "pinia";
import { useInventarStore } from "../stores/inventarStore.js";

const props = defineProps({
  ausleiheForm: { type: Object, required: true },
  ausleiheManuelleExemplarEingabe: { type: String, required: true },
  ausleiheScanExemplarEingabe: { type: String, required: true },
  standardfristText: { type: Function, required: true }
});

const emit = defineEmits([
  "update:ausleiheManuelleExemplarEingabe",
  "update:ausleiheScanExemplarEingabe",
  "suche-manuell",
  "scan-uebernehmen",
  "speichern"
]);

const inventarStore = useInventarStore();
const { 
  exemplare, offeneAusleihen, verfuegbareExemplare, 
  lehrkraftAusleiher, schuelerAusleiher, klassenAusleiher 
} = storeToRefs(inventarStore);

const exemplarSuche = ref("");
const ausleiherSuche = ref("");
const exemplarListeOffen = ref(false);

function exemplarOptionsText(eintrag, offeneAusleihen) {
  if (eintrag.status === "verfuegbar") {
    return `${eintrag.inventarnummer} - ${eintrag.titel}`;
  }

  if (eintrag.status === "ausgeliehen") {
    const offeneAusleihe = offeneAusleihen.find(
      (ausleihe) =>
        ausleihe.exemplar_id === eintrag.id ||
        ausleihe.inventarnummer === eintrag.inventarnummer
    );
    const ausleiherText = offeneAusleihe?.ausleiher_name
      ? ` an ${offeneAusleihe.ausleiher_name}`
      : "";
    return `${eintrag.inventarnummer} - ${eintrag.titel} [ausgeliehen${ausleiherText}]`;
  }

  return `${eintrag.inventarnummer} - ${eintrag.titel} [nicht ausleihbar: ${eintrag.status}]`;
}

const exemplarSuchoptionen = computed(() =>
  exemplare.value.map((eintrag) => ({
    id: eintrag.id,
    suchtext: exemplarOptionsText(eintrag, offeneAusleihen.value),
    farbe: eintrag.status === "ausgeliehen" ? "#b42318" : undefined,
    eintrag
  }))
);

const gefilterteExemplarSuchoptionen = computed(() => {
  const text = exemplarSuche.value.trim().toLowerCase();

  if (!text) {
    return exemplarSuchoptionen.value;
  }

  return exemplarSuchoptionen.value.filter(({ suchtext, eintrag }) => {
    const inventarnummer = eintrag.inventarnummer?.toLowerCase() || "";
    const titel = eintrag.titel?.toLowerCase() || "";
    const barcode = eintrag.barcode?.toLowerCase() || "";

    return (
      suchtext.toLowerCase().includes(text) ||
      inventarnummer.includes(text) ||
      titel.includes(text) ||
      barcode.includes(text)
    );
  });
});

const istBuchbaresExemplarAusgewaehlt = computed(() =>
  exemplare.value.some(
    (eintrag) =>
      Number(eintrag.id) === Number(props.ausleiheForm.exemplar_id) &&
      eintrag.status === "verfuegbar"
  )
);

const istAusleiherAusgewaehlt = computed(() =>
  ausleiherSuchoptionen.value.some(
    (eintrag) => Number(eintrag.id) === Number(props.ausleiheForm.ausleiher_id)
  )
);

function synchronisiereExemplarSuche() {
  const ausgewaehlt = exemplare.value.find(
    (eintrag) => Number(eintrag.id) === Number(props.ausleiheForm.exemplar_id)
  );
  exemplarSuche.value = ausgewaehlt ? exemplarOptionsText(ausgewaehlt, offeneAusleihen.value) : "";
}

function uebernehmeExemplarSuche(wert) {
  exemplarSuche.value = wert;
  exemplarListeOffen.value = true;

  const gefunden = exemplarSuchoptionen.value.find((eintrag) => eintrag.suchtext === wert)?.eintrag;

  if (gefunden) {
    props.ausleiheForm.exemplar_id = gefunden.id;
    return;
  }

  if (!wert.trim()) {
    props.ausleiheForm.exemplar_id = "";
  }
}

function exemplarListeAnzeigen() {
  exemplarListeOffen.value = true;
}

function exemplarListeAusblenden() {
  window.setTimeout(() => {
    exemplarListeOffen.value = false;
  }, 120);
}

function waehleExemplarAusListe(eintrag) {
  exemplarSuche.value = exemplarOptionsText(eintrag, offeneAusleihen.value);
  props.ausleiheForm.exemplar_id = eintrag.id;
  exemplarListeOffen.value = false;
}

const ausleiherSuchoptionen = computed(() =>
  [...lehrkraftAusleiher.value, ...schuelerAusleiher.value, ...klassenAusleiher.value].map((person) => ({
    id: person.id,
    suchtext: `${person.name}${person.klasse_oder_bereich ? ` - ${person.klasse_oder_bereich}` : ""}`,
    person
  }))
);

function synchronisiereAusleiherSuche() {
  const ausgewaehlt = ausleiherSuchoptionen.value.find(
    (eintrag) => Number(eintrag.id) === Number(props.ausleiheForm.ausleiher_id)
  );
  ausleiherSuche.value = ausgewaehlt ? ausgewaehlt.suchtext : "";
}

function uebernehmeAusleiherSuche(wert) {
  ausleiherSuche.value = wert;

  const gefunden = ausleiherSuchoptionen.value.find((eintrag) => eintrag.suchtext === wert)?.person;

  if (gefunden) {
    props.ausleiheForm.ausleiher_id = gefunden.id;
    return;
  }

  if (!wert.trim()) {
    props.ausleiheForm.ausleiher_id = "";
  }
}

watch(
  () => [props.ausleiheForm.exemplar_id, exemplare.value.length, offeneAusleihen.value.length],
  () => {
    synchronisiereExemplarSuche();
  },
  { immediate: true }
);

watch(
  () => [
    props.ausleiheForm.ausleiher_id,
    lehrkraftAusleiher.value.length,
    schuelerAusleiher.value.length,
    klassenAusleiher.value.length
  ],
  () => {
    synchronisiereAusleiherSuche();
  },
  { immediate: true }
);
</script>

<template>
  <article class="panel">
    <div class="panel-head">
      <h2>Ausleihe</h2>
      <span class="subtle">{{ verfuegbareExemplare.length }} verfuegbar</span>
    </div>

    <div class="form-grid">
      <label class="field field-wide">
        <span>Ausleiher</span>
        <div class="scanner-input-wrap">
          <input
            :value="ausleiherSuche"
            type="text"
            list="ausleiher-suche-liste"
            placeholder="Ausleiher suchen nach Name, Klasse oder Bereich"
            @input="uebernehmeAusleiherSuche($event.target.value)"
            @change="uebernehmeAusleiherSuche($event.target.value)"
          />
          <button
            v-if="ausleiherSuche"
            type="button"
            class="scanner-clear-button"
            aria-label="Ausleiher leeren"
            @click="uebernehmeAusleiherSuche('')"
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <line x1="18" y1="6" x2="6" y2="18"/>
              <line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
          </button>
        </div>
        <datalist id="ausleiher-suche-liste">
          <option
            v-for="person in ausleiherSuchoptionen"
            :key="person.id"
            :value="person.suchtext"
          />
        </datalist>
      </label>

      <label class="field field-wide">
        <span>Exemplar</span>
        <div class="scanner-input-wrap exemplar-dropdown">
          <input
            :value="exemplarSuche"
            type="text"
            placeholder="Exemplar suchen nach Inventarnummer, Barcode oder Titel"
            @input="uebernehmeExemplarSuche($event.target.value)"
            @change="uebernehmeExemplarSuche($event.target.value)"
            @focus="exemplarListeAnzeigen"
            @blur="exemplarListeAusblenden"
          />
          <button
            v-if="exemplarSuche"
            type="button"
            class="scanner-clear-button"
            aria-label="Exemplar leeren"
            @click="uebernehmeExemplarSuche('')"
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <line x1="18" y1="6" x2="6" y2="18"/>
              <line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
          </button>
        </div>
        <ul
          v-if="exemplarListeOffen && gefilterteExemplarSuchoptionen.length"
          class="exemplar-suchliste"
        >
          <li
            v-for="eintrag in gefilterteExemplarSuchoptionen"
            :key="eintrag.id"
            :class="{
              'is-ausgeliehen': eintrag.eintrag.status === 'ausgeliehen',
              'is-nicht-ausleihbar': !['verfuegbar', 'ausgeliehen'].includes(eintrag.eintrag.status)
            }"
            @mousedown.prevent="waehleExemplarAusListe(eintrag.eintrag)"
          >
            {{ eintrag.suchtext }}
          </li>
        </ul>
        <small class="field-status-hint">
          Gib Person, Inventarnummer, Barcode oder Titel ein. Verliehene Exemplare sind rot markiert.
        </small>
      </label>

      <label class="field field-wide">
        <span>Faellig am</span>
        <input v-model="ausleiheForm.faellig_am" type="date" />
      </label>

      <label class="field field-wide">
        <span>Kommentar</span>
        <textarea v-model="ausleiheForm.kommentar_ausgabe" rows="3"></textarea>
      </label>
    </div>

    <p class="helper-text compact-helper">
      {{ standardfristText(ausleiheForm.ausleiher_id) }}
      <span v-if="!ausleiheForm.faellig_am"> Wenn leer, setzt das Backend die Frist automatisch.</span>
    </p>

    <button
      class="primary wide-button"
      :disabled="!istBuchbaresExemplarAusgewaehlt || !istAusleiherAusgewaehlt"
      @click="emit('speichern')"
    >
      Ausleihe buchen
    </button>
  </article>
</template>

<style scoped>
.exemplar-dropdown {
  z-index: 2;
}

.exemplar-suchliste {
  margin: 6px 0 0;
  padding: 8px 0;
  list-style: none;
  border: 1px solid rgba(36, 52, 71, 0.14);
  border-radius: 14px;
  background: #ffffff;
  box-shadow: 0 14px 32px rgba(36, 52, 71, 0.14);
  max-height: 260px;
  overflow-y: auto;
}

.exemplar-suchliste li {
  padding: 10px 14px;
  color: #243447;
  cursor: pointer;
  font-size: 0.88rem;
}

.exemplar-suchliste li:hover {
  background: rgba(36, 52, 71, 0.06);
}

.exemplar-suchliste li.is-ausgeliehen {
  color: #b42318;
  font-weight: 600;
}

.exemplar-suchliste li.is-nicht-ausleihbar {
  color: #8a5a12;
}
</style>
