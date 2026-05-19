<script setup>
import TagesfokusModule from "../components/TagesfokusModule.vue";

defineProps({
  offeneAusleihen: { type: Array, required: true },
  historieEintraege: { type: Array, required: true },
  formatDatum: { type: Function, required: true }
});
</script>

<template>
  <TagesfokusModule
    :offene-ausleihen="offeneAusleihen"
    :historie-eintraege="historieEintraege"
    :format-datum="formatDatum"
  />
</template>
