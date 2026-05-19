-- Migration: Tabelle herkunft + herkunft_id in artikel und buch_details
-- Datum: 2026-04-11

USE smedia;

-- 1. Neue Lookup-Tabelle herkunft
CREATE TABLE IF NOT EXISTS herkunft (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    bezeichnung VARCHAR(150) NOT NULL,
    notiz TEXT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_herkunft_bezeichnung (bezeichnung)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. herkunft_id in artikel
ALTER TABLE artikel
    ADD COLUMN herkunft_id INT UNSIGNED NULL AFTER modellbezeichnung,
    ADD KEY idx_artikel_herkunft (herkunft_id),
    ADD CONSTRAINT fk_artikel_herkunft
        FOREIGN KEY (herkunft_id) REFERENCES herkunft (id);

-- 3. herkunft_id in buch_details
ALTER TABLE buch_details
    ADD COLUMN herkunft_id INT UNSIGNED NULL AFTER ist_lehrerversion,
    ADD KEY idx_buch_details_herkunft (herkunft_id),
    ADD CONSTRAINT fk_buch_details_herkunft
        FOREIGN KEY (herkunft_id) REFERENCES herkunft (id);
