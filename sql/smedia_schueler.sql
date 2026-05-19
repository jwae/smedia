USE smedia;

CREATE TABLE IF NOT EXISTS schueler (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    S_ID INT NULL,
    vorname VARCHAR(100) NOT NULL,
    nachname VARCHAR(100) NOT NULL,
    anzeigename VARCHAR(220) NOT NULL,
    barcode VARCHAR(150) NULL,
    email VARCHAR(190) NULL,
    geburtsdatum DATE NULL,
    aktiv TINYINT(1) NOT NULL DEFAULT 1,
    notizen TEXT NULL,
    erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_schueler_s_id (S_ID),
    UNIQUE KEY uq_schueler_barcode (barcode),
    KEY idx_schueler_name (nachname, vorname),
    KEY idx_schueler_anzeigename (anzeigename)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS schueler_klassen (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    schueler_id INT UNSIGNED NOT NULL,
    klassen_id INT UNSIGNED NOT NULL,
    schuljahr VARCHAR(20) NOT NULL,
    von_datum DATE NULL,
    bis_datum DATE NULL,
    ist_aktuell TINYINT(1) NOT NULL DEFAULT 1,
    erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_schueler_klassen_schueler (schueler_id),
    KEY idx_schueler_klassen_klasse (klassen_id),
    KEY idx_schueler_klassen_schuljahr (schuljahr),
    KEY idx_schueler_klassen_aktuell (ist_aktuell),
    CONSTRAINT fk_schueler_klassen_schueler
        FOREIGN KEY (schueler_id) REFERENCES schueler(id),
    CONSTRAINT fk_schueler_klassen_klasse
        FOREIGN KEY (klassen_id) REFERENCES klassen(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
