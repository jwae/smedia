import { ref, computed, nextTick, onMounted, onUnmounted } from "vue";

export function useScanner(exemplare, ausleiher, offeneAusleihen) {
  const scannerGeraetLabel = "Honeywell USB-Scanner";
  const scannerStatus = ref("Bereit fuer den Honeywell-Scan.");
  const scanResult = ref("");
  const scanType = ref("");
  const manuelleCodeEingabe = ref("");
  const lastError = ref("");
  // Referenz für das Scanner-Eingabefeld im DOM
  const scannerInputRef = ref(null);

  const scanDialog = ref({
    ausleiher: null,
    exemplar: null,
    erwartet: "ausleiher"
  });

  const markierteScanAusleihen = ref([]);

  function istAusleiheUeberfaellig(ausleihe) {
    if (!ausleihe) return false;
    
    // 1. Backend-Flag prüfen (Sicherste Methode, vermeidet das 2026-Problem)
    if (ausleihe.faelligkeit && ausleihe.faelligkeit.status === "ueberfaellig") {
      return true;
    }

    // 2. Lokale Berechnung als Fallback
    if (ausleihe.faellig_am) {
      const faellig = new Date(ausleihe.faellig_am);
      if (isNaN(faellig.getTime())) return false; // Ungültiges Datumsformat abfangen

      const heute = new Date();
      faellig.setHours(0, 0, 0, 0);
      heute.setHours(0, 0, 0, 0);
      return faellig.getTime() < heute.getTime();
    }
    return false;
  }

  function tageUeberfaellig(ausleihe) {
    if (!ausleihe || !ausleihe.faellig_am) return 0;
    
    const faellig = new Date(ausleihe.faellig_am);
    if (isNaN(faellig.getTime())) return 0;

    const heute = new Date();
    faellig.setHours(0, 0, 0, 0);
    heute.setHours(0, 0, 0, 0);
    
    const diffTime = heute.getTime() - faellig.getTime();
    
    if (diffTime > 0) {
      return Math.floor(diffTime / (1000 * 60 * 60 * 24));
    }

    // Fallback für eure Testdaten (Backend sendet 2026, dein PC ist in 2024):
    if (ausleihe.faelligkeit && ausleihe.faelligkeit.status === "ueberfaellig") {
      return 1; // Pauschal 1 Tag zurückgeben, damit das rote Warn-Etikett im UI zwingend erscheint
    }

    return 0;
  }

  // --- Globale Scanner-Erkennung (Hardware Scanner) ---
  let scanBuffer = "";
  let lastKeyTime = Date.now();

  function handleGlobalKeydown(e) {
    // Ignoriere Tastenkombinationen (Strg+C, Alt+Tab, etc.)
    if (e.ctrlKey || e.metaKey || e.altKey) return;

    const currentTime = Date.now();
    // Wenn der Abstand zwischen zwei Anschlägen > 50ms ist, war es ein Mensch -> Buffer leeren
    if (currentTime - lastKeyTime > 50) {
      scanBuffer = "";
    }
    lastKeyTime = currentTime;

    // Scanner beenden ihren Scan fast immer mit "Enter"
    if (e.key === "Enter" && scanBuffer.length >= 3) {
      e.preventDefault(); // Verhindert Submit von Formularen
      verarbeiteErkanntenCode(scanBuffer, "Globaler Auto-Scan");
      
      scanBuffer = "";
      manuelleCodeEingabe.value = ""; // Verhindert doppelte Ausführung, falls Eingabefeld fokussiert war
      
      // Fokus vom aktuellen Feld nehmen, damit das UI nicht in Textfeldern hängen bleibt
      if (e.target && (e.target.tagName === "INPUT" || e.target.tagName === "TEXTAREA")) {
        e.target.blur();
      }
      return;
    }

    // Nur echte, druckbare Einzelzeichen in den Buffer aufnehmen
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

  function fokussiereScannerEingabe() {
    nextTick(() => {
      const feld =
        scannerInputRef.value ||
        document.querySelector('[data-scanner-input="true"]');
      if (feld instanceof HTMLInputElement) {
        feld.focus();
        feld.select();
      }
      setTimeout(() => {
        const spaeteresFeld =
          scannerInputRef.value ||
          document.querySelector('[data-scanner-input="true"]');
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
    lastError.value = "";

    const feld = scannerInputRef.value;
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
    lastError.value = "";
    markierteScanAusleihen.value = [];
    scanDialogZuruecksetzen();
    scannerStatus.value = "Bereit fuer den Honeywell-Scan.";
  }

  function uebernehmeScanAusleiher(person) {
    if (scanDialog.value.ausleiher && Number(scanDialog.value.ausleiher.id) !== Number(person.id)) {
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
    lastError.value = "";

    let exemplar = null;
    let person = null;

    // JSON-QR Code Support (wie im Architektur-Konzept geplant)
    try {
      const parsed = JSON.parse(decodedText);
      if (parsed.type === "device" || parsed.type === "exemplar") {
        exemplar = exemplare.value.find((eintrag) => Number(eintrag.id) === Number(parsed.id));
      } else if (parsed.type === "user" || parsed.type === "person") {
        person = ausleiher.value.find((eintrag) => Number(eintrag.id) === Number(parsed.id));
      }
    } catch (e) {
      // Fallback auf klassische Barcode-Strings
      exemplar = exemplare.value.find((eintrag) => eintrag.barcode === decodedText);
      if (!exemplar) {
        person = ausleiher.value.find((eintrag) => eintrag.barcode === decodedText);
      }
    }

    if (exemplar) {
      // Automatisches Zuweisen des Ausleihers, wenn das Gerät bereits ausgeliehen ist
      if (exemplar.status === "ausgeliehen") {
        const offeneAusleihe = offeneAusleihen.value.find(
          (eintrag) =>
            Number(eintrag.exemplar_id) === Number(exemplar.id) ||
            eintrag.inventarnummer === exemplar.inventarnummer
        );
        
        if (offeneAusleihe) {
          if (istAusleiheUeberfaellig(offeneAusleihe)) {
            lastError.value = `ACHTUNG: Das Exemplar ${exemplar.inventarnummer} ist überfällig!`;
          }

          if (offeneAusleihe.ausleiher_id) {
            const personMitAusleihe = ausleiher.value.find(
              (a) => Number(a.id) === Number(offeneAusleihe.ausleiher_id)
            );
            if (personMitAusleihe) {
              uebernehmeScanAusleiher(personMitAusleihe);
            }
          }
        }
      }

      uebernehmeScanExemplar(exemplar);

      const warnung = scanAusleiherUeberfaelligCount.value > 0 
        ? ` ACHTUNG: ${scanAusleiherUeberfaelligCount.value} überfällig!` 
        : "";

      scannerStatus.value = scanDialog.value.ausleiher
        ? `Ausleiher und Exemplar erkannt: ${exemplar.inventarnummer}.${warnung}`
        : `Exemplar ${exemplar.inventarnummer} erkannt. Jetzt Ausleiher scannen.`;
      return;
    }

    if (person) {
      uebernehmeScanAusleiher(person);

      const personHatOffeneAusleihen = offeneAusleihen.value.some((eintrag) => {
        if (eintrag.ausleiher_id != null) {
          return Number(eintrag.ausleiher_id) === Number(person.id);
        }
        return eintrag.ausleiher_name === person.name;
      });

      if (!personHatOffeneAusleihen && scanDialog.value.exemplar?.status === "ausgeliehen") {
        scanDialog.value.exemplar = null;
        scanDialog.value.erwartet = "exemplar";
        markierteScanAusleihen.value = [];
      }

      if (scanAusleiherUeberfaelligCount.value > 0) {
        lastError.value = `ACHTUNG: ${person.name} hat ${scanAusleiherUeberfaelligCount.value} überfällige Ausleihe(n)!`;
      }

      const warnung = scanAusleiherUeberfaelligCount.value > 0 
        ? ` ACHTUNG: ${scanAusleiherUeberfaelligCount.value} überfällig!` 
        : "";

      scannerStatus.value = scanDialog.value.exemplar
        ? `${person.name} erkannt.${warnung} Ausleihe ist scanbereit.`
        : `${person.name} erkannt.${warnung} Jetzt Exemplar scannen.`;
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
        
        let ueberfaelligText = "";
        if (offeneAusleihe) {
          if (istAusleiheUeberfaellig(offeneAusleihe)) {
            ueberfaelligText = " (ÜBERFÄLLIG!)";
          }
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
    const gefiltert = offeneAusleihen.value.filter((eintrag) => {
      if (eintrag.ausleiher_id != null) return Number(eintrag.ausleiher_id) === Number(scanDialog.value.ausleiher.id);
      return eintrag.ausleiher_name === scanDialog.value.ausleiher.name;
    });

    // Sortierung: Überfällige Ausleihen stehen automatisch ganz oben
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
    if (scanOffeneAusleiheZurRueckgabe.value) return `Exemplar ist an ${scanDialog.value.ausleiher?.name} verliehen. Rueckgabe ist direkt moeglich.`;
    if (scanMarkierteAusleihe.value) return `${scanMarkierteAusleihe.value.inventarnummer} ist markiert. Rueckgabe oder Verlaengerung ist direkt moeglich.`;
    if (scanDialog.value.exemplar?.status === "ausgeliehen") return exemplarWarntext(scanDialog.value.exemplar);
    if (scanDialog.value.exemplar?.status === "defekt") return exemplarWarntext(scanDialog.value.exemplar);
    
    const warnung = scanAusleiherUeberfaelligCount.value > 0 
      ? ` (Achtung: ${scanAusleiherUeberfaelligCount.value} überfällig)` 
      : "";

    if (scanBereitZurAusleihe.value) return `Person und Exemplar sind erkannt${warnung}. Du kannst die Ausleihe direkt speichern.`;
    return scanDialog.value.erwartet === "ausleiher" ? "1. Person oder Klasse scannen" : `2. Geraet oder Buch scannen${warnung}`;
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
