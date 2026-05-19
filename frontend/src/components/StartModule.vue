<script setup>
const props = defineProps({
  scannerGeraetLabel: { type: String, required: true },
  manuelleCodeEingabe: { type: String, required: true },
  scannerStatus: { type: String, required: true },
  scanResult: { type: String, required: true },
  scanType: { type: String, required: true },
  lastError: { type: String, required: true },
  scanDialog: { type: Object, required: true },
  scanBereitZurAusleihe: { type: Boolean, required: true },
  scanBereitZurRueckgabe: { type: Boolean, required: true },
  scanDialogHinweis: { type: String, required: true },
  scanOffeneAusleihenDesAusleihers: { type: Array, required: true },
  markierteScanAusleihen: { type: Array, required: true },
  startAusleiheGeoeffnet: { type: Boolean, required: true },
  startRueckgabeGeoeffnet: { type: Boolean, required: true },
  startVerlaengerungGeoeffnet: { type: Boolean, required: true },
  ausleiheForm: { type: Object, required: true },
  rueckgabeForm: { type: Object, required: true },
  verlaengerungForm: { type: Object, required: true },
  scanOffeneAusleiheZurRueckgabe: { type: Object, required: false, default: null },
  lehrkraftAusleiher: { type: Array, required: true },
  schuelerAusleiher: { type: Array, required: true },
  klassenAusleiher: { type: Array, required: true },
  standardfristText: { type: Function, required: true },
  formatDatum: { type: Function, required: true },
  ausleiherDetailText: { type: Function, required: true },
  istAusleiheUeberfaellig: { type: Function, required: true },
  tageUeberfaellig: { type: Function, required: true },
  exemplarHatWarnstatus: { type: Function, required: true },
  exemplarWarntext: { type: Function, required: true }
});

const emit = defineEmits([
  "update:manuelleCodeEingabe",
  "update:markierte-scan-ausleihen",
  "manuelle-pruefung",
  "scan-bestaetigen",
  "ausleihe-starten",
  "ausleihe-abbrechen",
  "scan-rueckgabe",
  "scan-verlaengern",
  "rueckgabe-buchen",
  "rueckgabe-abbrechen",
  "verlaengerung-speichern",
  "verlaengerung-abbrechen",
  "scan-zuruecksetzen"
]);

function istScanAusleiheMarkiert(ausleiheId) {
  return props.markierteScanAusleihen.includes(ausleiheId);
}

function toggleScanAusleihe(ausleiheId, checked) {
  const naechsteMarkierungen = checked ? [ausleiheId] : [];

  emit("update:markierte-scan-ausleihen", naechsteMarkierungen);
}
</script>

<template>
  <section class="start-grid">
    <article class="panel scanner-panel">
      <div class="panel-head">
        <div class="scanner-head-title">
          <h2>Scanner</h2>
          <span class="badge">{{ scannerGeraetLabel }}</span>
        </div>
        <div class="panel-head-actions scanner-head-actions">
          <button class="ghost small-button head-reset-button" @click="emit('scan-zuruecksetzen')">
            Scan Reset
          </button>
        </div>
      </div>

      <div class="form-grid fallback-grid">
        <label class="field field-wide">
          <div class="scanner-input-wrap">
            <input
              :value="manuelleCodeEingabe"
              type="text"
              data-scanner-input="true"
              placeholder="Barcode scannen oder Code eingeben"
              @input="emit('update:manuelleCodeEingabe', $event.target.value)"
              @keydown.enter.prevent="emit('manuelle-pruefung')"
            />
            <button
              v-if="manuelleCodeEingabe"
              type="button"
              class="scanner-clear-button"
              aria-label="Scanner-Eingabe leeren"
              @click="emit('update:manuelleCodeEingabe', '')"
            >
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <line x1="18" y1="6" x2="6" y2="18"/>
                <line x1="6" y1="6" x2="18" y2="18"/>
              </svg>
            </button>
          </div>
        </label>
      </div>

      <p class="helper-text compact-helper">{{ scanDialogHinweis }}</p>

      <p v-if="scanResult" class="helper-text compact-helper">
        Letzter Treffer: <strong>{{ scanResult }}</strong>
        <span v-if="scanType"> ({{ scanType }})</span>
      </p>
      <p v-if="lastError" class="feedback error">{{ lastError }}</p>

      <div class="scan-dialog">
        <div class="scan-slot" :class="scanDialog.ausleiher ? 'is-complete' : 'is-pending'">
          <span class="scan-slot-label">Ausleiher</span>
          <strong>
            {{ scanDialog.ausleiher ? scanDialog.ausleiher.name : "noch offen" }}
            <span v-if="scanDialog.ausleiher?.barcode" class="scan-inline-badge">
              {{ scanDialog.ausleiher.barcode }}
            </span>
          </strong>
          <small>
            {{
              scanDialog.ausleiher
                ? ausleiherDetailText(scanDialog.ausleiher)
                : "zuerst Person oder Klasse scannen"
            }}
          </small>
        </div>

        <div
          :class="[
            'scan-slot',
            scanDialog.exemplar ? 'is-complete' : 'is-pending',
            exemplarHatWarnstatus(scanDialog.exemplar) ? 'is-warning' : ''
          ]"
        >
          <span class="scan-slot-label">Exemplar</span>
          <strong>
            {{ scanDialog.exemplar ? scanDialog.exemplar.inventarnummer : "noch offen" }}
            <span v-if="scanDialog.exemplar?.barcode" class="scan-inline-badge">
              {{ scanDialog.exemplar.barcode }}
            </span>
          </strong>
          <small>
            {{ exemplarWarntext(scanDialog.exemplar) }}
          </small>
        </div>
      </div>

      <div
        v-if="scanDialog.ausleiher"
        class="scan-person-loans"
      >
        <div class="panel-head compact-head">
          <h3>Offene Ausleihen</h3>
          <span class="subtle">{{ scanOffeneAusleihenDesAusleihers.length }}</span>
        </div>

        <div v-if="scanOffeneAusleihenDesAusleihers.length === 0" class="helper-text compact-helper">
          Fuer diesen Ausleiher sind aktuell keine offenen Ausleihen vorhanden.
        </div>

        <div v-if="scanOffeneAusleihenDesAusleihers.length > 0" class="scan-loan-grid">
          <label
            v-for="eintrag in scanOffeneAusleihenDesAusleihers"
            :key="`scan-loan-${eintrag.id}`"
            :class="[
              'scan-slot',
              'scan-loan-card',
              istAusleiheUeberfaellig(eintrag) ? 'is-overdue' : '',
              istScanAusleiheMarkiert(eintrag.id) ? 'is-selected' : 'is-pending'
            ]"
          >
            <span class="scan-loan-toggle">
              <input
                type="checkbox"
                :checked="istScanAusleiheMarkiert(eintrag.id)"
                @change="toggleScanAusleihe(eintrag.id, $event.target.checked)"
              />
              <span class="scan-slot-label">Markieren</span>
            </span>
            <strong>
              {{ eintrag.inventarnummer }}
              <span v-if="eintrag.barcode" class="scan-inline-badge">
                {{ eintrag.barcode }}
              </span>
            </strong>
            <small>{{ eintrag.titel }}</small>
            <small>
              Faellig:
              {{ eintrag.faellig_am ? formatDatum(eintrag.faellig_am) : "ohne Frist" }}
            </small>
            <small v-if="istAusleiheUeberfaellig(eintrag)">
              Ueberfaellig seit {{ tageUeberfaellig(eintrag) }} Tag{{ tageUeberfaellig(eintrag) === 1 ? "" : "en" }}
            </small>
          </label>
        </div>
      </div>

      <div class="button-row">
        <button
          class="warning"
          @click="emit('scan-bestaetigen')"
          :disabled="!scanBereitZurAusleihe"
        >
          Ausleihen
        </button>
        <button
          class="secondary"
          @click="emit('scan-rueckgabe')"
          :disabled="!scanBereitZurRueckgabe"
        >
          Rueckgabe
        </button>
        <button
          class="petrol"
          @click="emit('scan-verlaengern')"
          :disabled="!scanBereitZurRueckgabe"
        >
          Verlaengern
        </button>
      </div>
    </article>

    <article v-if="startAusleiheGeoeffnet" class="panel">
      <div class="panel-head">
        <h2>Ausleihe</h2>
        <span class="subtle">Scan, Kontrolle und Start</span>
      </div>

      <div class="form-grid">
        <label class="field">
          <span>Ausleiher</span>
          <select v-model="ausleiheForm.ausleiher_id">
            <option value="">Bitte waehlen</option>
            <optgroup label="Lehrkraefte">
              <option v-for="person in lehrkraftAusleiher" :key="person.id" :value="person.id">
                {{ person.name }}{{ person.klasse_oder_bereich ? ` - ${person.klasse_oder_bereich}` : "" }}
              </option>
            </optgroup>
            <optgroup label="Schueler">
              <option v-for="person in schuelerAusleiher" :key="person.id" :value="person.id">
                {{ person.name }}{{ person.klasse_oder_bereich ? ` - ${person.klasse_oder_bereich}` : "" }}
              </option>
            </optgroup>
            <optgroup label="Klassen">
              <option v-for="person in klassenAusleiher" :key="person.id" :value="person.id">
                {{ person.name }}
              </option>
            </optgroup>
          </select>
        </label>

        <label class="field">
          <span>Faellig am (zu Testen beliebiges Datum erlaubt).</span>
          <input v-model="ausleiheForm.faellig_am" type="date" />
        </label>

        <label class="field field-wide">
          <span>Exemplar</span>
          <div class="field-readonly-display" :class="{ 'is-empty': !scanDialog.exemplar }">
            <template v-if="scanDialog.exemplar">
              <strong>
                {{ scanDialog.exemplar.inventarnummer }}
                <span v-if="scanDialog.exemplar.barcode" class="scan-inline-badge">
                  {{ scanDialog.exemplar.barcode }}
                </span>
              </strong>
              <small>{{ scanDialog.exemplar.titel }}</small>
            </template>
            <span v-else>Noch kein Exemplar gescannt</span>
          </div>
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

      <div class="button-row start-actions">
        <button class="primary" @click="emit('ausleihe-starten')">Ausleihe buchen</button>
        <button class="ghost" @click="emit('ausleihe-abbrechen')">Abbrechen</button>
      </div>
    </article>

    <article v-if="startRueckgabeGeoeffnet" class="panel">
      <div class="panel-head">
        <h2>Rueckgabe</h2>
        <span class="subtle">Scan, Kontrolle und Buchung</span>
      </div>

      <div class="form-grid">
        <label class="field">
          <span>Ausleiher</span>
          <input
            :value="scanOffeneAusleiheZurRueckgabe?.ausleiher_name || ''"
            type="text"
            readonly
            placeholder="Noch kein Ausleiher erkannt"
          />
        </label>

        <label class="field field-wide">
          <span>Offene Ausleihe</span>
          <div class="field-readonly-display" :class="{ 'is-empty': !scanOffeneAusleiheZurRueckgabe }">
            <template v-if="scanOffeneAusleiheZurRueckgabe">
              <strong>
                {{ scanOffeneAusleiheZurRueckgabe.inventarnummer }}
                <span v-if="scanOffeneAusleiheZurRueckgabe.barcode" class="scan-inline-badge">
                  {{ scanOffeneAusleiheZurRueckgabe.barcode }}
                </span>
              </strong>
            </template>
            <span v-else>Noch keine passende offene Ausleihe erkannt</span>
          </div>
        </label>

        <label class="field field-highlight-green">
          <span>Zustand bei Ausgabe</span>
          <input
            :value="scanOffeneAusleiheZurRueckgabe?.zustand_bei_ausgabe || ''"
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

        <label class="field">
          <span>Faelligkeit</span>
          <input
            :value="scanOffeneAusleiheZurRueckgabe?.faellig_am ? formatDatum(scanOffeneAusleiheZurRueckgabe.faellig_am) : ''"
            type="text"
            readonly
            placeholder="Keine Frist hinterlegt"
          />
        </label>

        <label class="field field-wide">
          <span>Kommentar Rueckgabe</span>
          <textarea v-model="rueckgabeForm.kommentar_rueckgabe" rows="3"></textarea>
        </label>
      </div>

      <div class="button-row start-actions">
        <button class="secondary" @click="emit('rueckgabe-buchen')">Rueckgabe buchen</button>
        <button class="ghost" @click="emit('rueckgabe-abbrechen')">Abbrechen</button>
      </div>
    </article>

    <article v-if="startVerlaengerungGeoeffnet" class="panel">
      <div class="panel-head">
        <h2>Verlaengern</h2>
        <span class="subtle">Scan, Kontrolle und neue Frist</span>
      </div>

      <div class="form-grid">
        <label class="field">
          <span>Ausleiher</span>
          <input
            :value="scanOffeneAusleiheZurRueckgabe?.ausleiher_name || ''"
            type="text"
            readonly
            placeholder="Noch kein Ausleiher erkannt"
          />
        </label>

        <label class="field field-wide">
          <span>Offene Ausleihe</span>
          <div class="field-readonly-display" :class="{ 'is-empty': !scanOffeneAusleiheZurRueckgabe }">
            <template v-if="scanOffeneAusleiheZurRueckgabe">
              <strong>
                {{ scanOffeneAusleiheZurRueckgabe.inventarnummer }}
                <span v-if="scanOffeneAusleiheZurRueckgabe.barcode" class="scan-inline-badge">
                  {{ scanOffeneAusleiheZurRueckgabe.barcode }}
                </span>
              </strong>
            </template>
            <span v-else>Noch keine passende offene Ausleihe erkannt</span>
          </div>
        </label>

        <label class="field">
          <span>Aktuell faellig</span>
          <input
            :value="scanOffeneAusleiheZurRueckgabe?.faellig_am ? formatDatum(scanOffeneAusleiheZurRueckgabe.faellig_am) : ''"
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

      <div class="button-row start-actions">
        <button class="petrol" @click="emit('verlaengerung-speichern')">Ausleihe verlaengern</button>
        <button class="ghost" @click="emit('verlaengerung-abbrechen')">Abbrechen</button>
      </div>
    </article>
  </section>
</template>
