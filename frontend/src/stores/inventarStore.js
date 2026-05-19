import { defineStore } from "pinia";
import { computed, ref } from "vue";

export const useInventarStore = defineStore("inventar", () => {
  // State (unsere zentralen Daten)
  const exemplare = ref([]);
  const ausleiher = ref([]);
  const offeneAusleihen = ref([]);

  // Getters (abgeleitete Daten)
  const verfuegbareExemplare = computed(() =>
    exemplare.value.filter((eintrag) => eintrag.status === "verfuegbar")
  );

  const klassenAusleiher = computed(() =>
    ausleiher.value.filter((eintrag) => eintrag.ausleiher_typ === "klasse" && eintrag.aktiv !== false)
  );

  const lehrkraftAusleiher = computed(() =>
    ausleiher.value.filter((eintrag) => eintrag.ausleiher_typ === "lehrkraft" && eintrag.aktiv !== false)
  );

  const schuelerAusleiher = computed(() =>
    ausleiher.value.filter((eintrag) => eintrag.ausleiher_typ === "schueler" && eintrag.aktiv !== false)
  );

  // Actions (Funktionen, um die Daten zu verändern)
  function setzeDaten(neueExemplare, neueAusleiher, neueOffeneAusleihen) {
    exemplare.value = neueExemplare || [];
    ausleiher.value = neueAusleiher || [];
    offeneAusleihen.value = neueOffeneAusleihen || [];
  }

  // Alles zurückgeben, was andere Komponenten nutzen dürfen
  return { 
    exemplare, 
    ausleiher, 
    offeneAusleihen, 
    verfuegbareExemplare,
    klassenAusleiher,
    lehrkraftAusleiher,
    schuelerAusleiher,
    setzeDaten 
  };
});
