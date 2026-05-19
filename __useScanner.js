import { ref, computed, nextTick } from "vue";

export function useScanner(exemplare, ausleiher, offeneAusleihen) {
  const scannerGeraetLabel = "Honeywell USB-Scanner";
  const scannerStatus = ref("Bereit fuer den Honeywell-Scan.");
  const scanResult = ref("");
  const scanType = ref("");
  const manuelleCodeEingabe = ref("");
  const lastError = ref("");

  const scanDialog = ref({
    ausleiher: null,
    exemplar: null,
    erwartet: "ausleiher"
  });

  const markierteScanAusleihen = ref([]);

  function fokussiereScannerEingabe() {
    nextTick(() => {
      const feld = document.querySelector('[data-scanner-input="true"]');
      if (feld instanceof HTMLInputElement) {
        feld.focus();
        feld.select();
      }
      setTimeout(() => {
        const spaeteresFeld = document.querySelector('[data-scanner-input="true"]');
        if (spaeteresFeld instanceof HTMLInputElement) {
          spaeteresFeld.focus();
          spaeteresFeld.select();
        }
      }, 30);
    });
  }

  function leereScannerEingaben() {
    manuelleCodeEingabe.value = "";
    scanResult.value = "";
    scanType.value = "";

    const feld = document.querySelector('[data-scanner-input="true"]');
    if (feld instanceof HTMLInputElement) {
      feld.value = "";
    }
  }

  function scanDialogZuruecksetzen() {
    scanDialog.value = {
      ausleiher: null,
      exemplar: null,
      erwartet: "ausleiher"
    };
    markierteScanAusleihen.value = [];
  }

  function resetResult() {
    scanResult.value = "";
    scanType.value = "";
    manuelleCodeEingabe.value = "";
    markierteScanAusleihen.value = [];
    scanDialogZuruecksetzen();
    scannerStatus.value = "Bereit fuer den Honeywell-Scan.";
  }

  function uebernehmeScanAusleiher(person) {
    if (Number(scanDialog.value.ausleiher?.id) !== Number(person.id)) {
      markierteScanAusleihen.value = [];
    }
    scanDialog.value.ausleiher = person;
    scanDialog.value.erwartet = scanDialog.value.exemplar ? "komplett" : "exemplar";
  }

  function uebernehmeScanExemplar(exemplar) {
    scanDialog.value.exemplar = exemplar;
    scanDialog.value.erwartet = scanDialog.value.ausleiher ? "komplett" : "ausleiher";
  }

  function verarbeiteErkanntenCode(decodedText, formatName = "Manuelle Eingabe") {
    scanResult.value = decodedText;
    scanType.value = formatName;
    scannerStatus.value = "Code erkannt.";

    const exemplar = exemplare.value.find((eintrag) => eintrag.barcode === decodedText);
    const person = ausleiher.value.find((eintrag) => eintrag.barcode === decodedText);

    if (exemplar) {
      uebernehmeScanExemplar(exemplar);
      scannerStatus.value = scanDialog.value.ausleiher
        ? `Ausleiher und Exemplar erkannt: ${exemplar.inventarnummer}.`
        : `Exemplar ${exemplar.inventarnummer} erkannt. Jetzt Ausleiher scannen.`;
      return;
    }

    if (person) {
      uebernehmeScanAusleiher(person);
      scannerStatus.value = scanDialog.value.exemplar
        ? `${person.name} erkannt. Ausleihe ist scanbereit.`
        : `${person.name} erkannt. Jetzt Exemplar scannen.`;
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
    verarbeiteErkanntenCode(code, "Honeywell / Codeeingabe");
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
      const offeneAusleihe = offeneAusleihen.value.find(
        (eintrag) =>
          eintrag.exemplar_id === exemplar.id ||
          eintrag.inventarnummer === exemplar.inventarnummer
      );
      return offeneAusleihe?.ausleiher_name
        ? `Ausgeliehen an ${offeneAusleihe.ausleiher_name}`
        : "Aktuell ausgeliehen";
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
    if (scanDialog.value.exemplar?.status !== "ausgeliehen" || !scanDialog.value.ausleiher) {
      return null;
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
    return offeneAusleihen.value.filter((eintrag) => {
      if (eintrag.ausleiher_id != null) return Number(eintrag.ausleiher_id) === Number(scanDialog.value.ausleiher.id);
      return eintrag.ausleiher_name === scanDialog.value.ausleiher.name;
    });
  });

  const scanMarkierteAusleihe = computed(() => {
    const markierteId = markierteScanAusleihen.value[0];
    if (!markierteId) return null;
    return scanOffeneAusleihenDesAusleihers.value.find((eintrag) => Number(eintrag.id) === Number(markierteId)) || null;
  });

  const scanAktiveAusleihe = computed(() => scanOffeneAusleiheZurRueckgabe.value || scanMarkierteAusleihe.value);
  const scanBereitZurRueckgabe = computed(() => Boolean(scanAktiveAusleihe.value));

  const scanHinweisText = computed(() => {
    if (scanOffeneAusleiheZurRueckgabe.value) return `Exemplar ist an ${scanDialog.value.ausleiher?.name} verliehen. Rueckgabe ist direkt moeglich.`;
    if (scanMarkierteAusleihe.value) return `${scanMarkierteAusleihe.value.inventarnummer} ist markiert. Rueckgabe oder Verlaengerung ist direkt moeglich.`;
    if (scanDialog.value.exemplar?.status === "ausgeliehen") return exemplarWarntext(scanDialog.value.exemplar);
    if (scanDialog.value.exemplar?.status === "defekt") return exemplarWarntext(scanDialog.value.exemplar);
    if (scanBereitZurAusleihe.value) return "Person und Exemplar sind erkannt. Du kannst die Ausleihe direkt speichern.";
    return scanDialog.value.erwartet === "ausleiher" ? "1. Person oder Klasse scannen" : "2. Geraet oder Buch scannen";
  });

  return {
    scannerGeraetLabel, scannerStatus, scanResult, scanType, manuelleCodeEingabe, lastError, scanDialog, markierteScanAusleihen,
    scanBereitZurAusleihe, scanOffeneAusleiheZurRueckgabe, scanOffeneAusleihenDesAusleihers, scanMarkierteAusleihe,
    scanAktiveAusleihe, scanBereitZurRueckgabe, scanHinweisText, fokussiereScannerEingabe, leereScannerEingaben,
    scanDialogZuruecksetzen, resetResult, verarbeiteErkanntenCode, manuelleCodePruefung, uebernehmeScanAusleiher,
    uebernehmeScanExemplar, exemplarHatWarnstatus, exemplarWarntext
  };
}