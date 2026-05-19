USE smedia;

CREATE TABLE IF NOT EXISTS klassen (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    bezeichnung VARCHAR(10) NOT NULL,
    stufe VARCHAR(10) NOT NULL,
    parallelklasse CHAR(1) NULL,
    aktiv TINYINT(1) NOT NULL DEFAULT 1,
    erstellt_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    aktualisiert_am DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_klassen_bezeichnung (bezeichnung),
    KEY idx_klassen_stufe (stufe)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO klassen (bezeichnung, stufe, parallelklasse)
WITH RECURSIVE nummern AS (
    SELECT 1 AS nr
    UNION ALL
    SELECT nr + 1
    FROM nummern
    WHERE nr < 10
),
parallelen AS (
    SELECT 'a' AS buchstabe
    UNION ALL SELECT 'b'
    UNION ALL SELECT 'c'
    UNION ALL SELECT 'd'
    UNION ALL SELECT 'e'
    UNION ALL SELECT 'f'
    UNION ALL SELECT 'g'
    UNION ALL SELECT 'h'
)
SELECT
    CONCAT(LPAD(n.nr, 2, '0'), p.buchstabe) AS bezeichnung,
    LPAD(n.nr, 2, '0') AS stufe,
    p.buchstabe AS parallelklasse
FROM nummern n
CROSS JOIN parallelen p
LEFT JOIN klassen k
    ON k.bezeichnung = CONCAT(LPAD(n.nr, 2, '0'), p.buchstabe)
WHERE k.id IS NULL;

INSERT INTO klassen (bezeichnung, stufe, parallelklasse)
SELECT
    stufen.stufe AS bezeichnung,
    stufen.stufe,
    NULL AS parallelklasse
FROM (
    SELECT '11' AS stufe
    UNION ALL SELECT '12'
    UNION ALL SELECT '13'
    UNION ALL SELECT 'EF'
    UNION ALL SELECT 'Q1'
    UNION ALL SELECT 'Q2'
) AS stufen
LEFT JOIN klassen k
    ON k.bezeichnung = stufen.stufe
WHERE k.id IS NULL;
