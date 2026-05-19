import { ref, computed } from "vue";
import { apiRequest } from "../utils/api.js";

export function useHistorie() {
  const historieEintraege = ref([]);
  const historieGesamt = ref(0);
  const historieLaedtMehr = ref(false);
  const historieLoeschTage = ref("30");
  
  const apiFehler = ref("");
  const erfolgsMeldung = ref("");

  const kannMehrLaden = computed(() => historieEintraege.value.length < historieGesamt.value);

  async function ladeHistorieInitial() {
    try {
      const res = await apiRequest("/historie?limit=200&offset=0");
      historieEintraege.value = res.eintraege || [];
      historieGesamt.value = res.gesamt || 0;
    } catch (e) {
      apiFehler.value = e.message;
    }
  }

  async function ladeMehrHistorie() {
    if (historieLaedtMehr.value || !kannMehrLaden.value) return;
    
    historieLaedtMehr.value = true;
    try {
      const res = await apiRequest(`/historie?limit=200&offset=${historieEintraege.value.length}`);
      historieEintraege.value.push(...(res.eintraege || []));
      historieGesamt.value = res.gesamt || 0;
    } catch (e) {
      apiFehler.value = e.message;
    } finally {
      historieLaedtMehr.value = false;
    }
  }

  async function historieBereinigen() {
    const tage = Number(historieLoeschTage.value);
    if (!Number.isInteger(tage) || tage < 1) {
      apiFehler.value = "Bitte eine gültige Anzahl von Tagen für die Historie-Bereinigung angeben.";
      return;
    }
    
    apiFehler.value = "";
    erfolgsMeldung.value = "";
    try {
      const res = await apiRequest(`/historie?tage=${tage}`, { method: "DELETE" });
      erfolgsMeldung.value = res.meldung;
      await ladeHistorieInitial();
    } catch (e) {
      apiFehler.value = e.message;
    }
  }

  return {
    historieEintraege, historieGesamt, historieLaedtMehr, historieLoeschTage, kannMehrLaden,
    apiFehler, erfolgsMeldung,
    ladeHistorieInitial,
    ladeMehrHistorie,
    historieBereinigen
  };
}
