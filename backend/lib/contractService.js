import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import Handlebars from "handlebars";
import puppeteer from "puppeteer";
import { getConnection, query } from "../db.js";

const currentFile = fileURLToPath(import.meta.url);
const currentDir = path.dirname(currentFile);
const backendDir = path.resolve(currentDir, "..");
const contractTemplatePath = path.join(backendDir, "templates", "leihvertrag", "layout.hbs");
const contractCssPath = path.join(backendDir, "templates", "leihvertrag", "styles.css");
const contractStorageDir = path.join(backendDir, "storage", "leihvertraege");
const contractTemplateAssetDir = path.join(backendDir, "templates", "leihvertrag", "assets");
const contractLetterheadDir = path.join(contractTemplateAssetDir, "briefkoepfe");

export const CONTRACT_TYPES = ["tablet", "laptop", "wlan"];

export const SCHOOL_CONTRACT_PARTNER = {
  schulname: "Musterschule",
  adresse: "Musterweg 10, 41434 Neuss",
  vertretung: "Schulleiter Herr Meier Schulte",
  ort: "Neuss"
};

function sanitizeFilenameSegment(value, fallback = "Unbekannt") {
  const text = String(value ?? "")
    .trim()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/[^a-zA-Z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");

  return text || fallback;
}

function escapeHtml(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

function formatGermanDateForPdf(value) {
  const date = value instanceof Date ? value : new Date(value);

  if (Number.isNaN(date.getTime())) {
    return "";
  }

  return new Intl.DateTimeFormat("de-DE", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric"
  }).format(date);
}

function buildPdfFooterTemplate({ ort, generatedAt, schulname, seitenrand_links_mm, seitenrand_rechts_mm }) {
  const leftText = escapeHtml([ort, formatGermanDateForPdf(generatedAt)].filter(Boolean).join(", "));
  const rightText = escapeHtml(schulname);
  const paddingLeft = formatMarginMm(seitenrand_links_mm ?? DEFAULT_PAGE_MARGINS_MM.left);
  const paddingRight = formatMarginMm(seitenrand_rechts_mm ?? DEFAULT_PAGE_MARGINS_MM.right);

  return `
    <div style="width:100%; font-size:12px; color:#4b5563; padding:0 ${paddingRight} 0 ${paddingLeft}; box-sizing:border-box;">
      <div style="position:relative; width:100%; border-top:1px solid #d1d5db; padding-top:3mm;">
        <span>${leftText}</span>
        <span style="position:absolute; left:50%; transform:translateX(-50%); white-space:nowrap;">
          Seite:<span class="pageNumber"></span>
        </span>
        <span style="float:right;">${rightText}</span>
      </div>
    </div>
  `;
}

const PLACEHOLDER_SECTION_LIBRARY = {
  tablet: [
    {
      titel: "Nutzung des Tablets",
      abschnitt_art: "rechtstext",
      html_inhalt: `
        <p>Das ausgegebene Tablet bleibt Eigentum der Schule. Es ist ausschliesslich fuer schulische Zwecke, das Lernen zu Hause sowie fuer abgestimmte Unterrichtsvorhaben zu verwenden.</p>
        <p>Installationen, Konten und Schutzeinstellungen duerfen nur im durch die Schule freigegebenen Rahmen veraendert werden. Sicherheits- und Jugendschutzvorgaben sind einzuhalten.</p>
      `
    },
    {
      titel: "Sorgfalt und Haftung",
      abschnitt_art: "rechtstext",
      html_inhalt: `
        <p>Das Geraet ist pfleglich zu behandeln und vor Verlust, Diebstahl, Feuchtigkeit sowie unsachgemaesser Nutzung zu schuetzen. Schaeden oder Funktionsstoerungen sind unverzueglich der Schule mitzuteilen.</p>
        <p>Bei vorsetzlicher oder grob fahrlaessiger Beschaedigung koennen schul- oder zivilrechtliche Folgen entstehen. Die konkrete Pruefung erfolgt im Einzelfall.</p>
      `
    },
    {
      titel: "Rueckgabe und Daten",
      abschnitt_art: "rechtstext",
      html_inhalt: `
        <p>Das Tablet ist auf Aufforderung der Schule, bei Schulwechsel oder am Ende der vereinbarten Nutzung vollstaendig zurueckzugeben. Dazu gehoeren auch ausgegebenes Zubehoer und Schutzmaterialien.</p>
        <p>Vor der Rueckgabe koennen schulische Konten, Profile oder Daten im notwendigen Umfang entfernt werden. Private Daten sind durch die nutzende Person rechtzeitig selbst zu sichern.</p>
      `
    }
  ],
  laptop: [
    {
      titel: "Nutzung des Laptops",
      abschnitt_art: "rechtstext",
      html_inhalt: `
        <p>Der Laptop wird fuer schulische Aufgaben, digitale Lernangebote und abgestimmte Heimarbeit zur Verfuegung gestellt. Die Nutzung erfolgt im Rahmen der schulischen Ordnungen und Weisungen.</p>
        <p>Manipulationen am Betriebssystem, an Verwaltungssoftware oder an Schutzmechanismen sind unzulaessig, sofern sie nicht durch die Schule freigegeben wurden.</p>
      `
    },
    {
      titel: "Pflege, Transport und Meldungen",
      abschnitt_art: "rechtstext",
      html_inhalt: `
        <p>Der Laptop ist transportsicher aufzubewahren und vor Beschaedigungen zu schuetzen. Netzteil, Eingabegeraete und weiteres Zubehoer sind gemeinsam mit dem Hauptgeraet sorgfaeltig zu verwahren.</p>
        <p>Defekte, Verlust oder Missbrauchsverdacht muessen ohne schuldhaftes Zoegern gemeldet werden, damit Schutz- und Sperrmassnahmen veranlasst werden koennen.</p>
      `
    },
    {
      titel: "Rueckgabe",
      abschnitt_art: "rechtstext",
      html_inhalt: `
        <p>Die Rueckgabe erfolgt in sauberem, vollstaendigem und moeglichst funktionsfaehigem Zustand. Vorhandene Benutzerdaten sind eigenverantwortlich zu sichern.</p>
        <p>Die Schule kann zur Vorbereitung einer Weitergabe ein Zuruecksetzen, Neuaufsetzen oder die Entfernung verwalteter Inhalte vornehmen.</p>
      `
    }
  ],
  wlan: [
    {
      titel: "Zweck der Ueberlassung",
      abschnitt_art: "rechtstext",
      html_inhalt: `
        <p>Die bereitgestellte WLAN-Komponente beziehungsweise das zugeordnete Netzzugangsmittel dient der Teilnahme an schulischen Lern- und Kommunikationsangeboten im abgestimmten Rahmen.</p>
        <p>Die Nutzung ist auf berechtigte Personen beschraenkt. Zugangsdaten oder technische Komponenten duerfen nicht unbefugt an Dritte weitergegeben werden.</p>
      `
    },
    {
      titel: "Sicherheit und Verantwortlichkeit",
      abschnitt_art: "rechtstext",
      html_inhalt: `
        <p>Die ausgegebenen Komponenten sind vor Verlust und unbefugtem Zugriff zu schuetzen. Bei Stoerungen, Missbrauchsverdacht oder Verlust ist die Schule unmittelbar zu informieren.</p>
        <p>Es gelten die schulischen Regeln zur IT-Nutzung, zum Datenschutz und zur Informationssicherheit in ihrer jeweils gueltigen Fassung.</p>
      `
    },
    {
      titel: "Beendigung der Nutzung",
      abschnitt_art: "rechtstext",
      html_inhalt: `
        <p>Mit Ende der Berechtigung oder auf Anforderung der Schule sind ausgegebene Komponenten unverzueglich zurueckzugeben beziehungsweise Zugangsdaten nicht weiter zu verwenden.</p>
        <p>Die Schule kann Zugriffe aus organisatorischen oder sicherheitsrelevanten Gruenden jederzeit einschraenken oder beenden.</p>
      `
    }
  ]
};

const DEFAULT_PAGE_MARGINS_MM = {
  top: 14,
  right: 12,
  bottom: 18,
  left: 12
};

Handlebars.registerHelper("formatGermanDate", (value) => {
  if (!value) return "-";
  const parsed = new Date(value);
  if (Number.isNaN(parsed.getTime())) return String(value);

  return new Intl.DateTimeFormat("de-DE", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric"
  }).format(parsed);
});

Handlebars.registerHelper("formatGermanDateTime", (value) => {
  if (!value) return "-";
  const parsed = new Date(value);
  if (Number.isNaN(parsed.getTime())) return String(value);

  return new Intl.DateTimeFormat("de-DE", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit"
  }).format(parsed);
});

Handlebars.registerHelper("eq", (left, right) => left === right);

function assertContractType(typ) {
  const normalized = String(typ || "").trim().toLowerCase();
  if (!CONTRACT_TYPES.includes(normalized)) {
    throw new Error("Unbekannter Vertragstyp.");
  }
  return normalized;
}

function normalizeTemplateSections(sections) {
  if (!Array.isArray(sections) || sections.length === 0) {
    throw new Error("Mindestens ein Rechtstext-Abschnitt ist erforderlich.");
  }

  return sections.map((section, index) => {
    const titel = String(section?.titel || "").trim();
    const htmlInhalt = String(section?.html_inhalt || "").trim();
    const abschnittArt = String(section?.abschnitt_art || "rechtstext").trim() || "rechtstext";

    if (!titel) {
      throw new Error(`Abschnitt ${index + 1} hat keinen Titel.`);
    }

    if (!htmlInhalt) {
      throw new Error(`Abschnitt ${index + 1} hat keinen Inhalt.`);
    }

    return {
      titel,
      abschnitt_art: abschnittArt,
      sortier_nr: Number(section?.sortier_nr) || index + 1,
      html_inhalt: htmlInhalt
    };
  });
}

function normalizeLetterheadPng(value) {
  const normalized = String(value || "").trim();

  if (!normalized) {
    return null;
  }

  if (!/^data:image\/png;base64,/i.test(normalized)) {
    throw new Error("Der Briefkopf muss als PNG-Bild hinterlegt werden.");
  }

  return normalized;
}

function normalizeLetterheadPath(value) {
  const normalized = String(value || "").trim().replace(/\\/g, "/");

  if (!normalized) {
    return null;
  }

  if (!/^briefkoepfe\/[a-zA-Z0-9._-]+\.png$/i.test(normalized)) {
    throw new Error("Der Briefkopf-Pfad ist ungueltig.");
  }

  return normalized;
}

function resolveTemplateAssetPath(relativePath) {
  const normalized = normalizeLetterheadPath(relativePath);

  if (!normalized) {
    return null;
  }

  return path.join(contractTemplateAssetDir, normalized);
}

async function storeLetterheadAsset({ pngDataUrl, typ }) {
  const normalizedPng = normalizeLetterheadPng(pngDataUrl);

  if (!normalizedPng) {
    return null;
  }

  const match = normalizedPng.match(/^data:image\/png;base64,(.+)$/i);
  if (!match) {
    throw new Error("Der Briefkopf muss als PNG-Bild hinterlegt werden.");
  }

  const fileBuffer = Buffer.from(match[1], "base64");
  const fileName = `${sanitizeFilenameSegment(typ || "vertrag", "vertrag")}_${Date.now()}.png`;
  const relativePath = path.posix.join("briefkoepfe", fileName);
  const absolutePath = resolveTemplateAssetPath(relativePath);

  await fs.mkdir(contractLetterheadDir, { recursive: true });
  await fs.writeFile(absolutePath, fileBuffer);

  return relativePath;
}

async function readLetterheadAssetAsDataUrl(relativePath) {
  const absolutePath = resolveTemplateAssetPath(relativePath);

  if (!absolutePath) {
    return null;
  }

  try {
    const fileBuffer = await fs.readFile(absolutePath);
    return `data:image/png;base64,${fileBuffer.toString("base64")}`;
  } catch {
    return null;
  }
}

function normalizePageMarginMm(value, label, fallback) {
  if (value === undefined || value === null || value === "") {
    return fallback;
  }

  const normalized = Number(value);

  if (!Number.isFinite(normalized)) {
    throw new Error(`Der Seitenrand ${label} ist ungueltig.`);
  }

  if (normalized < 0 || normalized > 50) {
    throw new Error(`Der Seitenrand ${label} muss zwischen 0 und 50 mm liegen.`);
  }

  return Math.round(normalized * 100) / 100;
}

function normalizeTemplateLayout(layout = {}) {
  const uploadedLetterhead = normalizeLetterheadPng(
    layout.briefkopf_upload ?? (String(layout.briefkopf_png || "").trim().startsWith("data:image/") ? layout.briefkopf_png : null)
  );
  const storedLetterheadPath = normalizeLetterheadPath(
    layout.briefkopf_pfad ?? (uploadedLetterhead ? null : layout.briefkopf_png)
  );

  return {
    briefkopf_pfad: storedLetterheadPath,
    briefkopf_upload: uploadedLetterhead,
    seitenrand_oben_mm: normalizePageMarginMm(layout.seitenrand_oben_mm, "oben", DEFAULT_PAGE_MARGINS_MM.top),
    seitenrand_rechts_mm: normalizePageMarginMm(layout.seitenrand_rechts_mm, "rechts", DEFAULT_PAGE_MARGINS_MM.right),
    seitenrand_unten_mm: normalizePageMarginMm(layout.seitenrand_unten_mm, "unten", DEFAULT_PAGE_MARGINS_MM.bottom),
    seitenrand_links_mm: normalizePageMarginMm(layout.seitenrand_links_mm, "links", DEFAULT_PAGE_MARGINS_MM.left)
  };
}

function formatMarginMm(value) {
  return `${Number(value)}mm`;
}

function buildContractCss(cssSource, layout) {
  return cssSource
    .replaceAll("__PAGE_MARGIN_TOP__", formatMarginMm(layout.seitenrand_oben_mm))
    .replaceAll("__PAGE_MARGIN_RIGHT__", formatMarginMm(layout.seitenrand_rechts_mm))
    .replaceAll("__PAGE_MARGIN_BOTTOM__", formatMarginMm(layout.seitenrand_unten_mm))
    .replaceAll("__PAGE_MARGIN_LEFT__", formatMarginMm(layout.seitenrand_links_mm))
    .replaceAll("__PAGE_MARGIN_TOP_VALUE__", formatMarginMm(layout.seitenrand_oben_mm))
    .replaceAll("__PAGE_MARGIN_BOTTOM_VALUE__", formatMarginMm(layout.seitenrand_unten_mm));
}

async function loadContractRenderer() {
  const [templateSource, cssSource] = await Promise.all([
    fs.readFile(contractTemplatePath, "utf8"),
    fs.readFile(contractCssPath, "utf8")
  ]);

  return {
    render: Handlebars.compile(templateSource),
    css: cssSource
  };
}

async function createTemplateVersionWithConnection(connection, { typ, name, sections, layout = {}, aktiv = true }) {
  const normalizedType = assertContractType(typ);
  const normalizedSections = normalizeTemplateSections(sections);
  const normalizedName = String(name || "").trim() || `Leihvertrag ${normalizedType}`;
  const normalizedLayout = normalizeTemplateLayout(layout);
  const storedLetterheadPath = normalizedLayout.briefkopf_upload
    ? await storeLetterheadAsset({ pngDataUrl: normalizedLayout.briefkopf_upload, typ: normalizedType })
    : normalizedLayout.briefkopf_pfad;

  const [maxVersionRows] = await connection.execute(
    `
      SELECT MAX(version) AS max_version
      FROM vertrags_vorlagen
      WHERE typ = ?
    `,
    [normalizedType]
  );

  const nextVersion = Number(maxVersionRows[0]?.max_version || 0) + 1;

  if (aktiv) {
    await connection.execute(
      `
        UPDATE vertrags_vorlagen
        SET aktiv = 0
        WHERE typ = ?
      `,
      [normalizedType]
    );
  }

  const [insertResult] = await connection.execute(
    `
      INSERT INTO vertrags_vorlagen (
        name,
        typ,
        version,
        briefkopf_png,
        seitenrand_oben_mm,
        seitenrand_rechts_mm,
        seitenrand_unten_mm,
        seitenrand_links_mm,
        aktiv
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `,
    [
      normalizedName,
      normalizedType,
      nextVersion,
      storedLetterheadPath,
      normalizedLayout.seitenrand_oben_mm,
      normalizedLayout.seitenrand_rechts_mm,
      normalizedLayout.seitenrand_unten_mm,
      normalizedLayout.seitenrand_links_mm,
      aktiv ? 1 : 0
    ]
  );

  for (const section of normalizedSections.sort((left, right) => left.sortier_nr - right.sortier_nr)) {
    await connection.execute(
      `
        INSERT INTO vertrags_abschnitte (
          v_vorlage_id,
          titel,
          abschnitt_art,
          sortier_nr,
          html_inhalt
        )
        VALUES (?, ?, ?, ?, ?)
      `,
      [
        insertResult.insertId,
        section.titel,
        section.abschnitt_art,
        section.sortier_nr,
        section.html_inhalt
      ]
    );
  }

  return Number(insertResult.insertId);
}

export async function initializeContractModule() {
  await query(`
    CREATE TABLE IF NOT EXISTS vertrags_vorlagen (
      v_vorlage_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
      name VARCHAR(190) NOT NULL,
      typ VARCHAR(50) NOT NULL,
      version INT NOT NULL,
      briefkopf_png LONGTEXT NULL,
      seitenrand_oben_mm DECIMAL(5,2) NOT NULL DEFAULT 14.00,
      seitenrand_rechts_mm DECIMAL(5,2) NOT NULL DEFAULT 12.00,
      seitenrand_unten_mm DECIMAL(5,2) NOT NULL DEFAULT 18.00,
      seitenrand_links_mm DECIMAL(5,2) NOT NULL DEFAULT 12.00,
      aktiv TINYINT(1) NOT NULL DEFAULT 1,
      erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (v_vorlage_id),
      UNIQUE KEY uq_vertrags_vorlagen_typ_version (typ, version),
      KEY idx_vertrags_vorlagen_typ_aktiv (typ, aktiv)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `);

  const briefkopfColumnRows = await query(`
    SHOW COLUMNS FROM vertrags_vorlagen LIKE 'briefkopf_png'
  `);

  if (!briefkopfColumnRows.length) {
    await query(`
      ALTER TABLE vertrags_vorlagen
      ADD COLUMN briefkopf_png LONGTEXT NULL AFTER version
    `);
  }

  const legacyLetterheads = await query(`
    SELECT v_vorlage_id, typ, briefkopf_png
    FROM vertrags_vorlagen
    WHERE briefkopf_png IS NOT NULL
      AND briefkopf_png LIKE 'data:image/png;base64,%'
  `);

  for (const row of legacyLetterheads) {
    const storedLetterheadPath = await storeLetterheadAsset({
      pngDataUrl: row.briefkopf_png,
      typ: row.typ
    });

    await query(
      `
        UPDATE vertrags_vorlagen
        SET briefkopf_png = ?
        WHERE v_vorlage_id = ?
      `,
      [storedLetterheadPath, row.v_vorlage_id]
    );
  }

  const marginColumns = [
    {
      name: "seitenrand_oben_mm",
      definition: "DECIMAL(5,2) NOT NULL DEFAULT 14.00 AFTER briefkopf_png"
    },
    {
      name: "seitenrand_rechts_mm",
      definition: "DECIMAL(5,2) NOT NULL DEFAULT 12.00 AFTER seitenrand_oben_mm"
    },
    {
      name: "seitenrand_unten_mm",
      definition: "DECIMAL(5,2) NOT NULL DEFAULT 18.00 AFTER seitenrand_rechts_mm"
    },
    {
      name: "seitenrand_links_mm",
      definition: "DECIMAL(5,2) NOT NULL DEFAULT 12.00 AFTER seitenrand_unten_mm"
    }
  ];

  for (const column of marginColumns) {
    const existingColumn = await query(`
      SHOW COLUMNS FROM vertrags_vorlagen LIKE '${column.name}'
    `);

    if (!existingColumn.length) {
      await query(`
        ALTER TABLE vertrags_vorlagen
        ADD COLUMN ${column.name} ${column.definition}
      `);
    }
  }

  await query(`
    CREATE TABLE IF NOT EXISTS vertrags_abschnitte (
      v_abschnitt_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
      v_vorlage_id INT UNSIGNED NOT NULL,
      titel VARCHAR(190) NOT NULL,
      abschnitt_art VARCHAR(50) NOT NULL DEFAULT 'rechtstext',
      sortier_nr INT NOT NULL DEFAULT 1,
      html_inhalt LONGTEXT NOT NULL,
      erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      PRIMARY KEY (v_abschnitt_id),
      KEY idx_vertrags_abschnitte_vorlage (v_vorlage_id, sortier_nr),
      CONSTRAINT fk_vertrags_abschnitte_vorlage
        FOREIGN KEY (v_vorlage_id) REFERENCES vertrags_vorlagen (v_vorlage_id)
        ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `);

  await query(`
    CREATE TABLE IF NOT EXISTS leihvertraege (
      id INT UNSIGNED NOT NULL AUTO_INCREMENT,
      ausleiher_id INT UNSIGNED NOT NULL,
      ausleiher_typ VARCHAR(50) NOT NULL,
      erzeugungsdatum DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
      vertragstyp VARCHAR(50) NOT NULL,
      pdf_pfad VARCHAR(500) NOT NULL,
      vorlagen_version INT NOT NULL,
      v_vorlage_id INT UNSIGNED NOT NULL,
      PRIMARY KEY (id),
      KEY idx_leihvertraege_ausleiher (ausleiher_id, erzeugungsdatum),
      KEY idx_leihvertraege_typ (vertragstyp),
      KEY idx_leihvertraege_vorlage (v_vorlage_id),
      CONSTRAINT fk_leihvertraege_ausleiher
        FOREIGN KEY (ausleiher_id) REFERENCES ausleiher (id),
      CONSTRAINT fk_leihvertraege_vorlage
        FOREIGN KEY (v_vorlage_id) REFERENCES vertrags_vorlagen (v_vorlage_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `);

  await query(`
    CREATE TABLE IF NOT EXISTS leihvertraege_positionen (
      leihvertrag_id INT UNSIGNED NOT NULL,
      artikel_exemplar_id INT UNSIGNED NOT NULL,
      PRIMARY KEY (leihvertrag_id, artikel_exemplar_id),
      KEY idx_leihvertraege_positionen_exemplar (artikel_exemplar_id),
      CONSTRAINT fk_leihvertraege_positionen_vertrag
        FOREIGN KEY (leihvertrag_id) REFERENCES leihvertraege (id)
        ON DELETE CASCADE,
      CONSTRAINT fk_leihvertraege_positionen_exemplar
        FOREIGN KEY (artikel_exemplar_id) REFERENCES artikel_exemplare (id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  `);

  const connection = await getConnection();

  try {
    await connection.beginTransaction();

    for (const type of CONTRACT_TYPES) {
      const [rows] = await connection.execute(
        `
          SELECT COUNT(*) AS anzahl
          FROM vertrags_vorlagen
          WHERE typ = ?
        `,
        [type]
      );

      if (Number(rows[0]?.anzahl || 0) === 0) {
        await createTemplateVersionWithConnection(connection, {
          typ: type,
          name: `Leihvertrag ${type.toUpperCase()}`,
          sections: PLACEHOLDER_SECTION_LIBRARY[type],
          aktiv: true
        });
      }
    }

    await connection.commit();
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}

function mapTemplateRows(rows) {
  const templates = new Map();

  for (const row of rows) {
    if (!templates.has(row.v_vorlage_id)) {
      templates.set(row.v_vorlage_id, {
        v_vorlage_id: row.v_vorlage_id,
        name: row.name,
        typ: row.typ,
        version: row.version,
        briefkopf_pfad: row.briefkopf_png || null,
        briefkopf_preview_url: row.briefkopf_png ? `/api/vertragsvorlagen-assets/${row.briefkopf_png}` : null,
        seitenrand_oben_mm: Number(row.seitenrand_oben_mm ?? DEFAULT_PAGE_MARGINS_MM.top),
        seitenrand_rechts_mm: Number(row.seitenrand_rechts_mm ?? DEFAULT_PAGE_MARGINS_MM.right),
        seitenrand_unten_mm: Number(row.seitenrand_unten_mm ?? DEFAULT_PAGE_MARGINS_MM.bottom),
        seitenrand_links_mm: Number(row.seitenrand_links_mm ?? DEFAULT_PAGE_MARGINS_MM.left),
        aktiv: Boolean(row.aktiv),
        sections: []
      });
    }

    if (row.v_abschnitt_id) {
      templates.get(row.v_vorlage_id).sections.push({
        v_abschnitt_id: row.v_abschnitt_id,
        titel: row.abschnitt_titel,
        abschnitt_art: row.abschnitt_art,
        sortier_nr: row.sortier_nr,
        html_inhalt: row.html_inhalt
      });
    }
  }

  return [...templates.values()].sort((left, right) => {
    if (left.typ !== right.typ) {
      return left.typ.localeCompare(right.typ, "de");
    }
    return right.version - left.version;
  });
}

export async function listAllContractTemplates() {
  const rows = await query(`
    SELECT
      vv.v_vorlage_id,
      vv.name,
      vv.typ,
      vv.version,
      vv.briefkopf_png,
      vv.seitenrand_oben_mm,
      vv.seitenrand_rechts_mm,
      vv.seitenrand_unten_mm,
      vv.seitenrand_links_mm,
      vv.aktiv,
      va.v_abschnitt_id,
      va.titel AS abschnitt_titel,
      va.abschnitt_art,
      va.sortier_nr,
      va.html_inhalt
    FROM vertrags_vorlagen vv
    LEFT JOIN vertrags_abschnitte va
      ON va.v_vorlage_id = vv.v_vorlage_id
    ORDER BY vv.typ, vv.version DESC, va.sortier_nr ASC
  `);

  return mapTemplateRows(rows);
}

export async function listActiveContractTemplates() {
  const rows = await query(`
    SELECT
      vv.v_vorlage_id,
      vv.name,
      vv.typ,
      vv.version,
      vv.briefkopf_png,
      vv.seitenrand_oben_mm,
      vv.seitenrand_rechts_mm,
      vv.seitenrand_unten_mm,
      vv.seitenrand_links_mm,
      vv.aktiv,
      va.v_abschnitt_id,
      va.titel AS abschnitt_titel,
      va.abschnitt_art,
      va.sortier_nr,
      va.html_inhalt
    FROM vertrags_vorlagen vv
    LEFT JOIN vertrags_abschnitte va
      ON va.v_vorlage_id = vv.v_vorlage_id
    WHERE vv.aktiv = 1
    ORDER BY vv.typ, va.sortier_nr ASC
  `);

  return mapTemplateRows(rows);
}

export async function createContractTemplateVersion({
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
}) {
  const connection = await getConnection();

  try {
    await connection.beginTransaction();
      const templateId = await createTemplateVersionWithConnection(connection, {
        typ,
        name,
        sections,
        layout: {
          briefkopf_png,
          briefkopf_pfad,
          briefkopf_upload,
          seitenrand_oben_mm,
          seitenrand_rechts_mm,
          seitenrand_unten_mm,
          seitenrand_links_mm
        },
        aktiv: true
      });
    await connection.commit();

    const allTemplates = await listAllContractTemplates();
    return allTemplates.find((template) => template.v_vorlage_id === templateId) || null;
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}

export async function updateContractTemplate({
  templateId,
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
}) {
  const normalizedTemplateId = Number(templateId);

  if (!Number.isInteger(normalizedTemplateId) || normalizedTemplateId <= 0) {
    throw new Error("Ungueltige Vorlagen-ID.");
  }

  const normalizedType = assertContractType(typ);
  const normalizedSections = normalizeTemplateSections(sections);
  const normalizedName = String(name || "").trim() || `Leihvertrag ${normalizedType}`;
  const normalizedLayout = normalizeTemplateLayout({
    briefkopf_png,
    briefkopf_pfad,
    briefkopf_upload,
    seitenrand_oben_mm,
    seitenrand_rechts_mm,
    seitenrand_unten_mm,
    seitenrand_links_mm
  });
  const connection = await getConnection();

  try {
    await connection.beginTransaction();

    const [templateRows] = await connection.execute(
      `
        SELECT v_vorlage_id, briefkopf_png
        FROM vertrags_vorlagen
        WHERE v_vorlage_id = ?
          AND typ = ?
        LIMIT 1
      `,
      [normalizedTemplateId, normalizedType]
    );

    if (!templateRows.length) {
      throw new Error("Die ausgewaehlte Vertragsvorlage wurde nicht gefunden.");
    }

    const storedLetterheadPath = normalizedLayout.briefkopf_upload
      ? await storeLetterheadAsset({ pngDataUrl: normalizedLayout.briefkopf_upload, typ: normalizedType })
      : normalizedLayout.briefkopf_pfad;

    await connection.execute(
      `
        UPDATE vertrags_vorlagen
        SET name = ?,
            briefkopf_png = ?,
            seitenrand_oben_mm = ?,
            seitenrand_rechts_mm = ?,
            seitenrand_unten_mm = ?,
            seitenrand_links_mm = ?
        WHERE v_vorlage_id = ?
      `,
      [
        normalizedName,
        storedLetterheadPath,
        normalizedLayout.seitenrand_oben_mm,
        normalizedLayout.seitenrand_rechts_mm,
        normalizedLayout.seitenrand_unten_mm,
        normalizedLayout.seitenrand_links_mm,
        normalizedTemplateId
      ]
    );

    await connection.execute(
      `
        DELETE FROM vertrags_abschnitte
        WHERE v_vorlage_id = ?
      `,
      [normalizedTemplateId]
    );

    for (const section of normalizedSections.sort((left, right) => left.sortier_nr - right.sortier_nr)) {
      await connection.execute(
        `
          INSERT INTO vertrags_abschnitte (
            v_vorlage_id,
            titel,
            abschnitt_art,
            sortier_nr,
            html_inhalt
          )
          VALUES (?, ?, ?, ?, ?)
        `,
        [
          normalizedTemplateId,
          section.titel,
          section.abschnitt_art,
          section.sortier_nr,
          section.html_inhalt
        ]
      );
    }

    await connection.commit();

    const allTemplates = await listAllContractTemplates();
    return allTemplates.find((template) => template.v_vorlage_id === normalizedTemplateId) || null;
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}

async function getActiveTemplateByType(typ) {
  const normalizedType = assertContractType(typ);
  const rows = await query(
    `
      SELECT
        vv.v_vorlage_id,
        vv.name,
        vv.typ,
        vv.version,
        vv.briefkopf_png,
        vv.seitenrand_oben_mm,
        vv.seitenrand_rechts_mm,
        vv.seitenrand_unten_mm,
        vv.seitenrand_links_mm,
        vv.aktiv,
        va.v_abschnitt_id,
        va.titel AS abschnitt_titel,
        va.abschnitt_art,
        va.sortier_nr,
        va.html_inhalt
      FROM vertrags_vorlagen vv
      LEFT JOIN vertrags_abschnitte va
        ON va.v_vorlage_id = vv.v_vorlage_id
      WHERE vv.typ = ?
        AND vv.aktiv = 1
      ORDER BY va.sortier_nr ASC
    `,
    [normalizedType]
  );

  const templates = mapTemplateRows(rows);
  return templates[0] || null;
}

export async function getBorrowerContractContext(ausleiherId) {
  const numericId = Number(ausleiherId);
  if (!numericId) {
    throw new Error("Gueltige Ausleiher-ID erforderlich.");
  }

  const borrowerRows = await query(
    `
      SELECT
        a.id,
        a.name,
        a.ausleiher_typ,
        a.quelle_typ,
        a.quelle_id,
        a.klasse_oder_bereich,
        s.vorname AS schueler_vorname,
        s.nachname AS schueler_nachname,
        s.geburtsdatum,
        k.bezeichnung AS klasse,
        l.anrede AS lehrer_anrede,
        l.vorname AS lehrer_vorname,
        l.nachname AS lehrer_nachname
      FROM ausleiher a
      LEFT JOIN schueler s
        ON a.quelle_typ = 'schueler'
       AND s.id = a.quelle_id
      LEFT JOIN schueler_klassen sk
        ON sk.schueler_id = s.id
       AND sk.ist_aktuell = 1
      LEFT JOIN klassen k
        ON k.id = sk.klassen_id
      LEFT JOIN lehrkraefte l
        ON a.quelle_typ = 'lehrkraft'
       AND l.id = a.quelle_id
      WHERE a.id = ?
      LIMIT 1
    `,
    [numericId]
  );

  if (borrowerRows.length === 0) {
    throw new Error("Ausleiher wurde nicht gefunden.");
  }

  const borrower = borrowerRows[0];
  const deviceRows = await query(
    `
      SELECT
        ae.id AS artikel_exemplar_id,
        ae.artikel_id,
        ae.inventarnummer,
        ae.barcode,
        ae.seriennummer,
        art.titel,
        art.hersteller,
        art.modellbezeichnung,
        it.bezeichnung AS inventar_typ
      FROM ausleihen al
      JOIN artikel_exemplare ae
        ON ae.id = al.exemplar_id
      JOIN artikel art
        ON art.id = ae.artikel_id
      LEFT JOIN inventar_typen it
        ON it.id = art.inventar_typ_id
      WHERE al.ausleiher_id = ?
        AND al.status = 'offen'
        AND COALESCE(it.bezeichnung, '') <> 'buch'
      ORDER BY art.titel, ae.inventarnummer
    `,
    [numericId]
  );

  return {
    ausleiher: {
      id: borrower.id,
      name: borrower.name,
      ausleiher_typ: borrower.ausleiher_typ,
      quelle_typ: borrower.quelle_typ,
      quelle_id: borrower.quelle_id,
      klasse_oder_bereich: borrower.klasse_oder_bereich,
      vorname:
        borrower.quelle_typ === "schueler"
          ? borrower.schueler_vorname
          : borrower.lehrer_vorname,
      nachname:
        borrower.quelle_typ === "schueler"
          ? borrower.schueler_nachname
          : borrower.lehrer_nachname,
      anrede: borrower.lehrer_anrede || "",
      klasse: borrower.klasse || borrower.klasse_oder_bereich || "",
      geburtsdatum: borrower.geburtsdatum || null
    },
    geraete: deviceRows.map((device) => ({
      artikel_exemplar_id: device.artikel_exemplar_id,
      artikel_id: device.artikel_id,
      inventarnummer: device.inventarnummer,
      barcode: device.barcode,
      seriennummer: device.seriennummer,
      titel: device.titel,
      hersteller: device.hersteller,
      modellbezeichnung: device.modellbezeichnung,
      inventar_typ: device.inventar_typ,
      geraetename: [device.titel, device.hersteller, device.modellbezeichnung].filter(Boolean).join(" · ")
    }))
  };
}

async function buildContractDisplayData(contractId, generatedAt, borrower, devices, template, contractType) {
  const personDisplayName =
    borrower.ausleiher_typ === "lehrkraft"
      ? [borrower.anrede, borrower.vorname, borrower.nachname].filter(Boolean).join(" ")
      : [borrower.vorname, borrower.nachname].filter(Boolean).join(" ");
  const briefkopfPng = await readLetterheadAssetAsDataUrl(template.briefkopf_pfad);

  return {
    css: "",
    partner: SCHOOL_CONTRACT_PARTNER,
    vertrag: {
      id: contractId,
      nummer: `LV-${String(contractId).padStart(6, "0")}`,
      typ: contractType,
      title: template.name,
      version: template.version,
      generatedAt
    },
    layout: {
      briefkopf_png: briefkopfPng,
      briefkopf_pfad: template.briefkopf_pfad || null,
      seitenrand_oben_mm: Number(template.seitenrand_oben_mm ?? DEFAULT_PAGE_MARGINS_MM.top),
      seitenrand_rechts_mm: Number(template.seitenrand_rechts_mm ?? DEFAULT_PAGE_MARGINS_MM.right),
      seitenrand_unten_mm: Number(template.seitenrand_unten_mm ?? DEFAULT_PAGE_MARGINS_MM.bottom),
      seitenrand_links_mm: Number(template.seitenrand_links_mm ?? DEFAULT_PAGE_MARGINS_MM.left)
    },
    ausleiher: {
      ...borrower,
      personLabel: borrower.ausleiher_typ === "lehrkraft" ? "Lehrkraft" : "Schuelerin / Schueler",
      displayName: personDisplayName || borrower.name
    },
    geraete: devices.map((device, index) => ({
      ...device,
      index: index + 1,
      bezeichnung: [device.titel, device.hersteller, device.modellbezeichnung].filter(Boolean).join(" · ")
    })),
    rechtstexte: template.sections
  };
}

async function writeContractPdf({ html, outputPath, footerContext, layout }) {
  await fs.mkdir(path.dirname(outputPath), { recursive: true });

  const browser = await puppeteer.launch({
    headless: true,
    args: ["--no-sandbox", "--disable-setuid-sandbox"]
  });

  try {
    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: "networkidle0" });
    await page.pdf({
      path: outputPath,
      format: "A4",
      printBackground: true,
      displayHeaderFooter: true,
      headerTemplate: "<div></div>",
      footerTemplate: buildPdfFooterTemplate(footerContext),
      margin: {
        top: formatMarginMm(layout.seitenrand_oben_mm),
        right: formatMarginMm(layout.seitenrand_rechts_mm),
        bottom: formatMarginMm(layout.seitenrand_unten_mm),
        left: formatMarginMm(layout.seitenrand_links_mm)
      }
    });
  } finally {
    await browser.close();
  }
}

export async function createLoanContract({ ausleiherId, vertragstyp, artikelExemplarIds }) {
  const normalizedType = assertContractType(vertragstyp);
  const uniqueDeviceIds = Array.isArray(artikelExemplarIds)
    ? [...new Set(artikelExemplarIds.map((value) => Number(value)).filter(Boolean))]
    : [];

  if (uniqueDeviceIds.length === 0) {
    throw new Error("Mindestens ein Leihgeraet muss ausgewaehlt werden.");
  }

  const template = await getActiveTemplateByType(normalizedType);
  if (!template) {
    throw new Error("Fuer diesen Vertragstyp ist keine aktive Vorlage hinterlegt.");
  }

  const contractContext = await getBorrowerContractContext(ausleiherId);
  const validDeviceIds = new Set(contractContext.geraete.map((device) => Number(device.artikel_exemplar_id)));
  const selectedDevices = uniqueDeviceIds.map((deviceId) =>
    contractContext.geraete.find((device) => Number(device.artikel_exemplar_id) === Number(deviceId))
  );

  if (selectedDevices.some((device) => !device) || uniqueDeviceIds.some((id) => !validDeviceIds.has(id))) {
    throw new Error("Es koennen nur offene, bereits zugeordnete Geraete in den Vertrag aufgenommen werden.");
  }

  const connection = await getConnection();

  try {
    await connection.beginTransaction();

    const [insertResult] = await connection.execute(
      `
        INSERT INTO leihvertraege (
          ausleiher_id,
          ausleiher_typ,
          vertragstyp,
          pdf_pfad,
          vorlagen_version,
          v_vorlage_id
        )
        VALUES (?, ?, ?, ?, ?, ?)
      `,
      [
        Number(ausleiherId),
        contractContext.ausleiher.ausleiher_typ,
        normalizedType,
        "",
        template.version,
        template.v_vorlage_id
      ]
    );

    const contractId = Number(insertResult.insertId);

    for (const deviceId of uniqueDeviceIds) {
      await connection.execute(
        `
          INSERT INTO leihvertraege_positionen (
            leihvertrag_id,
            artikel_exemplar_id
          )
          VALUES (?, ?)
        `,
        [contractId, deviceId]
      );
    }

    const generatedAt = new Date();
    const year = String(generatedAt.getFullYear());
    const month = String(generatedAt.getMonth() + 1).padStart(2, "0");
    const day = String(generatedAt.getDate()).padStart(2, "0");
    const hour = String(generatedAt.getHours()).padStart(2, "0");
    const minute = String(generatedAt.getMinutes()).padStart(2, "0");
    const second = String(generatedAt.getSeconds()).padStart(2, "0");
    const zeitstempel = `${year}${month}${day}_${hour}${minute}${second}`;
    const klasse = sanitizeFilenameSegment(contractContext.ausleiher.klasse || contractContext.ausleiher.klasse_oder_bereich, "OhneKlasse");
    const name = sanitizeFilenameSegment(contractContext.ausleiher.nachname, "OhneName");
    const vorname = sanitizeFilenameSegment(contractContext.ausleiher.vorname, "OhneVorname");
    const vertragstypSegment = sanitizeFilenameSegment(
      normalizedType === "tablet" ? "Tablet" : normalizedType.charAt(0).toUpperCase() + normalizedType.slice(1),
      "Vertrag"
    );
    const filename = `${zeitstempel}_${klasse}_${name}_${vorname}_${vertragstypSegment}.pdf`;
    const relativePdfPath = path.posix.join("backend", "storage", "leihvertraege", year, filename);
    const absolutePdfPath = path.join(contractStorageDir, year, filename);

    const renderer = await loadContractRenderer();
    const displayData = await buildContractDisplayData(
      contractId,
      generatedAt,
      contractContext.ausleiher,
      selectedDevices,
      template,
      normalizedType
    );
    const html = renderer.render({
      ...displayData,
      css: buildContractCss(renderer.css, displayData.layout)
    });

    await writeContractPdf({
      html,
      outputPath: absolutePdfPath,
      footerContext: {
        ort: SCHOOL_CONTRACT_PARTNER.ort,
        generatedAt,
        schulname: SCHOOL_CONTRACT_PARTNER.schulname,
        seitenrand_links_mm: displayData.layout.seitenrand_links_mm,
        seitenrand_rechts_mm: displayData.layout.seitenrand_rechts_mm
      },
      layout: displayData.layout
    });

    await connection.execute(
      `
        UPDATE leihvertraege
        SET
          pdf_pfad = ?,
          erzeugungsdatum = ?
        WHERE id = ?
      `,
      [relativePdfPath, generatedAt, contractId]
    );

    await connection.commit();

    return {
      id: contractId,
      ausleiher_id: Number(ausleiherId),
      ausleiher_typ: contractContext.ausleiher.ausleiher_typ,
      vertragstyp: normalizedType,
      pdf_pfad: relativePdfPath,
      vorlagen_version: template.version,
      v_vorlage_id: template.v_vorlage_id
    };
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}

export async function getStoredLoanContract(contractId) {
  const numericId = Number(contractId);
  if (!numericId) {
    throw new Error("Gueltige Vertrags-ID erforderlich.");
  }

  const rows = await query(
    `
      SELECT
        lv.id,
        lv.pdf_pfad,
        lv.ausleiher_id,
        lv.ausleiher_typ,
        lv.erzeugungsdatum,
        lv.vertragstyp,
        lv.vorlagen_version,
        lv.v_vorlage_id
      FROM leihvertraege lv
      WHERE lv.id = ?
      LIMIT 1
    `,
    [numericId]
  );

  if (rows.length === 0) {
    throw new Error("Leihvertrag wurde nicht gefunden.");
  }

  return rows[0];
}

export function resolveStoredContractPath(relativePath) {
  if (!relativePath) {
    throw new Error("Zum Vertrag ist kein PDF-Pfad hinterlegt.");
  }

  const normalizedRelative = String(relativePath).replace(/^backend[\\/]/i, "");
  return path.resolve(backendDir, normalizedRelative);
}

export function getContractTemplateAssetDirectory() {
  return contractTemplateAssetDir;
}
