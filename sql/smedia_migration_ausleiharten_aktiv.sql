ALTER TABLE ausleiharten
ADD COLUMN aktiv TINYINT(1) NOT NULL DEFAULT 1 AFTER bezeichnung;

UPDATE ausleiharten
SET aktiv = 1
WHERE aktiv IS NULL;
