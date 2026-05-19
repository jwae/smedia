-- init.sql fuer MariaDB / smedia
-- Erstellt aus der bereitgestellten DBeaver-DDL-Vorlage.
-- Tabellen werden angelegt; nur Stammdaten/Kataloge werden vorbelegt.

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS smedia /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE smedia;
-- smedia.app_einstellungen definition

CREATE TABLE `app_einstellungen` (
  `bereich` varchar(50) NOT NULL,
  `daten_json` longtext NOT NULL,
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`bereich`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.artikel_kategorie definition

CREATE TABLE `artikel_kategorie` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `kategorie` varchar(150) NOT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `bemerkung` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_artikel_kategorie_kategorie` (`kategorie`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.ausleiharten definition

CREATE TABLE `ausleiharten` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(50) NOT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `beschreibung` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ausleiharten_bezeichnung` (`bezeichnung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.ausleiher definition

CREATE TABLE `ausleiher` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `ausleiher_typ` varchar(50) NOT NULL,
  `quelle_typ` varchar(30) DEFAULT NULL,
  `quelle_id` int(10) unsigned DEFAULT NULL,
  `klasse_oder_bereich` varchar(100) DEFAULT NULL,
  `barcode` varchar(150) DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ausleiher_barcode` (`barcode`),
  UNIQUE KEY `uq_ausleiher_quelle` (`quelle_typ`,`quelle_id`),
  KEY `idx_ausleiher_typ` (`ausleiher_typ`),
  KEY `idx_ausleiher_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.faecher definition

CREATE TABLE `faecher` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(100) NOT NULL,
  `kuerzel` varchar(10) DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_faecher_bezeichnung` (`bezeichnung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.herkunft definition

CREATE TABLE `herkunft` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(150) NOT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `notiz` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_herkunft_bezeichnung` (`bezeichnung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.klassen definition

CREATE TABLE `klassen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(10) NOT NULL,
  `stufe` varchar(10) NOT NULL,
  `parallelklasse` char(1) DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_klassen_bezeichnung` (`bezeichnung`),
  KEY `idx_klassen_stufe` (`stufe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.lehrkraefte definition

CREATE TABLE `lehrkraefte` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `kuerzel` varchar(20) DEFAULT NULL,
  `anrede` varchar(30) DEFAULT NULL,
  `vorname` varchar(100) NOT NULL,
  `nachname` varchar(100) NOT NULL,
  `anzeigename` varchar(220) NOT NULL,
  `barcode` varchar(150) DEFAULT NULL,
  `email` varchar(190) DEFAULT NULL,
  `fachbereich` varchar(120) DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `notizen` text DEFAULT NULL,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_lehrkraefte_kuerzel` (`kuerzel`),
  UNIQUE KEY `uq_lehrkraefte_barcode` (`barcode`),
  KEY `idx_lehrkraefte_name` (`nachname`,`vorname`),
  KEY `idx_lehrkraefte_anzeigename` (`anzeigename`),
  KEY `idx_lehrkraefte_fachbereich` (`fachbereich`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.schueler definition

CREATE TABLE `schueler` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `S_ID` int(11) DEFAULT NULL,
  `vorname` varchar(100) NOT NULL,
  `nachname` varchar(100) NOT NULL,
  `anzeigename` varchar(220) NOT NULL,
  `barcode` varchar(150) DEFAULT NULL,
  `email` varchar(190) DEFAULT NULL,
  `geburtsdatum` date DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `notizen` text DEFAULT NULL,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_schueler_barcode` (`barcode`),
  UNIQUE KEY `uq_schueler_email` (`email`),
  KEY `idx_schueler_name` (`nachname`,`vorname`),
  KEY `idx_schueler_anzeigename` (`anzeigename`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.statuskatalog definition

CREATE TABLE `statuskatalog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(50) NOT NULL,
  `beschreibung` varchar(255) DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `ist_ausleihbar` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_statuskatalog_bezeichnung` (`bezeichnung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.vertrags_vorlagen definition

CREATE TABLE `vertrags_vorlagen` (
  `v_vorlage_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(190) NOT NULL,
  `typ` varchar(50) NOT NULL,
  `version` int(11) NOT NULL,
  `briefkopf_png` longtext DEFAULT NULL,
  `seitenrand_oben_mm` decimal(5,2) NOT NULL DEFAULT 14.00,
  `seitenrand_rechts_mm` decimal(5,2) NOT NULL DEFAULT 12.00,
  `seitenrand_unten_mm` decimal(5,2) NOT NULL DEFAULT 18.00,
  `seitenrand_links_mm` decimal(5,2) NOT NULL DEFAULT 12.00,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`v_vorlage_id`),
  UNIQUE KEY `uq_vertrags_vorlagen_typ_version` (`typ`,`version`),
  KEY `idx_vertrags_vorlagen_typ_aktiv` (`typ`,`aktiv`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.zustandskatalog definition

CREATE TABLE `zustandskatalog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(50) NOT NULL,
  `beschreibung` varchar(255) DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `sortierung` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_zustandskatalog_bezeichnung` (`bezeichnung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.inventar_typen definition

CREATE TABLE `inventar_typen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(50) NOT NULL,
  `beschreibung` varchar(255) DEFAULT NULL,
  `ausleihart_id` int(10) unsigned NOT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_inventar_typen_bezeichnung` (`bezeichnung`),
  KEY `idx_inventar_typen_ausleihart` (`ausleihart_id`),
  CONSTRAINT `fk_inventar_typen_ausleihart` FOREIGN KEY (`ausleihart_id`) REFERENCES `ausleiharten` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.leihvertraege definition

CREATE TABLE `leihvertraege` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ausleiher_id` int(10) unsigned NOT NULL,
  `ausleiher_typ` varchar(50) NOT NULL,
  `erzeugungsdatum` datetime NOT NULL DEFAULT current_timestamp(),
  `vertragstyp` varchar(50) NOT NULL,
  `pdf_pfad` varchar(500) NOT NULL,
  `vorlagen_version` int(11) NOT NULL,
  `v_vorlage_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_leihvertraege_ausleiher` (`ausleiher_id`,`erzeugungsdatum`),
  KEY `idx_leihvertraege_typ` (`vertragstyp`),
  KEY `idx_leihvertraege_vorlage` (`v_vorlage_id`),
  CONSTRAINT `fk_leihvertraege_ausleiher` FOREIGN KEY (`ausleiher_id`) REFERENCES `ausleiher` (`id`),
  CONSTRAINT `fk_leihvertraege_vorlage` FOREIGN KEY (`v_vorlage_id`) REFERENCES `vertrags_vorlagen` (`v_vorlage_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.schueler_klassen definition

CREATE TABLE `schueler_klassen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `schueler_id` int(10) unsigned NOT NULL,
  `klassen_id` int(10) unsigned NOT NULL,
  `schuljahr` varchar(20) NOT NULL,
  `von_datum` date DEFAULT NULL,
  `bis_datum` date DEFAULT NULL,
  `ist_aktuell` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_schueler_klassen_schueler` (`schueler_id`),
  KEY `idx_schueler_klassen_klasse` (`klassen_id`),
  KEY `idx_schueler_klassen_schuljahr` (`schuljahr`),
  KEY `idx_schueler_klassen_aktuell` (`ist_aktuell`),
  CONSTRAINT `fk_schueler_klassen_klasse` FOREIGN KEY (`klassen_id`) REFERENCES `klassen` (`id`),
  CONSTRAINT `fk_schueler_klassen_schueler` FOREIGN KEY (`schueler_id`) REFERENCES `schueler` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.standorte definition

CREATE TABLE `standorte` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(100) NOT NULL,
  `standort_typ` varchar(50) DEFAULT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `beschreibung` varchar(255) DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_standorte_bezeichnung` (`bezeichnung`),
  KEY `idx_standorte_parent` (`parent_id`),
  CONSTRAINT `fk_standorte_parent` FOREIGN KEY (`parent_id`) REFERENCES `standorte` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.vertrags_abschnitte definition

CREATE TABLE `vertrags_abschnitte` (
  `v_abschnitt_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `v_vorlage_id` int(10) unsigned NOT NULL,
  `titel` varchar(190) NOT NULL,
  `abschnitt_art` varchar(50) NOT NULL DEFAULT 'rechtstext',
  `sortier_nr` int(11) NOT NULL DEFAULT 1,
  `html_inhalt` longtext NOT NULL,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`v_abschnitt_id`),
  KEY `idx_vertrags_abschnitte_vorlage` (`v_vorlage_id`,`sortier_nr`),
  CONSTRAINT `fk_vertrags_abschnitte_vorlage` FOREIGN KEY (`v_vorlage_id`) REFERENCES `vertrags_vorlagen` (`v_vorlage_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.artikel definition

CREATE TABLE `artikel` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inventar_typ_id` int(10) unsigned NOT NULL,
  `titel` varchar(255) NOT NULL,
  `interne_bezeichnung` varchar(255) DEFAULT NULL,
  `beschreibung` text DEFAULT NULL,
  `hersteller` varchar(150) DEFAULT NULL,
  `modellbezeichnung` varchar(150) DEFAULT NULL,
  `herkunft_id` int(10) unsigned DEFAULT NULL,
  `artikel_kategorie_id` int(10) unsigned DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_artikel_inventar_typ` (`inventar_typ_id`),
  KEY `idx_artikel_titel` (`titel`),
  KEY `idx_artikel_herkunft` (`herkunft_id`),
  KEY `idx_artikel_kategorie` (`artikel_kategorie_id`),
  CONSTRAINT `fk_artikel_herkunft` FOREIGN KEY (`herkunft_id`) REFERENCES `herkunft` (`id`),
  CONSTRAINT `fk_artikel_inventar_typ` FOREIGN KEY (`inventar_typ_id`) REFERENCES `inventar_typen` (`id`),
  CONSTRAINT `fk_artikel_kategorie` FOREIGN KEY (`artikel_kategorie_id`) REFERENCES `artikel_kategorie` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.artikel_exemplare definition

CREATE TABLE `artikel_exemplare` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `artikel_id` int(10) unsigned NOT NULL,
  `inventarnummer` varchar(100) NOT NULL,
  `barcode` varchar(150) NOT NULL,
  `seriennummer` varchar(150) DEFAULT NULL,
  `status_id` int(10) unsigned NOT NULL,
  `zustand_id` int(10) unsigned NOT NULL,
  `standort_id` int(10) unsigned DEFAULT NULL,
  `anschaffungsdatum` date DEFAULT NULL,
  `kaufpreis` decimal(10,2) DEFAULT NULL,
  `garantie_bis` date DEFAULT NULL,
  `ist_klassensatz` tinyint(1) NOT NULL DEFAULT 0,
  `klassensatz_name` varchar(150) DEFAULT NULL,
  `notizen` text DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_artikel_exemplare_inventarnummer` (`inventarnummer`),
  UNIQUE KEY `uq_artikel_exemplare_barcode` (`barcode`),
  UNIQUE KEY `uq_artikel_exemplare_seriennummer` (`seriennummer`),
  KEY `idx_artikel_exemplare_artikel` (`artikel_id`),
  KEY `idx_artikel_exemplare_status` (`status_id`),
  KEY `idx_artikel_exemplare_zustand` (`zustand_id`),
  KEY `idx_artikel_exemplare_standort` (`standort_id`),
  KEY `idx_artikel_exemplare_klassensatz` (`ist_klassensatz`,`klassensatz_name`),
  CONSTRAINT `fk_artikel_exemplare_artikel` FOREIGN KEY (`artikel_id`) REFERENCES `artikel` (`id`),
  CONSTRAINT `fk_artikel_exemplare_standort` FOREIGN KEY (`standort_id`) REFERENCES `standorte` (`id`),
  CONSTRAINT `fk_artikel_exemplare_status` FOREIGN KEY (`status_id`) REFERENCES `statuskatalog` (`id`),
  CONSTRAINT `fk_artikel_exemplare_zustand` FOREIGN KEY (`zustand_id`) REFERENCES `zustandskatalog` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.ausleihen definition

CREATE TABLE `ausleihen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `exemplar_id` int(10) unsigned NOT NULL,
  `ausleiher_id` int(10) unsigned NOT NULL,
  `ausgabe_am` datetime NOT NULL DEFAULT current_timestamp(),
  `faellig_am` datetime DEFAULT NULL,
  `rueckgabe_am` datetime DEFAULT NULL,
  `zustand_bei_ausgabe_id` int(10) unsigned NOT NULL,
  `zustand_bei_rueckgabe_id` int(10) unsigned DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'offen',
  `kommentar_ausgabe` text DEFAULT NULL,
  `kommentar_rueckgabe` text DEFAULT NULL,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_ausleihen_exemplar` (`exemplar_id`),
  KEY `idx_ausleihen_ausleiher` (`ausleiher_id`),
  KEY `idx_ausleihen_status` (`status`),
  KEY `idx_ausleihen_faelligkeit` (`faellig_am`),
  KEY `fk_ausleihen_zustand_ausgabe` (`zustand_bei_ausgabe_id`),
  KEY `fk_ausleihen_zustand_rueckgabe` (`zustand_bei_rueckgabe_id`),
  CONSTRAINT `fk_ausleihen_ausleiher` FOREIGN KEY (`ausleiher_id`) REFERENCES `ausleiher` (`id`),
  CONSTRAINT `fk_ausleihen_exemplar` FOREIGN KEY (`exemplar_id`) REFERENCES `artikel_exemplare` (`id`),
  CONSTRAINT `fk_ausleihen_zustand_ausgabe` FOREIGN KEY (`zustand_bei_ausgabe_id`) REFERENCES `zustandskatalog` (`id`),
  CONSTRAINT `fk_ausleihen_zustand_rueckgabe` FOREIGN KEY (`zustand_bei_rueckgabe_id`) REFERENCES `zustandskatalog` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.buch_details definition

CREATE TABLE `buch_details` (
  `artikel_id` int(10) unsigned NOT NULL,
  `titelcode` varchar(20) DEFAULT NULL,
  `autor` varchar(255) DEFAULT NULL,
  `verlag` varchar(255) DEFAULT NULL,
  `fach_id` int(10) unsigned DEFAULT NULL,
  `veroeffentlicht` varchar(50) DEFAULT NULL,
  `cover_url` varchar(500) DEFAULT NULL,
  `cover_bild` longtext DEFAULT NULL,
  `jahrgangsstufe` varchar(50) DEFAULT NULL,
  `schuljahr_ausgabe` varchar(20) DEFAULT NULL,
  `ist_arbeitsheft` tinyint(1) NOT NULL DEFAULT 0,
  `ist_lehrerversion` tinyint(1) NOT NULL DEFAULT 0,
  `herkunft_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`artikel_id`),
  UNIQUE KEY `uq_buch_details_titelcode` (`titelcode`),
  KEY `idx_buch_details_jahrgangsstufe` (`jahrgangsstufe`),
  KEY `idx_buch_details_veroeffentlicht` (`veroeffentlicht`),
  KEY `idx_buch_details_fach` (`fach_id`),
  KEY `idx_buch_details_herkunft` (`herkunft_id`),
  CONSTRAINT `fk_buch_details_artikel` FOREIGN KEY (`artikel_id`) REFERENCES `artikel` (`id`),
  CONSTRAINT `fk_buch_details_fach` FOREIGN KEY (`fach_id`) REFERENCES `faecher` (`id`),
  CONSTRAINT `fk_buch_details_herkunft` FOREIGN KEY (`herkunft_id`) REFERENCES `herkunft` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.exemplar_zuordnungen definition

CREATE TABLE `exemplar_zuordnungen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `haupt_exemplar_id` int(10) unsigned NOT NULL,
  `neben_exemplar_id` int(10) unsigned NOT NULL,
  `beziehungsart` varchar(50) NOT NULL,
  `beschreibung` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_exemplar_zuordnungen` (`haupt_exemplar_id`,`neben_exemplar_id`,`beziehungsart`),
  KEY `idx_exemplar_zuordnungen_neben` (`neben_exemplar_id`),
  CONSTRAINT `fk_exemplar_zuordnungen_haupt` FOREIGN KEY (`haupt_exemplar_id`) REFERENCES `artikel_exemplare` (`id`),
  CONSTRAINT `fk_exemplar_zuordnungen_neben` FOREIGN KEY (`neben_exemplar_id`) REFERENCES `artikel_exemplare` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.geraete_details definition

CREATE TABLE `geraete_details` (
  `artikel_id` int(10) unsigned NOT NULL,
  `geraetekategorie` varchar(100) NOT NULL,
  `modellnummer` varchar(100) DEFAULT NULL,
  `speichergroesse` varchar(50) DEFAULT NULL,
  `betriebssystem` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`artikel_id`),
  KEY `idx_geraete_details_geraetekategorie` (`geraetekategorie`),
  CONSTRAINT `fk_geraete_details_artikel` FOREIGN KEY (`artikel_id`) REFERENCES `artikel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.historie_eintraege definition

CREATE TABLE `historie_eintraege` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezug_typ` varchar(50) NOT NULL,
  `bezug_id` int(10) unsigned DEFAULT NULL,
  `exemplar_id` int(10) unsigned DEFAULT NULL,
  `ausleihe_id` int(10) unsigned DEFAULT NULL,
  `aktion` varchar(50) NOT NULL,
  `titel` varchar(255) NOT NULL,
  `details` text DEFAULT NULL,
  `ausgeloest_von` varchar(150) NOT NULL DEFAULT 'system',
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_historie_erstellt_am` (`erstellt_am`),
  KEY `idx_historie_bezug` (`bezug_typ`,`bezug_id`),
  KEY `idx_historie_exemplar` (`exemplar_id`),
  KEY `idx_historie_ausleihe` (`ausleihe_id`),
  CONSTRAINT `fk_historie_ausleihe` FOREIGN KEY (`ausleihe_id`) REFERENCES `ausleihen` (`id`),
  CONSTRAINT `fk_historie_exemplar` FOREIGN KEY (`exemplar_id`) REFERENCES `artikel_exemplare` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.leihvertraege_positionen definition

CREATE TABLE `leihvertraege_positionen` (
  `leihvertrag_id` int(10) unsigned NOT NULL,
  `artikel_exemplar_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`leihvertrag_id`,`artikel_exemplar_id`),
  KEY `idx_leihvertraege_positionen_exemplar` (`artikel_exemplar_id`),
  CONSTRAINT `fk_leihvertraege_positionen_exemplar` FOREIGN KEY (`artikel_exemplar_id`) REFERENCES `artikel_exemplare` (`id`),
  CONSTRAINT `fk_leihvertraege_positionen_vertrag` FOREIGN KEY (`leihvertrag_id`) REFERENCES `leihvertraege` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.schadensmeldungen definition

CREATE TABLE `schadensmeldungen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `exemplar_id` int(10) unsigned NOT NULL,
  `ausleihe_id` int(10) unsigned DEFAULT NULL,
  `gemeldet_von_ausleiher_id` int(10) unsigned DEFAULT NULL,
  `gemeldet_am` datetime NOT NULL DEFAULT current_timestamp(),
  `titel` varchar(255) NOT NULL,
  `beschreibung` text NOT NULL,
  `schadensgrad` varchar(30) NOT NULL DEFAULT 'mittel',
  `status` varchar(30) NOT NULL DEFAULT 'offen',
  `geloest_am` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_schadensmeldungen_exemplar` (`exemplar_id`),
  KEY `idx_schadensmeldungen_ausleihe` (`ausleihe_id`),
  KEY `idx_schadensmeldungen_ausleiher` (`gemeldet_von_ausleiher_id`),
  KEY `idx_schadensmeldungen_status` (`status`),
  CONSTRAINT `fk_schadensmeldungen_ausleihe` FOREIGN KEY (`ausleihe_id`) REFERENCES `ausleihen` (`id`),
  CONSTRAINT `fk_schadensmeldungen_ausleiher` FOREIGN KEY (`gemeldet_von_ausleiher_id`) REFERENCES `ausleiher` (`id`),
  CONSTRAINT `fk_schadensmeldungen_exemplar` FOREIGN KEY (`exemplar_id`) REFERENCES `artikel_exemplare` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- smedia.reparaturen definition

CREATE TABLE `reparaturen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `schadensmeldung_id` int(10) unsigned NOT NULL,
  `exemplar_id` int(10) unsigned NOT NULL,
  `gestartet_am` datetime NOT NULL DEFAULT current_timestamp(),
  `abgeschlossen_am` datetime DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'offen',
  `dienstleister` varchar(150) DEFAULT NULL,
  `beschreibung` text NOT NULL,
  `kosten` decimal(10,2) DEFAULT NULL,
  `abschluss_notiz` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_reparaturen_schaden` (`schadensmeldung_id`),
  KEY `idx_reparaturen_exemplar` (`exemplar_id`),
  KEY `idx_reparaturen_status` (`status`),
  CONSTRAINT `fk_reparaturen_exemplar` FOREIGN KEY (`exemplar_id`) REFERENCES `artikel_exemplare` (`id`),
  CONSTRAINT `fk_reparaturen_schadensmeldung` FOREIGN KEY (`schadensmeldung_id`) REFERENCES `schadensmeldungen` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------
-- Stammdaten / Kataloge
-- -----------------------------------------------------

INSERT INTO `artikel_kategorie` (`id`, `kategorie`, `aktiv`, `bemerkung`) VALUES
(1, 'Tablet', 1, NULL),
(2, 'Tablet_Zubehoer', 1, NULL),
(3, 'Laptop', 1, NULL),
(4, 'Laptop_Zubehoer', 1, NULL),
(5, 'Buch', 1, NULL),
(6, 'Taschenrechner', 1, NULL),
(7, 'Hotspot', 1, NULL),
(8, 'Netzteil', 1, NULL),
(9, 'Stift', NULL),
(10, 'Beamer', NULL),
(11, 'Tastatur', NULL);

INSERT INTO `ausleiharten` (`id`, `bezeichnung`, `aktiv`, `beschreibung`) VALUES
(1, 'einzelexemplar', 1, 'Ein einzelnes Exemplar wird ausgeliehen.'),
(2, 'klassensatz', 1, 'Mehrere Exemplare werden als Klassensatz ausgeliehen.');

INSERT INTO `faecher` (`id`, `bezeichnung`, `kuerzel`, `aktiv`) VALUES
(1, 'Deutsch', 'D', 1),
(2, 'Mathematik', 'M', 1),
(3, 'Englisch', 'E', 1),
(4, 'Biologie', 'BIO', 1),
(5, 'Geschichte', 'GE', 1),
(6, 'Physik', 'PH', 1),
(7, 'Chemie', 'CH', 1),
(8, 'Geographie', 'EK', 1),
(9, 'Sport', 'SP', 1),
(10, 'Musik', 'MU', 1),
(11, 'Kunst', 'KU', 1),
(12, 'Informatik', 'IF', 1),
(13, 'Ethik', 'ETH', 1),
(14, 'Religion', 'REL', 1),
(15, 'Latein', 'L', 1),
(16, 'Franzoesisch', 'F', 1),
(17, 'Politik', 'PO', 1),
(18, 'Wirtschaft', 'WI', 1);

INSERT INTO `herkunft` (`id`, `bezeichnung`, `aktiv`, `notiz`) VALUES
(1, 'Kauf', 1, NULL),
(2, 'DigitalPakt 2021', 1, NULL),
(3, 'Spende', 1, NULL),
(4, 'Leasing ABC', 1, NULL),
(5, 'Leasing DEF', 1, NULL),
(6, 'Stadt', 1, NULL);

INSERT INTO `standorte` (`id`, `bezeichnung`, `standort_typ`, `parent_id`, `beschreibung`, `aktiv`) VALUES
(1, 'Medienraum', 'Raum', NULL, NULL, 1),
(2, 'Bibliothek', 'Raum', NULL, NULL, 1),
(3, 'Lager Technik', 'Lager', NULL, NULL, 1),
(4, 'Klassenraum 7a', 'Raum', NULL, NULL, 1);

INSERT INTO `statuskatalog` (`id`, `bezeichnung`, `beschreibung`, `aktiv`, `ist_ausleihbar`) VALUES
(1, 'verfuegbar', 'Exemplar ist verfuegbar und kann ausgeliehen werden.', 1, 1),
(2, 'reserviert', 'Exemplar ist reserviert.', 1, 0),
(3, 'ausgeliehen', 'Exemplar ist aktuell ausgeliehen.', 1, 0),
(4, 'defekt', 'Exemplar ist defekt.', 1, 0),
(5, 'in_reparatur', 'Exemplar befindet sich in Reparatur.', 1, 0),
(6, 'verloren', 'Exemplar wurde als verloren gemeldet.', 1, 0),
(7, 'ausgesondert', 'Exemplar wurde ausgesondert.', 1, 0);

INSERT INTO `zustandskatalog` (`id`, `bezeichnung`, `beschreibung`, `aktiv`, `sortierung`) VALUES
(1, 'neu', 'Neuwertiger Zustand.', 1, 1),
(2, 'sehr_gut', 'Sehr guter Zustand.', 1, 2),
(3, 'gut', 'Guter Zustand.', 1, 3),
(4, 'gebraucht', 'Gebrauchter Zustand.', 1, 4),
(5, 'beschaedigt', 'Beschaedigter Zustand.', 1, 5),
(6, 'unvollstaendig', 'Nicht vollstaendig.', 1, 6);

INSERT INTO vertrags_vorlagen (name,typ,version,briefkopf_png,seitenrand_oben_mm,seitenrand_rechts_mm,seitenrand_unten_mm,seitenrand_links_mm,aktiv) VALUES
	 ('Leihvertrag TABLET','tablet',1,NULL,14.00,12.00,18.00,12.00,0),
	 ('Leihvertrag LAPTOP','laptop',1,NULL,14.00,12.00,18.00,12.00,1),
	 ('Leihvertrag WLAN','wlan',1,NULL,14.00,12.00,18.00,12.00,1),
	 ('Leihvertrag TABLET','tablet',2,'briefkoepfe/tablet_1778933310241.png',14.00,12.00,18.00,20.00,1);

INSERT INTO `inventar_typen` (`id`, `bezeichnung`, `beschreibung`, `ausleihart_id`, `aktiv`) VALUES
(1, 'buch', 'Ausleihbare Buecher und Buch-Exemplare.', 1, 1),
(2, 'tablet', 'Tablets wie iPads.', 1, 1),
(3, 'stift', 'Digitale Stifte wie Apple Pencil.', 1, 1),
(4, 'ladegeraet', 'Netzteile und Ladegeraete.', 1, 1),
(5, 'tastatur', 'Tastaturen fuer mobile Geraete.', 1, 1),
(6, 'beamer', 'Beamer und Projektionsgeraete.', 1, 1),
(7, 'tablet_zubehoer', 'Sonstiges Zubehoer fuer Tablets.', 1, 1),
(8, 'laptop', 'Laptops und Notebooks.', 1, 1),
(9, 'laptop_zubehoer', 'Sonstiges Zubehoer fuer Laptops.', 1, 1),
(10, 'taschenrechner', 'Taschenrechner.', 1, 1),
(11, 'hotspot', 'Mobile WLAN-Hotspots.', 1, 1),
(12, 'netzteil', 'Netzteile.', 1, 1);


INSERT INTO smedia.vertrags_abschnitte (v_vorlage_id,titel,abschnitt_art,sortier_nr,html_inhalt) VALUES
	 (1,'Nutzung des Tablets','rechtstext',1,'<p>Das ausgegebene Tablet bleibt Eigentum der Schule. Es ist ausschliesslich fuer schulische Zwecke, das Lernen zu Hause sowie fuer abgestimmte Unterrichtsvorhaben zu verwenden.</p>
        <p>Installationen, Konten und Schutzeinstellungen duerfen nur im durch die Schule freigegebenen Rahmen veraendert werden. Sicherheits- und Jugendschutzvorgaben sind einzuhalten.</p>'),
	 (1,'Sorgfalt und Haftung','rechtstext',2,'<p>Das Geraet ist pfleglich zu behandeln und vor Verlust, Diebstahl, Feuchtigkeit sowie unsachgemaesser Nutzung zu schuetzen. Schaeden oder Funktionsstoerungen sind unverzueglich der Schule mitzuteilen.</p>
        <p>Bei vorsetzlicher oder grob fahrlaessiger Beschaedigung koennen schul- oder zivilrechtliche Folgen entstehen. Die konkrete Pruefung erfolgt im Einzelfall.</p>'),
	 (1,'Rueckgabe und Daten','rechtstext',3,'<p>Das Tablet ist auf Aufforderung der Schule, bei Schulwechsel oder am Ende der vereinbarten Nutzung vollstaendig zurueckzugeben. Dazu gehoeren auch ausgegebenes Zubehoer und Schutzmaterialien.</p>
        <p>Vor der Rueckgabe koennen schulische Konten, Profile oder Daten im notwendigen Umfang entfernt werden. Private Daten sind durch die nutzende Person rechtzeitig selbst zu sichern.</p>'),
	 (2,'Nutzung des Laptops','rechtstext',1,'<p>Der Laptop wird fuer schulische Aufgaben, digitale Lernangebote und abgestimmte Heimarbeit zur Verfuegung gestellt. Die Nutzung erfolgt im Rahmen der schulischen Ordnungen und Weisungen.</p>
        <p>Manipulationen am Betriebssystem, an Verwaltungssoftware oder an Schutzmechanismen sind unzulaessig, sofern sie nicht durch die Schule freigegeben wurden.</p>'),
	 (2,'Pflege, Transport und Meldungen','rechtstext',2,'<p>Der Laptop ist transportsicher aufzubewahren und vor Beschaedigungen zu schuetzen. Netzteil, Eingabegeraete und weiteres Zubehoer sind gemeinsam mit dem Hauptgeraet sorgfaeltig zu verwahren.</p>
        <p>Defekte, Verlust oder Missbrauchsverdacht muessen ohne schuldhaftes Zoegern gemeldet werden, damit Schutz- und Sperrmassnahmen veranlasst werden koennen.</p>'),
	 (2,'Rueckgabe','rechtstext',3,'<p>Die Rueckgabe erfolgt in sauberem, vollstaendigem und moeglichst funktionsfaehigem Zustand. Vorhandene Benutzerdaten sind eigenverantwortlich zu sichern.</p>
        <p>Die Schule kann zur Vorbereitung einer Weitergabe ein Zuruecksetzen, Neuaufsetzen oder die Entfernung verwalteter Inhalte vornehmen.</p>'),
	 (3,'Zweck der Ueberlassung','rechtstext',1,'<p>Die bereitgestellte WLAN-Komponente beziehungsweise das zugeordnete Netzzugangsmittel dient der Teilnahme an schulischen Lern- und Kommunikationsangeboten im abgestimmten Rahmen.</p>
        <p>Die Nutzung ist auf berechtigte Personen beschraenkt. Zugangsdaten oder technische Komponenten duerfen nicht unbefugt an Dritte weitergegeben werden.</p>'),
	 (3,'Sicherheit und Verantwortlichkeit','rechtstext',2,'<p>Die ausgegebenen Komponenten sind vor Verlust und unbefugtem Zugriff zu schuetzen. Bei Stoerungen, Missbrauchsverdacht oder Verlust ist die Schule unmittelbar zu informieren.</p>
        <p>Es gelten die schulischen Regeln zur IT-Nutzung, zum Datenschutz und zur Informationssicherheit in ihrer jeweils gueltigen Fassung.</p>'),
	 (3,'Beendigung der Nutzung','rechtstext',3,'<p>Mit Ende der Berechtigung oder auf Anforderung der Schule sind ausgegebene Komponenten unverzueglich zurueckzugeben beziehungsweise Zugangsdaten nicht weiter zu verwenden.</p>
        <p>Die Schule kann Zugriffe aus organisatorischen oder sicherheitsrelevanten Gruenden jederzeit einschraenken oder beenden.</p>'),
	 (4,'Vorbemerkung','rechtstext',1,'<p>Im Rahmen des Sofortausstattungsprogramms „DigitalPakt Schule“ werden Schülerinnen und Schülern leihweise mit mobilen Endgeräten ausgestattet. Dieser Leihvertrag regelt Einzelheiten zur Nutzung der Leihgeräte und ist für beide Parteien verbindlich.</p>');
INSERT INTO smedia.vertrags_abschnitte (v_vorlage_id,titel,abschnitt_art,sortier_nr,html_inhalt) VALUES
	 (4,'§ 1 - Leihgerät und Grundsätze der Nutzung','rechtstext',2,'<p>(1)	Die Stadt Grevenbroich stellt dem/der Entleiher*in das/die auf Seite 1 aufgeführte(-n) Endgerät(-e) inkl. Zubehör - zusammen im Folgenden „das Leihgerät“ genannt - unentgeltlich zur Verfügung. 
</p><p>
Das Leihgerät verbleibt im Eigentum der Stadt Grevenbroich. Die Nutzung ist nur durch den/die Entleiher*in zulässig. Eine Veräußerung oder Weitergabe an Dritte - auch zu lediglich vorübergehender Nutzung - ist verboten. 
</p><p>
(2)	Der/die Entleiher*in verpflichtet sich zu jeder Zeit auf Verlangen Auskunft über den Verbleib des Leihgerätes zu geben und dieses der Schule jederzeit vorzuführen.
</p><p>
(3)	Das Leihgerät ist pfleglich und sorgsam zu behandeln, insbesondere ist das Leihgerät vor Verschmutzungen und Beschädigungen zu schützen. Das Anbringen von permanenten Markierungen und Aufklebern/Stickern ist nicht erlaubt. Ausgenommen hiervon sind durch die Stadt Grevenbroich autorisierte Aufkleber zum Hinweis auf Zuschussgeber. 
</p><p>
(4)	Das Leihgerät wird über ein zentrales Mobile Device Management (MDM) verwaltet und ist vorkonfiguriert. Die Stadt Grevenbroich behält sich gegenüber dem/der Entleiher*in vor, jederzeit Anpassungen der Konfigurationen vorzunehmen.
</p><p>
(5)	Die Stadt Grevenbroich oder die o.g. Schule kann bei Bedarf - vor allem bei nicht mehr vorhandener Funktionsfähigkeit - das Leihgerät sperren oder in den Auslieferungszustand zurücksetzen. Durch das Zurücksetzen werden alle auf dem Leihgerät gespeicherte Daten gelöscht. Der/die Entleiher*in hat keinen Anspruch auf Sicherung oder Speicherung von Daten oder Dokumenten. Die Stadt Grevenbroich und die ITK-Rheinland haben das Recht, jederzeit Einblick in das Leihgerät zu nehmen, sofern und soweit dies zur Prüfung der Funktionsfähigkeit des Leihgerätes oder der installierten
</p>'),
	 (4,'§ 2 Beschädigung, Diebstahl und Versicherung','rechtstext',3,'<p>(1)	Jede Beschädigung oder Funktionsbeeinträchtigung des Leihgeräts oder Zubehörs muss der Schulleitung unmittelbar nach Eintritt der Beschädigung/Funktionsbeeinträchtigung gemeldet werden.
</p><p>
(2)	Jeglicher Verlust des Leihgerätes muss der Schulleitung unmittelbar nach Verlust gemeldet werden. Bei Diebstahl des Leihgerätes erstattet die Stadt Grevenbroich als Eigentümerin polizeiliche Anzeige. 
</p><p>
(3)	Die Stadt Grevenbroich hat für das Leihgerät eine für den/die Entleiher*in kostenfreie Versicherung abgeschlossen. Dennoch kann es zu Zusatzkosten kommen. Diese können dem/der Entleiher*in als Selbstbeteiligung in Rechnung gestellt werden, wenn Schäden behoben werden müssen, die weder über die Geräte-Garantie noch über Dritte abgedeckt sind oder wenn der Versicherungsschutz erlischt. 
</p><p>
a.	Bei unverschuldeten Hardwareschäden innerhalb der Garantiezeit fallen keine Kosten an, wenn der Garantieanspruch vom Hersteller anerkannt wird.
</p><p>
b.	Bei Hardwareschäden, die nicht durch Dritte verursacht wurden, tritt die Versicherung der Stadt Grevenbroich in Kraft und stellt sicher, dass das Leihgerät repariert oder ersetzt wird. Die Stadt Grevenbroich behält sich die Möglichkeit vor, dem/der Entleiher*in die städtische Selbstbeteiligung in Höhe von bis zu 100,00 Euro in Rechnung zu stellen.
</p><p>
c.	Die Versicherung der Stadt Grevenbroich behält sich vor, Regress gegen die Versicherung des/der Entleihers/Entleiherin geltend zu machen, bei vorsätzlich oder grob fahrlässig herbeigeführten Hardwareschäden auch gegen den/die Entleiher*in. 
</p><p>
d.	Bei Diebstahl bzw. Verlust/Abhandenkommen des Leihgerätes behält sich die Stadt Grevenbroich vor, dem/der Entleiher*in die städtische Selbstbeteiligung in Höhe von 100,00 Euro in Rechnung zu stellen. 
</p><p>
(4)	Aus diesem Grunde wird empfohlen, vorab mit der ggf. bei dem/der Entleiher*in bereits bestehenden Haftpflicht- oder Hausratversicherung Kontakt aufzunehmen. Möglicherweise sind entsprechende Leistungen bereits in den vorhandenen Versicherungsverträgen enthalten oder können gegen eine kleine Gebühr dazu gebucht werden.
</p><p>
(5)	Andernfalls wird dem/der Entleiher*in zur Absicherung bei einer Beschädigung oder einem Diebstahl empfohlen, eigenverantwortlich eine Versicherung bei einem Versicherer nach Wahl abzuschließen. Die Kosten für die Versicherung trägt der/die Entleiher*in selbst. 
</p><p>
(6)	Ein Anspruch auf Ersatz bzw. Reparatur des Leihgerätes besteht nicht.  
</p>'),
	 (4,'§ 3 Nutzung nur zu schulischen Zwecken','rechtstext',4,'<p>(1)	Das Leihgerät darf ausschließlich für schulische Zwecke genutzt werden. Eine private Nutzung des Leihgerätes ist verboten. Als schulischer Zweck ist die Nutzung im Rahmen des Unterrichts, inklusive der Vor- und Nachbereitung von Unterrichtsinhalten anzusehen, welche mit den Unterrichtsinhalten oder sonstiger schulischer Arbeit im Zusammenhang stehen. 

(2)	Der/die Entleiher*in ist verpflichtet, sich an die geltenden Rechtvorschriften - auch innerschulischer Art - zu halten. Dazu gehören Urheber-, Jugendschutz-, Datenschutz- und Strafrecht sowie die Schulordnung.

(3)	Der/die Sorgeberechtigte*n ist/sind für die Einhaltung der Zweckbestimmung der Nutzung verantwortlich.

(4)	Das Leihgerät muss stets mit einem vollständig aufgeladenen Akkuladezustand in die Schule mitgebracht werden. Ferner ist sicherzustellen, dass auf dem Leihgerät genügend freier Speicherplatz für schulische Zwecke zur Verfügung steht.

(5)	Fotos, Filme und Audiomitschnitte dürfen während des Unterrichts und auf dem Schulgelände ausschließlich schulischen Zwecken unter Beachtung der datenschutzrechtlichen Bestimmungen aufgenommen werden.
</p>'),
	 (4,'§ 4 Verbotene Nutzungen','rechtstext',5,'<p>(1)	Fotos, Filme, Musik und andere Medien- und Internetinhalte jugendgefährdender, rassistischer, pornographischer, gewaltverherrlichender, ehrverletzender oder beleidigender Art dürfen weder aufgerufen noch gespeichert, zugänglich gemacht oder weiterverbreitet werden. Die Bestimmungen der Strafgesetze sind zu beachten.

(2)	Filme, Musikbeiträge, Texte, Bilder oder sonstige urheberrechtlich geschützte Werke dürfen nur mit Zustimmung des Urhebers oder der sonstigen Rechteinhaber im Internet zum Abruf bereitgestellt, verbreitet oder veröffentlicht werden. Ist im Einzelfall nicht aufzuklären, ob Urheberrechte verletzt sein könnten, ist die Nutzung untersagt.

(3)	Das allgemeine Persönlichkeitsrecht ist zu beachten. Foto-, Video- und Audioaufnahmen, einschließlich deren Anfertigung, Speicherung, Weitergabe, Verbreitung und Veröffentlichung, sind ohne Einwilligung der aufgenommenen Person unzulässig. 

(4)	Es ist verboten, mit dem Leihgerät Inhalte, die der Stadt Grevenbroich, der o.g. Schule oder dem Land Nordrhein-Westfalen schaden können, im Internet zu veröffentlichen, zu versenden oder sonst zugänglich zu machen. 	

(5)	Das Hoch- oder Herunterladen sowie das Kopieren von Dateien, insbesondere von Dateien, die in sog. „File-Sharing-Netzwerken“ angeboten werden, sind grundsätzlich untersagt. Die Umgehung von Kopierschutzmechanismen ist verboten.

(6)	Das Entfernen der Sperre, die verhindert, dass nicht geprüfte Fremdsoftware installiert oder nicht vom Hersteller zugelassene Manipulationen am Leihgerät ermöglicht werden (sog. „Jailbreak“), ist ebenso wie das Löschen/Deaktivieren der vorinstallierten Programme nicht erlaubt.

(7)	Es ist untersagt, mithilfe des Leihgerätes im eigenen oder fremden Namen Verträge abzuschließen und/oder kostenpflichtige Dienste in Anspruch zu nehmen. 

(8)	Es ist verboten, die auf dem Leihgerät bereits vorinstallierten Programme/Apps zu löschen, zu verändern oder an andere Personen weiterzugeben.
</p>'),
	 (4,'§ 5 Verstöße gegen den Leihvertrag','rechtstext',6,'<p>(1)	Bei Zuwiderhandlungen gegen diesen Leihvertrag kann durch die Stadt Grevenbroich oder die o.g. Schule die Nutzung des Leihgerätes nach pflichtgemäßem Ermessen ganz oder teilweise, zeitweise oder dauerhaft eingeschränkt oder untersagt werden. 

(2)	Die Stadt Grevenbroich und die o.g. Schule haften nicht im Falle einer rechts- oder verbotswidrigen Nutzung des Leihgerätes (vgl. § 4 dieses Leihvertrages).
</p>'),
	 (4,'§ 6 Beendigung und Rückgabe','rechtstext',7,'<p>(1)	Es besteht für beide Vertragsparteien die Möglichkeit, den Leihvertrag jederzeit mit sofortiger Wirkung zu beenden. Dazu ist eine entsprechende Mitteilung in Textform erforderlich. 

(2)	Verlässt der/die Entleiher*in die o.g. Schule, so endet das Vertragsverhältnis automatisch mit dem letzten Schultag. 

(3)	Der/die Entleiher*in verpflichtet sich, das Leihgerät mit vollständigem Zubehör nach Vertragsende unverzüglich in einem ordnungsgemäßen und technisch einwandfreien Zustand an die Schulleitung zurückzugeben. Die Rückgabe muss spätestens drei Werktage nach Beendigung des Vertragsverhältnisses erfolgen und mithilfe der „Anlage zum Leihvertrag über ein iPad inklusive Zubehör“ dokumentiert werden. 
</p>'),
	 (4,'§ 7 Vorschäden','rechtstext',8,'<p>Das Leihgerät ist neu und unbeschädigt.

	Das Leihgerät ist gebraucht. Der/die Entleiher*in und die Schulleitung fertigen gemeinsam ein Übergabeprotokoll an, um ggf. vorhandene Vorschäden zu dokumentieren. Diese „Anlage zum Leihvertrag über ein iPad inklusive Zubehör“ ist Vertragsbestandteil.

§ 8
Datenschutz

(1)	Es gelten die gesetzlichen Bestimmungen gemäß EU-Datenschutz-Grundverordnung (EU-DSGVO) zum Schutz personenbezogener Daten und deren Verarbeitung.

(2)	Im Rahmen des Supports und der Wartung des Leihgerätes dürfen personenbezogene Daten durch die Stadt Grevenbroich als Schulträger, die o.g. Schule und der ITK-Rheinland verarbeitet werden, die zur ordnungsgemäßen Erfüllung dieses Leihvertrages einschließlich aller Sorgfaltspflichten erforderlich sind (Art. 6 Abs. 1 S. 1 Buchst. b DSGVO).  

(3)	Der/die Entleiher*in ist damit einverstanden, dass personenbezogene Daten zur allgemeinen Administration - unter Wahrung datenschutzrechtlicher Grundsätze - gespeichert werden.

§ 9
Schlussbestimmungen

(1)	Sofern der Stadt Grevenbroich Ansprüche aus diesem Leihvertrag entstehen, können diese gegen den/die Entleiher*in geltend gemacht werden.

(2)	Jegliche Änderung oder Ergänzung dieses Leihvertrages sind nur wirksam, wenn sie schriftlich vereinbart werden. Dies gilt auch für eine Änderung dieser Schriftformklausel.
</p><p>
(3)	Sollten einzelne Bestimmungen dieses Leihvertrages ganz oder teilweise unwirksam oder nichtig sein oder infolge Änderung der Gesetzeslage oder durch höchstrichterliche Rechtsprechung oder auf andere Weise ganz oder teilweise unwirksam oder nichtig werden oder weist dieser Vertrag Lücken auf, so sind sich die Parteien darüber einig, dass die übrigen Bestimmungen dieses Leihvertrages davon unberührt und gültig bleiben. Für diesen Fall verpflichten sich die Vertragspartner, unter Berücksichtigung des Grundsatzes von Treu und Glauben an der Stelle der unwirksamen Bestimmung eine wirksame Bestimmung zu vereinbaren, welche dem Sinn und Zweck der unwirksamen Bestimmung möglichst nahekommt und von der anzunehmen ist, dass die Parteien sie im Zeitpunkt des Abschlusses dieses Leihvertrages vereinbart hätten, wenn sie die Unwirksamkeit oder Nichtigkeit gekannt oder vorgesehen hätten. Entsprechendes gilt, falls dieser Leihvertrag eine Lücke enthalten sollte.
</p></p><p>
<strong>Hinweis: Sofern nur ein Sorgeberechtigter unterschreibt, wird von diesem bestätigt, dass er entweder die alleinige elterliche Sorge für den/die Schüler*in hat oder mit Einwilligung und in Vertretung des anderen Sorgeberechtigten handelt.</strong>
</p>');


-- Folgende Tabellen bleiben absichtlich leer:
-- app_einstellungen, artikel, artikel_exemplare, ausleihen, ausleiher, buch_details,
-- exemplar_zuordnungen, geraete_details, historie_eintraege, klassen, lehrkraefte,
-- leihvertraege, leihvertraege_positionen, reparaturen, schadensmeldungen, schueler,
-- schueler_klassen.
