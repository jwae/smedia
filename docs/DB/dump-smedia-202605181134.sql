/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.7.2-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: smedia
-- ------------------------------------------------------
-- Server version	12.2.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `app_einstellungen`
--

DROP TABLE IF EXISTS `app_einstellungen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_einstellungen` (
  `bereich` varchar(50) NOT NULL,
  `daten_json` longtext NOT NULL,
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`bereich`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_einstellungen`
--

LOCK TABLES `app_einstellungen` WRITE;
/*!40000 ALTER TABLE `app_einstellungen` DISABLE KEYS */;
/*!40000 ALTER TABLE `app_einstellungen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artikel`
--

DROP TABLE IF EXISTS `artikel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `artikel` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inventar_typ_id` int(10) unsigned NOT NULL,
  `titel` varchar(255) NOT NULL,
  `interne_bezeichnung` varchar(255) DEFAULT NULL,
  `beschreibung` text DEFAULT NULL,
  `hersteller` varchar(150) DEFAULT NULL,
  `modellbezeichnung` varchar(150) DEFAULT NULL,
  `herkunft_id` int(10) unsigned DEFAULT NULL,
  `artikel_kategorie_id` int(10) unsigned DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_artikel_inventar_typ` (`inventar_typ_id`),
  KEY `idx_artikel_titel` (`titel`),
  KEY `idx_artikel_herkunft` (`herkunft_id`),
  KEY `idx_artikel_kategorie` (`artikel_kategorie_id`),
  CONSTRAINT `fk_artikel_herkunft` FOREIGN KEY (`herkunft_id`) REFERENCES `herkunft` (`id`),
  CONSTRAINT `fk_artikel_inventar_typ` FOREIGN KEY (`inventar_typ_id`) REFERENCES `inventar_typen` (`id`),
  CONSTRAINT `fk_artikel_kategorie` FOREIGN KEY (`artikel_kategorie_id`) REFERENCES `artikel_kategorie` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artikel`
--

LOCK TABLES `artikel` WRITE;
/*!40000 ALTER TABLE `artikel` DISABLE KEYS */;
INSERT INTO `artikel` VALUES
(1,2,'iPad 10. Generation 64 GB','iPad 10','Schul-iPad fuer Unterricht und Ausleihe.','Apple','iPad 10. Generation',2,1,1,'2026-04-08 22:59:12','2026-05-15 23:42:32'),
(2,3,'Apple Pencil USB-C','Digitaler Stift','Digitaler Stift fuer kompatible iPads.','Apple','Pencil USB-C',2,2,1,'2026-04-08 22:59:12','2026-05-15 23:42:32'),
(3,4,'Apple 20W USB-C Netzteil','Ladegeraet Tablet','Standard-Ladegeraet fuer iPads.','Apple','20W USB-C Power Adapter',2,2,1,'2026-04-08 22:59:12','2026-05-15 23:42:32'),
(4,5,'Logitech Rugged Keyboard Folio','Tablet-Tastatur','Schutztastatur fuer Unterrichtstablets.','Logitech','Rugged Folio',1,2,1,'2026-04-08 22:59:12','2026-05-15 23:42:32'),
(5,6,'Epson EB-FH52','Beamer mobil','Mobiler Beamer fuer Klassenraeume.','Epson','EB-FH52',NULL,NULL,1,'2026-04-08 22:59:12','2026-04-08 22:59:12'),
(6,1,'Deutsch 7','Lehrbuch Deutsch Jahrgang 7','Schulbuch fuer den Deutschunterricht Jahrgang 7.',NULL,NULL,NULL,5,1,'2026-04-08 22:59:12','2026-05-15 23:42:32'),
(7,1,'Mathematik 7','Lehrbuch Mathematik Jahrgang 7','Schulbuch fuer den Mathematikunterricht Jahrgang 7.',NULL,NULL,NULL,5,1,'2026-04-08 22:59:12','2026-05-15 23:42:32'),
(8,1,'Englisch 7','Lehrbuch Englisch Jahrgang 7','Schulbuch fuer den Englischunterricht Jahrgang 7.',NULL,NULL,NULL,5,1,'2026-04-08 22:59:12','2026-05-15 23:42:32'),
(9,1,'Biologie 8','Lehrbuch Biologie Jahrgang 8','Schulbuch fuer den Biologieunterricht Jahrgang 8.',NULL,NULL,NULL,5,1,'2026-04-08 22:59:12','2026-05-15 23:42:32'),
(10,1,'Geschichte 9','Lehrbuch Geschichte Jahrgang 9','Schulbuch fuer den Geschichtsunterricht Jahrgang 9.',NULL,NULL,NULL,5,1,'2026-04-08 22:59:12','2026-05-15 23:42:32'),
(16,1,'Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9',NULL,NULL,NULL,NULL,NULL,5,1,'2026-04-09 14:16:01','2026-05-15 23:42:32'),
(17,1,'Mathematik real',NULL,NULL,NULL,NULL,NULL,5,1,'2026-04-09 14:27:38','2026-05-15 23:42:32'),
(18,1,'Mittlerer Schulabschluss zentrale Prüfungen 2010',NULL,NULL,NULL,NULL,NULL,5,1,'2026-04-09 15:15:11','2026-05-15 23:42:32'),
(19,1,'Mathematik real',NULL,NULL,NULL,NULL,NULL,5,1,'2026-04-11 18:27:08','2026-05-15 23:42:32'),
(21,2,'iPad 9.Gen 32GB','iPad 9','Schul-iPad fuer Schüler','Apple','iPad 9. Gen',1,1,1,'2026-04-13 17:59:49','2026-05-15 23:42:32');
/*!40000 ALTER TABLE `artikel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artikel_exemplare`
--

DROP TABLE IF EXISTS `artikel_exemplare`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `artikel_exemplare` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `artikel_id` int(10) unsigned NOT NULL,
  `inventarnummer` varchar(100) NOT NULL,
  `barcode` varchar(150) NOT NULL,
  `seriennummer` varchar(150) DEFAULT NULL,
  `status_id` int(10) unsigned NOT NULL,
  `zustand_id` int(10) unsigned NOT NULL,
  `standort_id` int(10) unsigned DEFAULT NULL,
  `anschaffungsdatum` date DEFAULT NULL,
  `kaufpreis` decimal(10,2) DEFAULT NULL,
  `garantie_bis` date DEFAULT NULL,
  `ist_klassensatz` tinyint(1) NOT NULL DEFAULT 0,
  `klassensatz_name` varchar(150) DEFAULT NULL,
  `notizen` text DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_artikel_exemplare_inventarnummer` (`inventarnummer`),
  UNIQUE KEY `uq_artikel_exemplare_barcode` (`barcode`),
  UNIQUE KEY `uq_artikel_exemplare_seriennummer` (`seriennummer`),
  KEY `idx_artikel_exemplare_artikel` (`artikel_id`),
  KEY `idx_artikel_exemplare_status` (`status_id`),
  KEY `idx_artikel_exemplare_zustand` (`zustand_id`),
  KEY `idx_artikel_exemplare_standort` (`standort_id`),
  KEY `idx_artikel_exemplare_klassensatz` (`ist_klassensatz`,`klassensatz_name`),
  CONSTRAINT `fk_artikel_exemplare_artikel` FOREIGN KEY (`artikel_id`) REFERENCES `artikel` (`id`),
  CONSTRAINT `fk_artikel_exemplare_standort` FOREIGN KEY (`standort_id`) REFERENCES `standorte` (`id`),
  CONSTRAINT `fk_artikel_exemplare_status` FOREIGN KEY (`status_id`) REFERENCES `statuskatalog` (`id`),
  CONSTRAINT `fk_artikel_exemplare_zustand` FOREIGN KEY (`zustand_id`) REFERENCES `zustandskatalog` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=358 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artikel_exemplare`
--

LOCK TABLES `artikel_exemplare` WRITE;
/*!40000 ALTER TABLE `artikel_exemplare` DISABLE KEYS */;
INSERT INTO `artikel_exemplare` VALUES
(1,1,'IPAD-001','G-IPAD-001','SN-IPAD-001',3,3,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-08 22:59:12','2026-05-16 00:04:38'),
(2,2,'PENCIL-001','G-PENCIL-001','SN-PENCIL-001',3,1,1,'2025-08-15',89.00,'2027-08-15',0,NULL,'Passend zu den Unterrichts-iPads.',1,'2026-04-08 22:59:12','2026-05-15 10:28:25'),
(3,3,'NETZ-001','G-NETZ-001',NULL,3,2,3,'2025-08-15',25.00,'2027-08-15',0,NULL,'Reserve-Ladegeraet.',1,'2026-04-08 22:59:12','2026-04-08 23:31:26'),
(4,4,'TAST-001','G-TAST-001','SN-TAST-001',3,3,1,'2025-08-20',119.00,'2027-08-20',0,NULL,'Tastatur fuer Tabletwagen.',1,'2026-04-08 22:59:12','2026-04-20 21:30:28'),
(5,5,'BEAMER-001','G-BEAMER-001','SN-BEAMER-001',1,3,3,'2024-09-01',799.00,'2026-09-01',0,NULL,'Mobiler Beamer fuer Fachraeume.',1,'2026-04-08 22:59:12','2026-04-09 11:38:38'),
(6,6,'BUCH-DE-001','B-DE-001',NULL,1,4,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 1 aus dem Klassensatz Deutsch 7.',1,'2026-04-08 22:59:12','2026-04-21 11:29:03'),
(7,7,'BUCH-MA-001','B-MA-001',NULL,1,3,2,'2026-07-01',26.00,NULL,1,'Mathematik 7 - Satz A','Exemplar 1 aus dem Klassensatz Mathematik 7.',1,'2026-04-08 22:59:12','2026-05-11 23:20:11'),
(8,8,'BUCH-EN-001','B-EN-001',NULL,1,3,2,'2026-07-01',25.00,NULL,1,'Englisch 7 - Satz A','Exemplar 1 aus dem Klassensatz Englisch 7.',1,'2026-04-08 22:59:12','2026-05-11 23:23:07'),
(9,9,'BUCH-BIO-001','B-BIO-001',NULL,3,4,2,'2026-07-01',27.50,NULL,1,'Biologie 8 - Satz B','Exemplar 1 aus dem Klassensatz Biologie 8.',1,'2026-04-08 22:59:12','2026-05-14 22:28:36'),
(10,10,'BUCH-GE-001','B-GE-001',NULL,1,3,2,'2026-07-01',23.00,NULL,1,'Geschichte 9 - Satz C','Exemplar 1 aus dem Klassensatz Geschichte 9.',1,'2026-04-08 22:59:12','2026-04-14 20:10:28'),
(16,6,'BUCH-DE-002','B-DE-002',NULL,1,3,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 2 aus dem Klassensatz Deutsch 7.',1,'2026-04-09 10:48:01','2026-05-14 19:10:41'),
(17,6,'BUCH-DE-003','B-DE-003',NULL,1,3,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 3 aus dem Klassensatz Deutsch 7.',1,'2026-04-09 10:48:01','2026-05-11 23:19:52'),
(18,6,'BUCH-DE-004','B-DE-004',NULL,1,3,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 4 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:46'),
(19,6,'BUCH-DE-005','B-DE-005',NULL,1,3,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 5 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:46'),
(20,6,'BUCH-DE-006','B-DE-006',NULL,1,3,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 6 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:46'),
(21,6,'BUCH-DE-007','B-DE-007',NULL,1,3,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 7 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:46'),
(22,6,'BUCH-DE-008','B-DE-008',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 8 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:26'),
(23,6,'BUCH-DE-009','B-DE-009',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 9 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:26'),
(24,6,'BUCH-DE-010','B-DE-010',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 10 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:26'),
(25,6,'BUCH-DE-011','B-DE-011',NULL,1,4,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 11 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:46'),
(26,6,'BUCH-DE-012','B-DE-012',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 12 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:46'),
(27,6,'BUCH-DE-013','B-DE-013',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 13 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:46'),
(28,6,'BUCH-DE-014','B-DE-014',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 14 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:46'),
(29,6,'BUCH-DE-015','B-DE-015',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 15 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:46'),
(30,6,'BUCH-DE-016','B-DE-016',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 16 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:02:46'),
(31,6,'BUCH-DE-017','B-DE-017',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 17 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(32,6,'BUCH-DE-018','B-DE-018',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 18 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(33,6,'BUCH-DE-019','B-DE-019',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 19 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(34,6,'BUCH-DE-020','B-DE-020',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 20 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(35,6,'BUCH-DE-021','B-DE-021',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 21 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(36,6,'BUCH-DE-022','B-DE-022',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 22 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(37,6,'BUCH-DE-023','B-DE-023',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 23 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(38,6,'BUCH-DE-024','B-DE-024',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 24 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(39,6,'BUCH-DE-025','B-DE-025',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 25 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(40,6,'BUCH-DE-026','B-DE-026',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 26 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(41,6,'BUCH-DE-027','B-DE-027',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 27 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(42,6,'BUCH-DE-028','B-DE-028',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 28 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(43,6,'BUCH-DE-029','B-DE-029',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 29 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(44,6,'BUCH-DE-030','B-DE-030',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 30 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(45,6,'BUCH-DE-031','B-DE-031',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 31 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:16'),
(46,6,'BUCH-DE-032','B-DE-032',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 32 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:29'),
(47,6,'BUCH-DE-033','B-DE-033',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 33 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:29'),
(48,6,'BUCH-DE-034','B-DE-034',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 34 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:29'),
(49,6,'BUCH-DE-035','B-DE-035',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 35 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:29'),
(50,6,'BUCH-DE-036','B-DE-036',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 36 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 22:03:29'),
(51,6,'BUCH-DE-037','B-DE-037',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 37 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 21:45:32'),
(52,6,'BUCH-DE-038','B-DE-038',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 38 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 21:45:32'),
(53,6,'BUCH-DE-039','B-DE-039',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 39 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 21:45:32'),
(54,6,'BUCH-DE-040','B-DE-040',NULL,1,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 40 aus dem Klassensatz Deutsch 7.',0,'2026-04-09 10:48:01','2026-04-11 21:45:32'),
(79,1,'IPAD-002','G-IPAD-002','SN-IPAD-002',4,5,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-17 23:44:22'),
(80,1,'IPAD-003','G-IPAD-003','SN-IPAD-003',3,2,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-20 21:28:46'),
(81,1,'IPAD-004','G-IPAD-004','SN-IPAD-004',3,2,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-20 21:29:59'),
(82,1,'IPAD-005','G-IPAD-005','SN-IPAD-005',4,5,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-17 09:35:40'),
(83,1,'IPAD-006','G-IPAD-006','SN-IPAD-006',4,5,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-14 10:15:36'),
(84,1,'IPAD-007','G-IPAD-007','SN-IPAD-007',3,3,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-05-15 10:23:23'),
(85,1,'IPAD-008','G-IPAD-008','SN-IPAD-008',3,2,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-05-17 22:55:19'),
(86,1,'IPAD-009','G-IPAD-009','SN-IPAD-009',4,5,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-14 08:24:33'),
(87,1,'IPAD-010','G-IPAD-010','SN-IPAD-010',1,4,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-17 23:43:39'),
(88,1,'IPAD-011','G-IPAD-011','SN-IPAD-011',1,4,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-20 21:40:56'),
(94,16,'BUCH-16-001','B-16-001',NULL,1,2,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-04-09 14:16:01','2026-04-09 14:16:01'),
(95,16,'BUCH-16-002','B-16-002',NULL,1,2,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-04-09 14:16:01','2026-04-09 14:16:01'),
(96,16,'BUCH-16-003','B-16-003',NULL,1,2,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-04-09 14:16:01','2026-04-09 14:16:01'),
(97,16,'BUCH-16-004','B-16-004',NULL,1,2,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-04-09 14:16:01','2026-04-09 14:16:01'),
(98,16,'BUCH-16-005','B-16-005',NULL,1,2,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-04-09 14:16:01','2026-04-09 14:16:01'),
(99,16,'BUCH-16-006','B-16-006',NULL,1,2,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-04-09 14:16:01','2026-04-09 14:16:01'),
(100,16,'BUCH-16-007','B-16-007',NULL,1,2,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-04-09 14:16:01','2026-04-09 14:16:01'),
(101,16,'BUCH-16-008','B-16-008',NULL,1,2,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-04-09 14:16:01','2026-04-09 14:16:01'),
(102,16,'BUCH-16-009','B-16-009',NULL,1,2,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-04-09 14:16:01','2026-04-09 14:16:01'),
(103,16,'BUCH-16-010','B-16-010',NULL,1,2,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-04-09 14:16:01','2026-04-09 14:16:01'),
(104,16,'BUCH-16-011','B-16-011',NULL,1,3,1,'2026-04-09',NULL,NULL,1,'Klasse 09a','Neu',1,'2026-04-09 14:17:39','2026-04-12 10:35:06'),
(105,16,'BUCH-16-012','B-16-012',NULL,3,2,1,'2026-04-09',NULL,NULL,1,'Klasse 09a','Neu',1,'2026-04-09 14:17:39','2026-04-09 14:24:19'),
(106,16,'BUCH-16-013','B-16-013',NULL,3,2,1,'2026-04-09',NULL,NULL,1,'Klasse 09a','Neu',1,'2026-04-09 14:17:39','2026-04-09 14:24:19'),
(107,16,'BUCH-16-014','B-16-014',NULL,3,2,1,'2026-04-09',NULL,NULL,1,'Klasse 09a','Neu',1,'2026-04-09 14:17:39','2026-04-09 14:24:19'),
(108,16,'BUCH-16-015','B-16-015',NULL,1,3,1,'2026-04-09',NULL,NULL,1,'Klasse 09a','Neu',1,'2026-04-09 14:17:39','2026-05-11 23:20:02'),
(109,16,'BUCH-16-016','B-16-016',NULL,4,5,1,'2026-04-09',NULL,NULL,1,'Klasse 09a','Neu',1,'2026-04-09 14:17:39','2026-04-12 10:34:33'),
(110,16,'BUCH-16-017','B-16-017',NULL,1,3,1,'2026-04-09',NULL,NULL,1,'Klasse 09a','Neu',1,'2026-04-09 14:17:39','2026-04-12 10:32:54'),
(111,16,'BUCH-16-018','B-16-018',NULL,1,3,1,'2026-04-09',NULL,NULL,1,'Klasse 09a','Neu',1,'2026-04-09 14:17:39','2026-04-11 18:08:59'),
(112,16,'BUCH-16-019','B-16-019',NULL,1,3,1,'2026-04-09',NULL,NULL,1,'Klasse 09a','Neu',1,'2026-04-09 14:17:39','2026-04-12 10:33:45'),
(113,16,'BUCH-16-020','B-16-020',NULL,1,3,1,'2026-04-09',NULL,NULL,1,'Klasse 09a','Neu',1,'2026-04-09 14:17:39','2026-04-12 10:34:19'),
(114,16,'BUCH-16-021','B-16-021',NULL,1,2,1,NULL,NULL,NULL,1,'Klasse 09b',NULL,1,'2026-04-09 14:23:23','2026-04-09 14:23:23'),
(115,16,'BUCH-16-022','B-16-022',NULL,1,2,1,NULL,NULL,NULL,1,'Klasse 09b',NULL,1,'2026-04-09 14:23:23','2026-04-09 14:23:23'),
(116,16,'BUCH-16-023','B-16-023',NULL,1,2,1,NULL,NULL,NULL,1,'Klasse 09b',NULL,1,'2026-04-09 14:23:23','2026-04-09 14:23:23'),
(117,16,'BUCH-16-024','B-16-024',NULL,1,2,1,NULL,NULL,NULL,1,'Klasse 09b',NULL,1,'2026-04-09 14:23:23','2026-04-09 14:23:23'),
(118,16,'BUCH-16-025','B-16-025',NULL,1,2,1,NULL,NULL,NULL,1,'Klasse 09b',NULL,1,'2026-04-09 14:23:23','2026-04-09 14:23:23'),
(119,16,'BUCH-16-026','B-16-026',NULL,1,2,1,NULL,NULL,NULL,1,'Klasse 09b',NULL,1,'2026-04-09 14:23:23','2026-04-09 14:23:23'),
(120,16,'BUCH-16-027','B-16-027',NULL,1,2,1,NULL,NULL,NULL,1,'Klasse 09b',NULL,1,'2026-04-09 14:23:23','2026-04-09 14:23:23'),
(121,16,'BUCH-16-028','B-16-028',NULL,1,2,1,NULL,NULL,NULL,1,'Klasse 09b',NULL,1,'2026-04-09 14:23:23','2026-04-09 14:23:23'),
(122,16,'BUCH-16-029','B-16-029',NULL,1,2,1,NULL,NULL,NULL,1,'Klasse 09b',NULL,1,'2026-04-09 14:23:23','2026-04-09 14:23:23'),
(123,16,'BUCH-16-030','B-16-030',NULL,1,3,1,NULL,NULL,NULL,1,'Klasse 09b',NULL,1,'2026-04-09 14:23:23','2026-04-17 23:43:06'),
(124,17,'BUCH-17-001','B-17-001',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(125,17,'BUCH-17-002','B-17-002',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(126,17,'BUCH-17-003','B-17-003',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(127,17,'BUCH-17-004','B-17-004',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(128,17,'BUCH-17-005','B-17-005',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(129,17,'BUCH-17-006','B-17-006',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(130,17,'BUCH-17-007','B-17-007',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(131,17,'BUCH-17-008','B-17-008',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(132,17,'BUCH-17-009','B-17-009',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(133,17,'BUCH-17-010','B-17-010',NULL,1,3,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-05-14 18:52:28'),
(134,17,'BUCH-17-011','B-17-011',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(135,17,'BUCH-17-012','B-17-012',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(136,17,'BUCH-17-013','B-17-013',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(137,17,'BUCH-17-014','B-17-014',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(138,17,'BUCH-17-015','B-17-015',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(139,17,'BUCH-17-016','B-17-016',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(140,17,'BUCH-17-017','B-17-017',NULL,1,3,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-18 00:05:26'),
(141,17,'BUCH-17-018','B-17-018',NULL,1,3,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-17 23:57:16'),
(142,17,'BUCH-17-019','B-17-019',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-20 21:29:24'),
(143,17,'BUCH-17-020','B-17-020',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-20 21:29:01'),
(144,17,'BUCH-17-021','B-17-021',NULL,3,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 21 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-18 00:13:45'),
(145,17,'BUCH-17-022','B-17-022',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 22 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(146,17,'BUCH-17-023','B-17-023',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 23 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(147,17,'BUCH-17-024','B-17-024',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 24 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(148,17,'BUCH-17-025','B-17-025',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 25 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(149,17,'BUCH-17-026','B-17-026',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 26 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(150,17,'BUCH-17-027','B-17-027',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 27 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(151,17,'BUCH-17-028','B-17-028',NULL,3,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 28 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-18 00:15:16'),
(152,17,'BUCH-17-029','B-17-029',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 29 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(153,17,'BUCH-17-030','B-17-030',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 30 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(154,17,'BUCH-17-031','B-17-031',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 07b','Exemplar 31 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:08:33','2026-04-09 15:08:33'),
(155,17,'BUCH-17-032','B-17-032',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 07b','Exemplar 32 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:08:33','2026-04-09 15:08:33'),
(156,17,'BUCH-17-033','B-17-033',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 07b','Exemplar 33 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:08:33','2026-04-09 15:08:33'),
(157,17,'BUCH-17-034','B-17-034',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 07b','Exemplar 34 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:08:33','2026-04-09 15:08:33'),
(158,17,'BUCH-17-035','B-17-035',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 07b','Exemplar 35 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:08:33','2026-04-09 15:08:33'),
(159,17,'BUCH-17-036','B-17-036',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 07b','Exemplar 36 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:08:33','2026-04-09 15:08:33'),
(160,18,'BUCH-18-001','B-18-001',NULL,5,5,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 1 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-11 00:34:18'),
(161,18,'BUCH-18-002','B-18-002',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 2 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(162,18,'BUCH-18-003','B-18-003',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 3 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(163,18,'BUCH-18-004','B-18-004',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 4 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(164,18,'BUCH-18-005','B-18-005',NULL,4,5,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 5 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:18:01'),
(165,18,'BUCH-18-006','B-18-006',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 6 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(166,18,'BUCH-18-007','B-18-007',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 7 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(167,18,'BUCH-18-008','B-18-008',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 8 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(168,18,'BUCH-18-009','B-18-009',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 9 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(169,18,'BUCH-18-010','B-18-010',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 10 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(170,18,'BUCH-18-011','B-18-011',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 11 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(171,18,'BUCH-18-012','B-18-012',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 12 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(172,18,'BUCH-18-013','B-18-013',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 13 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(173,18,'BUCH-18-014','B-18-014',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 14 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(174,18,'BUCH-18-015','B-18-015',NULL,1,2,1,'2010-04-01',NULL,NULL,1,'10A','Exemplar 15 aus dem Klassensatz Mittlerer Schulabschluss zentrale Prüfungen 2010.',1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(175,19,'BUCH-19-001','B-19-001',NULL,1,2,1,'2026-04-11',NULL,NULL,0,NULL,NULL,1,'2026-04-11 18:27:08','2026-04-11 18:27:08'),
(176,19,'BUCH-19-002','B-19-002',NULL,3,2,1,'2026-04-06',NULL,NULL,0,NULL,NULL,1,'2026-04-11 19:17:34','2026-04-20 21:31:16'),
(177,2,'PENCIL-002','G-PENCIL-002','SN-PENCIL-002',3,1,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-16 00:02:45','2026-05-16 00:04:09'),
(178,2,'PENCIL-003','G-PENCIL-003','SN-PENCIL-003',3,1,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-16 00:03:48','2026-05-16 00:04:25'),
(179,2,'PENCIL-004','G-PENCIL-004','SN-PENCIL-004',3,1,1,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-16 00:14:00','2026-05-16 00:14:14'),
(180,1,'iPad10-0001','sn','sn',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:17:32','2026-05-16 12:21:15'),
(181,1,'iPad10-0002','SN0000001','SN0000001',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:17:32','2026-05-17 22:45:03'),
(182,1,'iPad10-0003','SN0000002','SN0000002',1,3,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:17:32','2026-05-17 22:46:20'),
(183,1,'iPad10-0004','SN0000003','SN0000003',1,3,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:17:32','2026-05-17 22:46:20'),
(184,1,'iPad10-0005','SN0000004','SN0000004',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:17:32','2026-05-17 22:45:03'),
(185,1,'iPad10-0006','SN0000005','SN0000005',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:17:32','2026-05-17 22:45:03'),
(186,1,'iPad10-0007','SN0000006','SN0000006',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:17:32','2026-05-17 22:45:03'),
(187,1,'iPad10-0008','SN0000007','SN0000007',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:17:32','2026-05-17 22:45:03'),
(188,1,'iPad10-0009','SN0000008','SN0000008',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:17:32','2026-05-17 22:45:03'),
(189,1,'iPad10-0010','SN0000009','SN0000009',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:17:32','2026-05-17 22:45:03'),
(190,2,'apple pencil-0001','ST0000001','ST0000001',1,3,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:43:41','2026-05-17 22:47:35'),
(191,2,'apple pencil-0002','ST0000002','ST0000002',1,3,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:43:41','2026-05-17 22:47:35'),
(192,2,'apple pencil-0003','ST0000003','ST0000003',1,3,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:43:41','2026-05-17 22:47:35'),
(193,2,'apple pencil-0004','ST0000004','ST0000004',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:43:41','2026-05-17 22:46:57'),
(194,2,'apple pencil-0005','ST0000005','ST0000005',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:43:41','2026-05-17 22:46:57'),
(195,2,'apple pencil-0006','ST0000006','ST0000006',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:43:41','2026-05-17 22:46:57'),
(196,2,'apple pencil-0007','ST0000007','ST0000007',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:43:41','2026-05-17 22:46:57'),
(197,2,'apple pencil-0008','ST0000008','ST0000008',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:43:41','2026-05-17 22:46:57'),
(198,2,'apple pencil-0009','ST0000009','ST0000009',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:43:41','2026-05-17 22:46:57'),
(199,4,'Logitech-0001','HUE0000001','HUE0000001',1,3,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:50:38','2026-05-17 22:48:21'),
(200,4,'Logitech-0002','HUE0000002','HUE0000002',1,3,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:50:38','2026-05-17 22:48:21'),
(201,4,'Logitech-0003','HUE0000003','HUE0000003',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:50:38','2026-05-17 22:47:46'),
(202,4,'Logitech-0004','HUE0000004','HUE0000004',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:50:38','2026-05-17 22:47:46'),
(203,4,'Logitech-0005','HUE0000005','HUE0000005',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:50:38','2026-05-17 22:47:46'),
(204,4,'Logitech-0006','HUE0000006','HUE0000006',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:50:38','2026-05-17 22:47:46'),
(205,4,'Logitech-0007','HUE0000007','HUE0000007',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:50:38','2026-05-17 22:47:46'),
(206,4,'Logitech-0008','HUE0000008','HUE0000008',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:50:38','2026-05-17 22:47:46'),
(207,4,'Logitech-0009','HUE0000009','HUE0000009',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,0,'2026-05-16 12:50:38','2026-05-17 22:47:46'),
(208,21,'ip9-0001','ip9-0000001','ip9-0000001',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:56:01'),
(209,21,'ip9-0002','ip9-0000002','ip9-0000002',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:56:01'),
(210,21,'ip9-0003','ip9-0000003','ip9-0000003',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:56:01'),
(211,21,'ip9-0004','ip9-0000004','ip9-0000004',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:56:01'),
(212,21,'ip9-0005','ip9-0000005','ip9-0000005',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(213,21,'ip9-0006','ip9-0000006','ip9-0000006',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(214,21,'ip9-0007','ip9-0000007','ip9-0000007',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(215,21,'ip9-0008','ip9-0000008','ip9-0000008',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(216,21,'ip9-0009','ip9-0000009','ip9-0000009',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(217,21,'ip9-0010','ip9-0000010','ip9-0000010',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(218,21,'ip9-0011','ip9-0000011','ip9-0000011',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(219,21,'ip9-0012','ip9-0000012','ip9-0000012',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(220,21,'ip9-0013','ip9-0000013','ip9-0000013',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(221,21,'ip9-0014','ip9-0000014','ip9-0000014',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(222,21,'ip9-0015','ip9-0000015','ip9-0000015',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(223,21,'ip9-0016','ip9-0000016','ip9-0000016',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(224,21,'ip9-0017','ip9-0000017','ip9-0000017',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(225,21,'ip9-0018','ip9-0000018','ip9-0000018',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(226,21,'ip9-0019','ip9-0000019','ip9-0000019',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(227,21,'ip9-0020','ip9-0000020','ip9-0000020',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(228,21,'ip9-0021','ip9-0000021','ip9-0000021',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(229,21,'ip9-0022','ip9-0000022','ip9-0000022',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(230,21,'ip9-0023','ip9-0000023','ip9-0000023',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(231,21,'ip9-0024','ip9-0000024','ip9-0000024',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(232,21,'ip9-0025','ip9-0000025','ip9-0000025',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(233,21,'ip9-0026','ip9-0000026','ip9-0000026',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(234,21,'ip9-0027','ip9-0000027','ip9-0000027',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(235,21,'ip9-0028','ip9-0000028','ip9-0000028',3,3,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 23:17:58'),
(236,21,'ip9-0029','ip9-0000029','ip9-0000029',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(237,21,'ip9-0030','ip9-0000030','ip9-0000030',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(238,21,'ip9-0031','ip9-0000031','ip9-0000031',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(239,21,'ip9-0032','ip9-0000032','ip9-0000032',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(240,21,'ip9-0033','ip9-0000033','ip9-0000033',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(241,21,'ip9-0034','ip9-0000034','ip9-0000034',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(242,21,'ip9-0035','ip9-0000035','ip9-0000035',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(243,21,'ip9-0036','ip9-0000036','ip9-0000036',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(244,21,'ip9-0037','ip9-0000037','ip9-0000037',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(245,21,'ip9-0038','ip9-0000038','ip9-0000038',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(246,21,'ip9-0039','ip9-0000039','ip9-0000039',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(247,21,'ip9-0040','ip9-0000040','ip9-0000040',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(248,21,'ip9-0041','ip9-0000041','ip9-0000041',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(249,21,'ip9-0042','ip9-0000042','ip9-0000042',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(250,21,'ip9-0043','ip9-0000043','ip9-0000043',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(251,21,'ip9-0044','ip9-0000044','ip9-0000044',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(252,21,'ip9-0045','ip9-0000045','ip9-0000045',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(253,21,'ip9-0046','ip9-0000046','ip9-0000046',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(254,21,'ip9-0047','ip9-0000047','ip9-0000047',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(255,21,'ip9-0048','ip9-0000048','ip9-0000048',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(256,21,'ip9-0049','ip9-0000049','ip9-0000049',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(257,21,'ip9-0050','ip9-0000050','ip9-0000050',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:51:58','2026-05-17 22:51:58'),
(258,4,'logi-0001','Hue00001','Hue00001',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(259,4,'logi-0002','Hue00002','Hue00002',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(260,4,'logi-0003','Hue00003','Hue00003',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(261,4,'logi-0004','Hue00004','Hue00004',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(262,4,'logi-0005','Hue00005','Hue00005',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(263,4,'logi-0006','Hue00006','Hue00006',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(264,4,'logi-0007','Hue00007','Hue00007',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(265,4,'logi-0008','Hue00008','Hue00008',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(266,4,'logi-0009','Hue00009','Hue00009',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(267,4,'logi-0010','Hue00010','Hue00010',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(268,4,'logi-0011','Hue00011','Hue00011',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(269,4,'logi-0012','Hue00012','Hue00012',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(270,4,'logi-0013','Hue00013','Hue00013',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(271,4,'logi-0014','Hue00014','Hue00014',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(272,4,'logi-0015','Hue00015','Hue00015',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(273,4,'logi-0016','Hue00016','Hue00016',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(274,4,'logi-0017','Hue00017','Hue00017',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(275,4,'logi-0018','Hue00018','Hue00018',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(276,4,'logi-0019','Hue00019','Hue00019',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(277,4,'logi-0020','Hue00020','Hue00020',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(278,4,'logi-0021','Hue00021','Hue00021',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(279,4,'logi-0022','Hue00022','Hue00022',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(280,4,'logi-0023','Hue00023','Hue00023',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(281,4,'logi-0024','Hue00024','Hue00024',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(282,4,'logi-0025','Hue00025','Hue00025',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(283,4,'logi-0026','Hue00026','Hue00026',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(284,4,'logi-0027','Hue00027','Hue00027',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(285,4,'logi-0028','Hue00028','Hue00028',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 23:18:13'),
(286,4,'logi-0029','Hue00029','Hue00029',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(287,4,'logi-0030','Hue00030','Hue00030',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(288,4,'logi-0031','Hue00031','Hue00031',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(289,4,'logi-0032','Hue00032','Hue00032',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(290,4,'logi-0033','Hue00033','Hue00033',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(291,4,'logi-0034','Hue00034','Hue00034',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(292,4,'logi-0035','Hue00035','Hue00035',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(293,4,'logi-0036','Hue00036','Hue00036',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(294,4,'logi-0037','Hue00037','Hue00037',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(295,4,'logi-0038','Hue00038','Hue00038',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(296,4,'logi-0039','Hue00039','Hue00039',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(297,4,'logi-0040','Hue00040','Hue00040',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(298,4,'logi-0041','Hue00041','Hue00041',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(299,4,'logi-0042','Hue00042','Hue00042',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(300,4,'logi-0043','Hue00043','Hue00043',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(301,4,'logi-0044','Hue00044','Hue00044',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(302,4,'logi-0045','Hue00045','Hue00045',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(303,4,'logi-0046','Hue00046','Hue00046',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(304,4,'logi-0047','Hue00047','Hue00047',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(305,4,'logi-0048','Hue00048','Hue00048',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(306,4,'logi-0049','Hue00049','Hue00049',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(307,4,'logi-0050','Hue00050','Hue00050',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:52:51','2026-05-17 22:52:51'),
(308,2,'pen-0001','ST000001','ST000001',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(309,2,'pen-0002','ST000002','ST000002',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(310,2,'pen-0003','ST000003','ST000003',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(311,2,'pen-0004','ST000004','ST000004',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(312,2,'pen-0005','ST000005','ST000005',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(313,2,'pen-0006','ST000006','ST000006',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(314,2,'pen-0007','ST000007','ST000007',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(315,2,'pen-0008','ST000008','ST000008',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(316,2,'pen-0009','ST000009','ST000009',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(317,2,'pen-0010','ST000010','ST000010',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(318,2,'pen-0011','ST000011','ST000011',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(319,2,'pen-0012','ST000012','ST000012',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(320,2,'pen-0013','ST000013','ST000013',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(321,2,'pen-0014','ST000014','ST000014',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(322,2,'pen-0015','ST000015','ST000015',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(323,2,'pen-0016','ST000016','ST000016',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(324,2,'pen-0017','ST000017','ST000017',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(325,2,'pen-0018','ST000018','ST000018',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(326,2,'pen-0019','ST000019','ST000019',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(327,2,'pen-0020','ST000020','ST000020',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(328,2,'pen-0021','ST000021','ST000021',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(329,2,'pen-0022','ST000022','ST000022',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(330,2,'pen-0023','ST000023','ST000023',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(331,2,'pen-0024','ST000024','ST000024',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(332,2,'pen-0025','ST000025','ST000025',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(333,2,'pen-0026','ST000026','ST000026',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(334,2,'pen-0027','ST000027','ST000027',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(335,2,'pen-0028','ST000028','ST000028',3,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 23:18:06'),
(336,2,'pen-0029','ST000029','ST000029',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(337,2,'pen-0030','ST000030','ST000030',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(338,2,'pen-0031','ST000031','ST000031',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(339,2,'pen-0032','ST000032','ST000032',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(340,2,'pen-0033','ST000033','ST000033',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(341,2,'pen-0034','ST000034','ST000034',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(342,2,'pen-0035','ST000035','ST000035',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(343,2,'pen-0036','ST000036','ST000036',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(344,2,'pen-0037','ST000037','ST000037',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(345,2,'pen-0038','ST000038','ST000038',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(346,2,'pen-0039','ST000039','ST000039',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(347,2,'pen-0040','ST000040','ST000040',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(348,2,'pen-0041','ST000041','ST000041',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(349,2,'pen-0042','ST000042','ST000042',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(350,2,'pen-0043','ST000043','ST000043',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(351,2,'pen-0044','ST000044','ST000044',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(352,2,'pen-0045','ST000045','ST000045',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(353,2,'pen-0046','ST000046','ST000046',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(354,2,'pen-0047','ST000047','ST000047',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(355,2,'pen-0048','ST000048','ST000048',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(356,2,'pen-0049','ST000049','ST000049',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10'),
(357,2,'pen-0050','ST000050','ST000050',1,2,NULL,NULL,NULL,NULL,0,NULL,NULL,1,'2026-05-17 22:53:10','2026-05-17 22:53:10');
/*!40000 ALTER TABLE `artikel_exemplare` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artikel_kategorie`
--

DROP TABLE IF EXISTS `artikel_kategorie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `artikel_kategorie` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `kategorie` varchar(150) NOT NULL,
  `bemerkung` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_artikel_kategorie_kategorie` (`kategorie`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artikel_kategorie`
--

LOCK TABLES `artikel_kategorie` WRITE;
/*!40000 ALTER TABLE `artikel_kategorie` DISABLE KEYS */;
INSERT INTO `artikel_kategorie` VALUES
(1,'Tablet','Nötig für die Zuordnung zu einem Vertrag'),
(2,'Tablet_Zubehoer','Zubehör, dass mit einem Tablet ausgeliefert wird'),
(3,'Laptop',NULL),
(4,'Laptop_Zubehoer',NULL),
(5,'Buch',NULL),
(6,'Taschenrechner',NULL),
(7,'Hotspot',NULL),
(8,'Netzteil',NULL),
(9,'Stift',NULL),
(10,'Beamer',NULL),
(11,'Tastatur',NULL);
/*!40000 ALTER TABLE `artikel_kategorie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ausleiharten`
--

DROP TABLE IF EXISTS `ausleiharten`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ausleiharten` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(50) NOT NULL,
  `beschreibung` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ausleiharten_bezeichnung` (`bezeichnung`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ausleiharten`
--

LOCK TABLES `ausleiharten` WRITE;
/*!40000 ALTER TABLE `ausleiharten` DISABLE KEYS */;
INSERT INTO `ausleiharten` VALUES
(1,'einzelexemplar','Ein einzelnes physisches Objekt wird ausgeliehen.'),
(2,'klassensatz','Mehrere physische Exemplare koennen als Satz organisiert werden.');
/*!40000 ALTER TABLE `ausleiharten` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ausleihen`
--

DROP TABLE IF EXISTS `ausleihen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ausleihen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `exemplar_id` int(10) unsigned NOT NULL,
  `ausleiher_id` int(10) unsigned NOT NULL,
  `ausgabe_am` datetime NOT NULL DEFAULT current_timestamp(),
  `faellig_am` datetime DEFAULT NULL,
  `rueckgabe_am` datetime DEFAULT NULL,
  `zustand_bei_ausgabe_id` int(10) unsigned NOT NULL,
  `zustand_bei_rueckgabe_id` int(10) unsigned DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'offen',
  `kommentar_ausgabe` text DEFAULT NULL,
  `kommentar_rueckgabe` text DEFAULT NULL,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_ausleihen_exemplar` (`exemplar_id`),
  KEY `idx_ausleihen_ausleiher` (`ausleiher_id`),
  KEY `idx_ausleihen_status` (`status`),
  KEY `idx_ausleihen_faelligkeit` (`faellig_am`),
  KEY `fk_ausleihen_zustand_ausgabe` (`zustand_bei_ausgabe_id`),
  KEY `fk_ausleihen_zustand_rueckgabe` (`zustand_bei_rueckgabe_id`),
  CONSTRAINT `fk_ausleihen_ausleiher` FOREIGN KEY (`ausleiher_id`) REFERENCES `ausleiher` (`id`),
  CONSTRAINT `fk_ausleihen_exemplar` FOREIGN KEY (`exemplar_id`) REFERENCES `artikel_exemplare` (`id`),
  CONSTRAINT `fk_ausleihen_zustand_ausgabe` FOREIGN KEY (`zustand_bei_ausgabe_id`) REFERENCES `zustandskatalog` (`id`),
  CONSTRAINT `fk_ausleihen_zustand_rueckgabe` FOREIGN KEY (`zustand_bei_rueckgabe_id`) REFERENCES `zustandskatalog` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=191 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ausleihen`
--

LOCK TABLES `ausleihen` WRITE;
/*!40000 ALTER TABLE `ausleihen` DISABLE KEYS */;
INSERT INTO `ausleihen` VALUES
(1,1,1,'2026-04-08 08:00:00','2026-04-15 14:00:00','2026-04-08 23:19:23',2,3,'zurueckgegeben','Beispielausleihe fuer den Unterricht.',NULL,'2026-04-08 23:03:26','2026-04-08 23:19:23'),
(2,10,1,'2026-04-08 23:07:59','2026-04-05 23:36:30','2026-04-08 23:19:28',4,3,'zurueckgegeben',NULL,NULL,'2026-04-08 23:07:59','2026-04-08 23:38:21'),
(3,3,2,'2026-04-08 23:13:51','2026-04-05 23:36:30','2026-04-08 23:14:32',3,2,'zurueckgegeben','Bis er ein neues gekauft hat','Keine Meldimg','2026-04-08 23:13:51','2026-04-08 23:38:21'),
(4,7,282,'2026-04-08 23:25:21','2026-04-05 23:36:30','2026-04-09 11:42:50',1,3,'zurueckgegeben',NULL,NULL,'2026-04-08 23:25:21','2026-04-09 11:42:50'),
(5,5,1,'2026-04-08 23:27:04','2026-04-05 23:36:30','2026-04-09 11:38:38',4,3,'zurueckgegeben','Für ABschlussfeier',NULL,'2026-04-08 23:27:04','2026-04-09 11:38:38'),
(6,4,1,'2026-04-08 23:27:23','2026-03-05 23:36:30','2026-04-09 11:38:23',3,3,'zurueckgegeben','Abschlussfeier',NULL,'2026-04-08 23:27:23','2026-04-09 11:38:23'),
(7,9,1,'2026-04-08 23:27:38',NULL,'2026-04-09 11:38:29',3,3,'zurueckgegeben','Abschlussfeier',NULL,'2026-04-08 23:27:38','2026-04-09 11:38:29'),
(8,3,262,'2026-04-08 23:31:26',NULL,NULL,2,NULL,'offen',NULL,NULL,'2026-04-08 23:31:26','2026-04-09 11:41:24'),
(9,6,282,'2026-04-09 10:51:49','2026-04-10 14:00:00','2026-04-09 11:42:52',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 10:51:49','2026-04-09 11:42:52'),
(10,16,282,'2026-04-09 10:51:49','2026-04-10 14:00:00','2026-04-09 11:42:54',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 10:51:49','2026-04-09 11:42:54'),
(11,17,282,'2026-04-09 10:51:49','2026-04-10 14:00:00','2026-04-09 11:42:56',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 10:51:49','2026-04-09 11:42:56'),
(12,18,282,'2026-04-09 10:51:49','2026-04-10 14:00:00','2026-04-09 11:42:58',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 10:51:49','2026-04-09 11:42:58'),
(13,19,1,'2026-04-09 10:54:36','2026-04-23 14:00:00','2026-04-09 11:38:32',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 10:54:36','2026-04-09 11:38:32'),
(14,2,263,'2026-04-09 11:37:17','2026-04-23 14:00:00','2026-04-09 22:06:22',3,3,'zurueckgegeben',NULL,NULL,'2026-04-09 11:37:17','2026-04-09 22:06:22'),
(16,104,284,'2026-04-09 14:24:19','2026-04-10 14:00:00','2026-04-12 10:35:06',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:35:06'),
(17,105,284,'2026-04-09 14:24:19','2026-04-10 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-09 14:24:19','2026-04-09 14:24:19'),
(18,106,284,'2026-04-09 14:24:19','2026-04-10 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-09 14:24:19','2026-04-09 14:24:19'),
(19,107,284,'2026-04-09 14:24:19','2026-04-10 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-09 14:24:19','2026-04-09 14:24:19'),
(20,108,284,'2026-04-09 14:24:19','2026-04-10 14:00:00','2026-05-11 23:20:02',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-05-11 23:20:02'),
(21,109,284,'2026-04-09 14:24:19','2026-04-10 14:00:00','2026-04-12 10:34:33',2,5,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:34:33'),
(22,110,284,'2026-04-09 14:24:19','2026-04-10 14:00:00','2026-04-12 10:32:54',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:32:54'),
(23,111,284,'2026-04-09 14:24:19','2026-04-10 14:00:00','2026-04-12 10:34:25',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:34:25'),
(24,112,284,'2026-04-09 14:24:19','2026-04-10 14:00:00','2026-04-12 10:33:45',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:33:45'),
(25,113,284,'2026-04-09 14:24:19','2026-04-17 14:00:00','2026-04-12 10:34:19',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:34:19'),
(33,124,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(34,125,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(35,126,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(36,127,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(37,128,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(38,129,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(39,130,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(40,131,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(41,132,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(42,133,282,'2026-04-10 21:32:30','2026-04-11 14:00:00','2026-05-14 18:52:28',2,3,'zurueckgegeben',NULL,NULL,'2026-04-10 21:32:30','2026-05-14 18:52:28'),
(43,79,265,'2026-04-11 23:14:41','2026-04-25 23:59:59','2026-04-17 23:44:22',2,5,'zurueckgegeben',NULL,NULL,'2026-04-11 23:14:41','2026-04-17 23:44:22'),
(44,10,261,'2026-04-11 23:21:33','2026-04-25 23:59:59','2026-04-11 23:23:23',3,4,'zurueckgegeben',NULL,NULL,'2026-04-11 23:21:33','2026-04-11 23:23:23'),
(49,82,404,'2026-04-13 22:56:43','2026-04-20 23:59:59','2026-04-17 09:35:40',2,5,'zurueckgegeben','Leihgerät','Display defekt','2026-04-13 22:56:43','2026-04-17 09:35:40'),
(50,83,404,'2026-04-13 22:57:12','2026-04-01 23:59:59','2026-04-14 10:15:36',2,5,'zurueckgegeben','Leihgerät I',NULL,'2026-04-13 22:57:12','2026-04-14 10:15:36'),
(51,2,404,'2026-04-13 22:58:03','2026-04-01 23:59:59','2026-04-17 23:44:54',3,5,'zurueckgegeben','Leihgerät I',NULL,'2026-04-13 22:58:03','2026-04-17 23:44:54'),
(52,87,404,'2026-04-14 08:23:26','2026-04-21 23:59:59','2026-04-17 23:43:39',2,4,'zurueckgegeben',NULL,NULL,'2026-04-14 08:23:26','2026-04-17 23:43:39'),
(53,86,405,'2026-04-14 08:23:58','2026-04-21 23:59:59','2026-04-14 08:24:33',2,5,'zurueckgegeben',NULL,NULL,'2026-04-14 08:23:58','2026-04-14 08:24:33'),
(54,16,404,'2026-04-14 20:13:03','2026-04-28 23:59:00','2026-04-18 00:03:47',3,4,'zurueckgegeben',NULL,NULL,'2026-04-14 20:13:03','2026-04-18 00:03:47'),
(55,123,265,'2026-04-17 23:42:33','2026-04-24 23:59:59','2026-04-17 23:43:06',2,3,'zurueckgegeben',NULL,NULL,'2026-04-17 23:42:33','2026-04-17 23:43:06'),
(56,140,404,'2026-04-17 23:51:38','2026-04-24 23:59:59','2026-04-18 00:05:26',2,3,'zurueckgegeben',NULL,NULL,'2026-04-17 23:51:38','2026-04-18 00:05:26'),
(57,141,404,'2026-04-17 23:56:45','2026-04-24 23:59:59','2026-04-17 23:57:16',2,3,'zurueckgegeben',NULL,NULL,'2026-04-17 23:56:45','2026-04-17 23:57:16'),
(58,144,261,'2026-04-18 00:13:45','2026-04-25 23:59:59',NULL,2,NULL,'offen',NULL,NULL,'2026-04-18 00:13:45','2026-04-18 00:13:45'),
(59,151,404,'2026-04-18 00:15:16','2026-04-25 23:59:59',NULL,2,NULL,'offen',NULL,NULL,'2026-04-18 00:15:16','2026-04-18 00:15:16'),
(60,80,404,'2026-04-20 21:28:46','2026-04-27 23:59:59',NULL,2,NULL,'offen',NULL,NULL,'2026-04-20 21:28:46','2026-04-20 21:28:46'),
(61,143,404,'2026-04-20 21:29:01','2026-04-27 23:59:59',NULL,2,NULL,'offen',NULL,NULL,'2026-04-20 21:29:01','2026-04-20 21:29:01'),
(62,142,404,'2026-04-20 21:29:24','2026-03-30 23:59:59',NULL,2,NULL,'offen',NULL,NULL,'2026-04-20 21:29:24','2026-04-20 21:29:24'),
(63,81,404,'2026-04-20 21:29:59','2026-02-02 23:59:59',NULL,2,NULL,'offen',NULL,NULL,'2026-04-20 21:29:59','2026-04-20 21:29:59'),
(64,4,404,'2026-04-20 21:30:28','2026-02-02 23:59:59',NULL,3,NULL,'offen',NULL,NULL,'2026-04-20 21:30:28','2026-04-20 21:30:28'),
(65,176,265,'2026-04-20 21:31:16','2026-04-27 23:59:59',NULL,2,NULL,'offen',NULL,NULL,'2026-04-20 21:31:16','2026-04-20 21:31:16'),
(68,9,1711,'2026-05-14 22:28:36','2026-05-21 23:59:59',NULL,4,NULL,'offen',NULL,NULL,'2026-05-14 22:28:36','2026-05-14 22:28:36'),
(69,84,1736,'2026-05-15 10:23:23','2026-05-22 23:59:59',NULL,3,NULL,'offen',NULL,NULL,'2026-05-15 10:23:23','2026-05-15 10:23:23'),
(70,2,1736,'2026-05-15 10:28:25','2026-05-22 23:59:59',NULL,1,NULL,'offen',NULL,NULL,'2026-05-15 10:28:25','2026-05-15 10:28:25'),
(71,177,1736,'2026-05-16 00:04:09','2026-05-22 23:59:59',NULL,1,NULL,'offen',NULL,NULL,'2026-05-16 00:04:09','2026-05-16 00:04:09'),
(72,178,1600,'2026-05-16 00:04:25','2026-05-23 23:59:59',NULL,1,NULL,'offen',NULL,NULL,'2026-05-16 00:04:25','2026-05-16 00:04:25'),
(73,1,1600,'2026-05-16 00:04:38','2026-05-23 23:59:59',NULL,3,NULL,'offen',NULL,NULL,'2026-05-16 00:04:38','2026-05-16 00:04:38'),
(74,179,1736,'2026-05-16 00:14:14','2026-05-23 23:59:59',NULL,1,NULL,'offen',NULL,NULL,'2026-05-16 00:14:14','2026-05-16 00:14:14'),
(75,182,1517,'2026-05-16 12:33:07','2026-05-23 23:59:59','2026-05-17 22:45:47',2,3,'zurueckgegeben',NULL,NULL,'2026-05-16 12:33:07','2026-05-17 22:45:47'),
(76,183,1516,'2026-05-16 12:33:35','2026-05-23 23:59:59','2026-05-17 22:46:07',2,3,'zurueckgegeben',NULL,NULL,'2026-05-16 12:33:35','2026-05-17 22:46:07'),
(77,190,1516,'2026-05-16 12:44:07','2026-05-23 23:59:59','2026-05-17 22:47:25',2,3,'zurueckgegeben',NULL,NULL,'2026-05-16 12:44:07','2026-05-17 22:47:25'),
(78,191,1517,'2026-05-16 12:44:28','2026-05-23 23:59:59','2026-05-17 22:47:17',2,3,'zurueckgegeben',NULL,NULL,'2026-05-16 12:44:28','2026-05-17 22:47:17'),
(79,199,1516,'2026-05-16 12:50:56','2026-05-23 23:59:59','2026-05-17 22:48:07',2,3,'zurueckgegeben',NULL,NULL,'2026-05-16 12:50:56','2026-05-17 22:48:07'),
(80,200,1517,'2026-05-16 12:51:14','2026-05-23 23:59:59','2026-05-17 22:48:13',2,3,'zurueckgegeben',NULL,NULL,'2026-05-16 12:51:14','2026-05-17 22:48:13'),
(81,192,404,'2026-05-16 13:40:34','2026-05-23 23:59:59','2026-05-17 22:47:11',2,3,'zurueckgegeben',NULL,NULL,'2026-05-16 13:40:34','2026-05-17 22:47:11'),
(82,85,1515,'2026-05-17 22:55:19','2026-05-24 23:59:59',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 22:55:19','2026-05-17 22:55:19'),
(83,208,1543,'2026-05-17 22:56:01','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 22:56:01'),
(84,209,1544,'2026-05-17 22:56:01','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 22:56:01'),
(85,210,1545,'2026-05-17 22:56:01','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 22:56:01'),
(86,211,1546,'2026-05-17 22:56:01','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 22:56:01'),
(87,212,1547,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(88,213,1548,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(89,214,1549,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(90,215,1550,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(91,216,1551,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(92,217,1552,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(93,218,1553,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(94,219,1554,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(95,220,1555,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(96,221,1556,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(97,222,1557,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(98,223,1558,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(99,224,1559,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(100,225,1560,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(101,226,1561,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(102,227,1562,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(103,228,1563,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(104,229,1564,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(105,230,1565,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(106,231,1566,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(107,232,1567,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(108,233,1568,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(109,234,1569,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(110,235,1570,'2026-05-17 22:56:01','2026-05-24 14:00:00','2026-05-17 23:16:26',2,3,'zurueckgegeben',NULL,NULL,'2026-05-17 22:56:01','2026-05-17 23:16:26'),
(111,212,1547,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(112,213,1548,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(113,214,1549,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(114,215,1550,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(115,216,1551,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(116,217,1552,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(117,218,1553,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(118,219,1554,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(119,220,1555,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(120,221,1556,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(121,222,1557,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(122,223,1558,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(123,224,1559,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(124,225,1560,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(125,226,1561,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(126,227,1562,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(127,228,1563,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(128,229,1564,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(129,230,1565,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(130,231,1566,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(131,232,1567,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(132,233,1568,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(133,234,1569,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(134,235,1570,'2026-05-17 23:17:58','2026-05-24 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-05-17 23:17:58','2026-05-17 23:17:58'),
(135,308,1543,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(136,309,1544,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(137,310,1545,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(138,311,1546,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(139,312,1547,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(140,313,1548,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(141,314,1549,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(142,315,1550,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(143,316,1551,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(144,317,1552,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(145,318,1553,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(146,319,1554,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(147,320,1555,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(148,321,1556,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(149,322,1557,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(150,323,1558,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(151,324,1559,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(152,325,1560,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(153,326,1561,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(154,327,1562,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(155,328,1563,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(156,329,1564,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(157,330,1565,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(158,331,1566,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(159,332,1567,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(160,333,1568,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(161,334,1569,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(162,335,1570,'2026-05-17 23:18:06','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:06','2026-05-17 23:18:06'),
(163,258,1543,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(164,259,1544,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(165,260,1545,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(166,261,1546,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(167,262,1547,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(168,263,1548,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(169,264,1549,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(170,265,1550,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(171,266,1551,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(172,267,1552,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(173,268,1553,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(174,269,1554,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(175,270,1555,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(176,271,1556,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(177,272,1557,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(178,273,1558,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(179,274,1559,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(180,275,1560,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(181,276,1561,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(182,277,1562,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(183,278,1563,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(184,279,1564,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(185,280,1565,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(186,281,1566,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(187,282,1567,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(188,283,1568,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(189,284,1569,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13'),
(190,285,1570,'2026-05-17 23:18:13','2026-05-24 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-05-17 23:18:13','2026-05-17 23:18:13');
/*!40000 ALTER TABLE `ausleihen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ausleiher`
--

DROP TABLE IF EXISTS `ausleiher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `ausleiher` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `ausleiher_typ` varchar(50) NOT NULL,
  `quelle_typ` varchar(30) DEFAULT NULL,
  `quelle_id` int(10) unsigned DEFAULT NULL,
  `klasse_oder_bereich` varchar(100) DEFAULT NULL,
  `barcode` varchar(150) DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_ausleiher_barcode` (`barcode`),
  UNIQUE KEY `uq_ausleiher_quelle` (`quelle_typ`,`quelle_id`),
  KEY `idx_ausleiher_typ` (`ausleiher_typ`),
  KEY `idx_ausleiher_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1768 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ausleiher`
--

LOCK TABLES `ausleiher` WRITE;
/*!40000 ALTER TABLE `ausleiher` DISABLE KEYS */;
INSERT INTO `ausleiher` VALUES
(1,'Frau Becker','lehrkraft',NULL,NULL,'Deutsch','P-LEHR-001',0,'2026-04-08 23:03:26','2026-04-09 11:35:05'),
(2,'Herr Schneider','lehrkraft',NULL,NULL,'IT','P-LEHR-002',0,'2026-04-08 23:03:26','2026-04-09 11:35:05'),
(3,'Max Mustermann','schueler',NULL,NULL,'7a','P-S-001',0,'2026-04-08 23:03:26','2026-04-09 11:35:05'),
(4,'Anna Becker','schueler',NULL,NULL,'7a','P-S-002',0,'2026-04-08 23:03:26','2026-04-09 11:35:05'),
(5,'Klasse 7a','klasse',NULL,NULL,'Jahrgang 7','P-KLASSE-7A',0,'2026-04-08 23:03:26','2026-04-09 11:35:05'),
(261,'Becker, Anna','lehrkraft','lehrkraft',1,'Musik','BCK',1,'2026-04-09 11:33:09','2026-05-13 17:44:53'),
(262,'Schneider, Tobias','lehrkraft','lehrkraft',2,'Mathe','SND',1,'2026-04-09 11:33:09','2026-05-13 17:43:38'),
(263,'Mueller, Sarah','lehrkraft','lehrkraft',3,'Musik','MLR',1,'2026-04-09 11:33:09','2026-05-13 17:43:38'),
(264,'Herr David Koch','lehrkraft','lehrkraft',4,'Biologie','L-KCH-001',0,'2026-04-09 11:33:09','2026-05-13 18:11:46'),
(265,'Frau Julia Wagner','lehrkraft','lehrkraft',5,'Englisch','L-WGN-001',0,'2026-04-09 11:33:09','2026-05-13 18:11:46'),
(266,'Herr Lars Hoffmann','lehrkraft','lehrkraft',6,'Geschichte','L-HFM-001',0,'2026-04-09 11:33:09','2026-05-13 18:11:46'),
(282,'Klasse 07a','klasse','klasse',7,'07','K-07A',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(283,'Klasse 08a','klasse','klasse',8,'','K-08A',0,'2026-04-09 11:33:09','2026-05-14 22:42:22'),
(284,'Klasse 09a','klasse','klasse',9,'','K-09A',0,'2026-04-09 11:33:09','2026-05-14 22:42:22'),
(285,'Klasse 10a','klasse','klasse',10,'10','K-10A',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(286,'Klasse 01b','klasse','klasse',14,'01','K-01B',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(287,'Klasse 02b','klasse','klasse',15,'02','K-02B',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(288,'Klasse 03b','klasse','klasse',16,'03','K-03B',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(289,'Klasse 04b','klasse','klasse',17,'04','K-04B',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(290,'Klasse 05b','klasse','klasse',18,'05','K-05B',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(291,'Klasse 06b','klasse','klasse',19,'06','K-06B',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(292,'Klasse 07b','klasse','klasse',20,'07','K-07B',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(293,'Klasse 08b','klasse','klasse',21,'08','K-08B',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(294,'Klasse 09b','klasse','klasse',22,'09','K-09B',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(295,'Klasse 10b','klasse','klasse',23,'10','K-10B',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(296,'Klasse 01c','klasse','klasse',27,'01','K-01C',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(297,'Klasse 02c','klasse','klasse',28,'02','K-02C',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(298,'Klasse 03c','klasse','klasse',29,'03','K-03C',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(299,'Klasse 04c','klasse','klasse',30,'04','K-04C',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(300,'Klasse 05c','klasse','klasse',31,'05','K-05C',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(301,'Klasse 06c','klasse','klasse',32,'06','K-06C',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(302,'Klasse 07c','klasse','klasse',33,'07','K-07C',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(303,'Klasse 08c','klasse','klasse',34,'08','K-08C',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(304,'Klasse 09c','klasse','klasse',35,'09','K-09C',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(305,'Klasse 10c','klasse','klasse',36,'10','K-10C',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(306,'Klasse 01d','klasse','klasse',40,'01','K-01D',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(307,'Klasse 02d','klasse','klasse',41,'02','K-02D',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(308,'Klasse 03d','klasse','klasse',42,'03','K-03D',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(309,'Klasse 04d','klasse','klasse',43,'04','K-04D',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(310,'Klasse 05d','klasse','klasse',44,'05','K-05D',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(311,'Klasse 06d','klasse','klasse',45,'06','K-06D',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(312,'Klasse 07d','klasse','klasse',46,'07','K-07D',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(313,'Klasse 08d','klasse','klasse',47,'08','K-08D',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(314,'Klasse 09d','klasse','klasse',48,'09','K-09D',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(315,'Klasse 10d','klasse','klasse',49,'10','K-10D',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(316,'Klasse 01e','klasse','klasse',53,'01','K-01E',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(317,'Klasse 02e','klasse','klasse',54,'02','K-02E',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(318,'Klasse 03e','klasse','klasse',55,'03','K-03E',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(319,'Klasse 04e','klasse','klasse',56,'04','K-04E',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(320,'Klasse 05e','klasse','klasse',57,'05','K-05E',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(321,'Klasse 06e','klasse','klasse',58,'06','K-06E',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(322,'Klasse 07e','klasse','klasse',59,'07','K-07E',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(323,'Klasse 08e','klasse','klasse',60,'08','K-08E',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(324,'Klasse 09e','klasse','klasse',61,'09','K-09E',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(325,'Klasse 10e','klasse','klasse',62,'10','K-10E',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(326,'Klasse 01f','klasse','klasse',66,'01','K-01F',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(327,'Klasse 02f','klasse','klasse',67,'02','K-02F',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(328,'Klasse 03f','klasse','klasse',68,'03','K-03F',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(329,'Klasse 04f','klasse','klasse',69,'04','K-04F',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(330,'Klasse 05f','klasse','klasse',70,'05','K-05F',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(331,'Klasse 06f','klasse','klasse',71,'06','K-06F',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(332,'Klasse 07f','klasse','klasse',72,'07','K-07F',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(333,'Klasse 08f','klasse','klasse',73,'08','K-08F',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(334,'Klasse 09f','klasse','klasse',74,'09','K-09F',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(335,'Klasse 10f','klasse','klasse',75,'10','K-10F',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(336,'Klasse 01g','klasse','klasse',79,'01','K-01G',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(337,'Klasse 02g','klasse','klasse',80,'02','K-02G',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(338,'Klasse 03g','klasse','klasse',81,'03','K-03G',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(339,'Klasse 04g','klasse','klasse',82,'04','K-04G',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(340,'Klasse 05g','klasse','klasse',83,'05','K-05G',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(341,'Klasse 06g','klasse','klasse',84,'06','K-06G',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(342,'Klasse 07g','klasse','klasse',85,'07','K-07G',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(343,'Klasse 08g','klasse','klasse',86,'08','K-08G',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(344,'Klasse 09g','klasse','klasse',87,'09','K-09G',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(345,'Klasse 10g','klasse','klasse',88,'10','K-10G',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(346,'Klasse 01h','klasse','klasse',92,'01','K-01H',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(347,'Klasse 02h','klasse','klasse',93,'02','K-02H',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(348,'Klasse 03h','klasse','klasse',94,'03','K-03H',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(349,'Klasse 04h','klasse','klasse',95,'04','K-04H',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(350,'Klasse 05h','klasse','klasse',96,'05','K-05H',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(351,'Klasse 06h','klasse','klasse',97,'06','K-06H',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(352,'Klasse 07h','klasse','klasse',98,'07','K-07H',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(353,'Klasse 08h','klasse','klasse',99,'08','K-08H',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(354,'Klasse 09h','klasse','klasse',100,'09','K-09H',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(355,'Klasse 10h','klasse','klasse',101,'10','K-10H',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(356,'Klasse EF','klasse','klasse',162,'EF','K-EF',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(357,'Klasse Q1','klasse','klasse',163,'Q1','K-Q1',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(358,'Klasse Q2','klasse','klasse',164,'Q2','K-Q2',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(359,'Klasse 11','klasse','klasse',165,'11','K-11',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(360,'Klasse 12','klasse','klasse',166,'12','K-12',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(361,'Klasse 13','klasse','klasse',167,'13','K-13',0,'2026-04-09 11:33:09','2026-05-14 22:25:54'),
(404,'Waedt, Jügen','lehrkraft','lehrkraft',9,'Informatik','L-WAE-002',1,'2026-04-13 22:55:37','2026-05-13 18:11:46'),
(405,'Herr Patrick Hanslick','lehrkraft','lehrkraft',10,NULL,'L-HAN-001',1,'2026-04-13 22:55:37','2026-05-13 18:11:46'),
(424,'Klasse 01a','klasse','klasse',1,'01','K-01A',0,'2026-05-11 23:21:13','2026-05-12 22:39:57'),
(425,'Klasse 02a','klasse','klasse',2,'02','K-02A',0,'2026-05-11 23:21:13','2026-05-14 22:25:54'),
(426,'Klasse 03a','klasse','klasse',3,'03','K-03A',0,'2026-05-11 23:21:13','2026-05-14 22:25:54'),
(427,'Klasse 04a','klasse','klasse',4,'04','K-04A',0,'2026-05-11 23:21:13','2026-05-14 22:25:54'),
(428,'Klasse 05a','klasse','klasse',5,'05','K-05A',0,'2026-05-11 23:21:13','2026-05-14 22:25:54'),
(429,'Klasse 06a','klasse','klasse',6,'06','K-06A',0,'2026-05-11 23:21:13','2026-05-14 22:25:54'),
(450,'Khuga, David','lehrkraft','lehrkraft',1000,'Geisterwissenschaft','L-KHH-001',1,'2026-05-13 18:10:53','2026-05-13 18:10:53'),
(1515,'Beach, Patrick','schueler','schueler',1265,'1a','1613',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1516,'Borchers, Dominik','schueler','schueler',1266,'1a','1633',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1517,'Brocke, Alexander','schueler','schueler',1267,'1a','1645',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1518,'Budde, Jan','schueler','schueler',1268,'1a','1659',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1519,'Burtenbach, Christin','schueler','schueler',1269,'1a','1637',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1520,'Clausdatter, Katharina','schueler','schueler',1270,'1a','1630',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1521,'Einenkel, Florian','schueler','schueler',1271,'1a','1616',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1522,'Fölkersamb, Phillipp','schueler','schueler',1272,'1a','1655',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1523,'Hesse, Klaudia','schueler','schueler',1273,'1a','1651',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1524,'Hilbers, Kathrin, Katrin','schueler','schueler',1274,'1a','1665',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1525,'Hoff, Ute','schueler','schueler',1275,'1a','1636',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1526,'Hofmann, Klaudia','schueler','schueler',1276,'1a','1612',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1527,'Jürgensen, Susanne','schueler','schueler',1277,'1a','1615',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1528,'Knodel, Andreas','schueler','schueler',1278,'1a','1622',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1529,'Köcher, Andreas','schueler','schueler',1279,'1a','1649',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1530,'Kroß, Anne','schueler','schueler',1280,'1a','1639',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1531,'McClendon, Thorsten','schueler','schueler',1281,'1a','1624',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1532,'Mettenheim, Kristian','schueler','schueler',1282,'1a','1638',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1533,'Meyer, Benjamin','schueler','schueler',1283,'1a','1621',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1534,'Rodrian, Ute','schueler','schueler',1284,'1a','1619',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1535,'Saint, Phillipp','schueler','schueler',1285,'1a','1634',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1536,'Söncksen, Anne','schueler','schueler',1286,'1a','1666',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1537,'Stasiak, Monika','schueler','schueler',1287,'1a','1658',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1538,'Stremmel, Sven','schueler','schueler',1288,'1a','1644',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1539,'Valentin, Erik','schueler','schueler',1289,'1a','1627',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1540,'Vanselow, Marie','schueler','schueler',1290,'1a','1641',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1541,'Willmes, Ulrich','schueler','schueler',1291,'1a','1663',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1542,'Würfel, Brigitte','schueler','schueler',1292,'1a','1647',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1543,'Bassewitz, Sven','schueler','schueler',1293,'1b','1653',1,'2026-05-14 22:08:08','2026-05-14 22:27:54'),
(1544,'Behrends, Bernd','schueler','schueler',1294,'1b','1652',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1545,'Berg, Marie','schueler','schueler',1295,'1b','1589',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1546,'Börsting, Stephanie','schueler','schueler',1296,'1b','1667',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1547,'Classe, Jana','schueler','schueler',1297,'1b','1617',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1548,'Deuter, Kathrin, Katrin','schueler','schueler',1298,'1b','1629',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1549,'Gärd, Paul','schueler','schueler',1299,'1b','1618',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1550,'Greifeld, Lena','schueler','schueler',1300,'1b','1623',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1551,'Hasburgen, Ulrike','schueler','schueler',1301,'1b','1662',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1552,'John, Melanie','schueler','schueler',1302,'1b','1587',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1553,'Jonas, Tom','schueler','schueler',1303,'1b','1614',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1554,'Kern, Benjamin','schueler','schueler',1304,'1b','1632',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1555,'Lincke, Daniel','schueler','schueler',1305,'1b','1650',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1556,'Ludwig, Melanie','schueler','schueler',1306,'1b','1628',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1557,'Matschke, Peter','schueler','schueler',1307,'1b','1648',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1558,'Niehaus, Klaus','schueler','schueler',1308,'1b','1640',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1559,'Olsen, Petra','schueler','schueler',1309,'1b','1620',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1560,'Pauly, Daniel','schueler','schueler',1310,'1b','1657',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1561,'Pieper, Marina','schueler','schueler',1311,'1b','1646',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1562,'Ritz, Nicole','schueler','schueler',1312,'1b','1631',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1563,'Rouwertsen, Sandra','schueler','schueler',1313,'1b','1643',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1564,'Sauerbrey, Christian','schueler','schueler',1314,'1b','1660',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1565,'Schram, Vanessa','schueler','schueler',1315,'1b','1656',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1566,'tenHompel, Philipp','schueler','schueler',1316,'1b','1635',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1567,'Thadden, Anna','schueler','schueler',1317,'1b','1661',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1568,'Tschudy, Kathrin, Katrin','schueler','schueler',1318,'1b','1726',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1569,'Willmot, Uta','schueler','schueler',1319,'1b','1654',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1570,'Zickow, Ulrich','schueler','schueler',1320,'1b','1626',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1571,'Bainnin, Nicole','schueler','schueler',1321,'2a','1570',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1572,'Brocke, Marie','schueler','schueler',1322,'2a','1595',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1573,'Cossel, Leon','schueler','schueler',1323,'2a','1562',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1574,'Diedrichsen, Christin','schueler','schueler',1324,'2a','1588',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1575,'Ehden, Angelika','schueler','schueler',1325,'2a','1566',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1576,'Farver, Brigitte','schueler','schueler',1326,'2a','1576',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1577,'Feis, Vanessa','schueler','schueler',1327,'2a','1552',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1578,'Fleischer, Marina','schueler','schueler',1328,'2a','1567',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1579,'Grooßen, Jürgen','schueler','schueler',1329,'2a','1598',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1580,'Haniel, Erik','schueler','schueler',1330,'2a','1575',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1581,'Hardinghaus, Marcel','schueler','schueler',1331,'2a','1500',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1582,'Hinrichs, Kerstin','schueler','schueler',1332,'2a','1563',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1583,'Jürgensen, Heike','schueler','schueler',1333,'2a','1586',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1584,'Keßler, Kristian','schueler','schueler',1334,'2a','1573',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1585,'Kleiminger, Frank','schueler','schueler',1335,'2a','1555',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1586,'Koldum, Lena','schueler','schueler',1336,'2a','1537',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1587,'Krickelbeck, Stephanie','schueler','schueler',1337,'2a','1546',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1588,'Kulow, Anne','schueler','schueler',1338,'2a','1515',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1589,'Lantzing, Matthias','schueler','schueler',1339,'2a','1553',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1590,'Lütkens, Jessica','schueler','schueler',1340,'2a','1511',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1591,'Mandicke, Christian','schueler','schueler',1341,'2a','1582',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1592,'Mertz, Stephan','schueler','schueler',1342,'2a','1596',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1593,'Müller, Nadine','schueler','schueler',1343,'2a','1602',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1594,'Seim, Christine','schueler','schueler',1344,'2a','1601',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1595,'Steffens, Mike','schueler','schueler',1345,'2a','1609',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1596,'Stever, Jennifer','schueler','schueler',1346,'2a','1547',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1597,'Stünckel, Mandy','schueler','schueler',1347,'2a','1560',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1598,'Weihs, Kristian','schueler','schueler',1348,'2a','1534',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1599,'Wubben, Stefanie','schueler','schueler',1349,'2a','1599',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1600,'Albertsen, Stephan','schueler','schueler',1350,'2b','1568',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1601,'Barghusen, Klaudia','schueler','schueler',1351,'2b','1551',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1602,'Berg, Franziska','schueler','schueler',1352,'2b','1502',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1603,'Berque, Karin','schueler','schueler',1353,'2b','1579',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1604,'Blecher, Monika','schueler','schueler',1354,'2b','1580',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1605,'Dettmann, Barbara','schueler','schueler',1355,'2b','1585',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1606,'Ebsen, Sophie','schueler','schueler',1356,'2b','1554',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1607,'Esselborn, Antje','schueler','schueler',1357,'2b','1571',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1608,'Felt, Daniela','schueler','schueler',1358,'2b','1592',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1609,'Friedrichs, René','schueler','schueler',1359,'2b','1594',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1610,'Gardelin, Katharina','schueler','schueler',1360,'2b','1590',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1611,'Haumer, Eric','schueler','schueler',1361,'2b','1548',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1612,'Hubbell, Frank','schueler','schueler',1362,'2b','1583',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1613,'John, Max','schueler','schueler',1363,'2b','1578',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1614,'Jungblut, Tom','schueler','schueler',1364,'2b','1593',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1615,'Kappler, Manuela','schueler','schueler',1365,'2b','1591',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1616,'Kibbel, René','schueler','schueler',1366,'2b','1597',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1617,'Knop, Kerstin','schueler','schueler',1367,'2b','1603',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1618,'Koldum, Thomas','schueler','schueler',1368,'2b','1600',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1619,'Lippmann, Christian','schueler','schueler',1369,'2b','1556',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1620,'Lückels, Uta','schueler','schueler',1370,'2b','1577',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1621,'Nißen, Monika','schueler','schueler',1371,'2b','1569',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1622,'Ramroth, Ute','schueler','schueler',1372,'2b','1565',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1623,'Rohling, Patrick','schueler','schueler',1373,'2b','1572',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1624,'Rollier, Christin','schueler','schueler',1374,'2b','1561',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1625,'Rütting, Claudia','schueler','schueler',1375,'2b','1584',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1626,'Sänger, Sara','schueler','schueler',1376,'2b','1536',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1627,'Wilmes, Benjamin','schueler','schueler',1377,'2b','1581',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1628,'Zuber, Monika','schueler','schueler',1378,'2b','1558',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1629,'Berg, Angelika','schueler','schueler',1379,'3a','1523',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1630,'Bergener, Stefan','schueler','schueler',1380,'3a','1484',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1631,'Canow, Barbara','schueler','schueler',1381,'3a','1482',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1632,'Dalcke, Martin','schueler','schueler',1382,'3a','1669',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1633,'Emonts, Ralph','schueler','schueler',1383,'3a','1505',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1634,'Frohnert, Franziska','schueler','schueler',1384,'3a','1449',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1635,'Gaillard, Monika','schueler','schueler',1385,'3a','1493',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1636,'Gregor, Tom','schueler','schueler',1386,'3a','1520',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1637,'Haack, Christian','schueler','schueler',1387,'3a','1524',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1638,'Hartmann, Doreen','schueler','schueler',1388,'3a','1443',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1639,'Kammerer, Silke','schueler','schueler',1389,'3a','1516',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1640,'Kettemann, Antje','schueler','schueler',1390,'3a','1668',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1641,'Klauß, Melanie','schueler','schueler',1391,'3a','1491',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1642,'Klug, Mandy','schueler','schueler',1392,'3a','1513',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1643,'Koslowska, Marco','schueler','schueler',1393,'3a','1522',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1644,'Kreha, Heike','schueler','schueler',1394,'3a','1483',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1645,'Menne, Sara','schueler','schueler',1395,'3a','1510',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1646,'Möllers, Patrick','schueler','schueler',1396,'3a','1526',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1647,'Prellberg, Bernd','schueler','schueler',1397,'3a','1501',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1648,'Röcher, Christine','schueler','schueler',1398,'3a','1606',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1649,'Salenski, Anke','schueler','schueler',1399,'3a','1529',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1650,'Sauer, Lea','schueler','schueler',1400,'3a','1518',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1651,'Schassen, Silke','schueler','schueler',1401,'3a','1527',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1652,'Schütz, Robert','schueler','schueler',1402,'3a','1490',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1653,'Spiegel, Bernd','schueler','schueler',1403,'3a','1444',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1654,'Suermann, Jürgen','schueler','schueler',1404,'3a','1514',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1655,'Venneker, David','schueler','schueler',1405,'3a','1528',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1656,'Wojcik, Tobias','schueler','schueler',1406,'3a','1417',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1657,'Bockelmann, Eric','schueler','schueler',1407,'3b','1492',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1658,'Brockmann, Jens','schueler','schueler',1408,'3b','1509',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1659,'Bultmann, Anna','schueler','schueler',1409,'3b','1465',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1660,'Connover, David','schueler','schueler',1410,'3b','1503',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1661,'Conradi, Heike','schueler','schueler',1411,'3b','1427',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1662,'Dornseifer, Philipp','schueler','schueler',1412,'3b','1504',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1663,'Goltschmit, Mandy','schueler','schueler',1413,'3b','1531',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1664,'Hase, Antje','schueler','schueler',1414,'3b','1308',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1665,'Heinoff, Maria','schueler','schueler',1415,'3b','1512',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1666,'Heller, Dennis','schueler','schueler',1416,'3b','1494',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1667,'Himmelstierna, Kevin','schueler','schueler',1417,'3b','1487',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1668,'Himmelstützer, Susanne','schueler','schueler',1418,'3b','1485',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1669,'Kimmerlin, Marcel','schueler','schueler',1419,'3b','1533',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1670,'Kirckhoff, Doreen','schueler','schueler',1420,'3b','1530',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1671,'Kusserow, Marco','schueler','schueler',1421,'3b','1472',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1672,'Marteville, Claudia','schueler','schueler',1422,'3b','1506',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1673,'Niemeyer, Stephan','schueler','schueler',1423,'3b','1498',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1674,'Pampe, Nadine','schueler','schueler',1424,'3b','1496',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1675,'Pick, Jens','schueler','schueler',1425,'3b','1481',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1676,'Riggers, Sebastian','schueler','schueler',1426,'3b','1488',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1677,'Schmallenbach, Daniela','schueler','schueler',1427,'3b','1435',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1678,'Schulte-Janning, Gabriele','schueler','schueler',1428,'3b','1497',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1679,'Steingrobe, Franziska','schueler','schueler',1429,'3b','1438',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1680,'Steuber, Ralf','schueler','schueler',1430,'3b','1499',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1681,'Strömer, Mathias','schueler','schueler',1431,'3b','1486',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1682,'Teppel, Frank','schueler','schueler',1432,'3b','1532',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1683,'Wördemann, Stephan','schueler','schueler',1433,'3b','1469',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1684,'Wubben, Antje','schueler','schueler',1434,'3b','1525',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1685,'Wubbens, Sven','schueler','schueler',1435,'3b','1519',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1686,'Beesten, Marina','schueler','schueler',1436,'4a','1544',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1687,'Bengtsson, Kevin','schueler','schueler',1437,'4a','1459',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1688,'Chillot, Ralf','schueler','schueler',1438,'4a','1450',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1689,'Creutzer, Mario','schueler','schueler',1439,'4a','1432',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1690,'d\'Alençon, Kerstin','schueler','schueler',1440,'4a','1430',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1691,'Drewes, Christin','schueler','schueler',1441,'4a','1414',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1692,'Engelmann, Vanessa','schueler','schueler',1442,'4a','1466',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1693,'Farian, Sven','schueler','schueler',1443,'4a','1325',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1694,'Feld, Jessika','schueler','schueler',1444,'4a','1456',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1695,'Freithoff, Ralf','schueler','schueler',1445,'4a','1460',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1696,'Gockel, Uta','schueler','schueler',1446,'4a','1453',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1697,'Grosse-Hündfeld, Kristin','schueler','schueler',1447,'4a','1454',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1698,'Hemphill, Jana','schueler','schueler',1448,'4a','1413',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1699,'Hork, Thorsten','schueler','schueler',1449,'4a','1318',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1700,'Kimmerlin, Maria','schueler','schueler',1450,'4a','1467',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1701,'Kupferschmidt, Claudia','schueler','schueler',1451,'4a','1303',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1702,'Mallory, Sandra','schueler','schueler',1452,'4a','1431',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1703,'Siebert, Christin','schueler','schueler',1453,'4a','1412',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1704,'Thiessen, Thomas','schueler','schueler',1454,'4a','1405',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1705,'Töpler, Jessika','schueler','schueler',1455,'4a','1408',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1706,'Tretow, Andreas','schueler','schueler',1456,'4a','1479',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1707,'Vocke, Anja','schueler','schueler',1457,'4a','1474',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1708,'Wallmeyer, Sophia','schueler','schueler',1458,'4a','1406',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1709,'Westerbrochs, Petra','schueler','schueler',1459,'4a','1448',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1710,'Wölfer, Maximilian','schueler','schueler',1460,'4a','1428',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1711,'Bastian, Kevin','schueler','schueler',1461,'4b','1447',1,'2026-05-14 22:08:08','2026-05-14 22:42:22'),
(1712,'Bernonville, Mandy','schueler','schueler',1462,'4b','1434',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1713,'Brokmeyer, Dirk','schueler','schueler',1463,'4b','1313',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1714,'Deuter, Dirk','schueler','schueler',1464,'4b','1426',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1715,'Feddersen, Sebastian','schueler','schueler',1465,'4b','1442',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1716,'Friedrich, Uta','schueler','schueler',1466,'4b','1400',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1717,'Geizkofler, Antje','schueler','schueler',1467,'4b','1441',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1718,'Gieben, Erik','schueler','schueler',1468,'4b','1419',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1719,'Grünholz, Gabriele','schueler','schueler',1469,'4b','1445',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1720,'Heuer, Karolin','schueler','schueler',1470,'4b','1423',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1721,'Kißler, Petra','schueler','schueler',1471,'4b','1452',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1722,'Krämer, Uwe','schueler','schueler',1472,'4b','1471',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1723,'Lanzing, Birgit','schueler','schueler',1473,'4b','1399',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1724,'Mauw, Tim','schueler','schueler',1474,'4b','1424',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1725,'Merle, Florian','schueler','schueler',1475,'4b','1415',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1726,'Meyerdirks, Christian','schueler','schueler',1476,'4b','1407',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1727,'Nommsen, Sophia','schueler','schueler',1477,'4b','1429',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1728,'Öhelschlegel, Doreen','schueler','schueler',1478,'4b','1468',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1729,'Post, Jens','schueler','schueler',1479,'4b','1508',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1730,'Rösch, Diana','schueler','schueler',1480,'4b','1404',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1731,'Schödl, Katja','schueler','schueler',1481,'4b','1422',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1732,'Sperry, Phillipp','schueler','schueler',1482,'4b','1446',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1733,'Welter, Annett','schueler','schueler',1483,'4b','1436',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1734,'Zoll, Lisa','schueler','schueler',1484,'4b','1421',1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1735,'Belallli, Zakaria','schueler','schueler',1485,'08a','51657',1,'2026-05-14 22:17:54','2026-05-14 22:17:54'),
(1736,'Addily, Sophia','schueler','schueler',1486,'08a','52074',1,'2026-05-14 22:17:54','2026-05-14 22:17:54'),
(1737,'Engels, Pia-Sarina','schueler','schueler',1487,'09a','58332',1,'2026-05-14 22:17:54','2026-05-14 22:17:54'),
(1738,'Glanz, Julian','schueler','schueler',1488,'09a','51292',1,'2026-05-14 22:17:54','2026-05-14 22:17:54'),
(1741,'Klasse 1a','klasse','klasse',176,'','K-1A',1,'2026-05-14 22:25:54','2026-05-14 22:25:54'),
(1742,'Klasse 1b','klasse','klasse',177,'','K-1B',1,'2026-05-14 22:25:54','2026-05-14 22:25:54'),
(1743,'Klasse 2a','klasse','klasse',178,'','K-2A',1,'2026-05-14 22:25:54','2026-05-14 22:25:54'),
(1744,'Klasse 2b','klasse','klasse',179,'','K-2B',1,'2026-05-14 22:25:54','2026-05-14 22:25:54'),
(1745,'Klasse 3a','klasse','klasse',180,'','K-3A',1,'2026-05-14 22:25:54','2026-05-14 22:25:54'),
(1746,'Klasse 3b','klasse','klasse',181,'','K-3B',1,'2026-05-14 22:25:54','2026-05-14 22:25:54'),
(1747,'Klasse 4a','klasse','klasse',182,'','K-4A',1,'2026-05-14 22:25:54','2026-05-14 22:25:54'),
(1748,'Klasse 4b','klasse','klasse',183,'','K-4B',1,'2026-05-14 22:25:54','2026-05-14 22:25:54');
/*!40000 ALTER TABLE `ausleiher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buch_details`
--

DROP TABLE IF EXISTS `buch_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `buch_details` (
  `artikel_id` int(10) unsigned NOT NULL,
  `titelcode` varchar(20) DEFAULT NULL,
  `autor` varchar(255) DEFAULT NULL,
  `verlag` varchar(255) DEFAULT NULL,
  `fach_id` int(10) unsigned DEFAULT NULL,
  `veroeffentlicht` varchar(50) DEFAULT NULL,
  `cover_url` varchar(500) DEFAULT NULL,
  `cover_bild` longtext DEFAULT NULL,
  `jahrgangsstufe` varchar(50) DEFAULT NULL,
  `schuljahr_ausgabe` varchar(20) DEFAULT NULL,
  `ist_arbeitsheft` tinyint(1) NOT NULL DEFAULT 0,
  `ist_lehrerversion` tinyint(1) NOT NULL DEFAULT 0,
  `herkunft_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`artikel_id`),
  UNIQUE KEY `uq_buch_details_titelcode` (`titelcode`),
  KEY `idx_buch_details_jahrgangsstufe` (`jahrgangsstufe`),
  KEY `idx_buch_details_veroeffentlicht` (`veroeffentlicht`),
  KEY `idx_buch_details_fach` (`fach_id`),
  KEY `idx_buch_details_herkunft` (`herkunft_id`),
  CONSTRAINT `fk_buch_details_artikel` FOREIGN KEY (`artikel_id`) REFERENCES `artikel` (`id`),
  CONSTRAINT `fk_buch_details_fach` FOREIGN KEY (`fach_id`) REFERENCES `faecher` (`id`),
  CONSTRAINT `fk_buch_details_herkunft` FOREIGN KEY (`herkunft_id`) REFERENCES `herkunft` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buch_details`
--

LOCK TABLES `buch_details` WRITE;
/*!40000 ALTER TABLE `buch_details` DISABLE KEYS */;
INSERT INTO `buch_details` VALUES
(6,'9783123161011','Katharina Brenner','Westermann',2,NULL,NULL,NULL,'7','2026/27',0,0,NULL),
(7,'9783060400013','Martin Seidel','Cornelsen',1,NULL,NULL,NULL,'7','2026/27',0,0,NULL),
(8,'9783464242011','Helen Brooks','Klett',1,NULL,NULL,NULL,'7','2026/27',0,0,NULL),
(9,'9783141524010','Nina Vogt','Westermann',2,NULL,NULL,NULL,'8','2026/27',0,0,NULL),
(10,'9783124435012','Thomas Berger','Klett',1,NULL,NULL,NULL,'9','2026/27',0,0,NULL),
(16,'9783127419207',NULL,'Klett',1,'April 1, 2000',NULL,NULL,NULL,NULL,0,0,NULL),
(17,'9783060066704','Wolfgang Hecht, Reinhold Koullen, Jeannine Kreuz, Frank Nix, Hans-Helmut Paffen, Günther Reufsteck, Christine Sprehe, Rainer Zillgens','Cornelsen',2,'2013','http://books.google.com/books/content?id=uGVDMAEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api','data:image/jpeg;base64,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',NULL,NULL,0,0,NULL),
(18,'9783061500184','Gabriele Leerhoff, Dietmar Karau, Ricardo John, Evelyn Jasch, Petra Janzing, Andreas Hoffmann, Wolfgang Hecht, Kai Bartschat','Cornelsen',2,'2009','http://books.google.com/books/content?id=-P63PwAACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api','data:image/jpeg;base64,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',NULL,NULL,0,0,NULL),
(19,'9783060066711','Hecht, Wolfgang','Cornelsen',2,'2014','http://books.google.com/books/content?id=a0oPnwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api','data:image/jpeg;base64,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AAAAAAAAAD+AAAA4QklNBA0AAAAAAAQAAAB4OEJJTQQZAAAAAAAEAAAAHjhCSU0D8wAAAAAACQAAAAAAAAAAAQA4QklNJxAAAAAAAAoAAQAAAAAAAAACOEJJTQP1AAAAAABIAC9mZgABAGxmZgAGAAAAAAABAC9mZgABAKGZmgAGAAAAAAABADIAAAABAFoAAAAGAAAAAAABADUAAAABAC0AAAAGAAAAAAABOEJJTQP4AAAAAABwAAD/////////////////////////////A+gAAAAA/////////////////////////////wPoAAAAAP////////////////////////////8D6AAAAAD/////////////////////////////A+gAADhCSU0EAAAAAAAAAgABOEJJTQQCAAAAAAAKAAAAAAAAAAAAADhCSU0EMAAAAAAABQEBAQEBADhCSU0ELQAAAAAABgABAAAAAjhCSU0ECAAAAAAAEAAAAAEAAAJAAAACQAAAAAA4QklNBB4AAAAAAAQAAAAAOEJJTQQaAAAAAANLAAAABgAAAAAAAAAAAAABNAAAAMgAAAALAFUAbgBiAGUAbgBhAG4AbgB0AC0AMgAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAyAAAATQAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAQAAAAAAAG51bGwAAAACAAAABmJvdW5kc09iamMAAAABAAAAAAAAUmN0MQAAAAQAAAAAVG9wIGxvbmcAAAAAAAAAAExlZnRsb25nAAAAAAAAAABCdG9tbG9uZwAAATQAAAAAUmdodGxvbmcAAADIAAAABnNsaWNlc1ZsTHMAAAABT2JqYwAAAAEAAAAAAAVzbGljZQAAABIAAAAHc2xpY2VJRGxvbmcAAAAAAAAAB2dyb3VwSURsb25nAAAAAAAAAAZvcmlnaW5lbnVtAAAADEVTbGljZU9yaWdpbgAAAA1hdXRvR2VuZXJhdGVkAAAAAFR5cGVlbnVtAAAACkVTbGljZVR5cGUAAAAASW1nIAAAAAZib3VuZHNPYmpjAAAAAQAAAAAAAFJjdDEAAAAEAAAAAFRvcCBsb25nAAAAAAAAAABMZWZ0bG9uZwAAAAAAAAAAQnRvbWxvbmcAAAE0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gkuG/wDHG+tsj9Lj8/8Acc/+lUkrVxh//9kAOEJJTQQhAAAAAABVAAAAAQEAAAAPAEEAZABvAGIAZQAgAFAAaABvAHQAbwBzAGgAbwBwAAAAEwBBAGQAbwBiAGUAIABQAGgAbwB0AG8AcwBoAG8AcAAgAEMAUwA0AAAAAQA4QklNBAYAAAAAAAcABgAAAAEBAP/hES1odHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDQuMi4yLWMwNjMgNTMuMzUyNjI0LCAyMDA4LzA3LzMwLTE4OjEyOjE4ICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdEV2dD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlRXZlbnQjIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iIHhtbG5zOnBob3Rvc2hvcD0iaHR0cDovL25zLmFkb2JlLmNvbS9waG90b3Nob3AvMS4wLyIgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iIHhtbG5zOmV4aWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vZXhpZi8xLjAvIiB4bXA6Q3JlYXRvclRvb2w9IkFkb2JlIFBob3Rvc2hvcCBDUzQgV2luZG93cyIgeG1wOk1ldGFkYXRhRGF0ZT0iMjAyNi0wNC0xMVQxODoxNzozMyswMjowMCIgeG1wOk1vZGlmeURhdGU9IjIwMjYtMDQtMTFUMTg6MTc6MzMrMDI6MDAiIHhtcDpDcmVhdGVEYXRlPSIyMDI2LTA0LTExVDE4OjE3OjMzKzAyOjAwIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjZFMDkxN0M3QzEzNUYxMTFBNkJERkY2NTlGRjNCQzJDIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjZEMDkxN0M3QzEzNUYxMTFBNkJERkY2NTlGRjNCQzJDIiB4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ9InhtcC5kaWQ6NkQwOTE3QzdDMTM1RjExMUE2QkRGRjY1OUZGM0JDMkMiIGRjOmZvcm1hdD0iaW1hZ2UvanBlZyIgcGhvdG9zaG9wOkNvbG9yTW9kZT0iMyIgcGhvdG9zaG9wOklDQ1Byb2ZpbGU9InNSR0IgSUVDNjE5NjYtMi4xIiB0aWZmOk9yaWVudGF0aW9uPSIxIiB0aWZmOlhSZXNvbHV0aW9uPSI3MjAwMDAvMTAwMDAiIHRpZmY6WVJlc29sdXRpb249IjcyMDAwMC8xMDAwMCIgdGlmZjpSZXNvbHV0aW9uVW5pdD0iMiIgdGlmZjpOYXRpdmVEaWdlc3Q9IjI1NiwyNTcsMjU4LDI1OSwyNjIsMjc0LDI3NywyODQsNTMwLDUzMSwyODIsMjgzLDI5NiwzMDEsMzE4LDMxOSw1MjksNTMyLDMwNiwyNzAsMjcxLDI3MiwzMDUsMzE1LDMzNDMyO0IzNUFFQjBDQ0RBQjRFQ0FFRDZEQkNGMkUxMTU4MUM4IiBleGlmOlBpeGVsWERpbWVuc2lvbj0iMjAwIiBleGlmOlBpeGVsWURpbWVuc2lvbj0iMzA4IiBleGlmOkNvbG9yU3BhY2U9IjEiIGV4aWY6TmF0aXZlRGlnZXN0PSIzNjg2NCw0MDk2MCw0MDk2MSwzNzEyMSwzNzEyMiw0MDk2Miw0MDk2MywzNzUxMCw0MDk2NCwzNjg2NywzNjg2OCwzMzQzNCwzMzQzNywzNDg1MCwzNDg1MiwzNDg1NSwzNDg1NiwzNzM3NywzNzM3OCwzNzM3OSwzNzM4MCwzNzM4MSwzNzM4MiwzNzM4MywzNzM4NCwzNzM4NSwzNzM4NiwzNzM5Niw0MTQ4Myw0MTQ4NCw0MTQ4Niw0MTQ4Nyw0MTQ4OCw0MTQ5Miw0MTQ5Myw0MTQ5NSw0MTcyOCw0MTcyOSw0MTczMCw0MTk4NSw0MTk4Niw0MTk4Nyw0MTk4OCw0MTk4OSw0MTk5MCw0MTk5MSw0MTk5Miw0MTk5Myw0MTk5NCw0MTk5NSw0MTk5Niw0MjAxNiwwLDIsNCw1LDYsNyw4LDksMTAsMTEsMTIsMTMsMTQsMTUsMTYsMTcsMTgsMjAsMjIsMjMsMjQsMjUsMjYsMjcsMjgsMzA7M0M2NDRFNDE4RUZDRTg3OTUyQTk5NkU0RDNGMDQ1NUEiPiA8eG1wTU06SGlzdG9yeT4gPHJkZjpTZXE+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJjcmVhdGVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjZEMDkxN0M3QzEzNUYxMTFBNkJERkY2NTlGRjNCQzJDIiBzdEV2dDp3aGVuPSIyMDI2LTA0LTExVDE4OjE3OjMzKzAyOjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgQ1M0IFdpbmRvd3MiLz4gPHJkZjpsaSBzdEV2dDphY3Rpb249InNhdmVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjZFMDkxN0M3QzEzNUYxMTFBNkJERkY2NTlGRjNCQzJDIiBzdEV2dDp3aGVuPSIyMDI2LTA0LTExVDE4OjE3OjMzKzAyOjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgQ1M0IFdpbmRvd3MiIHN0RXZ0OmNoYW5nZWQ9Ii8iLz4gPC9yZGY6U2VxPiA8L3htcE1NOkhpc3Rvcnk+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg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','8',NULL,0,0,NULL);
/*!40000 ALTER TABLE `buch_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exemplar_zuordnungen`
--

DROP TABLE IF EXISTS `exemplar_zuordnungen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `exemplar_zuordnungen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `haupt_exemplar_id` int(10) unsigned NOT NULL,
  `neben_exemplar_id` int(10) unsigned NOT NULL,
  `beziehungsart` varchar(50) NOT NULL,
  `beschreibung` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_exemplar_zuordnungen` (`haupt_exemplar_id`,`neben_exemplar_id`,`beziehungsart`),
  KEY `idx_exemplar_zuordnungen_neben` (`neben_exemplar_id`),
  CONSTRAINT `fk_exemplar_zuordnungen_haupt` FOREIGN KEY (`haupt_exemplar_id`) REFERENCES `artikel_exemplare` (`id`),
  CONSTRAINT `fk_exemplar_zuordnungen_neben` FOREIGN KEY (`neben_exemplar_id`) REFERENCES `artikel_exemplare` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exemplar_zuordnungen`
--

LOCK TABLES `exemplar_zuordnungen` WRITE;
/*!40000 ALTER TABLE `exemplar_zuordnungen` DISABLE KEYS */;
INSERT INTO `exemplar_zuordnungen` VALUES
(1,1,2,'zubehoer','Apple Pencil ist dem iPad zugeordnet.'),
(2,1,3,'zubehoer','Netzteil ist dem iPad zugeordnet.'),
(3,1,4,'zubehoer','Tastatur ist dem iPad zugeordnet.');
/*!40000 ALTER TABLE `exemplar_zuordnungen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `faecher`
--

DROP TABLE IF EXISTS `faecher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `faecher` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(100) NOT NULL,
  `kuerzel` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_faecher_bezeichnung` (`bezeichnung`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `faecher`
--

LOCK TABLES `faecher` WRITE;
/*!40000 ALTER TABLE `faecher` DISABLE KEYS */;
INSERT INTO `faecher` VALUES
(1,'Deutsch','DE'),
(2,'Mathematik','MA'),
(3,'Englisch','EN'),
(4,'Biologie','BIO'),
(5,'Geschichte','GE'),
(6,'Physik','PH'),
(7,'Chemie','CH'),
(8,'Geographie','GEO'),
(9,'Sport','SP'),
(10,'Musik','MU'),
(11,'Kunst','KU'),
(12,'Informatik','IT'),
(13,'Ethik','ETH'),
(14,'Religion','REL'),
(15,'Latein','LAT'),
(16,'Franzoesisch','FR'),
(17,'Politik','POL'),
(18,'Wirtschaft','WI');
/*!40000 ALTER TABLE `faecher` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `geraete_details`
--

DROP TABLE IF EXISTS `geraete_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `geraete_details` (
  `artikel_id` int(10) unsigned NOT NULL,
  `geraetekategorie` varchar(100) NOT NULL,
  `modellnummer` varchar(100) DEFAULT NULL,
  `speichergroesse` varchar(50) DEFAULT NULL,
  `betriebssystem` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`artikel_id`),
  KEY `idx_geraete_details_geraetekategorie` (`geraetekategorie`),
  CONSTRAINT `fk_geraete_details_artikel` FOREIGN KEY (`artikel_id`) REFERENCES `artikel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `geraete_details`
--

LOCK TABLES `geraete_details` WRITE;
/*!40000 ALTER TABLE `geraete_details` DISABLE KEYS */;
INSERT INTO `geraete_details` VALUES
(1,'tablet','A2696','64 GB','iPadOS'),
(2,'stift','MUWA3ZM/A',NULL,NULL),
(3,'ladegeraet','A2305',NULL,NULL),
(4,'tastatur','920-009657',NULL,NULL),
(5,'beamer','V11H978040',NULL,NULL),
(6,'iPad-Hülle','Logitech',NULL,NULL),
(21,'tablet','B2696','32 GB','iPadOS');
/*!40000 ALTER TABLE `geraete_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `herkunft`
--

DROP TABLE IF EXISTS `herkunft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `herkunft` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(150) NOT NULL,
  `notiz` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_herkunft_bezeichnung` (`bezeichnung`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `herkunft`
--

LOCK TABLES `herkunft` WRITE;
/*!40000 ALTER TABLE `herkunft` DISABLE KEYS */;
INSERT INTO `herkunft` VALUES
(1,'Kauf','Schule bezahlt'),
(2,'DigitalPakt 2021',NULL),
(3,'Spende',NULL),
(4,'Leasing ABC','Fa. ABC Neuss'),
(5,'Leasing DEF','Fa. DEF Ddorf'),
(6,'Stadt','Stadt bezahlt');
/*!40000 ALTER TABLE `herkunft` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historie_eintraege`
--

DROP TABLE IF EXISTS `historie_eintraege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `historie_eintraege` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezug_typ` varchar(50) NOT NULL,
  `bezug_id` int(10) unsigned DEFAULT NULL,
  `exemplar_id` int(10) unsigned DEFAULT NULL,
  `ausleihe_id` int(10) unsigned DEFAULT NULL,
  `aktion` varchar(50) NOT NULL,
  `titel` varchar(255) NOT NULL,
  `details` text DEFAULT NULL,
  `ausgeloest_von` varchar(150) NOT NULL DEFAULT 'system',
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_historie_erstellt_am` (`erstellt_am`),
  KEY `idx_historie_bezug` (`bezug_typ`,`bezug_id`),
  KEY `idx_historie_exemplar` (`exemplar_id`),
  KEY `idx_historie_ausleihe` (`ausleihe_id`),
  CONSTRAINT `fk_historie_ausleihe` FOREIGN KEY (`ausleihe_id`) REFERENCES `ausleihen` (`id`),
  CONSTRAINT `fk_historie_exemplar` FOREIGN KEY (`exemplar_id`) REFERENCES `artikel_exemplare` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=788 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historie_eintraege`
--

LOCK TABLES `historie_eintraege` WRITE;
/*!40000 ALTER TABLE `historie_eintraege` DISABLE KEYS */;
INSERT INTO `historie_eintraege` VALUES
(443,'ausleihe',68,9,68,'ausgabe','Ausleihe erstellt: BUCH-BIO-001','Biologie 8 wurde an Bastian, Kevin ausgegeben. Faellig am 2026-05-21 23:59:59.','weboberflaeche','2026-05-14 22:28:36'),
(444,'exemplar',9,9,68,'status_aenderung','Status geaendert: BUCH-BIO-001','Biologie 8 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-14 22:28:36'),
(445,'ausleihe',69,84,69,'ausgabe','Ausleihe erstellt: IPAD-007','iPad 10. Generation 64 GB wurde an Addily, Sophia ausgegeben. Faellig am 2026-05-22 23:59:59.','weboberflaeche','2026-05-15 10:23:23'),
(446,'exemplar',84,84,69,'status_aenderung','Status geaendert: IPAD-007','iPad 10. Generation 64 GB wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-15 10:23:23'),
(447,'exemplar',2,2,NULL,'zustandsaenderung','Zustand geaendert: PENCIL-001','Apple Pencil USB-C wurde von beschaedigt auf neu gesetzt.','weboberflaeche','2026-05-15 10:26:13'),
(448,'exemplar',2,2,NULL,'status_aenderung','Status geaendert: PENCIL-001','Apple Pencil USB-C wurde von defekt auf verfuegbar gesetzt.','weboberflaeche','2026-05-15 10:27:10'),
(449,'ausleihe',70,2,70,'ausgabe','Ausleihe erstellt: PENCIL-001','Apple Pencil USB-C wurde an Addily, Sophia ausgegeben. Faellig am 2026-05-22 23:59:59.','weboberflaeche','2026-05-15 10:28:25'),
(450,'exemplar',2,2,70,'status_aenderung','Status geaendert: PENCIL-001','Apple Pencil USB-C wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-15 10:28:25'),
(451,'ausleihe',71,177,71,'ausgabe','Ausleihe erstellt: PENCIL-002','Apple Pencil USB-C wurde an Addily, Sophia ausgegeben. Faellig am 2026-05-22 23:59:59.','weboberflaeche','2026-05-16 00:04:09'),
(452,'exemplar',177,177,71,'status_aenderung','Status geaendert: PENCIL-002','Apple Pencil USB-C wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-16 00:04:09'),
(453,'ausleihe',72,178,72,'ausgabe','Ausleihe erstellt: PENCIL-003','Apple Pencil USB-C wurde an Albertsen, Stephan ausgegeben. Faellig am 2026-05-23 23:59:59.','weboberflaeche','2026-05-16 00:04:25'),
(454,'exemplar',178,178,72,'status_aenderung','Status geaendert: PENCIL-003','Apple Pencil USB-C wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-16 00:04:25'),
(455,'ausleihe',73,1,73,'ausgabe','Ausleihe erstellt: IPAD-001','iPad 10. Generation 64 GB wurde an Albertsen, Stephan ausgegeben. Faellig am 2026-05-23 23:59:59.','weboberflaeche','2026-05-16 00:04:38'),
(456,'exemplar',1,1,73,'status_aenderung','Status geaendert: IPAD-001','iPad 10. Generation 64 GB wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-16 00:04:38'),
(457,'ausleihe',74,179,74,'ausgabe','Ausleihe erstellt: PENCIL-004','Apple Pencil USB-C wurde an Addily, Sophia ausgegeben. Faellig am 2026-05-23 23:59:59.','weboberflaeche','2026-05-16 00:14:14'),
(458,'exemplar',179,179,74,'status_aenderung','Status geaendert: PENCIL-004','Apple Pencil USB-C wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-16 00:14:14'),
(459,'exemplar',180,180,NULL,'geloescht','Exemplar geloescht: iPad10-0001','iPad 10. Generation 64 GB (iPad10-0001) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-16 12:21:15'),
(460,'ausleihe',75,182,75,'ausgabe','Ausleihe erstellt: iPad10-0003','iPad 10. Generation 64 GB wurde an Brocke, Alexander ausgegeben. Faellig am 2026-05-23 23:59:59.','weboberflaeche','2026-05-16 12:33:07'),
(461,'exemplar',182,182,75,'status_aenderung','Status geaendert: iPad10-0003','iPad 10. Generation 64 GB wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-16 12:33:07'),
(462,'ausleihe',76,183,76,'ausgabe','Ausleihe erstellt: iPad10-0004','iPad 10. Generation 64 GB wurde an Borchers, Dominik ausgegeben. Faellig am 2026-05-23 23:59:59.','weboberflaeche','2026-05-16 12:33:35'),
(463,'exemplar',183,183,76,'status_aenderung','Status geaendert: iPad10-0004','iPad 10. Generation 64 GB wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-16 12:33:35'),
(464,'ausleihe',77,190,77,'ausgabe','Ausleihe erstellt: apple pencil-0001','Apple Pencil USB-C wurde an Borchers, Dominik ausgegeben. Faellig am 2026-05-23 23:59:59.','weboberflaeche','2026-05-16 12:44:07'),
(465,'exemplar',190,190,77,'status_aenderung','Status geaendert: apple pencil-0001','Apple Pencil USB-C wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-16 12:44:07'),
(466,'ausleihe',78,191,78,'ausgabe','Ausleihe erstellt: apple pencil-0002','Apple Pencil USB-C wurde an Brocke, Alexander ausgegeben. Faellig am 2026-05-23 23:59:59.','weboberflaeche','2026-05-16 12:44:28'),
(467,'exemplar',191,191,78,'status_aenderung','Status geaendert: apple pencil-0002','Apple Pencil USB-C wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-16 12:44:28'),
(468,'ausleihe',79,199,79,'ausgabe','Ausleihe erstellt: Logitech-0001','Logitech Rugged Keyboard Folio wurde an Borchers, Dominik ausgegeben. Faellig am 2026-05-23 23:59:59.','weboberflaeche','2026-05-16 12:50:56'),
(469,'exemplar',199,199,79,'status_aenderung','Status geaendert: Logitech-0001','Logitech Rugged Keyboard Folio wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-16 12:50:56'),
(470,'ausleihe',80,200,80,'ausgabe','Ausleihe erstellt: Logitech-0002','Logitech Rugged Keyboard Folio wurde an Brocke, Alexander ausgegeben. Faellig am 2026-05-23 23:59:59.','weboberflaeche','2026-05-16 12:51:14'),
(471,'exemplar',200,200,80,'status_aenderung','Status geaendert: Logitech-0002','Logitech Rugged Keyboard Folio wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-16 12:51:14'),
(472,'ausleihe',81,192,81,'ausgabe','Ausleihe erstellt: apple pencil-0003','Apple Pencil USB-C wurde an Waedt, Jügen ausgegeben. Faellig am 2026-05-23 23:59:59.','weboberflaeche','2026-05-16 13:40:34'),
(473,'exemplar',192,192,81,'status_aenderung','Status geaendert: apple pencil-0003','Apple Pencil USB-C wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-16 13:40:34'),
(474,'exemplar',181,181,NULL,'geloescht','Exemplar geloescht: iPad10-0002','iPad 10. Generation 64 GB (iPad10-0002) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:45:03'),
(475,'exemplar',184,184,NULL,'geloescht','Exemplar geloescht: iPad10-0005','iPad 10. Generation 64 GB (iPad10-0005) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:45:03'),
(476,'exemplar',185,185,NULL,'geloescht','Exemplar geloescht: iPad10-0006','iPad 10. Generation 64 GB (iPad10-0006) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:45:03'),
(477,'exemplar',186,186,NULL,'geloescht','Exemplar geloescht: iPad10-0007','iPad 10. Generation 64 GB (iPad10-0007) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:45:03'),
(478,'exemplar',187,187,NULL,'geloescht','Exemplar geloescht: iPad10-0008','iPad 10. Generation 64 GB (iPad10-0008) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:45:03'),
(479,'exemplar',188,188,NULL,'geloescht','Exemplar geloescht: iPad10-0009','iPad 10. Generation 64 GB (iPad10-0009) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:45:03'),
(480,'exemplar',189,189,NULL,'geloescht','Exemplar geloescht: iPad10-0010','iPad 10. Generation 64 GB (iPad10-0010) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:45:03'),
(481,'ausleihe',75,182,75,'rueckgabe','Rueckgabe verbucht: iPad10-0003','iPad 10. Generation 64 GB wurde von Brocke, Alexander zurueckgegeben. Zustand: gut.','weboberflaeche','2026-05-17 22:45:47'),
(482,'exemplar',182,182,75,'status_aenderung','Status geaendert: iPad10-0003','iPad 10. Generation 64 GB wurde auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 22:45:47'),
(483,'exemplar',182,182,75,'zustandsaenderung','Zustand geaendert: iPad10-0003','iPad 10. Generation 64 GB wurde mit Zustand gut verbucht.','weboberflaeche','2026-05-17 22:45:47'),
(484,'ausleihe',76,183,76,'rueckgabe','Rueckgabe verbucht: iPad10-0004','iPad 10. Generation 64 GB wurde von Borchers, Dominik zurueckgegeben. Zustand: gut.','weboberflaeche','2026-05-17 22:46:07'),
(485,'exemplar',183,183,76,'status_aenderung','Status geaendert: iPad10-0004','iPad 10. Generation 64 GB wurde auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 22:46:07'),
(486,'exemplar',183,183,76,'zustandsaenderung','Zustand geaendert: iPad10-0004','iPad 10. Generation 64 GB wurde mit Zustand gut verbucht.','weboberflaeche','2026-05-17 22:46:07'),
(487,'exemplar',182,182,NULL,'geloescht','Exemplar geloescht: iPad10-0003','iPad 10. Generation 64 GB (iPad10-0003) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:46:20'),
(488,'exemplar',183,183,NULL,'geloescht','Exemplar geloescht: iPad10-0004','iPad 10. Generation 64 GB (iPad10-0004) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:46:20'),
(489,'exemplar',193,193,NULL,'geloescht','Exemplar geloescht: apple pencil-0004','Apple Pencil USB-C (apple pencil-0004) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:46:57'),
(490,'exemplar',194,194,NULL,'geloescht','Exemplar geloescht: apple pencil-0005','Apple Pencil USB-C (apple pencil-0005) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:46:57'),
(491,'exemplar',195,195,NULL,'geloescht','Exemplar geloescht: apple pencil-0006','Apple Pencil USB-C (apple pencil-0006) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:46:58'),
(492,'exemplar',196,196,NULL,'geloescht','Exemplar geloescht: apple pencil-0007','Apple Pencil USB-C (apple pencil-0007) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:46:58'),
(493,'exemplar',197,197,NULL,'geloescht','Exemplar geloescht: apple pencil-0008','Apple Pencil USB-C (apple pencil-0008) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:46:58'),
(494,'exemplar',198,198,NULL,'geloescht','Exemplar geloescht: apple pencil-0009','Apple Pencil USB-C (apple pencil-0009) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:46:58'),
(495,'ausleihe',81,192,81,'rueckgabe','Rueckgabe verbucht: apple pencil-0003','Apple Pencil USB-C wurde von Waedt, Jügen zurueckgegeben. Zustand: gut.','weboberflaeche','2026-05-17 22:47:11'),
(496,'exemplar',192,192,81,'status_aenderung','Status geaendert: apple pencil-0003','Apple Pencil USB-C wurde auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 22:47:11'),
(497,'exemplar',192,192,81,'zustandsaenderung','Zustand geaendert: apple pencil-0003','Apple Pencil USB-C wurde mit Zustand gut verbucht.','weboberflaeche','2026-05-17 22:47:11'),
(498,'ausleihe',78,191,78,'rueckgabe','Rueckgabe verbucht: apple pencil-0002','Apple Pencil USB-C wurde von Brocke, Alexander zurueckgegeben. Zustand: gut.','weboberflaeche','2026-05-17 22:47:17'),
(499,'exemplar',191,191,78,'status_aenderung','Status geaendert: apple pencil-0002','Apple Pencil USB-C wurde auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 22:47:17'),
(500,'exemplar',191,191,78,'zustandsaenderung','Zustand geaendert: apple pencil-0002','Apple Pencil USB-C wurde mit Zustand gut verbucht.','weboberflaeche','2026-05-17 22:47:17'),
(501,'ausleihe',77,190,77,'rueckgabe','Rueckgabe verbucht: apple pencil-0001','Apple Pencil USB-C wurde von Borchers, Dominik zurueckgegeben. Zustand: gut.','weboberflaeche','2026-05-17 22:47:25'),
(502,'exemplar',190,190,77,'status_aenderung','Status geaendert: apple pencil-0001','Apple Pencil USB-C wurde auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 22:47:25'),
(503,'exemplar',190,190,77,'zustandsaenderung','Zustand geaendert: apple pencil-0001','Apple Pencil USB-C wurde mit Zustand gut verbucht.','weboberflaeche','2026-05-17 22:47:25'),
(504,'exemplar',190,190,NULL,'geloescht','Exemplar geloescht: apple pencil-0001','Apple Pencil USB-C (apple pencil-0001) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:47:35'),
(505,'exemplar',191,191,NULL,'geloescht','Exemplar geloescht: apple pencil-0002','Apple Pencil USB-C (apple pencil-0002) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:47:35'),
(506,'exemplar',192,192,NULL,'geloescht','Exemplar geloescht: apple pencil-0003','Apple Pencil USB-C (apple pencil-0003) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:47:35'),
(507,'exemplar',201,201,NULL,'geloescht','Exemplar geloescht: Logitech-0003','Logitech Rugged Keyboard Folio (Logitech-0003) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:47:46'),
(508,'exemplar',202,202,NULL,'geloescht','Exemplar geloescht: Logitech-0004','Logitech Rugged Keyboard Folio (Logitech-0004) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:47:46'),
(509,'exemplar',203,203,NULL,'geloescht','Exemplar geloescht: Logitech-0005','Logitech Rugged Keyboard Folio (Logitech-0005) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:47:46'),
(510,'exemplar',204,204,NULL,'geloescht','Exemplar geloescht: Logitech-0006','Logitech Rugged Keyboard Folio (Logitech-0006) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:47:46'),
(511,'exemplar',205,205,NULL,'geloescht','Exemplar geloescht: Logitech-0007','Logitech Rugged Keyboard Folio (Logitech-0007) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:47:46'),
(512,'exemplar',206,206,NULL,'geloescht','Exemplar geloescht: Logitech-0008','Logitech Rugged Keyboard Folio (Logitech-0008) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:47:46'),
(513,'exemplar',207,207,NULL,'geloescht','Exemplar geloescht: Logitech-0009','Logitech Rugged Keyboard Folio (Logitech-0009) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:47:46'),
(514,'ausleihe',79,199,79,'rueckgabe','Rueckgabe verbucht: Logitech-0001','Logitech Rugged Keyboard Folio wurde von Borchers, Dominik zurueckgegeben. Zustand: gut.','weboberflaeche','2026-05-17 22:48:07'),
(515,'exemplar',199,199,79,'status_aenderung','Status geaendert: Logitech-0001','Logitech Rugged Keyboard Folio wurde auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 22:48:07'),
(516,'exemplar',199,199,79,'zustandsaenderung','Zustand geaendert: Logitech-0001','Logitech Rugged Keyboard Folio wurde mit Zustand gut verbucht.','weboberflaeche','2026-05-17 22:48:07'),
(517,'ausleihe',80,200,80,'rueckgabe','Rueckgabe verbucht: Logitech-0002','Logitech Rugged Keyboard Folio wurde von Brocke, Alexander zurueckgegeben. Zustand: gut.','weboberflaeche','2026-05-17 22:48:13'),
(518,'exemplar',200,200,80,'status_aenderung','Status geaendert: Logitech-0002','Logitech Rugged Keyboard Folio wurde auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 22:48:13'),
(519,'exemplar',200,200,80,'zustandsaenderung','Zustand geaendert: Logitech-0002','Logitech Rugged Keyboard Folio wurde mit Zustand gut verbucht.','weboberflaeche','2026-05-17 22:48:13'),
(520,'exemplar',199,199,NULL,'geloescht','Exemplar geloescht: Logitech-0001','Logitech Rugged Keyboard Folio (Logitech-0001) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:48:21'),
(521,'exemplar',200,200,NULL,'geloescht','Exemplar geloescht: Logitech-0002','Logitech Rugged Keyboard Folio (Logitech-0002) wurde aus dem Bestand entfernt.','weboberflaeche','2026-05-17 22:48:21'),
(522,'ausleihe',82,85,82,'ausgabe','Ausleihe erstellt: IPAD-008','iPad 10. Generation 64 GB wurde an Beach, Patrick ausgegeben. Faellig am 2026-05-24 23:59:59.','weboberflaeche','2026-05-17 22:55:19'),
(523,'exemplar',85,85,82,'status_aenderung','Status geaendert: IPAD-008','iPad 10. Generation 64 GB wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:55:19'),
(524,'ausleihe',83,208,83,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0001','iPad 9.Gen 32GB wurde an Bassewitz, Sven ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(525,'exemplar',208,208,83,'status_aenderung','Status geaendert: ip9-0001','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(526,'ausleihe',84,209,84,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0002','iPad 9.Gen 32GB wurde an Behrends, Bernd ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(527,'exemplar',209,209,84,'status_aenderung','Status geaendert: ip9-0002','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(528,'ausleihe',85,210,85,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0003','iPad 9.Gen 32GB wurde an Berg, Marie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(529,'exemplar',210,210,85,'status_aenderung','Status geaendert: ip9-0003','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(530,'ausleihe',86,211,86,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0004','iPad 9.Gen 32GB wurde an Börsting, Stephanie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(531,'exemplar',211,211,86,'status_aenderung','Status geaendert: ip9-0004','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(532,'ausleihe',87,212,87,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0005','iPad 9.Gen 32GB wurde an Classe, Jana ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(533,'exemplar',212,212,87,'status_aenderung','Status geaendert: ip9-0005','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(534,'ausleihe',88,213,88,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0006','iPad 9.Gen 32GB wurde an Deuter, Kathrin, Katrin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(535,'exemplar',213,213,88,'status_aenderung','Status geaendert: ip9-0006','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(536,'ausleihe',89,214,89,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0007','iPad 9.Gen 32GB wurde an Gärd, Paul ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(537,'exemplar',214,214,89,'status_aenderung','Status geaendert: ip9-0007','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(538,'ausleihe',90,215,90,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0008','iPad 9.Gen 32GB wurde an Greifeld, Lena ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(539,'exemplar',215,215,90,'status_aenderung','Status geaendert: ip9-0008','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(540,'ausleihe',91,216,91,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0009','iPad 9.Gen 32GB wurde an Hasburgen, Ulrike ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(541,'exemplar',216,216,91,'status_aenderung','Status geaendert: ip9-0009','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(542,'ausleihe',92,217,92,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0010','iPad 9.Gen 32GB wurde an John, Melanie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(543,'exemplar',217,217,92,'status_aenderung','Status geaendert: ip9-0010','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(544,'ausleihe',93,218,93,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0011','iPad 9.Gen 32GB wurde an Jonas, Tom ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(545,'exemplar',218,218,93,'status_aenderung','Status geaendert: ip9-0011','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(546,'ausleihe',94,219,94,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0012','iPad 9.Gen 32GB wurde an Kern, Benjamin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(547,'exemplar',219,219,94,'status_aenderung','Status geaendert: ip9-0012','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(548,'ausleihe',95,220,95,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0013','iPad 9.Gen 32GB wurde an Lincke, Daniel ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(549,'exemplar',220,220,95,'status_aenderung','Status geaendert: ip9-0013','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(550,'ausleihe',96,221,96,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0014','iPad 9.Gen 32GB wurde an Ludwig, Melanie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(551,'exemplar',221,221,96,'status_aenderung','Status geaendert: ip9-0014','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(552,'ausleihe',97,222,97,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0015','iPad 9.Gen 32GB wurde an Matschke, Peter ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(553,'exemplar',222,222,97,'status_aenderung','Status geaendert: ip9-0015','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(554,'ausleihe',98,223,98,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0016','iPad 9.Gen 32GB wurde an Niehaus, Klaus ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(555,'exemplar',223,223,98,'status_aenderung','Status geaendert: ip9-0016','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(556,'ausleihe',99,224,99,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0017','iPad 9.Gen 32GB wurde an Olsen, Petra ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(557,'exemplar',224,224,99,'status_aenderung','Status geaendert: ip9-0017','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(558,'ausleihe',100,225,100,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0018','iPad 9.Gen 32GB wurde an Pauly, Daniel ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(559,'exemplar',225,225,100,'status_aenderung','Status geaendert: ip9-0018','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(560,'ausleihe',101,226,101,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0019','iPad 9.Gen 32GB wurde an Pieper, Marina ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(561,'exemplar',226,226,101,'status_aenderung','Status geaendert: ip9-0019','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(562,'ausleihe',102,227,102,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0020','iPad 9.Gen 32GB wurde an Ritz, Nicole ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(563,'exemplar',227,227,102,'status_aenderung','Status geaendert: ip9-0020','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(564,'ausleihe',103,228,103,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0021','iPad 9.Gen 32GB wurde an Rouwertsen, Sandra ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(565,'exemplar',228,228,103,'status_aenderung','Status geaendert: ip9-0021','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(566,'ausleihe',104,229,104,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0022','iPad 9.Gen 32GB wurde an Sauerbrey, Christian ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(567,'exemplar',229,229,104,'status_aenderung','Status geaendert: ip9-0022','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(568,'ausleihe',105,230,105,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0023','iPad 9.Gen 32GB wurde an Schram, Vanessa ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(569,'exemplar',230,230,105,'status_aenderung','Status geaendert: ip9-0023','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(570,'ausleihe',106,231,106,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0024','iPad 9.Gen 32GB wurde an tenHompel, Philipp ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(571,'exemplar',231,231,106,'status_aenderung','Status geaendert: ip9-0024','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(572,'ausleihe',107,232,107,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0025','iPad 9.Gen 32GB wurde an Thadden, Anna ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(573,'exemplar',232,232,107,'status_aenderung','Status geaendert: ip9-0025','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(574,'ausleihe',108,233,108,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0026','iPad 9.Gen 32GB wurde an Tschudy, Kathrin, Katrin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(575,'exemplar',233,233,108,'status_aenderung','Status geaendert: ip9-0026','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(576,'ausleihe',109,234,109,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0027','iPad 9.Gen 32GB wurde an Willmot, Uta ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(577,'exemplar',234,234,109,'status_aenderung','Status geaendert: ip9-0027','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(578,'ausleihe',110,235,110,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0028','iPad 9.Gen 32GB wurde an Zickow, Ulrich ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 22:56:01'),
(579,'exemplar',235,235,110,'status_aenderung','Status geaendert: ip9-0028','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 22:56:01'),
(580,'ausleihe',87,212,87,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0005','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(581,'exemplar',212,212,87,'status_aenderung','Status geaendert: ip9-0005','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(582,'ausleihe',88,213,88,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0006','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(583,'exemplar',213,213,88,'status_aenderung','Status geaendert: ip9-0006','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(584,'ausleihe',89,214,89,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0007','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(585,'exemplar',214,214,89,'status_aenderung','Status geaendert: ip9-0007','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(586,'ausleihe',90,215,90,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0008','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(587,'exemplar',215,215,90,'status_aenderung','Status geaendert: ip9-0008','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(588,'ausleihe',91,216,91,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0009','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(589,'exemplar',216,216,91,'status_aenderung','Status geaendert: ip9-0009','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(590,'ausleihe',92,217,92,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0010','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(591,'exemplar',217,217,92,'status_aenderung','Status geaendert: ip9-0010','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(592,'ausleihe',93,218,93,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0011','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(593,'exemplar',218,218,93,'status_aenderung','Status geaendert: ip9-0011','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(594,'ausleihe',94,219,94,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0012','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(595,'exemplar',219,219,94,'status_aenderung','Status geaendert: ip9-0012','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(596,'ausleihe',95,220,95,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0013','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(597,'exemplar',220,220,95,'status_aenderung','Status geaendert: ip9-0013','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(598,'ausleihe',96,221,96,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0014','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(599,'exemplar',221,221,96,'status_aenderung','Status geaendert: ip9-0014','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(600,'ausleihe',97,222,97,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0015','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(601,'exemplar',222,222,97,'status_aenderung','Status geaendert: ip9-0015','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(602,'ausleihe',98,223,98,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0016','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(603,'exemplar',223,223,98,'status_aenderung','Status geaendert: ip9-0016','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(604,'ausleihe',99,224,99,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0017','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(605,'exemplar',224,224,99,'status_aenderung','Status geaendert: ip9-0017','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(606,'ausleihe',100,225,100,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0018','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(607,'exemplar',225,225,100,'status_aenderung','Status geaendert: ip9-0018','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(608,'ausleihe',101,226,101,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0019','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(609,'exemplar',226,226,101,'status_aenderung','Status geaendert: ip9-0019','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(610,'ausleihe',102,227,102,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0020','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(611,'exemplar',227,227,102,'status_aenderung','Status geaendert: ip9-0020','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(612,'ausleihe',103,228,103,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0021','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(613,'exemplar',228,228,103,'status_aenderung','Status geaendert: ip9-0021','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(614,'ausleihe',104,229,104,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0022','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(615,'exemplar',229,229,104,'status_aenderung','Status geaendert: ip9-0022','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(616,'ausleihe',105,230,105,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0023','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(617,'exemplar',230,230,105,'status_aenderung','Status geaendert: ip9-0023','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(618,'ausleihe',106,231,106,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0024','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(619,'exemplar',231,231,106,'status_aenderung','Status geaendert: ip9-0024','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(620,'ausleihe',107,232,107,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0025','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(621,'exemplar',232,232,107,'status_aenderung','Status geaendert: ip9-0025','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(622,'ausleihe',108,233,108,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0026','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(623,'exemplar',233,233,108,'status_aenderung','Status geaendert: ip9-0026','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(624,'ausleihe',109,234,109,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0027','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(625,'exemplar',234,234,109,'status_aenderung','Status geaendert: ip9-0027','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(626,'ausleihe',110,235,110,'storno_assistent_rueckgabe','Storno-Assistent: ip9-0028','iPad 9.Gen 32GB wurde gesammelt zurueckgenommen. Zustand: gut.','weboberflaeche','2026-05-17 23:16:26'),
(627,'exemplar',235,235,110,'status_aenderung','Status geaendert: ip9-0028','iPad 9.Gen 32GB wurde durch den Storno-Assistenten auf verfuegbar gesetzt.','weboberflaeche','2026-05-17 23:16:26'),
(628,'ausleihe',111,212,111,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0005','iPad 9.Gen 32GB wurde an Classe, Jana ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(629,'exemplar',212,212,111,'status_aenderung','Status geaendert: ip9-0005','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(630,'ausleihe',112,213,112,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0006','iPad 9.Gen 32GB wurde an Deuter, Kathrin, Katrin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(631,'exemplar',213,213,112,'status_aenderung','Status geaendert: ip9-0006','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(632,'ausleihe',113,214,113,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0007','iPad 9.Gen 32GB wurde an Gärd, Paul ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(633,'exemplar',214,214,113,'status_aenderung','Status geaendert: ip9-0007','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(634,'ausleihe',114,215,114,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0008','iPad 9.Gen 32GB wurde an Greifeld, Lena ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(635,'exemplar',215,215,114,'status_aenderung','Status geaendert: ip9-0008','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(636,'ausleihe',115,216,115,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0009','iPad 9.Gen 32GB wurde an Hasburgen, Ulrike ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(637,'exemplar',216,216,115,'status_aenderung','Status geaendert: ip9-0009','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(638,'ausleihe',116,217,116,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0010','iPad 9.Gen 32GB wurde an John, Melanie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(639,'exemplar',217,217,116,'status_aenderung','Status geaendert: ip9-0010','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(640,'ausleihe',117,218,117,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0011','iPad 9.Gen 32GB wurde an Jonas, Tom ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(641,'exemplar',218,218,117,'status_aenderung','Status geaendert: ip9-0011','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(642,'ausleihe',118,219,118,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0012','iPad 9.Gen 32GB wurde an Kern, Benjamin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(643,'exemplar',219,219,118,'status_aenderung','Status geaendert: ip9-0012','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(644,'ausleihe',119,220,119,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0013','iPad 9.Gen 32GB wurde an Lincke, Daniel ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(645,'exemplar',220,220,119,'status_aenderung','Status geaendert: ip9-0013','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(646,'ausleihe',120,221,120,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0014','iPad 9.Gen 32GB wurde an Ludwig, Melanie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(647,'exemplar',221,221,120,'status_aenderung','Status geaendert: ip9-0014','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(648,'ausleihe',121,222,121,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0015','iPad 9.Gen 32GB wurde an Matschke, Peter ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(649,'exemplar',222,222,121,'status_aenderung','Status geaendert: ip9-0015','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(650,'ausleihe',122,223,122,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0016','iPad 9.Gen 32GB wurde an Niehaus, Klaus ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(651,'exemplar',223,223,122,'status_aenderung','Status geaendert: ip9-0016','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(652,'ausleihe',123,224,123,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0017','iPad 9.Gen 32GB wurde an Olsen, Petra ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(653,'exemplar',224,224,123,'status_aenderung','Status geaendert: ip9-0017','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(654,'ausleihe',124,225,124,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0018','iPad 9.Gen 32GB wurde an Pauly, Daniel ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(655,'exemplar',225,225,124,'status_aenderung','Status geaendert: ip9-0018','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(656,'ausleihe',125,226,125,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0019','iPad 9.Gen 32GB wurde an Pieper, Marina ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(657,'exemplar',226,226,125,'status_aenderung','Status geaendert: ip9-0019','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(658,'ausleihe',126,227,126,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0020','iPad 9.Gen 32GB wurde an Ritz, Nicole ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(659,'exemplar',227,227,126,'status_aenderung','Status geaendert: ip9-0020','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(660,'ausleihe',127,228,127,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0021','iPad 9.Gen 32GB wurde an Rouwertsen, Sandra ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(661,'exemplar',228,228,127,'status_aenderung','Status geaendert: ip9-0021','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(662,'ausleihe',128,229,128,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0022','iPad 9.Gen 32GB wurde an Sauerbrey, Christian ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(663,'exemplar',229,229,128,'status_aenderung','Status geaendert: ip9-0022','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(664,'ausleihe',129,230,129,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0023','iPad 9.Gen 32GB wurde an Schram, Vanessa ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(665,'exemplar',230,230,129,'status_aenderung','Status geaendert: ip9-0023','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(666,'ausleihe',130,231,130,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0024','iPad 9.Gen 32GB wurde an tenHompel, Philipp ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(667,'exemplar',231,231,130,'status_aenderung','Status geaendert: ip9-0024','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(668,'ausleihe',131,232,131,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0025','iPad 9.Gen 32GB wurde an Thadden, Anna ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(669,'exemplar',232,232,131,'status_aenderung','Status geaendert: ip9-0025','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(670,'ausleihe',132,233,132,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0026','iPad 9.Gen 32GB wurde an Tschudy, Kathrin, Katrin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(671,'exemplar',233,233,132,'status_aenderung','Status geaendert: ip9-0026','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(672,'ausleihe',133,234,133,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0027','iPad 9.Gen 32GB wurde an Willmot, Uta ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(673,'exemplar',234,234,133,'status_aenderung','Status geaendert: ip9-0027','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(674,'ausleihe',134,235,134,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: ip9-0028','iPad 9.Gen 32GB wurde an Zickow, Ulrich ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:17:58'),
(675,'exemplar',235,235,134,'status_aenderung','Status geaendert: ip9-0028','iPad 9.Gen 32GB wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:17:58'),
(676,'ausleihe',135,308,135,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0001','Apple Pencil USB-C wurde an Bassewitz, Sven ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(677,'exemplar',308,308,135,'status_aenderung','Status geaendert: pen-0001','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(678,'ausleihe',136,309,136,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0002','Apple Pencil USB-C wurde an Behrends, Bernd ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(679,'exemplar',309,309,136,'status_aenderung','Status geaendert: pen-0002','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(680,'ausleihe',137,310,137,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0003','Apple Pencil USB-C wurde an Berg, Marie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(681,'exemplar',310,310,137,'status_aenderung','Status geaendert: pen-0003','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(682,'ausleihe',138,311,138,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0004','Apple Pencil USB-C wurde an Börsting, Stephanie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(683,'exemplar',311,311,138,'status_aenderung','Status geaendert: pen-0004','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(684,'ausleihe',139,312,139,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0005','Apple Pencil USB-C wurde an Classe, Jana ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(685,'exemplar',312,312,139,'status_aenderung','Status geaendert: pen-0005','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(686,'ausleihe',140,313,140,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0006','Apple Pencil USB-C wurde an Deuter, Kathrin, Katrin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(687,'exemplar',313,313,140,'status_aenderung','Status geaendert: pen-0006','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(688,'ausleihe',141,314,141,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0007','Apple Pencil USB-C wurde an Gärd, Paul ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(689,'exemplar',314,314,141,'status_aenderung','Status geaendert: pen-0007','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(690,'ausleihe',142,315,142,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0008','Apple Pencil USB-C wurde an Greifeld, Lena ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(691,'exemplar',315,315,142,'status_aenderung','Status geaendert: pen-0008','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(692,'ausleihe',143,316,143,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0009','Apple Pencil USB-C wurde an Hasburgen, Ulrike ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(693,'exemplar',316,316,143,'status_aenderung','Status geaendert: pen-0009','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(694,'ausleihe',144,317,144,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0010','Apple Pencil USB-C wurde an John, Melanie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(695,'exemplar',317,317,144,'status_aenderung','Status geaendert: pen-0010','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(696,'ausleihe',145,318,145,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0011','Apple Pencil USB-C wurde an Jonas, Tom ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(697,'exemplar',318,318,145,'status_aenderung','Status geaendert: pen-0011','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(698,'ausleihe',146,319,146,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0012','Apple Pencil USB-C wurde an Kern, Benjamin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(699,'exemplar',319,319,146,'status_aenderung','Status geaendert: pen-0012','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(700,'ausleihe',147,320,147,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0013','Apple Pencil USB-C wurde an Lincke, Daniel ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(701,'exemplar',320,320,147,'status_aenderung','Status geaendert: pen-0013','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(702,'ausleihe',148,321,148,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0014','Apple Pencil USB-C wurde an Ludwig, Melanie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(703,'exemplar',321,321,148,'status_aenderung','Status geaendert: pen-0014','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(704,'ausleihe',149,322,149,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0015','Apple Pencil USB-C wurde an Matschke, Peter ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(705,'exemplar',322,322,149,'status_aenderung','Status geaendert: pen-0015','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(706,'ausleihe',150,323,150,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0016','Apple Pencil USB-C wurde an Niehaus, Klaus ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(707,'exemplar',323,323,150,'status_aenderung','Status geaendert: pen-0016','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(708,'ausleihe',151,324,151,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0017','Apple Pencil USB-C wurde an Olsen, Petra ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(709,'exemplar',324,324,151,'status_aenderung','Status geaendert: pen-0017','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(710,'ausleihe',152,325,152,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0018','Apple Pencil USB-C wurde an Pauly, Daniel ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(711,'exemplar',325,325,152,'status_aenderung','Status geaendert: pen-0018','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(712,'ausleihe',153,326,153,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0019','Apple Pencil USB-C wurde an Pieper, Marina ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(713,'exemplar',326,326,153,'status_aenderung','Status geaendert: pen-0019','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(714,'ausleihe',154,327,154,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0020','Apple Pencil USB-C wurde an Ritz, Nicole ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(715,'exemplar',327,327,154,'status_aenderung','Status geaendert: pen-0020','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(716,'ausleihe',155,328,155,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0021','Apple Pencil USB-C wurde an Rouwertsen, Sandra ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(717,'exemplar',328,328,155,'status_aenderung','Status geaendert: pen-0021','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(718,'ausleihe',156,329,156,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0022','Apple Pencil USB-C wurde an Sauerbrey, Christian ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(719,'exemplar',329,329,156,'status_aenderung','Status geaendert: pen-0022','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(720,'ausleihe',157,330,157,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0023','Apple Pencil USB-C wurde an Schram, Vanessa ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(721,'exemplar',330,330,157,'status_aenderung','Status geaendert: pen-0023','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(722,'ausleihe',158,331,158,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0024','Apple Pencil USB-C wurde an tenHompel, Philipp ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(723,'exemplar',331,331,158,'status_aenderung','Status geaendert: pen-0024','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(724,'ausleihe',159,332,159,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0025','Apple Pencil USB-C wurde an Thadden, Anna ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(725,'exemplar',332,332,159,'status_aenderung','Status geaendert: pen-0025','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(726,'ausleihe',160,333,160,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0026','Apple Pencil USB-C wurde an Tschudy, Kathrin, Katrin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(727,'exemplar',333,333,160,'status_aenderung','Status geaendert: pen-0026','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(728,'ausleihe',161,334,161,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0027','Apple Pencil USB-C wurde an Willmot, Uta ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(729,'exemplar',334,334,161,'status_aenderung','Status geaendert: pen-0027','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(730,'ausleihe',162,335,162,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: pen-0028','Apple Pencil USB-C wurde an Zickow, Ulrich ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:06'),
(731,'exemplar',335,335,162,'status_aenderung','Status geaendert: pen-0028','Apple Pencil USB-C wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:06'),
(732,'ausleihe',163,258,163,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0001','Logitech Rugged Keyboard Folio wurde an Bassewitz, Sven ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(733,'exemplar',258,258,163,'status_aenderung','Status geaendert: logi-0001','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(734,'ausleihe',164,259,164,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0002','Logitech Rugged Keyboard Folio wurde an Behrends, Bernd ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(735,'exemplar',259,259,164,'status_aenderung','Status geaendert: logi-0002','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(736,'ausleihe',165,260,165,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0003','Logitech Rugged Keyboard Folio wurde an Berg, Marie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(737,'exemplar',260,260,165,'status_aenderung','Status geaendert: logi-0003','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(738,'ausleihe',166,261,166,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0004','Logitech Rugged Keyboard Folio wurde an Börsting, Stephanie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(739,'exemplar',261,261,166,'status_aenderung','Status geaendert: logi-0004','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(740,'ausleihe',167,262,167,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0005','Logitech Rugged Keyboard Folio wurde an Classe, Jana ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(741,'exemplar',262,262,167,'status_aenderung','Status geaendert: logi-0005','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(742,'ausleihe',168,263,168,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0006','Logitech Rugged Keyboard Folio wurde an Deuter, Kathrin, Katrin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(743,'exemplar',263,263,168,'status_aenderung','Status geaendert: logi-0006','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(744,'ausleihe',169,264,169,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0007','Logitech Rugged Keyboard Folio wurde an Gärd, Paul ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(745,'exemplar',264,264,169,'status_aenderung','Status geaendert: logi-0007','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(746,'ausleihe',170,265,170,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0008','Logitech Rugged Keyboard Folio wurde an Greifeld, Lena ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(747,'exemplar',265,265,170,'status_aenderung','Status geaendert: logi-0008','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(748,'ausleihe',171,266,171,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0009','Logitech Rugged Keyboard Folio wurde an Hasburgen, Ulrike ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(749,'exemplar',266,266,171,'status_aenderung','Status geaendert: logi-0009','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(750,'ausleihe',172,267,172,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0010','Logitech Rugged Keyboard Folio wurde an John, Melanie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(751,'exemplar',267,267,172,'status_aenderung','Status geaendert: logi-0010','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(752,'ausleihe',173,268,173,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0011','Logitech Rugged Keyboard Folio wurde an Jonas, Tom ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(753,'exemplar',268,268,173,'status_aenderung','Status geaendert: logi-0011','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(754,'ausleihe',174,269,174,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0012','Logitech Rugged Keyboard Folio wurde an Kern, Benjamin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(755,'exemplar',269,269,174,'status_aenderung','Status geaendert: logi-0012','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(756,'ausleihe',175,270,175,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0013','Logitech Rugged Keyboard Folio wurde an Lincke, Daniel ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(757,'exemplar',270,270,175,'status_aenderung','Status geaendert: logi-0013','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(758,'ausleihe',176,271,176,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0014','Logitech Rugged Keyboard Folio wurde an Ludwig, Melanie ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(759,'exemplar',271,271,176,'status_aenderung','Status geaendert: logi-0014','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(760,'ausleihe',177,272,177,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0015','Logitech Rugged Keyboard Folio wurde an Matschke, Peter ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(761,'exemplar',272,272,177,'status_aenderung','Status geaendert: logi-0015','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(762,'ausleihe',178,273,178,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0016','Logitech Rugged Keyboard Folio wurde an Niehaus, Klaus ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(763,'exemplar',273,273,178,'status_aenderung','Status geaendert: logi-0016','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(764,'ausleihe',179,274,179,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0017','Logitech Rugged Keyboard Folio wurde an Olsen, Petra ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(765,'exemplar',274,274,179,'status_aenderung','Status geaendert: logi-0017','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(766,'ausleihe',180,275,180,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0018','Logitech Rugged Keyboard Folio wurde an Pauly, Daniel ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(767,'exemplar',275,275,180,'status_aenderung','Status geaendert: logi-0018','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(768,'ausleihe',181,276,181,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0019','Logitech Rugged Keyboard Folio wurde an Pieper, Marina ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(769,'exemplar',276,276,181,'status_aenderung','Status geaendert: logi-0019','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(770,'ausleihe',182,277,182,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0020','Logitech Rugged Keyboard Folio wurde an Ritz, Nicole ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(771,'exemplar',277,277,182,'status_aenderung','Status geaendert: logi-0020','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(772,'ausleihe',183,278,183,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0021','Logitech Rugged Keyboard Folio wurde an Rouwertsen, Sandra ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(773,'exemplar',278,278,183,'status_aenderung','Status geaendert: logi-0021','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(774,'ausleihe',184,279,184,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0022','Logitech Rugged Keyboard Folio wurde an Sauerbrey, Christian ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(775,'exemplar',279,279,184,'status_aenderung','Status geaendert: logi-0022','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(776,'ausleihe',185,280,185,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0023','Logitech Rugged Keyboard Folio wurde an Schram, Vanessa ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(777,'exemplar',280,280,185,'status_aenderung','Status geaendert: logi-0023','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(778,'ausleihe',186,281,186,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0024','Logitech Rugged Keyboard Folio wurde an tenHompel, Philipp ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(779,'exemplar',281,281,186,'status_aenderung','Status geaendert: logi-0024','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(780,'ausleihe',187,282,187,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0025','Logitech Rugged Keyboard Folio wurde an Thadden, Anna ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(781,'exemplar',282,282,187,'status_aenderung','Status geaendert: logi-0025','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(782,'ausleihe',188,283,188,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0026','Logitech Rugged Keyboard Folio wurde an Tschudy, Kathrin, Katrin ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(783,'exemplar',283,283,188,'status_aenderung','Status geaendert: logi-0026','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(784,'ausleihe',189,284,189,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0027','Logitech Rugged Keyboard Folio wurde an Willmot, Uta ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(785,'exemplar',284,284,189,'status_aenderung','Status geaendert: logi-0027','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13'),
(786,'ausleihe',190,285,190,'ausgabe_assistent_ausgabe','Ausgabe-Assistent: logi-0028','Logitech Rugged Keyboard Folio wurde an Zickow, Ulrich ausgegeben. Faellig am 2026-05-24 14:00:00.','weboberflaeche','2026-05-17 23:18:13'),
(787,'exemplar',285,285,190,'status_aenderung','Status geaendert: logi-0028','Logitech Rugged Keyboard Folio wurde durch den Ausgabe-Assistenten auf ausgeliehen gesetzt.','weboberflaeche','2026-05-17 23:18:13');
/*!40000 ALTER TABLE `historie_eintraege` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventar_typen`
--

DROP TABLE IF EXISTS `inventar_typen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventar_typen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(50) NOT NULL,
  `beschreibung` varchar(255) DEFAULT NULL,
  `ausleihart_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_inventar_typen_bezeichnung` (`bezeichnung`),
  KEY `idx_inventar_typen_ausleihart` (`ausleihart_id`),
  CONSTRAINT `fk_inventar_typen_ausleihart` FOREIGN KEY (`ausleihart_id`) REFERENCES `ausleiharten` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventar_typen`
--

LOCK TABLES `inventar_typen` WRITE;
/*!40000 ALTER TABLE `inventar_typen` DISABLE KEYS */;
INSERT INTO `inventar_typen` VALUES
(1,'buch','Ausleihbare Buecher und Buch-Exemplare.',2),
(2,'tablet','Tablets wie iPads.',1),
(3,'stift','Digitale Stifte wie Apple Pencil.',1),
(4,'ladegeraet','Netzteile und Ladegeraete.',1),
(5,'tastatur','Tastaturen fuer mobile Geraete.',1),
(6,'beamer','Beamer und Projektionsgeraete.',1),
(7,'tablet_zubehoer',NULL,1),
(8,'laptop',NULL,1),
(9,'laptop_zubehoer',NULL,1),
(10,'taschenrechner',NULL,1),
(11,'hotspot',NULL,1),
(12,'netzteil',NULL,1);
/*!40000 ALTER TABLE `inventar_typen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `klassen`
--

DROP TABLE IF EXISTS `klassen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `klassen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(10) NOT NULL,
  `stufe` varchar(10) NOT NULL,
  `parallelklasse` char(1) DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_klassen_bezeichnung` (`bezeichnung`),
  KEY `idx_klassen_stufe` (`stufe`)
) ENGINE=InnoDB AUTO_INCREMENT=186 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `klassen`
--

LOCK TABLES `klassen` WRITE;
/*!40000 ALTER TABLE `klassen` DISABLE KEYS */;
INSERT INTO `klassen` VALUES
(176,'1a','','',1,'2026-05-14 19:30:21','2026-05-14 19:30:21'),
(177,'1b','','',1,'2026-05-14 19:30:21','2026-05-14 19:30:21'),
(178,'2a','','',1,'2026-05-14 19:30:21','2026-05-14 19:30:21'),
(179,'2b','','',1,'2026-05-14 19:30:21','2026-05-14 19:30:21'),
(180,'3a','','',1,'2026-05-14 19:30:21','2026-05-14 19:30:21'),
(181,'3b','','',1,'2026-05-14 19:30:21','2026-05-14 19:30:21'),
(182,'4a','','',1,'2026-05-14 19:30:21','2026-05-14 19:30:21'),
(183,'4b','','',1,'2026-05-14 19:30:21','2026-05-14 19:30:21'),
(184,'08a','','',1,'2026-05-14 22:07:14','2026-05-14 22:07:14'),
(185,'09a','','',1,'2026-05-14 22:07:14','2026-05-14 22:07:14');
/*!40000 ALTER TABLE `klassen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lehrkraefte`
--

DROP TABLE IF EXISTS `lehrkraefte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `lehrkraefte` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `kuerzel` varchar(20) DEFAULT NULL,
  `anrede` varchar(30) DEFAULT NULL,
  `vorname` varchar(100) NOT NULL,
  `nachname` varchar(100) NOT NULL,
  `anzeigename` varchar(220) NOT NULL,
  `barcode` varchar(150) DEFAULT NULL,
  `email` varchar(190) DEFAULT NULL,
  `fachbereich` varchar(120) DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `notizen` text DEFAULT NULL,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_lehrkraefte_kuerzel` (`kuerzel`),
  UNIQUE KEY `uq_lehrkraefte_barcode` (`barcode`),
  KEY `idx_lehrkraefte_name` (`nachname`,`vorname`),
  KEY `idx_lehrkraefte_anzeigename` (`anzeigename`),
  KEY `idx_lehrkraefte_fachbereich` (`fachbereich`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lehrkraefte`
--

LOCK TABLES `lehrkraefte` WRITE;
/*!40000 ALTER TABLE `lehrkraefte` DISABLE KEYS */;
INSERT INTO `lehrkraefte` VALUES
(1,'BCK','Frau','Anna','Becker','Becker, Anna','BCK','anna@becker.de','Musik',1,'Beispiel-Lehrkraft fuer Deutsch.','2026-04-09 11:27:18','2026-05-13 17:44:53'),
(2,'SND','Herr','Tobias','Schneider','Schneider, Tobias','SND','Tobi@schneider.de','Mathe',1,'Beispiel-Lehrkraft fuer IT und Medien.','2026-04-09 11:27:18','2026-05-13 17:43:38'),
(3,'MLR','Frau','Sarah','Mueller','Mueller, Sarah','MLR','Sarah@mueller.de','Musik',1,'Beispiel-Lehrkraft fuer Mathematik.','2026-04-09 11:27:18','2026-05-13 17:58:11'),
(9,'WAE','Herr','Jügen','Waedt','Waedt, Jügen','L-WAE-002','juergen@waedt.de','Informatik',1,NULL,'2026-05-12 22:48:55','2026-05-13 18:11:46'),
(10,'HAN','Herr','Patrick','Hanslick','Herr Patrick Hanslick','L-HAN-001',NULL,NULL,1,NULL,'2026-05-12 22:49:46','2026-05-12 22:50:05'),
(1000,'KHH','Herr','David','Khuga','Khuga, David','L-KHH-001','davi@khuga.com','Geisterwissenschaft',1,NULL,'2026-05-13 18:10:53','2026-05-13 18:10:53');
/*!40000 ALTER TABLE `lehrkraefte` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leihvertraege`
--

DROP TABLE IF EXISTS `leihvertraege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `leihvertraege` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ausleiher_id` int(10) unsigned NOT NULL,
  `ausleiher_typ` varchar(50) NOT NULL,
  `erzeugungsdatum` datetime NOT NULL DEFAULT current_timestamp(),
  `vertragstyp` varchar(50) NOT NULL,
  `pdf_pfad` varchar(500) NOT NULL,
  `vorlagen_version` int(11) NOT NULL,
  `v_vorlage_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_leihvertraege_ausleiher` (`ausleiher_id`,`erzeugungsdatum`),
  KEY `idx_leihvertraege_typ` (`vertragstyp`),
  KEY `idx_leihvertraege_vorlage` (`v_vorlage_id`),
  CONSTRAINT `fk_leihvertraege_ausleiher` FOREIGN KEY (`ausleiher_id`) REFERENCES `ausleiher` (`id`),
  CONSTRAINT `fk_leihvertraege_vorlage` FOREIGN KEY (`v_vorlage_id`) REFERENCES `vertrags_vorlagen` (`v_vorlage_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leihvertraege`
--

LOCK TABLES `leihvertraege` WRITE;
/*!40000 ALTER TABLE `leihvertraege` DISABLE KEYS */;
INSERT INTO `leihvertraege` VALUES
(35,1736,'schueler','2026-05-16 01:13:57','tablet','backend/storage/leihvertraege/2026/20260516_011357_08a_Addily_Sophia_Tablet.pdf',2,4),
(36,1600,'schueler','2026-05-16 01:13:59','tablet','backend/storage/leihvertraege/2026/20260516_011359_2b_Albertsen_Stephan_Tablet.pdf',2,4),
(37,1516,'schueler','2026-05-16 12:51:43','tablet','backend/storage/leihvertraege/2026/20260516_125143_1a_Borchers_Dominik_Tablet.pdf',2,4),
(38,1516,'schueler','2026-05-16 13:27:35','tablet','backend/storage/leihvertraege/2026/20260516_132735_1a_Borchers_Dominik_Tablet.pdf',2,4),
(39,1516,'schueler','2026-05-16 13:28:59','tablet','backend/storage/leihvertraege/2026/20260516_132859_1a_Borchers_Dominik_Tablet.pdf',2,4),
(40,1516,'schueler','2026-05-16 13:33:37','tablet','backend/storage/leihvertraege/2026/20260516_133337_1a_Borchers_Dominik_Tablet.pdf',2,4),
(41,1516,'schueler','2026-05-16 13:42:24','tablet','backend/storage/leihvertraege/2026/20260516_134224_1a_Borchers_Dominik_Tablet.pdf',2,4),
(42,1516,'schueler','2026-05-16 13:44:16','tablet','backend/storage/leihvertraege/2026/20260516_134416_1a_Borchers_Dominik_Tablet.pdf',2,4),
(43,1516,'schueler','2026-05-16 13:45:00','tablet','backend/storage/leihvertraege/2026/20260516_134500_1a_Borchers_Dominik_Tablet.pdf',2,4),
(44,1516,'schueler','2026-05-16 13:45:49','tablet','backend/storage/leihvertraege/2026/20260516_134549_1a_Borchers_Dominik_Tablet.pdf',2,4),
(45,1516,'schueler','2026-05-16 13:47:39','tablet','backend/storage/leihvertraege/2026/20260516_134739_1a_Borchers_Dominik_Tablet.pdf',2,4),
(46,1516,'schueler','2026-05-16 13:48:44','tablet','backend/storage/leihvertraege/2026/20260516_134844_1a_Borchers_Dominik_Tablet.pdf',2,4),
(47,1516,'schueler','2026-05-16 13:49:58','tablet','backend/storage/leihvertraege/2026/20260516_134958_1a_Borchers_Dominik_Tablet.pdf',2,4),
(48,1516,'schueler','2026-05-16 13:50:39','tablet','backend/storage/leihvertraege/2026/20260516_135039_1a_Borchers_Dominik_Tablet.pdf',2,4),
(49,1516,'schueler','2026-05-16 13:52:09','tablet','backend/storage/leihvertraege/2026/20260516_135209_1a_Borchers_Dominik_Tablet.pdf',2,4),
(50,1516,'schueler','2026-05-16 13:52:54','tablet','backend/storage/leihvertraege/2026/20260516_135254_1a_Borchers_Dominik_Tablet.pdf',2,4),
(51,1516,'schueler','2026-05-16 13:55:09','tablet','backend/storage/leihvertraege/2026/20260516_135509_1a_Borchers_Dominik_Tablet.pdf',2,4),
(52,1516,'schueler','2026-05-16 13:55:47','tablet','backend/storage/leihvertraege/2026/20260516_135547_1a_Borchers_Dominik_Tablet.pdf',2,4),
(53,1516,'schueler','2026-05-16 14:08:39','tablet','backend/storage/leihvertraege/2026/20260516_140839_1a_Borchers_Dominik_Tablet.pdf',2,4),
(54,1516,'schueler','2026-05-16 14:10:05','tablet','backend/storage/leihvertraege/2026/20260516_141005_1a_Borchers_Dominik_Tablet.pdf',2,4);
/*!40000 ALTER TABLE `leihvertraege` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leihvertraege_positionen`
--

DROP TABLE IF EXISTS `leihvertraege_positionen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `leihvertraege_positionen` (
  `leihvertrag_id` int(10) unsigned NOT NULL,
  `artikel_exemplar_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`leihvertrag_id`,`artikel_exemplar_id`),
  KEY `idx_leihvertraege_positionen_exemplar` (`artikel_exemplar_id`),
  CONSTRAINT `fk_leihvertraege_positionen_exemplar` FOREIGN KEY (`artikel_exemplar_id`) REFERENCES `artikel_exemplare` (`id`),
  CONSTRAINT `fk_leihvertraege_positionen_vertrag` FOREIGN KEY (`leihvertrag_id`) REFERENCES `leihvertraege` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leihvertraege_positionen`
--

LOCK TABLES `leihvertraege_positionen` WRITE;
/*!40000 ALTER TABLE `leihvertraege_positionen` DISABLE KEYS */;
INSERT INTO `leihvertraege_positionen` VALUES
(36,1),
(35,2),
(35,84),
(35,177),
(36,178),
(35,179),
(37,183),
(38,183),
(39,183),
(40,183),
(41,183),
(42,183),
(43,183),
(44,183),
(45,183),
(46,183),
(47,183),
(48,183),
(49,183),
(50,183),
(51,183),
(52,183),
(53,183),
(54,183),
(37,190),
(38,190),
(39,190),
(40,190),
(41,190),
(42,190),
(43,190),
(44,190),
(45,190),
(46,190),
(47,190),
(48,190),
(49,190),
(50,190),
(51,190),
(52,190),
(53,190),
(54,190),
(37,199),
(38,199),
(39,199),
(40,199),
(41,199),
(42,199),
(43,199),
(44,199),
(45,199),
(46,199),
(47,199),
(48,199),
(49,199),
(50,199),
(51,199),
(52,199),
(53,199),
(54,199);
/*!40000 ALTER TABLE `leihvertraege_positionen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reparaturen`
--

DROP TABLE IF EXISTS `reparaturen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `reparaturen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `schadensmeldung_id` int(10) unsigned NOT NULL,
  `exemplar_id` int(10) unsigned NOT NULL,
  `gestartet_am` datetime NOT NULL DEFAULT current_timestamp(),
  `abgeschlossen_am` datetime DEFAULT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'offen',
  `dienstleister` varchar(150) DEFAULT NULL,
  `beschreibung` text NOT NULL,
  `kosten` decimal(10,2) DEFAULT NULL,
  `abschluss_notiz` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_reparaturen_schaden` (`schadensmeldung_id`),
  KEY `idx_reparaturen_exemplar` (`exemplar_id`),
  KEY `idx_reparaturen_status` (`status`),
  CONSTRAINT `fk_reparaturen_exemplar` FOREIGN KEY (`exemplar_id`) REFERENCES `artikel_exemplare` (`id`),
  CONSTRAINT `fk_reparaturen_schadensmeldung` FOREIGN KEY (`schadensmeldung_id`) REFERENCES `schadensmeldungen` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reparaturen`
--

LOCK TABLES `reparaturen` WRITE;
/*!40000 ALTER TABLE `reparaturen` DISABLE KEYS */;
INSERT INTO `reparaturen` VALUES
(1,2,21,'2026-04-11 18:06:47','2026-04-11 18:06:56','abgeschlossen','Buch.de','Wird repariert',NULL,'Reparatur in der Arbeitsoberflaeche abgeschlossen.'),
(2,1,111,'2026-04-11 18:07:53','2026-04-11 18:08:59','abgeschlossen','BUch.de','Reparatur dauert 2 Wochen',10.00,'Reparatur in der Arbeitsoberflaeche abgeschlossen.');
/*!40000 ALTER TABLE `reparaturen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schadensmeldungen`
--

DROP TABLE IF EXISTS `schadensmeldungen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `schadensmeldungen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `exemplar_id` int(10) unsigned NOT NULL,
  `ausleihe_id` int(10) unsigned DEFAULT NULL,
  `gemeldet_von_ausleiher_id` int(10) unsigned DEFAULT NULL,
  `gemeldet_am` datetime NOT NULL DEFAULT current_timestamp(),
  `titel` varchar(255) NOT NULL,
  `beschreibung` text NOT NULL,
  `schadensgrad` varchar(30) NOT NULL DEFAULT 'mittel',
  `status` varchar(30) NOT NULL DEFAULT 'offen',
  `geloest_am` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_schadensmeldungen_exemplar` (`exemplar_id`),
  KEY `idx_schadensmeldungen_ausleihe` (`ausleihe_id`),
  KEY `idx_schadensmeldungen_ausleiher` (`gemeldet_von_ausleiher_id`),
  KEY `idx_schadensmeldungen_status` (`status`),
  CONSTRAINT `fk_schadensmeldungen_ausleihe` FOREIGN KEY (`ausleihe_id`) REFERENCES `ausleihen` (`id`),
  CONSTRAINT `fk_schadensmeldungen_ausleiher` FOREIGN KEY (`gemeldet_von_ausleiher_id`) REFERENCES `ausleiher` (`id`),
  CONSTRAINT `fk_schadensmeldungen_exemplar` FOREIGN KEY (`exemplar_id`) REFERENCES `artikel_exemplare` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schadensmeldungen`
--

LOCK TABLES `schadensmeldungen` WRITE;
/*!40000 ALTER TABLE `schadensmeldungen` DISABLE KEYS */;
INSERT INTO `schadensmeldungen` VALUES
(1,111,23,261,'2026-04-09 15:20:21','Cover defekt','Cover defekt, wird neu verllebt','hoch','behoben','2026-04-11 18:08:59'),
(2,21,20,264,'2026-04-11 18:05:55','Wasserschaden auf Deckblatt','grnau','mittel','behoben','2026-04-11 18:06:56');
/*!40000 ALTER TABLE `schadensmeldungen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schueler`
--

DROP TABLE IF EXISTS `schueler`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `schueler` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `S_ID` int(11) DEFAULT NULL,
  `vorname` varchar(100) NOT NULL,
  `nachname` varchar(100) NOT NULL,
  `anzeigename` varchar(220) NOT NULL,
  `barcode` varchar(150) DEFAULT NULL,
  `email` varchar(190) DEFAULT NULL,
  `geburtsdatum` date DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `notizen` text DEFAULT NULL,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_schueler_barcode` (`barcode`),
  UNIQUE KEY `uq_schueler_email` (`email`),
  KEY `idx_schueler_name` (`nachname`,`vorname`),
  KEY `idx_schueler_anzeigename` (`anzeigename`)
) ENGINE=InnoDB AUTO_INCREMENT=1489 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schueler`
--

LOCK TABLES `schueler` WRITE;
/*!40000 ALTER TABLE `schueler` DISABLE KEYS */;
INSERT INTO `schueler` VALUES
(1265,1613,'Patrick','Beach','Beach, Patrick','1613','patrick.beach@example.test','2019-09-20',1,NULL,'2026-05-14 22:08:07','2026-05-14 22:08:16'),
(1266,1633,'Dominik','Borchers','Borchers, Dominik','1633','dominik.borchers@example.test','2018-12-20',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1267,1645,'Alexander','Brocke','Brocke, Alexander','1645','alexander.brocke@example.test','2019-07-03',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1268,1659,'Jan','Budde','Budde, Jan','1659','jan.budde@example.test','2019-09-27',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1269,1637,'Christin','Burtenbach','Burtenbach, Christin','1637','christin.burtenbach@example.test','2019-09-21',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1270,1630,'Katharina','Clausdatter','Clausdatter, Katharina','1630','katharina.clausdatter@example.test','2019-11-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1271,1616,'Florian','Einenkel','Einenkel, Florian','1616','florian.einenkel@example.test','2019-10-01',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1272,1655,'Phillipp','Fölkersamb','Fölkersamb, Phillipp','1655','phillipp.fölkersamb@example.test','2019-07-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1273,1651,'Klaudia','Hesse','Hesse, Klaudia','1651','klaudia.hesse@example.test','2019-12-11',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1274,1665,'Kathrin, Katrin','Hilbers','Hilbers, Kathrin, Katrin','1665','kathrin,.katrin.hilbers@example.test','2019-01-20',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1275,1636,'Ute','Hoff','Hoff, Ute','1636','ute.hoff@example.test','2019-01-24',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1276,1612,'Klaudia','Hofmann','Hofmann, Klaudia','1612','klaudia.hofmann@example.test','2019-11-27',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1277,1615,'Susanne','Jürgensen','Jürgensen, Susanne','1615','susanne.jürgensen@example.test','2019-06-20',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1278,1622,'Andreas','Knodel','Knodel, Andreas','1622','andreas.knodel@example.test','2019-07-31',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1279,1649,'Andreas','Köcher','Köcher, Andreas','1649','andreas.köcher@example.test','2019-09-13',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1280,1639,'Anne','Kroß','Kroß, Anne','1639','anne.kroß@example.test','2019-04-09',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1281,1624,'Thorsten','McClendon','McClendon, Thorsten','1624','thorsten.mcclendon@example.test','2019-05-18',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1282,1638,'Kristian','Mettenheim','Mettenheim, Kristian','1638','kristian.mettenheim@example.test','2019-02-05',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1283,1621,'Benjamin','Meyer','Meyer, Benjamin','1621','benjamin.meyer@example.test','2019-09-14',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1284,1619,'Ute','Rodrian','Rodrian, Ute','1619','ute.rodrian@example.test','2019-01-20',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1285,1634,'Phillipp','Saint','Saint, Phillipp','1634','phillipp.saint@example.test','2018-11-27',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1286,1666,'Anne','Söncksen','Söncksen, Anne','1666','anne.söncksen@example.test','2019-04-27',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1287,1658,'Monika','Stasiak','Stasiak, Monika','1658','monika.stasiak@example.test','2019-03-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1288,1644,'Sven','Stremmel','Stremmel, Sven','1644','sven.stremmel@example.test','2019-12-30',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1289,1627,'Erik','Valentin','Valentin, Erik','1627','erik.valentin@example.test','2019-09-04',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1290,1641,'Marie','Vanselow','Vanselow, Marie','1641','marie.vanselow@example.test','2019-11-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1291,1663,'Ulrich','Willmes','Willmes, Ulrich','1663','ulrich.willmes@example.test','2019-09-16',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1292,1647,'Brigitte','Würfel','Würfel, Brigitte','1647','brigitte.würfel@example.test','2019-05-07',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1293,1653,'Sven','Bassewitz','Bassewitz, Sven','1653','sven.bassewitz@example.test','2019-07-07',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:27:54'),
(1294,1652,'Bernd','Behrends','Behrends, Bernd','1652','bernd.behrends@example.test','2019-06-10',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1295,1589,'Marie','Berg','Berg, Marie','1589','marie.berg@example.test','2018-10-06',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1296,1667,'Stephanie','Börsting','Börsting, Stephanie','1667','stephanie.börsting@example.test','2019-12-06',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1297,1617,'Jana','Classe','Classe, Jana','1617','jana.classe@example.test','2019-02-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1298,1629,'Kathrin, Katrin','Deuter','Deuter, Kathrin, Katrin','1629','kathrin,.katrin.deuter@example.test','2019-11-21',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1299,1618,'Paul','Gärd','Gärd, Paul','1618','paul.gärd@example.test','2019-12-01',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1300,1623,'Lena','Greifeld','Greifeld, Lena','1623','lena.greifeld@example.test','2019-10-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1301,1662,'Ulrike','Hasburgen','Hasburgen, Ulrike','1662','ulrike.hasburgen@example.test','2019-07-02',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1302,1587,'Melanie','John','John, Melanie','1587','melanie.john@example.test','2019-02-04',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1303,1614,'Tom','Jonas','Jonas, Tom','1614','tom.jonas@example.test','2019-06-06',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1304,1632,'Benjamin','Kern','Kern, Benjamin','1632','benjamin.kern@example.test','2019-08-01',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1305,1650,'Daniel','Lincke','Lincke, Daniel','1650','daniel.lincke@example.test','2018-11-29',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1306,1628,'Melanie','Ludwig','Ludwig, Melanie','1628','melanie.ludwig@example.test','2020-02-22',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1307,1648,'Peter','Matschke','Matschke, Peter','1648','peter.matschke@example.test','2019-04-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1308,1640,'Klaus','Niehaus','Niehaus, Klaus','1640','klaus.niehaus@example.test','2019-09-18',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1309,1620,'Petra','Olsen','Olsen, Petra','1620','petra.olsen@example.test','2019-02-24',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1310,1657,'Daniel','Pauly','Pauly, Daniel','1657','daniel.pauly@example.test','2019-05-01',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1311,1646,'Marina','Pieper','Pieper, Marina','1646','marina.pieper@example.test','2019-06-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1312,1631,'Nicole','Ritz','Ritz, Nicole','1631','nicole.ritz@example.test','2019-12-24',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1313,1643,'Sandra','Rouwertsen','Rouwertsen, Sandra','1643','sandra.rouwertsen@example.test','2019-03-09',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1314,1660,'Christian','Sauerbrey','Sauerbrey, Christian','1660','christian.sauerbrey@example.test','2019-12-29',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1315,1656,'Vanessa','Schram','Schram, Vanessa','1656','vanessa.schram@example.test','2019-05-08',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1316,1635,'Philipp','tenHompel','tenHompel, Philipp','1635','philipp.tenhompel@example.test','2019-05-09',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1317,1661,'Anna','Thadden','Thadden, Anna','1661','anna.thadden@example.test','2019-10-09',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1318,1726,'Kathrin, Katrin','Tschudy','Tschudy, Kathrin, Katrin','1726','kathrin,.katrin.tschudy@example.test','2019-06-12',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1319,1654,'Uta','Willmot','Willmot, Uta','1654','uta.willmot@example.test','2019-07-26',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1320,1626,'Ulrich','Zickow','Zickow, Ulrich','1626','ulrich.zickow@example.test','2019-06-19',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1321,1570,'Nicole','Bainnin','Bainnin, Nicole','1570','nicole.bainnin@example.test','2018-03-28',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1322,1595,'Marie','Brocke','Brocke, Marie','1595','marie.brocke@example.test','2018-07-18',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1323,1562,'Leon','Cossel','Cossel, Leon','1562','leon.cossel@example.test','2018-10-11',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1324,1588,'Christin','Diedrichsen','Diedrichsen, Christin','1588','christin.diedrichsen@example.test','2019-01-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1325,1566,'Angelika','Ehden','Ehden, Angelika','1566','angelika.ehden@example.test','2018-07-18',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1326,1576,'Brigitte','Farver','Farver, Brigitte','1576','brigitte.farver@example.test','2018-03-07',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1327,1552,'Vanessa','Feis','Feis, Vanessa','1552','vanessa.feis@example.test','2018-09-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1328,1567,'Marina','Fleischer','Fleischer, Marina','1567','marina.fleischer@example.test','2017-10-31',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1329,1598,'Jürgen','Grooßen','Grooßen, Jürgen','1598','jürgen.grooßen@example.test','2017-12-26',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1330,1575,'Erik','Haniel','Haniel, Erik','1575','erik.haniel@example.test','2018-07-07',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1331,1500,'Marcel','Hardinghaus','Hardinghaus, Marcel','1500','marcel.hardinghaus@example.test','2017-10-30',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1332,1563,'Kerstin','Hinrichs','Hinrichs, Kerstin','1563','kerstin.hinrichs@example.test','2018-10-01',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1333,1586,'Heike','Jürgensen','Jürgensen, Heike','1586','heike.jürgensen@example.test','2018-07-13',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1334,1573,'Kristian','Keßler','Keßler, Kristian','1573','kristian.keßler@example.test','2018-05-03',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1335,1555,'Frank','Kleiminger','Kleiminger, Frank','1555','frank.kleiminger@example.test','2018-02-14',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1336,1537,'Lena','Koldum','Koldum, Lena','1537','lena.koldum@example.test','2018-02-08',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1337,1546,'Stephanie','Krickelbeck','Krickelbeck, Stephanie','1546','stephanie.krickelbeck@example.test','2018-07-07',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1338,1515,'Anne','Kulow','Kulow, Anne','1515','anne.kulow@example.test','2017-09-08',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1339,1553,'Matthias','Lantzing','Lantzing, Matthias','1553','matthias.lantzing@example.test','2018-06-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1340,1511,'Jessica','Lütkens','Lütkens, Jessica','1511','jessica.lütkens@example.test','2017-11-12',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1341,1582,'Christian','Mandicke','Mandicke, Christian','1582','christian.mandicke@example.test','2017-12-14',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1342,1596,'Stephan','Mertz','Mertz, Stephan','1596','stephan.mertz@example.test','2018-02-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1343,1602,'Nadine','Müller','Müller, Nadine','1602','nadine.müller@example.test','2018-11-04',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1344,1601,'Christine','Seim','Seim, Christine','1601','christine.seim@example.test','2018-03-26',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1345,1609,'Mike','Steffens','Steffens, Mike','1609','mike.steffens@example.test','2018-10-24',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1346,1547,'Jennifer','Stever','Stever, Jennifer','1547','jennifer.stever@example.test','2018-06-08',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1347,1560,'Mandy','Stünckel','Stünckel, Mandy','1560','mandy.stünckel@example.test','2017-10-29',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1348,1534,'Kristian','Weihs','Weihs, Kristian','1534','kristian.weihs@example.test','2016-07-10',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1349,1599,'Stefanie','Wubben','Wubben, Stefanie','1599','stefanie.wubben@example.test','2018-09-15',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1350,1568,'Stephan','Albertsen','Albertsen, Stephan','1568','stephan.albertsen@example.test','2018-05-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1351,1551,'Klaudia','Barghusen','Barghusen, Klaudia','1551','klaudia.barghusen@example.test','2018-10-31',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:33:23'),
(1352,1502,'Franziska','Berg','Berg, Franziska','1502','franziska.berg@example.test','2017-07-18',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1353,1579,'Karin','Berque','Berque, Karin','1579','karin.berque@example.test','2018-02-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1354,1580,'Monika','Blecher','Blecher, Monika','1580','monika.blecher@example.test','2018-08-03',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1355,1585,'Barbara','Dettmann','Dettmann, Barbara','1585','barbara.dettmann@example.test','2018-03-02',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1356,1554,'Sophie','Ebsen','Ebsen, Sophie','1554','sophie.ebsen@example.test','2018-03-21',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1357,1571,'Antje','Esselborn','Esselborn, Antje','1571','antje.esselborn@example.test','2018-09-04',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1358,1592,'Daniela','Felt','Felt, Daniela','1592','daniela.felt@example.test','2018-05-16',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1359,1594,'René','Friedrichs','Friedrichs, René','1594','rené.friedrichs@example.test','2018-04-28',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1360,1590,'Katharina','Gardelin','Gardelin, Katharina','1590','katharina.gardelin@example.test','2017-12-31',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1361,1548,'Eric','Haumer','Haumer, Eric','1548','eric.haumer@example.test','2018-10-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1362,1583,'Frank','Hubbell','Hubbell, Frank','1583','frank.hubbell@example.test','2018-05-16',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1363,1578,'Max','John','John, Max','1578','max.john@example.test','2018-09-06',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1364,1593,'Tom','Jungblut','Jungblut, Tom','1593','tom.jungblut@example.test','2018-05-26',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1365,1591,'Manuela','Kappler','Kappler, Manuela','1591','manuela.kappler@example.test','2017-11-23',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1366,1597,'René','Kibbel','Kibbel, René','1597','rené.kibbel@example.test','2018-04-28',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1367,1603,'Kerstin','Knop','Knop, Kerstin','1603','kerstin.knop@example.test','2017-11-03',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1368,1600,'Thomas','Koldum','Koldum, Thomas','1600','thomas.koldum@example.test','2018-07-12',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1369,1556,'Christian','Lippmann','Lippmann, Christian','1556','christian.lippmann@example.test','2018-02-19',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1370,1577,'Uta','Lückels','Lückels, Uta','1577','uta.lückels@example.test','2018-02-05',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1371,1569,'Monika','Nißen','Nißen, Monika','1569','monika.nißen@example.test','2018-02-20',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1372,1565,'Ute','Ramroth','Ramroth, Ute','1565','ute.ramroth@example.test','2018-12-21',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1373,1572,'Patrick','Rohling','Rohling, Patrick','1572','patrick.rohling@example.test','2018-01-03',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1374,1561,'Christin','Rollier','Rollier, Christin','1561','christin.rollier@example.test','2017-12-18',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1375,1584,'Claudia','Rütting','Rütting, Claudia','1584','claudia.rütting@example.test','2017-12-12',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1376,1536,'Sara','Sänger','Sänger, Sara','1536','sara.sänger@example.test','2017-09-29',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1377,1581,'Benjamin','Wilmes','Wilmes, Benjamin','1581','benjamin.wilmes@example.test','2018-11-28',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1378,1558,'Monika','Zuber','Zuber, Monika','1558','monika.zuber@example.test','2018-12-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1379,1523,'Angelika','Berg','Berg, Angelika','1523','angelika.berg@example.test','2017-12-14',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1380,1484,'Stefan','Bergener','Bergener, Stefan','1484','stefan.bergener@example.test','2017-03-14',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1381,1482,'Barbara','Canow','Canow, Barbara','1482','barbara.canow@example.test','2017-01-24',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1382,1669,'Martin','Dalcke','Dalcke, Martin','1669','martin.dalcke@example.test','2017-07-31',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1383,1505,'Ralph','Emonts','Emonts, Ralph','1505','ralph.emonts@example.test','2017-02-24',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1384,1449,'Franziska','Frohnert','Frohnert, Franziska','1449','franziska.frohnert@example.test','2016-05-20',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1385,1493,'Monika','Gaillard','Gaillard, Monika','1493','monika.gaillard@example.test','2017-12-28',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1386,1520,'Tom','Gregor','Gregor, Tom','1520','tom.gregor@example.test','2017-08-15',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1387,1524,'Christian','Haack','Haack, Christian','1524','christian.haack@example.test','2017-08-23',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1388,1443,'Doreen','Hartmann','Hartmann, Doreen','1443','doreen.hartmann@example.test','2016-09-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1389,1516,'Silke','Kammerer','Kammerer, Silke','1516','silke.kammerer@example.test','2017-04-14',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1390,1668,'Antje','Kettemann','Kettemann, Antje','1668','antje.kettemann@example.test','2016-05-14',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1391,1491,'Melanie','Klauß','Klauß, Melanie','1491','melanie.klauß@example.test','2017-06-01',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1392,1513,'Mandy','Klug','Klug, Mandy','1513','mandy.klug@example.test','2017-12-15',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1393,1522,'Marco','Koslowska','Koslowska, Marco','1522','marco.koslowska@example.test','2017-07-12',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1394,1483,'Heike','Kreha','Kreha, Heike','1483','heike.kreha@example.test','2017-05-13',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1395,1510,'Sara','Menne','Menne, Sara','1510','sara.menne@example.test','2017-06-16',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1396,1526,'Patrick','Möllers','Möllers, Patrick','1526','patrick.möllers@example.test','2017-08-29',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1397,1501,'Bernd','Prellberg','Prellberg, Bernd','1501','bernd.prellberg@example.test','2017-05-08',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1398,1606,'Christine','Röcher','Röcher, Christine','1606','christine.röcher@example.test','2017-05-08',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1399,1529,'Anke','Salenski','Salenski, Anke','1529','anke.salenski@example.test','2017-12-04',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1400,1518,'Lea','Sauer','Sauer, Lea','1518','lea.sauer@example.test','2017-07-12',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1401,1527,'Silke','Schassen','Schassen, Silke','1527','silke.schassen@example.test','2017-07-27',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1402,1490,'Robert','Schütz','Schütz, Robert','1490','robert.schütz@example.test','2017-05-26',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1403,1444,'Bernd','Spiegel','Spiegel, Bernd','1444','bernd.spiegel@example.test','2017-01-14',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1404,1514,'Jürgen','Suermann','Suermann, Jürgen','1514','jürgen.suermann@example.test','2017-12-14',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1405,1528,'David','Venneker','Venneker, David','1528','david.venneker@example.test','2017-11-04',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1406,1417,'Tobias','Wojcik','Wojcik, Tobias','1417','tobias.wojcik@example.test','2016-10-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1407,1492,'Eric','Bockelmann','Bockelmann, Eric','1492','eric.bockelmann@example.test','2017-08-02',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1408,1509,'Jens','Brockmann','Brockmann, Jens','1509','jens.brockmann@example.test','2017-05-27',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1409,1465,'Anna','Bultmann','Bultmann, Anna','1465','anna.bultmann@example.test','2016-10-05',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1410,1503,'David','Connover','Connover, David','1503','david.connover@example.test','2017-10-18',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1411,1427,'Heike','Conradi','Conradi, Heike','1427','heike.conradi@example.test','2016-08-11',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1412,1504,'Philipp','Dornseifer','Dornseifer, Philipp','1504','philipp.dornseifer@example.test','2017-04-08',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1413,1531,'Mandy','Goltschmit','Goltschmit, Mandy','1531','mandy.goltschmit@example.test','2017-10-14',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1414,1308,'Antje','Hase','Hase, Antje','1308','antje.hase@example.test','2015-10-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1415,1512,'Maria','Heinoff','Heinoff, Maria','1512','maria.heinoff@example.test','2017-01-18',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1416,1494,'Dennis','Heller','Heller, Dennis','1494','dennis.heller@example.test','2017-07-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1417,1487,'Kevin','Himmelstierna','Himmelstierna, Kevin','1487','kevin.himmelstierna@example.test','2017-05-07',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1418,1485,'Susanne','Himmelstützer','Himmelstützer, Susanne','1485','susanne.himmelstützer@example.test','2017-04-12',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1419,1533,'Marcel','Kimmerlin','Kimmerlin, Marcel','1533','marcel.kimmerlin@example.test','2017-10-14',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1420,1530,'Doreen','Kirckhoff','Kirckhoff, Doreen','1530','doreen.kirckhoff@example.test','2017-10-23',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1421,1472,'Marco','Kusserow','Kusserow, Marco','1472','marco.kusserow@example.test','2016-09-27',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1422,1506,'Claudia','Marteville','Marteville, Claudia','1506','claudia.marteville@example.test','2017-10-07',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1423,1498,'Stephan','Niemeyer','Niemeyer, Stephan','1498','stephan.niemeyer@example.test','2017-06-04',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1424,1496,'Nadine','Pampe','Pampe, Nadine','1496','nadine.pampe@example.test','2017-07-26',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1425,1481,'Jens','Pick','Pick, Jens','1481','jens.pick@example.test','2017-02-27',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1426,1488,'Sebastian','Riggers','Riggers, Sebastian','1488','sebastian.riggers@example.test','2017-02-15',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1427,1435,'Daniela','Schmallenbach','Schmallenbach, Daniela','1435','daniela.schmallenbach@example.test','2016-10-20',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1428,1497,'Gabriele','Schulte-Janning','Schulte-Janning, Gabriele','1497','gabriele.schulte-janning@example.test','2017-10-01',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1429,1438,'Franziska','Steingrobe','Steingrobe, Franziska','1438','franziska.steingrobe@example.test','2016-10-12',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1430,1499,'Ralf','Steuber','Steuber, Ralf','1499','ralf.steuber@example.test','2017-07-31',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1431,1486,'Mathias','Strömer','Strömer, Mathias','1486','mathias.strömer@example.test','2016-11-04',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1432,1532,'Frank','Teppel','Teppel, Frank','1532','frank.teppel@example.test','2017-08-06',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1433,1469,'Stephan','Wördemann','Wördemann, Stephan','1469','stephan.wördemann@example.test','2016-08-21',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1434,1525,'Antje','Wubben','Wubben, Antje','1525','antje.wubben@example.test','2017-03-09',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1435,1519,'Sven','Wubbens','Wubbens, Sven','1519','sven.wubbens@example.test','2017-09-15',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1436,1544,'Marina','Beesten','Beesten, Marina','1544','marina.beesten@example.test','2016-09-10',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1437,1459,'Kevin','Bengtsson','Bengtsson, Kevin','1459','kevin.bengtsson@example.test','2016-08-29',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1438,1450,'Ralf','Chillot','Chillot, Ralf','1450','ralf.chillot@example.test','2016-10-06',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1439,1432,'Mario','Creutzer','Creutzer, Mario','1432','mario.creutzer@example.test','2016-11-15',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1440,1430,'Kerstin','d\'Alençon','d\'Alençon, Kerstin','1430','kerstin.d\'alençon@example.test','2016-01-15',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1441,1414,'Christin','Drewes','Drewes, Christin','1414','christin.drewes@example.test','2016-04-06',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1442,1466,'Vanessa','Engelmann','Engelmann, Vanessa','1466','vanessa.engelmann@example.test','2016-01-05',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1443,1325,'Sven','Farian','Farian, Sven','1325','sven.farian@example.test','2015-04-12',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1444,1456,'Jessika','Feld','Feld, Jessika','1456','jessika.feld@example.test','2016-12-21',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1445,1460,'Ralf','Freithoff','Freithoff, Ralf','1460','ralf.freithoff@example.test','2016-11-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1446,1453,'Uta','Gockel','Gockel, Uta','1453','uta.gockel@example.test','2016-08-04',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1447,1454,'Kristin','Grosse-Hündfeld','Grosse-Hündfeld, Kristin','1454','kristin.grosse-hündfeld@example.test','2016-11-05',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1448,1413,'Jana','Hemphill','Hemphill, Jana','1413','jana.hemphill@example.test','2016-10-03',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1449,1318,'Thorsten','Hork','Hork, Thorsten','1318','thorsten.hork@example.test','2015-05-19',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1450,1467,'Maria','Kimmerlin','Kimmerlin, Maria','1467','maria.kimmerlin@example.test','2016-07-03',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1451,1303,'Claudia','Kupferschmidt','Kupferschmidt, Claudia','1303','claudia.kupferschmidt@example.test','2015-06-22',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1452,1431,'Sandra','Mallory','Mallory, Sandra','1431','sandra.mallory@example.test','2016-02-20',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1453,1412,'Christin','Siebert','Siebert, Christin','1412','christin.siebert@example.test','2016-07-23',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1454,1405,'Thomas','Thiessen','Thiessen, Thomas','1405','thomas.thiessen@example.test','2015-12-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1455,1408,'Jessika','Töpler','Töpler, Jessika','1408','jessika.töpler@example.test','2015-11-16',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1456,1479,'Andreas','Tretow','Tretow, Andreas','1479','andreas.tretow@example.test','2016-02-19',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1457,1474,'Anja','Vocke','Vocke, Anja','1474','anja.vocke@example.test','2015-11-30',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1458,1406,'Sophia','Wallmeyer','Wallmeyer, Sophia','1406','sophia.wallmeyer@example.test','2016-05-08',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1459,1448,'Petra','Westerbrochs','Westerbrochs, Petra','1448','petra.westerbrochs@example.test','2016-11-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1460,1428,'Maximilian','Wölfer','Wölfer, Maximilian','1428','maximilian.wölfer@example.test','2016-05-22',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1461,1447,'Kevin','Bastian','Bastian, Kevin','1447','kevin.bastian@example.test','2016-03-13',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:42:22'),
(1462,1434,'Mandy','Bernonville','Bernonville, Mandy','1434','mandy.bernonville@example.test','2016-05-15',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1463,1313,'Dirk','Brokmeyer','Brokmeyer, Dirk','1313','dirk.brokmeyer@example.test','2015-02-28',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1464,1426,'Dirk','Deuter','Deuter, Dirk','1426','dirk.deuter@example.test','2016-06-29',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1465,1442,'Sebastian','Feddersen','Feddersen, Sebastian','1442','sebastian.feddersen@example.test','2016-10-01',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1466,1400,'Uta','Friedrich','Friedrich, Uta','1400','uta.friedrich@example.test','2016-08-05',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1467,1441,'Antje','Geizkofler','Geizkofler, Antje','1441','antje.geizkofler@example.test','2015-12-26',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1468,1419,'Erik','Gieben','Gieben, Erik','1419','erik.gieben@example.test','2016-04-19',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1469,1445,'Gabriele','Grünholz','Grünholz, Gabriele','1445','gabriele.grünholz@example.test','2016-05-30',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1470,1423,'Karolin','Heuer','Heuer, Karolin','1423','karolin.heuer@example.test','2016-09-10',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1471,1452,'Petra','Kißler','Kißler, Petra','1452','petra.kißler@example.test','2016-03-18',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1472,1471,'Uwe','Krämer','Krämer, Uwe','1471','uwe.krämer@example.test','2016-07-16',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1473,1399,'Birgit','Lanzing','Lanzing, Birgit','1399','birgit.lanzing@example.test','2016-07-13',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1474,1424,'Tim','Mauw','Mauw, Tim','1424','tim.mauw@example.test','2016-02-12',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1475,1415,'Florian','Merle','Merle, Florian','1415','florian.merle@example.test','2016-03-25',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1476,1407,'Christian','Meyerdirks','Meyerdirks, Christian','1407','christian.meyerdirks@example.test','2016-04-01',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1477,1429,'Sophia','Nommsen','Nommsen, Sophia','1429','sophia.nommsen@example.test','2016-03-20',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1478,1468,'Doreen','Öhelschlegel','Öhelschlegel, Doreen','1468','doreen.öhelschlegel@example.test','2016-08-21',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1479,1508,'Jens','Post','Post, Jens','1508','jens.post@example.test','2017-04-11',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1480,1404,'Diana','Rösch','Rösch, Diana','1404','diana.rösch@example.test','2015-12-15',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1481,1422,'Katja','Schödl','Schödl, Katja','1422','katja.schödl@example.test','2016-06-22',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1482,1446,'Phillipp','Sperry','Sperry, Phillipp','1446','phillipp.sperry@example.test','2016-05-28',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1483,1436,'Annett','Welter','Welter, Annett','1436','annett.welter@example.test','2016-12-17',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1484,1421,'Lisa','Zoll','Zoll, Lisa','1421','lisa.zoll@example.test','2016-05-02',1,NULL,'2026-05-14 22:08:08','2026-05-14 22:08:16'),
(1485,51657,'Zakaria','Belallli','Belallli, Zakaria','51657','Z.Belal@example.test','2012-09-01',1,NULL,'2026-05-14 22:17:54','2026-05-14 22:20:26'),
(1486,52074,'Sophia','Addily','Addily, Sophia','52074','S.Addily@example.test','2012-07-12',1,NULL,'2026-05-14 22:17:54','2026-05-14 22:17:54'),
(1487,58332,'Pia-Sarina','Engels','Engels, Pia-Sarina','58332','PiaSarina.Engels@example.test','2012-01-21',1,NULL,'2026-05-14 22:17:54','2026-05-14 22:17:54'),
(1488,51292,'Julian','Glanz','Glanz, Julian','51292','J.Glanz@example.test','2012-07-12',1,NULL,'2026-05-14 22:17:54','2026-05-14 22:17:54');
/*!40000 ALTER TABLE `schueler` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schueler_klassen`
--

DROP TABLE IF EXISTS `schueler_klassen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `schueler_klassen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `schueler_id` int(10) unsigned NOT NULL,
  `klassen_id` int(10) unsigned NOT NULL,
  `schuljahr` varchar(20) NOT NULL,
  `von_datum` date DEFAULT NULL,
  `bis_datum` date DEFAULT NULL,
  `ist_aktuell` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_schueler_klassen_schueler` (`schueler_id`),
  KEY `idx_schueler_klassen_klasse` (`klassen_id`),
  KEY `idx_schueler_klassen_schuljahr` (`schuljahr`),
  KEY `idx_schueler_klassen_aktuell` (`ist_aktuell`),
  CONSTRAINT `fk_schueler_klassen_klasse` FOREIGN KEY (`klassen_id`) REFERENCES `klassen` (`id`),
  CONSTRAINT `fk_schueler_klassen_schueler` FOREIGN KEY (`schueler_id`) REFERENCES `schueler` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1545 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schueler_klassen`
--

LOCK TABLES `schueler_klassen` WRITE;
/*!40000 ALTER TABLE `schueler_klassen` DISABLE KEYS */;
INSERT INTO `schueler_klassen` VALUES
(1312,1265,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:07','2026-05-14 22:08:07'),
(1313,1266,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1314,1267,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1315,1268,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1316,1269,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1317,1270,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1318,1271,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1319,1272,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1320,1273,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1321,1274,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1322,1275,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1323,1276,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1324,1277,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1325,1278,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1326,1279,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1327,1280,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1328,1281,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1329,1282,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1330,1283,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1331,1284,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1332,1285,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1333,1286,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1334,1287,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1335,1288,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1336,1289,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1337,1290,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1338,1291,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1339,1292,176,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1340,1293,177,'24/25',NULL,NULL,0,'2026-05-14 22:08:08','2026-05-14 22:25:54'),
(1341,1294,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1342,1295,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1343,1296,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1344,1297,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1345,1298,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1346,1299,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1347,1300,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1348,1301,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1349,1302,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1350,1303,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1351,1304,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1352,1305,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1353,1306,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1354,1307,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1355,1308,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1356,1309,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1357,1310,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1358,1311,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1359,1312,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1360,1313,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1361,1314,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1362,1315,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1363,1316,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1364,1317,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1365,1318,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1366,1319,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1367,1320,177,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1368,1321,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1369,1322,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1370,1323,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1371,1324,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1372,1325,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1373,1326,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1374,1327,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1375,1328,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1376,1329,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1377,1330,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1378,1331,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1379,1332,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1380,1333,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1381,1334,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1382,1335,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1383,1336,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1384,1337,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1385,1338,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1386,1339,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1387,1340,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1388,1341,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1389,1342,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1390,1343,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1391,1344,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1392,1345,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1393,1346,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1394,1347,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1395,1348,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1396,1349,178,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1397,1350,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1398,1351,179,'24/25',NULL,NULL,0,'2026-05-14 22:08:08','2026-05-14 22:33:23'),
(1399,1352,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1400,1353,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1401,1354,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1402,1355,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1403,1356,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1404,1357,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1405,1358,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1406,1359,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1407,1360,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1408,1361,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1409,1362,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1410,1363,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1411,1364,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1412,1365,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1413,1366,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1414,1367,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1415,1368,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1416,1369,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1417,1370,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1418,1371,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1419,1372,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1420,1373,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1421,1374,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1422,1375,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1423,1376,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1424,1377,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1425,1378,179,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1426,1379,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1427,1380,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1428,1381,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1429,1382,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1430,1383,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1431,1384,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1432,1385,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1433,1386,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1434,1387,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1435,1388,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1436,1389,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1437,1390,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1438,1391,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1439,1392,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1440,1393,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1441,1394,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1442,1395,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1443,1396,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1444,1397,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1445,1398,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1446,1399,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1447,1400,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1448,1401,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1449,1402,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1450,1403,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1451,1404,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1452,1405,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1453,1406,180,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1454,1407,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1455,1408,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1456,1409,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1457,1410,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1458,1411,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1459,1412,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1460,1413,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1461,1414,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1462,1415,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1463,1416,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1464,1417,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1465,1418,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1466,1419,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1467,1420,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1468,1421,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1469,1422,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1470,1423,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1471,1424,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1472,1425,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1473,1426,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1474,1427,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1475,1428,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1476,1429,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1477,1430,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1478,1431,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1479,1432,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1480,1433,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1481,1434,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1482,1435,181,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1483,1436,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1484,1437,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1485,1438,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1486,1439,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1487,1440,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1488,1441,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1489,1442,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1490,1443,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1491,1444,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1492,1445,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1493,1446,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1494,1447,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1495,1448,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1496,1449,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1497,1450,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1498,1451,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1499,1452,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1500,1453,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1501,1454,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1502,1455,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1503,1456,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1504,1457,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1505,1458,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1506,1459,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1507,1460,182,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1508,1461,183,'24/25',NULL,NULL,0,'2026-05-14 22:08:08','2026-05-14 22:29:00'),
(1509,1462,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1510,1463,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1511,1464,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1512,1465,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1513,1466,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1514,1467,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1515,1468,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1516,1469,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1517,1470,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1518,1471,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1519,1472,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1520,1473,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1521,1474,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1522,1475,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1523,1476,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1524,1477,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1525,1478,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1526,1479,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1527,1480,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1528,1481,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1529,1482,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1530,1483,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1531,1484,183,'24/25',NULL,NULL,1,'2026-05-14 22:08:08','2026-05-14 22:08:08'),
(1532,1485,184,'24/25',NULL,NULL,0,'2026-05-14 22:17:54','2026-05-14 22:20:26'),
(1533,1486,184,'24/25',NULL,NULL,0,'2026-05-14 22:17:54','2026-05-14 22:20:26'),
(1534,1487,185,'24/25',NULL,NULL,0,'2026-05-14 22:17:54','2026-05-14 22:20:27'),
(1535,1488,185,'24/25',NULL,NULL,0,'2026-05-14 22:17:54','2026-05-14 22:20:27'),
(1536,1485,184,'24/25',NULL,NULL,1,'2026-05-14 22:20:26','2026-05-14 22:20:26'),
(1537,1486,184,'24/25',NULL,NULL,1,'2026-05-14 22:20:26','2026-05-14 22:20:26'),
(1538,1487,185,'24/25',NULL,NULL,1,'2026-05-14 22:20:27','2026-05-14 22:20:27'),
(1539,1488,185,'24/25',NULL,NULL,1,'2026-05-14 22:20:27','2026-05-14 22:20:27'),
(1540,1293,177,'24/25',NULL,NULL,0,'2026-05-14 22:25:54','2026-05-14 22:27:54'),
(1541,1293,177,'24/25',NULL,NULL,1,'2026-05-14 22:27:54','2026-05-14 22:27:54'),
(1542,1461,183,'24/25',NULL,NULL,0,'2026-05-14 22:29:00','2026-05-14 22:42:22'),
(1543,1351,179,'24/25',NULL,NULL,1,'2026-05-14 22:33:23','2026-05-14 22:33:23'),
(1544,1461,183,'24/25',NULL,NULL,1,'2026-05-14 22:42:22','2026-05-14 22:42:22');
/*!40000 ALTER TABLE `schueler_klassen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `standorte`
--

DROP TABLE IF EXISTS `standorte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `standorte` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(100) NOT NULL,
  `standort_typ` varchar(50) DEFAULT NULL,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `beschreibung` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_standorte_bezeichnung` (`bezeichnung`),
  KEY `idx_standorte_parent` (`parent_id`),
  CONSTRAINT `fk_standorte_parent` FOREIGN KEY (`parent_id`) REFERENCES `standorte` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `standorte`
--

LOCK TABLES `standorte` WRITE;
/*!40000 ALTER TABLE `standorte` DISABLE KEYS */;
INSERT INTO `standorte` VALUES
(1,'Medienraum','raum',NULL,'Zentraler Ausgaberaum fuer digitale Geraete.'),
(2,'Bibliothek','raum',NULL,'Ausgabe und Lagerung von Buechern.'),
(3,'Lager Technik','lager',NULL,'Lager fuer Technik und Zubehoer.'),
(4,'Klassenraum 7a','raum',NULL,'Klassenraum der 7a.');
/*!40000 ALTER TABLE `standorte` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statuskatalog`
--

DROP TABLE IF EXISTS `statuskatalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `statuskatalog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(50) NOT NULL,
  `beschreibung` varchar(255) DEFAULT NULL,
  `ist_ausleihbar` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_statuskatalog_bezeichnung` (`bezeichnung`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statuskatalog`
--

LOCK TABLES `statuskatalog` WRITE;
/*!40000 ALTER TABLE `statuskatalog` DISABLE KEYS */;
INSERT INTO `statuskatalog` VALUES
(1,'verfuegbar','Kann regul??r ausgeliehen werden.',1),
(2,'reserviert','Ist vorgemerkt und momentan nicht frei verfuegbar.',0),
(3,'ausgeliehen','Ist aktuell ausgegeben.',0),
(4,'defekt','Ist defekt und nicht ausleihbar.',0),
(5,'in_reparatur','Befindet sich in Reparatur.',0),
(6,'verloren','Ist nicht auffindbar.',0),
(7,'ausgesondert','Wurde aus dem Bestand genommen.',0);
/*!40000 ALTER TABLE `statuskatalog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vertrags_abschnitte`
--

DROP TABLE IF EXISTS `vertrags_abschnitte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `vertrags_abschnitte` (
  `v_abschnitt_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `v_vorlage_id` int(10) unsigned NOT NULL,
  `titel` varchar(190) NOT NULL,
  `abschnitt_art` varchar(50) NOT NULL DEFAULT 'rechtstext',
  `sortier_nr` int(11) NOT NULL DEFAULT 1,
  `html_inhalt` longtext NOT NULL,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`v_abschnitt_id`),
  KEY `idx_vertrags_abschnitte_vorlage` (`v_vorlage_id`,`sortier_nr`),
  CONSTRAINT `fk_vertrags_abschnitte_vorlage` FOREIGN KEY (`v_vorlage_id`) REFERENCES `vertrags_vorlagen` (`v_vorlage_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vertrags_abschnitte`
--

LOCK TABLES `vertrags_abschnitte` WRITE;
/*!40000 ALTER TABLE `vertrags_abschnitte` DISABLE KEYS */;
INSERT INTO `vertrags_abschnitte` VALUES
(1,1,'Nutzung des Tablets','rechtstext',1,'<p>Das ausgegebene Tablet bleibt Eigentum der Schule. Es ist ausschliesslich fuer schulische Zwecke, das Lernen zu Hause sowie fuer abgestimmte Unterrichtsvorhaben zu verwenden.</p>\n        <p>Installationen, Konten und Schutzeinstellungen duerfen nur im durch die Schule freigegebenen Rahmen veraendert werden. Sicherheits- und Jugendschutzvorgaben sind einzuhalten.</p>','2026-05-15 10:18:19','2026-05-15 10:18:19'),
(2,1,'Sorgfalt und Haftung','rechtstext',2,'<p>Das Geraet ist pfleglich zu behandeln und vor Verlust, Diebstahl, Feuchtigkeit sowie unsachgemaesser Nutzung zu schuetzen. Schaeden oder Funktionsstoerungen sind unverzueglich der Schule mitzuteilen.</p>\n        <p>Bei vorsetzlicher oder grob fahrlaessiger Beschaedigung koennen schul- oder zivilrechtliche Folgen entstehen. Die konkrete Pruefung erfolgt im Einzelfall.</p>','2026-05-15 10:18:19','2026-05-15 10:18:19'),
(3,1,'Rueckgabe und Daten','rechtstext',3,'<p>Das Tablet ist auf Aufforderung der Schule, bei Schulwechsel oder am Ende der vereinbarten Nutzung vollstaendig zurueckzugeben. Dazu gehoeren auch ausgegebenes Zubehoer und Schutzmaterialien.</p>\n        <p>Vor der Rueckgabe koennen schulische Konten, Profile oder Daten im notwendigen Umfang entfernt werden. Private Daten sind durch die nutzende Person rechtzeitig selbst zu sichern.</p>','2026-05-15 10:18:19','2026-05-15 10:18:19'),
(4,2,'Nutzung des Laptops','rechtstext',1,'<p>Der Laptop wird fuer schulische Aufgaben, digitale Lernangebote und abgestimmte Heimarbeit zur Verfuegung gestellt. Die Nutzung erfolgt im Rahmen der schulischen Ordnungen und Weisungen.</p>\n        <p>Manipulationen am Betriebssystem, an Verwaltungssoftware oder an Schutzmechanismen sind unzulaessig, sofern sie nicht durch die Schule freigegeben wurden.</p>','2026-05-15 10:18:19','2026-05-15 10:18:19'),
(5,2,'Pflege, Transport und Meldungen','rechtstext',2,'<p>Der Laptop ist transportsicher aufzubewahren und vor Beschaedigungen zu schuetzen. Netzteil, Eingabegeraete und weiteres Zubehoer sind gemeinsam mit dem Hauptgeraet sorgfaeltig zu verwahren.</p>\n        <p>Defekte, Verlust oder Missbrauchsverdacht muessen ohne schuldhaftes Zoegern gemeldet werden, damit Schutz- und Sperrmassnahmen veranlasst werden koennen.</p>','2026-05-15 10:18:19','2026-05-15 10:18:19'),
(6,2,'Rueckgabe','rechtstext',3,'<p>Die Rueckgabe erfolgt in sauberem, vollstaendigem und moeglichst funktionsfaehigem Zustand. Vorhandene Benutzerdaten sind eigenverantwortlich zu sichern.</p>\n        <p>Die Schule kann zur Vorbereitung einer Weitergabe ein Zuruecksetzen, Neuaufsetzen oder die Entfernung verwalteter Inhalte vornehmen.</p>','2026-05-15 10:18:19','2026-05-15 10:18:19'),
(7,3,'Zweck der Ueberlassung','rechtstext',1,'<p>Die bereitgestellte WLAN-Komponente beziehungsweise das zugeordnete Netzzugangsmittel dient der Teilnahme an schulischen Lern- und Kommunikationsangeboten im abgestimmten Rahmen.</p>\n        <p>Die Nutzung ist auf berechtigte Personen beschraenkt. Zugangsdaten oder technische Komponenten duerfen nicht unbefugt an Dritte weitergegeben werden.</p>','2026-05-15 10:18:19','2026-05-15 10:18:19'),
(8,3,'Sicherheit und Verantwortlichkeit','rechtstext',2,'<p>Die ausgegebenen Komponenten sind vor Verlust und unbefugtem Zugriff zu schuetzen. Bei Stoerungen, Missbrauchsverdacht oder Verlust ist die Schule unmittelbar zu informieren.</p>\n        <p>Es gelten die schulischen Regeln zur IT-Nutzung, zum Datenschutz und zur Informationssicherheit in ihrer jeweils gueltigen Fassung.</p>','2026-05-15 10:18:19','2026-05-15 10:18:19'),
(9,3,'Beendigung der Nutzung','rechtstext',3,'<p>Mit Ende der Berechtigung oder auf Anforderung der Schule sind ausgegebene Komponenten unverzueglich zurueckzugeben beziehungsweise Zugangsdaten nicht weiter zu verwenden.</p>\n        <p>Die Schule kann Zugriffe aus organisatorischen oder sicherheitsrelevanten Gruenden jederzeit einschraenken oder beenden.</p>','2026-05-15 10:18:19','2026-05-15 10:18:19'),
(82,4,'Vorbemerkung','rechtstext',1,'<p>Im Rahmen des Sofortausstattungsprogramms „DigitalPakt Schule“ werden Schülerinnen und Schülern leihweise mit mobilen Endgeräten ausgestattet. Dieser Leihvertrag regelt Einzelheiten zur Nutzung der Leihgeräte und ist für beide Parteien verbindlich.</p>','2026-05-16 14:08:30','2026-05-16 14:08:30'),
(83,4,'§ 1 - Leihgerät und Grundsätze der Nutzung','rechtstext',2,'<p>(1)	Die Stadt Grevenbroich stellt dem/der Entleiher*in das/die auf Seite 1 aufgeführte(-n) Endgerät(-e) inkl. Zubehör - zusammen im Folgenden „das Leihgerät“ genannt - unentgeltlich zur Verfügung. \n</p><p>\nDas Leihgerät verbleibt im Eigentum der Stadt Grevenbroich. Die Nutzung ist nur durch den/die Entleiher*in zulässig. Eine Veräußerung oder Weitergabe an Dritte - auch zu lediglich vorübergehender Nutzung - ist verboten. \n</p><p>\n(2)	Der/die Entleiher*in verpflichtet sich zu jeder Zeit auf Verlangen Auskunft über den Verbleib des Leihgerätes zu geben und dieses der Schule jederzeit vorzuführen.\n</p><p>\n(3)	Das Leihgerät ist pfleglich und sorgsam zu behandeln, insbesondere ist das Leihgerät vor Verschmutzungen und Beschädigungen zu schützen. Das Anbringen von permanenten Markierungen und Aufklebern/Stickern ist nicht erlaubt. Ausgenommen hiervon sind durch die Stadt Grevenbroich autorisierte Aufkleber zum Hinweis auf Zuschussgeber. \n</p><p>\n(4)	Das Leihgerät wird über ein zentrales Mobile Device Management (MDM) verwaltet und ist vorkonfiguriert. Die Stadt Grevenbroich behält sich gegenüber dem/der Entleiher*in vor, jederzeit Anpassungen der Konfigurationen vorzunehmen.\n</p><p>\n(5)	Die Stadt Grevenbroich oder die o.g. Schule kann bei Bedarf - vor allem bei nicht mehr vorhandener Funktionsfähigkeit - das Leihgerät sperren oder in den Auslieferungszustand zurücksetzen. Durch das Zurücksetzen werden alle auf dem Leihgerät gespeicherte Daten gelöscht. Der/die Entleiher*in hat keinen Anspruch auf Sicherung oder Speicherung von Daten oder Dokumenten. Die Stadt Grevenbroich und die ITK-Rheinland haben das Recht, jederzeit Einblick in das Leihgerät zu nehmen, sofern und soweit dies zur Prüfung der Funktionsfähigkeit des Leihgerätes oder der installierten\n</p>','2026-05-16 14:08:30','2026-05-16 14:08:30'),
(84,4,'§ 2 Beschädigung, Diebstahl und Versicherung','rechtstext',3,'<p>(1)	Jede Beschädigung oder Funktionsbeeinträchtigung des Leihgeräts oder Zubehörs muss der Schulleitung unmittelbar nach Eintritt der Beschädigung/Funktionsbeeinträchtigung gemeldet werden.\n</p><p>\n(2)	Jeglicher Verlust des Leihgerätes muss der Schulleitung unmittelbar nach Verlust gemeldet werden. Bei Diebstahl des Leihgerätes erstattet die Stadt Grevenbroich als Eigentümerin polizeiliche Anzeige. \n</p><p>\n(3)	Die Stadt Grevenbroich hat für das Leihgerät eine für den/die Entleiher*in kostenfreie Versicherung abgeschlossen. Dennoch kann es zu Zusatzkosten kommen. Diese können dem/der Entleiher*in als Selbstbeteiligung in Rechnung gestellt werden, wenn Schäden behoben werden müssen, die weder über die Geräte-Garantie noch über Dritte abgedeckt sind oder wenn der Versicherungsschutz erlischt. \n</p><p>\na.	Bei unverschuldeten Hardwareschäden innerhalb der Garantiezeit fallen keine Kosten an, wenn der Garantieanspruch vom Hersteller anerkannt wird.\n</p><p>\nb.	Bei Hardwareschäden, die nicht durch Dritte verursacht wurden, tritt die Versicherung der Stadt Grevenbroich in Kraft und stellt sicher, dass das Leihgerät repariert oder ersetzt wird. Die Stadt Grevenbroich behält sich die Möglichkeit vor, dem/der Entleiher*in die städtische Selbstbeteiligung in Höhe von bis zu 100,00 Euro in Rechnung zu stellen.\n</p><p>\nc.	Die Versicherung der Stadt Grevenbroich behält sich vor, Regress gegen die Versicherung des/der Entleihers/Entleiherin geltend zu machen, bei vorsätzlich oder grob fahrlässig herbeigeführten Hardwareschäden auch gegen den/die Entleiher*in. \n</p><p>\nd.	Bei Diebstahl bzw. Verlust/Abhandenkommen des Leihgerätes behält sich die Stadt Grevenbroich vor, dem/der Entleiher*in die städtische Selbstbeteiligung in Höhe von 100,00 Euro in Rechnung zu stellen. \n</p><p>\n(4)	Aus diesem Grunde wird empfohlen, vorab mit der ggf. bei dem/der Entleiher*in bereits bestehenden Haftpflicht- oder Hausratversicherung Kontakt aufzunehmen. Möglicherweise sind entsprechende Leistungen bereits in den vorhandenen Versicherungsverträgen enthalten oder können gegen eine kleine Gebühr dazu gebucht werden.\n</p><p>\n(5)	Andernfalls wird dem/der Entleiher*in zur Absicherung bei einer Beschädigung oder einem Diebstahl empfohlen, eigenverantwortlich eine Versicherung bei einem Versicherer nach Wahl abzuschließen. Die Kosten für die Versicherung trägt der/die Entleiher*in selbst. \n</p><p>\n(6)	Ein Anspruch auf Ersatz bzw. Reparatur des Leihgerätes besteht nicht.  \n</p>','2026-05-16 14:08:30','2026-05-16 14:08:30'),
(85,4,'§ 3 Nutzung nur zu schulischen Zwecken','rechtstext',4,'<p>(1)	Das Leihgerät darf ausschließlich für schulische Zwecke genutzt werden. Eine private Nutzung des Leihgerätes ist verboten. Als schulischer Zweck ist die Nutzung im Rahmen des Unterrichts, inklusive der Vor- und Nachbereitung von Unterrichtsinhalten anzusehen, welche mit den Unterrichtsinhalten oder sonstiger schulischer Arbeit im Zusammenhang stehen. \n\n(2)	Der/die Entleiher*in ist verpflichtet, sich an die geltenden Rechtvorschriften - auch innerschulischer Art - zu halten. Dazu gehören Urheber-, Jugendschutz-, Datenschutz- und Strafrecht sowie die Schulordnung.\n\n(3)	Der/die Sorgeberechtigte*n ist/sind für die Einhaltung der Zweckbestimmung der Nutzung verantwortlich.\n\n(4)	Das Leihgerät muss stets mit einem vollständig aufgeladenen Akkuladezustand in die Schule mitgebracht werden. Ferner ist sicherzustellen, dass auf dem Leihgerät genügend freier Speicherplatz für schulische Zwecke zur Verfügung steht.\n\n(5)	Fotos, Filme und Audiomitschnitte dürfen während des Unterrichts und auf dem Schulgelände ausschließlich schulischen Zwecken unter Beachtung der datenschutzrechtlichen Bestimmungen aufgenommen werden.\n</p>','2026-05-16 14:08:30','2026-05-16 14:08:30'),
(86,4,'§ 4 Verbotene Nutzungen','rechtstext',5,'<p>(1)	Fotos, Filme, Musik und andere Medien- und Internetinhalte jugendgefährdender, rassistischer, pornographischer, gewaltverherrlichender, ehrverletzender oder beleidigender Art dürfen weder aufgerufen noch gespeichert, zugänglich gemacht oder weiterverbreitet werden. Die Bestimmungen der Strafgesetze sind zu beachten.\n\n(2)	Filme, Musikbeiträge, Texte, Bilder oder sonstige urheberrechtlich geschützte Werke dürfen nur mit Zustimmung des Urhebers oder der sonstigen Rechteinhaber im Internet zum Abruf bereitgestellt, verbreitet oder veröffentlicht werden. Ist im Einzelfall nicht aufzuklären, ob Urheberrechte verletzt sein könnten, ist die Nutzung untersagt.\n\n(3)	Das allgemeine Persönlichkeitsrecht ist zu beachten. Foto-, Video- und Audioaufnahmen, einschließlich deren Anfertigung, Speicherung, Weitergabe, Verbreitung und Veröffentlichung, sind ohne Einwilligung der aufgenommenen Person unzulässig. \n\n(4)	Es ist verboten, mit dem Leihgerät Inhalte, die der Stadt Grevenbroich, der o.g. Schule oder dem Land Nordrhein-Westfalen schaden können, im Internet zu veröffentlichen, zu versenden oder sonst zugänglich zu machen. 	\n\n(5)	Das Hoch- oder Herunterladen sowie das Kopieren von Dateien, insbesondere von Dateien, die in sog. „File-Sharing-Netzwerken“ angeboten werden, sind grundsätzlich untersagt. Die Umgehung von Kopierschutzmechanismen ist verboten.\n\n(6)	Das Entfernen der Sperre, die verhindert, dass nicht geprüfte Fremdsoftware installiert oder nicht vom Hersteller zugelassene Manipulationen am Leihgerät ermöglicht werden (sog. „Jailbreak“), ist ebenso wie das Löschen/Deaktivieren der vorinstallierten Programme nicht erlaubt.\n\n(7)	Es ist untersagt, mithilfe des Leihgerätes im eigenen oder fremden Namen Verträge abzuschließen und/oder kostenpflichtige Dienste in Anspruch zu nehmen. \n\n(8)	Es ist verboten, die auf dem Leihgerät bereits vorinstallierten Programme/Apps zu löschen, zu verändern oder an andere Personen weiterzugeben.\n</p>','2026-05-16 14:08:30','2026-05-16 14:08:30'),
(87,4,'§ 5 Verstöße gegen den Leihvertrag','rechtstext',6,'<p>(1)	Bei Zuwiderhandlungen gegen diesen Leihvertrag kann durch die Stadt Grevenbroich oder die o.g. Schule die Nutzung des Leihgerätes nach pflichtgemäßem Ermessen ganz oder teilweise, zeitweise oder dauerhaft eingeschränkt oder untersagt werden. \n\n(2)	Die Stadt Grevenbroich und die o.g. Schule haften nicht im Falle einer rechts- oder verbotswidrigen Nutzung des Leihgerätes (vgl. § 4 dieses Leihvertrages).\n</p>','2026-05-16 14:08:30','2026-05-16 14:08:30'),
(88,4,'§ 6 Beendigung und Rückgabe','rechtstext',7,'<p>(1)	Es besteht für beide Vertragsparteien die Möglichkeit, den Leihvertrag jederzeit mit sofortiger Wirkung zu beenden. Dazu ist eine entsprechende Mitteilung in Textform erforderlich. \n\n(2)	Verlässt der/die Entleiher*in die o.g. Schule, so endet das Vertragsverhältnis automatisch mit dem letzten Schultag. \n\n(3)	Der/die Entleiher*in verpflichtet sich, das Leihgerät mit vollständigem Zubehör nach Vertragsende unverzüglich in einem ordnungsgemäßen und technisch einwandfreien Zustand an die Schulleitung zurückzugeben. Die Rückgabe muss spätestens drei Werktage nach Beendigung des Vertragsverhältnisses erfolgen und mithilfe der „Anlage zum Leihvertrag über ein iPad inklusive Zubehör“ dokumentiert werden. \n</p>','2026-05-16 14:08:30','2026-05-16 14:08:30'),
(89,4,'§ 7 Vorschäden','rechtstext',8,'<p>Das Leihgerät ist neu und unbeschädigt.\n\n	Das Leihgerät ist gebraucht. Der/die Entleiher*in und die Schulleitung fertigen gemeinsam ein Übergabeprotokoll an, um ggf. vorhandene Vorschäden zu dokumentieren. Diese „Anlage zum Leihvertrag über ein iPad inklusive Zubehör“ ist Vertragsbestandteil.\n\n§ 8\nDatenschutz\n\n(1)	Es gelten die gesetzlichen Bestimmungen gemäß EU-Datenschutz-Grundverordnung (EU-DSGVO) zum Schutz personenbezogener Daten und deren Verarbeitung.\n\n(2)	Im Rahmen des Supports und der Wartung des Leihgerätes dürfen personenbezogene Daten durch die Stadt Grevenbroich als Schulträger, die o.g. Schule und der ITK-Rheinland verarbeitet werden, die zur ordnungsgemäßen Erfüllung dieses Leihvertrages einschließlich aller Sorgfaltspflichten erforderlich sind (Art. 6 Abs. 1 S. 1 Buchst. b DSGVO).  \n\n(3)	Der/die Entleiher*in ist damit einverstanden, dass personenbezogene Daten zur allgemeinen Administration - unter Wahrung datenschutzrechtlicher Grundsätze - gespeichert werden.\n\n§ 9\nSchlussbestimmungen\n\n(1)	Sofern der Stadt Grevenbroich Ansprüche aus diesem Leihvertrag entstehen, können diese gegen den/die Entleiher*in geltend gemacht werden.\n\n(2)	Jegliche Änderung oder Ergänzung dieses Leihvertrages sind nur wirksam, wenn sie schriftlich vereinbart werden. Dies gilt auch für eine Änderung dieser Schriftformklausel.\n</p><p>\n(3)	Sollten einzelne Bestimmungen dieses Leihvertrages ganz oder teilweise unwirksam oder nichtig sein oder infolge Änderung der Gesetzeslage oder durch höchstrichterliche Rechtsprechung oder auf andere Weise ganz oder teilweise unwirksam oder nichtig werden oder weist dieser Vertrag Lücken auf, so sind sich die Parteien darüber einig, dass die übrigen Bestimmungen dieses Leihvertrages davon unberührt und gültig bleiben. Für diesen Fall verpflichten sich die Vertragspartner, unter Berücksichtigung des Grundsatzes von Treu und Glauben an der Stelle der unwirksamen Bestimmung eine wirksame Bestimmung zu vereinbaren, welche dem Sinn und Zweck der unwirksamen Bestimmung möglichst nahekommt und von der anzunehmen ist, dass die Parteien sie im Zeitpunkt des Abschlusses dieses Leihvertrages vereinbart hätten, wenn sie die Unwirksamkeit oder Nichtigkeit gekannt oder vorgesehen hätten. Entsprechendes gilt, falls dieser Leihvertrag eine Lücke enthalten sollte.\n</p></p><p>\n<strong>Hinweis: Sofern nur ein Sorgeberechtigter unterschreibt, wird von diesem bestätigt, dass er entweder die alleinige elterliche Sorge für den/die Schüler*in hat oder mit Einwilligung und in Vertretung des anderen Sorgeberechtigten handelt.</strong>\n</p>','2026-05-16 14:08:30','2026-05-16 14:08:30');
/*!40000 ALTER TABLE `vertrags_abschnitte` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vertrags_vorlagen`
--

DROP TABLE IF EXISTS `vertrags_vorlagen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `vertrags_vorlagen` (
  `v_vorlage_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(190) NOT NULL,
  `typ` varchar(50) NOT NULL,
  `version` int(11) NOT NULL,
  `briefkopf_png` longtext DEFAULT NULL,
  `seitenrand_oben_mm` decimal(5,2) NOT NULL DEFAULT 14.00,
  `seitenrand_rechts_mm` decimal(5,2) NOT NULL DEFAULT 12.00,
  `seitenrand_unten_mm` decimal(5,2) NOT NULL DEFAULT 18.00,
  `seitenrand_links_mm` decimal(5,2) NOT NULL DEFAULT 12.00,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`v_vorlage_id`),
  UNIQUE KEY `uq_vertrags_vorlagen_typ_version` (`typ`,`version`),
  KEY `idx_vertrags_vorlagen_typ_aktiv` (`typ`,`aktiv`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vertrags_vorlagen`
--

LOCK TABLES `vertrags_vorlagen` WRITE;
/*!40000 ALTER TABLE `vertrags_vorlagen` DISABLE KEYS */;
INSERT INTO `vertrags_vorlagen` VALUES
(1,'Leihvertrag TABLET','tablet',1,NULL,14.00,12.00,18.00,12.00,0,'2026-05-15 10:18:19','2026-05-15 15:34:01'),
(2,'Leihvertrag LAPTOP','laptop',1,NULL,14.00,12.00,18.00,12.00,1,'2026-05-15 10:18:19','2026-05-15 10:18:19'),
(3,'Leihvertrag WLAN','wlan',1,NULL,14.00,12.00,18.00,12.00,1,'2026-05-15 10:18:19','2026-05-15 10:18:19'),
(4,'Leihvertrag TABLET','tablet',2,'briefkoepfe/tablet_1778933310241.png',14.00,12.00,18.00,20.00,1,'2026-05-15 15:34:01','2026-05-16 14:08:30');
/*!40000 ALTER TABLE `vertrags_vorlagen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zustandskatalog`
--

DROP TABLE IF EXISTS `zustandskatalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `zustandskatalog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bezeichnung` varchar(50) NOT NULL,
  `beschreibung` varchar(255) DEFAULT NULL,
  `sortierung` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_zustandskatalog_bezeichnung` (`bezeichnung`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zustandskatalog`
--

LOCK TABLES `zustandskatalog` WRITE;
/*!40000 ALTER TABLE `zustandskatalog` DISABLE KEYS */;
INSERT INTO `zustandskatalog` VALUES
(1,'neu','Neuwertiger Zustand.',10),
(2,'sehr_gut','Kaum Gebrauchsspuren.',20),
(3,'gut','Normale Gebrauchsspuren.',30),
(4,'gebraucht','Deutliche Gebrauchsspuren, aber funktionstuechtig.',40),
(5,'beschaedigt','Physisch beschaedigt.',50),
(6,'unvollstaendig','Zubehoer oder Teile fehlen.',60);
/*!40000 ALTER TABLE `zustandskatalog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'smedia'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-05-18 11:34:41
