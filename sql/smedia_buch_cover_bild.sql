USE smedia;

ALTER TABLE buch_details
    ADD COLUMN IF NOT EXISTS cover_bild LONGTEXT NULL AFTER cover_url;
