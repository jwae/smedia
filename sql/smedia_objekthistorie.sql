USE smedia;

INSERT INTO historie_eintraege (
    bezug_typ,
    bezug_id,
    exemplar_id,
    aktion,
    titel,
    details,
    ausgeloest_von,
    erstellt_am
)
SELECT
    'exemplar',
    ae.id,
    ae.id,
    'exemplar_angelegt',
    CONCAT('Exemplar angelegt: ', ae.inventarnummer),
    CONCAT(
        a.titel,
        ' wurde im Bestand angelegt. Status: ',
        sk.bezeichnung,
        ', Zustand: ',
        zk.bezeichnung,
        ', Standort: ',
        COALESCE(st.bezeichnung, 'unbekannt')
    ),
    'migration',
    ae.erstellt_am
FROM artikel_exemplare ae
JOIN artikel a ON a.id = ae.artikel_id
JOIN statuskatalog sk ON sk.id = ae.status_id
JOIN zustandskatalog zk ON zk.id = ae.zustand_id
LEFT JOIN standorte st ON st.id = ae.standort_id
WHERE NOT EXISTS (
    SELECT 1
    FROM historie_eintraege h
    WHERE h.exemplar_id = ae.id
      AND h.aktion = 'exemplar_angelegt'
);
