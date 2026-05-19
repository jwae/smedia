USE smedia;

ALTER TABLE buch_details
    CHANGE COLUMN isbn titelcode VARCHAR(20) NULL;

ALTER TABLE buch_details
    ADD UNIQUE KEY uq_buch_details_titelcode (titelcode);
