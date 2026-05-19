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
    a.id,
    CONCAT('BUCH-DE-', LPAD(seq.nr, 3, '0')),
    CONCAT('B-DE-', LPAD(seq.nr, 3, '0')),
    NULL,
    s.id,
    z.id,
    st.id,
    '2026-07-01',
    24.50,
    NULL,
    1,
    'Deutsch 7 - Satz A',
    CONCAT('Exemplar ', seq.nr, ' aus dem Klassensatz Deutsch 7.')
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
    SELECT 11 UNION ALL
    SELECT 12 UNION ALL
    SELECT 13 UNION ALL
    SELECT 14 UNION ALL
    SELECT 15 UNION ALL
    SELECT 16 UNION ALL
    SELECT 17 UNION ALL
    SELECT 18 UNION ALL
    SELECT 19 UNION ALL
    SELECT 20 UNION ALL
    SELECT 21 UNION ALL
    SELECT 22 UNION ALL
    SELECT 23 UNION ALL
    SELECT 24 UNION ALL
    SELECT 25 UNION ALL
    SELECT 26 UNION ALL
    SELECT 27 UNION ALL
    SELECT 28 UNION ALL
    SELECT 29 UNION ALL
    SELECT 30 UNION ALL
    SELECT 31 UNION ALL
    SELECT 32 UNION ALL
    SELECT 33 UNION ALL
    SELECT 34 UNION ALL
    SELECT 35 UNION ALL
    SELECT 36 UNION ALL
    SELECT 37 UNION ALL
    SELECT 38 UNION ALL
    SELECT 39 UNION ALL
    SELECT 40
) AS seq
JOIN artikel a ON a.titel = 'Deutsch 7'
JOIN statuskatalog s ON s.bezeichnung = 'verfuegbar'
JOIN zustandskatalog z ON z.bezeichnung = 'sehr_gut'
JOIN standorte st ON st.bezeichnung = 'Bibliothek'
LEFT JOIN artikel_exemplare ae_bestand
    ON ae_bestand.inventarnummer = CONCAT('BUCH-DE-', LPAD(seq.nr, 3, '0'))
WHERE ae_bestand.id IS NULL;
