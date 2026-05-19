USE smedia;

ALTER TABLE buch_details
    ADD COLUMN IF NOT EXISTS veroeffentlicht VARCHAR(50) NULL AFTER fach;

ALTER TABLE buch_details
    ADD KEY IF NOT EXISTS idx_buch_details_veroeffentlicht (veroeffentlicht);
