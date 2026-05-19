ALTER TABLE standorte
ADD COLUMN aktiv TINYINT(1) NOT NULL DEFAULT 1 AFTER beschreibung;

UPDATE standorte
SET aktiv = 1
WHERE aktiv IS NULL;
