USE smedia;

CREATE TABLE IF NOT EXISTS lehrkraefte (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    kuerzel VARCHAR(20) NULL,
    anrede VARCHAR(30) NULL,
    vorname VARCHAR(100) NOT NULL,
    nachname VARCHAR(100) NOT NULL,
    anzeigename VARCHAR(220) NOT NULL,
    barcode VARCHAR(150) NULL,
    email VARCHAR(190) NULL,
    fachbereich VARCHAR(120) NULL,
    aktiv TINYINT(1) NOT NULL DEFAULT 1,
    notizen TEXT NULL,
    erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_lehrkraefte_kuerzel (kuerzel),
    UNIQUE KEY uq_lehrkraefte_barcode (barcode),
    UNIQUE KEY uq_lehrkraefte_email (email),
    KEY idx_lehrkraefte_name (nachname, vorname),
    KEY idx_lehrkraefte_anzeigename (anzeigename),
    KEY idx_lehrkraefte_fachbereich (fachbereich)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
