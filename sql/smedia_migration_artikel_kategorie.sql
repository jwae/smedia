-- Migration: Tabelle artikel_kategorie
-- Datum: 2026-05-15

USE smedia;

CREATE TABLE IF NOT EXISTS artikel_kategorie (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    kategorie VARCHAR(150) NOT NULL,
    bemerkung TEXT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_artikel_kategorie_kategorie (kategorie)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE artikel
    ADD COLUMN artikel_kategorie_id INT UNSIGNED NULL AFTER herkunft_id,
    ADD KEY idx_artikel_kategorie (artikel_kategorie_id),
    ADD CONSTRAINT fk_artikel_kategorie
        FOREIGN KEY (artikel_kategorie_id) REFERENCES artikel_kategorie (id);

INSERT IGNORE INTO artikel_kategorie (kategorie, bemerkung) VALUES
    ('Tablet', NULL),
    ('Tablet_Zubehoer', NULL),
    ('Laptop', NULL),
    ('Laptop_Zubehoer', NULL),
    ('Buch', NULL),
    ('Taschenrechner', NULL),
    ('Hotspot', NULL),
    ('Netzteil', NULL),
    ('Stift', NULL);
