<script setup>
defineProps({
  offeneAusleihen: { type: Array, required: true },
  historieEintraege: { type: Array, required: true },
  formatDatum: { type: Function, required: true }
});
</script>

<template>
  <section class="listen-grid">
    <article class="panel">
      <div class="panel-head">
        <h2>Tagesfokus</h2>
        <span class="subtle">Heute wichtig</span>
      </div>

      <div v-if="offeneAusleihen.length === 0" class="empty-state">
        Aktuell keine offenen Ausleihen.
      </div>
      <div v-else class="historie-liste">
        <article
          v-for="eintrag in offeneAusleihen.slice(0, 5)"
          :key="`start-loan-${eintrag.id}`"
          class="historie-eintrag"
        >
          <div class="historie-kopf">
            <strong>{{ eintrag.inventarnummer }}</strong>
            <span>{{ eintrag.faelligkeit?.text || "ohne Frist" }}</span>
          </div>
          <p>{{ eintrag.titel }} · {{ eintrag.ausleiher_name }}</p>
        </article>
      </div>

      <div class="historie-liste">
        <article
          v-for="eintrag in historieEintraege.slice(0, 5)"
          :key="`start-hist-${eintrag.id}`"
          class="historie-eintrag"
        >
          <div class="historie-kopf">
            <strong>{{ eintrag.titel }}</strong>
            <span>{{ formatDatum(eintrag.erstellt_am) }}</span>
          </div>
          <p>{{ eintrag.details }}</p>
        </article>
      </div>
    </article>
  </section>
</template>
