<script setup>
defineProps({
  modus: { type: String, required: true },
  exemplare: { type: Array, required: true },
  inventarGeoeffnet: { type: Boolean, required: true },
  laedtDaten: { type: Boolean, required: true },
  offeneAusleihen: { type: Array, required: true },
  offeneAusleihenGeoeffnet: { type: Boolean, required: true },
  formatDatum: { type: Function, required: true },
  ausgewaehltesExemplar: { type: Object, required: false, default: null },
  ausgewaehltesBuch: { type: Object, required: false, default: null },
  ausgewaehltesExemplarId: { type: [String, Number], required: true },
  exemplarForm: { type: Object, required: true },
  standorte: { type: Array, required: true },
  objektHistorie: { type: Array, required: true },
  objektHistorieSeite: { type: Number, required: false, default: 1 },
  objektHistorieGesamt: { type: Number, required: false, default: 0 },
  objektHistorieLimit: { type: Number, required: false, default: 10 }
});

const emit = defineEmits([
  "toggle-inventar-geoeffnet",
  "toggle-offene-ausleihen-geoeffnet",
  "update:ausgewaehltes-exemplar-id",
  "waehle-exemplar",
  "exemplar-speichern",
  "exemplar-loeschen-anfragen",
  "historie-seite-wechseln"
]);
</script>

<template>
  <section class="listen-grid">
    <article v-if="modus === 'rueckgabe'" class="panel">
      <div class="panel-head">
        <h2>Offene Ausleihen</h2>
        <div class="button-row panel-head-actions">
          <span class="subtle">{{ offeneAusleihen.length }} aktiv</span>
          <button class="ghost small-button icon-toggle" @click="emit('toggle-offene-ausleihen-geoeffnet')">
            <span :class="['chevron', offeneAusleihenGeoeffnet ? 'is-open' : '']"></span>
            {{ offeneAusleihenGeoeffnet ? "Einklappen" : "Aufklappen" }}
          </button>
        </div>
      </div>

      <div v-if="!offeneAusleihenGeoeffnet" class="empty-state">
        Offene Ausleihen sind eingeklappt.
      </div>
      <div v-else-if="offeneAusleihen.length === 0" class="empty-state">
        Aktuell keine offenen Ausleihen.
      </div>
      <div v-else class="loan-list">
        <article v-for="eintrag in offeneAusleihen" :key="eintrag.id" class="loan-card">
          <div class="loan-card-head">
            <div class="loan-title-block">
              <strong>{{ eintrag.inventarnummer }}</strong>
              <span class="loan-type">{{ eintrag.titel }}</span>
            </div>
            <span :class="['faelligkeits-badge', 'loan-head-badge', eintrag.faelligkeit?.klasse || 'faellig-neutral']">
              <span
                v-if="eintrag.faelligkeit?.symbol"
                class="faelligkeits-symbol"
                aria-hidden="true"
              >
                {{ eintrag.faelligkeit.symbol }}
              </span>
              {{ eintrag.faelligkeit?.text || "ohne Frist" }}
            </span>
          </div>
          <p class="loan-person">
            {{ eintrag.ausleiher_name }}
            <span>{{ eintrag.ausleiher_typ }}</span>
          </p>
          <div class="loan-meta">
            <span>Ausgabe: {{ formatDatum(eintrag.ausgabe_am) }}</span>
            <span>Faellig: {{ formatDatum(eintrag.faellig_am) }}</span>
          </div>
        </article>
      </div>
    </article>
  </section>

  <section v-if="modus === 'objekte'" class="listen-grid objekt-grid">
    <article class="panel">
      <div class="panel-head">
        <h2>Objektpflege</h2>
        <span class="subtle">Historie pro Exemplar</span>
      </div>

      <div
        v-if="ausgewaehltesExemplar && (ausgewaehltesExemplar.cover_bild || ausgewaehltesExemplar.cover_url)"
        class="buch-cover-box"
      >
        <img
          :src="ausgewaehltesExemplar.cover_bild || ausgewaehltesExemplar.cover_url"
          :alt="`Foto von ${ausgewaehltesExemplar.titel}`"
          class="buch-cover"
        />
      </div>

      <div v-if="ausgewaehltesBuch" class="buchdetails-box">
        <div class="panel-head compact-head">
          <h3>Buchdetails</h3>
          <span class="subtle">{{ ausgewaehltesBuch.inventarnummer }}</span>
        </div>
        <div class="buchdetails-grid">
          <div>
            <span class="buchdetails-label">Titel</span>
            <strong>{{ ausgewaehltesBuch.titel || "unbekannt" }}</strong>
          </div>
          <div>
            <span class="buchdetails-label">Autor</span>
            <strong>{{ ausgewaehltesBuch.autor || "unbekannt" }}</strong>
          </div>
          <div>
            <span class="buchdetails-label">Verlag</span>
            <strong>{{ ausgewaehltesBuch.verlag || "unbekannt" }}</strong>
          </div>
          <div>
            <span class="buchdetails-label">Fach</span>
            <strong>{{ ausgewaehltesBuch.fach || "unbekannt" }}</strong>
          </div>
          <div>
            <span class="buchdetails-label">EAN / ISBN-13</span>
            <strong>{{ ausgewaehltesBuch.titelcode || "unbekannt" }}</strong>
          </div>
          <div>
            <span class="buchdetails-label">Veroeffentlicht</span>
            <strong>{{ ausgewaehltesBuch.veroeffentlicht || "unbekannt" }}</strong>
          </div>
        </div>
      </div>

      <div class="form-grid">
        <label class="field field-wide">
          <span>Exemplar</span>
          <select
            :value="ausgewaehltesExemplarId"
            @change="emit('update:ausgewaehltes-exemplar-id', $event.target.value); emit('waehle-exemplar', Number($event.target.value))"
          >
            <option value="">Bitte waehlen</option>
            <option v-for="eintrag in exemplare" :key="eintrag.id" :value="eintrag.id">
              {{ eintrag.inventarnummer }} - {{ eintrag.titel }}
            </option>
          </select>
        </label>

        <label class="field">
          <span>Status</span>
          <select v-model="exemplarForm.status">
            <option value="verfuegbar">verfuegbar</option>
            <option value="reserviert">reserviert</option>
            <option value="ausgeliehen">ausgeliehen</option>
            <option value="defekt">defekt</option>
            <option value="in_reparatur">in_reparatur</option>
            <option value="verloren">verloren</option>
            <option value="ausgesondert">ausgesondert</option>
          </select>
        </label>

        <label class="field">
          <span>Zustand</span>
          <select v-model="exemplarForm.zustand">
            <option value="neu">neu</option>
            <option value="sehr_gut">sehr_gut</option>
            <option value="gut">gut</option>
            <option value="gebraucht">gebraucht</option>
            <option value="beschaedigt">beschaedigt</option>
            <option value="unvollstaendig">unvollstaendig</option>
          </select>
        </label>

        <label class="field">
          <span>Standort</span>
          <select v-model="exemplarForm.standort_id">
            <option value="">Kein Standort</option>
            <option v-for="standort in standorte" :key="standort.id" :value="standort.id">
              {{ standort.bezeichnung }}
            </option>
          </select>
        </label>

        <label class="field field-wide">
          <span>Notizen</span>
          <textarea v-model="exemplarForm.notizen" rows="3"></textarea>
        </label>
      </div>

      <div class="button-row objekt-action-row objekt-action-row-spaced">
        <button class="primary wide-button" @click="emit('exemplar-speichern')" :disabled="!ausgewaehltesExemplar">
          Objekt aktualisieren
        </button>
        <button
          class="danger wide-button"
          @click="emit('exemplar-loeschen-anfragen')"
          :disabled="!ausgewaehltesExemplar || ausgewaehltesExemplar.status === 'ausgeliehen'"
        >
          Objekt loeschen
        </button>
      </div>
    </article>

    <article class="panel">
      <div class="panel-head">
        <h2>Objekthistorie</h2>
        <span class="subtle">
          {{ ausgewaehltesExemplar ? ausgewaehltesExemplar.inventarnummer : "kein Exemplar" }}
        </span>
      </div>

      <div v-if="laedtDaten" class="empty-state">
        Lade Historie...
      </div>
      <div v-else-if="objektHistorie.length === 0" class="empty-state">
        Fuer dieses Exemplar sind noch keine Eintraege vorhanden.
      </div>
      <div v-else class="table-shell historie-table-shell">
        <table class="historie-table objekt-historie-table">
          <thead>
            <tr>
              <th>Datum</th>
              <th>Aktion</th>
              <th>Titel</th>
              <th>Details</th>
              <th>Ausgeloest von</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="eintrag in objektHistorie" :key="eintrag.id">
              <td :title="formatDatum(eintrag.erstellt_am)">
                <span class="objekt-historie-cell objekt-historie-date">{{ formatDatum(eintrag.erstellt_am) }}</span>
              </td>
              <td :title="eintrag.aktion || '-'">
                <span class="objekt-historie-cell">{{ eintrag.aktion || "-" }}</span>
              </td>
              <td :title="eintrag.titel || '-'">
                <span class="objekt-historie-cell">{{ eintrag.titel || "-" }}</span>
              </td>
              <td :title="eintrag.details || '-'">
                <span class="objekt-historie-cell">{{ eintrag.details || "-" }}</span>
              </td>
              <td :title="eintrag.ausgeloest_von || '-'">
                <span class="objekt-historie-cell">{{ eintrag.ausgeloest_von || "-" }}</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <div v-if="objektHistorieGesamt > objektHistorieLimit" class="button-row" style="margin-top: 1rem; justify-content: center; align-items: center;">
        <button
          class="btn-secondary small-button"
          :disabled="objektHistorieSeite <= 1"
          @click="emit('historie-seite-wechseln', objektHistorieSeite - 1)"
        >
          Zurueck
        </button>
        <span class="subtle" style="font-size: 0.875rem;">
          Seite {{ objektHistorieSeite }} von {{ Math.ceil(objektHistorieGesamt / objektHistorieLimit) }}
        </span>
        <button
          class="btn-secondary small-button"
          :disabled="objektHistorieSeite >= Math.ceil(objektHistorieGesamt / objektHistorieLimit)"
          @click="emit('historie-seite-wechseln', objektHistorieSeite + 1)"
        >
          Weiter
        </button>
      </div>
    </article>
  </section>
</template>
