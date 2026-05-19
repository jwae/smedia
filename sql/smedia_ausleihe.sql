USE smedia;

CREATE TABLE ausleiher (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    ausleiher_typ VARCHAR(50) NOT NULL,
    klasse_oder_bereich VARCHAR(100) NULL,
    barcode VARCHAR(150) NULL,
    aktiv TINYINT(1) NOT NULL DEFAULT 1,
    erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_ausleiher_barcode (barcode),
    KEY idx_ausleiher_typ (ausleiher_typ),
    KEY idx_ausleiher_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ausleihen (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    exemplar_id INT UNSIGNED NOT NULL,
    ausleiher_id INT UNSIGNED NOT NULL,
    ausgabe_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    faellig_am DATETIME NULL,
    rueckgabe_am DATETIME NULL,
    zustand_bei_ausgabe_id INT UNSIGNED NOT NULL,
    zustand_bei_rueckgabe_id INT UNSIGNED NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'offen',
    kommentar_ausgabe TEXT NULL,
    kommentar_rueckgabe TEXT NULL,
    erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_ausleihen_exemplar (exemplar_id),
    KEY idx_ausleihen_ausleiher (ausleiher_id),
    KEY idx_ausleihen_status (status),
    KEY idx_ausleihen_faelligkeit (faellig_am),
    CONSTRAINT fk_ausleihen_exemplar
        FOREIGN KEY (exemplar_id) REFERENCES artikel_exemplare (id),
    CONSTRAINT fk_ausleihen_ausleiher
        FOREIGN KEY (ausleiher_id) REFERENCES ausleiher (id),
    CONSTRAINT fk_ausleihen_zustand_ausgabe
        FOREIGN KEY (zustand_bei_ausgabe_id) REFERENCES zustandskatalog (id),
    CONSTRAINT fk_ausleihen_zustand_rueckgabe
        FOREIGN KEY (zustand_bei_rueckgabe_id) REFERENCES zustandskatalog (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO ausleiher (name, ausleiher_typ, klasse_oder_bereich, barcode) VALUES
    ('Frau Becker', 'lehrkraft', 'Deutsch', 'P-LEHR-001'),
    ('Herr Schneider', 'lehrkraft', 'IT', 'P-LEHR-002'),
    ('Max Mustermann', 'schueler', '7a', 'P-S-001'),
    ('Anna Becker', 'schueler', '7a', 'P-S-002'),
    ('Klasse 7a', 'klasse', 'Jahrgang 7', 'P-KLASSE-7A');

INSERT INTO ausleihen (
    exemplar_id,
    ausleiher_id,
    ausgabe_am,
    faellig_am,
    zustand_bei_ausgabe_id,
    status,
    kommentar_ausgabe
)
SELECT e.id, a.id, '2026-04-08 08:00:00', '2026-04-15 14:00:00', z.id, 'offen', 'Beispielausleihe fuer den Unterricht.'
FROM artikel_exemplare e
CROSS JOIN ausleiher a
CROSS JOIN zustandskatalog z
WHERE e.inventarnummer = 'IPAD-001'
  AND a.name = 'Frau Becker'
  AND z.bezeichnung = 'sehr_gut';

UPDATE artikel_exemplare e
JOIN statuskatalog s ON s.bezeichnung = 'ausgeliehen'
SET e.status_id = s.id
WHERE e.inventarnummer = 'IPAD-001';
