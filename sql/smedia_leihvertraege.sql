USE smedia;

CREATE TABLE IF NOT EXISTS vertrags_vorlagen (
    v_vorlage_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(190) NOT NULL,
    typ VARCHAR(50) NOT NULL,
    version INT NOT NULL,
    aktiv TINYINT(1) NOT NULL DEFAULT 1,
    erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (v_vorlage_id),
    UNIQUE KEY uq_vertrags_vorlagen_typ_version (typ, version),
    KEY idx_vertrags_vorlagen_typ_aktiv (typ, aktiv)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
