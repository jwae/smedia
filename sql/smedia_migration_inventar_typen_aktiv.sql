ALTER TABLE inventar_typen
ADD COLUMN aktiv TINYINT(1) NOT NULL DEFAULT 1 AFTER ausleihart_id;

UPDATE inventar_typen
SET aktiv = 1
WHERE aktiv IS NULL;
