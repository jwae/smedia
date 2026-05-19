USE smedia;

INSERT INTO standorte (bezeichnung, standort_typ, beschreibung) VALUES
    ('Medienraum', 'raum', 'Zentraler Ausgaberaum fuer digitale Geraete.'),
    ('Bibliothek', 'raum', 'Ausgabe und Lagerung von Buechern.'),
    ('Lager Technik', 'lager', 'Lager fuer Technik und Zubehoer.'),
    ('Klassenraum 7a', 'raum', 'Klassenraum der 7a.');

INSERT INTO artikel (
    inventar_typ_id,
    titel,
    interne_bezeichnung,
    beschreibung,
    hersteller,
    modellbezeichnung
)
SELECT it.id, 'iPad 10. Generation 64 GB', 'Tablet fuer Unterricht', 'Schul-iPad fuer Unterricht und Ausleihe.', 'Apple', 'iPad 10. Generation'
FROM inventar_typen it WHERE it.bezeichnung = 'tablet'
UNION ALL
SELECT it.id, 'Apple Pencil USB-C', 'Digitaler Stift', 'Digitaler Stift fuer kompatible iPads.', 'Apple', 'Pencil USB-C'
FROM inventar_typen it WHERE it.bezeichnung = 'stift'
UNION ALL
SELECT it.id, 'Apple 20W USB-C Netzteil', 'Ladegeraet Tablet', 'Standard-Ladegeraet fuer iPads.', 'Apple', '20W USB-C Power Adapter'
FROM inventar_typen it WHERE it.bezeichnung = 'ladegeraet'
UNION ALL
SELECT it.id, 'Logitech Rugged Keyboard Folio', 'Tablet-Tastatur', 'Schutztastatur fuer Unterrichtstablets.', 'Logitech', 'Rugged Folio'
FROM inventar_typen it WHERE it.bezeichnung = 'tastatur'
UNION ALL
SELECT it.id, 'Epson EB-FH52', 'Beamer mobil', 'Mobiler Beamer fuer Klassenraeume.', 'Epson', 'EB-FH52'
FROM inventar_typen it WHERE it.bezeichnung = 'beamer'
UNION ALL
SELECT it.id, 'Deutsch 7', 'Lehrbuch Deutsch Jahrgang 7', 'Schulbuch fuer den Deutschunterricht Jahrgang 7.', NULL, NULL
FROM inventar_typen it WHERE it.bezeichnung = 'buch'
UNION ALL
SELECT it.id, 'Mathematik 7', 'Lehrbuch Mathematik Jahrgang 7', 'Schulbuch fuer den Mathematikunterricht Jahrgang 7.', NULL, NULL
FROM inventar_typen it WHERE it.bezeichnung = 'buch'
UNION ALL
SELECT it.id, 'Englisch 7', 'Lehrbuch Englisch Jahrgang 7', 'Schulbuch fuer den Englischunterricht Jahrgang 7.', NULL, NULL
FROM inventar_typen it WHERE it.bezeichnung = 'buch'
UNION ALL
SELECT it.id, 'Biologie 8', 'Lehrbuch Biologie Jahrgang 8', 'Schulbuch fuer den Biologieunterricht Jahrgang 8.', NULL, NULL
FROM inventar_typen it WHERE it.bezeichnung = 'buch'
UNION ALL
SELECT it.id, 'Geschichte 9', 'Lehrbuch Geschichte Jahrgang 9', 'Schulbuch fuer den Geschichtsunterricht Jahrgang 9.', NULL, NULL
FROM inventar_typen it WHERE it.bezeichnung = 'buch';

INSERT INTO geraete_details (
    artikel_id,
    geraetekategorie,
    modellnummer,
    speichergroesse,
    betriebssystem
)
SELECT a.id, 'tablet', 'A2696', '64 GB', 'iPadOS'
FROM artikel a
WHERE a.titel = 'iPad 10. Generation 64 GB'
UNION ALL
SELECT a.id, 'stift', 'MUWA3ZM/A', NULL, NULL
FROM artikel a
WHERE a.titel = 'Apple Pencil USB-C'
UNION ALL
SELECT a.id, 'ladegeraet', 'A2305', NULL, NULL
FROM artikel a
WHERE a.titel = 'Apple 20W USB-C Netzteil'
UNION ALL
SELECT a.id, 'tastatur', '920-009657', NULL, NULL
FROM artikel a
WHERE a.titel = 'Logitech Rugged Keyboard Folio'
UNION ALL
SELECT a.id, 'beamer', 'V11H978040', NULL, NULL
FROM artikel a
WHERE a.titel = 'Epson EB-FH52';

INSERT INTO faecher (bezeichnung, kuerzel) VALUES
    ('Deutsch', 'DE'),
    ('Mathematik', 'MA'),
    ('Englisch', 'EN'),
    ('Biologie', 'BIO'),
    ('Geschichte', 'GE'),
    ('Physik', 'PH'),
    ('Chemie', 'CH'),
    ('Geographie', 'GEO'),
    ('Sport', 'SP'),
    ('Musik', 'MU'),
    ('Kunst', 'KU'),
    ('Informatik', 'IT'),
    ('Ethik', 'ETH'),
    ('Religion', 'REL'),
    ('Latein', 'LAT'),
    ('Franzoesisch', 'FR'),
    ('Politik', 'POL'),
    ('Wirtschaft', 'WI');

INSERT INTO buch_details (
    artikel_id,
    titelcode,
    autor,
    verlag,
    fach_id,
    jahrgangsstufe,
    schuljahr_ausgabe,
    ist_arbeitsheft
)
SELECT a.id, '9783123161011', 'Katharina Brenner', 'Westermann', f.id, '7', '2026/27', 0
FROM artikel a CROSS JOIN faecher f
WHERE a.titel = 'Deutsch 7' AND f.bezeichnung = 'Deutsch'
UNION ALL
SELECT a.id, '9783060400013', 'Martin Seidel', 'Cornelsen', f.id, '7', '2026/27', 0
FROM artikel a CROSS JOIN faecher f
WHERE a.titel = 'Mathematik 7' AND f.bezeichnung = 'Mathematik'
UNION ALL
SELECT a.id, '9783464242011', 'Helen Brooks', 'Klett', f.id, '7', '2026/27', 0
FROM artikel a CROSS JOIN faecher f
WHERE a.titel = 'Englisch 7' AND f.bezeichnung = 'Englisch'
UNION ALL
SELECT a.id, '9783141524010', 'Nina Vogt', 'Westermann', f.id, '8', '2026/27', 0
FROM artikel a CROSS JOIN faecher f
WHERE a.titel = 'Biologie 8' AND f.bezeichnung = 'Biologie'
UNION ALL
SELECT a.id, '9783124435012', 'Thomas Berger', 'Klett', f.id, '9', '2026/27', 0
FROM artikel a CROSS JOIN faecher f
WHERE a.titel = 'Geschichte 9' AND f.bezeichnung = 'Geschichte';

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
SELECT a.id, 'IPAD-001', 'G-IPAD-001', 'SN-IPAD-001', s.id, z.id, st.id, '2025-08-15', 449.00, '2027-08-15', 0, NULL, 'Einsatz fuer mobile Ausleihe.'
FROM artikel a
CROSS JOIN statuskatalog s
CROSS JOIN zustandskatalog z
CROSS JOIN standorte st
WHERE a.titel = 'iPad 10. Generation 64 GB'
  AND s.bezeichnung = 'verfuegbar'
  AND z.bezeichnung = 'sehr_gut'
  AND st.bezeichnung = 'Medienraum'
UNION ALL
SELECT a.id, 'PENCIL-001', 'G-PENCIL-001', 'SN-PENCIL-001', s.id, z.id, st.id, '2025-08-15', 89.00, '2027-08-15', 0, NULL, 'Passend zu den Unterrichts-iPads.'
FROM artikel a
CROSS JOIN statuskatalog s
CROSS JOIN zustandskatalog z
CROSS JOIN standorte st
WHERE a.titel = 'Apple Pencil USB-C'
  AND s.bezeichnung = 'verfuegbar'
  AND z.bezeichnung = 'gut'
  AND st.bezeichnung = 'Medienraum'
UNION ALL
SELECT a.id, 'NETZ-001', 'G-NETZ-001', NULL, s.id, z.id, st.id, '2025-08-15', 25.00, '2027-08-15', 0, NULL, 'Reserve-Ladegeraet.'
FROM artikel a
CROSS JOIN statuskatalog s
CROSS JOIN zustandskatalog z
CROSS JOIN standorte st
WHERE a.titel = 'Apple 20W USB-C Netzteil'
  AND s.bezeichnung = 'verfuegbar'
  AND z.bezeichnung = 'gut'
  AND st.bezeichnung = 'Lager Technik'
UNION ALL
SELECT a.id, 'TAST-001', 'G-TAST-001', 'SN-TAST-001', s.id, z.id, st.id, '2025-08-20', 119.00, '2027-08-20', 0, NULL, 'Tastatur fuer Tabletwagen.'
FROM artikel a
CROSS JOIN statuskatalog s
CROSS JOIN zustandskatalog z
CROSS JOIN standorte st
WHERE a.titel = 'Logitech Rugged Keyboard Folio'
  AND s.bezeichnung = 'verfuegbar'
  AND z.bezeichnung = 'gut'
  AND st.bezeichnung = 'Medienraum'
UNION ALL
SELECT a.id, 'BEAMER-001', 'G-BEAMER-001', 'SN-BEAMER-001', s.id, z.id, st.id, '2024-09-01', 799.00, '2026-09-01', 0, NULL, 'Mobiler Beamer fuer Fachraeume.'
FROM artikel a
CROSS JOIN statuskatalog s
CROSS JOIN zustandskatalog z
CROSS JOIN standorte st
WHERE a.titel = 'Epson EB-FH52'
  AND s.bezeichnung = 'verfuegbar'
  AND z.bezeichnung = 'gebraucht'
  AND st.bezeichnung = 'Lager Technik'
UNION ALL
SELECT a.id, 'BUCH-DE-001', 'B-DE-001', NULL, s.id, z.id, st.id, '2026-07-01', 24.50, NULL, 1, 'Deutsch 7 - Satz A', 'Exemplar 1 aus dem Klassensatz Deutsch 7.'
FROM artikel a
CROSS JOIN statuskatalog s
CROSS JOIN zustandskatalog z
CROSS JOIN standorte st
WHERE a.titel = 'Deutsch 7'
  AND s.bezeichnung = 'verfuegbar'
  AND z.bezeichnung = 'sehr_gut'
  AND st.bezeichnung = 'Bibliothek'
UNION ALL
SELECT a.id, 'BUCH-MA-001', 'B-MA-001', NULL, s.id, z.id, st.id, '2026-07-01', 26.00, NULL, 1, 'Mathematik 7 - Satz A', 'Exemplar 1 aus dem Klassensatz Mathematik 7.'
FROM artikel a
CROSS JOIN statuskatalog s
CROSS JOIN zustandskatalog z
CROSS JOIN standorte st
WHERE a.titel = 'Mathematik 7'
  AND s.bezeichnung = 'verfuegbar'
  AND z.bezeichnung = 'neu'
  AND st.bezeichnung = 'Bibliothek'
UNION ALL
SELECT a.id, 'BUCH-EN-001', 'B-EN-001', NULL, s.id, z.id, st.id, '2026-07-01', 25.00, NULL, 1, 'Englisch 7 - Satz A', 'Exemplar 1 aus dem Klassensatz Englisch 7.'
FROM artikel a
CROSS JOIN statuskatalog s
CROSS JOIN zustandskatalog z
CROSS JOIN standorte st
WHERE a.titel = 'Englisch 7'
  AND s.bezeichnung = 'verfuegbar'
  AND z.bezeichnung = 'sehr_gut'
  AND st.bezeichnung = 'Bibliothek'
UNION ALL
SELECT a.id, 'BUCH-BIO-001', 'B-BIO-001', NULL, s.id, z.id, st.id, '2026-07-01', 27.50, NULL, 1, 'Biologie 8 - Satz B', 'Exemplar 1 aus dem Klassensatz Biologie 8.'
FROM artikel a
CROSS JOIN statuskatalog s
CROSS JOIN zustandskatalog z
CROSS JOIN standorte st
WHERE a.titel = 'Biologie 8'
  AND s.bezeichnung = 'verfuegbar'
  AND z.bezeichnung = 'gut'
  AND st.bezeichnung = 'Bibliothek'
UNION ALL
SELECT a.id, 'BUCH-GE-001', 'B-GE-001', NULL, s.id, z.id, st.id, '2026-07-01', 23.00, NULL, 1, 'Geschichte 9 - Satz C', 'Exemplar 1 aus dem Klassensatz Geschichte 9.'
FROM artikel a
CROSS JOIN statuskatalog s
CROSS JOIN zustandskatalog z
CROSS JOIN standorte st
WHERE a.titel = 'Geschichte 9'
  AND s.bezeichnung = 'verfuegbar'
  AND z.bezeichnung = 'gebraucht'
  AND st.bezeichnung = 'Bibliothek';

INSERT INTO exemplar_zuordnungen (
    haupt_exemplar_id,
    neben_exemplar_id,
    beziehungsart,
    beschreibung
)
SELECT ipad.id, pencil.id, 'zubehoer', 'Apple Pencil ist dem iPad zugeordnet.'
FROM artikel_exemplare ipad
CROSS JOIN artikel_exemplare pencil
WHERE ipad.inventarnummer = 'IPAD-001'
  AND pencil.inventarnummer = 'PENCIL-001'
UNION ALL
SELECT ipad.id, netz.id, 'zubehoer', 'Netzteil ist dem iPad zugeordnet.'
FROM artikel_exemplare ipad
CROSS JOIN artikel_exemplare netz
WHERE ipad.inventarnummer = 'IPAD-001'
  AND netz.inventarnummer = 'NETZ-001'
UNION ALL
SELECT ipad.id, tast.id, 'zubehoer', 'Tastatur ist dem iPad zugeordnet.'
FROM artikel_exemplare ipad
CROSS JOIN artikel_exemplare tast
WHERE ipad.inventarnummer = 'IPAD-001'
  AND tast.inventarnummer = 'TAST-001';
