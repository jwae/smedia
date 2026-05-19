USE smedia;

CREATE TABLE historie_eintraege (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    bezug_typ VARCHAR(50) NOT NULL,
    bezug_id INT UNSIGNED NULL,
    exemplar_id INT UNSIGNED NULL,
    ausleihe_id INT UNSIGNED NULL,
    aktion VARCHAR(50) NOT NULL,
    titel VARCHAR(255) NOT NULL,
    details TEXT NULL,
    ausgeloest_von VARCHAR(150) NOT NULL DEFAULT 'system',
    erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_historie_erstellt_am (erstellt_am),
    KEY idx_historie_bezug (bezug_typ, bezug_id),
    KEY idx_historie_exemplar (exemplar_id),
    KEY idx_historie_ausleihe (ausleihe_id),
    CONSTRAINT fk_historie_exemplar
        FOREIGN KEY (exemplar_id) REFERENCES artikel_exemplare (id),
    CONSTRAINT fk_historie_ausleihe
        FOREIGN KEY (ausleihe_id) REFERENCES ausleihen (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO historie_eintraege (
    bezug_typ,
    bezug_id,
    exemplar_id,
    ausleihe_id,
    aktion,
    titel,
    details,
    ausgeloest_von,
    erstellt_am
)
SELECT
    'ausleihe',
    al.id,
    al.exemplar_id,
    al.id,
    'ausgabe',
    CONCAT('Ausleihe erstellt: ', ae.inventarnummer),
    CONCAT(
        a.titel,
        ' wurde an ',
        aus.name,
        ' ausgegeben. Faellig: ',
        COALESCE(DATE_FORMAT(al.faellig_am, '%d.%m.%Y %H:%i'), 'offen')
    ),
    'migration',
    al.ausgabe_am
FROM ausleihen al
JOIN artikel_exemplare ae ON ae.id = al.exemplar_id
JOIN artikel a ON a.id = ae.artikel_id
JOIN ausleiher aus ON aus.id = al.ausleiher_id
WHERE NOT EXISTS (
    SELECT 1
    FROM historie_eintraege h
    WHERE h.ausleihe_id = al.id
      AND h.aktion = 'ausgabe'
);
