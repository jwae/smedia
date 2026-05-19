<script setup>
import { computed, ref } from "vue";

const props = defineProps({
  historieGesamt: { type: Number, required: true },
  historieDatumFilter: { type: String, required: true },
  historieFilter: { type: String, required: true },
  historieGeoeffnet: { type: Boolean, required: true },
  historieEintraege: { type: Array, required: true },
  historieNachDatum: { type: Object, required: true },
  historieHatBuchlink: { type: Function, required: true },
  offeneAusleihen: { type: Array, required: true },
  formatDatum: { type: Function, required: true },
  historieLoeschTage: { type: [String, Number], required: true },
  historieKannMehrLaden: { type: Boolean, required: true },
  historieLaedtMehr: { type: Boolean, required: true }
});

const emit = defineEmits([
  "update:historie-datum-filter",
  "update:historie-filter",
  "update:historie-loesch-tage",
  "zeige-buchdetails",
  "historie-loeschen",
  "historie-mehr-laden"
]);

const aktiveAusleihenFilter = ref("");

const isHistorieOpen = ref(true);
const isAusleihenOpen = ref(true);

const gefilterteAktiveAusleihen = computed(() => {
  const q = aktiveAusleihenFilter.value.trim().toLowerCase();

  if (!q) {
    return props.offeneAusleihen;
  }

  return props.offeneAusleihen.filter((eintrag) =>
    [
      eintrag.ausleiher_name,
      eintrag.titel,
      eintrag.zustand_bei_ausgabe,
      eintrag.faelligkeit?.text,
      eintrag.inventarnummer,
      eintrag.barcode
    ].some((feld) => feld?.toLowerCase().includes(q))
  );
});

function onHistorieScroll(event) {
  const ziel = event.target;
  if (!ziel) return;

  const rest = ziel.scrollHeight - ziel.scrollTop - ziel.clientHeight;
  if (rest < 80) {
    emit("historie-mehr-laden");
  }
}
</script>

<template>
  <section class="panel">
    <div class="panel-head">
      <h2 @click="isHistorieOpen = !isHistorieOpen" class="collapsible-header" title="Ein-/Ausklappen">
        <svg :class="{ 'icon-rotated': isHistorieOpen }" class="chevron-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="6 9 12 15 18 9"></polyline>
        </svg>
        Historie <span class="subtle" style="font-size:0.85rem; font-weight:400;">{{ historieGesamt }} Eintraege</span>
      </h2>
      <div class="button-row panel-head-actions">
        <span class="subtle">Filtern nach:</span>
        <div class="historie-suche-wrap scanner-input-wrap">
          <input
            :value="historieDatumFilter"
            type="date"
            class="historie-suche"
            @input="emit('update:historie-datum-filter', $event.target.value)"
          />
          <button
            v-if="historieDatumFilter"
            type="button"
            class="scanner-clear-button"
            aria-label="Datumsfilter zurücksetzen"
            @click="emit('update:historie-datum-filter', '')"
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <line x1="18" y1="6" x2="6" y2="18"/>
              <line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
          </button>
        </div>
        <div class="historie-suche-wrap scanner-input-wrap">
          <input
            :value="historieFilter"
            type="search"
            placeholder="Inhalt suchen ..."
            class="historie-suche"
            @input="emit('update:historie-filter', $event.target.value)"
          />
          <button
            v-if="historieFilter"
            type="button"
            class="scanner-clear-button"
            aria-label="Filter zurücksetzen"
            @click="emit('update:historie-filter', '')"
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <line x1="18" y1="6" x2="6" y2="18"/>
              <line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
          </button>
        </div>
      </div>
    </div>

    <div v-show="isHistorieOpen">
    <div v-if="!historieGeoeffnet" class="empty-state">
      Historie ist eingeklappt.
    </div>
    <div v-else-if="historieEintraege.length === 0" class="empty-state">
      Noch keine Historie vorhanden.
    </div>
    <div v-else class="table-shell historie-table-shell inventar-table-shell" @scroll.passive="onHistorieScroll">
      <table class="historie-table">
        <thead>
          <tr>
            <th>Uhrzeit</th>
            <th>Aktion</th>
            <th>Titel</th>
            <th>Ausleiher</th>
            <th>Inventar-Nr.</th>
            <th>Barcode</th>
            <th>Status</th>
            <th>Ausgeloest von</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <template v-for="[tag, eintraege] in historieNachDatum" :key="tag">
            <tr class="historie-tag-zeile">
              <td colspan="9">{{ tag }} <span class="subtle">({{ eintraege.length }})</span></td>
            </tr>
            <tr v-for="eintrag in eintraege" :key="eintrag.id">
              <td style="white-space:nowrap">
                {{ new Date(eintrag.erstellt_am).toLocaleTimeString("de-DE", { hour: "2-digit", minute: "2-digit" }) }}
              </td>
              <td>
                <span
                  :class="{
                    'aktion-badge historie-aktion-rueckgabe': eintrag.aktion === 'rueckgabe',
                    'aktion-badge historie-aktion-verlaengerung': eintrag.aktion === 'verlaengerung',
                    'aktion-badge historie-aktion-ausgabe': eintrag.aktion === 'ausgabe',
                    'aktion-badge historie-aktion-reparatur': eintrag.aktion?.startsWith('reparatur')
                  }"
                >
                  {{ eintrag.aktion }}
                </span>
              </td>
              <td class="historie-titel">{{ eintrag.titel }}</td>
              <td>{{ (eintrag.aktion === 'ausgabe' || eintrag.aktion === 'rueckgabe') && eintrag.ausleiher_name ? eintrag.ausleiher_name : '-' }}</td>
              <td>{{ eintrag.inventarnummer || "-" }}</td>
              <td>{{ eintrag.barcode || "-" }}</td>
              <td>{{ eintrag.status || "-" }}</td>
              <td>{{ eintrag.ausgeloest_von }}</td>
              <td class="historie-link-cell">
                <button
                  v-if="historieHatBuchlink(eintrag)"
                  class="ghost small-button historie-link-button"
                  @click="emit('zeige-buchdetails', eintrag)"
                >
                  Buch
                </button>
              </td>
            </tr>
          </template>
        </tbody>
      </table>
      <div v-if="historieLaedtMehr" class="historie-statuszeile subtle">
        Weitere Eintraege werden geladen ...
      </div>
      <div v-else-if="historieKannMehrLaden" class="historie-statuszeile subtle">
        Nach unten scrollen, um weitere Eintraege zu laden.
      </div>
    </div>

    <div class="historie-loeschleiste">
      <span class="subtle">Alle Eintraege aelter als</span>
      <input
        :value="historieLoeschTage"
        type="number"
        min="1"
        step="1"
        class="historie-loeschfeld"
        @input="emit('update:historie-loesch-tage', $event.target.value)"
      />
      <span class="subtle">Tage loeschen</span>
      <button type="button" class="danger small-button historie-loesch-button" @click="emit('historie-loeschen')">
        Historie bereinigen
      </button>
    </div>
    </div>
  </section>

  <section class="panel">
    <div class="panel-head">
      <h2 @click="isAusleihenOpen = !isAusleihenOpen" class="collapsible-header" title="Ein-/Ausklappen">
        <svg :class="{ 'icon-rotated': isAusleihenOpen }" class="chevron-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="6 9 12 15 18 9"></polyline>
        </svg>
        Aktive Ausleihen <span class="subtle" style="font-size:0.85rem; font-weight:400;">{{ gefilterteAktiveAusleihen.length }} / {{ offeneAusleihen.length }} Eintraege</span>
      </h2>
      <div class="button-row panel-head-actions">
        <span class="subtle">Filtern nach:</span>
        <div class="historie-suche-wrap scanner-input-wrap">
          <input
            v-model="aktiveAusleihenFilter"
            type="search"
            placeholder="Aktive Ausleihen suchen ..."
            class="historie-suche"
          />
          <button
            v-if="aktiveAusleihenFilter"
            type="button"
            class="scanner-clear-button"
            aria-label="Filter zuruecksetzen"
            @click="aktiveAusleihenFilter = ''"
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <line x1="18" y1="6" x2="6" y2="18"/>
              <line x1="6" y1="6" x2="18" y2="18"/>
            </svg>
          </button>
        </div>
      </div>
    </div>

    <div v-show="isAusleihenOpen">
    <div v-if="offeneAusleihen.length === 0" class="empty-state">
      Aktuell keine aktiven Ausleihen.
    </div>
    <div v-else-if="gefilterteAktiveAusleihen.length === 0" class="empty-state">
      Keine aktiven Ausleihen zum Filter gefunden.
    </div>
    <div v-else class="table-shell historie-table-shell inventar-table-shell">
      <table class="historie-table">
        <thead>
          <tr>
            <th>Ausgabe</th>
            <th>Ausleiher</th>
            <th>Titel</th>
            <th>Status</th>
            <th>Faellig</th>
            <th>Inventar-Nr.</th>
            <th>Barcode</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="eintrag in gefilterteAktiveAusleihen" :key="`ausleihe-${eintrag.id}`">
            <td>{{ formatDatum(eintrag.ausgabe_am) }}</td>
            <td>{{ eintrag.ausleiher_name || "-" }}</td>
            <td class="historie-titel">{{ eintrag.titel || "-" }}</td>
            <td>{{ eintrag.zustand_bei_ausgabe || "-" }}</td>
            <td>
              <span :class="['faelligkeits-badge', eintrag.faelligkeit?.klasse || 'faellig-neutral']">
                <span
                  v-if="eintrag.faelligkeit?.symbol"
                  class="faelligkeits-symbol"
                  aria-hidden="true"
                >
                  {{ eintrag.faelligkeit.symbol }}
                </span>
                {{ eintrag.faellig_am ? formatDatum(eintrag.faellig_am) : 'ohne Frist' }}
              </span>
            </td>
            <td>{{ eintrag.inventarnummer || "-" }}</td>
            <td>{{ eintrag.barcode || "-" }}</td>
          </tr>
        </tbody>
      </table>
    </div>
    </div>
  </section>
</template>

<style scoped>
.collapsible-header {
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  user-select: none;
}

.chevron-icon {
  transition: transform 0.3s ease;
}

.icon-rotated {
  transform: rotate(180deg);
}

.aktion-badge {
  display: inline-block;
  padding: 0.2rem 0.6rem;
  border-radius: 9999px;
  font-size: 0.85em;
  font-weight: 500;
  line-height: 1.2;
}

.historie-aktion-ausgabe {
  background-color: #dbeafe; /* Helles Blau */
  color: #1e40af; /* Dunkles Blau */
}

.historie-aktion-rueckgabe {
  background-color: #d1fae5; /* Helles Gruen */
  color: #065f46; /* Dunkles Gruen */
}

.historie-aktion-verlaengerung {
  background-color: #fef3c7; /* Helles Gelb/Orange */
  color: #92400e; /* Dunkles Orange */
}

.historie-aktion-reparatur {
  background-color: #fee2e2; /* Helles Rot */
  color: #991b1b; /* Dunkles Rot */
}
</style>
