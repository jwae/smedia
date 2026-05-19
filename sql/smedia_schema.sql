CREATE DATABASE IF NOT EXISTS smedia
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE smedia;

CREATE TABLE ausleiharten (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    bezeichnung VARCHAR(50) NOT NULL,
    beschreibung VARCHAR(255) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_ausleiharten_bezeichnung (bezeichnung)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE inventar_typen (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    bezeichnung VARCHAR(50) NOT NULL,
    beschreibung VARCHAR(255) NULL,
    ausleihart_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_inventar_typen_bezeichnung (bezeichnung),
    KEY idx_inventar_typen_ausleihart (ausleihart_id),
    CONSTRAINT fk_inventar_typen_ausleihart
        FOREIGN KEY (ausleihart_id) REFERENCES ausleiharten (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE statuskatalog (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    bezeichnung VARCHAR(50) NOT NULL,
    beschreibung VARCHAR(255) NULL,
    ist_ausleihbar TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uq_statuskatalog_bezeichnung (bezeichnung)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE zustandskatalog (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    bezeichnung VARCHAR(50) NOT NULL,
    beschreibung VARCHAR(255) NULL,
    sortierung INT NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uq_zustandskatalog_bezeichnung (bezeichnung)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE standorte (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    bezeichnung VARCHAR(100) NOT NULL,
    standort_typ VARCHAR(50) NULL,
    parent_id INT UNSIGNED NULL,
    beschreibung VARCHAR(255) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_standorte_bezeichnung (bezeichnung),
    KEY idx_standorte_parent (parent_id),
    CONSTRAINT fk_standorte_parent
        FOREIGN KEY (parent_id) REFERENCES standorte (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS herkunft (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    bezeichnung VARCHAR(150) NOT NULL,
    notiz TEXT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_herkunft_bezeichnung (bezeichnung)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS artikel_kategorie (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    kategorie VARCHAR(150) NOT NULL,
    bemerkung TEXT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_artikel_kategorie_kategorie (kategorie)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE artikel (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    inventar_typ_id INT UNSIGNED NOT NULL,
    titel VARCHAR(255) NOT NULL,
    interne_bezeichnung VARCHAR(255) NULL,
    beschreibung TEXT NULL,
    hersteller VARCHAR(150) NULL,
    modellbezeichnung VARCHAR(150) NULL,
    herkunft_id INT UNSIGNED NULL,
    artikel_kategorie_id INT UNSIGNED NULL,
    aktiv TINYINT(1) NOT NULL DEFAULT 1,
    erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_artikel_inventar_typ (inventar_typ_id),
    KEY idx_artikel_titel (titel),
    KEY idx_artikel_herkunft (herkunft_id),
    KEY idx_artikel_kategorie (artikel_kategorie_id),
    CONSTRAINT fk_artikel_inventar_typ
        FOREIGN KEY (inventar_typ_id) REFERENCES inventar_typen (id),
    CONSTRAINT fk_artikel_kategorie
        FOREIGN KEY (artikel_kategorie_id) REFERENCES artikel_kategorie (id),
    CONSTRAINT fk_artikel_herkunft
        FOREIGN KEY (herkunft_id) REFERENCES herkunft (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE artikel_exemplare (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    artikel_id INT UNSIGNED NOT NULL,
    inventarnummer VARCHAR(100) NOT NULL,
    barcode VARCHAR(150) NOT NULL,
    seriennummer VARCHAR(150) NULL,
    status_id INT UNSIGNED NOT NULL,
    zustand_id INT UNSIGNED NOT NULL,
    standort_id INT UNSIGNED NULL,
    anschaffungsdatum DATE NULL,
    kaufpreis DECIMAL(10,2) NULL,
    garantie_bis DATE NULL,
    ist_klassensatz TINYINT(1) NOT NULL DEFAULT 0,
    klassensatz_name VARCHAR(150) NULL,
    notizen TEXT NULL,
    aktiv TINYINT(1) NOT NULL DEFAULT 1,
    erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_artikel_exemplare_inventarnummer (inventarnummer),
    UNIQUE KEY uq_artikel_exemplare_barcode (barcode),
    UNIQUE KEY uq_artikel_exemplare_seriennummer (seriennummer),
    KEY idx_artikel_exemplare_artikel (artikel_id),
    KEY idx_artikel_exemplare_status (status_id),
    KEY idx_artikel_exemplare_zustand (zustand_id),
    KEY idx_artikel_exemplare_standort (standort_id),
    KEY idx_artikel_exemplare_klassensatz (ist_klassensatz, klassensatz_name),
    CONSTRAINT fk_artikel_exemplare_artikel
        FOREIGN KEY (artikel_id) REFERENCES artikel (id),
    CONSTRAINT fk_artikel_exemplare_status
        FOREIGN KEY (status_id) REFERENCES statuskatalog (id),
    CONSTRAINT fk_artikel_exemplare_zustand
        FOREIGN KEY (zustand_id) REFERENCES zustandskatalog (id),
    CONSTRAINT fk_artikel_exemplare_standort
        FOREIGN KEY (standort_id) REFERENCES standorte (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS faecher (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    bezeichnung VARCHAR(100) NOT NULL,
    kuerzel VARCHAR(10) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_faecher_bezeichnung (bezeichnung)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE buch_details (
    artikel_id INT UNSIGNED NOT NULL,
    titelcode VARCHAR(20) NULL,
    autor VARCHAR(255) NULL,
    verlag VARCHAR(255) NULL,
    fach_id INT UNSIGNED NULL,
    veroeffentlicht VARCHAR(50) NULL,
    cover_url VARCHAR(500) NULL,
    cover_bild LONGTEXT NULL,
    jahrgangsstufe VARCHAR(50) NULL,
    schuljahr_ausgabe VARCHAR(20) NULL,
    ist_arbeitsheft TINYINT(1) NOT NULL DEFAULT 0,
    ist_lehrerversion TINYINT(1) NOT NULL DEFAULT 0,
    herkunft_id INT UNSIGNED NULL,
    PRIMARY KEY (artikel_id),
    UNIQUE KEY uq_buch_details_titelcode (titelcode),
    KEY idx_buch_details_fach (fach_id),
    KEY idx_buch_details_veroeffentlicht (veroeffentlicht),
    KEY idx_buch_details_jahrgangsstufe (jahrgangsstufe),
    KEY idx_buch_details_herkunft (herkunft_id),
    CONSTRAINT fk_buch_details_artikel
        FOREIGN KEY (artikel_id) REFERENCES artikel (id),
    CONSTRAINT fk_buch_details_fach
        FOREIGN KEY (fach_id) REFERENCES faecher (id),
    CONSTRAINT fk_buch_details_herkunft
        FOREIGN KEY (herkunft_id) REFERENCES herkunft (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE geraete_details (
    artikel_id INT UNSIGNED NOT NULL,
    geraetekategorie VARCHAR(100) NOT NULL,
    modellnummer VARCHAR(100) NULL,
    speichergroesse VARCHAR(50) NULL,
    betriebssystem VARCHAR(100) NULL,
    PRIMARY KEY (artikel_id),
    KEY idx_geraete_details_geraetekategorie (geraetekategorie),
    CONSTRAINT fk_geraete_details_artikel
        FOREIGN KEY (artikel_id) REFERENCES artikel (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO artikel_kategorie (kategorie, bemerkung) VALUES
    ('Tablet', NULL),
    ('Tablet_Zubehoer', NULL),
    ('Laptop', NULL),
    ('Laptop_Zubehoer', NULL),
    ('Buch', NULL),
    ('Taschenrechner', NULL),
    ('Hotspot', NULL),
    ('Netzteil', NULL),
    ('Stift', NULL);

CREATE TABLE exemplar_zuordnungen (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    haupt_exemplar_id INT UNSIGNED NOT NULL,
    neben_exemplar_id INT UNSIGNED NOT NULL,
    beziehungsart VARCHAR(50) NOT NULL,
    beschreibung VARCHAR(255) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_exemplar_zuordnungen (haupt_exemplar_id, neben_exemplar_id, beziehungsart),
    KEY idx_exemplar_zuordnungen_neben (neben_exemplar_id),
    CONSTRAINT fk_exemplar_zuordnungen_haupt
        FOREIGN KEY (haupt_exemplar_id) REFERENCES artikel_exemplare (id),
    CONSTRAINT fk_exemplar_zuordnungen_neben
        FOREIGN KEY (neben_exemplar_id) REFERENCES artikel_exemplare (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO ausleiharten (bezeichnung, beschreibung) VALUES
    ('einzelexemplar', 'Ein einzelnes physisches Objekt wird ausgeliehen.'),
    ('klassensatz', 'Mehrere physische Exemplare koennen als Satz organisiert werden.');

INSERT INTO inventar_typen (bezeichnung, beschreibung, ausleihart_id)
SELECT 'buch', 'Ausleihbare Buecher und Buch-Exemplare.', a.id
FROM ausleiharten a
WHERE a.bezeichnung = 'klassensatz'
UNION ALL
SELECT 'tablet', 'Tablets wie iPads.', a.id
FROM ausleiharten a
WHERE a.bezeichnung = 'einzelexemplar'
UNION ALL
SELECT 'stift', 'Digitale Stifte wie Apple Pencil.', a.id
FROM ausleiharten a
WHERE a.bezeichnung = 'einzelexemplar'
UNION ALL
SELECT 'ladegeraet', 'Netzteile und Ladegeraete.', a.id
FROM ausleiharten a
WHERE a.bezeichnung = 'einzelexemplar'
UNION ALL
SELECT 'tastatur', 'Tastaturen fuer mobile Geraete.', a.id
FROM ausleiharten a
WHERE a.bezeichnung = 'einzelexemplar'
UNION ALL
SELECT 'beamer', 'Beamer und Projektionsgeraete.', a.id
FROM ausleiharten a
WHERE a.bezeichnung = 'einzelexemplar';

INSERT INTO statuskatalog (bezeichnung, beschreibung, ist_ausleihbar) VALUES
    ('verfuegbar', 'Kann regulär ausgeliehen werden.', 1),
    ('reserviert', 'Ist vorgemerkt und momentan nicht frei verfuegbar.', 0),
    ('ausgeliehen', 'Ist aktuell ausgegeben.', 0),
    ('defekt', 'Ist defekt und nicht ausleihbar.', 0),
    ('in_reparatur', 'Befindet sich in Reparatur.', 0),
    ('verloren', 'Ist nicht auffindbar.', 0),
    ('ausgesondert', 'Wurde aus dem Bestand genommen.', 0);

INSERT INTO zustandskatalog (bezeichnung, beschreibung, sortierung) VALUES
    ('neu', 'Neuwertiger Zustand.', 10),
    ('sehr_gut', 'Kaum Gebrauchsspuren.', 20),
    ('gut', 'Normale Gebrauchsspuren.', 30),
    ('gebraucht', 'Deutliche Gebrauchsspuren, aber funktionstuechtig.', 40),
    ('beschaedigt', 'Physisch beschaedigt.', 50),
    ('unvollstaendig', 'Zubehoer oder Teile fehlen.', 60);
