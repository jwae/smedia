ALTER TABLE statuskatalog
ADD COLUMN aktiv TINYINT(1) NOT NULL DEFAULT 1 AFTER beschreibung;

UPDATE statuskatalog
SET aktiv = 1
WHERE aktiv IS NULL;
