USE smedia;

CREATE TABLE IF NOT EXISTS schadensmeldungen (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    exemplar_id INT UNSIGNED NOT NULL,
    ausleihe_id INT UNSIGNED NULL,
    gemeldet_von_ausleiher_id INT UNSIGNED NULL,
    gemeldet_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    titel VARCHAR(255) NOT NULL,
    beschreibung TEXT NOT NULL,
    schadensgrad VARCHAR(30) NOT NULL DEFAULT 'mittel',
    status VARCHAR(30) NOT NULL DEFAULT 'offen',
    geloest_am DATETIME NULL,
    PRIMARY KEY (id),
    KEY idx_schadensmeldungen_exemplar (exemplar_id),
    KEY idx_schadensmeldungen_ausleihe (ausleihe_id),
    KEY idx_schadensmeldungen_ausleiher (gemeldet_von_ausleiher_id),
    KEY idx_schadensmeldungen_status (status),
    CONSTRAINT fk_schadensmeldungen_exemplar
        FOREIGN KEY (exemplar_id) REFERENCES artikel_exemplare (id),
    CONSTRAINT fk_schadensmeldungen_ausleihe
        FOREIGN KEY (ausleihe_id) REFERENCES ausleihen (id),
    CONSTRAINT fk_schadensmeldungen_ausleiher
        FOREIGN KEY (gemeldet_von_ausleiher_id) REFERENCES ausleiher (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS reparaturen (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    schadensmeldung_id INT UNSIGNED NOT NULL,
    exemplar_id INT UNSIGNED NOT NULL,
    gestartet_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    abgeschlossen_am DATETIME NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'offen',
    dienstleister VARCHAR(150) NULL,
    beschreibung TEXT NOT NULL,
    kosten DECIMAL(10,2) NULL,
    abschluss_notiz TEXT NULL,
    PRIMARY KEY (id),
    KEY idx_reparaturen_schaden (schadensmeldung_id),
    KEY idx_reparaturen_exemplar (exemplar_id),
    KEY idx_reparaturen_status (status),
    CONSTRAINT fk_reparaturen_schadensmeldung
        FOREIGN KEY (schadensmeldung_id) REFERENCES schadensmeldungen (id),
    CONSTRAINT fk_reparaturen_exemplar
        FOREIGN KEY (exemplar_id) REFERENCES artikel_exemplare (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
