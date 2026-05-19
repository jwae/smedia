ALTER TABLE artikel_kategorie
ADD COLUMN aktiv TINYINT(1) NOT NULL DEFAULT 1 AFTER kategorie;

UPDATE artikel_kategorie
SET aktiv = 1
WHERE aktiv IS NULL;
