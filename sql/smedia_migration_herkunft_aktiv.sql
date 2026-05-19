ALTER TABLE herkunft
ADD COLUMN aktiv TINYINT(1) NOT NULL DEFAULT 1 AFTER bezeichnung;

UPDATE herkunft
SET aktiv = 1
WHERE aktiv IS NULL;
