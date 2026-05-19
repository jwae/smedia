import { ref, computed, watch } from 'vue';
import QRCode from 'qrcode';

const AUSLEIHER_TYPEN = ["schueler", "lehrkraft", "klasse", ""];
const AUSLEIHER_TYP_LABELS = {
  schueler: "Schueler",
  lehrkraft: "Lehrkraefte",
  klasse: "Klassen",
  "": "Ohne Typ"
};

function kuerzeText(wert, maxLaenge) {
  if (!wert) return "-";
  const text = String(wert);
  if (text.length <= maxLaenge) return text;
  return `${text.slice(0, Math.max(0, maxLaenge - 1))}…`;
}

const CODE39_MUSTER = {
  "0": "nnnwwnwnn",
  "1": "wnnwnnnnw",
  "2": "nnwwnnnnw",
  "3": "wnwwnnnnn",
  "4": "nnnwwnnnw",
  "5": "wnnwwnnnn",
  "6": "nnwwwnnnn",
  "7": "nnnwnnwnw",
  "8": "wnnwnnwnn",
  "9": "nnwwnnwnn",
  A: "wnnnnwnnw",
  B: "nnwnnwnnw",
  C: "wnwnnwnnn",
  D: "nnnnwwnnw",
  E: "wnnnwwnnn",
  F: "nnwnwwnnn",
  G: "nnnnnwwnw",
  H: "wnnnnwwnn",
  I: "nnwnnwwnn",
  J: "nnnnwwwnn",
  K: "wnnnnnnww",
  L: "nnwnnnnww",
  M: "wnwnnnnwn",
  N: "nnnnwnnww",
  O: "wnnnwnnwn",
  P: "nnwnwnnwn",
  Q: "nnnnnnwww",
  R: "wnnnnnwwn",
  S: "nnwnnnwwn",
  T: "nnnnwnwwn",
  U: "wwnnnnnnw",
  V: "nwwnnnnnw",
  W: "wwwnnnnnn",
  X: "nwnnwnnnw",
  Y: "wwnnwnnnn",
  Z: "nwwnwnnnn",
  "-": "nwnnnnwnw",
  ".": "wwnnnnwnn",
  " ": "nwwnnnwnn",
  "*": "nwnnwnwnn"
};

export function useDruck(exemplare, schuelerAusleiher, lehrkraftAusleiher, klassenAusleiher, offeneAusleihen) {
  const druckKategorie = ref("inventar");
  const druckCodeFormat = ref("barcode");
  const ausgabebelegLayout = ref("karten");
  const druckFilter = ref({
    suchtext: "",
    inventar_typ: "",
    status: "",
    standort: "",
    klasse: "",
    fachbereich: ""
  });
  const ausgabebelegFilter = ref({
    suchtext: "",
    ausleiher_typ: "",
    klasse: "",
    fachbereich: ""
  });
  const qrCodeSvgMap = ref({});

  const inventarTypenFuerDruck = computed(() =>
    [...new Set(exemplare.value.map((eintrag) => eintrag.inventar_typ).filter(Boolean))].sort((a, b) =>
      a.localeCompare(b, "de")
    )
  );

  const standorteFuerDruck = computed(() =>
    [...new Set(exemplare.value.map((eintrag) => eintrag.standort).filter(Boolean))].sort((a, b) =>
      a.localeCompare(b, "de")
    )
  );

  const statuswerteFuerDruck = computed(() =>
    [...new Set(exemplare.value.map((eintrag) => eintrag.status).filter(Boolean))].sort((a, b) =>
      a.localeCompare(b, "de")
    )
  );

  const klassenFuerDruck = computed(() =>
    [...new Set(schuelerAusleiher.value.map((eintrag) => eintrag.klasse_oder_bereich).filter(Boolean))].sort((a, b) =>
      a.localeCompare(b, "de")
    )
  );

  const fachbereicheFuerDruck = computed(() =>
    [...new Set(lehrkraftAusleiher.value.map((eintrag) => eintrag.klasse_oder_bereich).filter(Boolean))].sort((a, b) =>
      a.localeCompare(b, "de")
    )
  );

  const druckFilterAktiv = computed(() =>
    Object.values(druckFilter.value).some((wert) => Boolean(wert))
  );

  const ausgabebelegFilterAktiv = computed(() =>
    Object.values(ausgabebelegFilter.value).some((wert) => Boolean(wert))
  );

  const barcodeDruckEintraege = computed(() => {
    const suchtext = druckFilter.value.suchtext.trim().toLowerCase();

    if (druckKategorie.value === "inventar") {
      return exemplare.value
        .filter((eintrag) => {
          if (!eintrag.barcode) return false;
          if (druckFilter.value.inventar_typ && eintrag.inventar_typ !== druckFilter.value.inventar_typ) return false;
          if (druckFilter.value.status && eintrag.status !== druckFilter.value.status) return false;
          if (druckFilter.value.standort && eintrag.standort !== druckFilter.value.standort) return false;
          if (suchtext && !`${eintrag.inventarnummer} ${eintrag.titel} ${eintrag.barcode}`.toLowerCase().includes(suchtext)) return false;
          return true;
        })
        .map((eintrag) => ({
          id: `inventar-${eintrag.id}`,
          titel: eintrag.inventarnummer,
          untertitel: eintrag.titel,
          detail: eintrag.inventar_typ,
          barcode: eintrag.barcode
        }));
    }

    if (druckKategorie.value === "schueler") {
      return schuelerAusleiher.value
        .filter((eintrag) => {
          if (!eintrag.barcode) return false;
          if (druckFilter.value.klasse && eintrag.klasse_oder_bereich !== druckFilter.value.klasse) return false;
          if (suchtext && !`${eintrag.name} ${eintrag.klasse_oder_bereich || ""} ${eintrag.barcode}`.toLowerCase().includes(suchtext)) return false;
          return true;
        })
        .map((eintrag) => ({
          id: `schueler-${eintrag.id}`,
          titel: eintrag.name,
          untertitel: eintrag.klasse_oder_bereich ? `Klasse ${eintrag.klasse_oder_bereich}` : "Schueler",
          detail: "Schueler",
          barcode: eintrag.barcode
        }));
    }

    if (druckKategorie.value === "lehrkraefte") {
      return lehrkraftAusleiher.value
        .filter((eintrag) => {
          if (!eintrag.barcode) return false;
          if (druckFilter.value.fachbereich && eintrag.klasse_oder_bereich !== druckFilter.value.fachbereich) return false;
          if (suchtext && !`${eintrag.name} ${eintrag.klasse_oder_bereich || ""} ${eintrag.barcode}`.toLowerCase().includes(suchtext)) return false;
          return true;
        })
        .map((eintrag) => ({
          id: `lehrkraft-${eintrag.id}`,
          titel: eintrag.name,
          untertitel: eintrag.klasse_oder_bereich || "Lehrkraft",
          detail: "Lehrkraft",
          barcode: eintrag.barcode
        }));
    }

    if (druckKategorie.value === "klassen") {
      return klassenAusleiher.value
        .filter((eintrag) => {
          if (!eintrag.barcode) return false;
          if (druckFilter.value.klasse && eintrag.klasse_oder_bereich !== druckFilter.value.klasse) return false;
          if (suchtext && !`${eintrag.name} ${eintrag.klasse_oder_bereich || ""} ${eintrag.barcode}`.toLowerCase().includes(suchtext)) return false;
          return true;
        })
        .map((eintrag) => ({
          id: `klasse-${eintrag.id}`,
          titel: eintrag.name,
          untertitel: eintrag.klasse_oder_bereich ? `Klasse ${eintrag.klasse_oder_bereich}` : "Klasse",
          detail: "Klasse",
          barcode: eintrag.barcode
        }));
    }

    return [];
  });

  const ausgabebelegEintraege = computed(() => {
    const suchtext = ausgabebelegFilter.value.suchtext.trim().toLowerCase();

    return offeneAusleihen.value
      .filter((eintrag) => {
        if (ausgabebelegFilter.value.ausleiher_typ && eintrag.ausleiher_typ !== ausgabebelegFilter.value.ausleiher_typ) return false;
        if (
          ausgabebelegFilter.value.ausleiher_typ === "schueler" &&
          ausgabebelegFilter.value.klasse &&
          eintrag.klasse_oder_bereich !== ausgabebelegFilter.value.klasse
        ) return false;
        if (
          ausgabebelegFilter.value.ausleiher_typ === "lehrkraft" &&
          ausgabebelegFilter.value.fachbereich &&
          eintrag.klasse_oder_bereich !== ausgabebelegFilter.value.fachbereich
        ) return false;
        if (
          suchtext &&
          !`${eintrag.ausleiher_name || ""} ${eintrag.inventarnummer || ""} ${eintrag.titel || ""} ${eintrag.barcode || ""} ${eintrag.klasse_oder_bereich || ""}`
            .toLowerCase()
            .includes(suchtext)
        ) return false;
        return true;
      })
      .map((eintrag) => ({
        id: `ausleihe-${eintrag.id}`,
        titel: eintrag.ausleiher_name || "Unbekannter Ausleiher",
        untertitel: `${eintrag.inventarnummer || "-"} | ${kuerzeText(eintrag.titel || "-", 25)}`,
        ausleiherName: eintrag.ausleiher_name || "Unbekannter Ausleiher",
        inventarnummer: eintrag.inventarnummer || "-",
        medienTitel: kuerzeText(eintrag.titel || "-", 25),
        ausleiherTyp: eintrag.ausleiher_typ || "",
        ausleiherTypLabel: AUSLEIHER_TYP_LABELS[eintrag.ausleiher_typ || ""] || (eintrag.ausleiher_typ || "-"),
        bereich: eintrag.klasse_oder_bereich || "",
        barcode: eintrag.barcode || "",
        ausgabeAm: formatiereDruckDatum(eintrag.ausgabe_am),
        faelligAm: formatiereDruckDatum(eintrag.faellig_am),
        zustand: eintrag.zustand_bei_ausgabe || ""
      }));
  });

  const ausgabebelegGruppen = computed(() =>
    AUSLEIHER_TYPEN
      .map((typ) => ({
        typ,
        label: AUSLEIHER_TYP_LABELS[typ] || "Ohne Typ",
        eintraege: ausgabebelegEintraege.value
          .filter((eintrag) => (eintrag.ausleiherTyp || "") === typ)
          .sort((a, b) =>
            `${a.ausleiherName} ${a.inventarnummer} ${a.medienTitel}`.localeCompare(
              `${b.ausleiherName} ${b.inventarnummer} ${b.medienTitel}`,
              "de"
            )
          )
      }))
      .filter((gruppe) => gruppe.eintraege.length > 0)
  );

  const leihvertraegeSammeldruckEintraege = computed(() => {
    const gruppen = new Map();

    offeneAusleihen.value
      .filter((eintrag) => eintrag.ausleiher_typ === "schueler")
      .forEach((eintrag) => {
        const kategorie = String(eintrag.artikel_kategorie || "");
        if (!["tablet", "tablet_zubehoer"].includes(kategorie.toLowerCase())) return;

        const schluessel = eintrag.ausleiher_id || eintrag.ausleiher_name || eintrag.id;
        if (!gruppen.has(schluessel)) {
          gruppen.set(schluessel, {
            id: `sammeldruck-${schluessel}`,
            ausleiher_id: Number(eintrag.ausleiher_id),
            klasse: eintrag.klasse_oder_bereich || "-",
            name: eintrag.nachname || (eintrag.ausleiher_name || "").split(",")[0]?.trim() || "-",
            vorname: eintrag.vorname || (eintrag.ausleiher_name || "").split(",")[1]?.trim() || "-",
            tabletArtikelSet: new Set(),
            tabletZubehoerSet: new Set(),
            kategorienSet: new Set(),
            artikelExemplarIdsSet: new Set(),
            tabletVertragErzeugungsdatum: eintrag.tablet_vertrag_erzeugungsdatum || null
          });
        }

        const gruppe = gruppen.get(schluessel);
        const artikelText = [eintrag.titel, eintrag.inventarnummer].filter(Boolean).join(" - ");
        if (artikelText) {
          if (kategorie.toLowerCase() === "tablet") {
            gruppe.tabletArtikelSet.add(artikelText);
          }
          if (kategorie.toLowerCase() === "tablet_zubehoer") {
            gruppe.tabletZubehoerSet.add(artikelText);
          }
        }
        if (eintrag.artikel_kategorie) gruppe.kategorienSet.add(eintrag.artikel_kategorie);
        if (eintrag.exemplar_id) gruppe.artikelExemplarIdsSet.add(Number(eintrag.exemplar_id));
        if (!gruppe.tabletVertragErzeugungsdatum && eintrag.tablet_vertrag_erzeugungsdatum) {
          gruppe.tabletVertragErzeugungsdatum = eintrag.tablet_vertrag_erzeugungsdatum;
        }
      });

    return [...gruppen.values()]
      .filter((eintrag) => eintrag.kategorienSet.has("Tablet"))
      .map((eintrag) => ({
        id: eintrag.id,
        klasse: eintrag.klasse,
        name: eintrag.name,
        vorname: eintrag.vorname,
        ausleiher_id: eintrag.ausleiher_id,
        artikel_exemplar_ids: [...eintrag.artikelExemplarIdsSet].filter(Boolean),
        tablet_artikel: [...eintrag.tabletArtikelSet],
        tablet_zubehoer_artikel: [...eintrag.tabletZubehoerSet],
        artikel:
          [...eintrag.tabletArtikelSet, ...eintrag.tabletZubehoerSet].join(", ") || "-",
        artikel_kategorie: [...eintrag.kategorienSet].join(", ") || "-",
        erzeugungsdatum: formatiereDruckDatumMitUhrzeit(eintrag.tabletVertragErzeugungsdatum)
      }))
      .sort((a, b) =>
        `${a.klasse} ${a.name} ${a.vorname} ${a.artikel}`.localeCompare(
          `${b.klasse} ${b.name} ${b.vorname} ${b.artikel}`,
          "de"
        )
      );
  });

  function code39Svg(roherCode) {
    if (!roherCode) return "";
    const code = `*${String(roherCode).toUpperCase()}*`;
    const schmal = 2, breit = 5, hoehe = 52;
    let x = 0;
    const balken = [];
    for (let index = 0; index < code.length; index += 1) {
      const muster = CODE39_MUSTER[code[index]];
      if (!muster) return "";
      for (let i = 0; i < muster.length; i += 1) {
        const breite = muster[i] === "w" ? breit : schmal;
        if (i % 2 === 0) balken.push(`<rect x="${x}" y="0" width="${breite}" height="${hoehe}" fill="#111827" />`);
        x += breite;
      }
      if (index < code.length - 1) x += schmal;
    }
    return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${x} ${hoehe}" preserveAspectRatio="none" role="img">${balken.join("")}</svg>`;
  }

  function druckeBarcodes() {
    window.print();
  }

  function druckeAusgabebelege() {
    window.print();
  }

  function formatiereDruckDatum(wert) {
    if (!wert) return "-";
    const datum = new Date(wert);
    if (Number.isNaN(datum.getTime())) return String(wert);
    return datum.toLocaleDateString("de-DE");
  }

  function formatiereDruckDatumMitUhrzeit(wert) {
    if (!wert) return "-";
    const datum = new Date(wert);
    if (Number.isNaN(datum.getTime())) return String(wert);
    return datum.toLocaleString("de-DE", {
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
      second: "2-digit"
    });
  }

  async function aktualisiereQrCodes() {
    if (druckCodeFormat.value !== "qr") {
      qrCodeSvgMap.value = {};
      return;
    }
    const ergebnis = {};
    await Promise.all(barcodeDruckEintraege.value.slice(0, 400).map(async (eintrag) => {
      ergebnis[eintrag.id] = await QRCode.toString(eintrag.barcode, {
        type: "svg",
        margin: 1,
        width: 132,
        color: { dark: "#111827", light: "#FFFFFF" }
      });
    }));
    qrCodeSvgMap.value = ergebnis;
  }

  function druckFilterZuruecksetzen() {
    druckFilter.value = { suchtext: "", inventar_typ: "", status: "", standort: "", klasse: "", fachbereich: "" };
  }

  function ausgabebelegFilterZuruecksetzen() {
    ausgabebelegFilter.value = { suchtext: "", ausleiher_typ: "", klasse: "", fachbereich: "" };
  }

  watch([druckCodeFormat, barcodeDruckEintraege], () => {
    aktualisiereQrCodes().catch(console.error);
  });

  return {
    druckKategorie,
    druckCodeFormat,
    ausgabebelegLayout,
    druckFilter,
    ausgabebelegFilter,
    qrCodeSvgMap,
    inventarTypenFuerDruck,
    standorteFuerDruck,
    statuswerteFuerDruck,
    klassenFuerDruck,
    fachbereicheFuerDruck,
    druckFilterAktiv,
    ausgabebelegFilterAktiv,
    barcodeDruckEintraege,
    ausgabebelegEintraege,
    ausgabebelegGruppen,
    leihvertraegeSammeldruckEintraege,
    code39Svg,
    druckeBarcodes,
    druckeAusgabebelege,
    druckFilterZuruecksetzen,
    ausgabebelegFilterZuruecksetzen
  };
}
