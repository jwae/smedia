USE smedia;

INSERT IGNORE INTO lehrkraefte (
    kuerzel,
    anrede,
    vorname,
    nachname,
    anzeigename,
    barcode,
    email,
    fachbereich,
    aktiv,
    notizen
) VALUES
    ('BCK', 'Frau', 'Anna', 'Becker', 'Frau Anna Becker', 'L-BCK-001', 'anna.becker@schule.local', 'Deutsch', 1, 'Beispiel-Lehrkraft fuer Deutsch.'),
    ('SND', 'Herr', 'Tobias', 'Schneider', 'Herr Tobias Schneider', 'L-SND-001', 'tobias.schneider@schule.local', 'Informatik', 1, 'Beispiel-Lehrkraft fuer IT und Medien.'),
    ('MLR', 'Frau', 'Sarah', 'Mueller', 'Frau Sarah Mueller', 'L-MLR-001', 'sarah.mueller@schule.local', 'Mathematik', 1, 'Beispiel-Lehrkraft fuer Mathematik.'),
    ('KCH', 'Herr', 'David', 'Koch', 'Herr David Koch', 'L-KCH-001', 'david.koch@schule.local', 'Biologie', 1, 'Beispiel-Lehrkraft fuer Naturwissenschaften.'),
    ('WGN', 'Frau', 'Julia', 'Wagner', 'Frau Julia Wagner', 'L-WGN-001', 'julia.wagner@schule.local', 'Englisch', 1, 'Beispiel-Lehrkraft fuer Fremdsprachen.'),
    ('HFM', 'Herr', 'Lars', 'Hoffmann', 'Herr Lars Hoffmann', 'L-HFM-001', 'lars.hoffmann@schule.local', 'Geschichte', 1, 'Beispiel-Lehrkraft fuer Gesellschaftslehre.'),
    ('NMN', 'Frau', 'Katrin', 'Neumann', 'Frau Katrin Neumann', 'L-NMN-001', 'katrin.neumann@schule.local', 'Kunst', 1, 'Beispiel-Lehrkraft fuer Kunst.'),
    ('FSR', 'Herr', 'Jan', 'Fischer', 'Herr Jan Fischer', 'L-FSR-001', 'jan.fischer@schule.local', 'Sport', 1, 'Beispiel-Lehrkraft fuer Sport.');
