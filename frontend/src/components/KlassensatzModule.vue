<script setup>
import { storeToRefs } from "pinia";
import { useInventarStore } from "../stores/inventarStore.js";

defineProps({
  klassensatzForm: { type: Object, required: true },
  klassensatzGruppen: { type: Array, required: true },
  standardfristText: { type: Function, required: true },
  istKlassensatzGruppeAusgewaehlt: { type: Function, required: true },
  scanBereitZurAusleihe: { type: Boolean, required: true },
  scanDialog: { type: Object, required: true }
});

const emit = defineEmits(["toggle-gruppe", "speichern"]);

const inventarStore = useInventarStore();
const { klassenAusleiher } = storeToRefs(inventarStore);
</script>

<template>
  <section class="listen-grid objekt-grid">
    <article class="panel">
      <div class="panel-head">
        <h2>Klassensatz-Ausgabe</h2>
        <span class="subtle">{{ klassensatzGruppen.length }} Klassensaetze verfuegbar</span>
      </div>

      <div class="form-grid">
        <label class="field">
          <span>Klasse</span>
          <select v-model="klassensatzForm.ausleiher_id">
            <option value="">Bitte waehlen</option>
            <option v-for="eintrag in klassenAusleiher" :key="eintrag.id" :value="eintrag.id">
              {{ eintrag.name }}
            </option>
          </select>
        </label>

        <label class="field">
          <span>Faellig am</span>
          <input v-model="klassensatzForm.faellig_am" type="datetime-local" />
        </label>

        <label class="field field-wide">
          <span>Kommentar</span>
          <textarea v-model="klassensatzForm.kommentar_ausgabe" rows="2"></textarea>
        </label>
      </div>

      <p class="helper-text compact-helper">
        {{ standardfristText(klassensatzForm.ausleiher_id) }}
        <span v-if="!klassensatzForm.faellig_am"> Wenn leer, wird fuer Klassen automatisch 1 Tag gesetzt.</span>
      </p>

      <div v-if="klassensatzGruppen.length === 0" class="empty-state">
        Aktuell sind keine verfuegbaren Klassensatz-Buecher vorhanden.
      </div>
      <div v-else class="klassensatz-liste">
        <label
          v-for="gruppe in klassensatzGruppen"
          :key="gruppe.schluessel"
          class="klassensatz-eintrag"
        >
          <input
            type="checkbox"
            :checked="istKlassensatzGruppeAusgewaehlt(gruppe)"
            @change="emit('toggle-gruppe', gruppe)"
          />
          <div>
            <strong>{{ gruppe.klassensatz_name }}</strong>
            <div>{{ gruppe.titel }}</div>
            <small v-if="gruppe.verlag">{{ gruppe.verlag }}</small>
            <small>{{ gruppe.anzahl_verfuegbar }} verfuegbar</small>
          </div>
        </label>
      </div>

      <button class="primary wide-button" @click="emit('speichern')">
        Klassensatz ausgeben
      </button>
    </article>

    <article class="panel">
      <div class="panel-head">
        <h2>Klassensatz-Rueckgabe</h2>
        <span class="subtle">Dummy</span>
      </div>

      <div class="empty-state">
        Platzhalter fuer die spaetere Klassensatz-Rueckgabe.
      </div>
    </article>
  </section>
</template>
