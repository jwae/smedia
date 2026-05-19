CREATE USER IF NOT EXISTS 'smedia_app'@'127.0.0.1' IDENTIFIED BY 'waT%#219XBdDJ$yI-5Sh';
CREATE USER IF NOT EXISTS 'smedia_app'@'localhost' IDENTIFIED BY 'waT%#219XBdDJ$yI-5Sh';
GRANT ALL PRIVILEGES ON smedia.* TO 'smedia_app'@'127.0.0.1';
GRANT ALL PRIVILEGES ON smedia.* TO 'smedia_app'@'localhost';
FLUSH PRIVILEGES;
