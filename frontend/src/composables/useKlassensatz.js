import { ref, computed } from "vue";
import { apiRequest } from "../utils/api.js";

export function useKlassensatz(exemplare) {
  const klassensatzForm = ref({
    ausleiher_id: "",
    exemplar_ids: [],
    faellig_am: "",
    kommentar_ausgabe: ""
  });

  const verfuegbareKlassensatzBuecher = computed(() =>
    exemplare.value.filter(
      (eintrag) =>
        eintrag.inventar_typ === "buch" &&
        eintrag.ist_klassensatz &&
        eintrag.status === "verfuegbar"
    )
  );

  const klassensatzGruppen = computed(() => {
    const gruppen = new Map();

    for (const eintrag of verfuegbareKlassensatzBuecher.value) {
      const schluessel = eintrag.klassensatz_name || eintrag.titel;
      const vorhanden = gruppen.get(schluessel);

      if (vorhanden) {
        vorhanden.exemplar_ids.push(eintrag.id);
        vorhanden.anzahl_verfuegbar += 1;
      } else {
        gruppen.set(schluessel, {
          schluessel,
          titel: eintrag.titel,
          verlag: eintrag.verlag || "",
          klassensatz_name: eintrag.klassensatz_name || "Klassensatz",
          anzahl_verfuegbar: 1,
          exemplar_ids: [eintrag.id]
        });
      }
    }

    return [...gruppen.values()].sort((links, rechts) =>
      links.klassensatz_name.localeCompare(rechts.klassensatz_name, "de")
    );
  });

  function toggleKlassensatzExemplar(exemplarId) {
    const vorhandene = new Set(klassensatzForm.value.exemplar_ids);

    if (vorhandene.has(exemplarId)) {
      vorhandene.delete(exemplarId);
    } else {
      vorhandene.add(exemplarId);
    }

    klassensatzForm.value.exemplar_ids = [...vorhandene];
  }

  function istKlassensatzGruppeAusgewaehlt(gruppe) {
    return gruppe.exemplar_ids.every((id) => klassensatzForm.value.exemplar_ids.includes(id));
  }

  function toggleKlassensatzGruppe(gruppe) {
    const vorhandene = new Set(klassensatzForm.value.exemplar_ids);
    const istAusgewaehlt = istKlassensatzGruppeAusgewaehlt(gruppe);

    for (const exemplarId of gruppe.exemplar_ids) {
      if (istAusgewaehlt) {
        vorhandene.delete(exemplarId);
      } else {
        vorhandene.add(exemplarId);
      }
    }

    klassensatzForm.value.exemplar_ids = [...vorhandene];
  }

  async function klassensatzAusgabeSpeichern(onSuccess, onError) {
    try {
      const response = await apiRequest("/klassensaetze/ausgabe", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(klassensatzForm.value)
      });

      klassensatzForm.value = { ausleiher_id: "", exemplar_ids: [], faellig_am: "", kommentar_ausgabe: "" };

      if (onSuccess) await onSuccess(response);
    } catch (error) {
      if (onError) onError(error.message);
    }
  }

  return {
    klassensatzForm, klassensatzGruppen, 
    toggleKlassensatzExemplar, istKlassensatzGruppeAusgewaehlt, 
    toggleKlassensatzGruppe, klassensatzAusgabeSpeichern
  };
}
