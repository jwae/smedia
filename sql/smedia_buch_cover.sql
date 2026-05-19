USE smedia;

ALTER TABLE buch_details
    ADD COLUMN IF NOT EXISTS cover_url VARCHAR(500) NULL AFTER veroeffentlicht;
