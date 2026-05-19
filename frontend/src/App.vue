<script setup>
import { computed, nextTick, onMounted, onUnmounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";
import { storeToRefs } from "pinia";
import ModulNavigation from "./components/ModulNavigation.vue";
import { useScanner } from "./composables/useScanner.js";
import { useInventarStore } from "./stores/inventarStore.js";
import { useDruck } from "./composables/useDruck.js";
import { apiRequest } from "./utils/api.js";

const dashboard = ref(null);
const inventarStore = useInventarStore();
const { 
  exemplare, ausleiher, offeneAusleihen,
  verfuegbareExemplare, klassenAusleiher, lehrkraftAusleiher, schuelerAusleiher
} = storeToRefs(inventarStore);
const route = useRoute();
const router = useRouter();

const {
  druckKategorie, druckCodeFormat, druckFilter, qrCodeSvgMap,
  inventarTypenFuerDruck, standorteFuerDruck, statuswerteFuerDruck,
  klassenFuerDruck, fachbereicheFuerDruck, druckFilterAktiv,
  ausgabebelegFilter, ausgabebelegFilterAktiv, ausgabebelegLayout, barcodeDruckEintraege, ausgabebelegEintraege,
  ausgabebelegGruppen, leihvertraegeSammeldruckEintraege,
  code39Svg, druckeBarcodes, druckeAusgabebelege, druckFilterZuruecksetzen, ausgabebelegFilterZuruecksetzen
} = useDruck(exemplare, schuelerAusleiher, lehrkraftAusleiher, klassenAusleiher, offeneAusleihen);

const {
  scannerGeraetLabel, scannerStatus, scanResult, scanType, manuelleCodeEingabe, lastError,
  scanDialog, markierteScanAusleihen, scanBereitZurAusleihe, scanOffeneAusleiheZurRueckgabe,
  scanOffeneAusleihenDesAusleihers, scanMarkierteAusleihe, scanAktiveAusleihe, scanBereitZurRueckgabe,
  scanHinweisText, fokussiereScannerEingabe, leereScannerEingaben, scanDialogZuruecksetzen, resetResult,
  verarbeiteErkanntenCode, manuelleCodePruefung, uebernehmeScanAusleiher, uebernehmeScanExemplar,
  exemplarHatWarnstatus, exemplarWarntext,
  istAusleiheUeberfaellig, tageUeberfaellig
} = useScanner(exemplare, ausleiher, offeneAusleihen);

const historieEintraege = ref([]);
const historieGesamt = ref(0);
const historieFilter = ref("");
const historieDatumFilter = ref("");
const historieLoeschTage = ref("30");
const historieLaedtMehr = ref(false);
const historieBatchGroesse = 200;
const objektHistorie = ref([]);
const objektHistorieGesamt = ref(0);
const objektHistorieSeite = ref(1);
const objektHistorieLimit = ref(10);
const overlayExemplarId = ref(null);
const overlayHistorie = ref([]);
const artikel = ref([]);
const inventarTypen = ref([]);
const artikelKategorien = ref([]);
const standorte = ref([]);
const faecher = ref([]);
const herkunft = ref([]);
const schaeden = ref([]);
const reparaturen = ref([]);
const inventarGeoeffnet = ref(true);
const offeneAusleihenGeoeffnet = ref(true);
const historieGeoeffnet = ref(true);
const ausgewaehltesExemplarId = ref("");
const laedtDaten = ref(true);
const apiFehler = ref("");
const erfolgsMeldung = ref("");
const geraeteSuche = ref("");
const geraeteAusgewaehlt = ref(new Set());
const loeschenDialog = ref(false);
const historieLoeschenDialog = ref(false);
const loeschenFehler = ref("");
const externerBuchTitelcode = ref("");

function datumPlusTageAlsIsoDatum(tage) {
  const datum = new Date();
  datum.setDate(datum.getDate() + tage);
  const pad = (wert) => String(wert).padStart(2, "0");
  return `${datum.getFullYear()}-${pad(datum.getMonth() + 1)}-${pad(datum.getDate())}`;
}

function standardFaelligkeitAusleihe() {
  return datumPlusTageAlsIsoDatum(7);
}

const ausleiheForm = ref({
  exemplar_id: "",
  ausleiher_id: "",
  faellig_am: standardFaelligkeitAusleihe(),
  kommentar_ausgabe: ""
});
const ausleiheManuelleExemplarEingabe = ref("");
const ausleiheScanExemplarEingabe = ref("");

const klassensatzForm = ref({
  ausleiher_id: "",
  exemplar_ids: [],
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

const exemplarForm = ref({
  status: "",
  zustand: "",
  standort_id: "",
  notizen: ""
});

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

const objektpflegeBereich = ref(null);
const aktivesModul = computed(() => route.name || "start");
const startSuche = ref("");
const startAusleiheGeoeffnet = ref(false);
const startRueckgabeGeoeffnet = ref(false);
const startVerlaengerungGeoeffnet = ref(false);

  const modulNavigation = [
  { id: "start", label: "Start" },
  { id: "manuelle-buchung", label: "Manuelle Buchung" },
  { id: "buecher", label: "Medienverwaltung" },
  { id: "schaden", label: "Schaden & Reparatur" },
  { id: "historie", label: "Historie" },
  { id: "druck", label: "Druck" },
  { id: "tagesfokus", label: "Tagesfokus" },
  { id: "einstellungen", label: "Einstellungen" },
  { id: "db", label: "DB" }
];

const geraeteVerfuegbar = computed(() =>
  geraeteGefiltert.value.filter((e) => e.status === "verfuegbar")
);

const geraeteAlleAusgewaehlt = computed({
  get: () =>
    geraeteVerfuegbar.value.length > 0 &&
    geraeteVerfuegbar.value.every((e) => geraeteAusgewaehlt.value.has(e.id)),
  set: (val) => {
    const next = new Set(geraeteAusgewaehlt.value);
    geraeteVerfuegbar.value.forEach((e) => (val ? next.add(e.id) : next.delete(e.id)));
    geraeteAusgewaehlt.value = next;
  }
});

const geraeteGefiltert = computed(() => {
  const suchtext = geraeteSuche.value.trim().toLowerCase();
  return exemplare.value.filter((e) => {
    if (!suchtext) return true;
    return (
      (e.inventarnummer || "").toLowerCase().includes(suchtext) ||
      (e.titel || "").toLowerCase().includes(suchtext) ||
      (e.inventar_typ || "").toLowerCase().includes(suchtext) ||
      (e.status || "").toLowerCase().includes(suchtext) ||
      (e.zustand || "").toLowerCase().includes(suchtext) ||
      (e.standort || "").toLowerCase().includes(suchtext) ||
      (e.seriennummer || "").toLowerCase().includes(suchtext)
    );
  });
});

async function ladeUebersicht() {
  const [uebersicht, exemplarListe, ausleiherListe, historieListe, standortListe, schadenListe, reparaturListe, artikelListe, inventarTypenListe, artikelKategorienListe] = await Promise.all([
    apiRequest("/uebersicht"),
    apiRequest("/exemplare"),
    apiRequest("/ausleiher"),
    apiRequest(`/historie?limit=${historieBatchGroesse}&offset=0`),
    apiRequest("/standorte"),
    apiRequest("/schaeden"),
    apiRequest("/reparaturen"),
    apiRequest("/artikel"),
    apiRequest("/inventar-typen"),
    apiRequest("/artikel-kategorien")
  ]);
  const faecherListe = await apiRequest("/faecher").catch(() => faecher.value);
  const herkunftListe = await apiRequest("/herkunft").catch(() => herkunft.value);

  dashboard.value = uebersicht.kennzahlen;
  inventarStore.setzeDaten(exemplarListe, ausleiherListe, uebersicht.offene_ausleihen);
  historieEintraege.value = historieListe.eintraege;
  historieGesamt.value = historieListe.gesamt;
  artikel.value = artikelListe;
  inventarTypen.value = inventarTypenListe;
  artikelKategorien.value = artikelKategorienListe;
  standorte.value = standortListe;
  schaeden.value = schadenListe;
  reparaturen.value = reparaturListe;
  faecher.value = faecherListe;
  herkunft.value = herkunftListe;

  if (!ausgewaehltesExemplarId.value && exemplarListe.length > 0) {
    waehleExemplar(exemplarListe[0].id);
  } else if (ausgewaehltesExemplarId.value) {
    await ladeObjektHistorie(ausgewaehltesExemplarId.value);
  }
}

async function ladeObjektHistorie(exemplarId, seite = 1) {
  if (!exemplarId) {
    objektHistorie.value = [];
    objektHistorieGesamt.value = 0;
    return;
  }

  const limit = objektHistorieLimit.value;
  const offset = (seite - 1) * limit;

  const response = await apiRequest(`/historie?exemplar_id=${exemplarId}&limit=${limit}&offset=${offset}`);
  
  objektHistorie.value = response.eintraege || response;
  objektHistorieGesamt.value = response.gesamt || (Array.isArray(response) ? response.length : 0);
  objektHistorieSeite.value = seite;
}

function waehleExemplar(exemplarId) {
  ausgewaehltesExemplarId.value = exemplarId;
  const exemplar = exemplare.value.find((eintrag) => eintrag.id === exemplarId);

  if (!exemplar) return;

  exemplarForm.value = {
    status: exemplar.status,
    zustand: exemplar.zustand,
    standort_id: standorte.value.find((standort) => standort.bezeichnung === exemplar.standort)?.id || "",
    notizen: exemplar.notizen || ""
  };

  ladeObjektHistorie(exemplarId);
}

async function springeZurObjektpflege(payload) {
  // Erlaubt das Empfangen der reinen ID oder des kompletten Objekts aus dem Event
  const exemplarId = typeof payload === "object" && payload !== null ? payload.id : payload;
  
  if (exemplarId) {
    waehleExemplar(exemplarId);
  }
  wechsleModul("objekte");
  
  await nextTick();
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function historieHatBuchlink(eintrag) {
  if (!eintrag?.exemplar_id) return false;
  const exemplar = exemplare.value.find((wert) => wert.id === eintrag.exemplar_id);
  return exemplar?.inventar_typ === "buch";
}

async function zeigeBuchdetailsAusHistorie(eintrag) {
  if (!eintrag?.exemplar_id) return;
  overlayExemplarId.value = eintrag.exemplar_id;
  overlayHistorie.value = await apiRequest(`/historie?exemplar_id=${eintrag.exemplar_id}&limit=20`);
}

async function historieLoeschen() {
  const tage = Number(historieLoeschTage.value);

  if (!Number.isInteger(tage) || tage < 1) {
    apiFehler.value = "Bitte eine gueltige Anzahl von Tagen fuer die Historie-Bereinigung angeben.";
    return;
  }

  historieLoeschenDialog.value = false;
  apiFehler.value = "";
  erfolgsMeldung.value = "";

  try {
    const response = await apiRequest(`/historie?tage=${tage}`, {
      method: "DELETE"
    });
    erfolgsMeldung.value = response.meldung;
    await ladeUebersicht();
  } catch (error) {
    apiFehler.value = error.message;
  }
}

const historieKannMehrLaden = computed(
  () => historieEintraege.value.length < historieGesamt.value
);

async function ladeWeitereHistorie() {
  if (historieLaedtMehr.value || !historieKannMehrLaden.value) {
    return;
  }

  historieLaedtMehr.value = true;

  try {
    const historieListe = await apiRequest(
      `/historie?limit=${historieBatchGroesse}&offset=${historieEintraege.value.length}`
    );
    historieEintraege.value = [...historieEintraege.value, ...historieListe.eintraege];
    historieGesamt.value = historieListe.gesamt;
  } catch (error) {
    apiFehler.value = error.message;
  } finally {
    historieLaedtMehr.value = false;
  }
}

function historieLoeschenAnfragen() {
  const tage = Number(historieLoeschTage.value);

  if (!Number.isInteger(tage) || tage < 1) {
    apiFehler.value = "Bitte eine gueltige Anzahl von Tagen fuer die Historie-Bereinigung angeben.";
    return;
  }

  loeschenFehler.value = "";
  historieLoeschenDialog.value = true;
}

function wechsleModul(modulId) {
  router.push({ name: modulId });
}

function toggleInventarGeoeffnet() {
  inventarGeoeffnet.value = !inventarGeoeffnet.value;
}

function toggleOffeneAusleihenGeoeffnet() {
  offeneAusleihenGeoeffnet.value = !offeneAusleihenGeoeffnet.value;
}

function appLeereScannerEingaben() {
  leereScannerEingaben();
  ausleiheManuelleExemplarEingabe.value = "";
  ausleiheScanExemplarEingabe.value = "";
}

function schliesseStartPanels() {
  startAusleiheGeoeffnet.value = false;
  startRueckgabeGeoeffnet.value = false;
  startVerlaengerungGeoeffnet.value = false;
}

async function startTrefferOeffnen(treffer) {
  if (!treffer) return;

  if (treffer.typ === "exemplar") {
    springeZurObjektpflege(treffer.daten.id);
    return;
  }

  if (treffer.typ === "buch") {
    externerBuchTitelcode.value = treffer.daten.titelcode || "";
    wechsleModul("buecher");
    return;
  }

  if (treffer.typ === "ausleiher") {
    if (treffer.daten.ausleiher_typ === "klasse") {
      klassensatzForm.value.ausleiher_id = treffer.daten.id;
      wechsleModul("manuelle-buchung");
      return;
    }

    ausleiheForm.value.ausleiher_id = treffer.daten.id;
    wechsleModul("manuelle-buchung");
  }
}

function startTrefferHatRueckgabe(treffer) {
  return (
    treffer?.typ === "exemplar" &&
    treffer.daten?.inventar_typ !== "buch" &&
    treffer.daten?.status === "ausgeliehen"
  );
}

function startTrefferHatAusleihe(treffer) {
  return (
    treffer?.typ === "exemplar" &&
    treffer.daten?.inventar_typ !== "buch" &&
    treffer.daten?.status === "verfuegbar"
  );
}

function startTrefferAusleihe(treffer) {
  if (!startTrefferHatAusleihe(treffer)) return;

  ausleiheForm.value.exemplar_id = treffer.daten.id;
  apiFehler.value = "";
  wechsleModul("manuelle-buchung");
}

function startTrefferRueckgabe(treffer) {
  if (!startTrefferHatRueckgabe(treffer)) return;

  const offeneAusleihe = offeneAusleihen.value.find(
    (eintrag) => eintrag.inventarnummer === treffer.daten.inventarnummer
  );

  if (!offeneAusleihe) {
    apiFehler.value = "Zu diesem Geraet wurde keine offene Ausleihe gefunden.";
    return;
  }

  rueckgabeForm.value.ausleihe_id = offeneAusleihe.id;
  wechsleModul("rueckgabe");
}

async function ladeDaten() {
  laedtDaten.value = true;
  apiFehler.value = "";

  try {
    await ladeUebersicht();
  } catch (error) {
    apiFehler.value = error.message;
  } finally {
    laedtDaten.value = false;
  }
}

async function ladeDatenBeiFokus() {
  if (laedtDaten.value) return;
  await ladeDaten();
}

async function ausleiheSpeichern() {
  return ausleiheSpeichernMitOptionen();
}

async function ausleiheSpeichernMitOptionen(optionen = {}) {
  apiFehler.value = "";
  erfolgsMeldung.value = "";
  schliesseStartPanels();
  const { behalteAusleiher = false } = optionen;
  const gemerkterAusleiherId = ausleiheForm.value.ausleiher_id;
  const gemerkteFaelligkeit = ausleiheForm.value.faellig_am;
  const gemerkterKommentar = ausleiheForm.value.kommentar_ausgabe;
  const gemerkterScanAusleiher = scanDialog.value.ausleiher;
  const wirksameFaelligkeit = formatiereDatumAlsTagesende(ausleiheForm.value.faellig_am);

  try {
    const response = await apiRequest("/ausleihen", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        ...ausleiheForm.value,
        faellig_am: wirksameFaelligkeit
      })
    });

    ausleiheForm.value = {
      exemplar_id: "",
      ausleiher_id: behalteAusleiher ? gemerkterAusleiherId : "",
      faellig_am: behalteAusleiher ? gemerkteFaelligkeit : standardFaelligkeitAusleihe(),
      kommentar_ausgabe: behalteAusleiher ? gemerkterKommentar : ""
    };

    if (behalteAusleiher && gemerkterScanAusleiher) {
      scanDialog.value = {
        ausleiher: gemerkterScanAusleiher,
        exemplar: null,
        erwartet: "exemplar"
      };
    } else {
      scanDialogZuruecksetzen();
    }

    appLeereScannerEingaben();
    erfolgsMeldung.value = `Ausleihe wurde gespeichert. Faellig am ${formatDatum(response.faellig_am)}.`;
    await ladeDaten();
    fokussiereScannerEingabe();
  } catch (error) {
    apiFehler.value = error.message;
  }
}

async function klassensatzAusgabeSpeichern() {
  apiFehler.value = "";
  erfolgsMeldung.value = "";

  try {
    const response = await apiRequest("/klassensaetze/ausgabe", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(klassensatzForm.value)
    });

    klassensatzForm.value = {
      ausleiher_id: "",
      exemplar_ids: [],
      faellig_am: "",
      kommentar_ausgabe: ""
    };

    erfolgsMeldung.value = `${response.anzahl} Klassensatz-Exemplare wurden ausgegeben. Faellig am ${formatDatum(response.faellig_am)}.`;
    await ladeDaten();
  } catch (error) {
    apiFehler.value = error.message;
  }
}

async function scanAusleiheBestaetigen() {
  if (!scanBereitZurAusleihe.value) return;

  ausleiheForm.value = {
    ...ausleiheForm.value,
    ausleiher_id: scanDialog.value.ausleiher?.id || "",
    exemplar_id: scanDialog.value.exemplar?.id || "",
    faellig_am: ausleiheForm.value.faellig_am || standardFaelligkeitAusleihe()
  };

  startAusleiheGeoeffnet.value = true;
  startRueckgabeGeoeffnet.value = false;
  startVerlaengerungGeoeffnet.value = false;
}

async function scanRueckgabeBestaetigen() {
  if (!scanBereitZurRueckgabe.value || !scanAktiveAusleihe.value) return;

  rueckgabeForm.value.ausleihe_id = scanAktiveAusleihe.value.id;
  startAusleiheGeoeffnet.value = false;
  startRueckgabeGeoeffnet.value = true;
  startVerlaengerungGeoeffnet.value = false;
}

async function rueckgabeSpeichern() {
  return rueckgabeSpeichernMitOptionen();
}

async function rueckgabeSpeichernMitOptionen(optionen = {}) {
  apiFehler.value = "";
  erfolgsMeldung.value = "";
  schliesseStartPanels();
  const { behalteAusleiher = false } = optionen;
  const gemerkterScanAusleiher = scanDialog.value.ausleiher;

  try {
    await apiRequest(`/ausleihen/${rueckgabeForm.value.ausleihe_id}/rueckgabe`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        zustand_bei_rueckgabe: rueckgabeForm.value.zustand_bei_rueckgabe,
        kommentar_rueckgabe: rueckgabeForm.value.kommentar_rueckgabe
      })
    });

    rueckgabeForm.value = {
      ausleihe_id: "",
      zustand_bei_rueckgabe: "gut",
      kommentar_rueckgabe: ""
    };

    if (behalteAusleiher && gemerkterScanAusleiher) {
      scanDialog.value = {
        ausleiher: gemerkterScanAusleiher,
        exemplar: null,
        erwartet: "exemplar"
      };
    } else if (scanDialog.value.exemplar) {
      scanDialog.value = {
        ausleiher: scanDialog.value.ausleiher,
        exemplar: null,
        erwartet: scanDialog.value.ausleiher ? "exemplar" : "ausleiher"
      };
    }

    appLeereScannerEingaben();
    erfolgsMeldung.value = "Rueckgabe wurde verbucht.";
    await ladeDaten();
    fokussiereScannerEingabe();
  } catch (error) {
    apiFehler.value = error.message;
  }
}

async function scanVerlaengerungOeffnen() {
  if (!scanBereitZurRueckgabe.value || !scanAktiveAusleihe.value) return;

  const aktuelleFaelligkeit = scanAktiveAusleihe.value.faellig_am;

  verlaengerungForm.value = {
    ausleihe_id: scanAktiveAusleihe.value.id,
    faellig_am: formatFuerDatetimeLocalPlusTage(aktuelleFaelligkeit, 7),
    kommentar_verlaengerung: ""
  };

  startAusleiheGeoeffnet.value = false;
  startRueckgabeGeoeffnet.value = false;
  startVerlaengerungGeoeffnet.value = true;
}

async function verlaengerungSpeichern() {
  const offeneAusleihe =
    offeneAusleihen.value.find(
      (eintrag) => Number(eintrag.id) === Number(verlaengerungForm.value.ausleihe_id)
    ) || scanAktiveAusleihe.value;

  if (!verlaengerungForm.value.ausleihe_id && offeneAusleihe?.id) {
    verlaengerungForm.value.ausleihe_id = offeneAusleihe.id;
  }

  return verlaengerungSpeichernMitOptionen({ behalteAusleiher: true });
}

async function verlaengerungSpeichernMitOptionen(optionen = {}) {
  apiFehler.value = "";
  erfolgsMeldung.value = "";
  schliesseStartPanels();
  const { behalteAusleiher = false } = optionen;
  const gemerkterScanAusleiher = scanDialog.value.ausleiher;
  const offeneAusleihe =
    offeneAusleihen.value.find(
      (eintrag) => Number(eintrag.id) === Number(verlaengerungForm.value.ausleihe_id)
    ) || scanAktiveAusleihe.value;
  const aktuelleFaelligkeit = offeneAusleihe?.faellig_am;

  if (!verlaengerungForm.value.ausleihe_id || !verlaengerungForm.value.faellig_am) {
    apiFehler.value = "Neue Faelligkeit ist erforderlich.";
    return;
  }

  if (!aktuelleFaelligkeit) {
    apiFehler.value = "Verlaengern ist nur mit bestehender Faelligkeit moeglich.";
    return;
  }

  const aktuelleZeit = new Date(aktuelleFaelligkeit).getTime();
  const neueZeit = new Date(verlaengerungForm.value.faellig_am).getTime();

  if (Number.isNaN(aktuelleZeit) || Number.isNaN(neueZeit) || neueZeit <= aktuelleZeit) {
    apiFehler.value = "Die neue Faelligkeit muss spaeter als die aktuelle Faelligkeit sein.";
    return;
  }

  try {
    const response = await apiRequest(`/ausleihen/${verlaengerungForm.value.ausleihe_id}/verlaengern`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        faellig_am: verlaengerungForm.value.faellig_am,
        kommentar_verlaengerung: verlaengerungForm.value.kommentar_verlaengerung
      })
    });

    verlaengerungForm.value = {
      ausleihe_id: "",
      faellig_am: "",
      kommentar_verlaengerung: ""
    };

    if (behalteAusleiher && gemerkterScanAusleiher) {
      scanDialog.value = {
        ausleiher: gemerkterScanAusleiher,
        exemplar: null,
        erwartet: "exemplar"
      };
    }

    appLeereScannerEingaben();
    erfolgsMeldung.value = `Ausleihe wurde verlaengert. Neue Faelligkeit: ${formatDatum(response.faellig_am)}.`;
    await ladeDaten();
    fokussiereScannerEingabe();
  } catch (error) {
    apiFehler.value = error.message;
  }
}

async function exemplarSpeichern() {
  if (!ausgewaehltesExemplarId.value) return;

  apiFehler.value = "";
  erfolgsMeldung.value = "";

  try {
    await apiRequest(`/exemplare/${ausgewaehltesExemplarId.value}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(exemplarForm.value)
    });

    erfolgsMeldung.value = "Exemplar wurde aktualisiert.";
    await ladeDaten();
    await ladeObjektHistorie(ausgewaehltesExemplarId.value, objektHistorieSeite.value);
  } catch (error) {
    apiFehler.value = error.message;
  }
}

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

    schadenForm.value = {
      exemplar_id: "",
      ausleihe_id: "",
      gemeldet_von_ausleiher_id: "",
      titel: "",
      beschreibung: "",
      schadensgrad: "mittel"
    };

    erfolgsMeldung.value = "Schadensmeldung wurde gespeichert.";
    await ladeDaten();
  } catch (error) {
    apiFehler.value = error.message;
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

    reparaturForm.value = {
      schadensmeldung_id: "",
      dienstleister: "",
      beschreibung: "",
      kosten: ""
    };

    erfolgsMeldung.value = "Reparatur wurde gestartet.";
    await ladeDaten();
  } catch (error) {
    apiFehler.value = error.message;
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
    await ladeDaten();
  } catch (error) {
    apiFehler.value = error.message;
  }
}

function onLoeschenDialogEsc(e) {
  if (e.key !== "Escape") return;
  loeschenDialog.value = false;
  historieLoeschenDialog.value = false;
}
watch([loeschenDialog, historieLoeschenDialog], ([loeschenOffen, historieOffen]) => {
  if (loeschenOffen || historieOffen) window.addEventListener("keydown", onLoeschenDialogEsc);
  else window.removeEventListener("keydown", onLoeschenDialogEsc);
});

function geraeteAuswahlLoeschenAnfragen() {
  if (geraeteAusgewaehlt.value.size === 0) return;
  loeschenFehler.value = "";
  loeschenDialog.value = true;
}

async function geraeteAuswahlLoeschenBestaetigen() {
  const ids = [...geraeteAusgewaehlt.value];
  if (ids.length === 0) return;

  loeschenFehler.value = "";
  apiFehler.value = "";
  erfolgsMeldung.value = "";

  try {
    const response = await apiRequest("/exemplare", {
      method: "DELETE",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ ids })
    });
    loeschenDialog.value = false;
    erfolgsMeldung.value = response.meldung;
    geraeteAusgewaehlt.value = new Set();
    await ladeUebersicht();
  } catch (error) {
    loeschenFehler.value = error.message;
  }
}

function appResetResult() {
  resetResult();
  schliesseStartPanels();
  ausleiheForm.value.exemplar_id = "";
  ausleiheForm.value.ausleiher_id = "";
  ausleiheForm.value.faellig_am = standardFaelligkeitAusleihe();
  ausleiheForm.value.kommentar_ausgabe = "";
  rueckgabeForm.value = {
    ausleihe_id: "",
    zustand_bei_rueckgabe: "gut",
    kommentar_rueckgabe: ""
  };
  verlaengerungForm.value = {
    ausleihe_id: "",
    faellig_am: "",
    kommentar_verlaengerung: ""
  };
}

function formatDatum(isoWert) {
  if (!isoWert) return "offen";

  return new Intl.DateTimeFormat("de-DE", {
    dateStyle: "medium",
    timeStyle: "short"
  }).format(new Date(isoWert));
}

function formatiereDatumAlsTagesende(datumswert) {
  if (!datumswert) {
    return "";
  }

  if (/^\d{4}-\d{2}-\d{2}$/.test(datumswert)) {
    return `${datumswert} 23:59:59`;
  }

  const datum = new Date(datumswert);

  if (Number.isNaN(datum.getTime())) {
    return datumswert;
  }

  const pad = (wert) => String(wert).padStart(2, "0");

  return `${datum.getFullYear()}-${pad(datum.getMonth() + 1)}-${pad(datum.getDate())} 23:59:59`;
}

function formatFuerDatetimeLocal(isoWert) {
  if (!isoWert) return "";

  const datum = new Date(isoWert);

  if (Number.isNaN(datum.getTime())) {
    return "";
  }

  const pad = (wert) => String(wert).padStart(2, "0");

  return `${datum.getFullYear()}-${pad(datum.getMonth() + 1)}-${pad(datum.getDate())}T${pad(
    datum.getHours()
  )}:${pad(datum.getMinutes())}`;
}

function formatFuerDatetimeLocalPlusTage(isoWert, tage) {
  if (!isoWert) return "";

  const datum = new Date(isoWert);

  if (Number.isNaN(datum.getTime())) {
    return "";
  }

  datum.setDate(datum.getDate() + tage);
  return formatFuerDatetimeLocal(datum.toISOString());
}

const ausgewaehltesExemplar = computed(() =>
  exemplare.value.find((eintrag) => eintrag.id === ausgewaehltesExemplarId.value)
);

const ausgewaehltesBuch = computed(() =>
  ausgewaehltesExemplar.value?.inventar_typ === "buch" ? ausgewaehltesExemplar.value : null
);

const gefilterteHistorie = computed(() => {
  const q = historieFilter.value.trim().toLowerCase();
  const d = historieDatumFilter.value;
  return historieEintraege.value.filter((e) => {
    if (d) {
      const tag = new Date(e.erstellt_am).toISOString().slice(0, 10);
      if (tag !== d) return false;
    }
    if (q) {
      return [e.aktion, e.titel, e.inventarnummer, e.ausgeloest_von]
        .some((f) => f?.toLowerCase().includes(q));
    }
    return true;
  });
});

const historieNachDatum = computed(() => {
  const gruppen = new Map();
  for (const eintrag of gefilterteHistorie.value) {
    const tag = new Date(eintrag.erstellt_am).toLocaleDateString("de-DE", {
      weekday: "long", day: "numeric", month: "long", year: "numeric"
    });
    if (!gruppen.has(tag)) gruppen.set(tag, []);
    gruppen.get(tag).push(eintrag);
  }
  return gruppen;
});

const overlayExemplar = computed(() =>
  exemplare.value.find((eintrag) => eintrag.id === overlayExemplarId.value) ?? null
);

const overlayBuch = computed(() =>
  overlayExemplar.value?.inventar_typ === "buch" ? overlayExemplar.value : null
);

const startSuchergebnisse = computed(() => {
  const suchtext = startSuche.value.trim().toLowerCase();

  if (!suchtext) {
    return [];
  }

  const ergebnisse = [];
  const geseheneBuecher = new Set();

  for (const eintrag of exemplare.value) {
    const text = `${eintrag.inventarnummer} ${eintrag.titel} ${eintrag.barcode || ""}`.toLowerCase();
    if (text.includes(suchtext)) {
      const offeneAusleihe = offeneAusleihen.value.find(
        (ausleihe) =>
          ausleihe.exemplar_id === eintrag.id ||
          ausleihe.inventarnummer === eintrag.inventarnummer
      );
      ergebnisse.push({
        schluessel: `exemplar-${eintrag.id}`,
        typ: "exemplar",
        titel: eintrag.inventarnummer,
        untertitel: eintrag.titel,
        detail: eintrag.inventar_typ,
        meta: [
          `Status: ${eintrag.status}`,
          eintrag.status === "ausgeliehen" && offeneAusleihe?.ausleiher_name
            ? `Ausleiher: ${offeneAusleihe.ausleiher_name}`
            : null,
          `Zustand: ${eintrag.zustand}`,
          `Standort: ${eintrag.standort || "unbekannt"}`
        ].filter(Boolean),
        aktion: "Objekt oeffnen",
        daten: eintrag
      });
    }

    if (
      eintrag.inventar_typ === "buch" &&
      eintrag.artikel_id &&
      !geseheneBuecher.has(eintrag.artikel_id) &&
      `${eintrag.titel} ${eintrag.titelcode || ""} ${eintrag.verlag || ""}`.toLowerCase().includes(suchtext)
    ) {
      geseheneBuecher.add(eintrag.artikel_id);
      ergebnisse.push({
        schluessel: `buch-${eintrag.artikel_id}`,
        typ: "buch",
        titel: eintrag.titel,
        untertitel: eintrag.verlag || "Buch",
        detail: eintrag.titelcode || "",
        meta: [
          `Status: ${eintrag.status}`,
          `Standort: ${eintrag.standort || "unbekannt"}`,
          eintrag.verlag ? `Verlag: ${eintrag.verlag}` : null
        ].filter(Boolean),
        aktion: "Buch oeffnen",
        daten: eintrag
      });
    }
  }

  for (const person of ausleiher.value) {
    const text = `${person.name} ${person.klasse_oder_bereich || ""} ${person.barcode || ""}`.toLowerCase();
    if (text.includes(suchtext)) {
      const aktuelleAusleihen = offeneAusleihen.value
        .filter((eintrag) => eintrag.ausleiher_name === person.name)
        .slice(0, 3);
      ergebnisse.push({
        schluessel: `ausleiher-${person.id}`,
        typ: "ausleiher",
        titel: person.name,
        untertitel: ausleiherDetailText(person),
        detail: person.barcode || person.ausleiher_typ,
        meta: aktuelleAusleihen.length
          ? aktuelleAusleihen.map((eintrag) => `${eintrag.inventarnummer} · ${eintrag.titel}`)
          : ["Keine aktuellen Ausleihen"],
        aktion: person.ausleiher_typ === "klasse" ? "Klassensatz oeffnen" : "Ausleihe starten",
        daten: person
      });
    }
  }

  return ergebnisse.slice(0, 10);
});

const offeneSchaeden = computed(() =>
  schaeden.value.filter((eintrag) => eintrag.status !== "behoben")
);

const offeneReparaturen = computed(() =>
  reparaturen.value.filter((eintrag) => eintrag.status === "offen")
);

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

function istKlassensatzGruppeAusgewaehlt(gruppe) {
  return gruppe.exemplar_ids.every((id) => klassensatzForm.value.exemplar_ids.includes(id));
}

function toggleKlassensatzExemplar(exemplarId) {
  const vorhandene = new Set(klassensatzForm.value.exemplar_ids);
  if (vorhandene.has(exemplarId)) {
    vorhandene.delete(exemplarId);
  } else {
    vorhandene.add(exemplarId);
  }
  klassensatzForm.value.exemplar_ids = [...vorhandene];
}

function toggleGeraeteAuswahl(exemplarId) {
  const vorhandene = new Set(geraeteAusgewaehlt.value);
  const exemplar = exemplare.value.find((eintrag) => Number(eintrag.id) === Number(exemplarId));

  if (!exemplar || exemplar.status !== "verfuegbar") {
    return;
  }

  if (vorhandene.has(exemplar.id)) {
    vorhandene.delete(exemplar.id);
  } else {
    vorhandene.add(exemplar.id);
  }

  geraeteAusgewaehlt.value = vorhandene;
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

function standardfristTageFuerTyp(ausleiherTyp) {
  switch (ausleiherTyp) {
    case "lehrkraft":
      return 14;
    case "klasse":
      return 1;
    default:
      return 7;
  }
}

function standardfristText(ausleiherId) {
  const person = ausleiher.value.find((eintrag) => eintrag.id === Number(ausleiherId));

  if (!person) {
    return "Automatische Standardfrist nach Ausleiher-Typ.";
  }

  return `Standardfrist: ${standardfristTageFuerTyp(person.ausleiher_typ)} Tage`;
}

function ausleiherDetailText(eintrag) {
  if (!eintrag) return "";

  if (eintrag.ausleiher_typ === "schueler") {
    return eintrag.klasse_oder_bereich
      ? `Schueler, Klasse ${eintrag.klasse_oder_bereich}`
      : "Schueler";
  }

  if (eintrag.ausleiher_typ === "lehrkraft") {
    return eintrag.klasse_oder_bereich
      ? `Lehrkraft, ${eintrag.klasse_oder_bereich}`
      : "Lehrkraft";
  }

  return eintrag.klasse_oder_bereich
    ? `Klasse, Stufe ${eintrag.klasse_oder_bereich}`
    : "Klasse";
}

function startRueckgabeAbbrechen() {
  startRueckgabeGeoeffnet.value = false;
  rueckgabeForm.value = {
    ausleihe_id: "",
    zustand_bei_rueckgabe: "gut",
    kommentar_rueckgabe: ""
  };
}

function startVerlaengerungAbbrechen() {
  startVerlaengerungGeoeffnet.value = false;
  verlaengerungForm.value = {
    ausleihe_id: "",
    faellig_am: "",
    kommentar_verlaengerung: ""
  };
}

function startAusleiheAbbrechen() {
  startAusleiheGeoeffnet.value = false;
  ausleiheForm.value = {
    exemplar_id: "",
    ausleiher_id: scanDialog.value.ausleiher?.id || "",
    faellig_am: standardFaelligkeitAusleihe(),
    kommentar_ausgabe: ""
  };

  scanDialog.value = {
    ausleiher: scanDialog.value.ausleiher,
    exemplar: null,
    erwartet: scanDialog.value.ausleiher ? "exemplar" : "ausleiher"
  };

  appLeereScannerEingaben();
  fokussiereScannerEingabe();
}

function findeExemplarFuerAusleihe(suchwert) {
  const text = suchwert.trim().toLowerCase();

  if (!text) {
    return null;
  }

  const verfuegbareListe = verfuegbareExemplare.value;

  return (
    verfuegbareListe.find(
      (eintrag) =>
        eintrag.barcode?.toLowerCase() === text ||
        eintrag.inventarnummer?.toLowerCase() === text
    ) ||
    verfuegbareListe.find((eintrag) => eintrag.titel?.toLowerCase() === text) ||
    verfuegbareListe.find((eintrag) =>
      `${eintrag.inventarnummer} ${eintrag.titel} ${eintrag.barcode || ""}`.toLowerCase().includes(text)
    ) ||
    null
  );
}

function exemplarFuerAusleiheUebernehmen(exemplar, quelle = "Auswahl") {
  uebernehmeScanExemplar(exemplar);
  scannerStatus.value = `${exemplar.inventarnummer} fuer die Ausleihe uebernommen (${quelle}).`;
}

function manuellesAusleiheExemplarSuchen() {
  const exemplar = findeExemplarFuerAusleihe(ausleiheManuelleExemplarEingabe.value);

  if (!exemplar) {
    apiFehler.value = "Kein verfuegbares Exemplar zu dieser Eingabe gefunden.";
    return;
  }

  apiFehler.value = "";
  exemplarFuerAusleiheUebernehmen(exemplar, "manuelle Eingabe");
  ausleiheManuelleExemplarEingabe.value = "";
}

function scanEingabeAusleiheExemplarUebernehmen() {
  const exemplar = findeExemplarFuerAusleihe(ausleiheScanExemplarEingabe.value);

  if (!exemplar) {
    apiFehler.value = "Kein verfuegbares Exemplar zu diesem Scan gefunden.";
    return;
  }

  apiFehler.value = "";
  exemplarFuerAusleiheUebernehmen(exemplar, "Scanfeld");
  ausleiheScanExemplarEingabe.value = "";
}


onMounted(() => {
  ladeDaten();
  window.addEventListener("focus", ladeDatenBeiFokus);
  document.addEventListener("visibilitychange", onSichtbarkeitGeaendert);
});

onUnmounted(() => {
  window.removeEventListener("focus", ladeDatenBeiFokus);
  document.removeEventListener("visibilitychange", onSichtbarkeitGeaendert);
});

function onSichtbarkeitGeaendert() {
  if (document.visibilityState === "visible") {
    ladeDatenBeiFokus();
  }
}

watch(() => scanDialog.value.ausleiher, (person) => {
  if (person) {
    ausleiheForm.value.ausleiher_id = person.id;
    if (!klassensatzForm.value.ausleiher_id && person.ausleiher_typ === "klasse") {
      klassensatzForm.value.ausleiher_id = person.id;
    }
  }
});

watch(() => scanDialog.value.exemplar, (exemplar) => {
  if (exemplar) {
    ausleiheForm.value.exemplar_id = exemplar.id;
  }
});

watch(
  aktivesModul,
  (modulId) => {
    if (["start", "ausleihe", "rueckgabe"].includes(modulId)) {
      fokussiereScannerEingabe();
    }
    if (modulId === "buecher") {
      geraeteSuche.value = "";
    }
  },
  { immediate: true }
);
</script>
<template src="./App.html"></template>
