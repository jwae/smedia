import { ref } from "vue";
import { apiRequest } from "../utils/api.js";

export function useSchaden(onSuccess) {
  const apiFehler = ref("");
  const erfolgsMeldung = ref("");

  const schadenForm = ref({
    exemplar_id: "",
    ausleihe_id: "",
    gemeldet_von_ausleiher_id: "",
    titel: "",
    beschreibung: "",
    schadensgrad: "mittel"
  });

  const reparaturForm = ref({
    schadensmeldung_id: "",
    dienstleister: "",
    beschreibung: "",
    kosten: ""
  });

  async function schadenSpeichern() {
    apiFehler.value = "";
    erfolgsMeldung.value = "";
    try {
      await apiRequest("/schaeden", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ...schadenForm.value,
          ausleihe_id: schadenForm.value.ausleihe_id || null,
          gemeldet_von_ausleiher_id: schadenForm.value.gemeldet_von_ausleiher_id || null
        })
      });
      erfolgsMeldung.value = "Schadensmeldung wurde gespeichert.";
      schadenForm.value = { exemplar_id: "", ausleihe_id: "", gemeldet_von_ausleiher_id: "", titel: "", beschreibung: "", schadensgrad: "mittel" };
      if (onSuccess) await onSuccess();
    } catch (e) {
      apiFehler.value = e.message;
    }
  }

  async function reparaturStarten() {
    apiFehler.value = "";
    erfolgsMeldung.value = "";
    try {
      await apiRequest("/reparaturen", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ...reparaturForm.value,
          kosten: reparaturForm.value.kosten ? Number(reparaturForm.value.kosten) : null
        })
      });
      erfolgsMeldung.value = "Reparatur wurde gestartet.";
      reparaturForm.value = { schadensmeldung_id: "", dienstleister: "", beschreibung: "", kosten: "" };
      if (onSuccess) await onSuccess();
    } catch (e) {
      apiFehler.value = e.message;
    }
  }

  async function reparaturAbschliessen(reparaturId) {
    apiFehler.value = "";
    erfolgsMeldung.value = "";
    try {
      await apiRequest(`/reparaturen/${reparaturId}/abschliessen`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          neuer_status: "verfuegbar",
          neuer_zustand: "gut",
          abschluss_notiz: "Reparatur in der Arbeitsoberflaeche abgeschlossen."
        })
      });
      erfolgsMeldung.value = "Reparatur wurde abgeschlossen.";
      if (onSuccess) await onSuccess();
    } catch (e) {
      apiFehler.value = e.message;
    }
  }

  return {
    schadenForm, reparaturForm, apiFehler, erfolgsMeldung,
    schadenSpeichern, reparaturStarten, reparaturAbschliessen
  };
}
