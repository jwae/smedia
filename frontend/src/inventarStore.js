import { defineStore } from "pinia";
import { ref } from "vue";

export const useInventarStore = defineStore("inventar", () => {
  // State (unsere zentralen Daten)
  const exemplare = ref([]);
  const ausleiher = ref([]);
  const offeneAusleihen = ref([]);

  // Actions (Funktionen, um die Daten zu verändern)
  function setzeDaten(neueExemplare, neueAusleiher, neueOffeneAusleihen) {
    exemplare.value = neueExemplare || [];
    ausleiher.value = neueAusleiher || [];
    offeneAusleihen.value = neueOffeneAusleihen || [];
  }

  // Alles zurückgeben, was andere Komponenten nutzen dürfen
  return { exemplare, ausleiher, offeneAusleihen, setzeDaten };
});