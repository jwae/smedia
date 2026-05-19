USE smedia;

ALTER TABLE ausleiher
    ADD COLUMN IF NOT EXISTS quelle_typ VARCHAR(30) NULL AFTER ausleiher_typ,
    ADD COLUMN IF NOT EXISTS quelle_id INT UNSIGNED NULL AFTER quelle_typ;

CREATE UNIQUE INDEX uq_ausleiher_quelle
    ON ausleiher (quelle_typ, quelle_id);
