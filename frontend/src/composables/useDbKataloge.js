import { computed, ref } from "vue";

const DB_KATALOGE = [
  {
    id: "artikel_kategorie",
    label: "Artikel-Kategorie",
    beschreibung: "Kategorien fuer Artikelstammdaten strukturieren."
  },
  {
    id: "artikel",
    label: "Artikel",
    beschreibung: "Artikelstammdaten direkt in der Tabelle artikel pflegen."
  },
  {
    id: "ausleiharten",
    label: "Ausleiharten",
    beschreibung: "Ausleiharten und ihre Bezeichnungen pflegen."
  },
  {
    id: "faecher",
    label: "Faecher",
    beschreibung: "Fachkatalog fuer Buecher und Medien verwalten."
  },
  {
    id: "herkunft",
    label: "Herkunft",
    beschreibung: "Bezugsquellen und Herkunftsarten hinterlegen."
  },
  {
    id: "inventar_typen",
    label: "Inventar-Typen",
    beschreibung: "Typen fuer Inventargegenstaende definieren."
  },
  {
    id: "standorte",
    label: "Standorte",
    beschreibung: "Standorte und Aufstellungsorte konfigurieren."
  },
  {
    id: "statuskatalog",
    label: "Statuskatalog",
    beschreibung: "Statuswerte fuer Exemplare pflegen."
  },
  {
    id: "vertrags_vorlagen",
    label: "Vertragsvorlagen",
    beschreibung: "Versionierte Vorlagen fuer Leihvertraege verwalten."
  },
  {
    id: "zustandskatalog",
    label: "Zustandskatalog",
    beschreibung: "Zustandsbeschreibungen fuer Exemplare verwalten."
  }
];

export function useDbKataloge() {
  const aktiverBereich = ref(DB_KATALOGE[0].id);

  const bereiche = computed(() => DB_KATALOGE);
  const aktiverEintrag = computed(
    () => DB_KATALOGE.find((eintrag) => eintrag.id === aktiverBereich.value) || DB_KATALOGE[0]
  );

  function wechsleBereich(bereichId) {
    if (DB_KATALOGE.some((eintrag) => eintrag.id === bereichId)) {
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
