<script setup>
import { ref, computed, watch } from "vue";
import * as XLSX from "xlsx";
import AusgabeAssistentModule from "../components/AusgabeAssistentModule.vue";
import StornoAssistentModule from "../components/StornoAssistentModule.vue";

const props = defineProps({
  inventarGeoeffnet: { type: Boolean, required: true },
  geraeteGefiltert: { type: Array, required: true },
  geraeteSuche: { type: String, required: true },
  geraeteAlleAusgewaehlt: { type: Boolean, required: true },
  geraeteAusgewaehlt: { type: Object, required: true },
  laedtDaten: { type: Boolean, required: true },
  artikel: { type: Array, required: true },
  offeneAusleihen: { type: Array, required: true },
  inventarTypen: { type: Array, required: true },
  artikelKategorien: { type: Array, required: true },
  exemplare: { type: Array, required: true },
  ausgewaehltesExemplar: { type: Object, required: false, default: null },
  ausgewaehltesBuch: { type: Object, required: false, default: null },
  ausgewaehltesExemplarId: { type: [String, Number], required: true },
  exemplarForm: { type: Object, required: true },
  objektHistorie: { type: Array, required: true },
  objektHistorieSeite: { type: Number, required: false, default: 1 },
  objektHistorieGesamt: { type: Number, required: false, default: 0 },
  objektHistorieLimit: { type: Number, required: false, default: 10 },
  formatDatum: { type: Function, required: true },
  faecher: { type: Array, required: true },
  herkunft: { type: Array, required: true },
  standorte: { type: Array, required: true },
  apiRequest: { type: Function, required: true },
  externerBuchTitelcode: { type: String, required: false, default: "" }
});

const emit = defineEmits([
  "toggle-inventar-geoeffnet",
  "update:geraete-suche",
  "update:geraete-alle-ausgewaehlt",
  "toggle-geraet-auswahl",
  "bearbeite-geraet",
  "geraete-auswahl-loeschen-anfragen",
  "update:ausgewaehltes-exemplar-id",
  "waehle-exemplar",
  "exemplar-speichern",
  "historie-seite-wechseln",
  "zeige-erfolg",
  "zeige-fehler",
  "zeige-scanner-status",
  "lade-daten",
  "update:externer-buch-titelcode"
]);

const objekthistorieGeoeffnet = ref(false);

const importDateien = ref({
  schueler: null,
  lehrer: null,
  buecher: null,
  artikel: null
});
const artikelForm = ref({
  id: null,
  inventar_typ_id: "",
  titel: "",
  interne_bezeichnung: "",
  beschreibung: "",
  hersteller: "",
  modellbezeichnung: "",
  herkunft_id: "",
  artikel_kategorie_id: "",
  aktiv: true
});
const artikelImportZeilen = ref([]);
const artikelImportDateiname = ref("");
const artikelImportArtikelId = ref("");
const artikelImportPraefix = ref("");

const aktiverMedienBereich = ref('inventar');
const medienBereiche = [
  { id: 'inventar', label: 'Inventar', beschreibung: 'Vollstaendige Liste aller Exemplare.' },
  { id: 'ausgabe-assistent', label: 'Ausgabe-Assistent', beschreibung: 'Viele gleichartige Artikel an eine Klasse verteilen.' },
  { id: 'storno-assistent', label: 'Storno-Assistent', beschreibung: 'Offene Buchungen eines Artikels klassenweise aufheben.' },
  { id: 'artikelverwaltung', label: 'Artikel verwalten', beschreibung: 'Hardware und sonstige Artikel separat pflegen.' },
  { id: 'artikel-exemplare-import', label: 'Artikel Exemplare importieren', beschreibung: 'Seriennummern fuer Artikel-Exemplare importieren.' },
  { id: 'lehrbuch', label: 'Lehrbuch hinzufuegen', beschreibung: 'Buecher per EAN / ISBN-13 erfassen.' },
  { id: 'titelerkennung', label: 'Titelerkennung', beschreibung: 'Gefundene Buchdetails ansehen.' },
  { id: 'objektpflege', label: 'Objektpflege', beschreibung: 'Exemplar bearbeiten und Historie einsehen.' },
  { id: 'import-export', label: 'Import', beschreibung: 'Daten aus CSV-Dateien importieren.' },
  { id: 'export', label: 'Export', beschreibung: 'Daten als CSV-Dateien exportieren.' },
];
const artikelVerwaltungEintraege = computed(() => {
  const suchtext = props.geraeteSuche.trim().toLowerCase();

  return props.artikel.filter((eintrag) => {
    if (!suchtext) {
      return true;
    }

    return (
      String(eintrag.id || "").toLowerCase().includes(suchtext) ||
      String(eintrag.titel || "").toLowerCase().includes(suchtext) ||
      String(eintrag.interne_bezeichnung || "").toLowerCase().includes(suchtext) ||
      String(eintrag.inventar_typ || "").toLowerCase().includes(suchtext) ||
      String(eintrag.hersteller || "").toLowerCase().includes(suchtext) ||
      String(eintrag.modellbezeichnung || "").toLowerCase().includes(suchtext) ||
      String(eintrag.artikel_kategorie || "").toLowerCase().includes(suchtext) ||
      String(eintrag.herkunft || "").toLowerCase().includes(suchtext)
    );
  });
});

function kuerzeText(wert, maxLaenge = 18) {
  const text = String(wert || "");
  if (text.length <= maxLaenge) {
    return text;
  }

  return `${text.slice(0, maxLaenge - 1)}…`;
}
function setzeArtikelForm(artikel = null) {
  artikelForm.value = {
    id: artikel?.id ?? null,
    inventar_typ_id: artikel?.inventar_typ_id ?? "",
    titel: artikel?.titel ?? "",
    interne_bezeichnung: artikel?.interne_bezeichnung ?? "",
    beschreibung: artikel?.beschreibung ?? "",
    hersteller: artikel?.hersteller ?? "",
    modellbezeichnung: artikel?.modellbezeichnung ?? "",
    herkunft_id: artikel?.herkunft_id ?? "",
    artikel_kategorie_id: artikel?.artikel_kategorie_id ?? "",
    aktiv: artikel?.aktiv ?? true
  };
}

function artikelZurBearbeitungOeffnen(artikel) {
  setzeArtikelForm(artikel);
  aktiverMedienBereich.value = "artikelbearbeitung";
}

function artikelBearbeitungAbbrechen() {
  setzeArtikelForm();
  aktiverMedienBereich.value = "artikelverwaltung";
}

const artikelImportBereit = computed(() =>
  Boolean(
    artikelImportPraefix.value.trim() &&
    artikelImportZeilen.value.length > 0 &&
    artikelImportZeilen.value.every((eintrag) => eintrag.artikel_id && eintrag.seriennummer)
  )
);

const artikelImportAuswahlText = computed(() => {
  const artikelId = Number(artikelImportArtikelId.value);
  if (!artikelId) {
    return "- bitte waehlen -";
  }

  return props.artikel.find((eintrag) => Number(eintrag.id) === artikelId)?.titel || "- bitte waehlen -";
});

function berechneImportInventarnummer(index) {
  const praefix = artikelImportPraefix.value.trim().replace(/-+$/, "");
  if (!praefix) {
    return "-";
  }

  return `${praefix}-${String(index + 1).padStart(4, "0")}`;
}

function uebernehmeImportArtikelFuerAlle() {
  if (!artikelImportArtikelId.value) {
    return;
  }

  artikelImportZeilen.value = artikelImportZeilen.value.map((eintrag) => ({
    ...eintrag,
    artikel_id: artikelImportArtikelId.value
  }));
}

watch(artikelImportArtikelId, (neuerWert) => {
  artikelImportZeilen.value = artikelImportZeilen.value.map((eintrag) => ({
    ...eintrag,
    artikel_id: neuerWert || ""
  }));
});

async function artikelExemplareDateiEinlesen(event) {
  const datei = event.target.files?.[0];
  importDateien.value.artikel = datei || null;
  artikelImportDateiname.value = datei?.name || "";

  if (!datei) {
    artikelImportZeilen.value = [];
    return;
  }

  try {
    const zeilenRohdaten = datei.name.toLowerCase().endsWith(".xlsx")
      ? await leseSeriennummernAusXlsx(datei)
      : await leseSeriennummernAusText(datei);

    const zeilen = zeilenRohdaten.map((seriennummer, index) => ({
        id: `${datei.name}-${index + 1}`,
        zeile: index + 1,
        seriennummer,
        barcode: seriennummer,
        artikel_id: artikelImportArtikelId.value || ""
      }));

    artikelImportZeilen.value = zeilen;
    emit("zeige-fehler", "");
    if (zeilen.length === 0) {
      emit("zeige-fehler", "Die Datei enthaelt keine importierbaren Seriennummern.");
    }
  } catch (error) {
    artikelImportZeilen.value = [];
    emit("zeige-fehler", error.message || "Die Datei konnte nicht gelesen werden.");
  } finally {
    event.target.value = "";
  }
}

async function leseSeriennummernAusText(datei) {
  const text = await datei.text();
  const zeilen = text
    .split(/\r?\n/)
    .map((zeile) => zeile.trim())
    .filter(Boolean)
    .map((zeile) => {
      const ersteSpalte = zeile.split(/[;,]/)[0]?.trim();
      return ersteSpalte || zeile;
    });

  return entferneSeriennummerKopfzeile(zeilen);
}

async function leseSeriennummernAusXlsx(datei) {
  const buffer = await datei.arrayBuffer();
  const workbook = XLSX.read(buffer, { type: "array" });
  const erstesBlatt = workbook.SheetNames[0];

  if (!erstesBlatt) {
    return [];
  }

  const worksheet = workbook.Sheets[erstesBlatt];
  const zeilen = XLSX.utils.sheet_to_json(worksheet, { header: 1, raw: false });
  const spaltenIndex = findeErsteGefuellteSpalte(zeilen);

  if (spaltenIndex === -1) {
    return [];
  }

  const seriennummern = zeilen
    .map((zeile) => String(zeile?.[spaltenIndex] || "").trim())
    .filter(Boolean);

  return entferneSeriennummerKopfzeile(seriennummern);
}

function findeErsteGefuellteSpalte(zeilen) {
  let maxSpalten = 0;

  zeilen.forEach((zeile) => {
    if (Array.isArray(zeile)) {
      maxSpalten = Math.max(maxSpalten, zeile.length);
    }
  });

  for (let index = 0; index < maxSpalten; index += 1) {
    const hatWerte = zeilen.some((zeile) => String(zeile?.[index] || "").trim());
    if (hatWerte) {
      return index;
    }
  }

  return -1;
}

function entferneSeriennummerKopfzeile(werte) {
  if (werte.length === 0) {
    return werte;
  }

  const ersterWert = String(werte[0] || "").trim().toLowerCase();
  if (["seriennummer", "serial", "serialnumber", "sn"].includes(ersterWert)) {
    return werte.slice(1);
  }

  return werte;
}

async function artikelExemplareImportieren() {
  if (!artikelImportBereit.value) {
    emit("zeige-fehler", "Bitte Datei laden, Inventarnummer-Praefix setzen und alle Exemplare einem Artikel zuordnen.");
    return;
  }

  emit("zeige-fehler", "");
  emit("zeige-erfolg", "");

  try {
    const response = await props.apiRequest("/artikel-exemplare/import", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        inventarnummer_praefix: artikelImportPraefix.value.trim(),
        exemplare: artikelImportZeilen.value.map((eintrag) => ({
          artikel_id: eintrag.artikel_id,
          seriennummer: eintrag.seriennummer
        }))
      })
    });

    emit("zeige-erfolg", response.meldung);
    artikelImportZeilen.value = [];
    artikelImportDateiname.value = "";
    artikelImportArtikelId.value = "";
    artikelImportPraefix.value = "";
    importDateien.value.artikel = null;
    emit("lade-daten");
  } catch (error) {
    emit("zeige-fehler", error.message);
  }
}

async function artikelSpeichern() {
  if (!artikelForm.value.id) {
    emit("zeige-fehler", "Kein Artikel zum Bearbeiten ausgewaehlt.");
    return;
  }

  emit("zeige-fehler", "");
  emit("zeige-erfolg", "");

  try {
    const response = await props.apiRequest(`/artikel/${artikelForm.value.id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        inventar_typ_id: artikelForm.value.inventar_typ_id || null,
        titel: artikelForm.value.titel,
        interne_bezeichnung: artikelForm.value.interne_bezeichnung || null,
        beschreibung: artikelForm.value.beschreibung || null,
        hersteller: artikelForm.value.hersteller || null,
        modellbezeichnung: artikelForm.value.modellbezeichnung || null,
        herkunft_id: artikelForm.value.herkunft_id || null,
        artikel_kategorie_id: artikelForm.value.artikel_kategorie_id || null,
        aktiv: artikelForm.value.aktiv
      })
    });

    emit("zeige-erfolg", response.meldung);
    emit("lade-daten");
    aktiverMedienBereich.value = "artikelverwaltung";
  } catch (error) {
    emit("zeige-fehler", error.message);
  }
}

const buchImportForm = ref({
  titelcode: "",
  artikel_id: "",
  titel: "",
  autor: "",
  fach_id: null,
  verlag: "",
  veroeffentlicht: "",
  jahrgangsstufe: "",
  ist_arbeitsheft: false,
  ist_lehrerversion: false,
  herkunft_id: null,
  klassensatz_name: "",
  anzahl: 1,
  standort_id: "",
  zustand: "sehr_gut",
  anschaffungsdatum: "",
  kaufpreis: "",
  notizen: ""
});
const gefundenesBuch = ref(null);
const buchCoverBild = ref("");
const buchFeldHighlights = ref({
  titel: false,
  autor: false,
  verlag: false,
  veroeffentlicht: false,
  jahrgangsstufe: false
});
const buchFeldHighlightTimer = {};

const gefundenesBuchJson = computed(() =>
  gefundenesBuch.value ? JSON.stringify(gefundenesBuch.value, null, 2) : ""
);

watch(() => props.externerBuchTitelcode, async (newVal) => {
  if (newVal) {
    buchImportForm.value.titelcode = newVal;
    aktiverMedienBereich.value = 'lehrbuch';
    await buchTitelNachschlagen();
    emit("update:externer-buch-titelcode", "");
  }
}, { immediate: true });

function buchSuchfelderZuruecksetzen() {
  buchImportForm.value.artikel_id = "";
  buchImportForm.value.titel = "";
  buchImportForm.value.autor = "";
  buchImportForm.value.fach_id = null;
  buchImportForm.value.verlag = "";
  buchImportForm.value.veroeffentlicht = "";
  buchImportForm.value.jahrgangsstufe = "";
  buchImportForm.value.ist_arbeitsheft = false;
  buchImportForm.value.ist_lehrerversion = false;
  buchImportForm.value.herkunft_id = null;
  buchImportForm.value.klassensatz_name = "";
  gefundenesBuch.value = null;
  buchCoverBild.value = "";
}

async function buchCoverDateiAuswaehlen(event) {
  const datei = event.target.files?.[0];

  if (!datei) {
    return;
  }

  if (!datei.type.startsWith("image/")) {
    emit("zeige-fehler", "Bitte eine Bilddatei fuer das Buchcover auswaehlen.");
    event.target.value = "";
    return;
  }

  if (datei.size > 2.5 * 1024 * 1024) {
    emit("zeige-fehler", "Das Buchcover ist zu gross. Bitte ein Bild bis maximal 2,5 MB auswaehlen.");
    event.target.value = "";
    return;
  }

  emit("zeige-fehler", "");

  const datenUrl = await new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => resolve(String(reader.result || ""));
    reader.onerror = () => reject(new Error("Das Buchcover konnte nicht gelesen werden."));
    reader.readAsDataURL(datei);
  });

  buchCoverBild.value = datenUrl;

  if (gefundenesBuch.value) {
    gefundenesBuch.value = {
      ...gefundenesBuch.value,
      cover_bild: datenUrl
    };
  }

  event.target.value = "";
}

function markiereBuchfeld(...feldNamen) {
  feldNamen.forEach((feldName) => {
    if (!(feldName in buchFeldHighlights.value)) {
      return;
    }

    buchFeldHighlights.value[feldName] = false;

    if (buchFeldHighlightTimer[feldName]) {
      clearTimeout(buchFeldHighlightTimer[feldName]);
    }

    setTimeout(() => {
      buchFeldHighlights.value[feldName] = true;
      buchFeldHighlightTimer[feldName] = setTimeout(() => {
        buchFeldHighlights.value[feldName] = false;
      }, 1400);
    }, 10);
  });
}

async function buchTitelNachschlagen() {
  const titelcode = buchImportForm.value.titelcode.trim();

  if (!titelcode) {
    emit("zeige-fehler", "Bitte zuerst einen Titelcode eingeben.");
    return;
  }

  emit("zeige-fehler", "");
  buchSuchfelderZuruecksetzen();

  try {
    const buch = await props.apiRequest(`/buecher/titelcode/${encodeURIComponent(titelcode)}`);
    gefundenesBuch.value = buch;
    buchCoverBild.value = buch.cover_bild || "";
    buchImportForm.value.artikel_id = buch.artikel_id;

    if (!buchImportForm.value.klassensatz_name && buch.klassensatz_namen?.length) {
      buchImportForm.value.klassensatz_name = buch.klassensatz_namen[0];
    }

    buchImportForm.value.fach_id = buch.fach_id || null;
    buchImportForm.value.autor = buch.autor || "";
    buchImportForm.value.verlag = buch.verlag || "";
    buchImportForm.value.titel = buch.titel || "";
    buchImportForm.value.veroeffentlicht = buch.veroeffentlicht || "";
    buchImportForm.value.jahrgangsstufe = buch.jahrgangsstufe || "";
    buchImportForm.value.ist_arbeitsheft = buch.ist_arbeitsheft || false;
    buchImportForm.value.ist_lehrerversion = buch.ist_lehrerversion || false;
    buchImportForm.value.herkunft_id = buch.herkunft_id || null;
    markiereBuchfeld("titel", "autor", "verlag", "veroeffentlicht", "jahrgangsstufe");

    emit("zeige-scanner-status", `${buch.titel} ueber Titelcode erkannt.`);
  } catch (error) {
    gefundenesBuch.value = null;
    emit("zeige-fehler", error.message);
  }
}

async function buchTitelOnlineSuchen() {
  const titelcode = buchImportForm.value.titelcode.trim();

  if (!titelcode) {
    emit("zeige-fehler", "Bitte zuerst einen Titelcode eingeben.");
    return;
  }

  emit("zeige-fehler", "");
  buchSuchfelderZuruecksetzen();

  try {
    const treffer = await props.apiRequest(`/buecher/lookup/${encodeURIComponent(titelcode)}`);
    const quellenLabel = treffer.quelle_label || treffer.quelle || "Online-Quelle";
    gefundenesBuch.value = {
      artikel_id: "",
      titel: treffer.titel || "Unbekannter Titel",
      titelcode: treffer.titelcode,
      autor: treffer.autoren?.join(", ") || null,
      verlag: treffer.verlag || null,
      fach: null,
      jahrgangsstufe: null,
      exemplare_gesamt: 0,
      klassensatz_exemplare: 0,
      klassensatz_namen: [],
      nummernkreis: null,
      online_quelle: treffer.quelle,
      online_quelle_label: quellenLabel,
      online_untertitel: treffer.untertitel || null,
      online_veroeffentlicht: treffer.veroeffentlicht || null,
      cover_url: treffer.cover_url || null,
      cover_bild: "",
      online_json: treffer
    };
    buchCoverBild.value = "";
    if (treffer.titel) {
      buchImportForm.value.titel = treffer.titel;
      markiereBuchfeld("titel");
    }

    if (treffer.autoren?.length) {
      buchImportForm.value.autor = treffer.autoren.join(", ");
      markiereBuchfeld("autor");
    }

    if (treffer.verlag) {
      buchImportForm.value.verlag = treffer.verlag;
      markiereBuchfeld("verlag");
    }

    if (treffer.veroeffentlicht) {
      buchImportForm.value.veroeffentlicht = treffer.veroeffentlicht;
      markiereBuchfeld("veroeffentlicht");
    }

    emit("zeige-scanner-status", `${gefundenesBuch.value.titel} online gefunden (${quellenLabel}).`);
  } catch (error) {
    gefundenesBuch.value = null;
    emit("zeige-fehler", error.message);
  }
}

async function buchExemplareAnlegen() {
  emit("zeige-fehler", "");
  emit("zeige-erfolg", "");

  try {
    const response = await props.apiRequest("/buecher/exemplare", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        titelcode: buchImportForm.value.titelcode.trim(),
        artikel_id: buchImportForm.value.artikel_id || null,
        titel: buchImportForm.value.titel || null,
        autor: buchImportForm.value.autor || null,
        fach_id: buchImportForm.value.fach_id || null,
        verlag: buchImportForm.value.verlag || null,
        veroeffentlicht: buchImportForm.value.veroeffentlicht || null,
        jahrgangsstufe: buchImportForm.value.jahrgangsstufe || null,
        ist_arbeitsheft: buchImportForm.value.ist_arbeitsheft,
        ist_lehrerversion: buchImportForm.value.ist_lehrerversion,
        herkunft_id: buchImportForm.value.herkunft_id || null,
        cover_url: gefundenesBuch.value?.cover_url || null,
        cover_bild: buchCoverBild.value || gefundenesBuch.value?.cover_bild || null,
        klassensatz_name: buchImportForm.value.klassensatz_name || null,
        anzahl: Number(buchImportForm.value.anzahl || 1),
        standort_id: buchImportForm.value.standort_id || null,
        zustand: buchImportForm.value.zustand,
        anschaffungsdatum: buchImportForm.value.anschaffungsdatum || null,
        kaufpreis: buchImportForm.value.kaufpreis ? Number(buchImportForm.value.kaufpreis) : null,
        notizen: buchImportForm.value.notizen || null
      })
    });

    emit("zeige-erfolg", response.meldung);
    buchSuchfelderZuruecksetzen();
    emit("lade-daten");
  } catch (error) {
    emit("zeige-fehler", error.message);
  }
}
</script>

<template>
  <section class="medien-layout">

    <!-- Linke Navigation -->
    <aside class="panel medien-nav-panel">
      <p class="eyebrow medien-eyebrow">Medienverwaltung</p>
      <h2>Bereiche</h2>

      <nav class="medien-nav" aria-label="Medienverwaltungsbereiche">
        <button
          v-for="bereich in medienBereiche"
          :key="bereich.id"
          type="button"
          :class="['medien-link', aktiverMedienBereich === bereich.id ? 'is-active' : '']"
          @click="aktiverMedienBereich = bereich.id"
        >
          <span class="medien-link-title">{{ bereich.label }}</span>
          <span class="medien-link-copy">{{ bereich.beschreibung }}</span>
        </button>
      </nav>
    </aside>

    <!-- Rechter Inhaltsbereich -->
    <section class="panel medien-detail-panel">

      <!-- ── Inventar ── -->
      <template v-if="aktiverMedienBereich === 'inventar'">
        <header class="medien-detail-head">
          <div>
            <p class="eyebrow medien-eyebrow">Bereich</p>
            <h2>Inventar <span class="subtle" style="font-size:0.85rem; font-weight:400;">{{ geraeteGefiltert.length }} Eintraege</span></h2>
            <p class="medien-intro">Eine vollstaendige Liste aller ausleihbaren Buecher, Medien, etc.</p>
          </div>
        </header>

        <div class="form-grid">
          <label class="field field-wide">
            <span>Suche</span>
            <div class="scanner-input-wrap">
              <input
                :value="geraeteSuche"
                type="text"
                placeholder="Inventarnummer, Titel, Typ, Status ..."
                @input="emit('update:geraete-suche', $event.target.value)"
              />
              <button
                v-if="geraeteSuche"
                type="button"
                class="scanner-clear-button"
                aria-label="Suche leeren"
                @click="emit('update:geraete-suche', '')"
              >
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                  <line x1="18" y1="6" x2="6" y2="18"/>
                  <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
              </button>
            </div>
          </label>
        </div>
        <div v-if="geraeteGefiltert.length === 0" class="empty-state">Keine Geraete gefunden.</div>
        <div v-else class="table-shell inventar-table-shell geraete-table-shell">
          <table class="geraete-table">
            <thead>
              <tr>
                <th class="col-action">
                  <input
                    :checked="geraeteAlleAusgewaehlt"
                    type="checkbox"
                    title="Alle auswaehlen"
                    @change="emit('update:geraete-alle-ausgewaehlt', $event.target.checked)"
                  />
                </th>
                <th class="col-action"></th>
                <th>Inventar-Nr.</th>
                <th>Barcode</th>
                <th>Titel</th>
                <th>Typ</th>
                <th>Status</th>
                <th>Zustand</th>
                <th>Standort</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="eintrag in geraeteGefiltert" :key="eintrag.id">
                <td class="col-action">
                  <input
                    type="checkbox"
                    :checked="geraeteAusgewaehlt.has(eintrag.id)"
                    :disabled="eintrag.status !== 'verfuegbar'"
                    @change="emit('toggle-geraet-auswahl', eintrag.id)"
                  />
                </td>
                <td class="col-action">
                  <button class="icon-action-btn" title="Bearbeiten" @click="artikelZurBearbeitungOeffnen(eintrag)">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="15" height="15">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                  </button>
                </td>
                <td>{{ eintrag.inventarnummer }}</td>
                <td>{{ eintrag.barcode || "-" }}</td>
                <td>{{ eintrag.titel }}</td>
                <td>{{ eintrag.inventar_typ }}</td>
                <td>
                  <span :class="[
                    'inventar-status',
                    eintrag.status === 'ausgeliehen' ? 'is-ausgeliehen' : '',
                    eintrag.status === 'defekt' ? 'is-defekt' : ''
                  ]">
                    {{ eintrag.status }}
                  </span>
                </td>
                <td>{{ eintrag.zustand }}</td>
                <td>{{ eintrag.standort || "-" }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="button-row" style="margin-top: 12px;">
          <button
            class="danger"
            :disabled="geraeteAusgewaehlt.size === 0"
            @click="emit('geraete-auswahl-loeschen-anfragen')"
          >
            Auswahl loeschen ({{ geraeteAusgewaehlt.size }})
          </button>
        </div>
      </template>

      <!-- ── Lehrbuch hinzufügen ── -->
      <template v-else-if="aktiverMedienBereich === 'ausgabe-assistent'">
        <AusgabeAssistentModule
          :artikel="artikel"
          :exemplare="exemplare"
          :api-request="apiRequest"
          @zeige-erfolg="emit('zeige-erfolg', $event)"
          @zeige-fehler="emit('zeige-fehler', $event)"
        />
      </template>

      <template v-else-if="aktiverMedienBereich === 'storno-assistent'">
        <StornoAssistentModule
          :artikel="artikel"
          :offene-ausleihen="offeneAusleihen"
          :api-request="apiRequest"
          @zeige-erfolg="emit('zeige-erfolg', $event)"
          @zeige-fehler="emit('zeige-fehler', $event)"
        />
      </template>

      <template v-else-if="aktiverMedienBereich === 'artikelverwaltung'">
        <header class="medien-detail-head">
          <div>
            <p class="eyebrow medien-eyebrow">Bereich</p>
            <h2>Artikel verwalten <span class="subtle" style="font-size:0.85rem; font-weight:400;">{{ artikelVerwaltungEintraege.length }} Eintraege</span></h2>
            <p class="medien-intro">Alle Nicht-Buch-Artikel wie Hardware und Zubehoer im direkten Zugriff.</p>
          </div>
        </header>

        <div class="form-grid">
          <label class="field field-wide">
            <span>Suche</span>
            <div class="scanner-input-wrap">
              <input
                :value="geraeteSuche"
                type="text"
                placeholder="Inventarnummer, Titel, Typ, Status ..."
                @input="emit('update:geraete-suche', $event.target.value)"
              />
              <button
                v-if="geraeteSuche"
                type="button"
                class="scanner-clear-button"
                aria-label="Suche leeren"
                @click="emit('update:geraete-suche', '')"
              >
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                  <line x1="18" y1="6" x2="6" y2="18"/>
                  <line x1="6" y1="6" x2="18" y2="18"/>
                </svg>
              </button>
            </div>
          </label>
        </div>

        <div v-if="artikelVerwaltungEintraege.length === 0" class="empty-state">
          Keine Artikel gefunden.
        </div>
        <div v-else class="table-shell inventar-table-shell geraete-table-shell artikelverwaltung-table-shell">
          <table class="geraete-table artikelverwaltung-table">
            <thead>
              <tr>
                <th class="col-action"></th>
                <th>Titel</th>
                <th>Typ</th>
                <th>Interne Bezeichnung</th>
                <th>Hersteller</th>
                <th>Modell</th>
                <th>Kategorie</th>
                <th>Herkunft</th>
                <th>Erstellt am</th>
                <th>Aktiv</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="eintrag in artikelVerwaltungEintraege" :key="`artikel-${eintrag.id}`">
                <td class="col-action">
                  <button class="icon-action-btn" title="Bearbeiten" @click="artikelZurBearbeitungOeffnen(eintrag)">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="15" height="15">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/>
                      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                  </button>
                </td>
                <td :title="eintrag.titel"><span class="artikelverwaltung-cell">{{ kuerzeText(eintrag.titel || "-", 15) }}</span></td>
                <td :title="eintrag.inventar_typ"><span class="artikelverwaltung-cell">{{ kuerzeText(eintrag.inventar_typ || "-", 15) }}</span></td>
                <td :title="eintrag.interne_bezeichnung || '-'"><span class="artikelverwaltung-cell">{{ kuerzeText(eintrag.interne_bezeichnung || "-", 15) }}</span></td>
                <td :title="eintrag.hersteller || '-'"><span class="artikelverwaltung-cell">{{ kuerzeText(eintrag.hersteller || "-", 15) }}</span></td>
                <td :title="eintrag.modellbezeichnung || '-'"><span class="artikelverwaltung-cell">{{ kuerzeText(eintrag.modellbezeichnung || "-", 15) }}</span></td>
                <td :title="eintrag.artikel_kategorie || '-'"><span class="artikelverwaltung-cell">{{ kuerzeText(eintrag.artikel_kategorie || "-", 15) }}</span></td>
                <td :title="eintrag.herkunft || '-'"><span class="artikelverwaltung-cell">{{ kuerzeText(eintrag.herkunft || "-", 15) }}</span></td>
                <td :title="formatDatum(eintrag.erstellt_am)"><span class="artikelverwaltung-cell">{{ kuerzeText(formatDatum(eintrag.erstellt_am) || "-", 15) }}</span></td>
                <td :title="eintrag.aktiv ? 'Ja' : 'Nein'"><span class="artikelverwaltung-cell">{{ kuerzeText(eintrag.aktiv ? "Ja" : "Nein", 15) }}</span></td>
              </tr>
            </tbody>
          </table>
        </div>
      </template>

      <template v-else-if="aktiverMedienBereich === 'artikelbearbeitung'">
        <header class="medien-detail-head">
          <div>
            <p class="eyebrow medien-eyebrow">Bereich</p>
            <h2>Artikel bearbeiten</h2>
            <p class="medien-intro">Stammdaten des ausgewaehlten Artikels pflegen.</p>
          </div>
          <div class="button-row">
            <button class="ghost" type="button" @click="artikelBearbeitungAbbrechen">Zurueck zur Artikelliste</button>
          </div>
        </header>

        <div v-if="!artikelForm.id" class="empty-state">
          Kein Artikel ausgewaehlt.
        </div>
        <div v-else class="form-grid">
          <label class="field">
            <span>Inventar-Typ</span>
            <select v-model="artikelForm.inventar_typ_id">
              <option value="">- bitte waehlen -</option>
              <option v-for="typ in inventarTypen" :key="`it-${typ.id}`" :value="typ.id">
                {{ typ.bezeichnung }}
              </option>
            </select>
          </label>

          <label class="field field-wide">
            <span>Titel</span>
            <input v-model="artikelForm.titel" type="text" placeholder="z. B. iPad 10. Gen" />
          </label>

          <label class="field field-wide">
            <span>Interne Bezeichnung</span>
            <input v-model="artikelForm.interne_bezeichnung" type="text" placeholder="Interne Kurzbezeichnung" maxlength="255" />
          </label>

          <label class="field">
            <span>Hersteller</span>
            <input v-model="artikelForm.hersteller" type="text" placeholder="z. B. Apple" />
          </label>

          <label class="field">
            <span>Modell</span>
            <input v-model="artikelForm.modellbezeichnung" type="text" placeholder="z. B. A2696" />
          </label>

          <label class="field">
            <span>Kategorie</span>
            <select v-model="artikelForm.artikel_kategorie_id">
              <option value="">- bitte waehlen -</option>
              <option v-for="kategorie in artikelKategorien" :key="`kat-${kategorie.id}`" :value="kategorie.id">
                {{ kategorie.kategorie }}
              </option>
            </select>
          </label>

          <label class="field">
            <span>Herkunft</span>
            <select v-model="artikelForm.herkunft_id">
              <option value="">- bitte waehlen -</option>
              <option v-for="eintrag in herkunft" :key="`herkunft-${eintrag.id}`" :value="eintrag.id">
                {{ eintrag.bezeichnung }}
              </option>
            </select>
          </label>

          <label class="field field-wide">
            <span>Beschreibung</span>
            <textarea v-model="artikelForm.beschreibung" rows="4" placeholder="Optionale Beschreibung des Artikels"></textarea>
          </label>

          <label class="field">
            <span>Aktiv</span>
            <div class="toggle-row">
              <input id="artikel-aktiv" v-model="artikelForm.aktiv" type="checkbox" class="toggle-input" />
              <label for="artikel-aktiv" class="toggle-label"><span class="toggle-knob"></span></label>
              <span class="toggle-text">{{ artikelForm.aktiv ? "Ja" : "Nein" }}</span>
            </div>
          </label>
        </div>

        <div v-if="artikelForm.id" class="button-row objekt-action-row objekt-action-row-spaced">
          <button class="primary wide-button" type="button" @click="artikelSpeichern">
            Artikel speichern
          </button>
        </div>
      </template>

      <template v-else-if="aktiverMedienBereich === 'artikel-exemplare-import'">
        <header class="medien-detail-head">
          <div>
            <p class="eyebrow medien-eyebrow">Bereich</p>
            <h2>Artikel Exemplare importieren</h2>
            <p class="medien-intro">CSV-, TXT- oder XLSX-Datei mit Seriennummern laden, Artikel zuordnen und Inventarnummern generieren.</p>
          </div>
        </header>

        <div class="form-grid">
          <label class="field field-wide">
            <span>Datei mit Seriennummern</span>
            <input type="file" accept=".csv,.txt,.xlsx" class="compact-file-input" @change="artikelExemplareDateiEinlesen" />
            <small class="subtle">{{ artikelImportDateiname || "Noch keine Datei geladen." }}</small>
          </label>

          <label class="field">
            <span>Inventarnummer Anfang</span>
            <input v-model="artikelImportPraefix" type="text" placeholder="z. B. IPAD-2026" />
            <small class="subtle">Es wird automatisch `-0001`, `-0002` usw. angehaengt.</small>
          </label>

          <label class="field">
            <span>Artikel fuer alle</span>
            <select v-model="artikelImportArtikelId">
              <option value="">- bitte waehlen -</option>
              <option v-for="eintrag in artikel" :key="`import-artikel-${eintrag.id}`" :value="eintrag.id">
                {{ eintrag.titel }}
              </option>
            </select>
            <small class="subtle">&nbsp;</small>
          </label>

          <div class="button-row field-wide">
            <button class="primary" type="button" :disabled="!artikelImportBereit" @click="artikelExemplareImportieren">
              Exemplare importieren
            </button>
          </div>
        </div>

        <div v-if="artikelImportZeilen.length === 0" class="empty-state">
          Noch keine Seriennummern geladen.
        </div>
        <div v-else class="table-shell inventar-table-shell geraete-table-shell">
          <table class="geraete-table">
            <thead>
              <tr>
                <th>Zeile</th>
                <th>Seriennummer</th>
                <th>Barcode</th>
                <th>Artikel</th>
                <th>Inventarnummer</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(eintrag, index) in artikelImportZeilen" :key="eintrag.id">
                <td>{{ eintrag.zeile }}</td>
                <td>{{ eintrag.seriennummer }}</td>
                <td>{{ eintrag.barcode }}</td>
                <td>{{ artikelImportAuswahlText }}</td>
                <td>{{ berechneImportInventarnummer(index) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </template>

      <template v-else-if="aktiverMedienBereich === 'lehrbuch'">
        <header class="medien-detail-head">
          <div>
            <p class="eyebrow medien-eyebrow">Bereich</p>
            <h2>Lehrbuch hinzufuegen</h2>
            <p class="medien-intro">Buecher erfassen und zum Buchbestand hinzufuegen.</p>
          </div>
        </header>
        <div class="form-grid">
          <label class="field field-wide">
            <span>EAN / ISBN-13</span>
            <input
              v-model="buchImportForm.titelcode"
              type="text"
              placeholder="z. B. 9783123161011"
              @keyup.enter="buchTitelNachschlagen"
            />
          </label>

          <div class="button-row field-wide">
            <button class="ghost" @click="buchTitelNachschlagen">EAN in Schuldatenbank pruefen</button>
            <button class="ghost" @click="buchTitelOnlineSuchen">EAN online suchen</button>
          </div>

          <label class="field field-wide">
            <span>Titel</span>
            <input v-model="buchImportForm.titel" :class="{ 'field-updated': buchFeldHighlights.titel }" type="text" placeholder="z. B. Mathematik real" />
          </label>

          <label class="field field-wide">
            <span>Autor</span>
            <input v-model="buchImportForm.autor" :class="{ 'field-updated': buchFeldHighlights.autor }" type="text" placeholder="z. B. Max Mustermann" />
          </label>

          <label class="field">
            <span>Fach</span>
            <select v-model="buchImportForm.fach_id">
              <option :value="null">- bitte waehlen -</option>
              <option v-for="fach in faecher" :key="fach.id" :value="fach.id">
                {{ fach.bezeichnung }}
              </option>
            </select>
          </label>

          <label class="field">
            <span>Verlag</span>
            <input v-model="buchImportForm.verlag" :class="{ 'field-updated': buchFeldHighlights.verlag }" type="text" placeholder="z. B. Westermann" />
          </label>

          <label class="field">
            <span>Veroeffentlicht</span>
            <input v-model="buchImportForm.veroeffentlicht" :class="{ 'field-updated': buchFeldHighlights.veroeffentlicht }" type="text" placeholder="z. B. 2013" />
          </label>

          <label class="field">
            <span>Jahrgangsstufe</span>
            <input v-model="buchImportForm.jahrgangsstufe" :class="{ 'field-updated': buchFeldHighlights.jahrgangsstufe }" type="text" placeholder="z. B. 7" />
          </label>

          <label class="field">
            <span>Arbeitsheft</span>
            <div class="toggle-row">
              <input type="checkbox" id="ist_arbeitsheft" v-model="buchImportForm.ist_arbeitsheft" class="toggle-input" />
              <label for="ist_arbeitsheft" class="toggle-label"><span class="toggle-knob"></span></label>
              <span class="toggle-text">{{ buchImportForm.ist_arbeitsheft ? "Ja" : "Nein" }}</span>
            </div>
          </label>

          <label class="field">
            <span>Lehrerversion</span>
            <div class="toggle-row">
              <input type="checkbox" id="ist_lehrerversion" v-model="buchImportForm.ist_lehrerversion" class="toggle-input" />
              <label for="ist_lehrerversion" class="toggle-label"><span class="toggle-knob"></span></label>
              <span class="toggle-text">{{ buchImportForm.ist_lehrerversion ? "Ja" : "Nein" }}</span>
            </div>
          </label>

          <label class="field">
            <span>Herkunft</span>
            <select v-model="buchImportForm.herkunft_id">
              <option :value="null">- bitte waehlen -</option>
              <option v-for="h in herkunft" :key="h.id" :value="h.id">
                {{ h.bezeichnung }}
              </option>
            </select>
          </label>

          <label class="field field-wide">
            <span>Buchfoto</span>
            <input type="file" accept="image/*" @change="buchCoverDateiAuswaehlen" />
          </label>

          <label class="field">
            <span>Klassensatzname</span>
            <input v-model="buchImportForm.klassensatz_name" type="text" placeholder="z. B. Deutsch 7 - Satz A" />
          </label>

          <label class="field">
            <span>Anzahl</span>
            <input v-model="buchImportForm.anzahl" type="number" min="1" max="100" />
          </label>

          <label class="field">
            <span>Standort</span>
            <select v-model="buchImportForm.standort_id">
              <option value="">Automatisch</option>
              <option v-for="standort in standorte" :key="`buch-${standort.id}`" :value="standort.id">
                {{ standort.bezeichnung }}
              </option>
            </select>
          </label>

          <label class="field">
            <span>Zustand</span>
            <select v-model="buchImportForm.zustand">
              <option value="neu">neu</option>
              <option value="sehr_gut">sehr_gut</option>
              <option value="gut">gut</option>
              <option value="gebraucht">gebraucht</option>
              <option value="beschaedigt">beschaedigt</option>
            </select>
          </label>

          <label class="field">
            <span>Anschaffungsdatum</span>
            <input v-model="buchImportForm.anschaffungsdatum" type="date" />
          </label>

          <label class="field">
            <span>Kaufpreis</span>
            <input v-model="buchImportForm.kaufpreis" type="number" min="0" step="0.01" />
          </label>

          <label class="field field-wide">
            <span>Notizen</span>
            <textarea v-model="buchImportForm.notizen" rows="2"></textarea>
          </label>
        </div>

        <button class="primary wide-button" @click="buchExemplareAnlegen">
          Buch-Exemplare anlegen
        </button>
      </template>

      <!-- ── Titelerkennung ── -->
      <template v-else-if="aktiverMedienBereich === 'titelerkennung'">
        <header class="medien-detail-head">
          <div>
            <p class="eyebrow medien-eyebrow">Bereich</p>
            <h2>Titelerkennung</h2>
            <p class="medien-intro">Gefundene Buchdetails und Metadaten.</p>
          </div>
          <span class="subtle">{{ gefundenesBuch ? "gefunden" : "noch kein Titel" }}</span>
        </header>

      <div v-if="!gefundenesBuch" class="empty-state">
        Noch kein Buchtitel geladen. EAN / ISBN-13 eingeben oder mit dem Fallback-Scanner pruefen.
      </div>
      <div v-else class="historie-liste">
        <article class="historie-eintrag">
          <div v-if="buchCoverBild || gefundenesBuch.cover_bild || gefundenesBuch.cover_url" class="buch-cover-box">
            <img :src="buchCoverBild || gefundenesBuch.cover_bild || gefundenesBuch.cover_url" :alt="`Cover von ${gefundenesBuch.titel}`" class="buch-cover" />
          </div>
          <div class="historie-kopf">
            <strong>{{ gefundenesBuch.titel }}</strong>
            <span>{{ gefundenesBuch.fach }}</span>
          </div>
          <p>
            EAN / ISBN-13: {{ gefundenesBuch.titelcode }}<br />
            Autor: {{ gefundenesBuch.autor || "unbekannt" }}<br />
            Verlag: {{ gefundenesBuch.verlag || "unbekannt" }}
          </p>
          <div class="historie-meta">
            <span>{{ gefundenesBuch.exemplare_gesamt }} Exemplare gesamt</span>
            <span>{{ gefundenesBuch.klassensatz_exemplare }} im Klassensatz</span>
          </div>
          <div class="historie-meta" v-if="gefundenesBuch.online_quelle_label || gefundenesBuch.online_quelle || gefundenesBuch.online_veroeffentlicht">
            <span v-if="gefundenesBuch.online_quelle_label || gefundenesBuch.online_quelle">
              Quelle: {{ gefundenesBuch.online_quelle_label || gefundenesBuch.online_quelle }}
            </span>
            <span v-if="gefundenesBuch.online_veroeffentlicht">Erschienen: {{ gefundenesBuch.online_veroeffentlicht }}</span>
          </div>
          <div class="historie-meta" v-if="gefundenesBuch.klassensatz_namen?.length">
            <span>Vorhandene Saetze: {{ gefundenesBuch.klassensatz_namen.join(", ") }}</span>
          </div>
          <div class="historie-meta" v-if="gefundenesBuch.nummernkreis">
            <span>Naechste Inventarnummer: {{ gefundenesBuch.nummernkreis?.inventar_prefix }}{{ String(gefundenesBuch.nummernkreis?.inventar_startwert || 1).padStart(gefundenesBuch.nummernkreis?.inventar_stellen || 3, "0") }}</span>
            <span>Naechster Exemplarcode: {{ gefundenesBuch.nummernkreis?.barcode_prefix }}{{ String(gefundenesBuch.nummernkreis?.barcode_startwert || 1).padStart(gefundenesBuch.nummernkreis?.barcode_stellen || 3, "0") }}</span>
          </div>
          <details class="json-details">
            <summary>Gesamtes JSON anzeigen</summary>
            <pre class="json-block">{{ gefundenesBuchJson }}</pre>
          </details>
        </article>
      </div>
      </template>

      <!-- ── Objektpflege ── -->
      <template v-else-if="aktiverMedienBereich === 'objektpflege'">
        <header class="medien-detail-head">
          <div>
            <p class="eyebrow medien-eyebrow">Bereich</p>
            <h2>Objektpflege</h2>
            <p class="medien-intro">Exemplar bearbeiten und Historie einsehen.</p>
          </div>
        </header>

        <div v-if="ausgewaehltesBuch" class="buchdetails-box">
          <div class="panel-head compact-head">
            <h3>Buchdetails</h3>
            <span class="subtle">{{ ausgewaehltesBuch.inventarnummer }}</span>
          </div>
          <div class="buchdetails-grid">
            <div
              v-if="ausgewaehltesExemplar && (ausgewaehltesExemplar.cover_bild || ausgewaehltesExemplar.cover_url)"
              class="buchdetails-foto"
            >
              <img
                :src="ausgewaehltesExemplar.cover_bild || ausgewaehltesExemplar.cover_url"
                :alt="`Foto von ${ausgewaehltesExemplar.titel}`"
                class="buchdetails-foto-bild"
              />
            </div>
            <div>
              <span class="buchdetails-label">Titel</span>
              <strong>{{ ausgewaehltesBuch.titel || "unbekannt" }}</strong>
            </div>
            <div>
              <span class="buchdetails-label">Autor</span>
              <strong>{{ ausgewaehltesBuch.autor || "unbekannt" }}</strong>
            </div>
            <div>
              <span class="buchdetails-label">Verlag</span>
              <strong>{{ ausgewaehltesBuch.verlag || "unbekannt" }}</strong>
            </div>
            <div>
              <span class="buchdetails-label">Fach</span>
              <strong>{{ ausgewaehltesBuch.fach || "unbekannt" }}</strong>
            </div>
            <div>
              <span class="buchdetails-label">EAN / ISBN-13</span>
              <strong>{{ ausgewaehltesBuch.titelcode || "unbekannt" }}</strong>
            </div>
            <div>
              <span class="buchdetails-label">Veroeffentlicht</span>
              <strong>{{ ausgewaehltesBuch.veroeffentlicht || "unbekannt" }}</strong>
            </div>
          </div>
        </div>

        <div class="objektpflege-form">
          <label class="field op-col-full">
            <span>Exemplar</span>
            <select
              :value="ausgewaehltesExemplarId"
              @change="emit('update:ausgewaehltes-exemplar-id', $event.target.value); emit('waehle-exemplar', Number($event.target.value))"
            >
              <option value="">Bitte waehlen</option>
              <option v-for="eintrag in exemplare" :key="eintrag.id" :value="eintrag.id">
                {{ eintrag.inventarnummer }} - {{ eintrag.titel }}
              </option>
            </select>
          </label>

          <label class="field">
            <span>Status</span>
            <select v-model="exemplarForm.status">
              <option value="verfuegbar">verfuegbar</option>
              <option value="reserviert">reserviert</option>
              <option value="ausgeliehen">ausgeliehen</option>
              <option value="defekt">defekt</option>
              <option value="in_reparatur">in_reparatur</option>
              <option value="verloren">verloren</option>
              <option value="ausgesondert">ausgesondert</option>
            </select>
          </label>

          <label class="field">
            <span>Zustand</span>
            <select v-model="exemplarForm.zustand">
              <option value="neu">neu</option>
              <option value="sehr_gut">sehr_gut</option>
              <option value="gut">gut</option>
              <option value="gebraucht">gebraucht</option>
              <option value="beschaedigt">beschaedigt</option>
              <option value="unvollstaendig">unvollstaendig</option>
            </select>
          </label>

          <label class="field op-col-2">
            <span>Standort</span>
            <select v-model="exemplarForm.standort_id">
              <option value="">Kein Standort</option>
              <option v-for="standort in standorte" :key="standort.id" :value="standort.id">
                {{ standort.bezeichnung }}
              </option>
            </select>
          </label>

          <label class="field op-col-full">
            <span>Notizen</span>
            <textarea v-model="exemplarForm.notizen" rows="3"></textarea>
          </label>
        </div>

        <div class="button-row objekt-action-row objekt-action-row-spaced">
          <button class="primary wide-button" @click="emit('exemplar-speichern')" :disabled="!ausgewaehltesExemplar">
            Objekt aktualisieren
          </button>
        </div>

        <hr class="objektpflege-divider" />

        <div class="panel-head" style="margin-top: 4px;">
          <h2 @click="objekthistorieGeoeffnet = !objekthistorieGeoeffnet" class="collapsible-header" title="Ein-/Ausklappen">
            <svg :class="{ 'icon-rotated': objekthistorieGeoeffnet }" class="chevron-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <polyline points="6 9 12 15 18 9"></polyline>
            </svg>
            Objekthistorie
          </h2>
          <div class="button-row panel-head-actions">
            <span class="subtle">
              {{ ausgewaehltesExemplar ? ausgewaehltesExemplar.inventarnummer : "kein Exemplar" }}
            </span>
          </div>
        </div>

        <div v-if="objekthistorieGeoeffnet">
          <div v-if="laedtDaten" class="empty-state">
            Lade Historie...
          </div>
          <div v-else-if="objektHistorie.length === 0" class="empty-state">
            Fuer dieses Exemplar sind noch keine Eintraege vorhanden.
          </div>
          <div v-else class="table-shell historie-table-shell">
            <table class="historie-table objekt-historie-table">
              <thead>
                <tr>
                  <th>Datum</th>
                  <th>Aktion</th>
                  <th>Titel</th>
                  <th>Details</th>
                  <th>Ausgeloest von</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="eintrag in objektHistorie" :key="eintrag.id">
                  <td :title="formatDatum(eintrag.erstellt_am)">
                    <span class="objekt-historie-cell objekt-historie-date">{{ formatDatum(eintrag.erstellt_am) }}</span>
                  </td>
                  <td :title="eintrag.aktion || '-'">
                    <span class="objekt-historie-cell">{{ eintrag.aktion || "-" }}</span>
                  </td>
                  <td :title="eintrag.titel || '-'">
                    <span class="objekt-historie-cell">{{ eintrag.titel || "-" }}</span>
                  </td>
                  <td :title="eintrag.details || '-'">
                    <span class="objekt-historie-cell">{{ eintrag.details || "-" }}</span>
                  </td>
                  <td :title="eintrag.ausgeloest_von || '-'">
                    <span class="objekt-historie-cell">{{ eintrag.ausgeloest_von || "-" }}</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <div v-if="objektHistorieGesamt > objektHistorieLimit" class="button-row" style="margin-top: 1rem; justify-content: center; align-items: center;">
            <button
              class="btn-secondary small-button"
              :disabled="objektHistorieSeite <= 1"
              @click="emit('historie-seite-wechseln', objektHistorieSeite - 1)"
            >
              Zurueck
            </button>
            <span class="subtle" style="font-size: 0.875rem;">
              Seite {{ objektHistorieSeite }} von {{ Math.ceil(objektHistorieGesamt / objektHistorieLimit) }}
            </span>
            <button
              class="btn-secondary small-button"
              :disabled="objektHistorieSeite >= Math.ceil(objektHistorieGesamt / objektHistorieLimit)"
              @click="emit('historie-seite-wechseln', objektHistorieSeite + 1)"
            >
              Weiter
            </button>
          </div>
        </div>

        <div v-if="!objekthistorieGeoeffnet" class="empty-state">
          Objekthistorie ist eingeklappt.
        </div>
      </template>

      <template v-else-if="aktiverMedienBereich === 'import-export'">
        <header class="medien-detail-head">
          <div>
            <p class="eyebrow medien-eyebrow">Bereich</p>
            <h2>Import</h2>
            <p class="medien-intro">Importfunktionen fuer Systemdaten und Exemplare.</p>
          </div>
        </header>

        <div class="imexport-stack">
          <!-- Schuelerdaten -->
          <article class="imexport-card">
            <div class="imexport-card-head">
              <h3>Schuelerdaten</h3>
              <p class="subtle">Importieren Sie Schueler aus dem Schulverwaltungssystem.</p>
            </div>
            <div class="imexport-card-actions button-row">
              <input type="file" accept=".csv" class="compact-file-input" @change="(e) => importDateien.schueler = e.target.files[0]" />
              <button class="primary small-button" :disabled="!importDateien.schueler">Importieren</button>
            </div>
          </article>

          <!-- Lehrerdaten -->
          <article class="imexport-card">
            <div class="imexport-card-head">
              <h3>Lehrerdaten</h3>
              <p class="subtle">Importieren Sie Lehrkraefte und Personal.</p>
            </div>
            <div class="imexport-card-actions button-row">
              <input type="file" accept=".csv" class="compact-file-input" @change="(e) => importDateien.lehrer = e.target.files[0]" />
              <button class="primary small-button" :disabled="!importDateien.lehrer">Importieren</button>
            </div>
          </article>

          <!-- Buecher -->
          <article class="imexport-card">
            <div class="imexport-card-head">
              <h3>Buecher</h3>
              <p class="subtle">Katalogdaten fuer Buecher und Lehrmittel importieren.</p>
            </div>
            <div class="imexport-card-actions button-row">
              <input type="file" accept=".csv" class="compact-file-input" @change="(e) => importDateien.buecher = e.target.files[0]" />
              <button class="primary small-button" :disabled="!importDateien.buecher">Importieren</button>
            </div>
          </article>

          <!-- Artikel -->
          <article class="imexport-card">
            <div class="imexport-card-head">
              <h3>Artikel</h3>
              <p class="subtle">Stammdaten fuer Hardware importieren.</p>
            </div>
            <div class="imexport-card-actions button-row">
              <input type="file" accept=".csv" class="compact-file-input" @change="(e) => importDateien.artikel = e.target.files[0]" />
              <button class="primary small-button" :disabled="!importDateien.artikel">Importieren</button>
            </div>
          </article>
        </div>
      </template>

      <template v-else-if="aktiverMedienBereich === 'export'">
        <header class="medien-detail-head">
          <div>
            <p class="eyebrow medien-eyebrow">Bereich</p>
            <h2>Export</h2>
            <p class="medien-intro">Exportfunktionen fuer Systemdaten und Exemplare.</p>
          </div>
        </header>

        <div class="imexport-stack">
          <!-- Schuelerdaten -->
          <article class="imexport-card">
            <div class="imexport-card-head">
              <h3>Schuelerdaten</h3>
              <p class="subtle">Exportieren Sie Schueler in eine CSV-Datei.</p>
            </div>
            <div class="imexport-card-actions button-row">
              <button class="primary small-button">Exportieren</button>
            </div>
          </article>

          <!-- Lehrerdaten -->
          <article class="imexport-card">
            <div class="imexport-card-head">
              <h3>Lehrerdaten</h3>
              <p class="subtle">Exportieren Sie Lehrkraefte und Personal.</p>
            </div>
            <div class="imexport-card-actions button-row">
              <button class="primary small-button">Exportieren</button>
            </div>
          </article>

          <!-- Buecher -->
          <article class="imexport-card">
            <div class="imexport-card-head">
              <h3>Buecher</h3>
              <p class="subtle">Katalogdaten fuer Buecher und Lehrmittel exportieren.</p>
            </div>
            <div class="imexport-card-actions button-row">
              <button class="primary small-button">Exportieren</button>
            </div>
          </article>

          <!-- Artikel -->
          <article class="imexport-card">
            <div class="imexport-card-head">
              <h3>Artikel</h3>
              <p class="subtle">Stammdaten fuer Hardware exportieren.</p>
            </div>
            <div class="imexport-card-actions button-row">
              <button class="primary small-button">Exportieren</button>
            </div>
          </article>
        </div>
      </template>

    </section>
  </section>
</template>

<style scoped>
.medien-layout {
  display: grid;
  grid-template-columns: minmax(220px, 280px) minmax(0, 1fr);
  gap: 20px;
  align-items: start;
}

.medien-nav-panel {
  position: sticky;
  top: 24px;
  max-height: calc(100vh - 48px);
  display: flex;
  flex-direction: column;
}

.medien-eyebrow {
  margin-bottom: 10px;
}

.medien-intro {
  margin: 10px 0 0;
  color: rgba(36, 52, 71, 0.72);
}

.medien-nav {
  margin-top: 22px;
  display: grid;
  gap: 6px;
  overflow-y: auto;
}

.medien-link {
  text-align: left;
  padding: 8px 14px;
  border-radius: 12px;
  background: rgba(36, 52, 71, 0.05);
  border: 1px solid transparent;
  display: grid;
  gap: 2px;
  transition: background 160ms ease, border-color 160ms ease, transform 160ms ease;
}

.medien-link:hover {
  transform: translateY(-1px);
  background: rgba(36, 52, 71, 0.08);
}

.medien-link.is-active {
  background: linear-gradient(180deg, rgba(42, 157, 143, 0.16), rgba(42, 157, 143, 0.08));
  border-color: rgba(42, 157, 143, 0.24);
}

.medien-link-title {
  font-weight: 700;
  color: #17324a;
}

.medien-link-copy {
  font-size: 0.88rem;
  color: rgba(36, 52, 71, 0.68);
}

.medien-detail-panel {
  min-height: 720px;
}

.medien-detail-head {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  align-items: flex-start;
  padding-bottom: 18px;
  border-bottom: 1px solid rgba(36, 52, 71, 0.08);
  margin-bottom: 22px;
}

.inventar-status {
  display: inline-flex;
  align-items: center;
  padding: 2px 8px;
  border-radius: 999px;
}

.inventar-status.is-ausgeliehen {
  background: rgba(46, 160, 67, 0.14);
  color: #1f7a33;
  font-weight: 700;
}

.inventar-status.is-defekt {
  background: rgba(196, 48, 43, 0.14);
  color: #a32020;
  font-weight: 700;
}

.artikelverwaltung-table-shell {
  overflow-x: auto;
}

.artikelverwaltung-table {
  min-width: 1120px;
}

.artikelverwaltung-table th:not(.col-action),
.artikelverwaltung-table td:not(.col-action) {
  max-width: 15ch;
}

.artikelverwaltung-cell {
  display: inline-block;
  max-width: 15ch;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  vertical-align: bottom;
}

.objektpflege-form {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px 16px;
  margin-bottom: 16px;
}

.objektpflege-form .field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.op-col-2 {
  grid-column: span 2;
}

.op-col-full {
  grid-column: span 4;
}

.buchdetails-foto {
  grid-column: 4;
  grid-row: 1 / span 2;
  display: flex;
  align-items: flex-start;
  justify-content: flex-end;
}

.buchdetails-foto-bild {
  max-width: 130px;
  max-height: 200px;
  object-fit: contain;
  border-radius: 8px;
}

.objektpflege-divider {
  border: none;
  border-top: 1px solid rgba(36, 52, 71, 0.1);
  margin: 20px 0 16px;
}

.collapsible-header {
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  user-select: none;
}

.chevron-icon {
  transition: transform 0.3s ease;
}

.icon-rotated {
  transform: rotate(180deg);
}

.imexport-stack {
  display: flex;
  flex-direction: column;
  gap: 12px;
  width: 100%;
}

.imexport-card {
  background: var(--surface-2, #f8f9fa);
  border-radius: var(--radius-m, 12px);
  padding: 16px 20px;
  border: 1px solid var(--border-color, rgba(36, 52, 71, 0.1));
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  width: 100%;
}

.imexport-card-head {
  flex: 1;
}

.imexport-card-head h3 {
  margin: 0 0 2px 0;
  font-size: 1rem;
}

.imexport-card-head p {
  margin: 0;
  font-size: 0.85rem;
}

.imexport-card-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.compact-file-input {
  font-size: 0.85rem;
  padding: 4px;
}
</style>
