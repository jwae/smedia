USE smedia;

ALTER TABLE klassen
  DROP INDEX idx_klassen_sortierung,
  DROP COLUMN sortierung;
