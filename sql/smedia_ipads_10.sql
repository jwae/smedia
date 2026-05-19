USE smedia;

INSERT INTO artikel_exemplare (
    artikel_id,
    inventarnummer,
    barcode,
    seriennummer,
    status_id,
    zustand_id,
    standort_id,
    anschaffungsdatum,
    kaufpreis,
    garantie_bis,
    ist_klassensatz,
    klassensatz_name,
    notizen
)
SELECT
    1,
    CONCAT('IPAD-', LPAD(seq.nr, 3, '0')),
    CONCAT('G-IPAD-', LPAD(seq.nr, 3, '0')),
    CONCAT('SN-IPAD-', LPAD(seq.nr, 3, '0')),
    1,
    2,
    1,
    '2025-08-15',
    449.00,
    '2027-08-15',
    0,
    NULL,
    'Einsatz fuer mobile Ausleihe.'
FROM (
    SELECT 2 AS nr UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5 UNION ALL
    SELECT 6 UNION ALL
    SELECT 7 UNION ALL
    SELECT 8 UNION ALL
    SELECT 9 UNION ALL
    SELECT 10 UNION ALL
    SELECT 11
) AS seq
LEFT JOIN artikel_exemplare ae
    ON ae.inventarnummer = CONCAT('IPAD-', LPAD(seq.nr, 3, '0'))
WHERE ae.id IS NULL;
