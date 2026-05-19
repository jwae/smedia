import { ref, computed, nextTick, onMounted, onUnmounted } from "vue";
import { apiRequest } from "../utils/api.js";

const SCANNER_READY_TEXT = "Bereit fuer den Honeywell-Scan.";
const SCAN_INPUT_SELECTOR = '[data-scanner-input="true"]';
const SCAN_EXPECTED = {
  AUSLEIHER: "ausleiher",
  EXEMPLAR: "exemplar",
  KOMPLETT: "komplett"
};

export function useScanner(exemplare, ausleiher, offeneAusleihen) {
  const scannerGeraetLabel = "Honeywell USB-Scanner";
  const scannerStatus = ref(SCANNER_READY_TEXT);
  const scanResult = ref("");
  const scanType = ref("");
  const manuelleCodeEingabe = ref("");
  const lastError = ref("");
  const scannerInputRef = ref(null);

  const scanDialog = ref({
    ausleiher: null,
    exemplar: null,
    erwartet: SCAN_EXPECTED.AUSLEIHER
  });

  const markierteScanAusleihen = ref([]);

  function parseScanDatum(isoWert) {
    if (!isoWert) return null;

    const datum = new Date(isoWert);
    return isNaN(datum.getTime()) ? null : datum;
  }

  function holeHeutigenTagesbeginn() {
    const heute = new Date();
    heute.setHours(0, 0, 0, 0);
    return heute;
  }

  function istAusleiheUeberfaellig(ausleihe) {
    if (!ausleihe) return false;

    if (ausleihe.faelligkeit && ausleihe.faelligkeit.status === "ueberfaellig") {
      return true;
    }

    if (ausleihe.faellig_am) {
      const faellig = parseScanDatum(ausleihe.faellig_am);
      if (!faellig) return false;
      faellig.setHours(0, 0, 0, 0);
      const heute = holeHeutigenTagesbeginn();
      return faellig.getTime() < heute.getTime();
    }

    return false;
  }

  function tageUeberfaellig(ausleihe) {
    if (!ausleihe || !ausleihe.faellig_am) return 0;

    const faellig = parseScanDatum(ausleihe.faellig_am);
    if (!faellig) return 0;
    faellig.setHours(0, 0, 0, 0);
    const heute = holeHeutigenTagesbeginn();

    const diffTime = heute.getTime() - faellig.getTime();
    if (diffTime > 0) {
      return Math.floor(diffTime / (1000 * 60 * 60 * 24));
    }

    if (ausleihe.faelligkeit && ausleihe.faelligkeit.status === "ueberfaellig") {
      return 1;
    }

    return 0;
  }

  let scanBuffer = "";
  let lastKeyTime = Date.now();

  function handleGlobalKeydown(e) {
    if (e.ctrlKey || e.metaKey || e.altKey) return;

    const currentTime = Date.now();
    if (currentTime - lastKeyTime > 50) {
      scanBuffer = "";
    }
    lastKeyTime = currentTime;

    if (e.key === "Enter" && scanBuffer.length >= 3) {
      e.preventDefault();
      void verarbeiteErkanntenCode(scanBuffer, "Globaler Auto-Scan");

      scanBuffer = "";
      manuelleCodeEingabe.value = "";

      if (e.target && (e.target.tagName === "INPUT" || e.target.tagName === "TEXTAREA")) {
        e.target.blur();
      }
      return;
    }

    if (e.key.length === 1) {
      scanBuffer += e.key;
    }
  }

  onMounted(() => {
    window.addEventListener("keydown", handleGlobalKeydown);
  });

  onUnmounted(() => {
    window.removeEventListener("keydown", handleGlobalKeydown);
  });

  function holeScannerEingabefeld() {
    return scannerInputRef.value || document.querySelector(SCAN_INPUT_SELECTOR);
  }

  function fokussiereUndMarkiereScannerFeld() {
    const feld = holeScannerEingabefeld();
    if (feld instanceof HTMLInputElement) {
      feld.focus();
      feld.select();
    }
  }

  function fokussiereScannerEingabe() {
    nextTick(() => {
      fokussiereUndMarkiereScannerFeld();
      setTimeout(fokussiereUndMarkiereScannerFeld, 30);
    });
  }

  function setzeScannerRueckmeldungZurueck() {
    manuelleCodeEingabe.value = "";
    scanResult.value = "";
    scanType.value = "";
    lastError.value = "";
  }

  function leereScannerEingaben() {
    setzeScannerRueckmeldungZurueck();

    const feld = scannerInputRef.value;
    if (feld instanceof HTMLInputElement) {
      feld.value = "";
    }
  }

  function scanDialogZuruecksetzen() {
    scanDialog.value = {
      ausleiher: null,
      exemplar: null,
      erwartet: SCAN_EXPECTED.AUSLEIHER
    };
    markierteScanAusleihen.value = [];
  }

  function resetResult() {
    setzeScannerRueckmeldungZurueck();
    scanDialogZuruecksetzen();
    scannerStatus.value = SCANNER_READY_TEXT;
  }

  function uebernehmeScanAusleiher(person) {
    if (scanDialog.value.ausleiher && Number(scanDialog.value.ausleiher.id) !== Number(person.id)) {
      markierteScanAusleihen.value = [];
    }

    scanDialog.value.ausleiher = person;
    scanDialog.value.erwartet = scanDialog.value.exemplar ? SCAN_EXPECTED.KOMPLETT : SCAN_EXPECTED.EXEMPLAR;
  }

  function uebernehmeScanExemplar(exemplar) {
    scanDialog.value.exemplar = exemplar;
    scanDialog.value.erwartet = scanDialog.value.ausleiher ? SCAN_EXPECTED.KOMPLETT : SCAN_EXPECTED.AUSLEIHER;
  }

  function normalisiereScanCode(wert) {
    return String(wert || "").trim().replace(/\r/g, "").replace(/\n/g, "");
  }

  function findeAusleiherZumCode(code) {
    const scanCode = normalisiereScanCode(code);
    if (!scanCode) return null;

    return (
      ausleiher.value.find((eintrag) => normalisiereScanCode(eintrag.barcode) === scanCode) ||
      ausleiher.value.find((eintrag) => eintrag.ausleiher_typ === "schueler" && String(eintrag.s_id || "").trim() === scanCode) ||
      null
    );
  }

  function findeExemplarZumCode(code) {
    const scanCode = normalisiereScanCode(code);
    if (!scanCode) return null;

    return (
      exemplare.value.find((eintrag) => normalisiereScanCode(eintrag.barcode) === scanCode) ||
      null
    );
  }

  function findeOffeneAusleiheZumExemplar(exemplar) {
    if (!exemplar) return null;

    return (
      offeneAusleihen.value.find(
        (eintrag) =>
          Number(eintrag.exemplar_id) === Number(exemplar.id) ||
          eintrag.inventarnummer === exemplar.inventarnummer
      ) || null
    );
  }

  async function ladeScanTrefferAusDb(scanCode) {
    try {
      return await apiRequest(`/scanner/lookup?code=${encodeURIComponent(scanCode)}`);
    } catch (error) {
      if (String(error?.message || "").includes("nicht im System gefunden")) {
        return null;
      }
      throw error;
    }
  }

  function findeJsonScanTreffer(scanCode) {
    let exemplar = null;
    let person = null;
    let istTreffer = false;

    try {
      const parsed = JSON.parse(scanCode);

      if (parsed && typeof parsed === "object") {
        if (parsed.type === "device" || parsed.type === "exemplar") {
          exemplar = exemplare.value.find((eintrag) => Number(eintrag.id) === Number(parsed.id));
          istTreffer = Boolean(exemplar);
        } else if (parsed.type === "user" || parsed.type === "person") {
          person = ausleiher.value.find((eintrag) => Number(eintrag.id) === Number(parsed.id));
          istTreffer = Boolean(person);
        }
      }
    } catch {
      istTreffer = false;
    }

    return { exemplar, person, istTreffer };
  }

  async function findeScanTreffer(scanCode) {
    const jsonTreffer = findeJsonScanTreffer(scanCode);
    if (jsonTreffer.istTreffer) {
      return jsonTreffer;
    }

    const treffer = await ladeScanTrefferAusDb(scanCode);
    if (treffer?.typ === "exemplar") {
      return { exemplar: treffer.daten, person: null };
    }
    if (treffer?.typ === "ausleiher") {
      return { exemplar: null, person: treffer.daten };
    }

    return {
      exemplar: findeExemplarZumCode(scanCode),
      person: findeAusleiherZumCode(scanCode)
    };
  }

  function holeAusleiherWarnungText() {
    return scanAusleiherUeberfaelligCount.value > 0
      ? ` ACHTUNG: ${scanAusleiherUeberfaelligCount.value} ueberfaellig!`
      : "";
  }

  function gehoertAusleiheZumAusleiher(ausleihe, person) {
    if (!ausleihe || !person) return false;

    if (ausleihe.ausleiher_id != null) {
      return Number(ausleihe.ausleiher_id) === Number(person.id);
    }

    return ausleihe.ausleiher_name === person.name;
  }

  function personHatOffeneAusleihen(person) {
    return offeneAusleihen.value.some((eintrag) => gehoertAusleiheZumAusleiher(eintrag, person));
  }

  function synchronisiereExemplarNachAusleiherScan(person) {
    if (!personHatOffeneAusleihen(person) && scanDialog.value.exemplar?.status === "ausgeliehen") {
      scanDialog.value.exemplar = null;
      scanDialog.value.erwartet = SCAN_EXPECTED.EXEMPLAR;
      markierteScanAusleihen.value = [];
    }
  }

  function verarbeiteExemplarTreffer(exemplar) {
    const offeneAusleihe = exemplar.status === "ausgeliehen"
      ? findeOffeneAusleiheZumExemplar(exemplar)
      : null;

    if (offeneAusleihe && istAusleiheUeberfaellig(offeneAusleihe)) {
      lastError.value = `ACHTUNG: Das Exemplar ${exemplar.inventarnummer} ist ueberfaellig!`;
    }

    uebernehmeScanExemplar(exemplar);

    const warnung = holeAusleiherWarnungText();
    scannerStatus.value = scanDialog.value.ausleiher
      ? `Ausleiher und Exemplar erkannt: ${exemplar.inventarnummer}.${warnung}`
      : `Exemplar ${exemplar.inventarnummer} erkannt. Jetzt Ausleiher scannen.`;
  }

  function verarbeiteAusleiherTreffer(person) {
    uebernehmeScanAusleiher(person);
    synchronisiereExemplarNachAusleiherScan(person);

    if (scanAusleiherUeberfaelligCount.value > 0) {
      lastError.value = `ACHTUNG: ${person.name} hat ${scanAusleiherUeberfaelligCount.value} ueberfaellige Ausleihe(n)!`;
    }

    const warnung = holeAusleiherWarnungText();
    scannerStatus.value = scanDialog.value.exemplar
      ? `${person.name} erkannt.${warnung} Ausleihe ist scanbereit.`
      : `${person.name} erkannt.${warnung} Jetzt Exemplar scannen.`;
  }

  async function verarbeiteErkanntenCode(decodedText, formatName = "Manuelle Eingabe") {
    const scanCode = normalisiereScanCode(decodedText);

    if (!scanCode) {
      scannerStatus.value = "Bitte zuerst einen Barcode eingeben.";
      return;
    }

    scanResult.value = scanCode;
    scanType.value = formatName;
    scannerStatus.value = "Code erkannt. Pruefe Barcode in der Datenbank...";
    lastError.value = "";

    let exemplar = null;
    let person = null;

    try {
      ({ exemplar, person } = await findeScanTreffer(scanCode));
    } catch (error) {
      lastError.value = error.message || "Barcode konnte nicht in der Datenbank geprueft werden.";
      scannerStatus.value = "Barcode-Pruefung fehlgeschlagen.";
      return;
    }

    if (exemplar) {
      verarbeiteExemplarTreffer(exemplar);
      return;
    }

    if (person) {
      verarbeiteAusleiherTreffer(person);
      return;
    }

    scannerStatus.value = "Code erkannt, aber nicht im System gefunden.";
  }

  function manuelleCodePruefung() {
    const code = manuelleCodeEingabe.value.trim();
    if (!code) {
      scannerStatus.value = "Bitte zuerst einen Barcode eingeben.";
      fokussiereScannerEingabe();
      return;
    }
    void verarbeiteErkanntenCode(code, "Honeywell / Codeeingabe");
    manuelleCodeEingabe.value = "";
    fokussiereScannerEingabe();
  }

  function exemplarHatWarnstatus(exemplar) {
    return ["ausgeliehen", "defekt"].includes(exemplar?.status || "");
  }

  function exemplarWarntext(exemplar) {
    if (!exemplar) {
      return "Geraet oder Buch scannen";
    }
    if (exemplar.status === "ausgeliehen") {
      const offeneAusleihe = findeOffeneAusleiheZumExemplar(exemplar);

      let ueberfaelligText = "";
      if (offeneAusleihe && istAusleiheUeberfaellig(offeneAusleihe)) {
        ueberfaelligText = " (UEBERFAELLIG!)";
      }

      return offeneAusleihe?.ausleiher_name
        ? `Ausgeliehen an ${offeneAusleihe.ausleiher_name}${ueberfaelligText}`
        : `Aktuell ausgeliehen${ueberfaelligText}`;
    }
    if (exemplar.status === "defekt") {
      return "Defekt und nicht ausleihbar";
    }
    return exemplar.titel;
  }

  const scanBereitZurAusleihe = computed(
    () =>
      Boolean(scanDialog.value.ausleiher) &&
      Boolean(scanDialog.value.exemplar) &&
      !exemplarHatWarnstatus(scanDialog.value.exemplar)
  );

  const scanOffeneAusleiheZurRueckgabe = computed(() => {
    if (scanDialog.value.exemplar?.status !== "ausgeliehen") {
      return null;
    }
    if (!scanDialog.value.ausleiher) {
      return findeOffeneAusleiheZumExemplar(scanDialog.value.exemplar);
    }
    return (
      offeneAusleihen.value.find(
        (eintrag) =>
          Number(eintrag.exemplar_id) === Number(scanDialog.value.exemplar.id) &&
          Number(eintrag.ausleiher_id) === Number(scanDialog.value.ausleiher.id)
      ) || null
    );
  });

  const scanOffeneAusleihenDesAusleihers = computed(() => {
    if (!scanDialog.value.ausleiher) return [];
    const gefiltert = offeneAusleihen.value.filter((eintrag) => gehoertAusleiheZumAusleiher(eintrag, scanDialog.value.ausleiher));

    return gefiltert.sort((a, b) => {
      const aIstUeberfaellig = istAusleiheUeberfaellig(a);
      const bIstUeberfaellig = istAusleiheUeberfaellig(b);

      if (aIstUeberfaellig && !bIstUeberfaellig) return -1;
      if (!aIstUeberfaellig && bIstUeberfaellig) return 1;

      const dateA = a.faellig_am ? new Date(a.faellig_am).getTime() : Infinity;
      const dateB = b.faellig_am ? new Date(b.faellig_am).getTime() : Infinity;

      return dateA - dateB;
    });
  });

  const scanAusleiherUeberfaelligCount = computed(() => {
    if (!scanDialog.value.ausleiher) return 0;
    return scanOffeneAusleihenDesAusleihers.value.filter(istAusleiheUeberfaellig).length;
  });

  const scanMarkierteAusleihe = computed(() => {
    const markierteId = markierteScanAusleihen.value[0];
    if (!markierteId) return null;
    return scanOffeneAusleihenDesAusleihers.value.find((eintrag) => Number(eintrag.id) === Number(markierteId)) || null;
  });

  const scanAktiveAusleihe = computed(() => scanOffeneAusleiheZurRueckgabe.value || scanMarkierteAusleihe.value);
  const scanBereitZurRueckgabe = computed(() => Boolean(scanAktiveAusleihe.value));

  const scanHinweisText = computed(() => {
    if (scanOffeneAusleiheZurRueckgabe.value) {
      const ausleiherName = scanOffeneAusleiheZurRueckgabe.value.ausleiher_name || scanDialog.value.ausleiher?.name || "dem Ausleiher";
      return `Exemplar ist an ${ausleiherName} verliehen. Rueckgabe ist direkt moeglich.`;
    }
    if (scanMarkierteAusleihe.value) return `${scanMarkierteAusleihe.value.inventarnummer} ist markiert. Rueckgabe oder Verlaengerung ist direkt moeglich.`;
    if (scanDialog.value.exemplar?.status === "ausgeliehen") return exemplarWarntext(scanDialog.value.exemplar);
    if (scanDialog.value.exemplar?.status === "defekt") return exemplarWarntext(scanDialog.value.exemplar);

    const warnung = scanAusleiherUeberfaelligCount.value > 0
      ? ` (Achtung: ${scanAusleiherUeberfaelligCount.value} ueberfaellig)`
      : "";

    if (scanBereitZurAusleihe.value) return `Person und Exemplar sind erkannt${warnung}. Du kannst die Ausleihe direkt speichern.`;
    return scanDialog.value.erwartet === SCAN_EXPECTED.AUSLEIHER ? "1. Person oder Klasse scannen" : `2. Geraet oder Buch scannen${warnung}`;
  });

  return {
    scannerInputRef, scannerGeraetLabel, scannerStatus, scanResult, scanType,
    manuelleCodeEingabe, lastError, scanDialog, markierteScanAusleihen,
    scanBereitZurAusleihe, scanOffeneAusleiheZurRueckgabe, scanOffeneAusleihenDesAusleihers, scanAusleiherUeberfaelligCount, scanMarkierteAusleihe,
    scanAktiveAusleihe, scanBereitZurRueckgabe, scanHinweisText, fokussiereScannerEingabe, leereScannerEingaben,
    scanDialogZuruecksetzen, resetResult, verarbeiteErkanntenCode, manuelleCodePruefung, uebernehmeScanAusleiher,
    uebernehmeScanExemplar, exemplarHatWarnstatus, exemplarWarntext, istAusleiheUeberfaellig,
    tageUeberfaellig
  };
}
