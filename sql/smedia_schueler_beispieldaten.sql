USE smedia;

INSERT INTO schueler (
    vorname,
    nachname,
    anzeigename,
    barcode,
    geburtsdatum,
    aktiv,
    notizen
)
WITH RECURSIVE laufnummern AS (
    SELECT 1 AS nr
    UNION ALL
    SELECT nr + 1
    FROM laufnummern
    WHERE nr < 10
),
vornamen AS (
    SELECT 1 AS nr, 'Mia' AS name
    UNION ALL SELECT 2, 'Noah'
    UNION ALL SELECT 3, 'Emma'
    UNION ALL SELECT 4, 'Luca'
    UNION ALL SELECT 5, 'Lea'
    UNION ALL SELECT 6, 'Ben'
    UNION ALL SELECT 7, 'Ida'
    UNION ALL SELECT 8, 'Jonas'
    UNION ALL SELECT 9, 'Leni'
    UNION ALL SELECT 10, 'Paul'
),
nachnamen AS (
    SELECT 1 AS nr, 'Beispiel' AS name
    UNION ALL SELECT 2, 'Muster'
    UNION ALL SELECT 3, 'Sommer'
    UNION ALL SELECT 4, 'Winter'
    UNION ALL SELECT 5, 'Schulz'
    UNION ALL SELECT 6, 'Fischer'
    UNION ALL SELECT 7, 'Neumann'
    UNION ALL SELECT 8, 'Klein'
    UNION ALL SELECT 9, 'Wagner'
    UNION ALL SELECT 10, 'Hoffmann'
)
SELECT
    v.name AS vorname,
    CONCAT(n.name, ' ', k.bezeichnung) AS nachname,
    CONCAT(v.name, ' ', n.name, ' ', k.bezeichnung, ' ', LPAD(l.nr, 2, '0')) AS anzeigename,
    CONCAT('S-', UPPER(k.bezeichnung), '-', LPAD(l.nr, 3, '0')) AS barcode,
    DATE_ADD('2012-01-01', INTERVAL ((CAST(k.stufe AS UNSIGNED) * 11) + l.nr) DAY) AS geburtsdatum,
    1 AS aktiv,
    CONCAT('Beispielschueler fuer Klasse ', k.bezeichnung, '.') AS notizen
FROM klassen k
JOIN laufnummern l
    ON 1 = 1
JOIN vornamen v
    ON v.nr = l.nr
JOIN nachnamen n
    ON n.nr = l.nr
LEFT JOIN schueler s
    ON s.barcode = CONCAT('S-', UPPER(k.bezeichnung), '-', LPAD(l.nr, 3, '0'))
WHERE k.parallelklasse IN ('a', 'b')
  AND k.stufe NOT IN ('11', '12', '13', 'EF', 'Q1', 'Q2')
  AND s.id IS NULL;

INSERT INTO schueler_klassen (
    schueler_id,
    klassen_id,
    schuljahr,
    von_datum,
    bis_datum,
    ist_aktuell
)
WITH RECURSIVE laufnummern AS (
    SELECT 1 AS nr
    UNION ALL
    SELECT nr + 1
    FROM laufnummern
    WHERE nr < 10
)
SELECT
    s.id,
    k.id,
    '2026/27',
    '2026-08-20',
    NULL,
    1
FROM klassen k
JOIN laufnummern l
    ON 1 = 1
JOIN schueler s
    ON s.barcode = CONCAT('S-', UPPER(k.bezeichnung), '-', LPAD(l.nr, 3, '0'))
LEFT JOIN schueler_klassen sk
    ON sk.schueler_id = s.id
   AND sk.klassen_id = k.id
   AND sk.schuljahr = '2026/27'
WHERE k.parallelklasse IN ('a', 'b')
  AND k.stufe NOT IN ('11', '12', '13', 'EF', 'Q1', 'Q2')
  AND sk.id IS NULL;
