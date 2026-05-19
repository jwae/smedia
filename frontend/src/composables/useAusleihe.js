import { ref } from "vue";
import { apiRequest } from "../utils/api.js";

export function useAusleihe(onSuccess) {
  const apiFehler = ref("");
  const erfolgsMeldung = ref("");

  const ausleiheForm = ref({
    exemplar_id: "",
    ausleiher_id: "",
    faellig_am: "",
    kommentar_ausgabe: ""
  });

  const rueckgabeForm = ref({
    ausleihe_id: "",
    zustand_bei_rueckgabe: "gut",
    kommentar_rueckgabe: ""
  });

  const verlaengerungForm = ref({
    ausleihe_id: "",
    faellig_am: "",
    kommentar_verlaengerung: ""
  });

  async function ausleiheSpeichern(wirksameFaelligkeit) {
    apiFehler.value = "";
    erfolgsMeldung.value = "";
    try {
      const response = await apiRequest("/ausleihen", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ...ausleiheForm.value,
          faellig_am: wirksameFaelligkeit
        })
      });
      erfolgsMeldung.value = `Ausleihe gespeichert. Faellig am ${response.faellig_am}`;
      ausleiheForm.value = { exemplar_id: "", ausleiher_id: "", faellig_am: "", kommentar_ausgabe: "" };
      if (onSuccess) await onSuccess();
    } catch (error) {
      apiFehler.value = error.message;
    }
  }

  async function rueckgabeSpeichern() {
    apiFehler.value = "";
    erfolgsMeldung.value = "";
    try {
      await apiRequest(`/ausleihen/${rueckgabeForm.value.ausleihe_id}/rueckgabe`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          zustand_bei_rueckgabe: rueckgabeForm.value.zustand_bei_rueckgabe,
          kommentar_rueckgabe: rueckgabeForm.value.kommentar_rueckgabe
        })
      });
      erfolgsMeldung.value = "Rueckgabe wurde verbucht.";
      rueckgabeForm.value = { ausleihe_id: "", zustand_bei_rueckgabe: "gut", kommentar_rueckgabe: "" };
      if (onSuccess) await onSuccess();
    } catch (error) {
      apiFehler.value = error.message;
    }
  }

  return {
    ausleiheForm,
    rueckgabeForm,
    verlaengerungForm,
    apiFehler,
    erfolgsMeldung,
    ausleiheSpeichern,
    rueckgabeSpeichern
  };
}