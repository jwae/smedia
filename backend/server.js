import cors from "cors";
import express from "express";
import { existsSync } from "node:fs";
import fs from "node:fs/promises";
import http from "node:http";
import https from "node:https";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { PDFDocument, StandardFonts, rgb } from "pdf-lib";
import swaggerUi from "swagger-ui-express";
import YAML from "yamljs";
import yazl from "yazl";
import { closePool, getConnection, query } from "./db.js";
import {
  createContractTemplateVersion,
  createLoanContract,
  getContractTemplateAssetDirectory,
  getBorrowerContractContext,
  getStoredLoanContract,
  initializeContractModule,
  listActiveContractTemplates,
  listAllContractTemplates,
  resolveStoredContractPath,
  updateContractTemplate
} from "./lib/contractService.js";
import { loadKlassenUndSchueler } from "@smedia/lib";

const app = express();
const port = Number(process.env.API_PORT || 3001);
const currentFile = fileURLToPath(import.meta.url);
const currentDir = path.dirname(currentFile);
const openapiPath = path.resolve(currentDir, "..", "openapi.yaml");
const openapiDocument = YAML.load(openapiPath);
const distKandidaten = [
  path.resolve(currentDir, "..", "frontend", "dist"),
  path.resolve(currentDir, "..", "dist")
];
const distDir = distKandidaten.find((kandidat) => existsSync(path.join(kandidat, "index.html"))) || distKandidaten[0];
const distIndexPath = path.join(distDir, "index.html");

app.use(cors());
app.use(express.json({ limit: "6mb" }));
app.use("/api/docs", swaggerUi.serve, swaggerUi.setup(openapiDocument));
app.use("/api/vertragsvorlagen-assets", express.static(getContractTemplateAssetDirectory()));
app.use(express.static(distDir));

app.use((error, _req, res, next) => {
  if (error?.type === "entity.too.large") {
    return res.status(413).json({
      fehler: "Die Anfrage ist zu gross. Bitte ein kleineres Briefkopf-Bild verwenden."
    });
  }

  return next(error);
});

const STANDARDFRISTEN_TAGE = {
  lehrkraft: 14,
  schueler: 7,
  klasse: 1
};

function formatiereSqlDatum(date) {
  const pad = (wert) => String(wert).padStart(2, "0");

  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(
    date.getHours()
  )}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
}

function berechneStandardFaelligkeit(ausleiherTyp, faelligAm) {
  if (faelligAm) {
    return faelligAm;
  }

  const tage = STANDARDFRISTEN_TAGE[ausleiherTyp] ?? 7;
  const datum = new Date();
  datum.setDate(datum.getDate() + tage);
  datum.setHours(14, 0, 0, 0);

  return formatiereSqlDatum(datum);
}

function berechneFaelligkeitsStatus(faelligAm) {
  if (!faelligAm) {
    return {
      status: "ohne_frist",
      klasse: "faellig-neutral",
      text: "ohne Frist",
      symbol: ""
    };
  }

  const jetzt = Date.now();
  const faelligkeit = new Date(faelligAm).getTime();
  const differenzMs = faelligkeit - jetzt;
  const differenzTage = differenzMs / (1000 * 60 * 60 * 24);

  if (differenzMs < 0) {
    return {
      status: "ueberfaellig",
      klasse: "faellig-kritisch",
      text: "ueberfaellig",
      symbol: "!"
    };
  }

  if (differenzTage <= 2) {
    return {
      status: "bald_faellig",
      klasse: "faellig-warnung",
      text: "bald faellig",
      symbol: "!"
    };
  }

  return {
    status: "unkritisch",
    klasse: "faellig-gut",
    text: "unkritisch",
    symbol: ""
  };
}

function prioritaetFaelligkeit(status) {
  switch (status) {
    case "ueberfaellig":
      return 0;
    case "bald_faellig":
      return 1;
    case "ohne_frist":
      return 2;
    default:
      return 3;
  }
}

async function ermittleNaechstenLehrkraftBarcode(connection, kuerzel) {
  const prefix = `L-${kuerzel}-`;
  const [rows] = await connection.query(
    `
      SELECT barcode
      FROM lehrkraefte
      WHERE barcode LIKE ?
    `,
    [`${prefix}%`]
  );

  let maxSuffix = 0;

  for (const row of rows) {
    const barcode = String(row.barcode || "");
    const suffix = barcode.slice(prefix.length);

    if (/^\d{3}$/.test(suffix)) {
      maxSuffix = Math.max(maxSuffix, Number(suffix));
    }
  }

  return `${prefix}${String(maxSuffix + 1).padStart(3, "0")}`;
}

function mapExemplar(row) {
  return {
    id: row.id,
    inventarnummer: row.inventarnummer,
    barcode: row.barcode,
    seriennummer: row.seriennummer,
    artikel_id: row.artikel_id,
    titel: row.titel,
    titelcode: row.titelcode,
    autor: row.autor,
    verlag: row.verlag,
    fach: row.fach,
    veroeffentlicht: row.veroeffentlicht,
    cover_url: row.cover_url,
    cover_bild: row.cover_bild,
    inventar_typ: row.inventar_typ,
    standort: row.standort,
    standort_id: row.standort_id,
    status: row.status,
    zustand: row.zustand,
    notizen: row.notizen,
    ist_klassensatz: Boolean(row.ist_klassensatz),
    klassensatz_name: row.klassensatz_name
  };
}

function mapAusleiherMitDetails(row) {
  return {
    id: row.id,
    name: row.name,
    ausleiher_typ: row.ausleiher_typ,
    klasse_oder_bereich: row.klasse_oder_bereich,
    barcode: row.barcode,
    quelle_typ: row.quelle_typ,
    quelle_id: row.quelle_id,
    aktiv: Boolean(row.aktiv),
    s_id: row.s_id,
    vorname: row.vorname,
    nachname: row.nachname,
    anzeigename: row.anzeigename,
    geburtsdatum: row.geburtsdatum,
    email: row.email,
    klasse: row.klasse
  };
}

function normalisiereTextfeld(wert) {
  if (typeof wert !== "string") {
    return null;
  }

  const bereinigt = wert.trim();
  return bereinigt.length > 0 ? bereinigt : null;
}

function normalisiereBooleanWert(wert) {
  if (typeof wert === "boolean") {
    return wert;
  }

  if (typeof wert === "number") {
    return wert !== 0;
  }

  if (typeof wert === "string") {
    const normalisiert = wert.trim().toLowerCase();

    if (["true", "1", "ja", "yes", "on"].includes(normalisiert)) {
      return true;
    }

    if (["false", "0", "nein", "no", "off", ""].includes(normalisiert)) {
      return false;
    }
  }

  return false;
}

function formatiereAnzeigeDatum(wert) {
  if (!wert) {
    return "";
  }

  const datum = new Date(wert);
  if (Number.isNaN(datum.getTime())) {
    return "";
  }

  return datum.toLocaleDateString("de-DE");
}

function formatiereAnzeigeZeitstempel(wert = new Date()) {
  const datum = wert instanceof Date ? wert : new Date(wert);
  if (Number.isNaN(datum.getTime())) {
    return "";
  }

  return datum.toLocaleString("de-DE", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit"
  });
}

function kuerzePdfText(wert, maxLaenge = 34) {
  const text = String(wert || "").trim();
  if (text.length <= maxLaenge) {
    return text;
  }

  return `${text.slice(0, Math.max(0, maxLaenge - 1))}...`;
}

async function ladeAusgabeAssistentKontext(connection, klasseAusleiherId, artikelId) {
  const [klassenRows] = await connection.execute(
    `
      SELECT a.id, a.name, a.ausleiher_typ, a.quelle_id, a.aktiv, k.bezeichnung AS klassenname
      FROM ausleiher a
      JOIN klassen k ON k.id = a.quelle_id
      WHERE a.id = ? AND a.ausleiher_typ = 'klasse' AND a.quelle_typ = 'klasse' AND a.aktiv = 1 AND k.aktiv = 1
      LIMIT 1
    `,
    [klasseAusleiherId]
  );

  if (klassenRows.length === 0) {
    throw new Error("Klasse wurde nicht gefunden.");
  }

  const [artikelRows] = await connection.execute(
    `
      SELECT id, titel, aktiv
      FROM artikel
      WHERE id = ?
      LIMIT 1
    `,
    [artikelId]
  );

  if (artikelRows.length === 0 || artikelRows[0].aktiv !== 1) {
    throw new Error("Artikel wurde nicht gefunden.");
  }

  return {
    klasse: klassenRows[0],
    artikel: artikelRows[0]
  };
}

async function erstelleAusgabeAssistentVorschau(connection, klasseAusleiherId, artikelId) {
  const kontext = await ladeAusgabeAssistentKontext(connection, klasseAusleiherId, artikelId);

  const [schuelerRows] = await connection.execute(
    `
      SELECT
        a.id AS schueler_ausleiher_id,
        s.id AS schueler_id,
        s.vorname,
        s.nachname,
        COALESCE(k.bezeichnung, ?) AS klasse
      FROM schueler_klassen sk
      JOIN (
        SELECT MAX(id) AS id
        FROM schueler_klassen
        WHERE ist_aktuell = 1
        GROUP BY schueler_id
      ) aktuelle_zuordnung
        ON aktuelle_zuordnung.id = sk.id
      JOIN schueler s
        ON s.id = sk.schueler_id
       AND s.aktiv = 1
      JOIN ausleiher a
        ON a.quelle_typ = 'schueler'
       AND a.quelle_id = s.id
       AND a.aktiv = 1
      LEFT JOIN klassen k
        ON k.id = sk.klassen_id
      WHERE sk.klassen_id = ?
      ORDER BY s.nachname, s.vorname, s.id
    `,
    [kontext.klasse.klassenname || kontext.klasse.name, kontext.klasse.quelle_id]
  );

  const [verfuegbareExemplare] = await connection.execute(
    `
      SELECT
        ae.id,
        ae.inventarnummer,
        ae.seriennummer,
        ae.barcode
      FROM artikel_exemplare ae
      JOIN statuskatalog sk ON sk.id = ae.status_id
      WHERE ae.artikel_id = ?
        AND ae.aktiv = 1
        AND sk.bezeichnung = 'verfuegbar'
      ORDER BY ae.inventarnummer, ae.seriennummer, ae.id
    `,
    [artikelId]
  );

  const schuelerAusleiherIds = schuelerRows.map((eintrag) => Number(eintrag.schueler_ausleiher_id));
  let bestehendeAusleihenRows = [];

  if (schuelerAusleiherIds.length > 0) {
    const platzhalter = schuelerAusleiherIds.map(() => "?").join(", ");
    const [rows] = await connection.execute(
      `
        SELECT
          al.ausleiher_id,
          ae.id AS exemplar_id,
          ae.inventarnummer,
          ae.seriennummer,
          ae.barcode
        FROM ausleihen al
        JOIN artikel_exemplare ae ON ae.id = al.exemplar_id
        WHERE al.status = 'offen'
          AND ae.artikel_id = ?
          AND al.ausleiher_id IN (${platzhalter})
        ORDER BY al.ausgabe_am DESC, al.id DESC
      `,
      [artikelId, ...schuelerAusleiherIds]
    );
    bestehendeAusleihenRows = rows;
  }

  const bestehendeAusleihenMap = new Map();
  for (const eintrag of bestehendeAusleihenRows) {
    if (!bestehendeAusleihenMap.has(Number(eintrag.ausleiher_id))) {
      bestehendeAusleihenMap.set(Number(eintrag.ausleiher_id), eintrag);
    }
  }

  let exemplarIndex = 0;
  const zeilen = schuelerRows.map((eintrag, index) => {
    const bestehendeAusleihe = bestehendeAusleihenMap.get(Number(eintrag.schueler_ausleiher_id));
    const schuelerName = [eintrag.nachname, eintrag.vorname].filter(Boolean).join(", ");

    if (bestehendeAusleihe) {
      return {
        listen_id: `schueler-${eintrag.schueler_ausleiher_id}-${index + 1}`,
        schueler_ausleiher_id: Number(eintrag.schueler_ausleiher_id),
        schueler_id: Number(eintrag.schueler_id),
        schueler_name: schuelerName,
        klasse: eintrag.klasse || kontext.klasse.klassenname || kontext.klasse.name,
        exemplar_id: null,
        inventarnummer: "",
        seriennummer: "",
        barcode: "",
        status: "bereits ausgeliehen",
        aktiv: false,
        aktivierbar: false,
        bestehende_ausleihe: {
          inventarnummer: bestehendeAusleihe.inventarnummer || "",
          seriennummer: bestehendeAusleihe.seriennummer || "",
          barcode: bestehendeAusleihe.barcode || ""
        },
        bestehende_ausleihe_tooltip: `Vorhanden: ${bestehendeAusleihe.inventarnummer || "-"} / ${bestehendeAusleihe.seriennummer || "-"}`
      };
    }

    const exemplar = verfuegbareExemplare[exemplarIndex] || null;
    if (exemplar) {
      exemplarIndex += 1;
      return {
        listen_id: `schueler-${eintrag.schueler_ausleiher_id}-${index + 1}`,
        schueler_ausleiher_id: Number(eintrag.schueler_ausleiher_id),
        schueler_id: Number(eintrag.schueler_id),
        schueler_name: schuelerName,
        klasse: eintrag.klasse || kontext.klasse.klassenname || kontext.klasse.name,
        exemplar_id: Number(exemplar.id),
        inventarnummer: exemplar.inventarnummer || "",
        seriennummer: exemplar.seriennummer || "",
        barcode: exemplar.barcode || "",
        status: "vorgeschlagen",
        aktiv: true,
        aktivierbar: true,
        bestehende_ausleihe: null,
        bestehende_ausleihe_tooltip: ""
      };
    }

    return {
      listen_id: `schueler-${eintrag.schueler_ausleiher_id}-${index + 1}`,
      schueler_ausleiher_id: Number(eintrag.schueler_ausleiher_id),
      schueler_id: Number(eintrag.schueler_id),
      schueler_name: schuelerName,
      klasse: eintrag.klasse || kontext.klasse.klassenname || kontext.klasse.name,
      exemplar_id: null,
      inventarnummer: "",
      seriennummer: "",
      barcode: "",
      status: "nicht versorgt",
      aktiv: false,
      aktivierbar: false,
      bestehende_ausleihe: null,
      bestehende_ausleihe_tooltip: ""
    };
  });

  return {
    klasse_name: kontext.klasse.klassenname || kontext.klasse.name,
    artikel_id: Number(kontext.artikel.id),
    artikel_titel: kontext.artikel.titel || "",
    zeilen,
    statistik: {
      gesamt: zeilen.length,
      zugeordnet: zeilen.filter((eintrag) => eintrag.status === "vorgeschlagen").length,
      bereits_ausgeliehen: zeilen.filter((eintrag) => eintrag.status === "bereits ausgeliehen").length,
      nicht_versorgt: zeilen.filter((eintrag) => eintrag.status === "nicht versorgt").length
    }
  };
}

async function erstelleStornoAssistentVorschau(connection, klasseAusleiherId, artikelId) {
  const kontext = await ladeAusgabeAssistentKontext(connection, klasseAusleiherId, artikelId);

  const [schuelerRows] = await connection.execute(
    `
      SELECT
        a.id AS schueler_ausleiher_id,
        s.id AS schueler_id,
        s.vorname,
        s.nachname,
        COALESCE(k.bezeichnung, ?) AS klasse
      FROM schueler_klassen sk
      JOIN (
        SELECT MAX(id) AS id
        FROM schueler_klassen
        WHERE ist_aktuell = 1
        GROUP BY schueler_id
      ) aktuelle_zuordnung
        ON aktuelle_zuordnung.id = sk.id
      JOIN schueler s
        ON s.id = sk.schueler_id
       AND s.aktiv = 1
      JOIN ausleiher a
        ON a.quelle_typ = 'schueler'
       AND a.quelle_id = s.id
       AND a.aktiv = 1
      LEFT JOIN klassen k
        ON k.id = sk.klassen_id
      WHERE sk.klassen_id = ?
      ORDER BY s.nachname, s.vorname, s.id
    `,
    [kontext.klasse.klassenname || kontext.klasse.name, kontext.klasse.quelle_id]
  );

  const schuelerAusleiherIds = schuelerRows.map((eintrag) => Number(eintrag.schueler_ausleiher_id));
  let offeneAusleihenRows = [];

  if (schuelerAusleiherIds.length > 0) {
    const platzhalter = schuelerAusleiherIds.map(() => "?").join(", ");
    const [rows] = await connection.execute(
      `
        SELECT
          al.id AS ausleihe_id,
          al.ausleiher_id,
          ae.id AS exemplar_id,
          ae.inventarnummer,
          ae.seriennummer,
          ae.barcode
        FROM ausleihen al
        JOIN artikel_exemplare ae ON ae.id = al.exemplar_id
        WHERE al.status = 'offen'
          AND ae.artikel_id = ?
          AND al.ausleiher_id IN (${platzhalter})
        ORDER BY al.ausgabe_am DESC, al.id DESC
      `,
      [artikelId, ...schuelerAusleiherIds]
    );
    offeneAusleihenRows = rows;
  }

  const offeneAusleihenMap = new Map();
  for (const eintrag of offeneAusleihenRows) {
    if (!offeneAusleihenMap.has(Number(eintrag.ausleiher_id))) {
      offeneAusleihenMap.set(Number(eintrag.ausleiher_id), eintrag);
    }
  }

  const zeilen = schuelerRows.map((eintrag, index) => {
    const offeneAusleihe = offeneAusleihenMap.get(Number(eintrag.schueler_ausleiher_id));
    const schuelerName = [eintrag.nachname, eintrag.vorname].filter(Boolean).join(", ");

    if (!offeneAusleihe) {
      return {
        listen_id: `storno-${eintrag.schueler_ausleiher_id}-${index + 1}`,
        ausleihe_id: null,
        schueler_ausleiher_id: Number(eintrag.schueler_ausleiher_id),
        schueler_id: Number(eintrag.schueler_id),
        schueler_name: schuelerName,
        klasse: eintrag.klasse || kontext.klasse.klassenname || kontext.klasse.name,
        exemplar_id: null,
        inventarnummer: "",
        seriennummer: "",
        barcode: "",
        status: "keine offene Buchung",
        aktiv: false,
        aktivierbar: false
      };
    }

    return {
      listen_id: `storno-${eintrag.schueler_ausleiher_id}-${index + 1}`,
      ausleihe_id: Number(offeneAusleihe.ausleihe_id),
      schueler_ausleiher_id: Number(eintrag.schueler_ausleiher_id),
      schueler_id: Number(eintrag.schueler_id),
      schueler_name: schuelerName,
      klasse: eintrag.klasse || kontext.klasse.klassenname || kontext.klasse.name,
      exemplar_id: Number(offeneAusleihe.exemplar_id),
      inventarnummer: offeneAusleihe.inventarnummer || "",
      seriennummer: offeneAusleihe.seriennummer || "",
      barcode: offeneAusleihe.barcode || "",
      status: "offene Buchung",
      aktiv: true,
      aktivierbar: true
    };
  });

  return {
    klasse_name: kontext.klasse.klassenname || kontext.klasse.name,
    artikel_id: Number(kontext.artikel.id),
    artikel_titel: kontext.artikel.titel || "",
    zeilen,
    statistik: {
      gesamt: zeilen.length,
      offene_buchungen: zeilen.filter((eintrag) => eintrag.status === "offene Buchung").length,
      keine_offene_buchung: zeilen.filter((eintrag) => eintrag.status === "keine offene Buchung").length
    }
  };
}

async function erzeugeAssistentPdf({
  dokumentTitel = "Assistent",
  klasseName,
  artikelTitel,
  metaZeileLinks = "",
  metaZeileRechts = "",
  faelligAm,
  kommentarAusgabe,
  zeilen
}) {
  const pdf = await PDFDocument.create();
  const fontRegular = await pdf.embedFont(StandardFonts.Helvetica);
  const fontBold = await pdf.embedFont(StandardFonts.HelveticaBold);

  const seitenBreite = 842;
  const seitenHoehe = 595;
  const rand = 36;
  const tabellenSpalten = [
    { key: "schueler_name", label: "Schueler", breite: 185, maxLaenge: 32 },
    { key: "klasse", label: "Klasse", breite: 70, maxLaenge: 12 },
    { key: "inventarnummer", label: "Exemplar", breite: 86, maxLaenge: 18 },
    { key: "seriennummer", label: "Seriennummer", breite: 140, maxLaenge: 26 },
    { key: "barcode", label: "Barcode", breite: 120, maxLaenge: 22 },
    { key: "status", label: "Status", breite: 100, maxLaenge: 18 }
  ];

  const zeilenHoehe = 18;
  const kopfhoehe = 84;
  const metaHoehe = kommentarAusgabe ? 52 : 34;
  const tabellenStartY = seitenHoehe - rand - kopfhoehe - metaHoehe;
  const tabellenEndeY = rand + 22;
  const verfuegbareZeilenProSeite = Math.max(
    1,
    Math.floor((tabellenStartY - tabellenEndeY - zeilenHoehe) / zeilenHoehe)
  );
  const seiten = [];

  for (let index = 0; index < zeilen.length; index += verfuegbareZeilenProSeite) {
    seiten.push(zeilen.slice(index, index + verfuegbareZeilenProSeite));
  }

  if (seiten.length === 0) {
    seiten.push([]);
  }

  const zeichneSeitenkopf = (seite, seitenIndex) => {
    seite.drawText(dokumentTitel, {
      x: rand,
      y: seitenHoehe - rand,
      size: 20,
      font: fontBold,
      color: rgb(0.14, 0.2, 0.28)
    });

    seite.drawText(`Klasse: ${klasseName || "-"}`, {
      x: rand,
      y: seitenHoehe - rand - 28,
      size: 10.5,
      font: fontRegular,
      color: rgb(0.25, 0.31, 0.38)
    });
    seite.drawText(`Artikel: ${artikelTitel || "-"}`, {
      x: rand + 220,
      y: seitenHoehe - rand - 28,
      size: 10.5,
      font: fontRegular,
      color: rgb(0.25, 0.31, 0.38)
    });
    seite.drawText(metaZeileLinks || `Erzeugt: ${formatiereAnzeigeZeitstempel()}`, {
      x: rand,
      y: seitenHoehe - rand - 44,
      size: 10,
      font: fontRegular,
      color: rgb(0.25, 0.31, 0.38)
    });
    seite.drawText(metaZeileRechts || `Faellig am: ${formatiereAnzeigeDatum(faelligAm) || "-"}`, {
      x: rand + 220,
      y: seitenHoehe - rand - 44,
      size: 10,
      font: fontRegular,
      color: rgb(0.25, 0.31, 0.38)
    });

    if (kommentarAusgabe) {
      seite.drawText(`Kommentar: ${kuerzePdfText(kommentarAusgabe, 92)}`, {
        x: rand,
        y: seitenHoehe - rand - 60,
        size: 10,
        font: fontRegular,
        color: rgb(0.25, 0.31, 0.38)
      });
    }

    seite.drawText(`Seite ${seitenIndex + 1} / ${seiten.length}`, {
      x: seitenBreite - rand - 70,
      y: seitenHoehe - rand,
      size: 10,
      font: fontRegular,
      color: rgb(0.37, 0.42, 0.49)
    });
  };

  const zeichneTabellenkopf = (seite, startY) => {
    let aktuelleX = rand;
    seite.drawLine({
      start: { x: rand, y: startY + 6 },
      end: { x: seitenBreite - rand, y: startY + 6 },
      thickness: 1,
      color: rgb(0.84, 0.87, 0.9)
    });

    for (const spalte of tabellenSpalten) {
      seite.drawText(spalte.label, {
        x: aktuelleX,
        y: startY - 7,
        size: 10,
        font: fontBold,
        color: rgb(0.14, 0.2, 0.28)
      });
      aktuelleX += spalte.breite;
    }
  };

  seiten.forEach((eintraege, seitenIndex) => {
    const seite = pdf.addPage([seitenBreite, seitenHoehe]);
    zeichneSeitenkopf(seite, seitenIndex);
    zeichneTabellenkopf(seite, tabellenStartY);

    let aktuelleY = tabellenStartY - 28;
    eintraege.forEach((eintrag) => {
      let aktuelleX = rand;

      for (const spalte of tabellenSpalten) {
        const text = kuerzePdfText(eintrag[spalte.key] || "-", spalte.maxLaenge);
        seite.drawText(text, {
          x: aktuelleX,
          y: aktuelleY,
          size: 9.5,
          font: fontRegular,
          color: rgb(0.2, 0.25, 0.31)
        });
        aktuelleX += spalte.breite;
      }

      seite.drawLine({
        start: { x: rand, y: aktuelleY - 4 },
        end: { x: seitenBreite - rand, y: aktuelleY - 4 },
        thickness: 0.6,
        color: rgb(0.9, 0.92, 0.94)
      });

      aktuelleY -= zeilenHoehe;
    });
  });

  return Buffer.from(await pdf.save());
}

const STANDARD_EINSTELLUNGEN = {
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
    inventarPraefix: "BUCH-",
    barcodePraefix: "B-",
    onlineSucheAktiv: true,
    standardAnzahl: "1"
  }
};

async function initialisiereEinstellungstabelle() {
  await query(`
    CREATE TABLE IF NOT EXISTS app_einstellungen (
      bereich VARCHAR(50) NOT NULL,
      daten_json LONGTEXT NOT NULL,
      aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (bereich)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `);
}

async function initialisiereSchuelerConstraints() {
  const emailIndexRows = await query(
    `
      SELECT COUNT(*) AS anzahl
      FROM information_schema.statistics
      WHERE table_schema = DATABASE()
        AND table_name = 'schueler'
        AND index_name = 'uq_schueler_email'
    `
  );

  if (Number(emailIndexRows[0]?.anzahl || 0) > 0) {
    await query(`ALTER TABLE schueler DROP INDEX uq_schueler_email`);
  }

  const doppelteSids = await query(
    `
      SELECT S_ID, COUNT(*) AS anzahl
      FROM schueler
      WHERE S_ID IS NOT NULL
      GROUP BY S_ID
      HAVING COUNT(*) > 1
      ORDER BY S_ID
      LIMIT 5
    `
  );

  if (doppelteSids.length > 0) {
    const beispiele = doppelteSids.map((eintrag) => `${eintrag.S_ID} (${eintrag.anzahl}x)`).join(", ");
    throw new Error(`Doppelte S_ID in schueler gefunden: ${beispiele}. Bitte bereinigen, bevor die Eindeutigkeit aktiviert wird.`);
  }

  const sidIndexRows = await query(
    `
      SELECT COUNT(*) AS anzahl
      FROM information_schema.statistics
      WHERE table_schema = DATABASE()
        AND table_name = 'schueler'
        AND index_name = 'uq_schueler_s_id'
    `
  );

  if (Number(sidIndexRows[0]?.anzahl || 0) === 0) {
    await query(`ALTER TABLE schueler ADD UNIQUE KEY uq_schueler_s_id (S_ID)`);
  }
}

async function ladeEinstellungenBereich(bereich) {
  const defaults = STANDARD_EINSTELLUNGEN[bereich];

  if (!defaults) {
    return null;
  }

  const rows = await query(
    `
      SELECT daten_json
      FROM app_einstellungen
      WHERE bereich = ?
      LIMIT 1
    `,
    [bereich]
  );

  if (rows.length === 0) {
    return { ...defaults };
  }

  try {
    const gespeichert = JSON.parse(rows[0].daten_json || "{}");
    return { ...defaults, ...gespeichert };
  } catch (_error) {
    return { ...defaults };
  }
}

async function speichereEinstellungenBereich(bereich, daten) {
  const defaults = STANDARD_EINSTELLUNGEN[bereich];

  if (!defaults) {
    throw new Error("Unbekannter Einstellungsbereich.");
  }

  const gemischt = { ...defaults, ...(daten || {}) };

  await query(
    `
      INSERT INTO app_einstellungen (bereich, daten_json)
      VALUES (?, ?)
      ON DUPLICATE KEY UPDATE daten_json = VALUES(daten_json)
    `,
    [bereich, JSON.stringify(gemischt)]
  );

  return gemischt;
}

async function fetchJsonMitTimeout(url, timeoutMs = 5000) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const response = await fetch(url, {
      signal: controller.signal,
      headers: {
        Accept: "application/json",
        "User-Agent": "smedia/1.0 (+school-media-manager)"
      }
    });

    if (!response.ok) {
      throw new Error(`Remote-HTTP ${response.status}`);
    }

    return await response.json();
  } finally {
    clearTimeout(timer);
  }
}

async function fetchTextMitTimeout(url, timeoutMs = 5000) {
  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const response = await fetch(url, {
      signal: controller.signal,
      headers: {
        Accept: "application/xml, text/xml;q=0.9, */*;q=0.8",
        "User-Agent": "smedia/1.0 (+school-media-manager)"
      }
    });

    if (!response.ok) {
      throw new Error(`Remote-HTTP ${response.status}`);
    }

    return await response.text();
  } finally {
    clearTimeout(timer);
  }
}

async function fetchBildAlsDataUrl(url, timeoutMs = 8000, maxBytes = 3 * 1024 * 1024) {
  if (!url) {
    return null;
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);

  try {
    const response = await fetch(url, {
      signal: controller.signal,
      headers: {
        Accept: "image/*",
        "User-Agent": "smedia/1.0 (+school-media-manager)"
      }
    });

    if (!response.ok) {
      throw new Error(`Remote-HTTP ${response.status}`);
    }

    const contentType = response.headers.get("content-type") || "";

    if (!contentType.startsWith("image/")) {
      throw new Error("Remote-Datei ist kein Bild.");
    }

    const arrayBuffer = await response.arrayBuffer();

    if (arrayBuffer.byteLength > maxBytes) {
      throw new Error("Bild ist zu gross.");
    }

    const base64 = Buffer.from(arrayBuffer).toString("base64");
    return `data:${contentType};base64,${base64}`;
  } finally {
    clearTimeout(timer);
  }
}

function laeuftInDockerContainer() {
  return process.env.RUNNING_IN_DOCKER === "true" || existsSync("/.dockerenv");
}

function ersetzeLokalenSvwsHostFuerDocker(basis) {
  if (!laeuftInDockerContainer()) {
    return basis;
  }

  if (/^localhost(?::|$)/i.test(basis)) {
    return basis.replace(/^localhost/i, "host.docker.internal");
  }

  if (/^127\.0\.0\.1(?::|$)/.test(basis)) {
    return basis.replace(/^127\.0\.0\.1/, "host.docker.internal");
  }

  return basis;
}

function normalisiereSvwsHost(host) {
  const basis = String(host || "").trim();

  if (!basis) {
    return "";
  }

  if (/^https?:\/\//i.test(basis)) {
    const url = new URL(basis);
    url.hostname = ersetzeLokalenSvwsHostFuerDocker(url.hostname);
    return url.toString().replace(/\/+$/, "");
  }

  const dockerBasis = ersetzeLokalenSvwsHostFuerDocker(basis);
  const lowerBasis = dockerBasis.toLowerCase();
  const istLokalerHost =
    lowerBasis === "localhost" ||
    lowerBasis.startsWith("localhost:") ||
    lowerBasis === "127.0.0.1" ||
    lowerBasis.startsWith("127.0.0.1:") ||
    lowerBasis === "[::1]" ||
    lowerBasis.startsWith("[::1]:") ||
    lowerBasis === "::1";

  const protocol = istLokalerHost ? "http" : "https";
  return `${protocol}://${dockerBasis}`.replace(/\/+$/, "");
}

async function requestSvws(urlString, benutzer, kennwort, timeoutMs = 5000) {
  const url = new URL(urlString);
  const client = url.protocol === "https:" ? https : http;

  return await new Promise((resolve, reject) => {
    const request = client.request(
      url,
      {
        method: "GET",
        headers: {
          Accept: "application/json",
          Authorization: `Basic ${Buffer.from(`${benutzer}:${kennwort}`).toString("base64")}`,
          "User-Agent": "smedia/1.0 (+school-media-manager)"
        },
        rejectUnauthorized: false
      },
      (response) => {
        let body = "";
        response.setEncoding("utf8");
        response.on("data", (chunk) => {
          body += chunk;
        });
        response.on("end", () => {
          resolve({
            statusCode: response.statusCode || 0,
            body
          });
        });
      }
    );

    request.setTimeout(timeoutMs, () => {
      request.destroy(new Error("RequestTimeout"));
    });

    request.on("error", reject);
    request.end();
  });
}

async function requestSvwsJson(urlString, benutzer, kennwort, timeoutMs = 5000) {
  const response = await requestSvws(urlString, benutzer, kennwort, timeoutMs);
  let data = null;

  if (response.body) {
    try {
      data = JSON.parse(response.body);
    } catch {
      throw new Error(`Ungültige JSON-Antwort von ${urlString}.`);
    }
  }

  return {
    statusCode: response.statusCode,
    data
  };
}

function createSvwsClient({ host, schule, user, passwort }) {
  const basisUrl = `${normalisiereSvwsHost(host)}/db/${encodeURIComponent(String(schule || "").trim())}`;

  return {
    async get(endpoint) {
      const pathPart = String(endpoint || "").startsWith("/") ? endpoint : `/${endpoint || ""}`;
      return await requestSvwsJson(`${basisUrl}${pathPart}`, String(user || "").trim(), String(passwort || ""), 5000);
    }
  };
}

function formatiereDatumFuerImport(wert) {
  if (!wert) return "";
  const text = String(wert).trim();
  if (!text) return "";

  if (/^\d{2}\.\d{2}\.\d{4}$/.test(text)) {
    return text;
  }

  const match = text.match(/^(\d{4})-(\d{2})-(\d{2})/);
  if (match) {
    return `${match[3]}.${match[2]}.${match[1]}`;
  }

  const datum = new Date(text);
  if (Number.isNaN(datum.getTime())) {
    return "";
  }

  return `${String(datum.getDate()).padStart(2, "0")}.${String(datum.getMonth() + 1).padStart(2, "0")}.${datum.getFullYear()}`;
}

function decodiereXmlText(wert) {
  return String(wert || "")
    .replace(/&amp;/g, "&")
    .replace(/&quot;/g, '"')
    .replace(/&apos;/g, "'")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .trim();
}

function extrahiereErstesXmlFeld(xml, muster) {
  const treffer = muster.exec(xml);
  return treffer?.[1] ? decodiereXmlText(treffer[1]) : null;
}

async function sucheGoogleBooksZusatzdaten(titelcode) {
  const bereinigterCode = String(titelcode || "").replace(/[^0-9Xx]/g, "");

  if (!bereinigterCode) {
    return null;
  }

  const googleAntwort = await fetchJsonMitTimeout(
    `https://www.googleapis.com/books/v1/volumes?q=isbn:${encodeURIComponent(bereinigterCode)}`,
    5000
  );
  const eintrag = Array.isArray(googleAntwort?.items) ? googleAntwort.items[0] : null;

  if (!eintrag?.volumeInfo) {
    return null;
  }

  return {
    quelle: "google_books",
    quelle_label: "Google Books",
    titel: eintrag.volumeInfo.title || null,
    untertitel: eintrag.volumeInfo.subtitle || null,
    autoren: Array.isArray(eintrag.volumeInfo.authors) ? eintrag.volumeInfo.authors.filter(Boolean) : [],
    verlag: eintrag.volumeInfo.publisher || null,
    veroeffentlicht: eintrag.volumeInfo.publishedDate || null,
    cover_url:
      eintrag.volumeInfo.imageLinks?.thumbnail ||
      eintrag.volumeInfo.imageLinks?.smallThumbnail ||
      null
  };
}

async function sucheBuchOnline(titelcode) {
  const bereinigterCode = String(titelcode || "").replace(/[^0-9Xx]/g, "");
  const fehler = [];

  if (!bereinigterCode) {
    throw new Error("Titelcode ist leer.");
  }

  let basisTreffer = null;

  try {
    const openLibraryBooks = await fetchJsonMitTimeout(
      `https://openlibrary.org/api/books?bibkeys=ISBN:${encodeURIComponent(
        bereinigterCode
      )}&format=json&jscmd=data`
    );
    const eintrag = openLibraryBooks[`ISBN:${bereinigterCode}`];

    if (eintrag) {
      basisTreffer = {
        quelle: "openlibrary_books_api",
        quelle_label: "Open Library Books API",
        titelcode: bereinigterCode,
        titel: eintrag.title || null,
        untertitel: eintrag.subtitle || null,
        autoren: Array.isArray(eintrag.authors)
          ? eintrag.authors.map((autor) => autor.name).filter(Boolean)
          : [],
        verlag: Array.isArray(eintrag.publishers)
          ? eintrag.publishers.map((verlag) => verlag.name).filter(Boolean).join(", ")
          : null,
        veroeffentlicht: eintrag.publish_date || null
      };
    }
  } catch (error) {
    fehler.push(`Open Library Books API: ${error.message}`);
  }

  if (!basisTreffer) {
    try {
    const suchTreffer = await fetchJsonMitTimeout(
      `https://openlibrary.org/search.json?isbn=${encodeURIComponent(
        bereinigterCode
      )}&fields=title,subtitle,author_name,publisher,publish_date,isbn&limit=1`
    );
    const eintrag = Array.isArray(suchTreffer?.docs) ? suchTreffer.docs[0] : null;

    if (eintrag) {
      basisTreffer = {
        quelle: "openlibrary_search_api",
        quelle_label: "Open Library Search API",
        titelcode: bereinigterCode,
        titel: eintrag.title || null,
        untertitel: eintrag.subtitle || null,
        autoren: Array.isArray(eintrag.author_name) ? eintrag.author_name.filter(Boolean) : [],
        verlag: Array.isArray(eintrag.publisher) ? eintrag.publisher.filter(Boolean).join(", ") : null,
        veroeffentlicht: Array.isArray(eintrag.publish_date)
          ? eintrag.publish_date.filter(Boolean)[0] || null
          : eintrag.publish_date || null
      };
    }
    } catch (error) {
      fehler.push(`Open Library Search API: ${error.message}`);
    }
  }

  if (!basisTreffer) {
    try {
    const dnbXml = await fetchTextMitTimeout(
      `https://services.dnb.de/sru/dnb?version=1.1&operation=searchRetrieve&query=${encodeURIComponent(
        `isbn="${bereinigterCode}"`
      )}&maximumRecords=1&recordSchema=MARC21-xml`
    );

    const anzahlTreffer = Number(extrahiereErstesXmlFeld(dnbXml, /<numberOfRecords>(\d+)<\/numberOfRecords>/i) || 0);

    if (anzahlTreffer > 0) {
      const titel =
        extrahiereErstesXmlFeld(
          dnbXml,
          /<datafield[^>]*tag="245"[^>]*>[\s\S]*?<subfield[^>]*code="a"[^>]*>([\s\S]*?)<\/subfield>/i
        ) ||
        extrahiereErstesXmlFeld(dnbXml, /<titleInfo>[\s\S]*?<title>([\s\S]*?)<\/title>/i);
      const untertitel =
        extrahiereErstesXmlFeld(
          dnbXml,
          /<datafield[^>]*tag="245"[^>]*>[\s\S]*?<subfield[^>]*code="b"[^>]*>([\s\S]*?)<\/subfield>/i
        ) ||
        extrahiereErstesXmlFeld(dnbXml, /<titleInfo>[\s\S]*?<subTitle>([\s\S]*?)<\/subTitle>/i);
      const verlag =
        extrahiereErstesXmlFeld(
          dnbXml,
          /<datafield[^>]*tag="264"[^>]*>[\s\S]*?<subfield[^>]*code="b"[^>]*>([\s\S]*?)<\/subfield>/i
        ) ||
        extrahiereErstesXmlFeld(
          dnbXml,
          /<datafield[^>]*tag="260"[^>]*>[\s\S]*?<subfield[^>]*code="b"[^>]*>([\s\S]*?)<\/subfield>/i
        );
      const autor =
        extrahiereErstesXmlFeld(
          dnbXml,
          /<datafield[^>]*tag="100"[^>]*>[\s\S]*?<subfield[^>]*code="a"[^>]*>([\s\S]*?)<\/subfield>/i
        ) ||
        extrahiereErstesXmlFeld(
          dnbXml,
          /<datafield[^>]*tag="700"[^>]*>[\s\S]*?<subfield[^>]*code="a"[^>]*>([\s\S]*?)<\/subfield>/i
        );
      const veroeffentlicht =
        extrahiereErstesXmlFeld(
          dnbXml,
          /<datafield[^>]*tag="264"[^>]*>[\s\S]*?<subfield[^>]*code="c"[^>]*>([\s\S]*?)<\/subfield>/i
        ) ||
        extrahiereErstesXmlFeld(
          dnbXml,
          /<datafield[^>]*tag="260"[^>]*>[\s\S]*?<subfield[^>]*code="c"[^>]*>([\s\S]*?)<\/subfield>/i
        );

      basisTreffer = {
        quelle: "dnb_sru",
        quelle_label: "Deutsche Nationalbibliothek SRU",
        titelcode: bereinigterCode,
        titel: titel || null,
        untertitel: untertitel || null,
        autoren: autor ? [autor] : [],
        verlag: verlag || null,
        veroeffentlicht: veroeffentlicht || null
      };
    }
    } catch (error) {
      fehler.push(`DNB SRU: ${error.message}`);
    }
  }

  let googleZusatz = null;

  try {
    googleZusatz = await sucheGoogleBooksZusatzdaten(bereinigterCode);
  } catch (error) {
    fehler.push(`Google Books: ${error.message}`);
  }

  if (!basisTreffer && googleZusatz) {
    return {
      titelcode: bereinigterCode,
      ...googleZusatz
    };
  }

  if (basisTreffer) {
    return {
      ...basisTreffer,
      autoren: basisTreffer.autoren?.length ? basisTreffer.autoren : googleZusatz?.autoren || [],
      cover_url: googleZusatz?.cover_url || null
    };
  }

  if (fehler.length > 0) {
    throw new Error(`Online-Suche momentan ohne Treffer oder nicht erreichbar. ${fehler.join(" | ")}`);
  }

  return null;
}

function baueNummernkreis(ausVorlage, fallbackPrefix) {
  const muster = /^(.+?)(\d+)$/.exec(ausVorlage || "");

  if (!muster) {
    return {
      prefix: fallbackPrefix,
      startwert: 1,
      stellen: 3
    };
  }

  return {
    prefix: muster[1],
    startwert: Number(muster[2]),
    stellen: muster[2].length
  };
}

async function ermittleBuchVorlagen(artikelId) {
  const rows = await query(
    `
      SELECT inventarnummer, barcode
      FROM artikel_exemplare
      WHERE artikel_id = ?
      ORDER BY id
      LIMIT 1
    `,
    [artikelId]
  );

  const inventar = baueNummernkreis(rows[0]?.inventarnummer, `BUCH-${artikelId}-`);
  const barcode = baueNummernkreis(rows[0]?.barcode, `B-${artikelId}-`);

  const maxRows = await query(
    `
      SELECT
        MAX(CAST(REGEXP_SUBSTR(inventarnummer, '[0-9]+$') AS UNSIGNED)) AS max_inventarnummer,
        MAX(CAST(REGEXP_SUBSTR(barcode, '[0-9]+$') AS UNSIGNED)) AS max_barcode
      FROM artikel_exemplare
      WHERE artikel_id = ?
    `,
    [artikelId]
  );

  return {
    inventar_prefix: inventar.prefix,
    inventar_stellen: inventar.stellen,
    inventar_startwert: Math.max(inventar.startwert, Number(maxRows[0]?.max_inventarnummer || 0) + 1),
    barcode_prefix: barcode.prefix,
    barcode_stellen: barcode.stellen,
    barcode_startwert: Math.max(barcode.startwert, Number(maxRows[0]?.max_barcode || 0) + 1)
  };
}

async function schreibeHistorie({
  bezug_typ,
  bezug_id = null,
  exemplar_id = null,
  ausleihe_id = null,
  aktion,
  titel,
  details = null,
  ausgeloest_von = "system"
}) {
  await query(
    `
      INSERT INTO historie_eintraege (
        bezug_typ,
        bezug_id,
        exemplar_id,
        ausleihe_id,
        aktion,
        titel,
        details,
        ausgeloest_von
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `,
    [bezug_typ, bezug_id, exemplar_id, ausleihe_id, aktion, titel, details, ausgeloest_von]
  );
}

function schreibeHistorieMitConnection(connection, parameter) {
  const {
    bezug_typ,
    bezug_id = null,
    exemplar_id = null,
    ausleihe_id = null,
    aktion,
    titel,
    details = null,
    ausgeloest_von = "system"
  } = parameter;

  return connection.execute(
    `
      INSERT INTO historie_eintraege (
        bezug_typ,
        bezug_id,
        exemplar_id,
        ausleihe_id,
        aktion,
        titel,
        details,
        ausgeloest_von
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `,
    [bezug_typ, bezug_id, exemplar_id, ausleihe_id, aktion, titel, details, ausgeloest_von]
  );
}

async function synchronisiereAusleiher() {
  const [schuelerResult, lehrkraftResult, klassenResult] = await Promise.all([
    query(
      `
        INSERT INTO ausleiher (
          name,
          ausleiher_typ,
          quelle_typ,
          quelle_id,
          klasse_oder_bereich,
          barcode,
          aktiv
        )
        SELECT
          s.anzeigename,
          'schueler',
          'schueler',
          s.id,
          k.bezeichnung,
          s.barcode,
          s.aktiv
        FROM schueler s
        LEFT JOIN schueler_klassen sk
          ON sk.schueler_id = s.id
         AND sk.ist_aktuell = 1
        LEFT JOIN klassen k
          ON k.id = sk.klassen_id
        ON DUPLICATE KEY UPDATE
          name = VALUES(name),
          klasse_oder_bereich = VALUES(klasse_oder_bereich),
          barcode = VALUES(barcode),
          aktiv = VALUES(aktiv)
      `
    ),
    query(
      `
        INSERT INTO ausleiher (
          name,
          ausleiher_typ,
          quelle_typ,
          quelle_id,
          klasse_oder_bereich,
          barcode,
          aktiv
        )
        SELECT
          l.anzeigename,
          'lehrkraft',
          'lehrkraft',
          l.id,
          l.fachbereich,
          l.barcode,
          l.aktiv
        FROM lehrkraefte l
        ON DUPLICATE KEY UPDATE
          name = VALUES(name),
          klasse_oder_bereich = VALUES(klasse_oder_bereich),
          barcode = VALUES(barcode),
          aktiv = VALUES(aktiv)
      `
    ),
    query(
      `
        INSERT INTO ausleiher (
          name,
          ausleiher_typ,
          quelle_typ,
          quelle_id,
          klasse_oder_bereich,
          barcode,
          aktiv
        )
        SELECT
          CONCAT('Klasse ', k.bezeichnung),
          'klasse',
          'klasse',
          k.id,
          k.stufe,
          CONCAT('K-', UPPER(k.bezeichnung)),
          k.aktiv
        FROM klassen k
        ON DUPLICATE KEY UPDATE
          name = VALUES(name),
          klasse_oder_bereich = VALUES(klasse_oder_bereich),
          barcode = VALUES(barcode),
          aktiv = VALUES(aktiv)
      `
    )
  ]);

  await Promise.all([
    query(
      `
        UPDATE ausleiher a
        LEFT JOIN schueler s ON s.id = a.quelle_id
        SET a.aktiv = 0
        WHERE a.quelle_typ = 'schueler'
          AND (s.id IS NULL OR s.aktiv = 0)
      `
    ),
    query(
      `
        UPDATE ausleiher a
        LEFT JOIN lehrkraefte l ON l.id = a.quelle_id
        SET a.aktiv = 0
        WHERE a.quelle_typ = 'lehrkraft'
          AND (l.id IS NULL OR l.aktiv = 0)
      `
    ),
    query(
      `
        UPDATE ausleiher a
        LEFT JOIN klassen k ON k.id = a.quelle_id
        SET a.aktiv = 0
        WHERE a.quelle_typ = 'klasse'
          AND (k.id IS NULL OR k.aktiv = 0)
      `
    )
  ]);

  return {
    schueler: (schuelerResult.affectedRows || 0),
    lehrkraefte: (lehrkraftResult.affectedRows || 0),
    klassen: (klassenResult.affectedRows || 0)
  };
}

app.get("/api/gesundheit", async (_req, res) => {
  try {
    const rows = await query("SELECT NOW() AS server_zeit");
    res.json({ ok: true, server_zeit: rows[0].server_zeit });
  } catch (error) {
    res.status(500).json({ ok: false, fehler: error.message });
  }
});

app.get("/api/uebersicht", async (_req, res) => {
  try {
    const [kennzahlen, offeneAusleihen] = await Promise.all([
      query(`
        SELECT
          COUNT(*) AS exemplare_gesamt,
          SUM(CASE WHEN sk.bezeichnung = 'verfuegbar' THEN 1 ELSE 0 END) AS verfuegbar,
          SUM(CASE WHEN sk.bezeichnung = 'ausgeliehen' THEN 1 ELSE 0 END) AS ausgeliehen,
          SUM(CASE WHEN sk.bezeichnung IN ('defekt', 'in_reparatur') THEN 1 ELSE 0 END) AS problemfaelle,
          SUM(CASE WHEN it.bezeichnung = 'buch' THEN 1 ELSE 0 END) AS buecher,
          SUM(CASE WHEN it.bezeichnung <> 'buch' THEN 1 ELSE 0 END) AS geraete
        FROM artikel_exemplare ae
        JOIN artikel a ON a.id = ae.artikel_id
        JOIN inventar_typen it ON it.id = a.inventar_typ_id
        JOIN statuskatalog sk ON sk.id = ae.status_id
        WHERE ae.aktiv = 1
      `),
      query(`
        SELECT
          al.id,
          al.exemplar_id,
          al.ausleiher_id,
          ae.artikel_id,
          ae.inventarnummer,
          ae.barcode,
          a.titel,
          ak.kategorie AS artikel_kategorie,
          aus.name AS ausleiher_name,
          aus.ausleiher_typ,
          aus.klasse_oder_bereich,
          s.vorname,
          s.nachname,
          lv.tablet_vertrag_erzeugungsdatum,
          al.ausgabe_am,
          al.faellig_am,
          z.bezeichnung AS zustand_bei_ausgabe
        FROM ausleihen al
        JOIN artikel_exemplare ae ON ae.id = al.exemplar_id
        JOIN artikel a ON a.id = ae.artikel_id
        JOIN ausleiher aus ON aus.id = al.ausleiher_id
        LEFT JOIN artikel_kategorie ak ON ak.id = a.artikel_kategorie_id
        LEFT JOIN schueler s ON s.id = aus.quelle_id AND aus.quelle_typ = 'schueler'
        LEFT JOIN (
          SELECT
            ausleiher_id,
            MAX(erzeugungsdatum) AS tablet_vertrag_erzeugungsdatum
          FROM leihvertraege
          WHERE vertragstyp = 'tablet'
          GROUP BY ausleiher_id
        ) lv ON lv.ausleiher_id = al.ausleiher_id
        JOIN zustandskatalog z ON z.id = al.zustand_bei_ausgabe_id
        WHERE al.status = 'offen'
        ORDER BY al.ausgabe_am DESC
      `)
    ]);

    const offeneAusleihenMitFaelligkeit = offeneAusleihen
      .map((eintrag) => ({
        ...eintrag,
        faelligkeit: berechneFaelligkeitsStatus(eintrag.faellig_am)
      }))
      .sort((links, rechts) => {
        const linksPrioritaet = prioritaetFaelligkeit(links.faelligkeit.status);
        const rechtsPrioritaet = prioritaetFaelligkeit(rechts.faelligkeit.status);

        if (linksPrioritaet !== rechtsPrioritaet) {
          return linksPrioritaet - rechtsPrioritaet;
        }

        const linksZeit = links.faellig_am
          ? new Date(links.faellig_am).getTime()
          : Number.MAX_SAFE_INTEGER;
        const rechtsZeit = rechts.faellig_am
          ? new Date(rechts.faellig_am).getTime()
          : Number.MAX_SAFE_INTEGER;

        return linksZeit - rechtsZeit;
      });

    res.json({
      kennzahlen: kennzahlen[0],
      offene_ausleihen: offeneAusleihenMitFaelligkeit
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/exemplare", async (req, res) => {
  try {
    const typ = req.query.typ || null;
    const nurVerfuegbar = req.query.nur_verfuegbar === "1";
    const rows = await query(
      `
        SELECT
          ae.id,
          ae.artikel_id,
          ae.inventarnummer,
          ae.barcode,
          ae.seriennummer,
          ae.ist_klassensatz,
          ae.klassensatz_name,
          ae.notizen,
          a.titel,
          bd.titelcode,
          bd.autor,
          bd.verlag,
          f.bezeichnung AS fach,
          bd.veroeffentlicht,
          bd.cover_url,
          bd.cover_bild,
          ae.standort_id,
          it.bezeichnung AS inventar_typ,
          st.bezeichnung AS standort,
          sk.bezeichnung AS status,
          zk.bezeichnung AS zustand
        FROM artikel_exemplare ae
        JOIN artikel a ON a.id = ae.artikel_id
        JOIN inventar_typen it ON it.id = a.inventar_typ_id
        JOIN statuskatalog sk ON sk.id = ae.status_id
        JOIN zustandskatalog zk ON zk.id = ae.zustand_id
        LEFT JOIN buch_details bd ON bd.artikel_id = a.id
        LEFT JOIN faecher f ON f.id = bd.fach_id
        LEFT JOIN standorte st ON st.id = ae.standort_id
        WHERE ae.aktiv = 1
          AND (? IS NULL OR it.bezeichnung = ?)
          AND (? = 0 OR sk.bezeichnung = 'verfuegbar')
        ORDER BY a.titel, ae.inventarnummer
      `,
      [typ, typ, nurVerfuegbar ? 1 : 0]
    );

    res.json(rows.map(mapExemplar));
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/historie", async (req, res) => {
  try {
    const limit = Math.min(Math.max(Number(req.query.limit || 20), 1), 500);
    const offset = Math.max(Number(req.query.offset || 0), 0);
    const exemplarId = req.query.exemplar_id ? Number(req.query.exemplar_id) : null;
    const [rows, countRows] = await Promise.all([
      query(
        `
          SELECT
            h.id,
            h.bezug_typ,
            h.bezug_id,
            h.exemplar_id,
            h.ausleihe_id,
            h.aktion,
            h.titel,
            h.details,
            h.ausgeloest_von,
            h.erstellt_am,
            ae.inventarnummer,
            ae.barcode,
            sk.bezeichnung AS status,
            a.titel AS artikel_titel,
            aus.name AS ausleiher_name
          FROM historie_eintraege h
          LEFT JOIN artikel_exemplare ae ON ae.id = h.exemplar_id
          LEFT JOIN statuskatalog sk ON sk.id = ae.status_id
          LEFT JOIN artikel a ON a.id = ae.artikel_id
          LEFT JOIN ausleihen al ON al.id = h.ausleihe_id
          LEFT JOIN ausleiher aus ON aus.id = al.ausleiher_id
          WHERE (? IS NULL OR h.exemplar_id = ?)
          ORDER BY h.erstellt_am DESC, h.id DESC
          LIMIT ?
          OFFSET ?
        `,
        [exemplarId, exemplarId, limit, offset]
      ),
      query(`SELECT COUNT(*) AS gesamt FROM historie_eintraege WHERE (? IS NULL OR exemplar_id = ?)`, [exemplarId, exemplarId])
    ]);
    res.json({ eintraege: rows, gesamt: countRows[0].gesamt });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.delete("/api/historie", async (req, res) => {
  try {
    const tage = Number(req.query.tage);

    if (!Number.isInteger(tage) || tage < 1) {
      return res.status(400).json({ fehler: "Bitte eine gueltige Anzahl von Tagen angeben." });
    }

    const result = await query(
      `
        DELETE FROM historie_eintraege
        WHERE erstellt_am < (NOW() - INTERVAL ? DAY)
      `,
      [tage]
    );

    res.json({
      meldung: `${result.affectedRows || 0} Historie-Eintraege geloescht, die aelter als ${tage} Tage sind.`
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/standorte", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT id, bezeichnung, standort_typ, parent_id, beschreibung, aktiv
      FROM standorte
      ORDER BY bezeichnung
    `);
    res.json(
      rows.map((row) => ({
        id: row.id,
        bezeichnung: row.bezeichnung,
        standort_typ: row.standort_typ,
        parent_id: row.parent_id,
        beschreibung: row.beschreibung,
        aktiv: Boolean(row.aktiv)
      }))
    );
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/faecher", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT id, bezeichnung, kuerzel, aktiv
      FROM faecher
      ORDER BY bezeichnung
    `);
    res.json(
      rows.map((row) => ({
        id: row.id,
        bezeichnung: row.bezeichnung,
        kuerzel: row.kuerzel,
        aktiv: Boolean(row.aktiv)
      }))
    );
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/herkunft", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT id, bezeichnung, notiz, aktiv
      FROM herkunft
      ORDER BY bezeichnung
    `);
    res.json(
      rows.map((row) => ({
        id: row.id,
        bezeichnung: row.bezeichnung,
        notiz: row.notiz,
        aktiv: Boolean(row.aktiv)
      }))
    );
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/faecher", async (req, res) => {
  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const kuerzel = normalisiereTextfeld(req.body?.kuerzel);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM faecher WHERE bezeichnung = ? LIMIT 1`, [bezeichnung]);
    if (vorhanden.length > 0) {
      return res.status(400).json({ fehler: "Dieses Fach existiert bereits." });
    }

    const ergebnis = await query(
      `INSERT INTO faecher (bezeichnung, kuerzel, aktiv) VALUES (?, ?, ?)`,
      [bezeichnung, kuerzel, aktiv]
    );
    const rows = await query(`SELECT id, bezeichnung, kuerzel, aktiv FROM faecher WHERE id = ?`, [ergebnis.insertId]);
    res.status(201).json({
      meldung: "Fach wurde angelegt.",
      datensatz: { ...rows[0], aktiv: Boolean(rows[0]?.aktiv) }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.put("/api/faecher/:id", async (req, res) => {
  const datensatzId = Number(req.params.id);
  if (!datensatzId) {
    return res.status(400).json({ fehler: "Ungueltige Fach-ID." });
  }

  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const kuerzel = normalisiereTextfeld(req.body?.kuerzel);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM faecher WHERE id = ? LIMIT 1`, [datensatzId]);
    if (vorhanden.length === 0) {
      return res.status(404).json({ fehler: "Fach nicht gefunden." });
    }
    const duplikat = await query(`SELECT id FROM faecher WHERE bezeichnung = ? AND id <> ? LIMIT 1`, [bezeichnung, datensatzId]);
    if (duplikat.length > 0) {
      return res.status(400).json({ fehler: "Dieses Fach existiert bereits." });
    }

    await query(`UPDATE faecher SET bezeichnung = ?, kuerzel = ?, aktiv = ? WHERE id = ?`, [bezeichnung, kuerzel, aktiv, datensatzId]);
    const rows = await query(`SELECT id, bezeichnung, kuerzel, aktiv FROM faecher WHERE id = ?`, [datensatzId]);
    res.json({
      meldung: "Fach wurde gespeichert.",
      datensatz: { ...rows[0], aktiv: Boolean(rows[0]?.aktiv) }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/herkunft", async (req, res) => {
  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const notiz = normalisiereTextfeld(req.body?.notiz);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM herkunft WHERE bezeichnung = ? LIMIT 1`, [bezeichnung]);
    if (vorhanden.length > 0) {
      return res.status(400).json({ fehler: "Diese Herkunft existiert bereits." });
    }

    const ergebnis = await query(`INSERT INTO herkunft (bezeichnung, aktiv, notiz) VALUES (?, ?, ?)`, [bezeichnung, aktiv, notiz]);
    const rows = await query(`SELECT id, bezeichnung, notiz, aktiv FROM herkunft WHERE id = ?`, [ergebnis.insertId]);
    res.status(201).json({
      meldung: "Herkunft wurde angelegt.",
      datensatz: { ...rows[0], aktiv: Boolean(rows[0]?.aktiv) }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.put("/api/herkunft/:id", async (req, res) => {
  const datensatzId = Number(req.params.id);
  if (!datensatzId) {
    return res.status(400).json({ fehler: "Ungueltige Herkunft-ID." });
  }

  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const notiz = normalisiereTextfeld(req.body?.notiz);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM herkunft WHERE id = ? LIMIT 1`, [datensatzId]);
    if (vorhanden.length === 0) {
      return res.status(404).json({ fehler: "Herkunft nicht gefunden." });
    }
    const duplikat = await query(`SELECT id FROM herkunft WHERE bezeichnung = ? AND id <> ? LIMIT 1`, [bezeichnung, datensatzId]);
    if (duplikat.length > 0) {
      return res.status(400).json({ fehler: "Diese Herkunft existiert bereits." });
    }

    await query(`UPDATE herkunft SET bezeichnung = ?, aktiv = ?, notiz = ? WHERE id = ?`, [bezeichnung, aktiv, notiz, datensatzId]);
    const rows = await query(`SELECT id, bezeichnung, notiz, aktiv FROM herkunft WHERE id = ?`, [datensatzId]);
    res.json({
      meldung: "Herkunft wurde gespeichert.",
      datensatz: { ...rows[0], aktiv: Boolean(rows[0]?.aktiv) }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/standorte", async (req, res) => {
  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const standortTyp = normalisiereTextfeld(req.body?.standort_typ);
  const parentId = Number(req.body?.parent_id) || null;
  const beschreibung = normalisiereTextfeld(req.body?.beschreibung);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM standorte WHERE bezeichnung = ? LIMIT 1`, [bezeichnung]);
    if (vorhanden.length > 0) {
      return res.status(400).json({ fehler: "Dieser Standort existiert bereits." });
    }

    const ergebnis = await query(
      `INSERT INTO standorte (bezeichnung, standort_typ, parent_id, beschreibung, aktiv) VALUES (?, ?, ?, ?, ?)`,
      [bezeichnung, standortTyp, parentId, beschreibung, aktiv]
    );
    const rows = await query(
      `SELECT id, bezeichnung, standort_typ, parent_id, beschreibung, aktiv FROM standorte WHERE id = ?`,
      [ergebnis.insertId]
    );
    res.status(201).json({
      meldung: "Standort wurde angelegt.",
      datensatz: { ...rows[0], aktiv: Boolean(rows[0]?.aktiv) }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.put("/api/standorte/:id", async (req, res) => {
  const datensatzId = Number(req.params.id);
  if (!datensatzId) {
    return res.status(400).json({ fehler: "Ungueltige Standort-ID." });
  }

  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const standortTyp = normalisiereTextfeld(req.body?.standort_typ);
  const parentId = Number(req.body?.parent_id) || null;
  const beschreibung = normalisiereTextfeld(req.body?.beschreibung);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }
  if (parentId && parentId === datensatzId) {
    return res.status(400).json({ fehler: "Ein Standort kann nicht sein eigener Parent sein." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM standorte WHERE id = ? LIMIT 1`, [datensatzId]);
    if (vorhanden.length === 0) {
      return res.status(404).json({ fehler: "Standort nicht gefunden." });
    }
    const duplikat = await query(`SELECT id FROM standorte WHERE bezeichnung = ? AND id <> ? LIMIT 1`, [bezeichnung, datensatzId]);
    if (duplikat.length > 0) {
      return res.status(400).json({ fehler: "Dieser Standort existiert bereits." });
    }

    await query(
      `UPDATE standorte SET bezeichnung = ?, standort_typ = ?, parent_id = ?, beschreibung = ?, aktiv = ? WHERE id = ?`,
      [bezeichnung, standortTyp, parentId, beschreibung, aktiv, datensatzId]
    );
    const rows = await query(
      `SELECT id, bezeichnung, standort_typ, parent_id, beschreibung, aktiv FROM standorte WHERE id = ?`,
      [datensatzId]
    );
    res.json({
      meldung: "Standort wurde gespeichert.",
      datensatz: { ...rows[0], aktiv: Boolean(rows[0]?.aktiv) }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/schueler", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        s.id,
        s.S_ID as s_id,
        s.vorname,
        s.nachname,
        s.anzeigename,
        s.barcode,
        s.geburtsdatum,
        s.email,
        s.aktiv,
        s.notizen,
        k.id AS klassen_id,
        k.bezeichnung AS klasse,
        sk.schuljahr,
        (SELECT COUNT(*) FROM ausleihen al JOIN ausleiher aus ON al.ausleiher_id = aus.id WHERE aus.quelle_typ = 'schueler' AND aus.quelle_id = s.id AND al.status = 'offen') AS aktive_ausleihen
      FROM schueler s
      LEFT JOIN schueler_klassen sk
        ON sk.schueler_id = s.id
       AND sk.ist_aktuell = 1
      LEFT JOIN klassen k
        ON k.id = sk.klassen_id
      GROUP BY s.id
      ORDER BY s.nachname, s.vorname
    `);

    res.json(rows);
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/klassen", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        k.id,
        k.bezeichnung,
        k.stufe,
        k.parallelklasse,
        k.aktiv,
        COUNT(DISTINCT sk.schueler_id) AS schueler_anzahl
      FROM klassen k
      LEFT JOIN schueler_klassen sk
        ON sk.klassen_id = k.id
       AND sk.ist_aktuell = 1
      GROUP BY k.id, k.bezeichnung, k.stufe, k.parallelklasse, k.aktiv
      ORDER BY k.bezeichnung
    `);

    res.json(rows);
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/lehrkraefte", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        id,
        kuerzel,
        anrede,
        vorname,
        nachname,
        anzeigename,
        barcode,
        email,
        fachbereich,
        aktiv,
        notizen,
        (SELECT COUNT(*) FROM ausleihen al JOIN ausleiher aus ON al.ausleiher_id = aus.id WHERE aus.quelle_typ = 'lehrkraft' AND aus.quelle_id = lehrkraefte.id AND al.status = 'offen') AS aktive_ausleihen
      FROM lehrkraefte
      ORDER BY nachname, vorname
    `);

    res.json(rows);
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/einstellungen", async (_req, res) => {
  try {
    const [benutzer, geraete, buecher] = await Promise.all([
      ladeEinstellungenBereich("benutzer"),
      ladeEinstellungenBereich("geraete"),
      ladeEinstellungenBereich("buecher")
    ]);

    res.json({ benutzer, geraete, buecher });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/ausgabe-assistent/vorschau", async (req, res) => {
  const klasseAusleiherId = Number(req.body?.klasse_ausleiher_id);
  const artikelId = Number(req.body?.artikel_id);

  if (!klasseAusleiherId || !artikelId) {
    return res.status(400).json({ fehler: "Klasse und Artikel sind erforderlich." });
  }

  let connection;
  try {
    connection = await getConnection();
    const vorschau = await erstelleAusgabeAssistentVorschau(connection, klasseAusleiherId, artikelId);
    res.json(vorschau);
  } catch (error) {
    res.status(400).json({ fehler: error.message });
  } finally {
    connection?.release();
  }
});

app.post("/api/ausgabe-assistent/uebernehmen", async (req, res) => {
  const klasseAusleiherId = Number(req.body?.klasse_ausleiher_id);
  const artikelId = Number(req.body?.artikel_id);
  const faelligAm = normalisiereTextfeld(req.body?.faellig_am || "");
  const kommentarAusgabe = normalisiereTextfeld(req.body?.kommentar_ausgabe || "");
  const zeilen = Array.isArray(req.body?.zeilen) ? req.body.zeilen : [];

  if (!klasseAusleiherId || !artikelId) {
    return res.status(400).json({ fehler: "Klasse und Artikel sind erforderlich." });
  }

  let connection;

  try {
    connection = await getConnection();
    await connection.beginTransaction();

    const kontext = await ladeAusgabeAssistentKontext(connection, klasseAusleiherId, artikelId);
    const vorschau = await erstelleAusgabeAssistentVorschau(connection, klasseAusleiherId, artikelId);
    const clientZeilenMap = new Map(
      zeilen.map((eintrag) => [String(eintrag.listen_id || ""), eintrag]).filter(([key]) => Boolean(key))
    );

    const speicherbareZeilen = vorschau.zeilen.map((eintrag) => {
      const clientEintrag = clientZeilenMap.get(String(eintrag.listen_id || ""));
      const aktiviert = eintrag.aktivierbar
        ? normalisiereBooleanWert(clientEintrag?.aktiv)
        : false;

      return {
        ...eintrag,
        aktiv: aktiviert
      };
    });

    const aktiveZeilen = speicherbareZeilen.filter((eintrag) => eintrag.aktiv && eintrag.aktivierbar && eintrag.exemplar_id);
    const exemplarIds = [...new Set(aktiveZeilen.map((eintrag) => Number(eintrag.exemplar_id)).filter(Boolean))];
    const ausleiherIds = [...new Set(aktiveZeilen.map((eintrag) => Number(eintrag.schueler_ausleiher_id)).filter(Boolean))];

    if (aktiveZeilen.length > 0) {
      if (exemplarIds.length !== aktiveZeilen.length) {
        await connection.rollback();
        return res.status(400).json({ fehler: "Jede aktive Zeile muss genau ein Exemplar enthalten." });
      }

      const exemplarPlatzhalter = exemplarIds.map(() => "?").join(", ");
      const [exemplarRows] = await connection.execute(
        `
          SELECT
            ae.id,
            ae.inventarnummer,
            ae.zustand_id,
            sk.bezeichnung AS status,
            a.titel
          FROM artikel_exemplare ae
          JOIN statuskatalog sk ON sk.id = ae.status_id
          JOIN artikel a ON a.id = ae.artikel_id
          WHERE ae.id IN (${exemplarPlatzhalter})
            AND ae.artikel_id = ?
            AND ae.aktiv = 1
          FOR UPDATE
        `,
        [...exemplarIds, artikelId]
      );

      if (exemplarRows.length !== exemplarIds.length) {
        await connection.rollback();
        return res.status(409).json({ fehler: "Mindestens ein ausgewaehltes Exemplar passt nicht mehr zum Artikel." });
      }

      const nichtVerfuegbare = exemplarRows.filter((eintrag) => eintrag.status !== "verfuegbar");
      if (nichtVerfuegbare.length > 0) {
        await connection.rollback();
        return res.status(409).json({
          fehler: `Diese Exemplare sind nicht mehr verfuegbar: ${nichtVerfuegbare.map((eintrag) => eintrag.inventarnummer).join(", ")}.`
        });
      }

      const ausleiherPlatzhalter = ausleiherIds.map(() => "?").join(", ");
      const [ausleiherRows] = await connection.execute(
        `
          SELECT a.id, a.name, a.ausleiher_typ
          FROM ausleiher a
          JOIN schueler_klassen sk ON sk.schueler_id = a.quelle_id AND sk.ist_aktuell = 1
          WHERE a.id IN (${ausleiherPlatzhalter})
            AND a.quelle_typ = 'schueler'
            AND a.aktiv = 1
            AND sk.klassen_id = ?
        `,
        [...ausleiherIds, kontext.klasse.quelle_id]
      );

      if (ausleiherRows.length !== ausleiherIds.length) {
        await connection.rollback();
        return res.status(409).json({ fehler: "Mindestens ein Schueler gehoert nicht mehr zur ausgewaehlten Klasse." });
      }

      const exemplarMap = new Map(exemplarRows.map((eintrag) => [Number(eintrag.id), eintrag]));
      const ausleiherMap = new Map(ausleiherRows.map((eintrag) => [Number(eintrag.id), eintrag]));
      const wirksameFaelligkeit = berechneStandardFaelligkeit("schueler", faelligAm);

      for (const zeile of aktiveZeilen) {
        const exemplar = exemplarMap.get(Number(zeile.exemplar_id));
        const ausleiher = ausleiherMap.get(Number(zeile.schueler_ausleiher_id));

        if (!exemplar || !ausleiher) {
          await connection.rollback();
          return res.status(409).json({ fehler: "Zuordnung konnte wegen veralteter Daten nicht gespeichert werden." });
        }

        const [insertResult] = await connection.execute(
          `
            INSERT INTO ausleihen (
              exemplar_id,
              ausleiher_id,
              faellig_am,
              zustand_bei_ausgabe_id,
              kommentar_ausgabe
            )
            VALUES (?, ?, ?, ?, ?)
          `,
          [
            exemplar.id,
            ausleiher.id,
            wirksameFaelligkeit,
            exemplar.zustand_id,
            kommentarAusgabe || null
          ]
        );

        await connection.execute(
          `
            UPDATE artikel_exemplare ae
            JOIN statuskatalog sk ON sk.bezeichnung = 'ausgeliehen'
            SET ae.status_id = sk.id
            WHERE ae.id = ?
          `,
          [exemplar.id]
        );

        await schreibeHistorieMitConnection(connection, {
          bezug_typ: "ausleihe",
          bezug_id: insertResult.insertId,
          exemplar_id: exemplar.id,
          ausleihe_id: insertResult.insertId,
          aktion: "ausgabe_assistent_ausgabe",
          titel: `Ausgabe-Assistent: ${exemplar.inventarnummer}`,
          details: `${exemplar.titel} wurde an ${ausleiher.name} ausgegeben. Faellig am ${wirksameFaelligkeit}.`,
          ausgeloest_von: "weboberflaeche"
        });

        await schreibeHistorieMitConnection(connection, {
          bezug_typ: "exemplar",
          bezug_id: exemplar.id,
          exemplar_id: exemplar.id,
          ausleihe_id: insertResult.insertId,
          aktion: "status_aenderung",
          titel: `Status geaendert: ${exemplar.inventarnummer}`,
          details: `${exemplar.titel} wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.`,
          ausgeloest_von: "weboberflaeche"
        });
      }

      await connection.commit();

      const rueckgabeZeilen = speicherbareZeilen.map((eintrag) => ({
        ...eintrag,
        status:
          eintrag.aktiv && eintrag.aktivierbar && eintrag.exemplar_id
            ? "zugeordnet"
            : eintrag.status === "vorgeschlagen"
              ? "deaktiviert"
              : eintrag.status
      }));

      return res.json({
        meldung:
          aktiveZeilen.length > 0
            ? `${aktiveZeilen.length} Ausleihen wurden erstellt.`
            : "Es wurden keine neuen Ausleihen erzeugt.",
        klasse_name: kontext.klasse.klassenname || kontext.klasse.name,
        artikel_titel: kontext.artikel.titel || "",
        faellig_am: berechneStandardFaelligkeit("schueler", faelligAm),
        kommentar_ausgabe: kommentarAusgabe || "",
        statistik: {
          gesamt: rueckgabeZeilen.length,
          zugeordnet: rueckgabeZeilen.filter((eintrag) => eintrag.status === "zugeordnet").length,
          bereits_ausgeliehen: rueckgabeZeilen.filter((eintrag) => eintrag.status === "bereits ausgeliehen").length,
          deaktiviert: rueckgabeZeilen.filter((eintrag) => eintrag.status === "deaktiviert").length,
          nicht_versorgt: rueckgabeZeilen.filter((eintrag) => eintrag.status === "nicht versorgt").length
        },
        zeilen: rueckgabeZeilen
      });
    }

    await connection.commit();
    res.json({
      meldung: "Es wurden keine neuen Ausleihen erzeugt.",
      klasse_name: kontext.klasse.klassenname || kontext.klasse.name,
      artikel_titel: kontext.artikel.titel || "",
      faellig_am: berechneStandardFaelligkeit("schueler", faelligAm),
      kommentar_ausgabe: kommentarAusgabe || "",
      statistik: {
        gesamt: speicherbareZeilen.length,
        zugeordnet: 0,
        bereits_ausgeliehen: speicherbareZeilen.filter((eintrag) => eintrag.status === "bereits ausgeliehen").length,
        deaktiviert: speicherbareZeilen.filter((eintrag) => eintrag.status === "vorgeschlagen").length,
        nicht_versorgt: speicherbareZeilen.filter((eintrag) => eintrag.status === "nicht versorgt").length
      },
      zeilen: speicherbareZeilen.map((eintrag) => ({
        ...eintrag,
        status: eintrag.status === "vorgeschlagen" ? "deaktiviert" : eintrag.status
      }))
    });
  } catch (error) {
    if (connection) {
      await connection.rollback();
    }
    res.status(400).json({ fehler: error.message });
  } finally {
    connection?.release();
  }
});

app.post("/api/ausgabe-assistent/druck", async (req, res) => {
  const klasseName = String(req.body?.klasse_name || "").trim();
  const artikelTitel = String(req.body?.artikel_titel || "").trim();
  const kommentarAusgabe = normalisiereTextfeld(req.body?.kommentar_ausgabe || "");
  const faelligAm = normalisiereTextfeld(req.body?.faellig_am || "");
  const zeilen = Array.isArray(req.body?.zeilen) ? req.body.zeilen : [];

  if (!klasseName || !artikelTitel) {
    return res.status(400).json({ fehler: "Klasse und Artikel fuer den Druck sind erforderlich." });
  }

  try {
    const pdfBuffer = await erzeugeAssistentPdf({
      dokumentTitel: "Ausgabe-Assistent",
      klasseName,
      artikelTitel,
      metaZeileLinks: `Erzeugt: ${formatiereAnzeigeZeitstempel()}`,
      metaZeileRechts: `Faellig am: ${formatiereAnzeigeDatum(faelligAm) || "-"}`,
      faelligAm,
      kommentarAusgabe,
      zeilen: zeilen.map((eintrag) => ({
        schueler_name: String(eintrag?.schueler_name || "").trim() || "-",
        klasse: String(eintrag?.klasse || "").trim() || klasseName,
        inventarnummer: String(eintrag?.inventarnummer || "").trim() || "-",
        seriennummer: String(eintrag?.seriennummer || "").trim() || "-",
        barcode: String(eintrag?.barcode || "").trim() || "-",
        status: String(eintrag?.status || "").trim() || "-"
      }))
    });

    res.type("application/pdf");
    res.setHeader("Content-Disposition", 'inline; filename="ausgabe-assistent-zuordnung.pdf"');
    res.send(pdfBuffer);
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/storno-assistent/vorschau", async (req, res) => {
  const klasseAusleiherId = Number(req.body?.klasse_ausleiher_id);
  const artikelId = Number(req.body?.artikel_id);

  if (!klasseAusleiherId || !artikelId) {
    return res.status(400).json({ fehler: "Klasse und Artikel sind erforderlich." });
  }

  let connection;
  try {
    connection = await getConnection();
    const vorschau = await erstelleStornoAssistentVorschau(connection, klasseAusleiherId, artikelId);
    res.json(vorschau);
  } catch (error) {
    res.status(400).json({ fehler: error.message });
  } finally {
    connection?.release();
  }
});

app.post("/api/storno-assistent/uebernehmen", async (req, res) => {
  const klasseAusleiherId = Number(req.body?.klasse_ausleiher_id);
  const artikelId = Number(req.body?.artikel_id);
  const kommentarRueckgabe = normalisiereTextfeld(req.body?.kommentar_rueckgabe || "");
  const zustandBeiRueckgabe = normalisiereTextfeld(req.body?.zustand_bei_rueckgabe || "");
  const zeilen = Array.isArray(req.body?.zeilen) ? req.body.zeilen : [];

  if (!klasseAusleiherId || !artikelId || !zustandBeiRueckgabe) {
    return res.status(400).json({ fehler: "Klasse, Artikel und Rueckgabezustand sind erforderlich." });
  }

  let connection;

  try {
    connection = await getConnection();
    await connection.beginTransaction();

    const kontext = await ladeAusgabeAssistentKontext(connection, klasseAusleiherId, artikelId);
    const vorschau = await erstelleStornoAssistentVorschau(connection, klasseAusleiherId, artikelId);
    const clientZeilenMap = new Map(
      zeilen.map((eintrag) => [String(eintrag.listen_id || ""), eintrag]).filter(([key]) => Boolean(key))
    );

    const rueckgabeZustandRows = await connection.execute(
      `
        SELECT id
        FROM zustandskatalog
        WHERE bezeichnung = ?
        LIMIT 1
      `,
      [zustandBeiRueckgabe]
    );
    const rueckgabeZustandId = rueckgabeZustandRows[0]?.[0]?.id;

    if (!rueckgabeZustandId) {
      await connection.rollback();
      return res.status(400).json({ fehler: "Rueckgabezustand ist ungueltig." });
    }

    const speicherbareZeilen = vorschau.zeilen.map((eintrag) => {
      const clientEintrag = clientZeilenMap.get(String(eintrag.listen_id || ""));
      const aktiviert = eintrag.aktivierbar ? normalisiereBooleanWert(clientEintrag?.aktiv) : false;

      return {
        ...eintrag,
        aktiv: aktiviert
      };
    });

    const aktiveZeilen = speicherbareZeilen.filter((eintrag) => eintrag.aktiv && eintrag.aktivierbar && eintrag.ausleihe_id);
    const ausleiheIds = [...new Set(aktiveZeilen.map((eintrag) => Number(eintrag.ausleihe_id)).filter(Boolean))];

    if (aktiveZeilen.length > 0) {
      const platzhalter = ausleiheIds.map(() => "?").join(", ");
      const [ausleihRows] = await connection.execute(
        `
          SELECT
            al.id,
            al.exemplar_id,
            al.ausleiher_id,
            al.status,
            ae.inventarnummer,
            a.titel AS artikel_titel
          FROM ausleihen al
          JOIN artikel_exemplare ae ON ae.id = al.exemplar_id
          JOIN artikel a ON a.id = ae.artikel_id
          WHERE al.id IN (${platzhalter})
            AND ae.artikel_id = ?
          FOR UPDATE
        `,
        [...ausleiheIds, artikelId]
      );

      if (ausleihRows.length !== ausleiheIds.length) {
        await connection.rollback();
        return res.status(409).json({ fehler: "Mindestens eine offene Buchung ist nicht mehr verfuegbar." });
      }

      const nichtOffen = ausleihRows.filter((eintrag) => eintrag.status !== "offen");
      if (nichtOffen.length > 0) {
        await connection.rollback();
        return res.status(409).json({ fehler: "Mindestens eine Buchung wurde bereits abgeschlossen." });
      }

      const neuerStatus = zustandBeiRueckgabe === "beschaedigt" ? "defekt" : "verfuegbar";
      const ausleihMap = new Map(ausleihRows.map((eintrag) => [Number(eintrag.id), eintrag]));

      for (const zeile of aktiveZeilen) {
        const ausleihe = ausleihMap.get(Number(zeile.ausleihe_id));
        if (!ausleihe) {
          await connection.rollback();
          return res.status(409).json({ fehler: "Storno konnte wegen veralteter Daten nicht gespeichert werden." });
        }

        await connection.execute(
          `
            UPDATE ausleihen
            SET
              rueckgabe_am = NOW(),
              zustand_bei_rueckgabe_id = ?,
              kommentar_rueckgabe = ?,
              status = 'zurueckgegeben'
            WHERE id = ?
          `,
          [rueckgabeZustandId, kommentarRueckgabe || null, ausleihe.id]
        );

        await connection.execute(
          `
            UPDATE artikel_exemplare ae
            JOIN statuskatalog sk ON sk.bezeichnung = ?
            JOIN zustandskatalog zk ON zk.bezeichnung = ?
            SET
              ae.status_id = sk.id,
              ae.zustand_id = zk.id
            WHERE ae.id = ?
          `,
          [neuerStatus, zustandBeiRueckgabe, ausleihe.exemplar_id]
        );

        await schreibeHistorieMitConnection(connection, {
          bezug_typ: "ausleihe",
          bezug_id: ausleihe.id,
          exemplar_id: ausleihe.exemplar_id,
          ausleihe_id: ausleihe.id,
          aktion: "storno_assistent_rueckgabe",
          titel: `Storno-Assistent: ${ausleihe.inventarnummer}`,
          details: `${ausleihe.artikel_titel} wurde gesammelt zurueckgenommen. Zustand: ${zustandBeiRueckgabe}.${kommentarRueckgabe ? ` Kommentar: ${kommentarRueckgabe}` : ""}`,
          ausgeloest_von: "weboberflaeche"
        });

        await schreibeHistorieMitConnection(connection, {
          bezug_typ: "exemplar",
          bezug_id: ausleihe.exemplar_id,
          exemplar_id: ausleihe.exemplar_id,
          ausleihe_id: ausleihe.id,
          aktion: "status_aenderung",
          titel: `Status geaendert: ${ausleihe.inventarnummer}`,
          details: `${ausleihe.artikel_titel} wurde durch den Storno-Assistenten auf ${neuerStatus} gesetzt.`,
          ausgeloest_von: "weboberflaeche"
        });
      }
    }

    await connection.commit();

    const rueckgabeZeilen = speicherbareZeilen.map((eintrag) => ({
      ...eintrag,
      status:
        eintrag.aktiv && eintrag.aktivierbar && eintrag.ausleihe_id
          ? "storniert"
          : eintrag.status === "offene Buchung"
            ? "deaktiviert"
            : eintrag.status
    }));

    res.json({
      meldung:
        aktiveZeilen.length > 0
          ? `${aktiveZeilen.length} Buchungen wurden aufgehoben.`
          : "Es wurden keine Buchungen aufgehoben.",
      klasse_name: kontext.klasse.klassenname || kontext.klasse.name,
      artikel_titel: kontext.artikel.titel || "",
      zustand_bei_rueckgabe: zustandBeiRueckgabe,
      kommentar_rueckgabe: kommentarRueckgabe || "",
      statistik: {
        gesamt: rueckgabeZeilen.length,
        storniert: rueckgabeZeilen.filter((eintrag) => eintrag.status === "storniert").length,
        deaktiviert: rueckgabeZeilen.filter((eintrag) => eintrag.status === "deaktiviert").length,
        keine_offene_buchung: rueckgabeZeilen.filter((eintrag) => eintrag.status === "keine offene Buchung").length
      },
      zeilen: rueckgabeZeilen
    });
  } catch (error) {
    if (connection) {
      await connection.rollback();
    }
    res.status(400).json({ fehler: error.message });
  } finally {
    connection?.release();
  }
});

app.post("/api/storno-assistent/druck", async (req, res) => {
  const klasseName = String(req.body?.klasse_name || "").trim();
  const artikelTitel = String(req.body?.artikel_titel || "").trim();
  const kommentarRueckgabe = normalisiereTextfeld(req.body?.kommentar_rueckgabe || "");
  const zustandBeiRueckgabe = normalisiereTextfeld(req.body?.zustand_bei_rueckgabe || "");
  const zeilen = Array.isArray(req.body?.zeilen) ? req.body.zeilen : [];

  if (!klasseName || !artikelTitel) {
    return res.status(400).json({ fehler: "Klasse und Artikel fuer den Druck sind erforderlich." });
  }

  try {
    const pdfBuffer = await erzeugeAssistentPdf({
      dokumentTitel: "Storno-Assistent",
      klasseName,
      artikelTitel,
      metaZeileLinks: `Erzeugt: ${formatiereAnzeigeZeitstempel()}`,
      metaZeileRechts: `Rueckgabezustand: ${zustandBeiRueckgabe || "-"}`,
      kommentarAusgabe: kommentarRueckgabe,
      zeilen: zeilen.map((eintrag) => ({
        schueler_name: String(eintrag?.schueler_name || "").trim() || "-",
        klasse: String(eintrag?.klasse || "").trim() || klasseName,
        inventarnummer: String(eintrag?.inventarnummer || "").trim() || "-",
        seriennummer: String(eintrag?.seriennummer || "").trim() || "-",
        barcode: String(eintrag?.barcode || "").trim() || "-",
        status: String(eintrag?.status || "").trim() || "-"
      }))
    });

    res.type("application/pdf");
    res.setHeader("Content-Disposition", 'inline; filename="storno-assistent-zuordnung.pdf"');
    res.send(pdfBuffer);
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/vertragsvorlagen", async (_req, res) => {
  try {
    const vorlagen = await listAllContractTemplates();
    res.json(vorlagen);
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/vertragsvorlagen/aktiv", async (_req, res) => {
  try {
    const vorlagen = await listActiveContractTemplates();
    res.json(vorlagen);
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/vertragsvorlagen", async (req, res) => {
  const {
    typ,
    name,
    sections,
    briefkopf_png,
    briefkopf_pfad,
    briefkopf_upload,
    seitenrand_oben_mm,
    seitenrand_rechts_mm,
    seitenrand_unten_mm,
    seitenrand_links_mm
  } = req.body || {};

  try {
    const vorlage = await createContractTemplateVersion({
      typ,
      name,
      sections,
      briefkopf_png,
      briefkopf_pfad,
      briefkopf_upload,
      seitenrand_oben_mm,
      seitenrand_rechts_mm,
      seitenrand_unten_mm,
      seitenrand_links_mm
    });
    res.status(201).json({
      meldung: "Neue Vertragsversion gespeichert und aktiviert.",
      vorlage
    });
  } catch (error) {
    res.status(400).json({ fehler: error.message });
  }
});

app.put("/api/vertragsvorlagen/:id", async (req, res) => {
  const {
    typ,
    name,
    sections,
    briefkopf_png,
    briefkopf_pfad,
    briefkopf_upload,
    seitenrand_oben_mm,
    seitenrand_rechts_mm,
    seitenrand_unten_mm,
    seitenrand_links_mm
  } = req.body || {};

  try {
    const vorlage = await updateContractTemplate({
      templateId: req.params.id,
      typ,
      name,
      sections,
      briefkopf_png,
      briefkopf_pfad,
      briefkopf_upload,
      seitenrand_oben_mm,
      seitenrand_rechts_mm,
      seitenrand_unten_mm,
      seitenrand_links_mm
    });
    res.json({
      meldung: "Formatierung der Vertragsvorlage gespeichert.",
      vorlage
    });
  } catch (error) {
    res.status(400).json({ fehler: error.message });
  }
});

app.get("/api/leihvertraege/ausleiher/:id/geraete", async (req, res) => {
  try {
    const daten = await getBorrowerContractContext(req.params.id);
    res.json(daten);
  } catch (error) {
    const statusCode = error.message.includes("nicht gefunden") ? 404 : 400;
    res.status(statusCode).json({ fehler: error.message });
  }
});

app.post("/api/leihvertraege", async (req, res) => {
  const { ausleiher_id, vertragstyp, artikel_exemplar_ids } = req.body || {};

  try {
    const vertrag = await createLoanContract({
      ausleiherId: ausleiher_id,
      vertragstyp,
      artikelExemplarIds: artikel_exemplar_ids
    });

    res.status(201).json({
      meldung: "Leihvertrag wurde erzeugt und gespeichert.",
      vertrag,
      download_url: `/api/leihvertraege/${vertrag.id}/pdf`
    });
  } catch (error) {
    res.status(400).json({ fehler: error.message });
  }
});

app.post("/api/leihvertraege/export", async (req, res) => {
  const { vertrag_ids, modus } = req.body || {};

  try {
    const contractIds = Array.isArray(vertrag_ids)
      ? [...new Set(vertrag_ids.map((value) => Number(value)).filter(Boolean))]
      : [];

    if (contractIds.length === 0) {
      throw new Error("Mindestens eine gueltige Vertrags-ID ist erforderlich.");
    }

    const exportModus = String(modus || "preview").toLowerCase();
    if (!["preview", "zip"].includes(exportModus)) {
      throw new Error("Ungueltiger Exportmodus.");
    }

    const vertraege = await Promise.all(contractIds.map((id) => getStoredLoanContract(id)));
    const pdfDateien = await Promise.all(
      vertraege.map(async (vertrag) => {
        const absolutePath = resolveStoredContractPath(vertrag.pdf_pfad);
        const buffer = await fs.readFile(absolutePath);
        return {
          id: vertrag.id,
          dateiname: path.basename(absolutePath),
          buffer
        };
      })
    );

    if (exportModus === "preview") {
      const mergedPdf = await PDFDocument.create();

      for (const pdfDatei of pdfDateien) {
        const sourcePdf = await PDFDocument.load(pdfDatei.buffer);
        const pageIndices = sourcePdf.getPageIndices();
        const copiedPages = await mergedPdf.copyPages(sourcePdf, pageIndices);
        copiedPages.forEach((page) => mergedPdf.addPage(page));
      }

      const mergedBuffer = Buffer.from(await mergedPdf.save());
      res.type("application/pdf");
      res.setHeader("Content-Disposition", 'inline; filename="tabletvertraege-vorschau.pdf"');
      res.send(mergedBuffer);
      return;
    }

    const zipFile = new yazl.ZipFile();
    for (const pdfDatei of pdfDateien) {
      zipFile.addBuffer(pdfDatei.buffer, pdfDatei.dateiname);
    }
    zipFile.end();

    res.type("application/zip");
    res.setHeader("Content-Disposition", 'attachment; filename="tabletvertraege.zip"');
    zipFile.outputStream.pipe(res);
  } catch (error) {
    const statusCode = error.message.includes("nicht gefunden") ? 404 : 400;
    res.status(statusCode).json({ fehler: error.message });
  }
});

app.get("/api/leihvertraege/:id/pdf", async (req, res) => {
  try {
    const vertrag = await getStoredLoanContract(req.params.id);
    const absolutePath = resolveStoredContractPath(vertrag.pdf_pfad);
    await fs.access(absolutePath);

    res.type("application/pdf");
    res.setHeader(
      "Content-Disposition",
      `inline; filename="${path.basename(absolutePath)}"`
    );
    res.sendFile(absolutePath);
  } catch (error) {
    const statusCode = error.message.includes("nicht gefunden") ? 404 : 400;
    res.status(statusCode).json({ fehler: error.message });
  }
});

app.post("/api/svws/verbindung-testen", async (req, res) => {
  const { host, schule, user, passwort } = req.body || {};
  const basisUrl = normalisiereSvwsHost(host);
  const schema = String(schule || "").trim();
  const benutzer = String(user || "").trim();
  const kennwort = String(passwort || "");

  if (!basisUrl || !schema || !benutzer) {
    return res.status(400).json({ fehler: "Host, Schule und User werden benötigt." });
  }

  const url = `${basisUrl}/db/${encodeURIComponent(schema)}/schule/stammdaten`;

  try {
    const response = await requestSvws(url, benutzer, kennwort, 5000);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return res.status(400).json({
        ok: false,
        fehler: `SVWS-Endpunkt nicht erreichbar (HTTP ${response.statusCode}).`
      });
    }

    return res.json({
      ok: true,
      meldung: "SVWS-Verbindung erfolgreich geprüft."
    });
  } catch (error) {
    const fehlerCode = error?.cause?.code || error?.code || "";
    const ursacheText = error?.cause?.message || "";
    let fehlerText = "";

    if (error?.message === "RequestTimeout") {
      fehlerText = `Zeitüberschreitung beim Verbindungsaufbau zu ${url}.`;
    } else if (fehlerCode === "ECONNREFUSED") {
      fehlerText = `Verbindung zu ${url} abgelehnt. Bitte Host, Port und laufenden SVWS-Server prüfen.`;
      if (laeuftInDockerContainer() && /localhost|127\.0\.0\.1/.test(String(host || ""))) {
        fehlerText += " Bei Docker bitte den SVWS-Host des Rechners oder host.docker.internal verwenden.";
      }
    } else if (fehlerCode === "ENOTFOUND") {
      fehlerText = `Host für ${url} wurde nicht gefunden. Bitte Hostangabe prüfen.`;
    } else if (fehlerCode === "EHOSTUNREACH") {
      fehlerText = `Host ${basisUrl} ist nicht erreichbar. Bitte Netzwerk und Server prüfen.`;
    } else if (fehlerCode === "DEPTH_ZERO_SELF_SIGNED_CERT" || fehlerCode === "SELF_SIGNED_CERT_IN_CHAIN") {
      fehlerText = `HTTPS-Zertifikat für ${basisUrl} wird nicht vertraut (${fehlerCode}).`;
    } else {
      fehlerText = error?.message
        ? `Verbindungsfehler zu ${url}: ${error.message}${ursacheText ? ` (${ursacheText})` : ""}`
        : `Unbekannter Fehler beim Verbindungsaufbau zu ${url}.`;
    }

    return res.status(400).json({
      ok: false,
      fehler: fehlerText
    });
  }
});

app.post("/api/svws/schueler-import", async (req, res) => {
  const { host, schule, user, passwort } = req.body || {};
  const basisUrl = normalisiereSvwsHost(host);
  const schema = String(schule || "").trim();
  const benutzer = String(user || "").trim();

  if (!basisUrl || !schema || !benutzer) {
    return res.status(400).json({ fehler: "Host, Schule und User werden benÃ¶tigt." });
  }

  let connection;
  try {
    const client = createSvwsClient({ host, schule, user, passwort });
    const klassenListe = await loadKlassenUndSchueler(client);
    const schueler = klassenListe.flatMap((klasse) =>
        klasse.schueler.map((eintrag) => ({
          s_id: eintrag.id,
          vorname: eintrag.vorname || "",
          nachname: eintrag.nachname || "",
          klasse: klasse.kuerzel || "",
          email: eintrag.email || "",
          geburtsdatum: formatiereDatumFuerImport(
            eintrag.geburtsdatum ?? eintrag.geburtsdatumAnzeige ?? eintrag.geburtstag ?? eintrag.datumGeburt ?? ""
          )
      }))
    );

    if (schueler.length === 0) {
      return res.status(400).json({ fehler: "SVWS hat keine importierbaren SchÃ¼lerdaten geliefert." });
    }

    connection = await getConnection();
    await connection.beginTransaction();
    const { eingefuegt, aktualisiert } = await importiereSchuelerDatensaetze(connection, schueler);
    await connection.commit();

    return res.json({
      meldung: `${eingefuegt} SchÃ¼ler neu angelegt, ${aktualisiert} aktualisiert.`,
      gesamt: schueler.length,
      klassen: klassenListe.length
    });
  } catch (error) {
    if (connection) await connection.rollback();
    return res.status(500).json({ fehler: error.message });
  } finally {
    if (connection) connection.release();
  }
});

app.post("/api/svws/schueler-vorschau", async (req, res) => {
  const { host, schule, user, passwort } = req.body || {};
  const basisUrl = normalisiereSvwsHost(host);
  const schema = String(schule || "").trim();
  const benutzer = String(user || "").trim();

  if (!basisUrl || !schema || !benutzer) {
    return res.status(400).json({ fehler: "Host, Schule und User werden benÃ¶tigt." });
  }

  try {
    const client = createSvwsClient({ host, schule, user, passwort });
    const klassenListe = await loadKlassenUndSchueler(client);
    const schueler = klassenListe.flatMap((klasse) =>
        klasse.schueler.map((eintrag) => ({
          s_id: eintrag.id,
          vorname: eintrag.vorname || "",
          nachname: eintrag.nachname || "",
          klasse: klasse.kuerzel || "",
          email: eintrag.email || "",
          geburtsdatum: formatiereDatumFuerImport(
            eintrag.geburtsdatum ?? eintrag.geburtsdatumAnzeige ?? eintrag.geburtstag ?? eintrag.datumGeburt ?? ""
          )
      }))
    );

    return res.json({
      schueler,
      gesamt: schueler.length,
      klassen: klassenListe.length
    });
  } catch (error) {
    return res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/schueler/import", async (req, res) => {
  const { schueler } = req.body;
  if (!Array.isArray(schueler) || schueler.length === 0) {
    return res.status(400).json({ fehler: "Keine SchÃ¼lerdaten Ã¼bergeben." });
  }

  let connection;
  try {
    connection = await getConnection();
    await connection.beginTransaction();
    const { eingefuegt, aktualisiert } = await importiereSchuelerDatensaetze(connection, schueler);
    await connection.commit();
    return res.json({ meldung: `${eingefuegt} SchÃ¼ler neu angelegt, ${aktualisiert} aktualisiert.` });
  } catch (error) {
    if (connection) await connection.rollback();
    return res.status(500).json({ fehler: error.message });
  } finally {
    if (connection) connection.release();
  }
});

app.patch("/api/schueler/:id", async (req, res) => {
  const schuelerId = Number(req.params.id);

  if (!schuelerId) {
    return res.status(400).json({ fehler: "Gueltige Schueler-ID erforderlich." });
  }

  const {
    vorname,
    nachname,
    anzeigename,
    barcode,
    geburtsdatum,
    email,
    aktiv,
    notizen,
    klassen_id,
    schuljahr
  } = req.body || {};

  let connection;

  try {
    connection = await getConnection();
    await connection.beginTransaction();

    const [rows] = await connection.execute(
      `
        SELECT id
        FROM schueler
        WHERE id = ?
      `,
      [schuelerId]
    );

    if (rows.length === 0) {
      await connection.rollback();
      return res.status(404).json({ fehler: "Schueler nicht gefunden." });
    }

    await connection.execute(
      `
        UPDATE schueler
        SET
          vorname = ?,
          nachname = ?,
          anzeigename = ?,
          barcode = ?,
          geburtsdatum = ?,
          email = ?,
          aktiv = ?,
          notizen = ?
        WHERE id = ?
      `,
      [
        normalisiereTextfeld(vorname) || "",
        normalisiereTextfeld(nachname) || "",
        normalisiereTextfeld(anzeigename) || "",
        normalisiereTextfeld(barcode),
        geburtsdatum || null,
        normalisiereTextfeld(email),
        normalisiereBooleanWert(aktiv) ? 1 : 0,
        normalisiereTextfeld(notizen),
        schuelerId
      ]
    );

    await connection.execute(
      `
        UPDATE schueler_klassen
        SET ist_aktuell = 0
        WHERE schueler_id = ? AND ist_aktuell = 1
      `,
      [schuelerId]
    );

    if (Number(klassen_id)) {
      await connection.execute(
        `
          INSERT INTO schueler_klassen (
            schueler_id,
            klassen_id,
            schuljahr,
            ist_aktuell
          )
          VALUES (?, ?, ?, 1)
        `,
        [schuelerId, Number(klassen_id), normalisiereTextfeld(schuljahr) || new Date().getFullYear().toString()]
      );
    }

    await connection.commit();
    await synchronisiereAusleiher();
    res.json({ meldung: "Schueler aktualisiert." });
  } catch (error) {
    if (connection) {
      await connection.rollback();
    }
    res.status(500).json({ fehler: error.message });
  } finally {
    if (connection) {
      connection.release();
    }
  }
});

app.delete("/api/schueler", async (req, res) => {
  const { ids } = req.body;
  
  if (!Array.isArray(ids) || ids.length === 0) {
    return res.status(400).json({ fehler: "Gueltige Schueler-IDs erforderlich." });
  }

  let connection;
  try {
    connection = await getConnection();
    await connection.beginTransaction();

    // Students may be deleted as long as they do not have open loans.
    const [eligibleRows] = await connection.query(`
      SELECT DISTINCT s.id 
      FROM schueler s
      LEFT JOIN ausleiher a ON a.quelle_typ = 'schueler' AND a.quelle_id = s.id
      LEFT JOIN ausleihen al ON al.ausleiher_id = a.id AND al.status = 'offen'
      WHERE s.id IN (?)
        AND al.id IS NULL
    `, [ids]);
    
    const eligibleIds = eligibleRows.map(row => row.id);

    if (eligibleIds.length === 0) {
      await connection.rollback();
      return res.status(400).json({ fehler: "Die ausgewählten Schüler können nicht gelöscht werden, solange offene Ausleihen vorhanden sind. Bitte zuerst alle offenen Ausleihen abschließen oder zurückgeben." });
    }

    const [ausleiherRows] = await connection.query(
      `SELECT id FROM ausleiher WHERE quelle_typ = 'schueler' AND quelle_id IN (?)`,
      [eligibleIds]
    );
    const ausleiherIds = ausleiherRows.map((row) => row.id);

    if (ausleiherIds.length > 0) {
      const [ausleihenRows] = await connection.query(
        `SELECT id FROM ausleihen WHERE ausleiher_id IN (?)`,
        [ausleiherIds]
      );
      const ausleihenIds = ausleihenRows.map((row) => row.id);

      if (ausleihenIds.length > 0) {
        const [schadenRows] = await connection.query(
          `SELECT id FROM schadensmeldungen WHERE ausleihe_id IN (?) OR gemeldet_von_ausleiher_id IN (?)`,
          [ausleihenIds, ausleiherIds]
        );
        const schadenIds = schadenRows.map((row) => row.id);

        if (schadenIds.length > 0) {
          await connection.query(`DELETE FROM reparaturen WHERE schadensmeldung_id IN (?)`, [schadenIds]);
          await connection.query(`DELETE FROM schadensmeldungen WHERE id IN (?)`, [schadenIds]);
        } else {
          await connection.query(`DELETE FROM schadensmeldungen WHERE gemeldet_von_ausleiher_id IN (?)`, [ausleiherIds]);
        }

        await connection.query(`DELETE FROM historie_eintraege WHERE ausleihe_id IN (?)`, [ausleihenIds]);
        await connection.query(`DELETE FROM ausleihen WHERE ausleiher_id IN (?)`, [ausleiherIds]);
      } else {
        await connection.query(`DELETE FROM schadensmeldungen WHERE gemeldet_von_ausleiher_id IN (?)`, [ausleiherIds]);
      }

      await connection.query(
        `DELETE FROM historie_eintraege WHERE bezug_typ = 'schueler' AND bezug_id IN (?)`,
        [eligibleIds]
      );
    }

    await connection.query(`DELETE FROM schueler_klassen WHERE schueler_id IN (?)`, [eligibleIds]);
    await connection.query(`DELETE FROM ausleiher WHERE quelle_typ = 'schueler' AND quelle_id IN (?)`, [eligibleIds]);
    await connection.query(`DELETE FROM schueler WHERE id IN (?)`, [eligibleIds]);

    await connection.commit();
    
    if (eligibleIds.length < ids.length) {
      res.json({ meldung: `${eligibleIds.length} Schüler gelöscht. ${ids.length - eligibleIds.length} Schüler konnten wegen offener Ausleihen nicht gelöscht werden.` });
    } else {
      res.json({ meldung: `${eligibleIds.length} Schüler erfolgreich gelöscht.` });
    }
  } catch (error) {
    if (connection) await connection.rollback();
    res.status(500).json({ fehler: error.message });
  } finally {
    if (connection) connection.release();
  }
});

function parseGermanDate(dateStr) {
  if (!dateStr) return null;
  const parts = String(dateStr).trim().split(".");
  if (parts.length === 3) {
    return `${parts[2]}-${parts[1].padStart(2, "0")}-${parts[0].padStart(2, "0")}`;
  }
  return null;
}

async function importiereSchuelerDatensaetze(connection, schueler) {
  let eingefuegt = 0;
  let aktualisiert = 0;

  for (const s of schueler) {
    if (!s.vorname || !s.nachname) continue;

    const s_id_num = s.s_id ? parseInt(s.s_id, 10) : null;
    if (Number.isNaN(s_id_num) || s_id_num === null) continue;

    let schueler_db_id = null;
    let barcode_str = String(s_id_num);

    const [existing] = await connection.query(`SELECT id, email FROM schueler WHERE S_ID = ?`, [s_id_num]);
    if (existing.length > 0) {
      schueler_db_id = existing[0].id;
    }

    if (existing.length > 0) {
      await connection.query(
        `
          UPDATE schueler 
          SET vorname = ?, nachname = ?, anzeigename = ?, geburtsdatum = ?, barcode = ?, email = ?, aktiv = 1
          WHERE S_ID = ?
        `,
        [s.vorname, s.nachname, `${s.nachname}, ${s.vorname}`, s.geburtsdatum ? parseGermanDate(s.geburtsdatum) : null, barcode_str, normalisiereTextfeld(s.email), s_id_num]
      );
      aktualisiert++;
    }

    if (!schueler_db_id) {
      const [result] = await connection.query(
        `
          INSERT INTO schueler (S_ID, vorname, nachname, anzeigename, geburtsdatum, barcode, email, aktiv)
          VALUES (?, ?, ?, ?, ?, ?, ?, 1)
        `,
        [s_id_num, s.vorname, s.nachname, `${s.nachname}, ${s.vorname}`, s.geburtsdatum ? parseGermanDate(s.geburtsdatum) : null, barcode_str, normalisiereTextfeld(s.email)]
      );
      schueler_db_id = result.insertId;
      eingefuegt++;
    }

    if (!barcode_str) {
      barcode_str = `S-${schueler_db_id}`;
      await connection.query(`UPDATE schueler SET barcode = ? WHERE id = ?`, [barcode_str, schueler_db_id]);
    }

    if (s.klasse) {
      const klasseName = String(s.klasse).trim();
      if (klasseName) {
        let klassen_id = null;
        const [klasseRow] = await connection.query(`SELECT id FROM klassen WHERE bezeichnung = ?`, [klasseName]);

        if (klasseRow.length > 0) {
          klassen_id = klasseRow[0].id;
        } else {
          const [insertRes] = await connection.query(
            `INSERT INTO klassen (bezeichnung, stufe, parallelklasse, aktiv) VALUES (?, '', '', 1)`,
            [klasseName]
          );
          klassen_id = insertRes.insertId;
        }

        await connection.query(`UPDATE schueler_klassen SET ist_aktuell = 0 WHERE schueler_id = ?`, [schueler_db_id]);
        await connection.query(
          `
            INSERT INTO schueler_klassen (schueler_id, klassen_id, schuljahr, ist_aktuell)
            VALUES (?, ?, '24/25', 1)
          `,
          [schueler_db_id, klassen_id]
        );
      }
    }

    const [aktuelleKlasse] = await connection.query(
      `
        SELECT k.bezeichnung 
        FROM schueler_klassen sk 
        JOIN klassen k ON k.id = sk.klassen_id 
        WHERE sk.schueler_id = ? AND sk.ist_aktuell = 1
      `,
      [schueler_db_id]
    );
    const klasse_oder_bereich = aktuelleKlasse.length > 0 ? aktuelleKlasse[0].bezeichnung : null;

    const [ausleiherCheck] = await connection.query(`SELECT id FROM ausleiher WHERE quelle_typ = 'schueler' AND quelle_id = ?`, [schueler_db_id]);
    if (ausleiherCheck.length === 0) {
      await connection.query(
        `
          INSERT INTO ausleiher (name, ausleiher_typ, quelle_typ, quelle_id, klasse_oder_bereich, barcode, aktiv)
          VALUES (?, 'schueler', 'schueler', ?, ?, ?, 1)
        `,
        [`${s.nachname}, ${s.vorname}`, schueler_db_id, klasse_oder_bereich, barcode_str]
      );
    } else {
      await connection.query(
        `
          UPDATE ausleiher SET name = ?, klasse_oder_bereich = ?, barcode = ?, aktiv = 1 WHERE id = ?
        `,
        [`${s.nachname}, ${s.vorname}`, klasse_oder_bereich, barcode_str, ausleiherCheck[0].id]
      );
    }
  }

  return { eingefuegt, aktualisiert };
}

app.post("/api/schueler/import", async (req, res) => {
  const { schueler } = req.body;
  if (!Array.isArray(schueler) || schueler.length === 0) {
    return res.status(400).json({ fehler: "Keine Schülerdaten übergeben." });
  }

  const parseGermanDate = (dateStr) => {
    if (!dateStr) return null;
    const parts = dateStr.trim().split('.');
    if (parts.length === 3) {
      return `${parts[2]}-${parts[1].padStart(2, '0')}-${parts[0].padStart(2, '0')}`;
    }
    return null;
  };

  let connection;
  try {
    connection = await getConnection();
    await connection.beginTransaction();

    let eingefuegt = 0;
    let aktualisiert = 0;

    for (const s of schueler) {
      if (!s.vorname || !s.nachname) continue;

      let s_id_num = s.s_id ? parseInt(s.s_id, 10) : null;
      if (isNaN(s_id_num) || s_id_num === null) continue; // S-ID is mandatory

      let schueler_db_id = null;

      let barcode_str = String(s_id_num);

      const [existing] = await connection.query(`SELECT id FROM schueler WHERE S_ID = ?`, [s_id_num]);
        if (existing.length > 0) {
          schueler_db_id = existing[0].id;
          await connection.query(`
            UPDATE schueler 
            SET vorname = ?, nachname = ?, anzeigename = ?, geburtsdatum = ?, barcode = ?, email = ?, aktiv = 1
            WHERE S_ID = ?
          `, [s.vorname, s.nachname, `${s.nachname}, ${s.vorname}`, s.geburtsdatum ? parseGermanDate(s.geburtsdatum) : null, barcode_str, s.email || null, s_id_num]);
          aktualisiert++;
        }

      if (!schueler_db_id) {
        const [result] = await connection.query(`
          INSERT INTO schueler (S_ID, vorname, nachname, anzeigename, geburtsdatum, barcode, email, aktiv)
          VALUES (?, ?, ?, ?, ?, ?, ?, 1)
        `, [s_id_num, s.vorname, s.nachname, `${s.nachname}, ${s.vorname}`, s.geburtsdatum ? parseGermanDate(s.geburtsdatum) : null, barcode_str, s.email || null]);
        schueler_db_id = result.insertId;
        eingefuegt++;
      }

      if (!barcode_str) {
        barcode_str = "S-" + schueler_db_id;
        await connection.query(`UPDATE schueler SET barcode = ? WHERE id = ?`, [barcode_str, schueler_db_id]);
      }

      if (s.klasse) {
        const klasseName = s.klasse.trim();
        if (klasseName) {
          let klassen_id = null;
          const [klasseRow] = await connection.query(`SELECT id FROM klassen WHERE bezeichnung = ?`, [klasseName]);
          
          if (klasseRow.length > 0) {
            klassen_id = klasseRow[0].id;
          } else {
            // Auto-create missing class so the student and ausleiher get it assigned correctly
            const [insertRes] = await connection.query(
              `INSERT INTO klassen (bezeichnung, stufe, parallelklasse, aktiv) VALUES (?, '', '', 1)`,
              [klasseName]
            );
            klassen_id = insertRes.insertId;
          }

          await connection.query(`UPDATE schueler_klassen SET ist_aktuell = 0 WHERE schueler_id = ?`, [schueler_db_id]);
          await connection.query(`
            INSERT INTO schueler_klassen (schueler_id, klassen_id, schuljahr, ist_aktuell)
            VALUES (?, ?, '24/25', 1)
          `, [schueler_db_id, klassen_id]);
        }
      }

      const [aktuelleKlasse] = await connection.query(`
        SELECT k.bezeichnung 
        FROM schueler_klassen sk 
        JOIN klassen k ON k.id = sk.klassen_id 
        WHERE sk.schueler_id = ? AND sk.ist_aktuell = 1
      `, [schueler_db_id]);
      const klasse_oder_bereich = aktuelleKlasse.length > 0 ? aktuelleKlasse[0].bezeichnung : null;

      // Synchronize ausleiher
      const [ausleiherCheck] = await connection.query(`SELECT id FROM ausleiher WHERE quelle_typ = 'schueler' AND quelle_id = ?`, [schueler_db_id]);
      if (ausleiherCheck.length === 0) {
        await connection.query(`
          INSERT INTO ausleiher (name, ausleiher_typ, quelle_typ, quelle_id, klasse_oder_bereich, barcode, aktiv)
          VALUES (?, 'schueler', 'schueler', ?, ?, ?, 1)
        `, [`${s.nachname}, ${s.vorname}`, schueler_db_id, klasse_oder_bereich, barcode_str]);
      } else {
        await connection.query(`
          UPDATE ausleiher SET name = ?, klasse_oder_bereich = ?, barcode = ?, aktiv = 1 WHERE id = ?
        `, [`${s.nachname}, ${s.vorname}`, klasse_oder_bereich, barcode_str, ausleiherCheck[0].id]);
      }
    }

    await connection.commit();
    res.json({ meldung: `${eingefuegt} Schüler neu angelegt, ${aktualisiert} aktualisiert.` });
  } catch (error) {
    if (connection) await connection.rollback();
    res.status(500).json({ fehler: error.message });
  } finally {
    if (connection) connection.release();
  }
});

app.post("/api/lehrkraefte/import", async (req, res) => {
  const { lehrer } = req.body;
  if (!Array.isArray(lehrer) || lehrer.length === 0) {
    return res.status(400).json({ fehler: "Keine Lehrkraftdaten übergeben." });
  }

  let connection;
  try {
    connection = await getConnection();
    await connection.beginTransaction();

    let eingefuegt = 0;
    let aktualisiert = 0;

    for (const l of lehrer) {
      if (!l.id || !l.vorname || !l.nachname || !l.kuerzel) continue;

      const lehrerId = Number(l.id);
      if (!Number.isInteger(lehrerId) || lehrerId <= 0) continue;

      const kuerzel = l.kuerzel.trim();
      let lehrer_db_id = null;
      let barcode_str = String(kuerzel);

      const [existing] = await connection.query(`SELECT id, barcode FROM lehrkraefte WHERE id = ?`, [lehrerId]);
      if (existing.length > 0) {
        lehrer_db_id = existing[0].id;
        barcode_str = existing[0].barcode || (await ermittleNaechstenLehrkraftBarcode(connection, kuerzel));
        await connection.query(`
          UPDATE lehrkraefte 
          SET kuerzel = ?, anrede = ?, vorname = ?, nachname = ?, anzeigename = ?, email = ?, fachbereich = ?, barcode = ?, aktiv = 1
          WHERE id = ?
        `, [kuerzel, l.anrede || null, l.vorname, l.nachname, `${l.nachname}, ${l.vorname}`, l.email || null, l.fachbereich || null, barcode_str, lehrerId]);
        aktualisiert++;
      }

      if (!lehrer_db_id) {
        barcode_str = await ermittleNaechstenLehrkraftBarcode(connection, kuerzel);
        await connection.query(`
          INSERT INTO lehrkraefte (id, kuerzel, anrede, vorname, nachname, anzeigename, email, fachbereich, barcode, aktiv)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
        `, [lehrerId, kuerzel, l.anrede || null, l.vorname, l.nachname, `${l.nachname}, ${l.vorname}`, l.email || null, l.fachbereich || null, barcode_str]);
        lehrer_db_id = lehrerId;
        eingefuegt++;
      }

      // Synchronize ausleiher
      const [ausleiherCheck] = await connection.query(`SELECT id FROM ausleiher WHERE quelle_typ = 'lehrkraft' AND quelle_id = ?`, [lehrer_db_id]);
      if (ausleiherCheck.length === 0) {
        await connection.query(`
          INSERT INTO ausleiher (name, ausleiher_typ, quelle_typ, quelle_id, klasse_oder_bereich, barcode, aktiv)
          VALUES (?, 'lehrkraft', 'lehrkraft', ?, ?, ?, 1)
        `, [`${l.nachname}, ${l.vorname}`, lehrer_db_id, l.fachbereich || null, barcode_str]);
      } else {
        await connection.query(`
          UPDATE ausleiher SET name = ?, klasse_oder_bereich = ?, barcode = ?, aktiv = 1 WHERE id = ?
        `, [`${l.nachname}, ${l.vorname}`, l.fachbereich || null, barcode_str, ausleiherCheck[0].id]);
      }
    }

    await connection.commit();
    res.json({ meldung: `${eingefuegt} Lehrkräfte neu angelegt, ${aktualisiert} aktualisiert.` });
  } catch (error) {
    if (connection) await connection.rollback();
    res.status(500).json({ fehler: error.message });
  } finally {
    if (connection) connection.release();
  }
});

app.patch("/api/klassen/:id", async (req, res) => {
  const klassenId = Number(req.params.id);

  if (!klassenId) {
    return res.status(400).json({ fehler: "Gueltige Klassen-ID erforderlich." });
  }

  const { bezeichnung, stufe, parallelklasse, aktiv } = req.body || {};

  try {
    const rows = await query(`SELECT id FROM klassen WHERE id = ?`, [klassenId]);

    if (rows.length === 0) {
      return res.status(404).json({ fehler: "Klasse nicht gefunden." });
    }

    await query(
      `
        UPDATE klassen
        SET
          bezeichnung = ?,
          stufe = ?,
          parallelklasse = ?,
          aktiv = ?
        WHERE id = ?
      `,
      [
        normalisiereTextfeld(bezeichnung) || "",
        normalisiereTextfeld(stufe) || "",
        normalisiereTextfeld(parallelklasse),
        normalisiereBooleanWert(aktiv) ? 1 : 0,
        klassenId
      ]
    );

    await synchronisiereAusleiher();
    res.json({ meldung: "Klasse aktualisiert." });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.patch("/api/lehrkraefte/:id", async (req, res) => {
  const lehrkraftId = Number(req.params.id);

  if (!lehrkraftId) {
    return res.status(400).json({ fehler: "Gueltige Lehrkraft-ID erforderlich." });
  }

  const {
    kuerzel,
    anrede,
    vorname,
    nachname,
    anzeigename,
    barcode,
    email,
    fachbereich,
    aktiv,
    notizen
  } = req.body || {};

  try {
    const rows = await query(`SELECT id FROM lehrkraefte WHERE id = ?`, [lehrkraftId]);

    if (rows.length === 0) {
      return res.status(404).json({ fehler: "Lehrkraft nicht gefunden." });
    }

    await query(
      `
        UPDATE lehrkraefte
        SET
          kuerzel = ?,
          anrede = ?,
          vorname = ?,
          nachname = ?,
          anzeigename = ?,
          barcode = ?,
          email = ?,
          fachbereich = ?,
          aktiv = ?,
          notizen = ?
        WHERE id = ?
      `,
      [
        normalisiereTextfeld(kuerzel),
        normalisiereTextfeld(anrede),
        normalisiereTextfeld(vorname) || "",
        normalisiereTextfeld(nachname) || "",
        normalisiereTextfeld(anzeigename) || "",
        normalisiereTextfeld(barcode),
        normalisiereTextfeld(email),
        normalisiereTextfeld(fachbereich),
        normalisiereBooleanWert(aktiv) ? 1 : 0,
        normalisiereTextfeld(notizen),
        lehrkraftId
      ]
    );

    await synchronisiereAusleiher();
    res.json({ meldung: "Lehrkraft aktualisiert." });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.put("/api/einstellungen/:bereich", async (req, res) => {
  const bereich = String(req.params.bereich || "").trim().toLowerCase();

  if (!STANDARD_EINSTELLUNGEN[bereich]) {
    return res.status(404).json({ fehler: "Einstellungsbereich nicht gefunden." });
  }

  try {
    const gespeichert = await speichereEinstellungenBereich(bereich, req.body || {});
    res.json({ meldung: "Einstellungen gespeichert.", bereich, daten: gespeichert });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/buecher/titelcode/:titelcode", async (req, res) => {
  const titelcode = String(req.params.titelcode || "").trim();

  if (!titelcode) {
    return res.status(400).json({ fehler: "Titelcode ist erforderlich." });
  }

  try {
    const rows = await query(
      `
        SELECT
          a.id AS artikel_id,
          a.titel,
          bd.titelcode,
          bd.autor,
          bd.verlag,
          bd.fach_id,
          f.bezeichnung AS fach,
          bd.veroeffentlicht,
          bd.cover_url,
          bd.cover_bild,
          bd.jahrgangsstufe,
          bd.ist_arbeitsheft,
          bd.ist_lehrerversion,
          bd.herkunft_id,
          h.bezeichnung AS herkunft,
          COUNT(ae.id) AS exemplare_gesamt,
          SUM(CASE WHEN ae.ist_klassensatz = 1 THEN 1 ELSE 0 END) AS klassensatz_exemplare,
          GROUP_CONCAT(DISTINCT ae.klassensatz_name ORDER BY ae.klassensatz_name SEPARATOR '||') AS klassensatz_namen
        FROM buch_details bd
        JOIN artikel a ON a.id = bd.artikel_id
        LEFT JOIN faecher f ON f.id = bd.fach_id
        LEFT JOIN herkunft h ON h.id = bd.herkunft_id
        LEFT JOIN artikel_exemplare ae ON ae.artikel_id = a.id
        WHERE bd.titelcode = ?
        GROUP BY a.id, a.titel, bd.titelcode, bd.autor, bd.verlag, bd.fach_id, f.bezeichnung, bd.veroeffentlicht, bd.cover_url, bd.cover_bild, bd.jahrgangsstufe, bd.ist_arbeitsheft, bd.ist_lehrerversion, bd.herkunft_id, h.bezeichnung
      `,
      [titelcode]
    );

    if (rows.length === 0) {
      return res.status(404).json({ fehler: "Kein Buchtitel zu diesem Titelcode gefunden." });
    }

    const vorlagen = await ermittleBuchVorlagen(rows[0].artikel_id);
    const buch = rows[0];

    res.json({
      artikel_id: buch.artikel_id,
      titel: buch.titel,
      titelcode: buch.titelcode,
      autor: buch.autor,
      verlag: buch.verlag,
      fach_id: buch.fach_id,
      fach: buch.fach,
      cover_url: buch.cover_url,
      cover_bild: buch.cover_bild,
      veroeffentlicht: buch.veroeffentlicht,
      jahrgangsstufe: buch.jahrgangsstufe,
      ist_arbeitsheft: buch.ist_arbeitsheft === 1,
      ist_lehrerversion: buch.ist_lehrerversion === 1,
      herkunft_id: buch.herkunft_id,
      herkunft: buch.herkunft,
      exemplare_gesamt: Number(buch.exemplare_gesamt || 0),
      klassensatz_exemplare: Number(buch.klassensatz_exemplare || 0),
      klassensatz_namen: buch.klassensatz_namen ? buch.klassensatz_namen.split("||") : [],
      nummernkreis: vorlagen
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.delete("/api/lehrkraefte/:id", async (req, res) => {
  const lehrkraftId = Number(req.params.id);

  if (!lehrkraftId) {
    return res.status(400).json({ fehler: "Gueltige Lehrkraft-ID erforderlich." });
  }

  let connection;
  try {
    connection = await getConnection();
    await connection.beginTransaction();

    const [eligibleRows] = await connection.query(
      `
        SELECT l.id, a.id AS ausleiher_id
        FROM lehrkraefte l
        LEFT JOIN ausleiher a ON a.quelle_typ = 'lehrkraft' AND a.quelle_id = l.id
        LEFT JOIN ausleihen al ON al.ausleiher_id = a.id
        LEFT JOIN schadensmeldungen sm ON sm.gemeldet_von_ausleiher_id = a.id
        WHERE l.id = ?
          AND al.id IS NULL
          AND sm.id IS NULL
        GROUP BY l.id, a.id
      `,
      [lehrkraftId]
    );

    if (eligibleRows.length === 0) {
      await connection.rollback();
      return res.status(400).json({
        fehler: "Die Lehrkraft kann nicht geloescht werden, da Ausleihen oder Historieneintraege vorhanden sind. Bitte stattdessen auf inaktiv setzen."
      });
    }

    await connection.query(`DELETE FROM ausleiher WHERE quelle_typ = 'lehrkraft' AND quelle_id = ?`, [lehrkraftId]);
    await connection.query(`DELETE FROM lehrkraefte WHERE id = ?`, [lehrkraftId]);

    await connection.commit();
    res.json({ meldung: "Lehrkraft erfolgreich geloescht." });
  } catch (error) {
    if (connection) await connection.rollback();
    res.status(500).json({ fehler: error.message });
  } finally {
    if (connection) connection.release();
  }
});

app.get("/api/buecher", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        a.id AS artikel_id,
        a.titel,
        bd.titelcode,
        bd.autor,
        bd.verlag,
        bd.fach_id,
        f.bezeichnung AS fach,
        bd.veroeffentlicht,
        bd.cover_url,
        bd.jahrgangsstufe,
        bd.schuljahr_ausgabe,
        bd.ist_arbeitsheft,
        bd.ist_lehrerversion,
        bd.herkunft_id,
        h.bezeichnung AS herkunft,
        COUNT(ae.id) AS exemplare_gesamt
      FROM buch_details bd
      JOIN artikel a ON a.id = bd.artikel_id
      LEFT JOIN faecher f ON f.id = bd.fach_id
      LEFT JOIN herkunft h ON h.id = bd.herkunft_id
      LEFT JOIN artikel_exemplare ae ON ae.artikel_id = a.id
      GROUP BY a.id, a.titel, bd.titelcode, bd.autor, bd.verlag, bd.fach_id, f.bezeichnung,
               bd.veroeffentlicht, bd.cover_url, bd.jahrgangsstufe, bd.schuljahr_ausgabe,
               bd.ist_arbeitsheft, bd.ist_lehrerversion, bd.herkunft_id, h.bezeichnung
      ORDER BY a.titel
    `);

    res.json(rows.map(b => ({
      id: b.artikel_id,
      artikel_id: b.artikel_id,
      titel: b.titel,
      titelcode: b.titelcode || "",
      autor: b.autor || "",
      verlag: b.verlag || "",
      fach_id: b.fach_id,
      fach: b.fach || "",
      veroeffentlicht: b.veroeffentlicht || "",
      cover_url: b.cover_url || "",
      jahrgangsstufe: b.jahrgangsstufe || "",
      schuljahr_ausgabe: b.schuljahr_ausgabe || "",
      ist_arbeitsheft: b.ist_arbeitsheft === 1,
      ist_lehrerversion: b.ist_lehrerversion === 1,
      herkunft_id: b.herkunft_id,
      herkunft: b.herkunft || "",
      exemplare_gesamt: Number(b.exemplare_gesamt || 0)
    })));
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/artikel", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        a.id,
        a.inventar_typ_id,
        it.bezeichnung AS inventar_typ,
        a.titel,
        a.interne_bezeichnung,
        a.beschreibung,
        a.hersteller,
        a.modellbezeichnung,
        a.herkunft_id,
        h.bezeichnung AS herkunft,
        a.artikel_kategorie_id,
        ak.kategorie AS artikel_kategorie,
        a.aktiv,
        a.erstellt_am,
        a.aktualisiert_am
      FROM artikel a
      LEFT JOIN inventar_typen it ON it.id = a.inventar_typ_id
      LEFT JOIN herkunft h ON h.id = a.herkunft_id
      LEFT JOIN artikel_kategorie ak ON ak.id = a.artikel_kategorie_id
      ORDER BY a.titel, a.id
    `);

    res.json(rows.map((artikel) => ({
      id: artikel.id,
      inventar_typ_id: artikel.inventar_typ_id,
      inventar_typ: artikel.inventar_typ || "",
      titel: artikel.titel || "",
      interne_bezeichnung: artikel.interne_bezeichnung || "",
      beschreibung: artikel.beschreibung || "",
      hersteller: artikel.hersteller || "",
      modellbezeichnung: artikel.modellbezeichnung || "",
      herkunft_id: artikel.herkunft_id,
      herkunft: artikel.herkunft || "",
      artikel_kategorie_id: artikel.artikel_kategorie_id,
      artikel_kategorie: artikel.artikel_kategorie || "",
      aktiv: artikel.aktiv === 1,
      erstellt_am: artikel.erstellt_am,
      aktualisiert_am: artikel.aktualisiert_am
    })));
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/statuskatalog", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT id, bezeichnung, beschreibung, aktiv, ist_ausleihbar
      FROM statuskatalog
      ORDER BY bezeichnung
    `);
    res.json(
      rows.map((row) => ({
        id: row.id,
        bezeichnung: row.bezeichnung,
        beschreibung: row.beschreibung,
        aktiv: Boolean(row.aktiv),
        ist_ausleihbar: Boolean(row.ist_ausleihbar)
      }))
    );
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/zustandskatalog", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT id, bezeichnung, beschreibung, aktiv, sortierung
      FROM zustandskatalog
      ORDER BY sortierung, bezeichnung
    `);
    res.json(
      rows.map((row) => ({
        id: row.id,
        bezeichnung: row.bezeichnung,
        beschreibung: row.beschreibung,
        aktiv: Boolean(row.aktiv),
        sortierung: row.sortierung
      }))
    );
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/zustandskatalog", async (req, res) => {
  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const beschreibung = normalisiereTextfeld(req.body?.beschreibung);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);
  const sortierung = Number(req.body?.sortierung) || 0;

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM zustandskatalog WHERE bezeichnung = ? LIMIT 1`, [bezeichnung]);
    if (vorhanden.length > 0) {
      return res.status(400).json({ fehler: "Dieser Zustand existiert bereits." });
    }

    const ergebnis = await query(
      `INSERT INTO zustandskatalog (bezeichnung, beschreibung, aktiv, sortierung) VALUES (?, ?, ?, ?)`,
      [bezeichnung, beschreibung, aktiv, sortierung]
    );
    const rows = await query(
      `SELECT id, bezeichnung, beschreibung, aktiv, sortierung FROM zustandskatalog WHERE id = ?`,
      [ergebnis.insertId]
    );
    res.status(201).json({
      meldung: "Zustand wurde angelegt.",
      datensatz: {
        ...rows[0],
        aktiv: Boolean(rows[0]?.aktiv)
      }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.put("/api/zustandskatalog/:id", async (req, res) => {
  const datensatzId = Number(req.params.id);
  if (!datensatzId) {
    return res.status(400).json({ fehler: "Ungueltige Zustands-ID." });
  }

  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const beschreibung = normalisiereTextfeld(req.body?.beschreibung);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);
  const sortierung = Number(req.body?.sortierung) || 0;

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM zustandskatalog WHERE id = ? LIMIT 1`, [datensatzId]);
    if (vorhanden.length === 0) {
      return res.status(404).json({ fehler: "Zustand nicht gefunden." });
    }
    const duplikat = await query(`SELECT id FROM zustandskatalog WHERE bezeichnung = ? AND id <> ? LIMIT 1`, [bezeichnung, datensatzId]);
    if (duplikat.length > 0) {
      return res.status(400).json({ fehler: "Dieser Zustand existiert bereits." });
    }

    await query(
      `UPDATE zustandskatalog SET bezeichnung = ?, beschreibung = ?, aktiv = ?, sortierung = ? WHERE id = ?`,
      [bezeichnung, beschreibung, aktiv, sortierung, datensatzId]
    );
    const rows = await query(
      `SELECT id, bezeichnung, beschreibung, aktiv, sortierung FROM zustandskatalog WHERE id = ?`,
      [datensatzId]
    );
    res.json({
      meldung: "Zustand wurde gespeichert.",
      datensatz: {
        ...rows[0],
        aktiv: Boolean(rows[0]?.aktiv)
      }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/statuskatalog", async (req, res) => {
  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const beschreibung = normalisiereTextfeld(req.body?.beschreibung);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);
  const istAusleihbar = normalisiereBooleanWert(req.body?.ist_ausleihbar);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM statuskatalog WHERE bezeichnung = ? LIMIT 1`, [bezeichnung]);
    if (vorhanden.length > 0) {
      return res.status(400).json({ fehler: "Dieser Status existiert bereits." });
    }

    const ergebnis = await query(
      `INSERT INTO statuskatalog (bezeichnung, beschreibung, aktiv, ist_ausleihbar) VALUES (?, ?, ?, ?)`,
      [bezeichnung, beschreibung, aktiv, istAusleihbar]
    );
    const rows = await query(
      `SELECT id, bezeichnung, beschreibung, aktiv, ist_ausleihbar FROM statuskatalog WHERE id = ?`,
      [ergebnis.insertId]
    );
    res.status(201).json({
      meldung: "Status wurde angelegt.",
      datensatz: {
        ...rows[0],
        aktiv: Boolean(rows[0]?.aktiv),
        ist_ausleihbar: Boolean(rows[0]?.ist_ausleihbar)
      }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.put("/api/statuskatalog/:id", async (req, res) => {
  const datensatzId = Number(req.params.id);
  if (!datensatzId) {
    return res.status(400).json({ fehler: "Ungueltige Status-ID." });
  }

  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const beschreibung = normalisiereTextfeld(req.body?.beschreibung);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);
  const istAusleihbar = normalisiereBooleanWert(req.body?.ist_ausleihbar);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM statuskatalog WHERE id = ? LIMIT 1`, [datensatzId]);
    if (vorhanden.length === 0) {
      return res.status(404).json({ fehler: "Status nicht gefunden." });
    }
    const duplikat = await query(`SELECT id FROM statuskatalog WHERE bezeichnung = ? AND id <> ? LIMIT 1`, [bezeichnung, datensatzId]);
    if (duplikat.length > 0) {
      return res.status(400).json({ fehler: "Dieser Status existiert bereits." });
    }

    await query(
      `UPDATE statuskatalog SET bezeichnung = ?, beschreibung = ?, aktiv = ?, ist_ausleihbar = ? WHERE id = ?`,
      [bezeichnung, beschreibung, aktiv, istAusleihbar, datensatzId]
    );
    const rows = await query(
      `SELECT id, bezeichnung, beschreibung, aktiv, ist_ausleihbar FROM statuskatalog WHERE id = ?`,
      [datensatzId]
    );
    res.json({
      meldung: "Status wurde gespeichert.",
      datensatz: {
        ...rows[0],
        aktiv: Boolean(rows[0]?.aktiv),
        ist_ausleihbar: Boolean(rows[0]?.ist_ausleihbar)
      }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/artikel", async (req, res) => {
  const {
    inventar_typ_id,
    titel,
    interne_bezeichnung,
    beschreibung,
    hersteller,
    modellbezeichnung,
    herkunft_id,
    artikel_kategorie_id,
    aktiv
  } = req.body || {};

  if (!Number(inventar_typ_id)) {
    return res.status(400).json({ fehler: "Inventar-Typ ist erforderlich." });
  }

  if (!normalisiereTextfeld(titel)) {
    return res.status(400).json({ fehler: "Titel ist erforderlich." });
  }

  try {
    const ergebnis = await query(
      `
        INSERT INTO artikel (
          inventar_typ_id,
          titel,
          interne_bezeichnung,
          beschreibung,
          hersteller,
          modellbezeichnung,
          herkunft_id,
          artikel_kategorie_id,
          aktiv
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      `,
      [
        Number(inventar_typ_id),
        normalisiereTextfeld(titel) || "",
        normalisiereTextfeld(interne_bezeichnung),
        normalisiereTextfeld(beschreibung),
        normalisiereTextfeld(hersteller),
        normalisiereTextfeld(modellbezeichnung),
        Number(herkunft_id) || null,
        Number(artikel_kategorie_id) || null,
        normalisiereBooleanWert(aktiv)
      ]
    );

    const rows = await query(
      `
        SELECT
          a.id,
          a.inventar_typ_id,
          it.bezeichnung AS inventar_typ,
          a.titel,
          a.interne_bezeichnung,
          a.beschreibung,
          a.hersteller,
          a.modellbezeichnung,
          a.herkunft_id,
          h.bezeichnung AS herkunft,
          a.artikel_kategorie_id,
          ak.kategorie AS artikel_kategorie,
          a.aktiv,
          a.erstellt_am,
          a.aktualisiert_am
        FROM artikel a
        LEFT JOIN inventar_typen it ON it.id = a.inventar_typ_id
        LEFT JOIN herkunft h ON h.id = a.herkunft_id
        LEFT JOIN artikel_kategorie ak ON ak.id = a.artikel_kategorie_id
        WHERE a.id = ?
      `,
      [ergebnis.insertId]
    );

    const artikel = rows[0];

    res.status(201).json({
      meldung: "Artikel wurde angelegt.",
      datensatz: {
        id: artikel.id,
        inventar_typ_id: artikel.inventar_typ_id,
        inventar_typ: artikel.inventar_typ || "",
        titel: artikel.titel || "",
        interne_bezeichnung: artikel.interne_bezeichnung || "",
        beschreibung: artikel.beschreibung || "",
        hersteller: artikel.hersteller || "",
        modellbezeichnung: artikel.modellbezeichnung || "",
        herkunft_id: artikel.herkunft_id,
        herkunft: artikel.herkunft || "",
        artikel_kategorie_id: artikel.artikel_kategorie_id,
        artikel_kategorie: artikel.artikel_kategorie || "",
        aktiv: artikel.aktiv === 1,
        erstellt_am: artikel.erstellt_am,
        aktualisiert_am: artikel.aktualisiert_am
      }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/inventar-typen", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT it.id, it.bezeichnung, it.beschreibung, it.ausleihart_id, it.aktiv, aa.bezeichnung AS ausleihart
      FROM inventar_typen it
      LEFT JOIN ausleiharten aa ON aa.id = it.ausleihart_id
      ORDER BY it.bezeichnung
    `);
    res.json(
      rows.map((row) => ({
        id: row.id,
        bezeichnung: row.bezeichnung,
        beschreibung: row.beschreibung,
        ausleihart_id: row.ausleihart_id,
        ausleihart: row.ausleihart || "",
        aktiv: Boolean(row.aktiv)
      }))
    );
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/inventar-typen", async (req, res) => {
  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const beschreibung = normalisiereTextfeld(req.body?.beschreibung);
  const ausleihartId = Number(req.body?.ausleihart_id);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }
  if (!ausleihartId) {
    return res.status(400).json({ fehler: "Ausleihart ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM inventar_typen WHERE bezeichnung = ? LIMIT 1`, [bezeichnung]);
    if (vorhanden.length > 0) {
      return res.status(400).json({ fehler: "Dieser Inventar-Typ existiert bereits." });
    }

    const ergebnis = await query(
      `INSERT INTO inventar_typen (bezeichnung, beschreibung, ausleihart_id, aktiv) VALUES (?, ?, ?, ?)`,
      [bezeichnung, beschreibung, ausleihartId, aktiv]
    );
    const rows = await query(
      `
        SELECT it.id, it.bezeichnung, it.beschreibung, it.ausleihart_id, it.aktiv, aa.bezeichnung AS ausleihart
        FROM inventar_typen it
        LEFT JOIN ausleiharten aa ON aa.id = it.ausleihart_id
        WHERE it.id = ?
      `,
      [ergebnis.insertId]
    );
    res.status(201).json({
      meldung: "Inventar-Typ wurde angelegt.",
      datensatz: {
        ...rows[0],
        aktiv: Boolean(rows[0]?.aktiv)
      }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.put("/api/inventar-typen/:id", async (req, res) => {
  const datensatzId = Number(req.params.id);
  if (!datensatzId) {
    return res.status(400).json({ fehler: "Ungueltige Inventar-Typ-ID." });
  }

  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const beschreibung = normalisiereTextfeld(req.body?.beschreibung);
  const ausleihartId = Number(req.body?.ausleihart_id);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }
  if (!ausleihartId) {
    return res.status(400).json({ fehler: "Ausleihart ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM inventar_typen WHERE id = ? LIMIT 1`, [datensatzId]);
    if (vorhanden.length === 0) {
      return res.status(404).json({ fehler: "Inventar-Typ nicht gefunden." });
    }
    const duplikat = await query(`SELECT id FROM inventar_typen WHERE bezeichnung = ? AND id <> ? LIMIT 1`, [bezeichnung, datensatzId]);
    if (duplikat.length > 0) {
      return res.status(400).json({ fehler: "Dieser Inventar-Typ existiert bereits." });
    }

    await query(
      `UPDATE inventar_typen SET bezeichnung = ?, beschreibung = ?, ausleihart_id = ?, aktiv = ? WHERE id = ?`,
      [bezeichnung, beschreibung, ausleihartId, aktiv, datensatzId]
    );
    const rows = await query(
      `
        SELECT it.id, it.bezeichnung, it.beschreibung, it.ausleihart_id, it.aktiv, aa.bezeichnung AS ausleihart
        FROM inventar_typen it
        LEFT JOIN ausleiharten aa ON aa.id = it.ausleihart_id
        WHERE it.id = ?
      `,
      [datensatzId]
    );
    res.json({
      meldung: "Inventar-Typ wurde gespeichert.",
      datensatz: {
        ...rows[0],
        aktiv: Boolean(rows[0]?.aktiv)
      }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/artikel-kategorien", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT id, kategorie, aktiv, bemerkung
      FROM artikel_kategorie
      ORDER BY kategorie
    `);
    res.json(
      rows.map((row) => ({
        id: row.id,
        kategorie: row.kategorie,
        aktiv: Boolean(row.aktiv),
        bemerkung: row.bemerkung
      }))
    );
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/ausleiharten", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT id, bezeichnung, aktiv, beschreibung
      FROM ausleiharten
      ORDER BY bezeichnung
    `);
    res.json(
      rows.map((row) => ({
        id: row.id,
        bezeichnung: row.bezeichnung,
        aktiv: Boolean(row.aktiv),
        beschreibung: row.beschreibung
      }))
    );
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/ausleiharten", async (req, res) => {
  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);
  const beschreibung = normalisiereTextfeld(req.body?.beschreibung);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM ausleiharten WHERE bezeichnung = ? LIMIT 1`, [bezeichnung]);

    if (vorhanden.length > 0) {
      return res.status(400).json({ fehler: "Diese Ausleihart existiert bereits." });
    }

    const ergebnis = await query(
      `
        INSERT INTO ausleiharten (bezeichnung, aktiv, beschreibung)
        VALUES (?, ?, ?)
      `,
      [bezeichnung, aktiv, beschreibung]
    );

    const gespeichert = await query(
      `
        SELECT id, bezeichnung, aktiv, beschreibung
        FROM ausleiharten
        WHERE id = ?
      `,
      [ergebnis.insertId]
    );

    res.status(201).json({
      meldung: "Ausleihart wurde angelegt.",
      datensatz: {
        ...gespeichert[0],
        aktiv: Boolean(gespeichert[0]?.aktiv)
      }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.put("/api/ausleiharten/:id", async (req, res) => {
  const datensatzId = Number(req.params.id);

  if (!datensatzId) {
    return res.status(400).json({ fehler: "Ungueltige Ausleihart-ID." });
  }

  const bezeichnung = normalisiereTextfeld(req.body?.bezeichnung);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);
  const beschreibung = normalisiereTextfeld(req.body?.beschreibung);

  if (!bezeichnung) {
    return res.status(400).json({ fehler: "Bezeichnung ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM ausleiharten WHERE id = ? LIMIT 1`, [datensatzId]);

    if (vorhanden.length === 0) {
      return res.status(404).json({ fehler: "Ausleihart nicht gefunden." });
    }

    const duplikat = await query(
      `
        SELECT id
        FROM ausleiharten
        WHERE bezeichnung = ? AND id <> ?
        LIMIT 1
      `,
      [bezeichnung, datensatzId]
    );

    if (duplikat.length > 0) {
      return res.status(400).json({ fehler: "Diese Ausleihart existiert bereits." });
    }

    await query(
      `
        UPDATE ausleiharten
        SET bezeichnung = ?, aktiv = ?, beschreibung = ?
        WHERE id = ?
      `,
      [bezeichnung, aktiv, beschreibung, datensatzId]
    );

    const gespeichert = await query(
      `
        SELECT id, bezeichnung, aktiv, beschreibung
        FROM ausleiharten
        WHERE id = ?
      `,
      [datensatzId]
    );

    res.json({
      meldung: "Ausleihart wurde gespeichert.",
      datensatz: {
        ...gespeichert[0],
        aktiv: Boolean(gespeichert[0]?.aktiv)
      }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/artikel-kategorien", async (req, res) => {
  const kategorie = normalisiereTextfeld(req.body?.kategorie);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);
  const bemerkung = normalisiereTextfeld(req.body?.bemerkung);

  if (!kategorie) {
    return res.status(400).json({ fehler: "Kategorie ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM artikel_kategorie WHERE kategorie = ? LIMIT 1`, [kategorie]);

    if (vorhanden.length > 0) {
      return res.status(400).json({ fehler: "Diese Artikel-Kategorie existiert bereits." });
    }

    const ergebnis = await query(
      `
        INSERT INTO artikel_kategorie (kategorie, aktiv, bemerkung)
        VALUES (?, ?, ?)
      `,
      [kategorie, aktiv, bemerkung]
    );

    const gespeichert = await query(
      `
        SELECT id, kategorie, aktiv, bemerkung
        FROM artikel_kategorie
        WHERE id = ?
      `,
      [ergebnis.insertId]
    );

    res.status(201).json({
      meldung: "Artikel-Kategorie wurde angelegt.",
      datensatz: {
        ...gespeichert[0],
        aktiv: Boolean(gespeichert[0]?.aktiv)
      }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.put("/api/artikel-kategorien/:id", async (req, res) => {
  const datensatzId = Number(req.params.id);

  if (!datensatzId) {
    return res.status(400).json({ fehler: "Ungueltige Artikel-Kategorie-ID." });
  }

  const kategorie = normalisiereTextfeld(req.body?.kategorie);
  const aktiv = normalisiereBooleanWert(req.body?.aktiv);
  const bemerkung = normalisiereTextfeld(req.body?.bemerkung);

  if (!kategorie) {
    return res.status(400).json({ fehler: "Kategorie ist erforderlich." });
  }

  try {
    const vorhanden = await query(`SELECT id FROM artikel_kategorie WHERE id = ? LIMIT 1`, [datensatzId]);

    if (vorhanden.length === 0) {
      return res.status(404).json({ fehler: "Artikel-Kategorie nicht gefunden." });
    }

    const duplikat = await query(
      `
        SELECT id
        FROM artikel_kategorie
        WHERE kategorie = ? AND id <> ?
        LIMIT 1
      `,
      [kategorie, datensatzId]
    );

    if (duplikat.length > 0) {
      return res.status(400).json({ fehler: "Diese Artikel-Kategorie existiert bereits." });
    }

    await query(
      `
        UPDATE artikel_kategorie
        SET kategorie = ?, aktiv = ?, bemerkung = ?
        WHERE id = ?
      `,
      [kategorie, aktiv, bemerkung, datensatzId]
    );

    const gespeichert = await query(
      `
        SELECT id, kategorie, aktiv, bemerkung
        FROM artikel_kategorie
        WHERE id = ?
      `,
      [datensatzId]
    );

    res.json({
      meldung: "Artikel-Kategorie wurde gespeichert.",
      datensatz: {
        ...gespeichert[0],
        aktiv: Boolean(gespeichert[0]?.aktiv)
      }
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.patch("/api/artikel/:id", async (req, res) => {
  const artikelId = Number(req.params.id);

  if (!artikelId) {
    return res.status(400).json({ fehler: "Ungueltige Artikel-ID." });
  }

  const {
    inventar_typ_id,
    titel,
    interne_bezeichnung,
    beschreibung,
    hersteller,
    modellbezeichnung,
    herkunft_id,
    artikel_kategorie_id,
    aktiv
  } = req.body || {};

  if (!Number(inventar_typ_id)) {
    return res.status(400).json({ fehler: "Inventar-Typ ist erforderlich." });
  }

  if (!normalisiereTextfeld(titel)) {
    return res.status(400).json({ fehler: "Titel ist erforderlich." });
  }

  try {
    const rows = await query(`SELECT id FROM artikel WHERE id = ?`, [artikelId]);

    if (rows.length === 0) {
      return res.status(404).json({ fehler: "Artikel nicht gefunden." });
    }

    await query(
      `
        UPDATE artikel
        SET
          inventar_typ_id = ?,
          titel = ?,
          interne_bezeichnung = ?,
          beschreibung = ?,
          hersteller = ?,
          modellbezeichnung = ?,
          herkunft_id = ?,
          artikel_kategorie_id = ?,
          aktiv = ?
        WHERE id = ?
      `,
      [
        Number(inventar_typ_id),
        normalisiereTextfeld(titel) || "",
        normalisiereTextfeld(interne_bezeichnung),
        normalisiereTextfeld(beschreibung),
        normalisiereTextfeld(hersteller),
        normalisiereTextfeld(modellbezeichnung),
        Number(herkunft_id) || null,
        Number(artikel_kategorie_id) || null,
        normalisiereBooleanWert(aktiv) ? 1 : 0,
        artikelId
      ]
    );

    res.json({ meldung: "Artikel aktualisiert." });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/artikel-exemplare/import", async (req, res) => {
  const { inventarnummer_praefix, exemplare } = req.body || {};
  const prefixRaw = normalisiereTextfeld(inventarnummer_praefix);
  const importZeilen = Array.isArray(exemplare) ? exemplare : [];

  if (!prefixRaw) {
    return res.status(400).json({ fehler: "Ein Inventarnummer-Praefix ist erforderlich." });
  }

  if (importZeilen.length === 0) {
    return res.status(400).json({ fehler: "Es wurden keine Exemplare zum Import uebergeben." });
  }

  const prefix = prefixRaw.replace(/-+$/, "");
  const normierteZeilen = importZeilen.map((eintrag, index) => ({
    artikel_id: Number(eintrag?.artikel_id),
    seriennummer: normalisiereTextfeld(eintrag?.seriennummer),
    inventarnummer: `${prefix}-${String(index + 1).padStart(4, "0")}`
  }));

  const ungueltigeZeilen = normierteZeilen.filter((eintrag) => !eintrag.artikel_id || !eintrag.seriennummer);
  if (ungueltigeZeilen.length > 0) {
    return res.status(400).json({ fehler: "Jede Importzeile benoetigt einen Artikel und eine Seriennummer." });
  }

  const seriennummern = normierteZeilen.map((eintrag) => eintrag.seriennummer);
  const inventarnummern = normierteZeilen.map((eintrag) => eintrag.inventarnummer);

  if (new Set(seriennummern).size !== seriennummern.length) {
    return res.status(400).json({ fehler: "Die Importdatei enthaelt doppelte Seriennummern." });
  }

  let connection;

  try {
    connection = await getConnection();
    await connection.beginTransaction();

    const [zustandRows, statusRows] = await Promise.all([
      connection.execute(`SELECT id FROM zustandskatalog WHERE bezeichnung = 'sehr_gut'`),
      connection.execute(`SELECT id FROM statuskatalog WHERE bezeichnung = 'verfuegbar'`)
    ]);

    const zustandId = zustandRows[0][0]?.id;
    const statusId = statusRows[0][0]?.id;

    if (!zustandId || !statusId) {
      await connection.rollback();
      return res.status(400).json({ fehler: "Standard-Status oder Standard-Zustand nicht gefunden." });
    }

    const artikelIds = [...new Set(normierteZeilen.map((eintrag) => eintrag.artikel_id))];
    const artikelPlatzhalter = artikelIds.map(() => "?").join(", ");
    const [artikelRows] = await connection.execute(
      `SELECT id FROM artikel WHERE id IN (${artikelPlatzhalter})`,
      artikelIds
    );
    if (artikelRows.length !== artikelIds.length) {
      await connection.rollback();
      return res.status(400).json({ fehler: "Mindestens ein ausgewaehlter Artikel existiert nicht mehr." });
    }

    const serienPlatzhalter = seriennummern.map(() => "?").join(", ");
    const inventarPlatzhalter = inventarnummern.map(() => "?").join(", ");

    const [konfliktRows] = await connection.execute(
      `
        SELECT seriennummer, barcode, inventarnummer
        FROM artikel_exemplare
        WHERE seriennummer IN (${serienPlatzhalter})
           OR barcode IN (${serienPlatzhalter})
           OR inventarnummer IN (${inventarPlatzhalter})
      `,
      [...seriennummern, ...seriennummern, ...inventarnummern]
    );

    if (konfliktRows.length > 0) {
      await connection.rollback();
      const vorhandeneSeriennummern = [
        ...new Set(
          konfliktRows
            .map((eintrag) => eintrag.seriennummer)
            .filter((wert) => wert && seriennummern.includes(wert))
        )
      ];
      const vorhandeneBarcodes = [
        ...new Set(
          konfliktRows
            .map((eintrag) => eintrag.barcode)
            .filter((wert) => wert && seriennummern.includes(wert))
        )
      ];
      const vorhandeneInventarnummern = [
        ...new Set(
          konfliktRows
            .map((eintrag) => eintrag.inventarnummer)
            .filter((wert) => wert && inventarnummern.includes(wert))
        )
      ];

      if (vorhandeneSeriennummern.length > 0) {
        return res.status(409).json({
          fehler: `Folgende Seriennummern sind bereits vorhanden und konnten nicht importiert werden: ${vorhandeneSeriennummern.join(", ")}`
        });
      }

      if (vorhandeneBarcodes.length > 0) {
        return res.status(409).json({
          fehler: `Folgende Barcodes sind bereits vorhanden und konnten nicht importiert werden: ${vorhandeneBarcodes.join(", ")}`
        });
      }

      if (vorhandeneInventarnummern.length > 0) {
        return res.status(409).json({
          fehler: `Folgende Inventarnummern sind bereits vorhanden und konnten nicht importiert werden: ${vorhandeneInventarnummern.join(", ")}`
        });
      }

      return res.status(409).json({
        fehler: "Der Import konnte wegen bereits vorhandener Daten nicht abgeschlossen werden."
      });
    }

    for (const eintrag of normierteZeilen) {
      await connection.execute(
        `
          INSERT INTO artikel_exemplare (
            artikel_id,
            inventarnummer,
            barcode,
            seriennummer,
            status_id,
            zustand_id,
            aktiv
          )
          VALUES (?, ?, ?, ?, ?, ?, 1)
        `,
        [
          eintrag.artikel_id,
          eintrag.inventarnummer,
          eintrag.seriennummer,
          eintrag.seriennummer,
          statusId,
          zustandId
        ]
      );
    }

    await connection.commit();
    res.json({ meldung: `${normierteZeilen.length} Artikel-Exemplare wurden importiert.` });
  } catch (error) {
    if (connection) {
      await connection.rollback();
    }
    res.status(500).json({ fehler: error.message });
  } finally {
    if (connection) {
      connection.release();
    }
  }
});

app.patch("/api/buecher/:artikel_id", async (req, res) => {
  const artikel_id = Number(req.params.artikel_id);

  if (!artikel_id) {
    return res.status(400).json({ fehler: "Ungueltige Artikel-ID." });
  }

  const { titel, titelcode, autor, verlag, fach_id, veroeffentlicht, cover_url,
          jahrgangsstufe, schuljahr_ausgabe, ist_arbeitsheft, ist_lehrerversion, herkunft_id } = req.body;

  try {
    if (titel !== undefined) {
      await query("UPDATE artikel SET titel = ? WHERE id = ?", [titel, artikel_id]);
    }

    await query(`
      UPDATE buch_details SET
        titelcode = ?,
        autor = ?,
        verlag = ?,
        fach_id = ?,
        veroeffentlicht = ?,
        cover_url = ?,
        jahrgangsstufe = ?,
        schuljahr_ausgabe = ?,
        ist_arbeitsheft = ?,
        ist_lehrerversion = ?,
        herkunft_id = ?
      WHERE artikel_id = ?
    `, [
      titelcode || null,
      autor || null,
      verlag || null,
      fach_id || null,
      veroeffentlicht || null,
      cover_url || null,
      jahrgangsstufe || null,
      schuljahr_ausgabe || null,
      ist_arbeitsheft ? 1 : 0,
      ist_lehrerversion ? 1 : 0,
      herkunft_id || null,
      artikel_id
    ]);

    res.json({ meldung: "Buch wurde aktualisiert." });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/buecher/lookup/:titelcode", async (req, res) => {
  const titelcode = String(req.params.titelcode || "").trim();

  if (!titelcode) {
    return res.status(400).json({ fehler: "Titelcode ist erforderlich." });
  }

  try {
    const onlineTreffer = await sucheBuchOnline(titelcode);

    if (!onlineTreffer) {
      return res.status(404).json({ fehler: "Online wurde kein Titel zu diesem Code gefunden." });
    }

    res.json(onlineTreffer);
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/buecher/exemplare", async (req, res) => {
  const {
    titelcode,
    artikel_id,
    titel = null,
    autor = null,
    anzahl = 1,
    fach_id = null,
    verlag = null,
    veroeffentlicht = null,
    cover_url = null,
    cover_bild = null,
    klassensatz_name = null,
    standort_id = null,
    zustand = "sehr_gut",
    anschaffungsdatum = null,
    kaufpreis = null,
    notizen = null,
    jahrgangsstufe = null,
    ist_arbeitsheft = false,
    ist_lehrerversion = false,
    herkunft_id = null
  } = req.body;

  const menge = Math.min(Math.max(Number(anzahl || 1), 1), 100);

  if (!titelcode && !artikel_id) {
    return res.status(400).json({ fehler: "Titelcode oder Artikel-ID ist erforderlich." });
  }

  let connection;

  try {
    connection = await getConnection();
    await connection.beginTransaction();
    let gespeichertesCoverBild = typeof cover_bild === "string" && cover_bild.trim() ? cover_bild.trim() : null;

    if (!gespeichertesCoverBild && normalisiereTextfeld(cover_url)) {
      try {
        gespeichertesCoverBild = await fetchBildAlsDataUrl(normalisiereTextfeld(cover_url));
      } catch (_error) {
        // externes Bild ist optional; URL bleibt erhalten
      }
    }

    const [buchRows] = await connection.execute(
      `
        SELECT
          a.id AS artikel_id,
          a.titel,
          bd.titelcode,
          COALESCE(?, ae.standort_id, 1) AS ziel_standort_id
        FROM buch_details bd
        JOIN artikel a ON a.id = bd.artikel_id
        LEFT JOIN artikel_exemplare ae ON ae.artikel_id = a.id
        WHERE (? IS NOT NULL AND a.id = ?) OR (? IS NOT NULL AND bd.titelcode = ?)
        ORDER BY ae.id
        LIMIT 1
      `,
      [standort_id, artikel_id || null, artikel_id || null, titelcode || null, titelcode || null]
    );

    let buchDatensatz = buchRows[0] || null;

    if (!buchDatensatz) {
      const neuerTitel = normalisiereTextfeld(titel);

      if (!neuerTitel) {
        await connection.rollback();
        return res.status(404).json({
          fehler: "Buchtitel nicht gefunden. Fuer einen neuen Titel wird mindestens ein Titel benoetigt."
        });
      }

      const [inventarTypRows] = await connection.execute(
        `SELECT id FROM inventar_typen WHERE bezeichnung = 'buch' LIMIT 1`
      );
      const inventarTypId = inventarTypRows[0]?.id;

      if (!inventarTypId) {
        await connection.rollback();
        return res.status(500).json({ fehler: "Inventartyp 'buch' wurde nicht gefunden." });
      }

      const [artikelInsert] = await connection.execute(
        `
          INSERT INTO artikel (
            inventar_typ_id,
            titel,
            interne_bezeichnung,
            beschreibung,
            hersteller,
            modellbezeichnung,
            herkunft_id,
            aktiv
          )
          VALUES (?, ?, NULL, NULL, NULL, NULL, ?, 1)
        `,
        [inventarTypId, neuerTitel, herkunft_id || null]
      );

      await connection.execute(
        `
          INSERT INTO buch_details (
            artikel_id,
            titelcode,
            autor,
            verlag,
            fach_id,
            veroeffentlicht,
            cover_url,
            cover_bild,
            jahrgangsstufe,
            schuljahr_ausgabe,
            ist_arbeitsheft,
            ist_lehrerversion,
            herkunft_id
          )
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NULL, ?, ?, ?)
        `,
        [
          artikelInsert.insertId,
          normalisiereTextfeld(titelcode),
          normalisiereTextfeld(autor),
          normalisiereTextfeld(verlag),
          fach_id || null,
          normalisiereTextfeld(veroeffentlicht),
          normalisiereTextfeld(cover_url),
          gespeichertesCoverBild,
          normalisiereTextfeld(jahrgangsstufe),
          ist_arbeitsheft ? 1 : 0,
          ist_lehrerversion ? 1 : 0,
          herkunft_id || null
        ]
      );

      buchDatensatz = {
        artikel_id: artikelInsert.insertId,
        titel: neuerTitel,
        titelcode: normalisiereTextfeld(titelcode),
        ziel_standort_id: Number(standort_id || 1)
      };
    }

    const [zustandRows, statusRows] = await Promise.all([
      connection.execute(`SELECT id FROM zustandskatalog WHERE bezeichnung = ?`, [zustand]),
      connection.execute(`SELECT id FROM statuskatalog WHERE bezeichnung = 'verfuegbar'`)
    ]);

    const zustandId = zustandRows[0][0]?.id;
    const statusId = statusRows[0][0]?.id;

    if (!zustandId || !statusId) {
      await connection.rollback();
      return res.status(400).json({ fehler: "Gueltiger Zustand oder Status nicht gefunden." });
    }

    await connection.execute(
      `
        UPDATE artikel a
        JOIN buch_details bd ON bd.artikel_id = a.id
        SET
          a.titel = COALESCE(?, a.titel),
          a.herkunft_id = COALESCE(?, a.herkunft_id),
          autor = COALESCE(?, autor),
          fach_id = COALESCE(?, fach_id),
          verlag = COALESCE(?, verlag),
          veroeffentlicht = COALESCE(?, veroeffentlicht),
          cover_url = COALESCE(?, cover_url),
          cover_bild = COALESCE(?, cover_bild),
          jahrgangsstufe = COALESCE(?, jahrgangsstufe),
          ist_arbeitsheft = ?,
          ist_lehrerversion = ?,
          bd.herkunft_id = COALESCE(?, bd.herkunft_id)
        WHERE a.id = ?
      `,
      [
        normalisiereTextfeld(titel),
        herkunft_id || null,
        normalisiereTextfeld(autor),
        fach_id || null,
        normalisiereTextfeld(verlag),
        normalisiereTextfeld(veroeffentlicht),
        normalisiereTextfeld(cover_url),
        gespeichertesCoverBild,
        normalisiereTextfeld(jahrgangsstufe),
        ist_arbeitsheft ? 1 : 0,
        ist_lehrerversion ? 1 : 0,
        herkunft_id || null,
        buchDatensatz.artikel_id
      ]
    );

    const aktualisierterTitel = normalisiereTextfeld(titel) || buchDatensatz.titel;
    const vorlagen = await ermittleBuchVorlagen(buchDatensatz.artikel_id);
    const erzeugteExemplare = [];

    for (let index = 0; index < menge; index += 1) {
      const exemplarNummer = vorlagen.inventar_startwert + index;
      const inventarNummer = `${vorlagen.inventar_prefix}${String(
        exemplarNummer
      ).padStart(vorlagen.inventar_stellen, "0")}`;
      const barcode = `${vorlagen.barcode_prefix}${String(vorlagen.barcode_startwert + index).padStart(
        vorlagen.barcode_stellen,
        "0"
      )}`;
      const exemplarNotiz =
        normalisiereTextfeld(notizen) ||
        (klassensatz_name ? `Exemplar ${exemplarNummer} aus dem Klassensatz ${aktualisierterTitel}.` : null);

      const [insertResult] = await connection.execute(
        `
          INSERT INTO artikel_exemplare (
            artikel_id,
            inventarnummer,
            barcode,
            seriennummer,
            status_id,
            zustand_id,
            standort_id,
            anschaffungsdatum,
            kaufpreis,
            garantie_bis,
            ist_klassensatz,
            klassensatz_name,
            notizen
          )
          VALUES (?, ?, ?, NULL, ?, ?, ?, ?, ?, NULL, ?, ?, ?)
        `,
        [
          buchDatensatz.artikel_id,
          inventarNummer,
          barcode,
          statusId,
          zustandId,
          Number(buchDatensatz.ziel_standort_id || 1),
          anschaffungsdatum || null,
          kaufpreis || null,
          klassensatz_name ? 1 : 0,
          klassensatz_name || null,
          exemplarNotiz
        ]
      );

      await schreibeHistorieMitConnection(connection, {
        bezug_typ: "exemplar",
        bezug_id: insertResult.insertId,
        exemplar_id: insertResult.insertId,
        aktion: "exemplar_angelegt",
        titel: `Exemplar angelegt: ${inventarNummer}`,
        details: `${aktualisierterTitel} wurde als neues Buch-Exemplar angelegt.${klassensatz_name ? ` Klassensatz: ${klassensatz_name}.` : ""}`,
        ausgeloest_von: "weboberflaeche"
      });

      erzeugteExemplare.push({
        id: insertResult.insertId,
        inventarnummer: inventarNummer,
        barcode
      });
    }

    await connection.commit();

    res.status(201).json({
      meldung: `${erzeugteExemplare.length} Buch-Exemplare wurden angelegt.`,
      artikel_id: buchDatensatz.artikel_id,
      titel: aktualisierterTitel,
      exemplare: erzeugteExemplare
    });
  } catch (error) {
    if (connection) {
      await connection.rollback();
    }
    res.status(500).json({ fehler: error.message });
  } finally {
    if (connection) {
      connection.release();
    }
  }
});

app.get("/api/schaeden", async (_req, res) => {
  try {
    const rows = await query(
      `
        SELECT
          s.id,
          s.exemplar_id,
          s.ausleihe_id,
          s.gemeldet_am,
          s.titel,
          s.beschreibung,
          s.schadensgrad,
          s.status,
          s.geloest_am,
          ae.inventarnummer,
          a.titel AS artikel_titel,
          aus.name AS gemeldet_von
        FROM schadensmeldungen s
        JOIN artikel_exemplare ae ON ae.id = s.exemplar_id
        JOIN artikel a ON a.id = ae.artikel_id
        LEFT JOIN ausleiher aus ON aus.id = s.gemeldet_von_ausleiher_id
        ORDER BY
          CASE s.status
            WHEN 'offen' THEN 1
            WHEN 'in_pruefung' THEN 2
            WHEN 'in_reparatur' THEN 3
            ELSE 4
          END,
          s.gemeldet_am DESC
      `
    );

    res.json(rows);
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/schaeden", async (req, res) => {
  const {
    exemplar_id,
    ausleihe_id = null,
    gemeldet_von_ausleiher_id = null,
    titel,
    beschreibung,
    schadensgrad = "mittel"
  } = req.body;

  if (!exemplar_id || !titel || !beschreibung) {
    return res.status(400).json({ fehler: "Exemplar, Titel und Beschreibung sind erforderlich." });
  }

  try {
    const exemplarRows = await query(
      `
        SELECT ae.id, ae.inventarnummer, a.titel
        FROM artikel_exemplare ae
        JOIN artikel a ON a.id = ae.artikel_id
        WHERE ae.id = ?
      `,
      [exemplar_id]
    );

    if (exemplarRows.length === 0) {
      return res.status(404).json({ fehler: "Exemplar nicht gefunden." });
    }

    const result = await query(
      `
        INSERT INTO schadensmeldungen (
          exemplar_id,
          ausleihe_id,
          gemeldet_von_ausleiher_id,
          titel,
          beschreibung,
          schadensgrad
        )
        VALUES (?, ?, ?, ?, ?, ?)
      `,
      [exemplar_id, ausleihe_id, gemeldet_von_ausleiher_id, titel, beschreibung, schadensgrad]
    );

    await query(
      `
        UPDATE artikel_exemplare ae
        JOIN statuskatalog sk ON sk.bezeichnung = 'defekt'
        JOIN zustandskatalog zk ON zk.bezeichnung = 'beschaedigt'
        SET
          ae.status_id = sk.id,
          ae.zustand_id = zk.id
        WHERE ae.id = ?
      `,
      [exemplar_id]
    );

    const exemplar = exemplarRows[0];

    await schreibeHistorie({
      bezug_typ: "schaden",
      bezug_id: result.insertId,
      exemplar_id,
      ausleihe_id,
      aktion: "schadensmeldung",
      titel: `Schaden gemeldet: ${exemplar.inventarnummer}`,
      details: `${exemplar.titel}: ${titel}. ${beschreibung}`,
      ausgeloest_von: "weboberflaeche"
    });

    await schreibeHistorie({
      bezug_typ: "exemplar",
      bezug_id: exemplar_id,
      exemplar_id,
      aktion: "status_aenderung",
      titel: `Status geaendert: ${exemplar.inventarnummer}`,
      details: `${exemplar.titel} wurde aufgrund einer Schadensmeldung auf defekt gesetzt.`,
      ausgeloest_von: "weboberflaeche"
    });

    await schreibeHistorie({
      bezug_typ: "exemplar",
      bezug_id: exemplar_id,
      exemplar_id,
      aktion: "zustandsaenderung",
      titel: `Zustand geaendert: ${exemplar.inventarnummer}`,
      details: `${exemplar.titel} wurde aufgrund einer Schadensmeldung auf beschaedigt gesetzt.`,
      ausgeloest_von: "weboberflaeche"
    });

    res.status(201).json({ id: result.insertId, meldung: "Schadensmeldung erfasst." });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/reparaturen", async (_req, res) => {
  try {
    const rows = await query(
      `
        SELECT
          r.id,
          r.schadensmeldung_id,
          r.exemplar_id,
          r.gestartet_am,
          r.abgeschlossen_am,
          r.status,
          r.dienstleister,
          r.beschreibung,
          r.kosten,
          r.abschluss_notiz,
          ae.inventarnummer,
          a.titel AS artikel_titel,
          s.titel AS schaden_titel
        FROM reparaturen r
        JOIN artikel_exemplare ae ON ae.id = r.exemplar_id
        JOIN artikel a ON a.id = ae.artikel_id
        JOIN schadensmeldungen s ON s.id = r.schadensmeldung_id
        ORDER BY
          CASE r.status WHEN 'offen' THEN 1 ELSE 2 END,
          r.gestartet_am DESC
      `
    );

    res.json(rows);
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/reparaturen", async (req, res) => {
  const { schadensmeldung_id, dienstleister = null, beschreibung, kosten = null } = req.body;

  if (!schadensmeldung_id || !beschreibung) {
    return res.status(400).json({ fehler: "Schadensmeldung und Beschreibung sind erforderlich." });
  }

  try {
    const schadenRows = await query(
      `
        SELECT s.id, s.exemplar_id, s.status, ae.inventarnummer, a.titel
        FROM schadensmeldungen s
        JOIN artikel_exemplare ae ON ae.id = s.exemplar_id
        JOIN artikel a ON a.id = ae.artikel_id
        WHERE s.id = ?
      `,
      [schadensmeldung_id]
    );

    if (schadenRows.length === 0) {
      return res.status(404).json({ fehler: "Schadensmeldung nicht gefunden." });
    }

    const schaden = schadenRows[0];

    const result = await query(
      `
        INSERT INTO reparaturen (
          schadensmeldung_id,
          exemplar_id,
          dienstleister,
          beschreibung,
          kosten
        )
        VALUES (?, ?, ?, ?, ?)
      `,
      [schadensmeldung_id, schaden.exemplar_id, dienstleister, beschreibung, kosten]
    );

    await query(
      `
        UPDATE schadensmeldungen
        SET status = 'in_reparatur'
        WHERE id = ?
      `,
      [schadensmeldung_id]
    );

    await query(
      `
        UPDATE artikel_exemplare ae
        JOIN statuskatalog sk ON sk.bezeichnung = 'in_reparatur'
        SET ae.status_id = sk.id
        WHERE ae.id = ?
      `,
      [schaden.exemplar_id]
    );

    await schreibeHistorie({
      bezug_typ: "reparatur",
      bezug_id: result.insertId,
      exemplar_id: schaden.exemplar_id,
      aktion: "reparatur_gestartet",
      titel: `Reparatur gestartet: ${schaden.inventarnummer}`,
      details: `${schaden.titel}: ${beschreibung}${dienstleister ? ` (Dienstleister: ${dienstleister})` : ""}`,
      ausgeloest_von: "weboberflaeche"
    });

    await schreibeHistorie({
      bezug_typ: "exemplar",
      bezug_id: schaden.exemplar_id,
      exemplar_id: schaden.exemplar_id,
      aktion: "status_aenderung",
      titel: `Status geaendert: ${schaden.inventarnummer}`,
      details: `${schaden.titel} wurde auf in_reparatur gesetzt.`,
      ausgeloest_von: "weboberflaeche"
    });

    res.status(201).json({ id: result.insertId, meldung: "Reparatur gestartet." });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/reparaturen/:id/abschliessen", async (req, res) => {
  const reparaturId = Number(req.params.id);
  const {
    abschluss_notiz = null,
    neuer_status = "verfuegbar",
    neuer_zustand = "gut"
  } = req.body;

  if (!reparaturId) {
    return res.status(400).json({ fehler: "Gueltige Reparatur-ID erforderlich." });
  }

  try {
    const reparaturRows = await query(
      `
        SELECT
          r.id,
          r.exemplar_id,
          r.schadensmeldung_id,
          r.status,
          ae.inventarnummer,
          a.titel
        FROM reparaturen r
        JOIN artikel_exemplare ae ON ae.id = r.exemplar_id
        JOIN artikel a ON a.id = ae.artikel_id
        WHERE r.id = ?
      `,
      [reparaturId]
    );

    if (reparaturRows.length === 0) {
      return res.status(404).json({ fehler: "Reparatur nicht gefunden." });
    }

    const reparatur = reparaturRows[0];

    if (reparatur.status !== "offen") {
      return res.status(409).json({ fehler: "Reparatur ist bereits abgeschlossen." });
    }

    await query(
      `
        UPDATE reparaturen
        SET
          status = 'abgeschlossen',
          abgeschlossen_am = NOW(),
          abschluss_notiz = ?
        WHERE id = ?
      `,
      [abschluss_notiz, reparaturId]
    );

    await query(
      `
        UPDATE schadensmeldungen
        SET
          status = 'behoben',
          geloest_am = NOW()
        WHERE id = ?
      `,
      [reparatur.schadensmeldung_id]
    );

    await query(
      `
        UPDATE artikel_exemplare ae
        JOIN statuskatalog sk ON sk.bezeichnung = ?
        JOIN zustandskatalog zk ON zk.bezeichnung = ?
        SET
          ae.status_id = sk.id,
          ae.zustand_id = zk.id
        WHERE ae.id = ?
      `,
      [neuer_status, neuer_zustand, reparatur.exemplar_id]
    );

    await schreibeHistorie({
      bezug_typ: "reparatur",
      bezug_id: reparaturId,
      exemplar_id: reparatur.exemplar_id,
      aktion: "reparatur_abgeschlossen",
      titel: `Reparatur abgeschlossen: ${reparatur.inventarnummer}`,
      details: `${reparatur.titel} wurde abgeschlossen.${abschluss_notiz ? ` ${abschluss_notiz}` : ""}`,
      ausgeloest_von: "weboberflaeche"
    });

    await schreibeHistorie({
      bezug_typ: "exemplar",
      bezug_id: reparatur.exemplar_id,
      exemplar_id: reparatur.exemplar_id,
      aktion: "status_aenderung",
      titel: `Status geaendert: ${reparatur.inventarnummer}`,
      details: `${reparatur.titel} wurde auf ${neuer_status} gesetzt.`,
      ausgeloest_von: "weboberflaeche"
    });

    await schreibeHistorie({
      bezug_typ: "exemplar",
      bezug_id: reparatur.exemplar_id,
      exemplar_id: reparatur.exemplar_id,
      aktion: "zustandsaenderung",
      titel: `Zustand geaendert: ${reparatur.inventarnummer}`,
      details: `${reparatur.titel} wurde auf ${neuer_zustand} gesetzt.`,
      ausgeloest_von: "weboberflaeche"
    });

    res.json({ meldung: "Reparatur abgeschlossen." });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/ausleiher", async (_req, res) => {
  try {
    const rows = await query(`
      SELECT
        a.id,
        a.name,
        a.ausleiher_typ,
        a.klasse_oder_bereich,
        a.barcode,
        a.quelle_typ,
        a.quelle_id,
        a.aktiv,
        s.S_ID AS s_id,
        s.vorname,
        s.nachname,
        s.anzeigename,
        s.geburtsdatum,
        s.email,
        k.bezeichnung AS klasse
      FROM ausleiher a
      LEFT JOIN schueler s
        ON a.quelle_typ = 'schueler'
        AND s.id = a.quelle_id
      LEFT JOIN schueler_klassen sk
        ON a.quelle_typ = 'schueler'
       AND sk.schueler_id = s.id
       AND sk.ist_aktuell = 1
      LEFT JOIN lehrkraefte l
        ON a.quelle_typ = 'lehrkraft'
        AND l.id = a.quelle_id
      LEFT JOIN klassen k
        ON (
          a.quelle_typ = 'klasse'
          AND k.id = a.quelle_id
        ) OR (
          a.quelle_typ = 'schueler'
          AND k.id = sk.klassen_id
        )
      WHERE a.aktiv = 1
        AND (
          (a.quelle_typ = 'schueler' AND COALESCE(s.aktiv, 0) = 1)
          OR (a.quelle_typ = 'lehrkraft' AND COALESCE(l.aktiv, 0) = 1)
          OR (a.quelle_typ = 'klasse' AND COALESCE(k.aktiv, 0) = 1)
        )
      ORDER BY
        CASE a.ausleiher_typ
          WHEN 'klasse' THEN 1
          WHEN 'lehrkraft' THEN 2
          ELSE 3
        END,
        a.name
    `);
    res.json(rows.map(mapAusleiherMitDetails));
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get("/api/scanner/lookup", async (req, res) => {
  const scanCode = String(req.query.code || "").trim();

  if (!scanCode) {
    return res.status(400).json({ fehler: "Ein Scan-Code ist erforderlich." });
  }

  try {
    const exemplarRows = await query(
      `
        SELECT
          ae.id,
          ae.artikel_id,
          ae.inventarnummer,
          ae.barcode,
          ae.seriennummer,
          ae.ist_klassensatz,
          ae.klassensatz_name,
          ae.notizen,
          a.titel,
          bd.titelcode,
          bd.autor,
          bd.verlag,
          f.bezeichnung AS fach,
          bd.veroeffentlicht,
          bd.cover_url,
          bd.cover_bild,
          ae.standort_id,
          it.bezeichnung AS inventar_typ,
          st.bezeichnung AS standort,
          sk.bezeichnung AS status,
          zk.bezeichnung AS zustand
        FROM artikel_exemplare ae
        JOIN artikel a ON a.id = ae.artikel_id
        JOIN inventar_typen it ON it.id = a.inventar_typ_id
        JOIN statuskatalog sk ON sk.id = ae.status_id
        JOIN zustandskatalog zk ON zk.id = ae.zustand_id
        LEFT JOIN buch_details bd ON bd.artikel_id = a.id
        LEFT JOIN faecher f ON f.id = bd.fach_id
        LEFT JOIN standorte st ON st.id = ae.standort_id
        WHERE ae.aktiv = 1
          AND (ae.barcode = ? OR ae.inventarnummer = ?)
        LIMIT 1
      `,
      [scanCode, scanCode]
    );

    if (exemplarRows.length > 0) {
      return res.json({
        typ: "exemplar",
        daten: mapExemplar(exemplarRows[0])
      });
    }

    const ausleiherRows = await query(
      `
        SELECT
          a.id,
          a.name,
          a.ausleiher_typ,
          a.klasse_oder_bereich,
          a.barcode,
          a.quelle_typ,
          a.quelle_id,
          a.aktiv,
          s.S_ID AS s_id,
          s.vorname,
          s.nachname,
          s.anzeigename,
          s.geburtsdatum,
          s.email,
          k.bezeichnung AS klasse
        FROM ausleiher a
        LEFT JOIN schueler s
          ON a.quelle_typ = 'schueler'
          AND s.id = a.quelle_id
        LEFT JOIN schueler_klassen sk
          ON a.quelle_typ = 'schueler'
         AND sk.schueler_id = s.id
         AND sk.ist_aktuell = 1
        LEFT JOIN lehrkraefte l
          ON a.quelle_typ = 'lehrkraft'
          AND l.id = a.quelle_id
        LEFT JOIN klassen k
          ON (
            a.quelle_typ = 'klasse'
            AND k.id = a.quelle_id
          ) OR (
            a.quelle_typ = 'schueler'
            AND k.id = sk.klassen_id
          )
        WHERE a.aktiv = 1
          AND (
            a.barcode = ?
            OR (a.quelle_typ = 'schueler' AND CAST(s.S_ID AS CHAR) = ?)
          )
          AND (
            (a.quelle_typ = 'schueler' AND COALESCE(s.aktiv, 0) = 1)
            OR (a.quelle_typ = 'lehrkraft' AND COALESCE(l.aktiv, 0) = 1)
            OR (a.quelle_typ = 'klasse' AND COALESCE(k.aktiv, 0) = 1)
          )
        LIMIT 1
      `,
      [scanCode, scanCode]
    );

    if (ausleiherRows.length > 0) {
      return res.json({
        typ: "ausleiher",
        daten: mapAusleiherMitDetails(ausleiherRows[0])
      });
    }

    return res.status(404).json({ fehler: "Code wurde nicht im System gefunden." });
  } catch (error) {
    return res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/ausleiher/synchronisieren", async (_req, res) => {
  try {
    const ergebnis = await synchronisiereAusleiher();
    res.json({
      meldung: "Ausleiher wurden mit den Fachtabellen synchronisiert.",
      statistik: ergebnis
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/ausleihen", async (req, res) => {
  const { exemplar_id, ausleiher_id, faellig_am, kommentar_ausgabe } = req.body;

  if (!exemplar_id || !ausleiher_id) {
    return res.status(400).json({ fehler: "Exemplar und Ausleiher sind erforderlich." });
  }

  let connection;

  try {
    connection = await getConnection();
    await connection.beginTransaction();

    const [exemplare] = await connection.execute(
      `
        SELECT ae.id, ae.zustand_id, sk.bezeichnung AS status, ae.inventarnummer, a.titel
        FROM artikel_exemplare ae
        JOIN artikel a ON a.id = ae.artikel_id
        JOIN statuskatalog sk ON sk.id = ae.status_id
        WHERE ae.id = ?
        FOR UPDATE
      `,
      [exemplar_id]
    );

    const [ausleiherRows] = await connection.execute(
      `
        SELECT id, name, ausleiher_typ
        FROM ausleiher
        WHERE id = ? AND aktiv = 1
      `,
      [ausleiher_id]
    );

    if (ausleiherRows.length === 0) {
      await connection.rollback();
      return res.status(404).json({ fehler: "Ausleiher wurde nicht gefunden." });
    }

    if (exemplare.length === 0) {
      await connection.rollback();
      return res.status(404).json({ fehler: "Exemplar wurde nicht gefunden." });
    }

    if (exemplare[0].status !== "verfuegbar") {
      await connection.rollback();
      return res.status(409).json({ fehler: "Exemplar ist aktuell nicht verfuegbar." });
    }

    const wirksameFaelligkeit = berechneStandardFaelligkeit(
      ausleiherRows[0].ausleiher_typ,
      faellig_am
    );

    const [insertResult] = await connection.execute(
      `
        INSERT INTO ausleihen (
          exemplar_id,
          ausleiher_id,
          faellig_am,
          zustand_bei_ausgabe_id,
          kommentar_ausgabe
        )
        VALUES (?, ?, ?, ?, ?)
      `,
      [
        exemplar_id,
        ausleiher_id,
        wirksameFaelligkeit,
        exemplare[0].zustand_id,
        kommentar_ausgabe || null
      ]
    );

    await connection.execute(
      `
        UPDATE artikel_exemplare ae
        JOIN statuskatalog sk ON sk.bezeichnung = 'ausgeliehen'
        SET ae.status_id = sk.id
        WHERE ae.id = ?
      `,
      [exemplar_id]
    );

    await schreibeHistorieMitConnection(connection, {
      bezug_typ: "ausleihe",
      bezug_id: insertResult.insertId,
      exemplar_id,
      ausleihe_id: insertResult.insertId,
      aktion: "ausgabe",
      titel: `Ausleihe erstellt: ${exemplare[0].inventarnummer}`,
      details: `${exemplare[0].titel} wurde an ${ausleiherRows[0].name} ausgegeben. Faellig am ${wirksameFaelligkeit}.`,
      ausgeloest_von: "weboberflaeche"
    });

    await schreibeHistorieMitConnection(connection, {
      bezug_typ: "exemplar",
      bezug_id: exemplar_id,
      exemplar_id,
      ausleihe_id: insertResult.insertId,
      aktion: "status_aenderung",
      titel: `Status geaendert: ${exemplare[0].inventarnummer}`,
      details: `${exemplare[0].titel} wurde auf ausgeliehen gesetzt.`,
      ausgeloest_von: "weboberflaeche"
    });

    await connection.commit();

    res.status(201).json({
      id: insertResult.insertId,
      meldung: "Ausleihe erfasst.",
      faellig_am: wirksameFaelligkeit
    });
  } catch (error) {
    if (connection) {
      await connection.rollback();
    }
    res.status(500).json({ fehler: error.message });
  } finally {
    connection?.release();
  }
});

app.post("/api/klassensaetze/ausgabe", async (req, res) => {
  const { exemplar_ids, ausleiher_id, faellig_am, kommentar_ausgabe } = req.body;
  const exemplarIds = Array.isArray(exemplar_ids)
    ? [...new Set(exemplar_ids.map((wert) => Number(wert)).filter(Boolean))]
    : [];

  if (!ausleiher_id || exemplarIds.length === 0) {
    return res.status(400).json({ fehler: "Ausleiher und mindestens ein Buch-Exemplar sind erforderlich." });
  }

  let connection;

  try {
    connection = await getConnection();
    await connection.beginTransaction();

    const [ausleiherRows] = await connection.execute(
      `
        SELECT id, name, ausleiher_typ
        FROM ausleiher
        WHERE id = ? AND aktiv = 1
      `,
      [ausleiher_id]
    );

    if (ausleiherRows.length === 0) {
      await connection.rollback();
      return res.status(404).json({ fehler: "Ausleiher wurde nicht gefunden." });
    }

    const platzhalter = exemplarIds.map(() => "?").join(", ");
    const [exemplarRows] = await connection.execute(
      `
        SELECT
          ae.id,
          ae.zustand_id,
          ae.ist_klassensatz,
          ae.klassensatz_name,
          ae.inventarnummer,
          sk.bezeichnung AS status,
          a.titel,
          it.bezeichnung AS inventar_typ
        FROM artikel_exemplare ae
        JOIN artikel a ON a.id = ae.artikel_id
        JOIN inventar_typen it ON it.id = a.inventar_typ_id
        JOIN statuskatalog sk ON sk.id = ae.status_id
        WHERE ae.id IN (${platzhalter})
      `,
      exemplarIds
    );

    if (exemplarRows.length !== exemplarIds.length) {
      await connection.rollback();
      return res.status(404).json({ fehler: "Mindestens ein ausgewaehltes Exemplar wurde nicht gefunden." });
    }

    const ungueltigeExemplare = exemplarRows.filter(
      (eintrag) =>
        eintrag.inventar_typ !== "buch" ||
        !eintrag.ist_klassensatz ||
        eintrag.status !== "verfuegbar"
    );

    if (ungueltigeExemplare.length > 0) {
      await connection.rollback();
      return res.status(409).json({
        fehler: `Diese Exemplare koennen nicht als Klassensatz ausgegeben werden: ${ungueltigeExemplare
          .map((eintrag) => eintrag.inventarnummer)
          .join(", ")}.`
      });
    }

    const wirksameFaelligkeit = berechneStandardFaelligkeit(
      ausleiherRows[0].ausleiher_typ,
      faellig_am
    );
    const erzeugteAusleihen = [];

    await schreibeHistorieMitConnection(connection, {
      bezug_typ: "klassensatz",
      bezug_id: Number(ausleiher_id),
      aktion: "klassensatz_sammelausgabe",
      titel: `Klassensatz-Ausgabe gestartet: ${ausleiherRows[0].name}`,
      details: `${exemplarRows.length} Buch-Exemplare werden an ${ausleiherRows[0].name} ausgegeben. Faellig am ${wirksameFaelligkeit}.`,
      ausgeloest_von: "weboberflaeche"
    });

    for (const exemplar of exemplarRows) {
      const [insertResult] = await connection.execute(
        `
          INSERT INTO ausleihen (
            exemplar_id,
            ausleiher_id,
            faellig_am,
            zustand_bei_ausgabe_id,
            kommentar_ausgabe
          )
          VALUES (?, ?, ?, ?, ?)
        `,
        [
          exemplar.id,
          ausleiher_id,
          wirksameFaelligkeit,
          exemplar.zustand_id,
          kommentar_ausgabe || null
        ]
      );

      await connection.execute(
        `
          UPDATE artikel_exemplare ae
          JOIN statuskatalog sk ON sk.bezeichnung = 'ausgeliehen'
          SET ae.status_id = sk.id
          WHERE ae.id = ?
        `,
        [exemplar.id]
      );

      await schreibeHistorieMitConnection(connection, {
        bezug_typ: "ausleihe",
        bezug_id: insertResult.insertId,
        exemplar_id: exemplar.id,
        ausleihe_id: insertResult.insertId,
        aktion: "klassensatz_ausgabe",
        titel: `Klassensatz ausgegeben: ${exemplar.inventarnummer}`,
        details: `${exemplar.titel}${exemplar.klassensatz_name ? ` (${exemplar.klassensatz_name})` : ""} wurde an ${ausleiherRows[0].name} ausgegeben. Faellig am ${wirksameFaelligkeit}.`,
        ausgeloest_von: "weboberflaeche"
      });

      await schreibeHistorieMitConnection(connection, {
        bezug_typ: "exemplar",
        bezug_id: exemplar.id,
        exemplar_id: exemplar.id,
        ausleihe_id: insertResult.insertId,
        aktion: "status_aenderung",
        titel: `Status geaendert: ${exemplar.inventarnummer}`,
        details: `${exemplar.titel} wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.`,
        ausgeloest_von: "weboberflaeche"
      });

      erzeugteAusleihen.push(insertResult.insertId);
    }

    await connection.commit();

    res.status(201).json({
      meldung: "Klassensatz-Ausgabe erfasst.",
      anzahl: erzeugteAusleihen.length,
      faellig_am: wirksameFaelligkeit,
      ausleihen: erzeugteAusleihen
    });
  } catch (error) {
    if (connection) {
      await connection.rollback();
    }
    res.status(500).json({ fehler: error.message });
  } finally {
    if (connection) {
      connection.release();
    }
  }
});

app.post("/api/ausleihen/:id/rueckgabe", async (req, res) => {
  const ausleiheId = Number(req.params.id);
  const { zustand_bei_rueckgabe, kommentar_rueckgabe } = req.body;

  if (!ausleiheId || !zustand_bei_rueckgabe) {
    return res.status(400).json({ fehler: "Rueckgabezustand ist erforderlich." });
  }

  try {
    const ausleihen = await query(
      `
        SELECT
          al.id,
          al.exemplar_id,
          al.status,
          z.id AS rueckgabe_zustand_id,
          ae.inventarnummer,
          a.titel AS artikel_titel,
          aus.name AS ausleiher_name
        FROM ausleihen al
        JOIN zustandskatalog z ON z.bezeichnung = ?
        JOIN artikel_exemplare ae ON ae.id = al.exemplar_id
        JOIN artikel a ON a.id = ae.artikel_id
        JOIN ausleiher aus ON aus.id = al.ausleiher_id
        WHERE al.id = ?
      `,
      [zustand_bei_rueckgabe, ausleiheId]
    );

    if (ausleihen.length === 0) {
      return res.status(404).json({ fehler: "Ausleihe oder Rueckgabezustand nicht gefunden." });
    }

    const ausleihe = ausleihen[0];

    if (ausleihe.status !== "offen") {
      return res.status(409).json({ fehler: "Diese Ausleihe ist bereits abgeschlossen." });
    }

    await query(
      `
        UPDATE ausleihen
        SET
          rueckgabe_am = NOW(),
          zustand_bei_rueckgabe_id = ?,
          kommentar_rueckgabe = ?,
          status = 'zurueckgegeben'
        WHERE id = ?
      `,
      [ausleihe.rueckgabe_zustand_id, kommentar_rueckgabe || null, ausleiheId]
    );

    const neuerStatus = zustand_bei_rueckgabe === "beschaedigt" ? "defekt" : "verfuegbar";

    await query(
      `
        UPDATE artikel_exemplare ae
        JOIN statuskatalog sk ON sk.bezeichnung = ?
        JOIN zustandskatalog zk ON zk.bezeichnung = ?
        SET
          ae.status_id = sk.id,
          ae.zustand_id = zk.id
        WHERE ae.id = ?
      `,
      [neuerStatus, zustand_bei_rueckgabe, ausleihe.exemplar_id]
    );

    await schreibeHistorie({
      bezug_typ: "ausleihe",
      bezug_id: ausleiheId,
      exemplar_id: ausleihe.exemplar_id,
      ausleihe_id: ausleiheId,
      aktion: "rueckgabe",
      titel: `Rueckgabe verbucht: ${ausleihe.inventarnummer}`,
      details: `${ausleihe.artikel_titel} wurde von ${ausleihe.ausleiher_name} zurueckgegeben. Zustand: ${zustand_bei_rueckgabe}.${kommentar_rueckgabe ? ` Kommentar: ${kommentar_rueckgabe}` : ""}`,
      ausgeloest_von: "weboberflaeche"
    });

    await schreibeHistorie({
      bezug_typ: "exemplar",
      bezug_id: ausleihe.exemplar_id,
      exemplar_id: ausleihe.exemplar_id,
      ausleihe_id: ausleiheId,
      aktion: "status_aenderung",
      titel: `Status geaendert: ${ausleihe.inventarnummer}`,
      details: `${ausleihe.artikel_titel} wurde auf ${neuerStatus} gesetzt.`,
      ausgeloest_von: "weboberflaeche"
    });

    await schreibeHistorie({
      bezug_typ: "exemplar",
      bezug_id: ausleihe.exemplar_id,
      exemplar_id: ausleihe.exemplar_id,
      ausleihe_id: ausleiheId,
      aktion: "zustandsaenderung",
      titel: `Zustand geaendert: ${ausleihe.inventarnummer}`,
      details: `${ausleihe.artikel_titel} wurde mit Zustand ${zustand_bei_rueckgabe} verbucht.`,
      ausgeloest_von: "weboberflaeche"
    });

    res.json({ meldung: "Rueckgabe verbucht." });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.post("/api/ausleihen/:id/verlaengern", async (req, res) => {
  const ausleiheId = Number(req.params.id);
  const { faellig_am, kommentar_verlaengerung } = req.body;

  if (!ausleiheId || !faellig_am) {
    return res.status(400).json({ fehler: "Neue Faelligkeit ist erforderlich." });
  }

  try {
    const ausleihen = await query(
      `
        SELECT
          al.id,
          al.exemplar_id,
          al.status,
          al.faellig_am AS bisher_faellig_am,
          ae.inventarnummer,
          a.titel AS artikel_titel,
          aus.name AS ausleiher_name
        FROM ausleihen al
        JOIN artikel_exemplare ae ON ae.id = al.exemplar_id
        JOIN artikel a ON a.id = ae.artikel_id
        JOIN ausleiher aus ON aus.id = al.ausleiher_id
        WHERE al.id = ?
      `,
      [ausleiheId]
    );

    if (ausleihen.length === 0) {
      return res.status(404).json({ fehler: "Ausleihe wurde nicht gefunden." });
    }

    const ausleihe = ausleihen[0];

    if (ausleihe.status !== "offen") {
      return res.status(409).json({ fehler: "Diese Ausleihe ist bereits abgeschlossen." });
    }

    if (!ausleihe.bisher_faellig_am) {
      return res.status(409).json({ fehler: "Verlaengern ist nur mit bestehender Faelligkeit moeglich." });
    }

    const bisherigeZeit = new Date(ausleihe.bisher_faellig_am).getTime();
    const neueZeit = new Date(faellig_am).getTime();

    if (Number.isNaN(bisherigeZeit) || Number.isNaN(neueZeit) || neueZeit <= bisherigeZeit) {
      return res.status(409).json({ fehler: "Die neue Faelligkeit muss spaeter als die aktuelle Faelligkeit sein." });
    }

    await query(
      `
        UPDATE ausleihen
        SET faellig_am = ?
        WHERE id = ?
      `,
      [faellig_am, ausleiheId]
    );

    await schreibeHistorie({
      bezug_typ: "ausleihe",
      bezug_id: ausleiheId,
      exemplar_id: ausleihe.exemplar_id,
      ausleihe_id: ausleiheId,
      aktion: "verlaengerung",
      titel: `Ausleihe verlaengert: ${ausleihe.inventarnummer}`,
      details: `${ausleihe.artikel_titel} fuer ${ausleihe.ausleiher_name} wurde von ${ausleihe.bisher_faellig_am || "ohne Frist"} auf ${faellig_am} verlaengert.${kommentar_verlaengerung ? ` Kommentar: ${kommentar_verlaengerung}` : ""}`,
      ausgeloest_von: "weboberflaeche"
    });

    res.json({
      meldung: "Ausleihe wurde verlaengert.",
      faellig_am
    });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.patch("/api/exemplare/:id", async (req, res) => {
  const exemplarId = Number(req.params.id);
  const { status, zustand, standort_id, notizen, ausgeloest_von = "weboberflaeche" } = req.body;

  if (!exemplarId) {
    return res.status(400).json({ fehler: "Gueltige Exemplar-ID erforderlich." });
  }

  try {
    const rows = await query(
      `
        SELECT
          ae.id,
          ae.notizen,
          ae.standort_id,
          ae.status_id,
          ae.zustand_id,
          ae.inventarnummer,
          a.titel,
          sk.bezeichnung AS status,
          zk.bezeichnung AS zustand,
          st.bezeichnung AS standort
        FROM artikel_exemplare ae
        JOIN artikel a ON a.id = ae.artikel_id
        JOIN statuskatalog sk ON sk.id = ae.status_id
        JOIN zustandskatalog zk ON zk.id = ae.zustand_id
        LEFT JOIN standorte st ON st.id = ae.standort_id
        WHERE ae.id = ?
      `,
      [exemplarId]
    );

    if (rows.length === 0) {
      return res.status(404).json({ fehler: "Exemplar nicht gefunden." });
    }

    const alt = rows[0];
    const neuerStatus = status || alt.status;
    const neuerZustand = zustand || alt.zustand;
    const neuerStandortId =
      standort_id === null || standort_id === "" ? null : Number(standort_id ?? alt.standort_id);
    const neueNotizen = typeof notizen === "string" ? notizen : alt.notizen;

    await query(
      `
        UPDATE artikel_exemplare ae
        JOIN statuskatalog sk ON sk.bezeichnung = ?
        JOIN zustandskatalog zk ON zk.bezeichnung = ?
        SET
          ae.status_id = sk.id,
          ae.zustand_id = zk.id,
          ae.standort_id = ?,
          ae.notizen = ?
        WHERE ae.id = ?
      `,
      [neuerStatus, neuerZustand, neuerStandortId, neueNotizen, exemplarId]
    );

    if (alt.status !== neuerStatus) {
      await schreibeHistorie({
        bezug_typ: "exemplar",
        bezug_id: exemplarId,
        exemplar_id: exemplarId,
        aktion: "status_aenderung",
        titel: `Status geaendert: ${alt.inventarnummer}`,
        details: `${alt.titel} wurde von ${alt.status} auf ${neuerStatus} gesetzt.`,
        ausgeloest_von
      });
    }

    if (alt.zustand !== neuerZustand) {
      await schreibeHistorie({
        bezug_typ: "exemplar",
        bezug_id: exemplarId,
        exemplar_id: exemplarId,
        aktion: "zustandsaenderung",
        titel: `Zustand geaendert: ${alt.inventarnummer}`,
        details: `${alt.titel} wurde von ${alt.zustand} auf ${neuerZustand} gesetzt.`,
        ausgeloest_von
      });
    }

    if ((alt.standort_id ?? null) !== (neuerStandortId ?? null)) {
      const standortRows = neuerStandortId
        ? await query(`SELECT bezeichnung FROM standorte WHERE id = ?`, [neuerStandortId])
        : [];
      const neuerStandortName = standortRows[0]?.bezeichnung || "unbekannt";

      await schreibeHistorie({
        bezug_typ: "exemplar",
        bezug_id: exemplarId,
        exemplar_id: exemplarId,
        aktion: "standortaenderung",
        titel: `Standort geaendert: ${alt.inventarnummer}`,
        details: `${alt.titel} wurde von ${alt.standort || "unbekannt"} nach ${neuerStandortName} verschoben.`,
        ausgeloest_von
      });
    }

    if ((alt.notizen || "") !== (neueNotizen || "")) {
      await schreibeHistorie({
        bezug_typ: "exemplar",
        bezug_id: exemplarId,
        exemplar_id: exemplarId,
        aktion: "notiz_aenderung",
        titel: `Notiz aktualisiert: ${alt.inventarnummer}`,
        details: `${alt.titel} hat aktualisierte Notizen erhalten.`,
        ausgeloest_von
      });
    }

    res.json({ meldung: "Exemplar aktualisiert." });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.delete("/api/exemplare", async (req, res) => {
  const ids = req.body?.ids;

  if (!Array.isArray(ids) || ids.length === 0) {
    return res.status(400).json({ fehler: "Keine Exemplar-IDs angegeben." });
  }

  const numIds = ids.map(Number).filter((n) => n > 0);
  if (numIds.length === 0) {
    return res.status(400).json({ fehler: "Ungueltige IDs." });
  }

  try {
    const platzhalter = numIds.map(() => "?").join(", ");
    const rows = await query(
      `
        SELECT ae.id, ae.inventarnummer, a.titel, sk.bezeichnung AS status
        FROM artikel_exemplare ae
        JOIN artikel a ON a.id = ae.artikel_id
        JOIN statuskatalog sk ON sk.id = ae.status_id
        WHERE ae.id IN (${platzhalter}) AND ae.aktiv = 1
      `,
      numIds
    );

    if (rows.length !== numIds.length) {
      return res.status(404).json({ fehler: "Einige Exemplare wurden nicht gefunden." });
    }

    const nichtVerfuegbar = rows.filter((r) => r.status !== "verfuegbar");
    if (nichtVerfuegbar.length > 0) {
      const liste = nichtVerfuegbar.map((r) => r.inventarnummer).join(", ");
      return res.status(409).json({
        fehler: `Folgende Exemplare sind nicht verfuegbar und koennen nicht geloescht werden: ${liste}`
      });
    }

    await query(
      `UPDATE artikel_exemplare SET aktiv = 0 WHERE id IN (${platzhalter})`,
      numIds
    );

    for (const row of rows) {
      await schreibeHistorie({
        bezug_typ: "exemplar",
        bezug_id: row.id,
        exemplar_id: row.id,
        aktion: "geloescht",
        titel: `Exemplar geloescht: ${row.inventarnummer}`,
        details: `${row.titel} (${row.inventarnummer}) wurde aus dem Bestand entfernt.`,
        ausgeloest_von: "weboberflaeche"
      });
    }

    res.json({ meldung: `${numIds.length} Exemplar(e) geloescht.` });
  } catch (error) {
    res.status(500).json({ fehler: error.message });
  }
});

app.get(/^\/(?!api(?:\/|$)).*/, (_req, res) => {
  res.sendFile(distIndexPath, (error) => {
    if (!error) {
      return;
    }

    if (error.code === "ENOENT") {
      res.status(503).send(
        "Kein Frontend-Build gefunden. Bitte zuerst 'npm run demo:build' oder 'npm run build' ausfuehren."
      );
      return;
    }

    res.status(500).send("Frontend konnte nicht geladen werden.");
  });
});

app.use("/api", (_req, res) => {
  res.status(404).json({ fehler: "API-Endpunkt nicht gefunden." });
});

await initialisiereEinstellungstabelle();
await initialisiereSchuelerConstraints();
await initializeContractModule();

const server = app.listen(port, () => {
  console.log(`API aktiv auf http://localhost:${port}`);
  console.log(`API-Dokumentation unter http://localhost:${port}/api/docs`);

  if (existsSync(distIndexPath)) {
    console.log(`Lokales Frontend-Build unter http://localhost:${port} (${distDir})`);
  } else {
    console.log("Kein lokales Frontend-Build gefunden. Erwartet wurde index.html unter frontend/dist oder dist. Im Docker-Produktivbetrieb liefert Nginx das Frontend auf Port 8080 aus.");
  }
});

async function shutdown() {
  server.close(async () => {
    await closePool();
    process.exit(0);
  });
}

process.on("SIGINT", shutdown);
process.on("SIGTERM", shutdown);
