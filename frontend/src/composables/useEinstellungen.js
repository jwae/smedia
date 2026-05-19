import { computed, ref } from "vue";

const EINSTELLUNGS_BEREICHE = [
  {
    id: "schueler",
    label: "Schueler",
    beschreibung: "Schuelerstammdaten bearbeiten."
  },
  {
    id: "klassen",
    label: "Klassen",
    beschreibung: "Klassendaten bearbeiten."
  },
  {
    id: "lehrer",
    label: "Lehrer",
    beschreibung: "Lehrkraefte, Fachbereiche und Ausleihvorgaben pflegen."
  },
  {
    id: "benutzer",
    label: "Benutzer",
    beschreibung: "Zugaenge, Rollen und Oberflaechenverhalten steuern."
  },
  {
    id: "geraete",
    label: "Geraete",
    beschreibung: "Nummernkreise, Standardwerte und Pflegefelder fuer Geraete setzen."
  },
  {
    id: "buecher",
    label: "Buecher",
    beschreibung: "Titelimport, Klassensatz-Defaults und Buchmetadaten konfigurieren."
  },
  {
    id: "ausleiher",
    label: "Ausleiher",
    beschreibung: "Zentrale Ausleiher-Tabelle einsehen."
  },
  {
    id: "vertragsvorlagen",
    label: "Vertragsvorlagen",
    beschreibung: "Versionierte Rechtstexte fuer Leihvertraege pflegen."
  }
];

export function useEinstellungen() {
  const aktiverBereich = ref(EINSTELLUNGS_BEREICHE[0].id);

  const bereiche = computed(() => EINSTELLUNGS_BEREICHE);
  const aktiverEintrag = computed(
    () => EINSTELLUNGS_BEREICHE.find((eintrag) => eintrag.id === aktiverBereich.value) || EINSTELLUNGS_BEREICHE[0]
  );

  function wechsleBereich(bereichId) {
    if (EINSTELLUNGS_BEREICHE.some((eintrag) => eintrag.id === bereichId)) {
      aktiverBereich.value = bereichId;
    }
  }

  return {
    bereiche,
    aktiverBereich,
    aktiverEintrag,
    wechsleBereich
  };
}
