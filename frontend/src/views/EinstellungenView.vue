<script setup>
import { computed, onMounted, reactive, ref, watch } from "vue";
import { useEinstellungen } from "../composables/useEinstellungen.js";
import VertragsvorlagenAdmin from "../components/VertragsvorlagenAdmin.vue";

const props = defineProps({
  apiRequest: { type: Function, required: true }
});

const { bereiche, aktiverBereich, aktiverEintrag, wechsleBereich } = useEinstellungen();

const laedtBereiche = ref(true);
const apiFehler = ref("");
const buchCoverVorschau = ref("");
const erfolgsMeldung = ref("");

const listen = reactive({
  schueler: [],
  klassen: [],
  lehrer: [],
  buecher: [],
  faecher: [],
  herkunft: [],
  ausleiher: []
});

const auswahl = reactive({
  schueler: null,
  klassen: null,
  lehrer: null,
  buecher: null,
  ausleiher: null
});

const ausgewaehlteSchueler = ref([]);
const zeigeSchuelerFormular = ref(false);
const zeigeSchuelerImport = ref(false);
const importDaten = ref([]);
const svwsImportDaten = ref([]);
const svwsImportForm = reactive({
  host: "http://localhost",
  schule: "durs",
  user: "Admin",
  passwort: ""
});
const svwsVerbindungOk = ref(false);
const svwsPrueftVerbindung = ref(false);
const svwsDatenLaden = ref(false);
const svwsImportLaeuft = ref(false);
const svwsStatusMeldung = ref("");
const svwsStatusTyp = ref("info");

function formatiereImportVergleichswert(wert) {
  if (wert === null || wert === undefined || wert === "") return "-";
  return String(wert);
}

function normalisiereDatumFuerDateInput(wert) {
  if (!wert) return "";

  const text = String(wert).trim();
  if (!text) return "";

  if (/^\d{4}-\d{2}-\d{2}$/.test(text)) {
    return text;
  }

  const isoMatch = text.match(/^(\d{4}-\d{2}-\d{2})T/);
  if (isoMatch) {
    return isoMatch[1];
  }

  const deMatch = text.match(/^(\d{2})\.(\d{2})\.(\d{4})$/);
  if (deMatch) {
    return `${deMatch[3]}-${deMatch[2]}-${deMatch[1]}`;
  }

  const parsed = new Date(text);
  if (Number.isNaN(parsed.getTime())) {
    return text;
  }

  const year = parsed.getFullYear();
  const month = String(parsed.getMonth() + 1).padStart(2, "0");
  const day = String(parsed.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

function istImportFeldGeaendert(row, feld) {
  return Array.isArray(row.aenderungsFelder) && row.aenderungsFelder.includes(feld);
}

function importAenderungsZellenStil(row, feld) {
  if (!istImportFeldGeaendert(row, feld)) {
    return { padding: "4px 8px", fontSize: "0.9rem" };
  }

  return {
    padding: "4px 8px",
    fontSize: "0.9rem",
    color: "#9d2c30",
    fontWeight: "600"
  };
}

function erstelleSchuelerImportVorschau(datensaetze) {
  const parsed = [];

  for (const eintrag of datensaetze) {
    const s_id = String(eintrag?.s_id ?? "").trim();
    const vorname = String(eintrag?.vorname ?? "").trim();
    const nachname = String(eintrag?.nachname ?? "").trim();
    const klasse = String(eintrag?.klasse ?? "").trim();
    const geburtsdatum = String(eintrag?.geburtsdatum ?? "").trim();
    const email = String(eintrag?.email ?? "").trim();

    let importStatus = "Neu";
    let statusFarbe = "#27ae60";
    let bestehendeWerte = null;
    const aenderungen = [];

    if (!s_id) {
      importStatus = "Fehler: S-ID fehlt";
      statusFarbe = "#c0392b";
    } else {
      const existierend = listen.schueler.find((s) => String(s.s_id) === s_id);
      if (existierend) {
        let existDatum = "";
        if (existierend.geburtsdatum) {
          const dateObj = new Date(existierend.geburtsdatum);
          if (!Number.isNaN(dateObj.getTime())) {
            existDatum = `${String(dateObj.getDate()).padStart(2, "0")}.${String(dateObj.getMonth() + 1).padStart(2, "0")}.${dateObj.getFullYear()}`;
          }
        }

        bestehendeWerte = {
          vorname: existierend.vorname || "",
          nachname: existierend.nachname || "",
          klasse: existierend.klasse || "",
          geburtsdatum: existDatum,
          email: existierend.email || ""
        };

        if ((existierend.vorname || "") !== vorname) aenderungen.push("Vorname");
        if ((existierend.nachname || "") !== nachname) aenderungen.push("Nachname");
        if ((existierend.klasse || "") !== klasse && klasse !== "") aenderungen.push("Klasse");
        if (existDatum !== geburtsdatum && geburtsdatum !== "") aenderungen.push("Datum");
        if ((existierend.email || "") !== email && email !== "") aenderungen.push("E-Mail");

        if (aenderungen.length > 0) {
          importStatus = "Änderung";
          statusFarbe = "#e74c3c";
        } else {
          importStatus = "Unverändert";
          statusFarbe = "#7f8c8d";
        }
      }
    }

    parsed.push({
      s_id,
      vorname,
      nachname,
      klasse,
      geburtsdatum,
      email,
      bestehendeWerte,
      aenderungsFelder: aenderungen,
      importStatus,
      statusFarbe
    });
  }

  return parsed;
}

function verarbeiteImportDatei(event) {
  const file = event.target.files[0];
  if (!file) return;

  const reader = new FileReader();
  reader.onload = (e) => {
    const text = e.target.result;
    const zeilen = text.split('\n').filter(line => line.trim().length > 0);
    const parsed = [];
    
    let startIndex = 0;
    if (zeilen.length > 0) {
      const kopfzeile = zeilen[0].toLowerCase();
      if (kopfzeile.includes("vorname") || kopfzeile.includes("\"id\"") || kopfzeile.startsWith("id;")) {
        startIndex = 1;
      }
    }

    for (let i = startIndex; i < zeilen.length; i++) {
      const spalten = zeilen[i].split(';').map(s => s.trim().replace(/^"|"$/g, ''));
      if (spalten.length >= 6) {
        const s_id = spalten[0];
        const vorname = spalten[1];
        const nachname = spalten[2];
        const klasse = spalten[3];
        const geburtsdatum = spalten[4];
        const email = spalten[5];
        
        let importStatus = "Neu";
        let statusFarbe = "#27ae60";
        let bestehendeWerte = null;
        const aenderungen = [];
        
        if (!s_id || s_id.trim() === "") {
          importStatus = "Fehler: S-ID fehlt";
          statusFarbe = "#c0392b"; // dark red for errors
        } else {
          const existierend = listen.schueler.find(s => String(s.s_id) === String(s_id));
          if (existierend) {
            let existDatum = "";
            if (existierend.geburtsdatum) {
              const dateObj = new Date(existierend.geburtsdatum);
               if (!isNaN(dateObj)) {
                  existDatum = `${String(dateObj.getDate()).padStart(2, '0')}.${String(dateObj.getMonth() + 1).padStart(2, '0')}.${dateObj.getFullYear()}`;
               }
             }

            bestehendeWerte = {
              vorname: existierend.vorname || "",
              nachname: existierend.nachname || "",
              klasse: existierend.klasse || "",
              geburtsdatum: existDatum,
              email: existierend.email || ""
            };

            if (existierend.vorname !== vorname) aenderungen.push("Vorname");
            if (existierend.nachname !== nachname) aenderungen.push("Nachname");
            if ((existierend.klasse || "") !== klasse && klasse !== "") aenderungen.push("Klasse");
            if (existDatum !== geburtsdatum && geburtsdatum !== "") aenderungen.push("Datum");
            if ((existierend.email || "") !== email && email !== "") aenderungen.push("E-Mail");
            
            if (aenderungen.length > 0) {
              importStatus = "Änderung";
              statusFarbe = "#e74c3c"; // light red for changes
            } else {
              importStatus = "Unverändert";
              statusFarbe = "#7f8c8d";
            }
          }
        }
        
        parsed.push({
          s_id,
          vorname,
          nachname,
          klasse,
          geburtsdatum,
          email,
          bestehendeWerte,
          aenderungsFelder: aenderungen,
          importStatus,
          statusFarbe
        });
      }
    }
    
    importDaten.value = erstelleSchuelerImportVorschau(parsed);
    event.target.value = null; // reset input
  };
  reader.readAsText(file);
}

const zeigeNurAenderungenUndFehler = ref(false);
const gefilterteImportDaten = computed(() => {
  if (!zeigeNurAenderungenUndFehler.value) return importDaten.value;
  return importDaten.value.filter(row => row.importStatus !== "Unverändert");
});

const gefilterteSvwsImportDaten = computed(() => {
  if (!zeigeNurAenderungenUndFehler.value) return svwsImportDaten.value;
  return svwsImportDaten.value.filter(row => row.importStatus !== "Unverändert");
});

const importLaeuft = ref(false);

async function speichereImport() {
  if (importDaten.value.length === 0) return;
  importLaeuft.value = true;
  apiFehler.value = "";
  erfolgsMeldung.value = "";

  try {
    const res = await fetch("/api/schueler/import", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ schueler: importDaten.value })
    });
    
    const json = await res.json();
    if (!res.ok) throw new Error(json.fehler || "Import fehlgeschlagen");
    
    erfolgsMeldung.value = json.meldung || `${importDaten.value.length} Schüler verarbeitet.`;
    importDaten.value = [];
    zeigeSchuelerImport.value = false;
    await ladeDaten();
    
    setTimeout(() => erfolgsMeldung.value = "", 5000);
  } catch(error) {
    apiFehler.value = error.message;
    setTimeout(() => apiFehler.value = "", 5000);
  } finally {
    importLaeuft.value = false;
  }
}

async function testeSvwsVerbindung() {
  const fehlendeFelder = [];

  if (!String(svwsImportForm.host || "").trim()) fehlendeFelder.push("Host");
  if (!String(svwsImportForm.schule || "").trim()) fehlendeFelder.push("Schule");
  if (!String(svwsImportForm.user || "").trim()) fehlendeFelder.push("User");

  if (fehlendeFelder.length > 0) {
    svwsVerbindungOk.value = false;
    svwsStatusTyp.value = "error";
    svwsStatusMeldung.value = `Bitte ausfüllen: ${fehlendeFelder.join(", ")}.`;
    return;
  }

  svwsPrueftVerbindung.value = true;
  svwsVerbindungOk.value = false;
  svwsStatusTyp.value = "info";
  svwsStatusMeldung.value = "";

  try {
    const response = await props.apiRequest("/svws/verbindung-testen", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        host: svwsImportForm.host,
        schule: svwsImportForm.schule,
        user: svwsImportForm.user,
        passwort: svwsImportForm.passwort
      })
    });

    svwsVerbindungOk.value = true;
    svwsStatusTyp.value = "success";
    svwsStatusMeldung.value = response.meldung || "SVWS-Verbindung erfolgreich geprüft.";
  } catch (error) {
    svwsVerbindungOk.value = false;
    svwsStatusTyp.value = "error";
    svwsStatusMeldung.value = error.message || "SVWS-Verbindung konnte nicht geprüft werden.";
  } finally {
    svwsPrueftVerbindung.value = false;
  }
}

async function importiereSchuelerVonSvws() {
  if (svwsImportDaten.value.length === 0) {
    svwsStatusTyp.value = "error";
    svwsStatusMeldung.value = "Bitte zuerst Schülerdaten holen.";
    return;
  }

  svwsImportLaeuft.value = true;
  svwsStatusTyp.value = "info";
  svwsStatusMeldung.value = "";

  try {
    const response = await props.apiRequest("/schueler/import", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ schueler: svwsImportDaten.value })
    });

    svwsStatusTyp.value = "success";
    svwsStatusMeldung.value = response.meldung || "Schülerdaten erfolgreich importiert.";
    svwsImportDaten.value = [];
    await ladeDaten();
  } catch (error) {
    svwsStatusTyp.value = "error";
    svwsStatusMeldung.value = error.message || "Schülerdaten konnten nicht importiert werden.";
  } finally {
    svwsImportLaeuft.value = false;
  }
}

async function holeSvwsSchuelerDaten() {
  const fehlendeFelder = [];

  if (!String(svwsImportForm.host || "").trim()) fehlendeFelder.push("Host");
  if (!String(svwsImportForm.schule || "").trim()) fehlendeFelder.push("Schule");
  if (!String(svwsImportForm.user || "").trim()) fehlendeFelder.push("User");

  if (fehlendeFelder.length > 0) {
    svwsVerbindungOk.value = false;
    svwsStatusTyp.value = "error";
    svwsStatusMeldung.value = `Bitte ausfüllen: ${fehlendeFelder.join(", ")}.`;
    return;
  }

  svwsDatenLaden.value = true;
  svwsStatusTyp.value = "info";
  svwsStatusMeldung.value = "";

  try {
    const response = await props.apiRequest("/svws/schueler-vorschau", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        host: svwsImportForm.host,
        schule: svwsImportForm.schule,
        user: svwsImportForm.user,
        passwort: svwsImportForm.passwort
      })
    });

    svwsImportDaten.value = erstelleSchuelerImportVorschau(response.schueler || []);
    svwsStatusTyp.value = "success";
    svwsStatusMeldung.value = `${svwsImportDaten.value.length} Schülerdaten aus SVWS geladen.`;
  } catch (error) {
    svwsStatusTyp.value = "error";
    svwsStatusMeldung.value = error.message || "SVWS-Schülerdaten konnten nicht geladen werden.";
  } finally {
    svwsDatenLaden.value = false;
  }
}

const zeigeLehrerImport = ref(false);
const importDatenLehrer = ref([]);

function verarbeiteLehrerImportDatei(event) {
  const file = event.target.files[0];
  if (!file) return;

  const reader = new FileReader();
  reader.onload = (e) => {
    const text = e.target.result;
    const zeilen = text.split('\n').filter(line => line.trim().length > 0);
    const parsed = [];
    
    let startIndex = 0;
    if (zeilen.length > 0) {
      const kopfzeile = zeilen[0].toLowerCase();
      if (kopfzeile.includes("vorname") || kopfzeile.includes("\"id\"") || kopfzeile.startsWith("id;")) {
        startIndex = 1;
      }
    }

    for (let i = startIndex; i < zeilen.length; i++) {
      const spalten = zeilen[i].split(';').map(s => s.trim().replace(/^"|"$/g, ''));
      if (spalten.length >= 7) {
        const id = spalten[0];
        const kuerzel = spalten[1];
        const anrede = spalten[2];
        const vorname = spalten[3];
        const nachname = spalten[4];
        const email = spalten[5];
        const fachbereich = spalten[6];
        
        let importStatus = "Neu";
        let statusFarbe = "#27ae60";
        let bestehendeWerte = null;
        const aenderungen = [];
        
        if (!id || id.trim() === "") {
          statusFarbe = "#c0392b";
          importStatus = "Fehler: ID fehlt";
        } else {
          const existierend = listen.lehrer.find(l => String(l.id) === String(id));
          if (existierend) {
            bestehendeWerte = {
              kuerzel: existierend.kuerzel || "",
              anrede: existierend.anrede || "",
              vorname: existierend.vorname || "",
              nachname: existierend.nachname || "",
              email: existierend.email || "",
              fachbereich: existierend.fachbereich || ""
            };
            if ((existierend.kuerzel || "") !== kuerzel) aenderungen.push("Kuerzel");
            if ((existierend.anrede || "") !== anrede) aenderungen.push("Anrede");
            if (existierend.vorname !== vorname) aenderungen.push("Vorname");
            if (existierend.nachname !== nachname) aenderungen.push("Nachname");
            if ((existierend.email || "") !== email && email !== "") aenderungen.push("E-Mail");
            if ((existierend.fachbereich || "") !== fachbereich && fachbereich !== "") aenderungen.push("Fachbereich");
            
            if (aenderungen.length > 0) {
              importStatus = "Änderung";
              statusFarbe = "#e74c3c";
            } else {
              importStatus = "Unverändert";
              statusFarbe = "#7f8c8d";
            }
          }
        }
        
        parsed.push({
          id,
          kuerzel,
          anrede,
          vorname,
          nachname,
          email,
          fachbereich,
          bestehendeWerte,
          aenderungsFelder: aenderungen,
          importStatus,
          statusFarbe
        });
      }
    }
    
    importDatenLehrer.value = parsed;
    event.target.value = null;
  };
  reader.readAsText(file);
}

const zeigeNurAenderungenUndFehlerLehrer = ref(false);
const gefilterteImportDatenLehrer = computed(() => {
  if (!zeigeNurAenderungenUndFehlerLehrer.value) return importDatenLehrer.value;
  return importDatenLehrer.value.filter(row => row.importStatus !== "Unverändert");
});

const importLaeuftLehrer = ref(false);

async function speichereLehrerImport() {
  if (importDatenLehrer.value.length === 0) return;
  importLaeuftLehrer.value = true;
  apiFehler.value = "";
  erfolgsMeldung.value = "";

  try {
    const res = await fetch("/api/lehrkraefte/import", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ lehrer: importDatenLehrer.value })
    });
    
    const json = await res.json();
    if (!res.ok) throw new Error(json.fehler || "Import fehlgeschlagen");
    
    erfolgsMeldung.value = json.meldung || `${importDatenLehrer.value.length} Lehrkräfte verarbeitet.`;
    importDatenLehrer.value = [];
    zeigeLehrerImport.value = false;
    await ladeDaten();
    
    setTimeout(() => erfolgsMeldung.value = "", 5000);
  } catch(error) {
    apiFehler.value = error.message;
    setTimeout(() => apiFehler.value = "", 5000);
  } finally {
    importLaeuftLehrer.value = false;
  }
}
const zeigeInaktiveSchueler = ref(false);

const ausleiherFilterSpalte = ref("name");
const ausleiherFilterText = ref("");

const gefilterteAusleiher = computed(() => {
  if (!ausleiherFilterText.value.trim()) {
    return listen.ausleiher;
  }
  const text = ausleiherFilterText.value.toLowerCase();
  const spalte = ausleiherFilterSpalte.value;

  return listen.ausleiher.filter(a => {
    const wert = a[spalte];
    if (wert === null || wert === undefined) return false;
    return String(wert).toLowerCase().includes(text);
  });
});

const schuelerFilterSpalte = ref("nachname");
const schuelerFilterText = ref("");

const klassenFilterSpalte = ref("bezeichnung");
const klassenFilterText = ref("");
const zeigeKlassenFormular = ref(false);
const zeigeInaktiveKlassen = ref(false);

const lehrerFilterSpalte = ref("nachname");
const lehrerFilterText = ref("");
const zeigeLehrerFormular = ref(false);
const zeigeInaktiveLehrer = ref(false);

const gefilterteLehrer = computed(() => {
  let list = zeigeInaktiveLehrer.value ? listen.lehrer : listen.lehrer.filter(l => l.aktiv);
  
  if (!lehrerFilterText.value.trim()) {
    return list;
  }
  
  const text = lehrerFilterText.value.toLowerCase();
  const spalte = lehrerFilterSpalte.value;

  return list.filter(l => {
    const wert = l[spalte];
    if (wert === null || wert === undefined) return false;
    return String(wert).toLowerCase().includes(text);
  });
});

const gefilterteKlassen = computed(() => {
  let list = zeigeInaktiveKlassen.value ? listen.klassen : listen.klassen.filter(k => k.aktiv);
  
  if (!klassenFilterText.value.trim()) {
    return list;
  }
  
  const text = klassenFilterText.value.toLowerCase();
  const spalte = klassenFilterSpalte.value;

  return list.filter(k => {
    const wert = k[spalte];
    if (wert === null || wert === undefined) return false;
    return String(wert).toLowerCase().includes(text);
  });
});

const gefilterteSchueler = computed(() => {
  let list = zeigeInaktiveSchueler.value ? listen.schueler : listen.schueler.filter(s => s.aktiv);
  
  if (!schuelerFilterText.value.trim()) {
    return list;
  }
  
  const text = schuelerFilterText.value.toLowerCase();
  const spalte = schuelerFilterSpalte.value;

  return list.filter(s => {
    const wert = s[spalte];
    if (wert === null || wert === undefined) return false;
    return String(wert).toLowerCase().includes(text);
  });
});

function bearbeiteAusleiher(ausleiher) {
  alert("Bearbeiten-Funktion für Ausleiher noch nicht implementiert.");
}

function loescheAusleiher(ausleiher) {
  if (confirm(`Soll der Ausleiher "${ausleiher.name}" wirklich gelöscht werden?`)) {
    alert("Löschen-Funktion für Ausleiher noch nicht implementiert.");
  }
}

function bearbeiteSchueler(schueler) {
  setzeAuswahl('schueler', schueler);
  zeigeSchuelerFormular.value = true;
}

function bearbeiteKlasse(klasse) {
  setzeAuswahl('klassen', klasse);
  zeigeKlassenFormular.value = true;
}

function loescheKlasse(klasse) {
  if (confirm(`Soll die Klasse "${klasse.bezeichnung}" wirklich gelöscht werden?`)) {
    alert("Löschen-Funktion für Klassen noch nicht implementiert.");
  }
}

function bearbeiteLehrer(lehrer) {
  setzeAuswahl('lehrer', lehrer);
  zeigeLehrerFormular.value = true;
}

async function loescheLehrer(lehrer) {
  if (confirm(`Soll die Lehrkraft "${lehrer.anzeigename}" wirklich gelöscht werden?`)) {
    alert("Löschen-Funktion für Lehrkräfte noch nicht implementiert.");
  }
}

async function entferneLehrer(lehrer) {
  if (!confirm(`Soll die Lehrkraft "${lehrer.anzeigename}" wirklich gelöscht werden?`)) {
    return;
  }

  apiFehler.value = "";
  erfolgsMeldung.value = "";

  try {
    const response = await props.apiRequest(`/lehrkraefte/${lehrer.id}`, {
      method: "DELETE"
    });

    erfolgsMeldung.value = response.meldung || "Lehrkraft erfolgreich gelöscht.";

    if (auswahl.lehrer === lehrer.id) {
      auswahl.lehrer = null;
      zeigeLehrerFormular.value = false;
    }

    await ladeDaten();
    setTimeout(() => {
      erfolgsMeldung.value = "";
    }, 5000);
  } catch (error) {
    apiFehler.value = error.message;
    setTimeout(() => {
      apiFehler.value = "";
    }, 5000);
  }
}

function toggleAlleSchueler(event) {
  if (event.target.checked) {
    ausgewaehlteSchueler.value = gefilterteSchueler.value.map(s => s.id);
  } else {
    ausgewaehlteSchueler.value = [];
  }
}

const formen = reactive({
  schueler: {
    id: null,
    s_id: null,
    vorname: "",
    nachname: "",
    anzeigename: "",
    barcode: "",
    geburtsdatum: "",
    email: "",
    aktiv: true,
    notizen: "",
    klassen_id: "",
    schuljahr: ""
  },
  klassen: {
    id: null,
    bezeichnung: "",
    stufe: "",
    parallelklasse: "",
    aktiv: true
  },
  lehrer: {
    id: null,
    kuerzel: "",
    anrede: "",
    vorname: "",
    nachname: "",
    anzeigename: "",
    barcode: "",
    email: "",
    fachbereich: "",
    aktiv: true,
    notizen: ""
  },
  benutzer: {
    rolleStandard: "verwaltung",
    scannerFokusBeimStart: true,
    erfolgsmeldungenAutomatischAusblenden: false
  },
  geraete: {
    inventarPraefix: "G-",
    barcodePraefix: "DEV-",
    standardStatus: "verfuegbar",
    seriennummerPflicht: false
  },
  buecher: {
    id: null,
    artikel_id: null,
    titel: "",
    titelcode: "",
    autor: "",
    verlag: "",
    fach_id: null,
    veroeffentlicht: "",
    cover_url: "",
    cover_bild: "",
    jahrgangsstufe: "",
    schuljahr_ausgabe: "",
    ist_arbeitsheft: false,
    ist_lehrerversion: false,
    herkunft_id: null
  }
});

const aktiveListe = computed(() => {
  if (aktiverBereich.value === "schueler") return listen.schueler;
  if (aktiverBereich.value === "klassen") return listen.klassen;
  if (aktiverBereich.value === "lehrer") return listen.lehrer;
  if (aktiverBereich.value === "buecher") return listen.buecher;
  if (aktiverBereich.value === "ausleiher") return listen.ausleiher;
  return [];
});

const aktiveAuswahl = computed(() => {
  if (aktiverBereich.value === "schueler") return auswahl.schueler;
  if (aktiverBereich.value === "klassen") return auswahl.klassen;
  if (aktiverBereich.value === "lehrer") return auswahl.lehrer;
  if (aktiverBereich.value === "buecher") return auswahl.buecher;
  if (aktiverBereich.value === "ausleiher") return auswahl.ausleiher;
  return null;
});

function cloneDaten(daten) {
  return JSON.parse(JSON.stringify(daten));
}

function setzeAuswahl(bereich, datensatz) {
  auswahl[bereich] = datensatz?.id ?? null;

  if (!datensatz) {
    return;
  }

  if (bereich === "schueler") {
    formen.schueler = {
      id: datensatz.id,
      s_id: datensatz.s_id,
      vorname: datensatz.vorname || "",
      nachname: datensatz.nachname || "",
      anzeigename: datensatz.anzeigename || "",
      barcode: datensatz.barcode || "",
      geburtsdatum: normalisiereDatumFuerDateInput(datensatz.geburtsdatum),
      email: datensatz.email || "",
      aktiv: Boolean(datensatz.aktiv),
      notizen: datensatz.notizen || "",
      klassen_id: datensatz.klassen_id || "",
      schuljahr: datensatz.schuljahr || ""
    };
    return;
  }

  if (bereich === "klassen") {
    formen.klassen = {
      id: datensatz.id,
      bezeichnung: datensatz.bezeichnung || "",
      stufe: datensatz.stufe || "",
      parallelklasse: datensatz.parallelklasse || "",
      aktiv: Boolean(datensatz.aktiv)
    };
    return;
  }

  if (bereich === "buecher") {
    formen.buecher = {
      id: datensatz.artikel_id,
      artikel_id: datensatz.artikel_id,
      titel: datensatz.titel || "",
      titelcode: datensatz.titelcode || "",
      autor: datensatz.autor || "",
      verlag: datensatz.verlag || "",
      fach_id: datensatz.fach_id ?? null,
      veroeffentlicht: datensatz.veroeffentlicht || "",
      cover_url: datensatz.cover_url || "",
      cover_bild: datensatz.cover_bild || "",
      jahrgangsstufe: datensatz.jahrgangsstufe || "",
      schuljahr_ausgabe: datensatz.schuljahr_ausgabe || "",
      ist_arbeitsheft: Boolean(datensatz.ist_arbeitsheft),
      ist_lehrerversion: Boolean(datensatz.ist_lehrerversion),
      herkunft_id: datensatz.herkunft_id ?? null
    };
    buchCoverVorschau.value = datensatz.cover_bild || datensatz.cover_url || "";
    return;
  }

  formen.lehrer = {
    id: datensatz.id,
    kuerzel: datensatz.kuerzel || "",
    anrede: datensatz.anrede || "",
    vorname: datensatz.vorname || "",
    nachname: datensatz.nachname || "",
    anzeigename: datensatz.anzeigename || "",
    barcode: datensatz.barcode || "",
    email: datensatz.email || "",
    fachbereich: datensatz.fachbereich || "",
    aktiv: Boolean(datensatz.aktiv),
    notizen: datensatz.notizen || ""
  };
}

async function buchCoverAuswaehlen(event) {
  const datei = event.target.files?.[0];
  if (!datei) return;

  if (!datei.type.startsWith("image/")) {
    apiFehler.value = "Bitte eine Bilddatei auswaehlen.";
    event.target.value = "";
    return;
  }

  if (datei.size > 2.5 * 1024 * 1024) {
    apiFehler.value = "Das Bild ist zu gross (max. 2,5 MB).";
    event.target.value = "";
    return;
  }

  apiFehler.value = "";

  const datenUrl = await new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(String(reader.result || ""));
    reader.onerror = () => reject(new Error("Bild konnte nicht gelesen werden."));
    reader.readAsDataURL(datei);
  });

  formen.buecher.cover_bild = datenUrl;
  buchCoverVorschau.value = datenUrl;
  event.target.value = "";
}

async function ladeDaten() {
  laedtBereiche.value = true;
  apiFehler.value = "";

  try {
    const [schueler, klassen, lehrkraefte, buecher, faecher, herkunft, einstellungen, ausleiher] = await Promise.all([
      props.apiRequest("/schueler"),
      props.apiRequest("/klassen"),
      props.apiRequest("/lehrkraefte"),
      props.apiRequest("/buecher"),
      props.apiRequest("/faecher"),
      props.apiRequest("/herkunft"),
      props.apiRequest("/einstellungen"),
      props.apiRequest("/ausleiher")
    ]);

    listen.schueler = schueler;
    listen.klassen = klassen;
    listen.lehrer = lehrkraefte;
    listen.buecher = buecher;
    listen.faecher = faecher;
    listen.herkunft = herkunft;
    listen.ausleiher = ausleiher;
    formen.benutzer = cloneDaten(einstellungen.benutzer);
    formen.geraete = cloneDaten(einstellungen.geraete);

    if (listen.schueler.length > 0) {
      setzeAuswahl("schueler", listen.schueler.find((eintrag) => eintrag.id === auswahl.schueler) || listen.schueler[0]);
    }

    if (listen.klassen.length > 0) {
      setzeAuswahl("klassen", listen.klassen.find((eintrag) => eintrag.id === auswahl.klassen) || listen.klassen[0]);
    }

    if (listen.lehrer.length > 0) {
      setzeAuswahl("lehrer", listen.lehrer.find((eintrag) => eintrag.id === auswahl.lehrer) || listen.lehrer[0]);
    }

    if (listen.buecher.length > 0) {
      setzeAuswahl("buecher", listen.buecher.find((eintrag) => eintrag.id === auswahl.buecher) || listen.buecher[0]);
    }
  } catch (error) {
    apiFehler.value = error.message;
  } finally {
    laedtBereiche.value = false;
  }
}

async function speichereDatensatz() {
  apiFehler.value = "";
  erfolgsMeldung.value = "";

  try {
    if (aktiverBereich.value === "schueler" && formen.schueler.id) {
      const response = await props.apiRequest(`/schueler/${formen.schueler.id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formen.schueler)
      });
      erfolgsMeldung.value = response.meldung;
      await ladeDaten();
      return;
    }

    if (aktiverBereich.value === "klassen" && formen.klassen.id) {
      const response = await props.apiRequest(`/klassen/${formen.klassen.id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formen.klassen)
      });
      erfolgsMeldung.value = response.meldung;
      await ladeDaten();
      return;
    }

    if (aktiverBereich.value === "lehrer" && formen.lehrer.id) {
      const response = await props.apiRequest(`/lehrkraefte/${formen.lehrer.id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formen.lehrer)
      });
      erfolgsMeldung.value = response.meldung;
      await ladeDaten();
      return;
    }

    if (aktiverBereich.value === "buecher" && formen.buecher.artikel_id) {
      const response = await props.apiRequest(`/buecher/${formen.buecher.artikel_id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formen.buecher)
      });
      erfolgsMeldung.value = response.meldung;
      await ladeDaten();
    }
  } catch (error) {
    apiFehler.value = error.message;
  }
}

async function speichereSystembereich() {
  apiFehler.value = "";
  erfolgsMeldung.value = "";

  try {
    const response = await props.apiRequest(`/einstellungen/${aktiverBereich.value}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(formen[aktiverBereich.value])
    });
    formen[aktiverBereich.value] = cloneDaten(response.daten);
    erfolgsMeldung.value = response.meldung;
  } catch (error) {
    apiFehler.value = error.message;
  }
}

function datensatzTitel(eintrag) {
  if (!eintrag) return "";

  if (aktiverBereich.value === "schueler") {
    return eintrag.anzeigename || `${eintrag.nachname}, ${eintrag.vorname}`;
  }

  if (aktiverBereich.value === "klassen") {
    return `Klasse ${eintrag.bezeichnung}`;
  }

  if (aktiverBereich.value === "buecher") {
    return eintrag.titel || eintrag.titelcode || "Unbekannt";
  }

  return eintrag.anzeigename || `${eintrag.nachname}, ${eintrag.vorname}`;
}

function datensatzUntertitel(eintrag) {
  if (!eintrag) return "";

  if (aktiverBereich.value === "schueler") {
    return [eintrag.klasse ? `Klasse ${eintrag.klasse}` : null, eintrag.barcode || null].filter(Boolean).join(" · ");
  }

  if (aktiverBereich.value === "klassen") {
    return [`Stufe ${eintrag.stufe || "-"}`, eintrag.parallelklasse ? `Parallel ${eintrag.parallelklasse}` : null].filter(Boolean).join(" · ");
  }

  if (aktiverBereich.value === "buecher") {
    const autor = eintrag.autor ? (eintrag.autor.length > 30 ? eintrag.autor.slice(0, 30) + "…" : eintrag.autor) : null;
    return [autor, eintrag.fach || null, eintrag.exemplare_gesamt != null ? `${eintrag.exemplare_gesamt} Ex.` : null].filter(Boolean).join(" · ");
  }

  return [eintrag.fachbereich || null, eintrag.kuerzel || null].filter(Boolean).join(" · ");
}

watch(aktiverBereich, (bereich) => {
  if (["schueler", "klassen", "lehrer", "buecher"].includes(bereich) && aktiveListe.value.length > 0 && !aktiveAuswahl.value) {
    setzeAuswahl(bereich, aktiveListe.value[0]);
  }

  apiFehler.value = "";
  erfolgsMeldung.value = "";
  ausgewaehlteSchueler.value = [];
  zeigeSchuelerFormular.value = false;
  zeigeSchuelerImport.value = false;
  importDaten.value = [];
  svwsImportForm.host = "http://localhost";
  svwsImportForm.schule = "durs";
  svwsImportForm.user = "Admin";
  svwsImportForm.passwort = "";
  svwsImportDaten.value = [];
  svwsVerbindungOk.value = false;
  svwsPrueftVerbindung.value = false;
  svwsDatenLaden.value = false;
  svwsImportLaeuft.value = false;
  svwsStatusMeldung.value = "";
  svwsStatusTyp.value = "info";
  zeigeLehrerImport.value = false;
  importDatenLehrer.value = [];
  zeigeInaktiveSchueler.value = false;
  ausleiherFilterText.value = "";
  schuelerFilterText.value = "";
  klassenFilterText.value = "";
  zeigeKlassenFormular.value = false;
  zeigeInaktiveKlassen.value = false;
  lehrerFilterText.value = "";
  zeigeLehrerFormular.value = false;
  zeigeInaktiveLehrer.value = false;
});

watch(
  () => [svwsImportForm.host, svwsImportForm.schule, svwsImportForm.user, svwsImportForm.passwort],
  () => {
    svwsVerbindungOk.value = false;
  }
);

async function loescheAusgewaehlteSchueler() {
  if (ausgewaehlteSchueler.value.length === 0) return;
  if (!confirm(`Sollen die ${ausgewaehlteSchueler.value.length} ausgewählten Schüler wirklich gelöscht werden?`)) return;

  apiFehler.value = "";
  erfolgsMeldung.value = "";

  try {
    const response = await props.apiRequest("/schueler", {
      method: "DELETE",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ ids: ausgewaehlteSchueler.value })
    });
    erfolgsMeldung.value = response.meldung;
    
    setTimeout(() => {
      if (erfolgsMeldung.value === response.meldung) {
        erfolgsMeldung.value = "";
      }
    }, 5000);

    ausgewaehlteSchueler.value = [];
    await ladeDaten();
  } catch (error) {
    apiFehler.value = error.message;
    setTimeout(() => {
      if (apiFehler.value === error.message) {
        apiFehler.value = "";
      }
    }, 5000);
  }
}

onMounted(() => {
  ladeDaten();
});
</script>

<template>
  <section class="einstellungen-layout">
    <aside class="panel einstellungen-nav-panel">
      <p class="eyebrow einstellungen-eyebrow">Einstellungen</p>
      <h2>Systembereiche</h2>


      <nav class="einstellungen-nav" aria-label="Einstellungsbereiche">
        <template v-for="bereich in bereiche" :key="bereich.id">
          <hr v-if="bereich.trennlinie" class="einstellungen-nav-divider" />
          <button
            type="button"
            :class="['einstellungen-link', aktiverBereich === bereich.id ? 'is-active' : '', bereich.katalog ? 'is-katalog' : '']"
            @click="wechsleBereich(bereich.id)"
          >
            <span class="einstellungen-link-title">{{ bereich.label }}</span>
            <span class="einstellungen-link-copy">{{ bereich.beschreibung }}</span>
          </button>
        </template>
      </nav>
    </aside>

    <section class="panel einstellungen-detail-panel">
      <header class="einstellungen-detail-head">
        <div>
          <p class="eyebrow einstellungen-eyebrow">Bereich</p>
          <h2>{{ aktiverEintrag.label }}</h2>
          <p class="einstellungen-intro">
            {{ aktiverEintrag.beschreibung }}
            <template v-if="aktiverBereich === 'schueler' && listen.schueler">
              — Gesamtanzahl: {{ gefilterteSchueler.length }}
            </template>
          </p>
        </div>
        <div style="display: flex; gap: 15px; align-items: center;">
          <button
            v-if="(aktiverBereich === 'schueler' && !zeigeSchuelerFormular && !zeigeSchuelerImport) || (aktiverBereich === 'lehrer' && !zeigeLehrerFormular && !zeigeLehrerImport)"
            type="button"
            class="secondary"
            style="padding: 6px 12px; font-size: 0.9rem; border-radius: 8px; cursor: pointer; border: 1px solid #1f4d6b; background: white; color: #1f4d6b;"
            @click="aktiverBereich === 'schueler' ? zeigeSchuelerImport = true : zeigeLehrerImport = true"
          >
            Importieren
          </button>
          <button
            v-if="aktiverBereich === 'schueler' && ausgewaehlteSchueler.length > 0 && !zeigeSchuelerFormular && !zeigeSchuelerImport"
            type="button"
            class="primary"
            style="background: #e74c3c; padding: 6px 12px; font-size: 0.9rem; border-radius: 8px; border: none; cursor: pointer; color: white;"
            @click="loescheAusgewaehlteSchueler"
          >
            Löschen ({{ ausgewaehlteSchueler.length }})
          </button>
          <div class="status-pill">{{ ["schueler", "klassen", "lehrer", "buecher", "ausleiher"].includes(aktiverBereich) ? "Stammdaten" : ["artikel", "inventar_typen", "statuskatalog", "zustandskatalog", "standorte"].includes(aktiverBereich) ? "Katalog" : "Konfiguration" }}</div>
        </div>
      </header>

      <p v-if="apiFehler" class="feedback error">{{ apiFehler }}</p>
      <p v-if="erfolgsMeldung" class="feedback success">{{ erfolgsMeldung }}</p>

      <div v-if="laedtBereiche" class="empty-state" style="margin-top: 22px;">Einstellungen werden geladen...</div>

      <template v-else-if="aktiverBereich === 'schueler'">
        <div v-if="zeigeSchuelerImport" style="margin-top: 22px;">
          <button @click="zeigeSchuelerImport = false; importDaten = []" type="button" class="secondary" style="margin-bottom: 20px;">
            &larr; Zurück zur Übersicht
          </button>
          <article class="einstellungen-card" style="margin-bottom: 18px;">
            <h3>Schüler Importieren</h3>
            <p class="einstellungen-intro" style="margin-bottom: 15px;">Wähle eine CSV-Datei mit dem Aufbau: <code>"Interne ID-Nummer";"Vorname";"Nachname";"Klasse";"Geburtsdatum";"E-Mail"</code></p>
            <div style="margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between;">
              <div>
                <input type="file" accept=".csv,.txt" @change="verarbeiteImportDatei" style="display: none;" ref="importFileInput" id="importFileInput" />
                <button type="button" class="secondary" @click="$refs.importFileInput.click()">Importdatei wählen</button>
              </div>
              <label v-if="importDaten.length > 0" style="display: flex; align-items: center; gap: 8px; font-size: 0.9rem; cursor: pointer; user-select: none;">
                <input type="checkbox" v-model="zeigeNurAenderungenUndFehler" style="accent-color: #e74c3c; cursor: pointer;" />
                Nur Änderungen
              </label>
            </div>
            
            <div v-if="importDaten.length > 0" style="max-height: 400px; overflow-y: auto; border: 1px solid rgba(36, 52, 71, 0.1); border-radius: 8px;">
              <table class="data-table" style="width: 100%; border-collapse: collapse; background: white;">
                <thead style="position: sticky; top: 0; z-index: 10; background: #f4f6f8;">
                  <tr style="text-align: left;">
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">S-ID</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Status</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Vorname</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Nachname</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Klasse</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Geburtsdatum</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">E-Mail</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(row, index) in gefilterteImportDaten" :key="index" style="border-bottom: 1px solid rgba(36, 52, 71, 0.05);">
                    <td style="padding: 4px 8px; font-size: 0.9rem;">{{ row.s_id }}</td>
                    <td style="padding: 4px 8px; font-size: 0.9rem;">
                      <span class="status-pill" :style="{ backgroundColor: row.statusFarbe + '20', color: row.statusFarbe, fontSize: '0.75rem', fontWeight: 'bold' }">{{ row.importStatus }}</span>
                    </td>
                    <td :style="importAenderungsZellenStil(row, 'Vorname')">
                      <template v-if="istImportFeldGeaendert(row, 'Vorname')">
                        {{ formatiereImportVergleichswert(row.bestehendeWerte?.vorname) }} → {{ formatiereImportVergleichswert(row.vorname) }}
                      </template>
                      <template v-else>
                        {{ formatiereImportVergleichswert(row.vorname) }}
                      </template>
                    </td>
                    <td :style="importAenderungsZellenStil(row, 'Nachname')">
                      <template v-if="istImportFeldGeaendert(row, 'Nachname')">
                        {{ formatiereImportVergleichswert(row.bestehendeWerte?.nachname) }} → {{ formatiereImportVergleichswert(row.nachname) }}
                      </template>
                      <template v-else>
                        {{ formatiereImportVergleichswert(row.nachname) }}
                      </template>
                    </td>
                    <td :style="importAenderungsZellenStil(row, 'Klasse')">
                      <template v-if="istImportFeldGeaendert(row, 'Klasse')">
                        {{ formatiereImportVergleichswert(row.bestehendeWerte?.klasse) }} → {{ formatiereImportVergleichswert(row.klasse) }}
                      </template>
                      <template v-else>
                        {{ formatiereImportVergleichswert(row.klasse) }}
                      </template>
                    </td>
                    <td :style="importAenderungsZellenStil(row, 'Datum')">
                      <template v-if="istImportFeldGeaendert(row, 'Datum')">
                        {{ formatiereImportVergleichswert(row.bestehendeWerte?.geburtsdatum) }} → {{ formatiereImportVergleichswert(row.geburtsdatum) }}
                      </template>
                      <template v-else>
                        {{ formatiereImportVergleichswert(row.geburtsdatum) }}
                      </template>
                    </td>
                    <td :style="importAenderungsZellenStil(row, 'E-Mail')">
                      <template v-if="istImportFeldGeaendert(row, 'E-Mail')">
                        {{ formatiereImportVergleichswert(row.bestehendeWerte?.email) }}→{{ formatiereImportVergleichswert(row.email) }}
                      </template>
                      <template v-else>
                        {{ formatiereImportVergleichswert(row.email) }}
                      </template>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div style="margin-top: 15px;" v-if="importDaten.length > 0">
              <button type="button" class="primary" @click="speichereImport" :disabled="importLaeuft">
                {{ importLaeuft ? 'Wird importiert...' : 'Daten prüfen & importieren (' + importDaten.length + ')' }}
              </button>
            </div>
          </article>
          <article class="einstellungen-card">
            <div class="svws-section-head">
              <h3>Schüler vom SVWS-Server importieren</h3>
              <span class="svws-db-badge" :class="{ 'is-active': svwsVerbindungOk }">Verbindung zur DB</span>
            </div>
            <p class="einstellungen-intro" style="margin-bottom: 18px;">
              Hinterlege hier die Zugangsdaten für den SVWS-Server, um die Verbindung zu prüfen und Schüler direkt zu importieren.
            </p>
            <p class="einstellungen-intro" style="margin-top: -8px; margin-bottom: 18px;">
              Bei lokalem SVWS auf demselben Rechner: `http://localhost:3000` oder der echte Servername. Wenn das Backend in Docker läuft, funktioniert oft `host.docker.internal:3000` statt `localhost`.
            </p>
            <div class="form-grid">
              <label class="field">
                <span>Host</span>
                <input v-model="svwsImportForm.host" type="text" placeholder="svws.example.org" />
              </label>
              <label class="field">
                <span>Schule</span>
                <input v-model="svwsImportForm.schule" type="text" placeholder="z. B. 123456" />
              </label>
              <label class="field">
                <span>User</span>
                <input v-model="svwsImportForm.user" type="text" placeholder="Benutzername" />
              </label>
              <label class="field">
                <span>Passwort</span>
                <input v-model="svwsImportForm.passwort" type="password" placeholder="Passwort" />
              </label>
            </div>
            <div class="svws-button-row">
              <button type="button" class="svws-button svws-button-secondary" :disabled="svwsPrueftVerbindung" @click="testeSvwsVerbindung">{{ svwsPrueftVerbindung ? "Prüfe Verbindung..." : "Verbindung testen" }}</button>
              <button type="button" class="svws-button svws-button-primary" :disabled="svwsDatenLaden" @click="holeSvwsSchuelerDaten">{{ svwsDatenLaden ? "Hole Schülerdaten..." : "Schülerdaten anzeigen" }}</button>
            </div>
            <div v-if="svwsImportDaten.length > 0" style="margin-top: 18px;">
              <div style="display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 12px; flex-wrap: wrap;">
                <div style="display: flex; align-items: center; gap: 14px; flex-wrap: wrap;">
                  <span
                    v-if="svwsStatusMeldung && svwsStatusTyp === 'success'"
                    style="color: #1f6b52; font-size: 0.92rem; font-weight: 600;"
                  >
                    {{ svwsStatusMeldung }}
                  </span>
                  <label style="display: flex; align-items: center; gap: 8px; font-size: 0.9rem; cursor: pointer; user-select: none;">
                    <input type="checkbox" v-model="zeigeNurAenderungenUndFehler" style="accent-color: #e74c3c; cursor: pointer;" />
                    Nur Änderungen
                  </label>
                </div>
                <button type="button" class="svws-button svws-button-primary" :disabled="svwsImportLaeuft" @click="importiereSchuelerVonSvws">{{ svwsImportLaeuft ? "Importiere Schülerdaten..." : "Schülerdaten importieren" }}</button>
              </div>
              <div style="max-height: 400px; overflow-y: auto; border: 1px solid rgba(36, 52, 71, 0.1); border-radius: 8px;">
                <table class="data-table" style="width: 100%; border-collapse: collapse; background: white;">
                  <thead style="position: sticky; top: 0; z-index: 10; background: #f4f6f8;">
                    <tr style="text-align: left;">
                      <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">S-ID</th>
                      <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Status</th>
                      <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Vorname</th>
                      <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Nachname</th>
                      <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Klasse</th>
                      <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Geburtsdatum</th>
                      <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">E-Mail</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(row, index) in gefilterteSvwsImportDaten" :key="`svws-${index}`" style="border-bottom: 1px solid rgba(36, 52, 71, 0.05);">
                      <td style="padding: 4px 8px; font-size: 0.9rem;">{{ row.s_id }}</td>
                      <td style="padding: 4px 8px; font-size: 0.9rem;">
                        <span class="status-pill" :style="{ backgroundColor: row.statusFarbe + '20', color: row.statusFarbe, fontSize: '0.75rem', fontWeight: 'bold' }">{{ row.importStatus }}</span>
                      </td>
                      <td :style="importAenderungsZellenStil(row, 'Vorname')">
                        <template v-if="istImportFeldGeaendert(row, 'Vorname')">
                          {{ formatiereImportVergleichswert(row.bestehendeWerte?.vorname) }} → {{ formatiereImportVergleichswert(row.vorname) }}
                        </template>
                        <template v-else>
                          {{ formatiereImportVergleichswert(row.vorname) }}
                        </template>
                      </td>
                      <td :style="importAenderungsZellenStil(row, 'Nachname')">
                        <template v-if="istImportFeldGeaendert(row, 'Nachname')">
                          {{ formatiereImportVergleichswert(row.bestehendeWerte?.nachname) }} → {{ formatiereImportVergleichswert(row.nachname) }}
                        </template>
                        <template v-else>
                          {{ formatiereImportVergleichswert(row.nachname) }}
                        </template>
                      </td>
                      <td :style="importAenderungsZellenStil(row, 'Klasse')">
                        <template v-if="istImportFeldGeaendert(row, 'Klasse')">
                          {{ formatiereImportVergleichswert(row.bestehendeWerte?.klasse) }} → {{ formatiereImportVergleichswert(row.klasse) }}
                        </template>
                        <template v-else>
                          {{ formatiereImportVergleichswert(row.klasse) }}
                        </template>
                      </td>
                      <td :style="importAenderungsZellenStil(row, 'Datum')">
                        <template v-if="istImportFeldGeaendert(row, 'Datum')">
                          {{ formatiereImportVergleichswert(row.bestehendeWerte?.geburtsdatum) }} → {{ formatiereImportVergleichswert(row.geburtsdatum) }}
                        </template>
                        <template v-else>
                          {{ formatiereImportVergleichswert(row.geburtsdatum) }}
                        </template>
                      </td>
                      <td :style="importAenderungsZellenStil(row, 'E-Mail')">
                        <template v-if="istImportFeldGeaendert(row, 'E-Mail')">
                          {{ formatiereImportVergleichswert(row.bestehendeWerte?.email) }} â†’ {{ formatiereImportVergleichswert(row.email) }}
                        </template>
                        <template v-else>
                          {{ formatiereImportVergleichswert(row.email) }}
                        </template>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
            <p
              v-if="svwsStatusMeldung && svwsStatusTyp !== 'success'"
              :style="{
                marginTop: '14px',
                marginBottom: 0,
                color: svwsStatusTyp === 'error' ? '#9d2c30' : svwsStatusTyp === 'success' ? '#1f6b52' : '#1f4d6b',
                fontSize: '0.92rem'
              }"
            >
              {{ svwsStatusMeldung }}
            </p>
          </article>
        </div>

        <div v-else-if="!zeigeSchuelerFormular" style="margin-top: 22px;">
          <div style="display: flex; gap: 10px; margin-bottom: 15px; align-items: center;">
            <span class="subtle">Filtern nach:</span>
            <select v-model="schuelerFilterSpalte" style="padding: 0 12px; height: 38px; box-sizing: border-box; border-radius: 8px; border: 1px solid rgba(36, 52, 71, 0.2); background: white; font-size: 0.9rem; cursor: pointer;">
              <option value="nachname">Nachname</option>
              <option value="vorname">Vorname</option>
              <option value="s_id">S-ID</option>
              <option value="klasse">Klasse</option>
              <option value="barcode">Barcode</option>
            </select>
            <div class="scanner-input-wrap" style="flex: 1; max-width: 300px;">
              <input 
                v-model="schuelerFilterText" 
                type="text" 
                placeholder="Suchen..." 
                style="padding: 0 12px; padding-right: 32px; height: 38px; box-sizing: border-box; border-radius: 8px; border: 1px solid rgba(36, 52, 71, 0.2); width: 100%; font-size: 0.9rem;" 
              />
              <button
                v-if="schuelerFilterText"
                type="button"
                class="scanner-clear-button"
                aria-label="Filter zurücksetzen"
                @click="schuelerFilterText = ''"
              >
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                  <line x1="18" y1="6" x2="6" y2="18"/>
                  <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
              </button>
            </div>
            <label style="display: flex; align-items: center; gap: 8px; margin-left: auto; font-size: 0.9rem; cursor: pointer; user-select: none; white-space: nowrap;">
              <input type="checkbox" v-model="zeigeInaktiveSchueler" style="accent-color: #1f4d6b; cursor: pointer;" />
              Inaktive einblenden
            </label>
          </div>
          <div style="max-height: 700px; overflow-y: auto; border: 1px solid rgba(36, 52, 71, 0.1); border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
            <table class="data-table" style="width: 100%; border-collapse: collapse; background: white;">
              <thead style="position: sticky; top: 0; z-index: 10; background: #f4f6f8;">
                <tr style="text-align: left;">
                  <th style="padding: 6px 8px; width: 40px; border-bottom: 2px solid rgba(36, 52, 71, 0.1);"></th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">S-ID</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Nachname</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Vorname</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Kl.</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Anz.Ausleihen</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Status</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Barcode</th>
                  <th style="padding: 6px 8px; width: 40px; border-bottom: 2px solid rgba(36, 52, 71, 0.1); text-align: center;">
                    <input type="checkbox" @change="toggleAlleSchueler($event)" :checked="ausgewaehlteSchueler.length === gefilterteSchueler.length && gefilterteSchueler.length > 0" style="cursor: pointer; accent-color: #1f4d6b;" />
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="schueler in gefilterteSchueler" :key="schueler.id" class="schueler-row" style="border-bottom: 1px solid rgba(36, 52, 71, 0.05); transition: background-color 150ms ease;">
                  <td style="padding: 4px 8px; text-align: center;">
                    <button type="button" @click="bearbeiteSchueler(schueler)" style="background: none; border: none; cursor: pointer; padding: 2px; display: inline-flex; align-items: center; justify-content: center;" title="Bearbeiten">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#1f4d6b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                      </svg>
                    </button>
                  </td>
                  <td style="padding: 4px 8px; font-size: 0.9rem; color: rgba(36, 52, 71, 0.65);">{{ schueler.s_id || '-' }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ schueler.nachname }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ schueler.vorname }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ schueler.klasse || '-' }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem; text-align: center;">{{ schueler.aktive_ausleihen || 0 }}</td>
                  <td style="padding: 4px 8px;">
                    <span :style="{ padding: '2px 6px', borderRadius: '10px', fontSize: '0.75rem', fontWeight: 'bold', backgroundColor: schueler.aktiv ? 'rgba(46, 204, 113, 0.15)' : 'rgba(231, 76, 60, 0.15)', color: schueler.aktiv ? '#27ae60' : '#c0392b' }">
                      {{ schueler.aktiv ? 'Aktiv' : 'Inaktiv' }}
                    </span>
                  </td>
                  <td style="padding: 4px 8px; font-size: 0.9rem; color: rgba(36, 52, 71, 0.65);">{{ schueler.barcode || '-' }}</td>
                  <td style="padding: 4px 8px; text-align: center;">
                    <input type="checkbox" :value="schueler.id" v-model="ausgewaehlteSchueler" style="cursor: pointer; accent-color: #1f4d6b;" />
                  </td>
                </tr>
                <tr v-if="gefilterteSchueler.length === 0">
                  <td colspan="8" style="padding: 16px; text-align: center; color: rgba(36, 52, 71, 0.5);">Keine Schüler gefunden.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <div v-else class="einstellungen-form-panel" style="margin-top: 22px;">
          <div style="margin-bottom: 20px;">
            <button type="button" class="secondary" @click="zeigeSchuelerFormular = false" style="display: flex; align-items: center; gap: 6px;">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
              Zurück zur Übersicht
            </button>
          </div>
          <div class="einstellungen-stack">
            <article class="einstellungen-card">
              <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h3 style="margin: 0;">Schuelerdaten</h3>
                <div style="display: flex; gap: 8px;">
                  <span class="status-pill" style="background: rgba(36, 52, 71, 0.08); color: #243447; font-family: monospace;">DB-ID: {{ formen.schueler.id || '-' }}</span>
                  <span class="status-pill" style="background: rgba(46, 204, 113, 0.15); color: #27ae60; font-family: monospace; font-weight: 600;">S-ID: {{ formen.schueler.s_id || '-' }}</span>
                </div>
              </div>
              <div class="form-grid">
                <label class="field">
                  <span>Vorname</span>
                  <input v-model="formen.schueler.vorname" type="text" />
                </label>
                <label class="field">
                  <span>Nachname</span>
                  <input v-model="formen.schueler.nachname" type="text" />
                </label>
                <label class="field field-wide">
                  <span>Anzeigename</span>
                  <input v-model="formen.schueler.anzeigename" type="text" />
                </label>
                <label class="field">
                  <span>Barcode</span>
                  <input v-model="formen.schueler.barcode" type="text" />
                </label>
                <label class="field">
                  <span>Geburtsdatum</span>
                  <input v-model="formen.schueler.geburtsdatum" type="date" />
                </label>
                <label class="field">
                  <span>E-Mail</span>
                  <input v-model="formen.schueler.email" type="email" />
                </label>
                <label class="field field-aktiv-hinweis">
                  <span>Aktiv</span>
                  <select v-model="formen.schueler.aktiv">
                    <option :value="true">ja</option>
                    <option :value="false">nein</option>
                  </select>
                </label>
                <label class="field">
                  <span>Klasse</span>
                  <select v-model="formen.schueler.klassen_id">
                    <option value="">Keine Zuordnung</option>
                    <option v-for="klasse in listen.klassen" :key="`klasse-opt-${klasse.id}`" :value="klasse.id">
                      {{ klasse.bezeichnung }}
                    </option>
                  </select>
                </label>
                <label class="field">
                  <span>Schuljahr</span>
                  <input v-model="formen.schueler.schuljahr" type="text" placeholder="z. B. 2025/2026" />
                </label>
                <label class="field field-wide">
                  <span>Notizen</span>
                  <textarea v-model="formen.schueler.notizen" rows="4"></textarea>
                </label>
              </div>
            </article>
          </div>
          <div class="button-row" style="margin-top: 20px;">
            <button class="primary" @click="speichereDatensatz">Aenderungen speichern</button>
          </div>
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'ausleiher'">
        <div style="margin-top: 22px;">
          <div style="display: flex; gap: 10px; margin-bottom: 15px; align-items: center;">
            <span class="subtle">Filtern nach:</span>
            <select v-model="ausleiherFilterSpalte" style="padding: 0 12px; height: 38px; box-sizing: border-box; border-radius: 8px; border: 1px solid rgba(36, 52, 71, 0.2); background: white; font-size: 0.9rem; cursor: pointer;">
              <option value="name">Name</option>
              <option value="id">ID</option>
              <option value="ausleiher_typ">Typ</option>
              <option value="klasse_oder_bereich">Klasse/Bereich</option>
              <option value="barcode">Barcode</option>
              <option value="quelle_typ">Quelle</option>
            </select>
            <div class="scanner-input-wrap" style="flex: 1; max-width: 300px;">
              <input 
                v-model="ausleiherFilterText" 
                type="text" 
                placeholder="Suchen..." 
                style="padding: 0 12px; padding-right: 32px; height: 38px; box-sizing: border-box; border-radius: 8px; border: 1px solid rgba(36, 52, 71, 0.2); width: 100%; font-size: 0.9rem;" 
              />
              <button
                v-if="ausleiherFilterText"
                type="button"
                class="scanner-clear-button"
                aria-label="Filter zurücksetzen"
                @click="ausleiherFilterText = ''"
              >
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                  <line x1="18" y1="6" x2="6" y2="18"/>
                  <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
              </button>
            </div>
          </div>
          <div style="max-height: 700px; overflow-y: auto; border: 1px solid rgba(36, 52, 71, 0.1); border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
            <table class="data-table" style="width: 100%; border-collapse: collapse; background: white;">
              <thead style="position: sticky; top: 0; z-index: 10; background: #f4f6f8;">
                <tr style="text-align: left;">
                  <th style="padding: 6px 8px; width: 40px; border-bottom: 2px solid rgba(36, 52, 71, 0.1);"></th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">ID</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Name</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Typ</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Klasse/Bereich</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Barcode</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Quelle</th>
                  <th style="padding: 6px 8px; width: 40px; border-bottom: 2px solid rgba(36, 52, 71, 0.1);"></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="ausleiher in gefilterteAusleiher" :key="ausleiher.id" class="schueler-row" style="border-bottom: 1px solid rgba(36, 52, 71, 0.05); transition: background-color 150ms ease;">
                  <td style="padding: 4px 8px; text-align: center;">
                    <button type="button" @click="bearbeiteAusleiher(ausleiher)" style="background: none; border: none; cursor: pointer; padding: 2px; display: inline-flex; align-items: center; justify-content: center;" title="Bearbeiten">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#1f4d6b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                      </svg>
                    </button>
                  </td>
                  <td style="padding: 4px 8px; font-size: 0.9rem; color: rgba(36, 52, 71, 0.65);">{{ ausleiher.id }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ ausleiher.name }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ ausleiher.ausleiher_typ }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ ausleiher.klasse_oder_bereich || '-' }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem; color: rgba(36, 52, 71, 0.65);">{{ ausleiher.barcode || '-' }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">
                    <span class="status-pill" style="padding: 2px 6px; font-size: 0.75rem; font-weight: bold; background: rgba(36, 52, 71, 0.08); color: #243447;">
                      {{ ausleiher.quelle_typ }} ({{ ausleiher.quelle_id }})
                    </span>
                  </td>
                  <td style="padding: 4px 8px; text-align: center;">
                    <button type="button" @click="loescheAusleiher(ausleiher)" style="background: none; border: none; cursor: pointer; padding: 2px; display: inline-flex; align-items: center; justify-content: center;" title="Löschen">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e74c3c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="3 6 5 6 21 6"></polyline>
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                      </svg>
                    </button>
                  </td>
                </tr>
                <tr v-if="gefilterteAusleiher.length === 0">
                  <td colspan="8" style="padding: 16px; text-align: center; color: rgba(36, 52, 71, 0.5);">Keine Ausleiher gefunden.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'klassen'">
        <div v-if="zeigeKlassenFormular" style="margin-top: 22px;">
          <div class="einstellungen-form-panel">
            <div class="einstellungen-stack">
              <article class="einstellungen-card">
                <h3>Klassendaten bearbeiten</h3>
                <div class="form-grid">
                  <label class="field">
                    <span>Bezeichnung</span>
                    <input v-model="formen.klassen.bezeichnung" type="text" />
                  </label>
                  <label class="field">
                    <span>Stufe</span>
                    <input v-model="formen.klassen.stufe" type="text" />
                  </label>
                  <label class="field">
                    <span>Parallelklasse</span>
                    <input v-model="formen.klassen.parallelklasse" type="text" />
                  </label>
                  <label class="field">
                    <span>Aktiv</span>
                    <select v-model="formen.klassen.aktiv">
                      <option :value="true">ja</option>
                      <option :value="false">nein</option>
                    </select>
                  </label>
                </div>
              </article>
            </div>
            <div class="button-row" style="margin-top: 20px; display: flex; gap: 10px;">
              <button class="ghost" @click="zeigeKlassenFormular = false">Abbrechen</button>
              <button class="primary" @click="speichereDatensatz(); zeigeKlassenFormular = false;">Aenderungen speichern</button>
            </div>
          </div>
        </div>
        
        <div v-else style="margin-top: 22px;">
          <div style="display: flex; gap: 10px; margin-bottom: 15px; align-items: center; justify-content: space-between;">
            <div style="display: flex; gap: 10px; align-items: center;">
              <span class="subtle">Filtern nach:</span>
              <select v-model="klassenFilterSpalte" style="padding: 0 12px; height: 38px; box-sizing: border-box; border-radius: 8px; border: 1px solid rgba(36, 52, 71, 0.2); background: white; font-size: 0.9rem; cursor: pointer;">
                <option value="bezeichnung">Bezeichnung</option>
                <option value="stufe">Stufe</option>
                <option value="parallelklasse">Parallelklasse</option>
              </select>
              <div class="scanner-input-wrap" style="flex: 1; max-width: 300px;">
                <input 
                  v-model="klassenFilterText" 
                  type="text" 
                  placeholder="Suchen..." 
                  style="padding: 0 12px; padding-right: 32px; height: 38px; box-sizing: border-box; border-radius: 8px; border: 1px solid rgba(36, 52, 71, 0.2); width: 100%; font-size: 0.9rem;" 
                />
                <button
                  v-if="klassenFilterText"
                  type="button"
                  class="scanner-clear-button"
                  aria-label="Filter zurücksetzen"
                  @click="klassenFilterText = ''"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <line x1="18" y1="6" x2="6" y2="18"/>
                    <line x1="6" y1="6" x2="18" y2="18"/>
                  </svg>
                </button>
              </div>
            </div>
            <label style="display: flex; align-items: center; gap: 6px; font-size: 0.9rem; color: #243447; cursor: pointer;">
              <input type="checkbox" v-model="zeigeInaktiveKlassen" />
              Inaktive einblenden
            </label>
          </div>
          
          <div style="max-height: 700px; overflow-y: auto; border: 1px solid rgba(36, 52, 71, 0.1); border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
            <table class="data-table" style="width: 100%; border-collapse: collapse; background: white;">
              <thead style="position: sticky; top: 0; z-index: 10; background: #f4f6f8;">
                <tr style="text-align: left;">
                  <th style="padding: 6px 8px; width: 40px; border-bottom: 2px solid rgba(36, 52, 71, 0.1);"></th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">ID</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Bezeichnung</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Schüler</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Stufe</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Par.</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Aktiv</th>
                  <th style="padding: 6px 8px; width: 40px; border-bottom: 2px solid rgba(36, 52, 71, 0.1);"></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="klasse in gefilterteKlassen" :key="klasse.id" class="schueler-row" style="border-bottom: 1px solid rgba(36, 52, 71, 0.05); transition: background-color 150ms ease;">
                  <td style="padding: 4px 8px; text-align: center;">
                    <button type="button" @click="bearbeiteKlasse(klasse)" style="background: none; border: none; cursor: pointer; padding: 2px; display: inline-flex; align-items: center; justify-content: center;" title="Bearbeiten">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#1f4d6b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                      </svg>
                    </button>
                  </td>
                  <td style="padding: 4px 8px; font-size: 0.9rem; color: rgba(36, 52, 71, 0.65);">{{ klasse.id }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ klasse.bezeichnung }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ klasse.schueler_anzahl }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ klasse.stufe }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ klasse.parallelklasse }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">
                    <span v-if="klasse.aktiv" style="color: #27ae60;">Ja</span>
                    <span v-else style="color: #e74c3c;">Nein</span>
                  </td>
                  <td style="padding: 4px 8px; text-align: center;">
                    <button type="button" @click="loescheKlasse(klasse)" style="background: none; border: none; cursor: pointer; padding: 2px; display: inline-flex; align-items: center; justify-content: center;" title="Löschen">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e74c3c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="3 6 5 6 21 6"></polyline>
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                      </svg>
                    </button>
                  </td>
                </tr>
                <tr v-if="gefilterteKlassen.length === 0">
                  <td colspan="8" style="padding: 16px; text-align: center; color: rgba(36, 52, 71, 0.5);">Keine Klassen gefunden.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'lehrer'">
        <div v-if="zeigeLehrerImport" style="margin-top: 22px;">
          <button @click="zeigeLehrerImport = false; importDatenLehrer = []" type="button" class="secondary" style="margin-bottom: 20px;">
            &larr; Zurück zur Übersicht
          </button>
          <article class="einstellungen-card">
            <h3>Lehrkräfte Importieren</h3>
            <p class="einstellungen-intro" style="margin-bottom: 15px;">Wähle eine CSV-Datei mit dem Aufbau: <code>"ID";"Kürzel";"Anrede";"Vorname";"Nachname";"E-Mail";"Fachbereich"</code></p>
            <div style="margin-bottom: 20px; display: flex; align-items: center; justify-content: space-between;">
              <div>
                <input type="file" accept=".csv,.txt" @change="verarbeiteLehrerImportDatei" style="display: none;" ref="importLehrerFileInput" id="importLehrerFileInput" />
                <button type="button" class="secondary" @click="$refs.importLehrerFileInput.click()">Importdatei wählen</button>
              </div>
              <label v-if="importDatenLehrer.length > 0" style="display: flex; align-items: center; gap: 8px; font-size: 0.9rem; cursor: pointer; user-select: none;">
                <input type="checkbox" v-model="zeigeNurAenderungenUndFehlerLehrer" style="accent-color: #e74c3c; cursor: pointer;" />
                Nur Änderungen
              </label>
            </div>
            
            <div v-if="importDatenLehrer.length > 0" style="max-height: 400px; overflow-y: auto; border: 1px solid rgba(36, 52, 71, 0.1); border-radius: 8px;">
              <table class="data-table" style="width: 100%; border-collapse: collapse; background: white;">
                <thead style="position: sticky; top: 0; z-index: 10; background: #f4f6f8;">
                  <tr style="text-align: left;">
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">ID</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Kürzel</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Status</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Anrede</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Vorname</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Nachname</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">E-Mail</th>
                    <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Fachbereich</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(row, index) in gefilterteImportDatenLehrer" :key="index" style="border-bottom: 1px solid rgba(36, 52, 71, 0.05);">
                    <td style="padding: 4px 8px; font-size: 0.9rem;">{{ row.id }}</td>
                    <td :style="importAenderungsZellenStil(row, 'Kuerzel')">
                      <template v-if="istImportFeldGeaendert(row, 'Kuerzel')">
                        {{ formatiereImportVergleichswert(row.bestehendeWerte?.kuerzel) }} → {{ formatiereImportVergleichswert(row.kuerzel) }}
                      </template>
                      <template v-else>
                        {{ formatiereImportVergleichswert(row.kuerzel) }}
                      </template>
                    </td>
                    <td style="padding: 4px 8px; font-size: 0.9rem;">
                      <span v-if="row.importStatus !== 'Unverändert'" class="status-pill" :style="{ backgroundColor: row.statusFarbe + '20', color: row.statusFarbe, fontSize: '0.75rem', fontWeight: 'bold' }">{{ row.importStatus }}</span>
                    </td>
                    <td :style="importAenderungsZellenStil(row, 'Anrede')">
                      <template v-if="istImportFeldGeaendert(row, 'Anrede')">
                        {{ formatiereImportVergleichswert(row.bestehendeWerte?.anrede) }} → {{ formatiereImportVergleichswert(row.anrede) }}
                      </template>
                      <template v-else>
                        {{ formatiereImportVergleichswert(row.anrede) }}
                      </template>
                    </td>
                    <td :style="importAenderungsZellenStil(row, 'Vorname')">
                      <template v-if="istImportFeldGeaendert(row, 'Vorname')">
                        {{ formatiereImportVergleichswert(row.bestehendeWerte?.vorname) }} → {{ formatiereImportVergleichswert(row.vorname) }}
                      </template>
                      <template v-else>
                        {{ formatiereImportVergleichswert(row.vorname) }}
                      </template>
                    </td>
                    <td :style="importAenderungsZellenStil(row, 'Nachname')">
                      <template v-if="istImportFeldGeaendert(row, 'Nachname')">
                        {{ formatiereImportVergleichswert(row.bestehendeWerte?.nachname) }} → {{ formatiereImportVergleichswert(row.nachname) }}
                      </template>
                      <template v-else>
                        {{ formatiereImportVergleichswert(row.nachname) }}
                      </template>
                    </td>
                    <td :style="importAenderungsZellenStil(row, 'E-Mail')">
                      <template v-if="istImportFeldGeaendert(row, 'E-Mail')">
                        {{ formatiereImportVergleichswert(row.bestehendeWerte?.email) }} → {{ formatiereImportVergleichswert(row.email) }}
                      </template>
                      <template v-else>
                        {{ formatiereImportVergleichswert(row.email) }}
                      </template>
                    </td>
                    <td :style="importAenderungsZellenStil(row, 'Fachbereich')">
                      <template v-if="istImportFeldGeaendert(row, 'Fachbereich')">
                        {{ formatiereImportVergleichswert(row.bestehendeWerte?.fachbereich) }} → {{ formatiereImportVergleichswert(row.fachbereich) }}
                      </template>
                      <template v-else>
                        {{ formatiereImportVergleichswert(row.fachbereich) }}
                      </template>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div style="margin-top: 15px;" v-if="importDatenLehrer.length > 0">
              <button type="button" class="primary" @click="speichereLehrerImport" :disabled="importLaeuftLehrer">
                {{ importLaeuftLehrer ? 'Wird importiert...' : 'Daten prüfen & importieren (' + importDatenLehrer.length + ')' }}
              </button>
            </div>
          </article>
        </div>

        <div v-else-if="zeigeLehrerFormular" style="margin-top: 22px;">
          <div class="einstellungen-form-panel">
            <div class="einstellungen-stack">
              <article class="einstellungen-card">
                <h3>Lehrkraftdaten bearbeiten</h3>
                <div class="form-grid">
                  <label class="field">
                    <span>Kuerzel</span>
                    <input v-model="formen.lehrer.kuerzel" type="text" />
                  </label>
                  <label class="field">
                    <span>Anrede</span>
                    <input v-model="formen.lehrer.anrede" type="text" />
                  </label>
                  <label class="field">
                    <span>Vorname</span>
                    <input v-model="formen.lehrer.vorname" type="text" />
                  </label>
                  <label class="field">
                    <span>Nachname</span>
                    <input v-model="formen.lehrer.nachname" type="text" />
                  </label>
                  <label class="field field-wide">
                    <span>Anzeigename</span>
                    <input v-model="formen.lehrer.anzeigename" type="text" />
                  </label>
                  <label class="field">
                    <span>Barcode</span>
                    <input v-model="formen.lehrer.barcode" type="text" />
                  </label>
                  <label class="field">
                    <span>E-Mail</span>
                    <input v-model="formen.lehrer.email" type="email" />
                  </label>
                  <label class="field">
                    <span>Fachbereich</span>
                    <input v-model="formen.lehrer.fachbereich" type="text" />
                  </label>
                  <label class="field">
                    <span>Aktiv</span>
                    <select v-model="formen.lehrer.aktiv">
                      <option :value="true">ja</option>
                      <option :value="false">nein</option>
                    </select>
                  </label>
                  <label class="field field-wide">
                    <span>Notizen</span>
                    <textarea v-model="formen.lehrer.notizen" rows="4"></textarea>
                  </label>
                </div>
              </article>
            </div>
            <div class="button-row" style="margin-top: 20px; display: flex; gap: 10px;">
              <button class="ghost" @click="zeigeLehrerFormular = false">Abbrechen</button>
              <button class="primary" @click="speichereDatensatz(); zeigeLehrerFormular = false;">Aenderungen speichern</button>
            </div>
          </div>
        </div>
        
        <div v-else-if="!zeigeLehrerFormular && !zeigeLehrerImport" style="margin-top: 22px;">
          <div style="display: flex; gap: 10px; margin-bottom: 15px; align-items: center; justify-content: space-between;">
            <div style="display: flex; gap: 10px; align-items: center;">
              <span class="subtle">Filtern nach:</span>
              <select v-model="lehrerFilterSpalte" style="padding: 0 12px; height: 38px; box-sizing: border-box; border-radius: 8px; border: 1px solid rgba(36, 52, 71, 0.2); background: white; font-size: 0.9rem; cursor: pointer;">
                <option value="nachname">Nachname</option>
                <option value="vorname">Vorname</option>
                <option value="kuerzel">Kürzel</option>
                <option value="fachbereich">Fachbereich</option>
              </select>
              <div class="scanner-input-wrap" style="flex: 1; max-width: 300px;">
                <input 
                  v-model="lehrerFilterText" 
                  type="text" 
                  placeholder="Suchen..." 
                  style="padding: 0 12px; padding-right: 32px; height: 38px; box-sizing: border-box; border-radius: 8px; border: 1px solid rgba(36, 52, 71, 0.2); width: 100%; font-size: 0.9rem;" 
                />
                <button
                  v-if="lehrerFilterText"
                  type="button"
                  class="scanner-clear-button"
                  aria-label="Filter zurücksetzen"
                  @click="lehrerFilterText = ''"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <line x1="18" y1="6" x2="6" y2="18"/>
                    <line x1="6" y1="6" x2="18" y2="18"/>
                  </svg>
                </button>
              </div>
            </div>
            <label style="display: flex; align-items: center; gap: 6px; font-size: 0.9rem; color: #243447; cursor: pointer;">
              <input type="checkbox" v-model="zeigeInaktiveLehrer" />
              Inaktive einblenden
            </label>
          </div>
          
          <div style="max-height: 700px; overflow-y: auto; border: 1px solid rgba(36, 52, 71, 0.1); border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
            <table class="data-table" style="width: 100%; border-collapse: collapse; background: white;">
              <thead style="position: sticky; top: 0; z-index: 10; background: #f4f6f8;">
                <tr style="text-align: left;">
                  <th style="padding: 6px 8px; width: 40px; border-bottom: 2px solid rgba(36, 52, 71, 0.1);"></th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">ID</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Name</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Kürzel</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Barcode</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Fachbereich</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Aktive Ausleihen</th>
                  <th style="padding: 6px 8px; font-size: 0.9rem; border-bottom: 2px solid rgba(36, 52, 71, 0.1);">Aktiv</th>
                  <th style="padding: 6px 8px; width: 40px; border-bottom: 2px solid rgba(36, 52, 71, 0.1);"></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="lehrer in gefilterteLehrer" :key="lehrer.id" class="schueler-row" style="border-bottom: 1px solid rgba(36, 52, 71, 0.05); transition: background-color 150ms ease;">
                  <td style="padding: 4px 8px; text-align: center;">
                    <button type="button" @click="bearbeiteLehrer(lehrer)" style="background: none; border: none; cursor: pointer; padding: 2px; display: inline-flex; align-items: center; justify-content: center;" title="Bearbeiten">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#1f4d6b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                        <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                      </svg>
                    </button>
                  </td>
                  <td style="padding: 4px 8px; font-size: 0.9rem; color: rgba(36, 52, 71, 0.65);">{{ lehrer.id }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ lehrer.anzeigename }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ lehrer.kuerzel }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem; color: rgba(36, 52, 71, 0.65);">{{ lehrer.barcode || '-' }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">{{ lehrer.fachbereich }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem; text-align: center;">{{ lehrer.aktive_ausleihen || 0 }}</td>
                  <td style="padding: 4px 8px; font-size: 0.9rem;">
                    <span v-if="lehrer.aktiv" style="color: #27ae60;">Ja</span>
                    <span v-else style="color: #e74c3c;">Nein</span>
                  </td>
                  <td style="padding: 4px 8px; text-align: center;">
                    <button type="button" @click="entferneLehrer(lehrer)" style="background: none; border: none; cursor: pointer; padding: 2px; display: inline-flex; align-items: center; justify-content: center;" title="Löschen">
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e74c3c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="3 6 5 6 21 6"></polyline>
                        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                      </svg>
                    </button>
                  </td>
                </tr>
                <tr v-if="gefilterteLehrer.length === 0">
                  <td colspan="9" style="padding: 16px; text-align: center; color: rgba(36, 52, 71, 0.5);">Keine Lehrkräfte gefunden.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'buecher'">
        <div class="einstellungen-editor-layout">
          <aside class="einstellungen-records">
            <div class="einstellungen-records-head">
              <strong>{{ aktiveListe.length }} Eintraege</strong>
              <span class="subtle">bearbeitbar</span>
            </div>

            <button
              v-for="eintrag in aktiveListe"
              :key="`${aktiverBereich}-${eintrag.id}`"
              type="button"
              :class="['einstellungen-record', aktiveAuswahl === eintrag.id ? 'is-active' : '']"
              @click="setzeAuswahl(aktiverBereich, eintrag)"
            >
              <span class="einstellungen-record-title">{{ datensatzTitel(eintrag) }}</span>
              <span class="einstellungen-record-copy">{{ datensatzUntertitel(eintrag) || 'Kein Zusatztext' }}</span>
            </button>
          </aside>

          <div class="einstellungen-form-panel">
            <div class="einstellungen-stack">
              <article class="einstellungen-card">
                <h3>Buchdetails</h3>
                <div class="form-grid">
                  <label class="field field-wide">
                    <span>Titel</span>
                    <input v-model="formen.buecher.titel" type="text" />
                  </label>
                  <label class="field">
                    <span>EAN / ISBN-13 (Titelcode)</span>
                    <input v-model="formen.buecher.titelcode" type="text" />
                  </label>
                  <label class="field">
                    <span>Autor</span>
                    <input v-model="formen.buecher.autor" type="text" />
                  </label>
                  <label class="field">
                    <span>Verlag</span>
                    <input v-model="formen.buecher.verlag" type="text" />
                  </label>
                  <label class="field">
                    <span>Fach</span>
                    <select v-model="formen.buecher.fach_id">
                      <option :value="null">- bitte waehlen -</option>
                      <option v-for="fach in listen.faecher" :key="fach.id" :value="fach.id">
                        {{ fach.bezeichnung }}
                      </option>
                    </select>
                  </label>
                  <label class="field">
                    <span>Veroeffentlicht</span>
                    <input v-model="formen.buecher.veroeffentlicht" type="text" placeholder="z. B. 2020" />
                  </label>
                  <label class="field">
                    <span>Jahrgangsstufe</span>
                    <input v-model="formen.buecher.jahrgangsstufe" type="text" placeholder="z. B. 7" />
                  </label>
                  <label class="field">
                    <span>Schuljahr-Ausgabe</span>
                    <input v-model="formen.buecher.schuljahr_ausgabe" type="text" placeholder="z. B. 2023/2024" />
                  </label>
                  <label class="field">
                    <span>Herkunft</span>
                    <select v-model="formen.buecher.herkunft_id">
                      <option :value="null">- bitte waehlen -</option>
                      <option v-for="h in listen.herkunft" :key="h.id" :value="h.id">
                        {{ h.bezeichnung }}
                      </option>
                    </select>
                  </label>
                  <label class="field field-wide">
                    <span>Cover-URL</span>
                    <input v-model="formen.buecher.cover_url" type="url" placeholder="https://..." />
                  </label>
                  <label class="field field-wide">
                    <span>Cover-Bild hochladen</span>
                    <div class="cover-upload-row">
                      <img v-if="buchCoverVorschau" :src="buchCoverVorschau" alt="Cover-Vorschau" class="cover-vorschau" />
                      <input type="file" accept="image/*" @change="buchCoverAuswaehlen" />
                    </div>
                  </label>
                  <label class="field">
                    <span>Arbeitsheft</span>
                    <select v-model="formen.buecher.ist_arbeitsheft">
                      <option :value="false">nein</option>
                      <option :value="true">ja</option>
                    </select>
                  </label>
                  <label class="field">
                    <span>Lehrerversion</span>
                    <select v-model="formen.buecher.ist_lehrerversion">
                      <option :value="false">nein</option>
                      <option :value="true">ja</option>
                    </select>
                  </label>
                </div>
              </article>
            </div>

            <div class="button-row">
              <button class="primary" @click="speichereDatensatz">Aenderungen speichern</button>
            </div>
          </div>
        </div>
      </template>

      <template v-else-if="aktiverBereich === 'vertragsvorlagen'">
        <VertragsvorlagenAdmin :api-request="apiRequest" />
      </template>

      <template v-else>
        <div class="einstellungen-stack" style="margin-top: 22px;">
          <article class="einstellungen-card" v-if="aktiverBereich === 'benutzer'">
            <h3>Benutzer</h3>
            <div class="form-grid">
              <label class="field">
                <span>Standardrolle</span>
                <select v-model="formen.benutzer.rolleStandard">
                  <option value="verwaltung">Verwaltung</option>
                  <option value="bibliothek">Bibliothek</option>
                  <option value="support">Support</option>
                </select>
              </label>
              <label class="field">
                <span>Scanner-Fokus beim Start</span>
                <select v-model="formen.benutzer.scannerFokusBeimStart">
                  <option :value="true">aktiv</option>
                  <option :value="false">inaktiv</option>
                </select>
              </label>
              <label class="field field-wide">
                <span>Erfolgsmeldungen automatisch ausblenden</span>
                <select v-model="formen.benutzer.erfolgsmeldungenAutomatischAusblenden">
                  <option :value="true">ja</option>
                  <option :value="false">nein</option>
                </select>
              </label>
            </div>
          </article>

          <article class="einstellungen-card" v-else-if="aktiverBereich === 'geraete'">
            <h3>Geraete</h3>
            <div class="form-grid">
              <label class="field">
                <span>Inventar-Praefix</span>
                <input v-model="formen.geraete.inventarPraefix" type="text" />
              </label>
              <label class="field">
                <span>Barcode-Praefix</span>
                <input v-model="formen.geraete.barcodePraefix" type="text" />
              </label>
              <label class="field">
                <span>Standardstatus</span>
                <select v-model="formen.geraete.standardStatus">
                  <option value="verfuegbar">verfuegbar</option>
                  <option value="reserviert">reserviert</option>
                  <option value="defekt">defekt</option>
                </select>
              </label>
              <label class="field">
                <span>Seriennummer Pflicht</span>
                <select v-model="formen.geraete.seriennummerPflicht">
                  <option :value="true">ja</option>
                  <option :value="false">nein</option>
                </select>
              </label>
            </div>
          </article>

          <article class="einstellungen-card" v-else-if="aktiverBereich === 'artikel'">
            <h3>Artikel</h3>
            <p class="einstellungen-intro">Verwaltung der Artikelstammdaten ist noch in Arbeit.</p>
          </article>

          <article class="einstellungen-card" v-else-if="aktiverBereich === 'inventar_typen'">
            <h3>Inventar-Typen</h3>
            <p class="einstellungen-intro">Verwaltung der Inventar-Typen ist noch in Arbeit.</p>
          </article>

          <article class="einstellungen-card" v-else-if="aktiverBereich === 'statuskatalog'">
            <h3>Statuskatalog</h3>
            <p class="einstellungen-intro">Verwaltung des Statuskatalogs ist noch in Arbeit.</p>
          </article>

          <article class="einstellungen-card" v-else-if="aktiverBereich === 'zustandskatalog'">
            <h3>Zustandskatalog</h3>
            <p class="einstellungen-intro">Verwaltung des Zustandskatalogs ist noch in Arbeit.</p>
          </article>

          <article class="einstellungen-card" v-else-if="aktiverBereich === 'standorte'">
            <h3>Standorte</h3>
            <p class="einstellungen-intro">Verwaltung der Standorte ist noch in Arbeit.</p>
          </article>

          <article class="einstellungen-card" v-else>
            <h3>Buecher</h3>
            <div class="form-grid">
              <label class="field">
                <span>Inventar-Praefix</span>
                <input v-model="formen.buecher.inventarPraefix" type="text" />
              </label>
              <label class="field">
                <span>Barcode-Praefix</span>
                <input v-model="formen.buecher.barcodePraefix" type="text" />
              </label>
              <label class="field">
                <span>Online-Suche aktiv</span>
                <select v-model="formen.buecher.onlineSucheAktiv">
                  <option :value="true">ja</option>
                  <option :value="false">nein</option>
                </select>
              </label>
              <label class="field">
                <span>Standardanzahl neuer Exemplare</span>
                <input v-model="formen.buecher.standardAnzahl" type="number" min="1" />
              </label>
            </div>
          </article>

          <div class="button-row">
            <button class="primary" @click="speichereSystembereich">Aenderungen speichern</button>
          </div>
        </div>
      </template>
    </section>
  </section>
</template>

<style scoped>
.einstellungen-layout {
  display: grid;
  grid-template-columns: minmax(260px, 320px) minmax(0, 1fr);
  gap: 20px;
  align-items: start;
}

.einstellungen-nav-panel,
.einstellungen-detail-panel {
  min-height: 720px;
}

.einstellungen-nav-panel {
  position: sticky;
  top: 24px;
  max-height: calc(100vh - 48px);
  display: flex;
  flex-direction: column;
}

.einstellungen-eyebrow {
  margin-bottom: 10px;
}

.einstellungen-intro {
  margin: 10px 0 0;
  color: rgba(36, 52, 71, 0.72);
}

.einstellungen-nav {
  margin-top: 22px;
  display: grid;
  gap: 6px;
  overflow-y: auto;
}

.einstellungen-nav-divider {
  border: none;
  border-top: 2px solid rgba(36, 52, 71, 0.14);
  margin-top: 10px;
}

.einstellungen-nav-divider + .einstellungen-link {
  margin-top: 10px;
}

.einstellungen-link {
  text-align: left;
  padding: 8px 14px;
  border-radius: 12px;
  background: rgba(36, 52, 71, 0.05);
  border: 1px solid transparent;
  display: grid;
  gap: 2px;
  transition: background 160ms ease, border-color 160ms ease, transform 160ms ease;
}

.einstellungen-link:hover {
  transform: translateY(-1px);
  background: rgba(36, 52, 71, 0.08);
}

.einstellungen-link.is-active {
  background: linear-gradient(180deg, rgba(42, 157, 143, 0.16), rgba(42, 157, 143, 0.08));
  border-color: rgba(42, 157, 143, 0.24);
}

.einstellungen-link.is-katalog {
  background: rgba(42, 157, 143, 0.15);
}

.einstellungen-link.is-katalog:hover {
  background: rgba(42, 157, 143, 0.22);
}

.einstellungen-link.is-katalog.is-active {
  background: linear-gradient(180deg, rgba(42, 157, 143, 0.32), rgba(42, 157, 143, 0.20));
  border-color: rgba(42, 157, 143, 0.40);
}

.einstellungen-link-title {
  font-weight: 700;
  color: #17324a;
}

.einstellungen-link-copy {
  font-size: 0.88rem;
  color: rgba(36, 52, 71, 0.68);
}

.einstellungen-detail-head {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  align-items: flex-start;
  padding-bottom: 18px;
  border-bottom: 1px solid rgba(36, 52, 71, 0.08);
}

.status-pill {
  white-space: nowrap;
  padding: 8px 12px;
  border-radius: 999px;
  background: rgba(244, 162, 97, 0.14);
  color: #9a5a16;
  font-weight: 700;
  font-size: 0.84rem;
}

.einstellungen-editor-layout {
  display: grid;
  grid-template-columns: minmax(240px, 300px) minmax(0, 1fr);
  gap: 20px;
  margin-top: 22px;
}

.einstellungen-records {
  border-right: 1px solid rgba(36, 52, 71, 0.08);
  padding-right: 18px;
  display: grid;
  gap: 10px;
  align-content: start;
  max-height: 780px;
  overflow: auto;
}

.einstellungen-records-head {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 4px 6px;
}

.einstellungen-record {
  text-align: left;
  padding: 12px 14px;
  border-radius: 18px;
  background: rgba(36, 52, 71, 0.05);
  display: grid;
  gap: 3px;
  transition: background 160ms ease, transform 160ms ease;
}

.einstellungen-record:hover {
  transform: translateY(-1px);
  background: rgba(36, 52, 71, 0.08);
}

.einstellungen-record.is-active {
  background: linear-gradient(180deg, rgba(31, 77, 107, 0.16), rgba(31, 77, 107, 0.08));
}

.einstellungen-record-title {
  font-weight: 700;
  color: #17324a;
}

.einstellungen-record-copy {
  font-size: 0.84rem;
  color: rgba(36, 52, 71, 0.65);
}

.einstellungen-form-panel {
  min-width: 0;
}

.einstellungen-stack {
  display: grid;
  gap: 18px;
}

.einstellungen-card {
  border: 1px solid rgba(36, 52, 71, 0.08);
  border-radius: 22px;
  padding: 20px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.92), rgba(245, 250, 252, 0.9));
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.8);
}

.einstellungen-card h3 {
  margin: 0 0 14px;
}

.svws-section-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
  flex-wrap: wrap;
}

.svws-section-head h3 {
  margin: 0;
}

.svws-db-badge {
  padding: 8px 12px;
  border-radius: 999px;
  border: 1px solid rgba(157, 44, 48, 0.22);
  background: rgba(157, 44, 48, 0.08);
  color: #9d2c30;
  font-size: 0.82rem;
  font-weight: 700;
  transition: background 160ms ease, color 160ms ease, border-color 160ms ease, box-shadow 160ms ease;
}

.svws-db-badge.is-active {
  border-color: rgba(42, 127, 98, 0.24);
  background: rgba(42, 127, 98, 0.14);
  color: #1f6b52;
  box-shadow: 0 8px 18px rgba(42, 127, 98, 0.12);
}

.svws-button-row {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  margin-top: 18px;
}

.svws-button {
  min-width: 190px;
  padding: 12px 18px;
  border-radius: 12px;
  border: 1px solid transparent;
  font-size: 0.95rem;
  font-weight: 700;
  cursor: pointer;
  transition: transform 160ms ease, box-shadow 160ms ease, border-color 160ms ease, background 160ms ease;
}

.svws-button:hover {
  transform: translateY(-1px);
}

.svws-button:disabled {
  cursor: wait;
  opacity: 0.72;
  transform: none;
}

.svws-button-secondary {
  background: linear-gradient(180deg, #ffffff, #eef5f8);
  border-color: rgba(31, 77, 107, 0.18);
  color: #1f4d6b;
  box-shadow: 0 10px 22px rgba(31, 77, 107, 0.08);
}

.svws-button-secondary:hover {
  box-shadow: 0 14px 28px rgba(31, 77, 107, 0.12);
}

.svws-button-primary {
  background: linear-gradient(135deg, #1f4d6b, #2a7f62);
  color: #ffffff;
  box-shadow: 0 14px 28px rgba(31, 77, 107, 0.18);
}

.svws-button-primary:hover {
  box-shadow: 0 18px 34px rgba(31, 77, 107, 0.24);
}

.field-aktiv-hinweis {
  padding: 12px 14px;
  border-radius: 16px;
  border: 1px solid rgba(42, 127, 98, 0.18);
  background: linear-gradient(180deg, rgba(42, 127, 98, 0.08), rgba(42, 127, 98, 0.03));
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.7);
}

.field-aktiv-hinweis span {
  color: #1f6b52;
  font-weight: 700;
}

@media (max-width: 1100px) {
  .einstellungen-layout,
  .einstellungen-editor-layout {
    grid-template-columns: 1fr;
  }

  .einstellungen-nav-panel {
    position: static;
    min-height: auto;
  }

  .einstellungen-detail-panel {
    min-height: auto;
  }

  .einstellungen-records {
    border-right: 0;
    border-bottom: 1px solid rgba(36, 52, 71, 0.08);
    padding-right: 0;
    padding-bottom: 18px;
    max-height: none;
  }

  .svws-button {
    width: 100%;
  }
}

.cover-upload-row {
  display: flex;
  align-items: flex-start;
  gap: 14px;
}

.cover-vorschau {
  max-width: 80px;
  max-height: 110px;
  object-fit: contain;
  border-radius: 6px;
  border: 1px solid rgba(36, 52, 71, 0.12);
  flex-shrink: 0;
}

.schueler-row:hover {
  background-color: rgba(31, 77, 107, 0.1);
}
</style>
