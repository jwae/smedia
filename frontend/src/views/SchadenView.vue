<script setup>
defineProps({
  offeneSchaeden: { type: Array, required: true },
  offeneReparaturen: { type: Array, required: true },
  exemplare: { type: Array, required: true },
  offeneAusleihen: { type: Array, required: true },
  schadenForm: { type: Object, required: true },
  reparaturForm: { type: Object, required: true },
  lehrkraftAusleiher: { type: Array, required: true },
  schuelerAusleiher: { type: Array, required: true },
  klassenAusleiher: { type: Array, required: true },
  reparaturen: { type: Array, required: true },
  formatDatum: { type: Function, required: true }
});

const emit = defineEmits([
  "schaden-speichern",
  "reparatur-starten",
  "reparatur-abschliessen"
]);
</script>

<template>
  <section class="listen-grid objekt-grid">
    <article class="panel">
      <div class="panel-head">
        <h2>Schaden melden</h2>
        <span class="subtle">{{ offeneSchaeden.length }} offen</span>
      </div>

      <div class="form-grid">
        <label class="field">
          <span>Exemplar</span>
          <select v-model="schadenForm.exemplar_id">
            <option value="">Bitte waehlen</option>
            <option v-for="eintrag in exemplare" :key="eintrag.id" :value="eintrag.id">
              {{ eintrag.inventarnummer }} - {{ eintrag.titel }}
            </option>
          </select>
        </label>

        <label class="field">
          <span>Gemeldet von</span>
          <select v-model="schadenForm.gemeldet_von_ausleiher_id">
            <option value="">Bitte waehlen</option>
            <optgroup label="Lehrkraefte">
              <option v-for="person in lehrkraftAusleiher" :key="`schaden-l-${person.id}`" :value="person.id">
                {{ person.name }}
              </option>
            </optgroup>
            <optgroup label="Schueler">
              <option v-for="person in schuelerAusleiher" :key="`schaden-s-${person.id}`" :value="person.id">
                {{ person.name }}
              </option>
            </optgroup>
            <optgroup label="Klassen">
              <option v-for="person in klassenAusleiher" :key="`schaden-k-${person.id}`" :value="person.id">
                {{ person.name }}
              </option>
            </optgroup>
          </select>
        </label>

        <label class="field">
          <span>Offene Ausleihe</span>
          <select v-model="schadenForm.ausleihe_id">
            <option value="">Keine direkte Zuordnung</option>
            <option v-for="eintrag in offeneAusleihen" :key="eintrag.id" :value="eintrag.id">
              {{ eintrag.inventarnummer }} - {{ eintrag.ausleiher_name }}
            </option>
          </select>
        </label>

        <label class="field">
          <span>Schadensgrad</span>
          <select v-model="schadenForm.schadensgrad">
            <option value="niedrig">niedrig</option>
            <option value="mittel">mittel</option>
            <option value="hoch">hoch</option>
          </select>
        </label>

        <label class="field field-wide">
          <span>Titel</span>
          <input v-model="schadenForm.titel" type="text" />
        </label>

        <label class="field field-wide">
          <span>Beschreibung</span>
          <textarea v-model="schadenForm.beschreibung" rows="3"></textarea>
        </label>
      </div>

      <button class="secondary wide-button" @click="emit('schaden-speichern')">
        Schadensmeldung speichern
      </button>
    </article>

    <article class="panel">
      <div class="panel-head">
        <h2>Reparatur starten</h2>
        <span class="subtle">{{ offeneReparaturen.length }} aktiv</span>
      </div>

      <div class="form-grid">
        <label class="field field-wide">
          <span>Schadensmeldung</span>
          <select v-model="reparaturForm.schadensmeldung_id">
            <option value="">Bitte waehlen</option>
            <option v-for="eintrag in offeneSchaeden" :key="eintrag.id" :value="eintrag.id">
              {{ eintrag.inventarnummer }} - {{ eintrag.titel }}
            </option>
          </select>
        </label>

        <label class="field">
          <span>Dienstleister</span>
          <input v-model="reparaturForm.dienstleister" type="text" />
        </label>

        <label class="field">
          <span>Kosten</span>
          <input v-model="reparaturForm.kosten" type="number" min="0" step="0.01" />
        </label>

        <label class="field field-wide">
          <span>Beschreibung</span>
          <textarea v-model="reparaturForm.beschreibung" rows="3"></textarea>
        </label>
      </div>

      <button class="primary wide-button" @click="emit('reparatur-starten')">
        Reparatur anlegen
      </button>
    </article>
  </section>

  <section class="listen-grid objekt-grid">
    <article class="panel">
      <div class="panel-head">
        <h2>Offene Schadensmeldungen</h2>
        <span class="subtle">{{ offeneSchaeden.length }} aktiv</span>
      </div>

      <div v-if="offeneSchaeden.length === 0" class="empty-state">
        Aktuell keine offenen Schadensmeldungen.
      </div>
      <div v-else class="historie-liste">
        <article v-for="eintrag in offeneSchaeden" :key="eintrag.id" class="historie-eintrag">
          <div class="historie-kopf">
            <strong>{{ eintrag.inventarnummer }} - {{ eintrag.titel }}</strong>
            <span>{{ eintrag.status }}</span>
          </div>
          <p>{{ eintrag.beschreibung }}</p>
          <div class="historie-meta">
            <span>Grad: {{ eintrag.schadensgrad }}</span>
            <span v-if="eintrag.gemeldet_von">von {{ eintrag.gemeldet_von }}</span>
            <span>{{ formatDatum(eintrag.gemeldet_am) }}</span>
          </div>
        </article>
      </div>
    </article>

    <article class="panel">
      <div class="panel-head">
        <h2>Reparaturen</h2>
        <span class="subtle">{{ reparaturen.length }} gesamt</span>
      </div>

      <div v-if="reparaturen.length === 0" class="empty-state">
        Noch keine Reparaturen vorhanden.
      </div>
      <div v-else class="historie-liste">
        <article v-for="eintrag in reparaturen" :key="eintrag.id" class="historie-eintrag">
          <div class="historie-kopf">
            <strong>{{ eintrag.inventarnummer }} - {{ eintrag.schaden_titel }}</strong>
            <span>{{ eintrag.status }}</span>
          </div>
          <p>{{ eintrag.beschreibung }}</p>
          <div class="historie-meta">
            <span v-if="eintrag.dienstleister">{{ eintrag.dienstleister }}</span>
            <span v-if="eintrag.kosten !== null">Kosten: {{ eintrag.kosten }} EUR</span>
            <span>{{ formatDatum(eintrag.gestartet_am) }}</span>
          </div>
          <button
            v-if="eintrag.status === 'offen'"
            class="ghost small-button"
            @click="emit('reparatur-abschliessen', eintrag.id)"
          >
            Reparatur abschliessen
          </button>
        </article>
      </div>
    </article>
  </section>
</template>
