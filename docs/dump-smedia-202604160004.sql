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
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_artikel_inventar_typ` (`inventar_typ_id`),
  KEY `idx_artikel_titel` (`titel`),
  KEY `idx_artikel_herkunft` (`herkunft_id`),
  CONSTRAINT `fk_artikel_herkunft` FOREIGN KEY (`herkunft_id`) REFERENCES `herkunft` (`id`),
  CONSTRAINT `fk_artikel_inventar_typ` FOREIGN KEY (`inventar_typ_id`) REFERENCES `inventar_typen` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artikel`
--

LOCK TABLES `artikel` WRITE;
/*!40000 ALTER TABLE `artikel` DISABLE KEYS */;
INSERT INTO `artikel` VALUES
(1,2,'iPad 10. Generation 64 GB','iPad 10','Schul-iPad fuer Unterricht und Ausleihe.','Apple','iPad 10. Generation',2,1,'2026-04-08 22:59:12','2026-04-13 18:05:16'),
(2,3,'Apple Pencil USB-C','Digitaler Stift','Digitaler Stift fuer kompatible iPads.','Apple','Pencil USB-C',2,1,'2026-04-08 22:59:12','2026-04-13 18:01:48'),
(3,4,'Apple 20W USB-C Netzteil','Ladegeraet Tablet','Standard-Ladegeraet fuer iPads.','Apple','20W USB-C Power Adapter',2,1,'2026-04-08 22:59:12','2026-04-13 18:01:48'),
(4,5,'Logitech Rugged Keyboard Folio','Tablet-Tastatur','Schutztastatur fuer Unterrichtstablets.','Logitech','Rugged Folio',1,1,'2026-04-08 22:59:12','2026-04-13 18:01:48'),
(5,6,'Epson EB-FH52','Beamer mobil','Mobiler Beamer fuer Klassenraeume.','Epson','EB-FH52',NULL,1,'2026-04-08 22:59:12','2026-04-08 22:59:12'),
(6,1,'Deutsch 7','Lehrbuch Deutsch Jahrgang 7','Schulbuch fuer den Deutschunterricht Jahrgang 7.',NULL,NULL,NULL,1,'2026-04-08 22:59:12','2026-04-08 22:59:12'),
(7,1,'Mathematik 7','Lehrbuch Mathematik Jahrgang 7','Schulbuch fuer den Mathematikunterricht Jahrgang 7.',NULL,NULL,NULL,1,'2026-04-08 22:59:12','2026-04-08 22:59:12'),
(8,1,'Englisch 7','Lehrbuch Englisch Jahrgang 7','Schulbuch fuer den Englischunterricht Jahrgang 7.',NULL,NULL,NULL,1,'2026-04-08 22:59:12','2026-04-08 22:59:12'),
(9,1,'Biologie 8','Lehrbuch Biologie Jahrgang 8','Schulbuch fuer den Biologieunterricht Jahrgang 8.',NULL,NULL,NULL,1,'2026-04-08 22:59:12','2026-04-08 22:59:12'),
(10,1,'Geschichte 9','Lehrbuch Geschichte Jahrgang 9','Schulbuch fuer den Geschichtsunterricht Jahrgang 9.',NULL,NULL,NULL,1,'2026-04-08 22:59:12','2026-04-08 22:59:12'),
(16,1,'Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9',NULL,NULL,NULL,NULL,NULL,1,'2026-04-09 14:16:01','2026-04-09 14:16:01'),
(17,1,'Mathematik real',NULL,NULL,NULL,NULL,NULL,1,'2026-04-09 14:27:38','2026-04-09 14:27:38'),
(18,1,'Mittlerer Schulabschluss zentrale Prüfungen 2010',NULL,NULL,NULL,NULL,NULL,1,'2026-04-09 15:15:11','2026-04-09 15:15:11'),
(19,1,'Mathematik real',NULL,NULL,NULL,NULL,NULL,1,'2026-04-11 18:27:08','2026-04-11 18:27:08'),
(21,2,'iPad 9.Gen 32GB','iPad 9','Schul-iPad fuer Schüler','Apple','iPad 9. Gen',1,1,'2026-04-13 17:59:49','2026-04-13 18:06:07');
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
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artikel_exemplare`
--

LOCK TABLES `artikel_exemplare` WRITE;
/*!40000 ALTER TABLE `artikel_exemplare` DISABLE KEYS */;
INSERT INTO `artikel_exemplare` VALUES
(1,1,'IPAD-001','G-IPAD-001','SN-IPAD-001',1,3,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-08 22:59:12','2026-04-08 23:19:23'),
(2,2,'PENCIL-001','G-PENCIL-001','SN-PENCIL-001',3,3,1,'2025-08-15',89.00,'2027-08-15',0,NULL,'Passend zu den Unterrichts-iPads.',1,'2026-04-08 22:59:12','2026-04-13 22:58:03'),
(3,3,'NETZ-001','G-NETZ-001',NULL,3,2,3,'2025-08-15',25.00,'2027-08-15',0,NULL,'Reserve-Ladegeraet.',1,'2026-04-08 22:59:12','2026-04-08 23:31:26'),
(4,4,'TAST-001','G-TAST-001','SN-TAST-001',1,3,1,'2025-08-20',119.00,'2027-08-20',0,NULL,'Tastatur fuer Tabletwagen.',1,'2026-04-08 22:59:12','2026-04-09 11:38:23'),
(5,5,'BEAMER-001','G-BEAMER-001','SN-BEAMER-001',1,3,3,'2024-09-01',799.00,'2026-09-01',0,NULL,'Mobiler Beamer fuer Fachraeume.',1,'2026-04-08 22:59:12','2026-04-09 11:38:38'),
(6,6,'BUCH-DE-001','B-DE-001',NULL,3,2,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 1 aus dem Klassensatz Deutsch 7.',1,'2026-04-08 22:59:12','2026-04-10 21:04:36'),
(7,7,'BUCH-MA-001','B-MA-001',NULL,3,3,2,'2026-07-01',26.00,NULL,1,'Mathematik 7 - Satz A','Exemplar 1 aus dem Klassensatz Mathematik 7.',1,'2026-04-08 22:59:12','2026-04-12 10:41:47'),
(8,8,'BUCH-EN-001','B-EN-001',NULL,3,2,2,'2026-07-01',25.00,NULL,1,'Englisch 7 - Satz A','Exemplar 1 aus dem Klassensatz Englisch 7.',1,'2026-04-08 22:59:12','2026-04-12 11:00:39'),
(9,9,'BUCH-BIO-001','B-BIO-001',NULL,3,3,2,'2026-07-01',27.50,NULL,1,'Biologie 8 - Satz B','Exemplar 1 aus dem Klassensatz Biologie 8.',1,'2026-04-08 22:59:12','2026-04-09 13:14:51'),
(10,10,'BUCH-GE-001','B-GE-001',NULL,1,3,2,'2026-07-01',23.00,NULL,1,'Geschichte 9 - Satz C','Exemplar 1 aus dem Klassensatz Geschichte 9.',1,'2026-04-08 22:59:12','2026-04-14 20:10:28'),
(16,6,'BUCH-DE-002','B-DE-002',NULL,3,3,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 2 aus dem Klassensatz Deutsch 7.',1,'2026-04-09 10:48:01','2026-04-14 20:13:03'),
(17,6,'BUCH-DE-003','B-DE-003',NULL,3,3,2,'2026-07-01',24.50,NULL,1,'Deutsch 7 - Satz A','Exemplar 3 aus dem Klassensatz Deutsch 7.',1,'2026-04-09 10:48:01','2026-04-12 20:41:49'),
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
(79,1,'IPAD-002','G-IPAD-002','SN-IPAD-002',3,2,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-11 23:14:41'),
(80,1,'IPAD-003','G-IPAD-003','SN-IPAD-003',1,2,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-09 11:50:54'),
(81,1,'IPAD-004','G-IPAD-004','SN-IPAD-004',1,2,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-09 11:50:54'),
(82,1,'IPAD-005','G-IPAD-005','SN-IPAD-005',3,2,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-13 22:56:43'),
(83,1,'IPAD-006','G-IPAD-006','SN-IPAD-006',4,5,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-14 10:15:36'),
(84,1,'IPAD-007','G-IPAD-007','SN-IPAD-007',1,2,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-09 11:50:54'),
(85,1,'IPAD-008','G-IPAD-008','SN-IPAD-008',1,2,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-09 11:50:54'),
(86,1,'IPAD-009','G-IPAD-009','SN-IPAD-009',4,5,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-14 08:24:33'),
(87,1,'IPAD-010','G-IPAD-010','SN-IPAD-010',3,2,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-14 08:23:26'),
(88,1,'IPAD-011','G-IPAD-011','SN-IPAD-011',1,2,1,'2025-08-15',449.00,'2027-08-15',0,NULL,'Einsatz fuer mobile Ausleihe.',1,'2026-04-09 11:50:54','2026-04-09 11:50:54'),
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
(108,16,'BUCH-16-015','B-16-015',NULL,3,2,1,'2026-04-09',NULL,NULL,1,'Klasse 09a','Neu',1,'2026-04-09 14:17:39','2026-04-09 14:24:19'),
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
(123,16,'BUCH-16-030','B-16-030',NULL,1,2,1,NULL,NULL,NULL,1,'Klasse 09b',NULL,1,'2026-04-09 14:23:23','2026-04-09 14:23:23'),
(124,17,'BUCH-17-001','B-17-001',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(125,17,'BUCH-17-002','B-17-002',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(126,17,'BUCH-17-003','B-17-003',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(127,17,'BUCH-17-004','B-17-004',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(128,17,'BUCH-17-005','B-17-005',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(129,17,'BUCH-17-006','B-17-006',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(130,17,'BUCH-17-007','B-17-007',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(131,17,'BUCH-17-008','B-17-008',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(132,17,'BUCH-17-009','B-17-009',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(133,17,'BUCH-17-010','B-17-010',NULL,3,2,1,'2026-04-08',NULL,NULL,1,'07a','Neu',1,'2026-04-09 14:27:38','2026-04-10 21:32:30'),
(134,17,'BUCH-17-011','B-17-011',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(135,17,'BUCH-17-012','B-17-012',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(136,17,'BUCH-17-013','B-17-013',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(137,17,'BUCH-17-014','B-17-014',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(138,17,'BUCH-17-015','B-17-015',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(139,17,'BUCH-17-016','B-17-016',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(140,17,'BUCH-17-017','B-17-017',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(141,17,'BUCH-17-018','B-17-018',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(142,17,'BUCH-17-019','B-17-019',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(143,17,'BUCH-17-020','B-17-020',NULL,1,2,1,'2026-04-08',NULL,NULL,1,'Klasse 07b',NULL,1,'2026-04-09 14:28:26','2026-04-09 14:28:26'),
(144,17,'BUCH-17-021','B-17-021',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 21 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(145,17,'BUCH-17-022','B-17-022',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 22 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(146,17,'BUCH-17-023','B-17-023',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 23 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(147,17,'BUCH-17-024','B-17-024',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 24 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(148,17,'BUCH-17-025','B-17-025',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 25 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(149,17,'BUCH-17-026','B-17-026',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 26 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(150,17,'BUCH-17-027','B-17-027',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 27 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
(151,17,'BUCH-17-028','B-17-028',NULL,1,2,1,'2026-04-09',NULL,NULL,1,'Klasse 7a','Exemplar 28 aus dem Klassensatz Mathematik real.',1,'2026-04-09 15:05:24','2026-04-09 15:05:24'),
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
(176,19,'BUCH-19-002','B-19-002',NULL,1,2,1,'2026-04-06',NULL,NULL,0,NULL,NULL,1,'2026-04-11 19:17:34','2026-04-11 19:17:34');
/*!40000 ALTER TABLE `artikel_exemplare` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(15,9,41,'2026-04-09 13:14:51','2026-04-01 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-04-09 13:14:51','2026-04-12 19:38:41'),
(16,104,284,'2026-04-09 14:24:19','2026-04-10 14:00:00','2026-04-12 10:35:06',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:35:06'),
(17,105,284,'2026-04-09 14:24:19','2026-04-10 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-09 14:24:19','2026-04-09 14:24:19'),
(18,106,284,'2026-04-09 14:24:19','2026-04-10 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-09 14:24:19','2026-04-09 14:24:19'),
(19,107,284,'2026-04-09 14:24:19','2026-04-10 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-09 14:24:19','2026-04-09 14:24:19'),
(20,108,284,'2026-04-09 14:24:19','2026-04-10 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-09 14:24:19','2026-04-09 14:24:19'),
(21,109,284,'2026-04-09 14:24:19','2026-04-10 14:00:00','2026-04-12 10:34:33',2,5,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:34:33'),
(22,110,284,'2026-04-09 14:24:19','2026-04-10 14:00:00','2026-04-12 10:32:54',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:32:54'),
(23,111,284,'2026-04-09 14:24:19','2026-04-10 14:00:00','2026-04-12 10:34:25',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:34:25'),
(24,112,284,'2026-04-09 14:24:19','2026-04-10 14:00:00','2026-04-12 10:33:45',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:33:45'),
(25,113,284,'2026-04-09 14:24:19','2026-04-17 14:00:00','2026-04-12 10:34:19',2,3,'zurueckgegeben',NULL,NULL,'2026-04-09 14:24:19','2026-04-12 10:34:19'),
(26,16,11,'2026-04-10 10:58:06','2026-04-17 14:00:00','2026-04-10 20:21:54',3,3,'zurueckgegeben',NULL,NULL,'2026-04-10 10:58:06','2026-04-10 20:21:54'),
(27,6,11,'2026-04-10 20:43:55','2026-04-17 14:00:00','2026-04-10 20:44:34',3,3,'zurueckgegeben',NULL,NULL,'2026-04-10 20:43:55','2026-04-10 20:44:34'),
(28,6,11,'2026-04-10 20:51:40','2026-04-17 14:00:00','2026-04-10 20:53:51',3,3,'zurueckgegeben',NULL,NULL,'2026-04-10 20:51:40','2026-04-10 20:53:51'),
(29,6,11,'2026-04-10 20:57:24','2026-04-17 14:00:00','2026-04-10 20:58:01',3,3,'zurueckgegeben',NULL,NULL,'2026-04-10 20:57:24','2026-04-10 20:58:01'),
(30,6,11,'2026-04-10 21:00:10','2026-04-17 14:00:00','2026-04-10 21:01:18',3,3,'zurueckgegeben',NULL,NULL,'2026-04-10 21:00:10','2026-04-10 21:01:18'),
(31,6,11,'2026-04-10 21:03:26','2026-04-17 14:00:00','2026-04-10 21:03:51',3,2,'zurueckgegeben',NULL,NULL,'2026-04-10 21:03:26','2026-04-10 21:03:51'),
(32,6,11,'2026-04-10 21:04:36','2026-04-01 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:04:36','2026-04-12 19:40:07'),
(33,124,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(34,125,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(35,126,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(36,127,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(37,128,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(38,129,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(39,130,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(40,131,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(41,132,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(42,133,282,'2026-04-10 21:32:30','2026-04-11 14:00:00',NULL,2,NULL,'offen',NULL,NULL,'2026-04-10 21:32:30','2026-04-10 21:32:30'),
(43,79,265,'2026-04-11 23:14:41','2026-04-25 23:59:59',NULL,2,NULL,'offen',NULL,NULL,'2026-04-11 23:14:41','2026-04-11 23:14:41'),
(44,10,261,'2026-04-11 23:21:33','2026-04-25 23:59:59','2026-04-11 23:23:23',3,4,'zurueckgegeben',NULL,NULL,'2026-04-11 23:21:33','2026-04-11 23:23:23'),
(45,7,11,'2026-04-12 10:41:47','2026-04-29 14:00:00',NULL,3,NULL,'offen',NULL,NULL,'2026-04-12 10:41:47','2026-04-14 20:12:15'),
(46,8,11,'2026-04-12 11:00:39','2026-04-19 23:59:59',NULL,2,NULL,'offen',NULL,NULL,'2026-04-12 11:00:39','2026-04-12 11:00:39'),
(47,10,11,'2026-04-12 20:20:54','2026-02-02 23:59:59','2026-04-14 20:10:28',4,3,'zurueckgegeben',NULL,NULL,'2026-04-12 20:20:54','2026-04-14 20:10:28'),
(48,17,6,'2026-04-12 20:41:49','2026-01-01 23:59:59',NULL,3,NULL,'offen',NULL,NULL,'2026-04-12 20:41:49','2026-04-12 20:41:49'),
(49,82,404,'2026-04-13 22:56:43','2026-04-20 23:59:59',NULL,2,NULL,'offen','Leihgerät',NULL,'2026-04-13 22:56:43','2026-04-13 22:56:43'),
(50,83,404,'2026-04-13 22:57:12','2026-04-01 23:59:59','2026-04-14 10:15:36',2,5,'zurueckgegeben','Leihgerät I',NULL,'2026-04-13 22:57:12','2026-04-14 10:15:36'),
(51,2,404,'2026-04-13 22:58:03','2026-04-01 23:59:59',NULL,3,NULL,'offen','Leihgerät I',NULL,'2026-04-13 22:58:03','2026-04-13 22:58:03'),
(52,87,404,'2026-04-14 08:23:26','2026-04-21 23:59:59',NULL,2,NULL,'offen',NULL,NULL,'2026-04-14 08:23:26','2026-04-14 08:23:26'),
(53,86,405,'2026-04-14 08:23:58','2026-04-21 23:59:59','2026-04-14 08:24:33',2,5,'zurueckgegeben',NULL,NULL,'2026-04-14 08:23:58','2026-04-14 08:24:33'),
(54,16,404,'2026-04-14 20:13:03','2026-04-21 23:59:59',NULL,3,NULL,'offen',NULL,NULL,'2026-04-14 20:13:03','2026-04-14 20:13:03');
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
) ENGINE=InnoDB AUTO_INCREMENT=406 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(6,'Mia Beispiel 01a 01','schueler','schueler',1,'01a','S-01A-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(7,'Noah Muster 01a 02','schueler','schueler',2,'01a','S-01A-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(8,'Emma Sommer 01a 03','schueler','schueler',3,'01a','S-01A-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(9,'Luca Winter 01a 04','schueler','schueler',4,'01a','S-01A-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(10,'Lea Schulz 01a 05','schueler','schueler',5,'01a','S-01A-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(11,'Ben Fischer 01a 06','schueler','schueler',6,'01a','S-01A-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(12,'Ida Neumann 01a 07','schueler','schueler',7,'01a','S-01A-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(13,'Jonas Klein 01a 08','schueler','schueler',8,'01a','S-01A-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(14,'Leni Wagner 01a 09','schueler','schueler',9,'01a','S-01A-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(15,'Paul Hoffmann 01a 10','schueler','schueler',10,'01a','S-01A-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(16,'Mia Beispiel 02a 01','schueler','schueler',11,'02a','S-02A-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(17,'Noah Muster 02a 02','schueler','schueler',12,'02a','S-02A-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(18,'Emma Sommer 02a 03','schueler','schueler',13,'02a','S-02A-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(19,'Luca Winter 02a 04','schueler','schueler',14,'02a','S-02A-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(20,'Lea Schulz 02a 05','schueler','schueler',15,'02a','S-02A-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(21,'Ben Fischer 02a 06','schueler','schueler',16,'02a','S-02A-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(22,'Ida Neumann 02a 07','schueler','schueler',17,'02a','S-02A-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(23,'Jonas Klein 02a 08','schueler','schueler',18,'02a','S-02A-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(24,'Leni Wagner 02a 09','schueler','schueler',19,'02a','S-02A-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(25,'Paul Hoffmann 02a 10','schueler','schueler',20,'02a','S-02A-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(26,'Mia Beispiel 03a 01','schueler','schueler',21,'03a','S-03A-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(27,'Noah Muster 03a 02','schueler','schueler',22,'03a','S-03A-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(28,'Emma Sommer 03a 03','schueler','schueler',23,'03a','S-03A-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(29,'Luca Winter 03a 04','schueler','schueler',24,'03a','S-03A-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(30,'Lea Schulz 03a 05','schueler','schueler',25,'03a','S-03A-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(31,'Ben Fischer 03a 06','schueler','schueler',26,'03a','S-03A-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(32,'Ida Neumann 03a 07','schueler','schueler',27,'03a','S-03A-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(33,'Jonas Klein 03a 08','schueler','schueler',28,'03a','S-03A-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(34,'Leni Wagner 03a 09','schueler','schueler',29,'03a','S-03A-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(35,'Paul Hoffmann 03a 10','schueler','schueler',30,'03a','S-03A-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(36,'Mia Beispiel 04a 01','schueler','schueler',31,'04a','S-04A-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(37,'Noah Muster 04a 02','schueler','schueler',32,'04a','S-04A-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(38,'Emma Sommer 04a 03','schueler','schueler',33,'04a','S-04A-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(39,'Luca Winter 04a 04','schueler','schueler',34,'04a','S-04A-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(40,'Lea Schulz 04a 05','schueler','schueler',35,'04a','S-04A-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(41,'Ben Fischer 04a 06','schueler','schueler',36,'04a','S-04A-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(42,'Ida Neumann 04a 07','schueler','schueler',37,'04a','S-04A-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(43,'Jonas Klein 04a 08','schueler','schueler',38,'04a','S-04A-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(44,'Leni Wagner 04a 09','schueler','schueler',39,'04a','S-04A-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(45,'Paul Hoffmann 04a 10','schueler','schueler',40,'04a','S-04A-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(46,'Mia Beispiel 05a 01','schueler','schueler',41,'05a','S-05A-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(47,'Noah Muster 05a 02','schueler','schueler',42,'05a','S-05A-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(48,'Emma Sommer 05a 03','schueler','schueler',43,'05a','S-05A-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(49,'Luca Winter 05a 04','schueler','schueler',44,'05a','S-05A-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(50,'Lea Schulz 05a 05','schueler','schueler',45,'05a','S-05A-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(51,'Ben Fischer 05a 06','schueler','schueler',46,'05a','S-05A-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(52,'Ida Neumann 05a 07','schueler','schueler',47,'05a','S-05A-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(53,'Jonas Klein 05a 08','schueler','schueler',48,'05a','S-05A-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(54,'Leni Wagner 05a 09','schueler','schueler',49,'05a','S-05A-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(55,'Paul Hoffmann 05a 10','schueler','schueler',50,'05a','S-05A-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(56,'Mia Beispiel 06a 01','schueler','schueler',51,'06a','S-06A-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(57,'Noah Muster 06a 02','schueler','schueler',52,'06a','S-06A-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(58,'Emma Sommer 06a 03','schueler','schueler',53,'06a','S-06A-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(59,'Luca Winter 06a 04','schueler','schueler',54,'06a','S-06A-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(60,'Lea Schulz 06a 05','schueler','schueler',55,'06a','S-06A-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(61,'Ben Fischer 06a 06','schueler','schueler',56,'06a','S-06A-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(62,'Ida Neumann 06a 07','schueler','schueler',57,'06a','S-06A-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(63,'Jonas Klein 06a 08','schueler','schueler',58,'06a','S-06A-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(64,'Leni Wagner 06a 09','schueler','schueler',59,'06a','S-06A-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(65,'Paul Hoffmann 06a 10','schueler','schueler',60,'06a','S-06A-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(66,'Mia Beispiel 07a 01','schueler','schueler',61,'07a','S-07A-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(67,'Noah Muster 07a 02','schueler','schueler',62,'07a','S-07A-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(68,'Emma Sommer 07a 03','schueler','schueler',63,'07a','S-07A-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(69,'Luca Winter 07a 04','schueler','schueler',64,'07a','S-07A-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(70,'Lea Schulz 07a 05','schueler','schueler',65,'07a','S-07A-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(71,'Ben Fischer 07a 06','schueler','schueler',66,'07a','S-07A-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(72,'Ida Neumann 07a 07','schueler','schueler',67,'07a','S-07A-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(73,'Jonas Klein 07a 08','schueler','schueler',68,'07a','S-07A-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(74,'Leni Wagner 07a 09','schueler','schueler',69,'07a','S-07A-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(75,'Paul Hoffmann 07a 10','schueler','schueler',70,'07a','S-07A-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(76,'Mia Beispiel 08a 01','schueler','schueler',71,'08a','S-08A-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(77,'Noah Muster 08a 02','schueler','schueler',72,'08a','S-08A-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(78,'Emma Sommer 08a 03','schueler','schueler',73,'08a','S-08A-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(79,'Luca Winter 08a 04','schueler','schueler',74,'08a','S-08A-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(80,'Lea Schulz 08a 05','schueler','schueler',75,'08a','S-08A-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(81,'Ben Fischer 08a 06','schueler','schueler',76,'08a','S-08A-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(82,'Ida Neumann 08a 07','schueler','schueler',77,'08a','S-08A-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(83,'Jonas Klein 08a 08','schueler','schueler',78,'08a','S-08A-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(84,'Leni Wagner 08a 09','schueler','schueler',79,'08a','S-08A-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(85,'Paul Hoffmann 08a 10','schueler','schueler',80,'08a','S-08A-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(86,'Mia Beispiel 09a 01','schueler','schueler',81,'09a','S-09A-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(87,'Noah Muster 09a 02','schueler','schueler',82,'09a','S-09A-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(88,'Emma Sommer 09a 03','schueler','schueler',83,'09a','S-09A-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(89,'Luca Winter 09a 04','schueler','schueler',84,'09a','S-09A-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(90,'Lea Schulz 09a 05','schueler','schueler',85,'09a','S-09A-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(91,'Ben Fischer 09a 06','schueler','schueler',86,'09a','S-09A-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(92,'Ida Neumann 09a 07','schueler','schueler',87,'09a','S-09A-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(93,'Jonas Klein 09a 08','schueler','schueler',88,'09a','S-09A-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(94,'Leni Wagner 09a 09','schueler','schueler',89,'09a','S-09A-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(95,'Paul Hoffmann 09a 10','schueler','schueler',90,'09a','S-09A-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(96,'Mia Beispiel 10a 01','schueler','schueler',91,'10a','S-10A-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(97,'Noah Muster 10a 02','schueler','schueler',92,'10a','S-10A-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(98,'Emma Sommer 10a 03','schueler','schueler',93,'10a','S-10A-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(99,'Luca Winter 10a 04','schueler','schueler',94,'10a','S-10A-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(100,'Lea Schulz 10a 05','schueler','schueler',95,'10a','S-10A-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(101,'Ben Fischer 10a 06','schueler','schueler',96,'10a','S-10A-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(102,'Ida Neumann 10a 07','schueler','schueler',97,'10a','S-10A-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(103,'Jonas Klein 10a 08','schueler','schueler',98,'10a','S-10A-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(104,'Leni Wagner 10a 09','schueler','schueler',99,'10a','S-10A-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(105,'Paul Hoffmann 10a 10','schueler','schueler',100,'10a','S-10A-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(106,'Mia Beispiel 01b 01','schueler','schueler',101,'01b','S-01B-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(107,'Noah Muster 01b 02','schueler','schueler',102,'01b','S-01B-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(108,'Emma Sommer 01b 03','schueler','schueler',103,'01b','S-01B-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(109,'Luca Winter 01b 04','schueler','schueler',104,'01b','S-01B-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(110,'Lea Schulz 01b 05','schueler','schueler',105,'01b','S-01B-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(111,'Ben Fischer 01b 06','schueler','schueler',106,'01b','S-01B-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(112,'Ida Neumann 01b 07','schueler','schueler',107,'01b','S-01B-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(113,'Jonas Klein 01b 08','schueler','schueler',108,'01b','S-01B-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(114,'Leni Wagner 01b 09','schueler','schueler',109,'01b','S-01B-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(115,'Paul Hoffmann 01b 10','schueler','schueler',110,'01b','S-01B-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(116,'Mia Beispiel 02b 01','schueler','schueler',111,'02b','S-02B-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(117,'Noah Muster 02b 02','schueler','schueler',112,'02b','S-02B-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(118,'Emma Sommer 02b 03','schueler','schueler',113,'02b','S-02B-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(119,'Luca Winter 02b 04','schueler','schueler',114,'02b','S-02B-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(120,'Lea Schulz 02b 05','schueler','schueler',115,'02b','S-02B-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(121,'Ben Fischer 02b 06','schueler','schueler',116,'02b','S-02B-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(122,'Ida Neumann 02b 07','schueler','schueler',117,'02b','S-02B-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(123,'Jonas Klein 02b 08','schueler','schueler',118,'02b','S-02B-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(124,'Leni Wagner 02b 09','schueler','schueler',119,'02b','S-02B-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(125,'Paul Hoffmann 02b 10','schueler','schueler',120,'02b','S-02B-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(126,'Mia Beispiel 03b 01','schueler','schueler',121,'03b','S-03B-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(127,'Noah Muster 03b 02','schueler','schueler',122,'03b','S-03B-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(128,'Emma Sommer 03b 03','schueler','schueler',123,'03b','S-03B-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(129,'Luca Winter 03b 04','schueler','schueler',124,'03b','S-03B-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(130,'Lea Schulz 03b 05','schueler','schueler',125,'03b','S-03B-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(131,'Ben Fischer 03b 06','schueler','schueler',126,'03b','S-03B-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(132,'Ida Neumann 03b 07','schueler','schueler',127,'03b','S-03B-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(133,'Jonas Klein 03b 08','schueler','schueler',128,'03b','S-03B-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(134,'Leni Wagner 03b 09','schueler','schueler',129,'03b','S-03B-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(135,'Paul Hoffmann 03b 10','schueler','schueler',130,'03b','S-03B-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(136,'Mia Beispiel 04b 01','schueler','schueler',131,'04b','S-04B-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(137,'Noah Muster 04b 02','schueler','schueler',132,'04b','S-04B-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(138,'Emma Sommer 04b 03','schueler','schueler',133,'04b','S-04B-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(139,'Luca Winter 04b 04','schueler','schueler',134,'04b','S-04B-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(140,'Lea Schulz 04b 05','schueler','schueler',135,'04b','S-04B-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(141,'Ben Fischer 04b 06','schueler','schueler',136,'04b','S-04B-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(142,'Ida Neumann 04b 07','schueler','schueler',137,'04b','S-04B-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(143,'Jonas Klein 04b 08','schueler','schueler',138,'04b','S-04B-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(144,'Leni Wagner 04b 09','schueler','schueler',139,'04b','S-04B-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(145,'Paul Hoffmann 04b 10','schueler','schueler',140,'04b','S-04B-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(146,'Mia Beispiel 05b 01','schueler','schueler',141,'05b','S-05B-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(147,'Noah Muster 05b 02','schueler','schueler',142,'05b','S-05B-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(148,'Emma Sommer 05b 03','schueler','schueler',143,'05b','S-05B-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(149,'Luca Winter 05b 04','schueler','schueler',144,'05b','S-05B-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(150,'Lea Schulz 05b 05','schueler','schueler',145,'05b','S-05B-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(151,'Ben Fischer 05b 06','schueler','schueler',146,'05b','S-05B-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(152,'Ida Neumann 05b 07','schueler','schueler',147,'05b','S-05B-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(153,'Jonas Klein 05b 08','schueler','schueler',148,'05b','S-05B-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(154,'Leni Wagner 05b 09','schueler','schueler',149,'05b','S-05B-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(155,'Paul Hoffmann 05b 10','schueler','schueler',150,'05b','S-05B-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(156,'Mia Beispiel 06b 01','schueler','schueler',151,'06b','S-06B-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(157,'Noah Muster 06b 02','schueler','schueler',152,'06b','S-06B-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(158,'Emma Sommer 06b 03','schueler','schueler',153,'06b','S-06B-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(159,'Luca Winter 06b 04','schueler','schueler',154,'06b','S-06B-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(160,'Lea Schulz 06b 05','schueler','schueler',155,'06b','S-06B-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(161,'Ben Fischer 06b 06','schueler','schueler',156,'06b','S-06B-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(162,'Ida Neumann 06b 07','schueler','schueler',157,'06b','S-06B-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(163,'Jonas Klein 06b 08','schueler','schueler',158,'06b','S-06B-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(164,'Leni Wagner 06b 09','schueler','schueler',159,'06b','S-06B-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(165,'Paul Hoffmann 06b 10','schueler','schueler',160,'06b','S-06B-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(166,'Mia Beispiel 07b 01','schueler','schueler',161,'07b','S-07B-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(167,'Noah Muster 07b 02','schueler','schueler',162,'07b','S-07B-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(168,'Emma Sommer 07b 03','schueler','schueler',163,'07b','S-07B-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(169,'Luca Winter 07b 04','schueler','schueler',164,'07b','S-07B-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(170,'Lea Schulz 07b 05','schueler','schueler',165,'07b','S-07B-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(171,'Ben Fischer 07b 06','schueler','schueler',166,'07b','S-07B-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(172,'Ida Neumann 07b 07','schueler','schueler',167,'07b','S-07B-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(173,'Jonas Klein 07b 08','schueler','schueler',168,'07b','S-07B-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(174,'Leni Wagner 07b 09','schueler','schueler',169,'07b','S-07B-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(175,'Paul Hoffmann 07b 10','schueler','schueler',170,'07b','S-07B-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(176,'Mia Beispiel 08b 01','schueler','schueler',171,'08b','S-08B-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(177,'Noah Muster 08b 02','schueler','schueler',172,'08b','S-08B-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(178,'Emma Sommer 08b 03','schueler','schueler',173,'08b','S-08B-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(179,'Luca Winter 08b 04','schueler','schueler',174,'08b','S-08B-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(180,'Lea Schulz 08b 05','schueler','schueler',175,'08b','S-08B-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(181,'Ben Fischer 08b 06','schueler','schueler',176,'08b','S-08B-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(182,'Ida Neumann 08b 07','schueler','schueler',177,'08b','S-08B-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(183,'Jonas Klein 08b 08','schueler','schueler',178,'08b','S-08B-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(184,'Leni Wagner 08b 09','schueler','schueler',179,'08b','S-08B-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(185,'Paul Hoffmann 08b 10','schueler','schueler',180,'08b','S-08B-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(186,'Mia Beispiel 09b 01','schueler','schueler',181,'09b','S-09B-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(187,'Noah Muster 09b 02','schueler','schueler',182,'09b','S-09B-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(188,'Emma Sommer 09b 03','schueler','schueler',183,'09b','S-09B-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(189,'Luca Winter 09b 04','schueler','schueler',184,'09b','S-09B-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(190,'Lea Schulz 09b 05','schueler','schueler',185,'09b','S-09B-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(191,'Ben Fischer 09b 06','schueler','schueler',186,'09b','S-09B-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(192,'Ida Neumann 09b 07','schueler','schueler',187,'09b','S-09B-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(193,'Jonas Klein 09b 08','schueler','schueler',188,'09b','S-09B-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(194,'Leni Wagner 09b 09','schueler','schueler',189,'09b','S-09B-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(195,'Paul Hoffmann 09b 10','schueler','schueler',190,'09b','S-09B-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(196,'Mia Beispiel 10b 01','schueler','schueler',191,'10b','S-10B-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(197,'Noah Muster 10b 02','schueler','schueler',192,'10b','S-10B-002',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(198,'Emma Sommer 10b 03','schueler','schueler',193,'10b','S-10B-003',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(199,'Luca Winter 10b 04','schueler','schueler',194,'10b','S-10B-004',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(200,'Lea Schulz 10b 05','schueler','schueler',195,'10b','S-10B-005',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(201,'Ben Fischer 10b 06','schueler','schueler',196,'10b','S-10B-006',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(202,'Ida Neumann 10b 07','schueler','schueler',197,'10b','S-10B-007',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(203,'Jonas Klein 10b 08','schueler','schueler',198,'10b','S-10B-008',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(204,'Leni Wagner 10b 09','schueler','schueler',199,'10b','S-10B-009',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(205,'Paul Hoffmann 10b 10','schueler','schueler',200,'10b','S-10B-010',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(261,'Frau Anna Becker','lehrkraft','lehrkraft',1,'D, M','L-BCK-001',1,'2026-04-09 11:33:09','2026-04-10 21:58:55'),
(262,'Herr Tobias Schneider','lehrkraft','lehrkraft',2,'IF, KU','L-SND-001',1,'2026-04-09 11:33:09','2026-04-10 21:58:55'),
(263,'Frau Sarah Mueller','lehrkraft','lehrkraft',3,'M, D','L-MLR-001',1,'2026-04-09 11:33:09','2026-04-10 21:58:55'),
(264,'Herr David Koch','lehrkraft','lehrkraft',4,'Bi, Ch, Ek','L-KCH-001',1,'2026-04-09 11:33:09','2026-04-10 21:58:55'),
(265,'Frau Julia Wagner','lehrkraft','lehrkraft',5,'E, F, Sp','L-WGN-001',1,'2026-04-09 11:33:09','2026-04-10 21:58:55'),
(266,'Herr Lars Hoffmann','lehrkraft','lehrkraft',6,'Ge, Ek, Mu','L-HFM-001',1,'2026-04-09 11:33:09','2026-04-10 21:58:55'),
(267,'Frau Katrin Neumann','lehrkraft','lehrkraft',7,'Kunst','L-NMN-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(268,'Herr Jan Fischer','lehrkraft','lehrkraft',8,'Sport','L-FSR-001',1,'2026-04-09 11:33:09','2026-04-09 11:33:09'),
(276,'Klasse 01a','klasse','klasse',1,'01','K-01A',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(277,'Klasse 02a','klasse','klasse',2,'02','K-02A',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(278,'Klasse 03a','klasse','klasse',3,'03','K-03A',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(279,'Klasse 04a','klasse','klasse',4,'04','K-04A',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(280,'Klasse 05a','klasse','klasse',5,'05','K-05A',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(281,'Klasse 06a','klasse','klasse',6,'06','K-06A',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(282,'Klasse 07a','klasse','klasse',7,'07','K-07A',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(283,'Klasse 08a','klasse','klasse',8,'08','K-08A',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(284,'Klasse 09a','klasse','klasse',9,'09','K-09A',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(285,'Klasse 10a','klasse','klasse',10,'10','K-10A',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(286,'Klasse 01b','klasse','klasse',14,'01','K-01B',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(287,'Klasse 02b','klasse','klasse',15,'02','K-02B',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(288,'Klasse 03b','klasse','klasse',16,'03','K-03B',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(289,'Klasse 04b','klasse','klasse',17,'04','K-04B',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(290,'Klasse 05b','klasse','klasse',18,'05','K-05B',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(291,'Klasse 06b','klasse','klasse',19,'06','K-06B',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(292,'Klasse 07b','klasse','klasse',20,'07','K-07B',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(293,'Klasse 08b','klasse','klasse',21,'08','K-08B',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(294,'Klasse 09b','klasse','klasse',22,'09','K-09B',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(295,'Klasse 10b','klasse','klasse',23,'10','K-10B',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(296,'Klasse 01c','klasse','klasse',27,'01','K-01C',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(297,'Klasse 02c','klasse','klasse',28,'02','K-02C',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(298,'Klasse 03c','klasse','klasse',29,'03','K-03C',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(299,'Klasse 04c','klasse','klasse',30,'04','K-04C',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(300,'Klasse 05c','klasse','klasse',31,'05','K-05C',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(301,'Klasse 06c','klasse','klasse',32,'06','K-06C',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(302,'Klasse 07c','klasse','klasse',33,'07','K-07C',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(303,'Klasse 08c','klasse','klasse',34,'08','K-08C',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(304,'Klasse 09c','klasse','klasse',35,'09','K-09C',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(305,'Klasse 10c','klasse','klasse',36,'10','K-10C',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(306,'Klasse 01d','klasse','klasse',40,'01','K-01D',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(307,'Klasse 02d','klasse','klasse',41,'02','K-02D',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(308,'Klasse 03d','klasse','klasse',42,'03','K-03D',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(309,'Klasse 04d','klasse','klasse',43,'04','K-04D',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(310,'Klasse 05d','klasse','klasse',44,'05','K-05D',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(311,'Klasse 06d','klasse','klasse',45,'06','K-06D',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(312,'Klasse 07d','klasse','klasse',46,'07','K-07D',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(313,'Klasse 08d','klasse','klasse',47,'08','K-08D',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(314,'Klasse 09d','klasse','klasse',48,'09','K-09D',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(315,'Klasse 10d','klasse','klasse',49,'10','K-10D',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(316,'Klasse 01e','klasse','klasse',53,'01','K-01E',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(317,'Klasse 02e','klasse','klasse',54,'02','K-02E',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(318,'Klasse 03e','klasse','klasse',55,'03','K-03E',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(319,'Klasse 04e','klasse','klasse',56,'04','K-04E',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(320,'Klasse 05e','klasse','klasse',57,'05','K-05E',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(321,'Klasse 06e','klasse','klasse',58,'06','K-06E',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(322,'Klasse 07e','klasse','klasse',59,'07','K-07E',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(323,'Klasse 08e','klasse','klasse',60,'08','K-08E',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(324,'Klasse 09e','klasse','klasse',61,'09','K-09E',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(325,'Klasse 10e','klasse','klasse',62,'10','K-10E',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(326,'Klasse 01f','klasse','klasse',66,'01','K-01F',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(327,'Klasse 02f','klasse','klasse',67,'02','K-02F',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(328,'Klasse 03f','klasse','klasse',68,'03','K-03F',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(329,'Klasse 04f','klasse','klasse',69,'04','K-04F',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(330,'Klasse 05f','klasse','klasse',70,'05','K-05F',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(331,'Klasse 06f','klasse','klasse',71,'06','K-06F',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(332,'Klasse 07f','klasse','klasse',72,'07','K-07F',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(333,'Klasse 08f','klasse','klasse',73,'08','K-08F',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(334,'Klasse 09f','klasse','klasse',74,'09','K-09F',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(335,'Klasse 10f','klasse','klasse',75,'10','K-10F',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(336,'Klasse 01g','klasse','klasse',79,'01','K-01G',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(337,'Klasse 02g','klasse','klasse',80,'02','K-02G',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(338,'Klasse 03g','klasse','klasse',81,'03','K-03G',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(339,'Klasse 04g','klasse','klasse',82,'04','K-04G',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(340,'Klasse 05g','klasse','klasse',83,'05','K-05G',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(341,'Klasse 06g','klasse','klasse',84,'06','K-06G',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(342,'Klasse 07g','klasse','klasse',85,'07','K-07G',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(343,'Klasse 08g','klasse','klasse',86,'08','K-08G',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(344,'Klasse 09g','klasse','klasse',87,'09','K-09G',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(345,'Klasse 10g','klasse','klasse',88,'10','K-10G',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(346,'Klasse 01h','klasse','klasse',92,'01','K-01H',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(347,'Klasse 02h','klasse','klasse',93,'02','K-02H',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(348,'Klasse 03h','klasse','klasse',94,'03','K-03H',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(349,'Klasse 04h','klasse','klasse',95,'04','K-04H',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(350,'Klasse 05h','klasse','klasse',96,'05','K-05H',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(351,'Klasse 06h','klasse','klasse',97,'06','K-06H',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(352,'Klasse 07h','klasse','klasse',98,'07','K-07H',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(353,'Klasse 08h','klasse','klasse',99,'08','K-08H',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(354,'Klasse 09h','klasse','klasse',100,'09','K-09H',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(355,'Klasse 10h','klasse','klasse',101,'10','K-10H',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(356,'Klasse EF','klasse','klasse',162,'EF','K-EF',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(357,'Klasse Q1','klasse','klasse',163,'Q1','K-Q1',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(358,'Klasse Q2','klasse','klasse',164,'Q2','K-Q2',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(359,'Klasse 11','klasse','klasse',165,'11','K-11',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(360,'Klasse 12','klasse','klasse',166,'12','K-12',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(361,'Klasse 13','klasse','klasse',167,'13','K-13',1,'2026-04-09 11:33:09','2026-04-09 11:46:47'),
(404,'Herr Waedt','lehrkraft',NULL,NULL,'M, IF','L-WAE-001',1,'2026-04-13 22:55:37','2026-04-13 22:55:37'),
(405,'Herr Hanslick','lehrkraft',NULL,NULL,'HW, IF','L-HAN-001',1,'2026-04-13 22:55:37','2026-04-13 22:55:37');
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
(17,'9783060066704','Wolfgang Hecht, Reinhold Koullen, Jeannine Kreuz, Frank Nix, Hans-Helmut Paffen, Günther Reufsteck, Christine Sprehe, Rainer Zillgens','Cornelsen',2,'2013','http://books.google.com/books/content?id=uGVDMAEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api','data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEBCQEJAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsKCwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCACxAIADAREAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDwm0+Ikmn2VxLY+F5LS4tTKLqeMyObUqGO87PmjxyvAxhfY189Uo+/ueNe5zx16XxV4du47KRLm4gSR5YbJikLQfxNwflK7+CQG67h3q+RRqxuwcXuc34cg1rUJrjWNPtZ/sEEQkummy8rhV+dkGAXlXbk9CCOMHAr0b0+5JteGtdtb74f6nrtnokN5bWsn2e5mvGhIgLZVR8w3MDnGMjr0YZrjxL5eVwHZL4jY1v4IX8tvBf2NjfWt4LXz3eSwaO0mlLZJJCqFUq7KCPlHBzwamWOlCNg93ua/iXR3vorSy07y9Y1G2XDm41BSREoIZpElkAjRVVycDgd+a89YmrOXMtiHvoNl0DTfDnh1ryW0s9c0VpVha4F0ZEgmWNiULI4XzOhAGGxz0oli6zFdnnOsWNvbnWHXVrJtOtUjulsZrqWS4Q70XJO3aQN+Tg5wDz6ezhKyxFkyknIXwW9147+IttB59lHbW8Mt28t3IzoY4wMFVx1yYxgHGB2HB2xbUKcoo29m0js9N1PT/iFClhpM2n3DJDLczQSWbxG6kVwB5BZhulG7O0HkDpXzsZTpbkuDRRurLRw3heeK5s7RZLa4Sa1MM6ujLtWMzjOEb5MgDhucgYFdDxTkuVi5WyTRYr+Oaa9tbKRpp1D6XdS2ZtC5DYkMJdgJM452c5AHUiuWc7rcw9jK9yl4gi0nSr+TSb6a/t/EslxEVtYbZTEjKCrKyhsiTkEqzAruGRTi26bfQ2cUlqd8LtrzUdJ07xJfXsmmXUEpt/spiiJm2BxHgBkChlB27QS5ZiSWyfPje7ZnCMb7mF4Q8O6FJ/aVxql3rE1kyAWtvpsKs13E3UoCSQmQfqVfJredR2tcIx5ZNnoXhzUPC2nx61pNnZC+a9VEEElxIC6qisCEY5YeWwwVPzKDgcV50pSvc2vdnjenav/AMIqt/CBDa6xc3Bme6TdvYDGTgELgqwOR0Ib0NfRVK/PK8TnpzTZ1vhjxelr4msL/wAPeGdIi8aXNr5E80Wni6up3yySRG3IeNjIRuJEW47uvNclbESbUb6HoqnOcbJGV4P+HnxA0y5QWUaeFmiDXE8q3MWnPGsnmR+aYY8PkGOUfIhOY2FZTxCveUiHh6t7NG3F8APjB8RdO1Cd21nVbK3WZ3uNYvZUUARufvXBAxhWI6jI9eKFiorVO500suq1b8yKfgP9mu88feJWh8KXf9p3unXiQ28tveOY2nLMVdMxnH+r3Ej7oYMxCgkZSxl9O5by2256CP2QvGP/AAm2tRafrNvca0tw2l61cWmrTmWAeWsv70so3g/J0z92uSrm0MMvZv8AI5KtOGHdpMs2v7C/j+w0mDRodVsl0u1uUuY7OS7zEZBnDlGjwx5OAck/SvNefRk7s5lWoPaR0Pwb/ZJ1T4p+NvEcGtalaXdv4Z26U91czvKvnId6QiJSFMecMQV542kYIr1KGMlH3qfXU9jCUVPVH0Ze/sM+G4bLUDpurLFdygukJ05TGv328sHdvVSWI4I+nPHRUxlR6yPSqYVqN0j5K8B/s++PNetbfU9J8UWFnJp88+nDypcTWhhLRskcqAsqc7sKyj5icc5ry6+aRp6T0Pn61alTdpOzNeL9lv4n6Fpd2ml+ILWCWZwZILFjEsyk8lmAXf1ZiGJB3DIzXNDNKUpasyVSnG0m9GSWv7KHxD1fwZD4p0vxbY6vpH22ezItVKRo0M8luZVjChQ3yYD8HZjJAr1VPnjzLY9aNHnjeJxPgT4YeM/iE17H4d8c3erT20xtZYBeusi+Si7SiGQExhWGzblRkgDg4ftPuHSy94hNo6Lwp+z8PFetavpPiDVY/B2tB4pNPvbu1mXT7t8FUIyS0bhhvLBiMvjaMGl7WC6kSy5UX+80OG8RfDzV9L0dtR0iG117Q4dM0yyl1LwyrSGHfHHF5siKMpIzR3DsGGSWYk886rlqSuclXC1EvcV0c6/iue3Ed1Ncw6gIZvL/AHkvnKsiq3mMN2QNzwzOpyOHGOCKh0+h5zUqbtI93b9kzw58PvjL8OfD/wAUfE8NxZ+JGlc2tgBDbxeTER++kf7quBsAXaeRg5ro+swjFuLPUVKlFn0/8FfC+tfDDwhd6LZQeBvDl+NQu/KvbG+ikuntWlLxrLIRlnUEoS2fuivnsRiZVZclKVmzWUvdcYNJh4a+EPhbw7bSAL4L8iaaS/nuLq+jupHZyXL75Ax6+hx1x1ryXTxU561F96PKlTxTlpUX3nBfAfw34n+PEWheJLnw/wCF7Xwx/Zzafd2dxbr51reRz7jst2jwu5D1B7gV7UsDWjFNTvr+B3xwuJqW5qmh1PiPxl8OfgT4fvvCfw38TeE/CurXpkN5rGoXcjXBlc/O0ZZHDEMd2M7U54FesoxhC8ldnpqjSow/eT1PCry70DU7y1gtfiRpieIbqRpLvUE13UNt6xAB3KsYAwpznrgEk14danHENzS/A8qSp1qmjuj1jQP2VPFviHTDqQ8QaTBlyXXTtYvr62uwMESMVkB3cep6elZ08vjPSx3rL6LWh1XgzxBH8CdPvYpIdJuG1O6Es99rfiBNEkcg4B8i5wxUEsdxOSGHpX0WGw0YaHo06PsTvZ/2g/DdoCYPEvgCa4BGyFvG1qhYnr2bNd86CZpOtLornkUvwJvfHGqalqnhrxUujWS3H2iWK9t7yO33sdxaK5DJFOpORuUHGecHFeDiMBCbuzCthIYpc1WNjyjxxZT+FfEVmzfErQzDcnFqula9e3j3TK3zDfEHAZzkhCS3HGdtcLy6hb3uh4lTA4en8Mr+R3vw98a6t8L9Xt7nS9U0u10F41W40e+n1J4ZFZzlsyW5xKRn5uvUMCBxVGVBS5ec6KGISfs3sd34m+Bvgr4i+FfFPiL4UaZ4fbXtWM0cou4niRLpS6bjvTdCyndxtHTjjFdOIwtOrOLp1PdR0VsFUrT9pSnbQ4jwTCfHnizxnpHizSPC9pq/hye0sGutWVFF2/kKsvlySpmRY5Y5FVhj5SvFeFiMEqdmqn9XPCnhpqrapU/E7rwn4RHww1TUb3wjd+GNOn1KaBtRhsdUjSGZUUqjNFkKvcZUAk7jWNGtXo25pXRvCVWk9XoePfGr4Q+GLjT/AIneNfF+k6DLP59onhbT/C+o72WPZsnMiIAMsdzdDjOAcV9JTzKjZRb1PQlWo8jcrXPYZo2027vBcahpC6nljPHNrdtHKxGS6uGlDcHPXjHXivlXhMU92eJLBYtdTyj4lePb6w8Z3fg2zETpf+GLuOO+F1D9ktb5o2EDNdbvKRiA33nHIHcivTw+WSfvVXsyo5biZay28j2z9nb4J+I7LwP4dtPiFZ29jqOnQJaSw2dwsxkVDtjLOvAGwJ65x15NdUspoSquo5NK530sppRXNNu/qeKaN+0T8R/2hPgrZWPg/wAISx6eJZ7TVbnTNUsLXzFWQkQIs06Oi+WRuOPm2NyckV7S9lh4+zvZ+f3nqL6tFOFORzGh+BvjR4LsQvhn4eXulS3EZju7qHX9LSa5G1hGEc3BZArMjDB+8S2ckmvMnSjVl71Zfj/keNVwSqSu6hfj8JfHC80XVdJvNA1i8sryMwxyS69pN8/l7uWYT3DAOq4cMMMGAIPFKGHpqVo1EbwwMVDlp1LHntp4fn034u6f8NdP8HQ+GdcfTYXGnxXFissswdpC4eOYIS8Rx8rliE6Zya7ocy95y5vM7cG5UZ8jlc/S3R4X0XSbLTo7iSUWsCQl3csXKrjJLEk8+pru530PonFPWxba6k2/LJyB/d5+nrVc0krkWXY+J/8AgoEX8I3Oj+LHsvten3RhsT9ouIxbvI24SxBDJvz5UasCFAGCS2awrRlOSjfc4cZUnGFm9DkNP+FvjXRIPK8H/DxfCtvcrHcJ/ZepaWpOQn7zcbsE7lXqfmxJKM149eiqk0q9W/3nz8cDGX7xVbNl658OfHQzI8Wka+VEcalG1jR2UgAhmINwRknGcg9uetYvBYSP21+I1gLO6qo1PCUHxe+HPi2DxLo3gO8soGObu1m1zSlhniGAySA3XzEKMqw+YBQOcA120KWGoxac0z0KMfYq86lz1v4F+M4P2r/h/wCJNY1ExWGp6b4lvbC2Mbq0otPllt1lA4JVJSgI6+XnOc1z4rBRr2UdLmdXD0sdL3dDwX4m33jn4IeNfFmteI9CtrfStXutPsNE8m9hnaSOGQhmVAxYBkedvmAwXA7VzTwd6Uad/hvf9PyRw1sHViuVPY9gS400zyIuq+HPPZwxjTW7JpQD04WbJB7V8/HB1HdvoeVLCzT1Z5B40+EH/CX3Gm3t74q1fxFqWokRaboB0mJp3Ln5j8wLrxuZmJAUfMeOa/SHKDWx9nXw9GrrGZ7tp+laN8NvjL4L8IeNxZSyaxZXt/ptrDEUtLSaJlcKR83mSn52DM2AVG0ZxWE6qppya0ClOlhYNqeqOg8e/ENvFimKINbaGrFCkyfNdHGOR2Ujt7818jjsfd2ifMZhmLqS5YbHH6Zpml2VmqabptnpVmrHbFaWiRoGbjOAOuT361897erOXvM8mSkkpJ7nL+GfHFt4u8YeNtCktgk3hueKFwmNzI8YYfhvyuPavVq4WtGlGonuOKnLqTeLtdtvDvhjWL+5VGSx064uCoO0EJGxCgDuSB+Vc+Dw9erO6ZvGNZvliUP2FdRs/ij4e0LWLqKC81HQLWS2u53VJJfNRgI1J+8Mg5x7emc/WfUXHENLRbr0PZyqhVjUvUPsHf8AOWU9fevcULaH3LatYfsG0FgMHqM1rKN42MW0eY/tGjTrH4XXXiDUba1lh0UtdMLmIS7VOQNoIPVmBI6cV4+bUaj5OU8TM4SlT90+V/2avHlj4w+DenNN5T32lXU+mXOyMABRh48Af7DqM9c189mWFrRrXW1ro+JjTxDjZnU/ETxrY/Dzwk+uzLGY3uYLZYi+AfMcLnOOwyxHYCvLwmGrYmTV+/4DaqR3Z2MTbJFZSS2zMGR99eenOOmK5lGortsiSm1e5Y8HSx+FdbS/0a0t7C9dczRrCIluhkkq+3gnk4OMiuqjj6lDQ6sNjKmHZ3HjL4w+Gdb8SfDjwlPaOdV8WX00GEJjn0/y4i3mK3Qgttx2O/619pgsR9Zp3sfWU8TGvBN7s8o+OH7M1rqMiXd/b2+kS2AK2NxozGCPUZFTCpIB8sbfLxxjqQeCKqFoztY5auF5mmew6l/whX7K/g258U61O5kupUt7nVJiDK2eQqjokeRnAwMkk8812csou0UerKpSw+5ynxm/Zsuv2hvHHgrx7Z+PE0vTtKiiuNJjs7ESCSMsJFfcXGQ3GcdhSlSlWhKDXxKxzVMPHGR906Gf4L6haW0l3deI43S2DSyEWrfdUEk43cnv+FfM1cks9Tzq+RpR5uY5j4ceH7D4xeHjr/hHxtY6pp6XBhd0tJAUZcb1I3YBzUyyfbmWxzU8n0+K5geAP2Gn8G/E7VvFUnjq4vbbVRKbvTYrTYrEsHUh9xOVI4z0yfWvejh3OjGjKOi6nfTymEdWe72fwV8EWMahvDdvev5Zjf8AtAGcSA9dytlT+VdVDA06MbRR6dLC0qDujc0Twho/hqGWPRNF0rQ4ZGDPFYWcdsrMOhIQDmupUEndHYnFbGtbaeikKyjpnPFdapIwlVlcstbW8q4YDb2raNJGDrMju9Kt9RtZLW6tIrmCVdskFxCssUi+hVsgj60q1NVbc3Qp1FOPLI5Wf4ReDZIpYI/Cei2qSsHdLK0S23MP4j5YXnHGfYVw18Gq5lKnRaszxj48fsS23xo0mx0zRvER8Owx3TXD211CbqORthVQBuBAALmuCGW/U7ypbnDXwVFq6OZ8LWGjap8S2+FL/ESC+8a6TZoZVfS2RXZQoKp8+ScckDgDHvXzksqqVZuXRs8VYSMpWTPUp/2bdVabdH4nhgdl+Yi1dTn/AL6GK6Fkko6pHUsC0vdPIviL+yrf6d8X/AHiXUPi/pWiatHdRQaNYXlkzSXEyMX8tP3mTu5yf9rFexhsMsPG0dzpp0oUGnfU+vbrTbq8tTbalDbzebGBKqqVRznsrcj8a6nQcndo951IcqPir/gpP4juvFXwL+HFtLbXmi3WralJJcWU8UitCqKQ/mKqltq454PHQGuqEtmfP5gpT2O0/YR+MItP2Ubg+LzPDeeCma0ngkH754vLEkCIGwSSpG1cDsOSDTqTVOTcNjpw1VQpWbOg+Jn7XPhjVvhR8SbLSDdaV4msdAuCiXuxtkzYhCAoxLyK0iEqOpOBmsPaurIWKqRlT+M+NP8Agnf8b5PhR8V7/wALa5dQWnhbWYZrmeW+lEa20kUbSNLzwBhWyfRSecYrpnLkipSXkcuFr+wvaV7n6aeCfiN4U+J2iyat4U1m01/TkkMRlts5Vs4AZGAZQexxg9s04TjI9ynWnU2OijuIWcgqxB4+RS2D6cd63ujdxktzw74/ftLWHw9gbTvCOs+F9Q8WWM6Sahpur6nbweXb7JNyIGlUyT7wn7tNzAHkLuTcXRFmeSWX/BR66lFqZvhrYyLJEGZ4fEHy5xzj9yeKSqJFui+46L/gove3H7mD4baeJcHaX8RrjJOBnMQH5kVr7XQydFtns/wP/aV0v4i3beHdf1HQ7DxuMyxWWk6pBewXcXzH91JDI6mUBWJiJEgVd2zb81SqlzN0Gj2b7d0UxShssCDAwPUYPzAY4IquZrYj2b3RgeOvib4f+Geif2j4g1W201JVcW8Nwf3ly6qTsRe56ZPQZ561yVak3oc+InyR1PyU8K+Nde039oK0+IsK3lveXWpSXqbkCrN8zfu8A8IQWTPHKtkccc8JOKPnYVZzq+7sfrjrnxR0Hw2umPqM6xHUUM0UMWTJgDJ+TrwxwT7irnjfZo+hcpxjdn5X/tiftBat4x+P48Q6ZcbtP8OXoGjr5mBE8T9eMbCxTkNyd3FZU3z3kup4GJxD5z9PPgl8XtJ+Nvwu07xfa4to2BjvIXwRDOqgsCe/BU5967I1IxVz2afNUgmfEv7V3jHTPiddWFrfTQQW1lHN5UCXBLM0jDcVB25wWblcg7QK8umpHNip8+xX/Z5ubTwrc6prmr2+gy+GpZ31Gaa/vHRYZ42Z1cFAcsgydp67vlB4rWybtIeHs1yyOh+L/wAMPh74n+Det23hbUdI0Y396bVtRBnng4cboYpxHhhviDDBIyCAw3VlzqjPTU9HEYen7M+b/BH7LOleGPEqa5rHxC8Nx+G4oZZLyOznuGnCPw4VFj3L8rMozyD3OK7quMVWCUonm08PHufT3grwN8OfhDp1xqXgf4xz+G9O1gpJdTabpst+1wIwSF3GNiqjJLYHGc54rlhiFc9ylGMFod98Uvjl4a8XhtKsfjRLp1nfWpzZ+FPDF7qN0NykFhJDG7xnk8HBBFdftJT0j/l+Zbqa2PE9N/Z9t/FPizQ7C21f4g3Usl+ZBJrPw41C204MzZ3FpI0jiQ45JwCTk1UVVSu0vvX+ZpGpG9mz7Ps/gF4KtIIgPh54X3oOfK0m2UH1xkV3wh3QOa7kj/CXwrFKiwfCrw4mTgTSWVopHuOaxqxa6CU0ne58IXnwf0Xwa19P4g8f+I/A8JvpAgufh9qn2YHewDozRGPOF+WUDgD5T0rhfPHoKrW5tj6n+FfjmKGxtbHRPjp4Y8cXUdukaQanaIZIwEAVn2SLLng53496mOJd7MyjLmWp598WPD2n/ECS1bxN8R9F8WXenNNLpmxVhj05ZdqS/OhIdMhRySR5WSTzWM69zzMS0z5C8TeAdF0CC1hhvbWG0mllSW4g1ITSJIX3INgJO3GTkAA79wzk4um3Ujc8dLkeh9H+GtVg+M1h4U0W88T2OjaX4aWC0t4YmAlu3zubczN1yBlgSOM4IIY8lWD6no06mmp89fEH9iH44/8ACV6xDpHhqz8W2CTNJHqNpr9lFFtOZeY5ZldAAwzkAnHQ16tOpR9mlKSXyv8AkYLDXm5NHvep+NvEXwQ/Zs8OfDyPQH8P6np1vE13d2OrWzGaV13F3aP5Su4oN27kAAHjA8qpN1J3Xc7HP2cbI+I/ih4n1LUrtIXeI7F+yui3KAoS2UcEg4UtjdjHPUjpX0WHoRa1PKpty+I7X4OePLSwgMV9JLLp8ckvkRNLKpcYBxuGGG1diFtoJIJBbAJ4cZh3J2iaNtOyPbtZ8YWPh3R/FE7I7S288F3aNeXT3MyIY2ScRyOCFG4odkZIACndgivMpULTSZ11Jc1OykfJXhHxjf6D47XUJb03L3TxpLPM+5Iw5A3E5BwpfHOB9eh+grYdVKaSVjlgmran68fCH4BfDbUvCWkeJrnSE8V6neqt7Nfa4rSgTMoJYQNhFboDgfiep82OGjzHuUafMtz2mK5ttI03ZDHHpunxABYbSMIq+gUAAAV6MaagrWOyNHlZ5l8cfG3jvTfCFmnw6tLa+1/Vb02kV5qDuthpkYRzJPcFVLNgdI8YLY5JAVvQoRi+hx4qcqeyPMvhV8LPiTN4w1Kfxv8AFy+1W6l0+8P9moYYLS2aRFjDxINxCpucAkkZYdCK9GNKB5CxUyCLRPi98LJrq+8NePD420uG4VZtH8RiON1h8tnCQzoo2yHOwfKxJK5IwSuNSlFarUqGJlKSR9MaD4wS41R9HN4jatb2kF5cWe9TLAswbYH2kjrG44POM45yfIqTg3y9T26cOZamF8SdG8Lz+H7jVfE+i6NfWtsMy311aI8kC55dWK7uPY/n0rza1NbWFWapq6PzC17xXp+tfEW4udJub2w8O28kpt7m2k/durbVZNjbcqrc85OGB4zgc3slsfM1a8nM8U+JnjG58ST3MFzF5lzEY9gkXB3Kx8ok7huO1j0B/Tj0sLTUUS3d6lr4S6wkPiKN9SuozZXkvmI9wAnOSCuCPlGcfN93jqTmsMZTaWg1Jo+rvDnw23eI7LxFpVpq9hZacot9SiuzbM0MxDrhWDEmCQIAWZeTuXtkfOSqNe6z141EoI+cfiHrmq3uvarYRwDTrC3mW9khbMagJHlZBCo+ZMHblV5BDYA6e1hKSkrs82rJyeh5L4h1CbV5ZZlvmtyZd8WnynymaQFfvZyDnrkHIxyBX0NFcokjX+FvgLxb8VfF0Vv4B0hvE+txaaL6LS7SVVkgjSQJu3OVA24XO0kjIwcnI1nSdR8pso30PsXW/wBkT4/618IrvQx8OFF35m63VtW0+K5+cYclxOVxjk5IJI6E15VLL6yq872H7Fnjdp/wTg/aS1eVoX+HFpokDEFmudcsJUA3ZIUJMx6EjnsTXuujJK17leyaP01/ZT+DfxE+FHwo0/w143k0Ka5tldvM0+9nnwWOdp3xqBj1BNeVPBVOa6PQoy5D2iPw1dMhjf7O8B6ozM39K6I4arax0/WLSucJ41+BGqa3NPeeGPGV54P1CYKshjt1uraTaQQWgchSRjAIIOCa6qdCpDqZ1aqqGLP8CPHmrBU1jxX4P1FV2kzr4XuIpm2ncASL7GCeSMf0x2cpx8sOxfuvgRrskRSx8a23hmSTCPLouiorEgYBTz5JQrd9wGfc0coWgtUi58MfgBoXwU0zXNQk1vVdf1XUGa+1fxBrMolurkqowSVAAVVBwqgD26VwywkE3UOlVmfO/wC01+1X4RuvhVejwXrtrrM+ogwBhBON38JZMx84LKCB6+xr5adSdSu0tjjxNV8p8VRzvo3gw3uqana3erzWLRLBp5ZzPGOpUYUlgWKnJHMYIyDmtoUnKWmx4bUnK54XrVlrmty3VjY6Hq95bXwiLpYabNJIg354XoOS4UZzjjvXu0KDirs7oRcldnT6T+z98Z570apYfCzxteQkjy7kaNdOkxAKu2GjBDbgSAw4JPQAVVbDuorFum2fTmt6V4z8LeBbBdd8Ia34VXUY7Sx0zStRvJIN8qkrLKkRGFlLSBir4+9xyOPjMVhJQqe8rGs1aKPnDUH0q41u6mspxqc++O0eJd8M1rE8IEgxcKu4KAVd2Ybicg4UsfepJwp3f9fccqPOI76W6+xJBLHpc1kq3DXFzcAqmG4YIerH5RgAgZBO0ZI9ayWpvBcx9tf8EdbAax8afHOp3hLXulaGsMfybQgnudzdO58sZ7elddGKfvI6YpJ7n3t4h/aaXwt8RPiN4PvvDavqPhnQodb0wW+ogvrZmLRxWqK0a7J3m2RKoL5MseDlsV03s7mh0nwt+Pnh7x54U8FXuo3mnaD4g8U6Vb6tBoS6h9okjSa3a5jTeUTc/ko7kbRxHIRuVS1F22HmefeHv25PAmvyeAtWu5IfDHg3xfoV/q1prWv3sdvLBLa3cNu0EsQ3IM+cX3iU4EZyABmnewR1Wh65f/GzwBo97rVle+MdFtbnRoprjUIpb1FNrHF5ZlZ8njZ50W7+75iZxuGVqF7md4f/AGj/AIW+KdVOmaT4/wDD99qHlTzfZo75N+yFQ0pwT/Cp3H/Z+bpzTd+gakN3+0X4ITWPBmnWGpLrT+K9SutJsZ9PeN4o7m3tpJ5FmJYFOI9vAJ3OmQAc0XFyo5jwJ+05pfiDXfs2u2uneGtPl0LSdatNRXW47uK4a/nuoI7cFECFxJatgo7hty9DkU0m9A5Ue1ahcRw2N1I5Xy44mZ9/QDBJz7Yrnq3nTcYsrY8m+EUXg74j6ZrupRaVoer2ttq7W8EwsY2C4ggbjKnnLdR7VwYGlTlBztqTKOtmj0XTPBfh3SJBLYeHtKsZF4329lHGw5/2V9c16KpxT2Dlj2N0bjnJxW2g2IcgnJJGakD5d/4KG+Bn8YfAZ9RgivLmfQb1Low2IG90I2PztcjG7sDyOQRXk4+kpw5ktjKcedbn5nfDvSL+0sL6eW2Fzq3yssEMkYimtCkcqO5TAyN4JPZnKsmQcfPTrRl7sDisk7XNI/sc21/dNIPEUtnDIsmYbfTR90Avjdvyef6V+yPhm8uW5+H/APESHyf7v87n2v8A8EzfgPY/CUfEHWhq1xrWpajJbQyXE8QjKoqsxGNxySxJ9unNeHmGX/2ZJRv0P07hvOpZ5QdX2XIlpvc+hPFf7NGm+LfipH471DxJqh1C2lWa0s1htxbxbEBiVgY8yBJo4bhQx4kgjPQEHgi21sfae0hBWZieGf2TbTwtrnw81GLxzrtxD4LgsILKynhtjE62tncWa7sR8bobmQNt5zgg8UcrkR7eEL67mJ4d/ZC8O6n8MbDQdH8fapeaFF4V1jwfb3UMdtJusb+dHmO7Zguvkogb2ORmlyuO4qVWNSLcTY1/9i7w74i1Dxne3GvaibjxNZapaSStDCz2p1CKKK6eIlOMpGwAxgeYc7tqbQqKsTa3+yFZaxqh1GPxvr2m3o1PUdVjns47ZHinvNMGnOUPlcbEy6nsx5yAAAon8Dfsm2XgaXRbmDxbq19f6b4pn8VLdXUMBLzTae9jNFgIBsMchYE5IYDk0Ac/p/7DGiafqnh/V/8AhMdbk1rw7p1lYaRf+VbhrQ213LcpKE8vazsLieFtwI8uVwMEk00TLY9/8Uwxy+FNZWRFuFaymRllXKuPLYEEeh71MKN58vcivU9jSlN9E2fOv7HlvL4W/Z/u4/DGiadp+NebNrEoSGONhCHfBdckLnHzDoOvfpr4N4Kfs311Pn8hzdZzhpV10k4/db/M9b1nxF8UtGk1c2XgvQ/EsQuUOnrDrbWLmBlO5ZN8LgurAHIIDB+ACnzc59KVbDx98UZ5YBcfCmG2R1dpmPiSBvKIB2KMId+SoyflxvHXBIAL/wAMvGXxB8TajqcXjP4dQ+CrW3bFpcRa9FqH2rheQqIpUEl8bsHCjIBPABo/FXwRa/EX4c+JfDd7A1zb6nZPF5YfYS+MpyOmGVefaplGNX92+pzYmo4UpSjC7SPyxf4OWusNFfXGo6q9zHYLA2DGscoU7UDoFAIUABR2Cjr1r3IcHxnBTva5+D1OP3h60qUqWx39hHEJ4szRjCS/3v8Ann9K/SVdz5mz8elTl7NxkkfYP7GVhb2vwrvLuJQ08+oyJI65w21V29frX53nc3VxSu9j+kfD2CWUOor3cn+BseI/CHiLUNd8WXdlp2pwKXs/sbC9jWO6gDxm6SNfMO12RWUeYqDJ6gEmuKnWUUk7H0OLweIrzk4KSfTUx7jw144Q6I9toesBLC6guYN+pWskywC7BmglHmBMmDIUKWGODJxg6+0pNM4lhswhOKnBtJ913PTfhVZahpfhU2+pabcaZcC8u5PJneJzse4eRTmN2GCGHU565Arz604N3TPpMvhUpQtOLR2itxziuZST2PZafQUmjmQDN7f3TVXQcr7iOWZCMEE0m7K6JlByTVzJ8TNjwxq+RtX7HNnPX7hqoKf1im1t1ObHNRw1Xme0X+R89fsqaJba58AbzTrjTodZtptbbzbaSRo0ICwHJJGSFxnHfFfRZ57P64lfSy/U/N+Apz/sepKnG79o/wAonYan4AvYPGf9s2vgu5vmawFu7HxRKkTHcfk8knbuwznd/tYrwbU+5+gutil/y6/E6vQp/FOkaENPtfB8EKWWyK2E2rCQSxYY8uQW3DAGTnO7PqKLU+silVxUvsJfM3v7R15ZoW/sW28oxOzhbvJD5+XBwMggZPHWnyQ6SJdbEr7CNe0a5aPfcwJE3ICRvvOO3YVha8kdlNVH7s2rM/Pj4teFIvB/xT8W6WJIkQSyXECrGVURyOJFVQB/CH256ZU1+m5diHiqEVN2sj+S+J8G8LnFalF+6jnbDUFR4yLucEJMflt1P/LP/fr1KnxWR81GjaT96+jPY/hr+1HB8LfA+m+HoPC0+sGAM73bXawbyznB27W7Y718tjconiq/NzWv5H6tw7xpQybLY4eVK7u+tv0OuX9tbfIkf/CGOu648kA6gCBzj+5+lYLhpr7Z63/ES05Plof+Tf8AAOdvf21vEUkfmWmiaZapt3bZYpJiencSJVrIFH4pnHLxMxEpNQoJW8xl3+2J4vs5JEWy0bCmPP8AoUo4Zc9pzWschpdZM5KniTmD+GlEozftb+ONSMYiu7HTt0Ur7rfTN+SFJH35D3ArpjkWGS1ZxS8Qc2m7pqPlZMx2/ak+Inyf8VQBlFJH9j2/c/Wq/sPCnO+Ps5e01/4ChJf2kfH16kAfxZOm+Z0Jh06FDgBcdD71qslwiOSfGeeT1Ve3yRzsvxt8bXEc7N4514YTI2qij7wHZqf9j4Xoc74rz2o7PEbjtX+KXix3vYm8a646NIIypIwVIbI+8fSuxZdhYJSSWh564mzWTmqtRyT03Oz+D/7Ry/CfwlJoi6DLrjy3M1+biS4FvtBA+XbtYn7p5zXjY/KXjKntovTbY+u4d41hkuAeHdHmfM3vbdLyOi1f9tbWJmQad4bs7ElV3NeM9wORn+Eof5/hXHHIbbs9ifiXU6Yf8TLm/a98Z31lH5S6XZSSySR+ZBp7tjaqnPzyn17iuqGSYZfxLs8uv4h5jUd8PFQXpc5wftSfESWKbPinGCMbdJt+OfXNdccnwC3T/E8ypx7nb2mv/AUZGsfGjxpNqN3/AMVtrUey5ZAIUVAFyeMB/at3lWFt7qPN/wBbs35/aTqs5y/8S3uu3E11qWs3+oXbWu0z3EKliA3AJ3/Wu+hQp0laJ8zi6lXGVpYqrO7ZSsLCXzY8TWo/dzdbpAfufWtd3c54pQd4lWTTpWigPnWeQg5Nyh/iPX2rSK55WZEmoR2uke0+FNP+E9voXhm31jR9S1/xRf3LhotI1BSY5jMVjVlM6AEqU4GfWvi688bTnNKVku5+sZVhOGFRw9PEKcq1ToujvZLy6HEfGbwjoHhj4garpfhZoYtNtIUheOe7JZZh98ZdiT1Fe5l0pzw6lV3Pk+IsJg8HjZUMH8K7736nM6rp8ouLnE1n/wAsP+XpP7n1r1D5YZp+nS7rf99Z/wDHvN/y9J/calZBYrtp0gEX72z/ANWn/L0nr9aOVDLltpshS1zJZ/8AHzL/AMvSei+9LlRhZXM9dOkFvcfvrT7g/wCXpP7496dkik2ndGhq2nSfadQ/e2f+vj/5ek9G96LJjTa26kcOnSADE1mALaTpdp/te9Um4qyFdshm06QSqfNswdkfP2pP7q+9O7EWoNNfyLXEtnk3Fx/y9J/cT3o5maR0Rnpp8pt5z51p2/5ek9veldlXZoanp0g1C+/f2g/0x/8Al7T1PvSMZe9uQw6fJ5bnzbTP2c9LpCfvj3pJJCsrWFsLibzI/wDR4z+7m5MAP8H+7TNiq08wihxBB9wdbYY6n60c3J7wO3U9j+EkSeDPD2v/ABD1CyhFzaTNZaFBJCo828kyu/GBwnUn03Y5r53M17bEwoR2e/p/wT9G4dhSyzDV88xUk+RNQVr+9bRr0PG5b67uvtVxcRpPcTM0ssssClpHZtzMfck5NfQKCpvlWx+e1qk6taVSo7uXvfeXNVuJ/tNx/o8X/LHpbgfwVRmMsJpi1v8A6PCP9Hm624P8De9AEDSzYi/0eL/Vp0th6/WgZZtrmbba/wCjx/8AHzL/AMuw9FoMmUUmm8m5/wBHh+52gH98f7NAjQ1e4m+0aj/o0X+vj6wj+63+zQBFbzzED/R4v+PWTpbj/a/2aAI5Z5hJ/wAe8Z+SP/l3X+6v+zQBZt7if7Pa/wCjR/8AHxcf8sF/uJ7Cg0jsUEmm+zT/AOjR9f8AniB/d/2TQUXtUuJv7Qvv9Gh/4/H/AOXcerf7NBkyKC4m2v8A6PGP9GPP2cD+MUCLNhbLuiP2S5P7ubkXCj+D/doNSrLCv2eLNneY8v8A5+lHc+iUCeiNVd73EEbwX7xpqOQhvAVByOcFcD8BQawqtRsY4gAt3/0O74QdblfUf7FBzN3Zp6vbqbi4/wBDuv8Alh/y8r/c/wBygCPT4FDQAWd3/wAe83S5T+43+xQaR2K7W64iP2O7/wBWn/L0nr/uUFFq2hG21/0O8/4+Zf8Al6T0X/YoMWZ6QDyZ/wDQ7zGwdblf74/2KANDV4AbvUCLO7/1ydLlfRv9igCOGDgf6Hef8e0n/Lyn+1/sUARSQgSc2d2Pkj63K/3V/wBigCzbwqLe1/0O6/4+Lj/l5X+4n+xQXHYoxW6mCc/Y7rqv/LyvqP8AZoKL+pwgX97/AKHd/wDH4/8Ay9J6n/YoM2QwRLsk/wBEux/ox5Nyp/jH+xQIp2RjDx5252Tdj/zzoNSpI8bQRYVc+V6H1NAGkPLN3HwnOods+ooJ5TJHlmCQ/L90fwn2oFy9jT1RohcXGAp/1PVT/coDlZHY+WZID8o/0eb+E/3GoKSsis3lYi+7/q0/hPrQUXbVosWvC/8AHzJ/CfRaDKzM5BGbecYT7q+v96gLM0NW8sXOofd5nj7E9moERwmLA+7/AMe0n8J/2qAIZTH5nAQ/JH2P91aALcBj8i1+VP8Aj4uPX+4lBcdjPTyzbzn5R/wE+1BZf1NY/t9/93/j8f8Ah9zQZMigKFHIC82x/hP98UCNCwvAGjH229GI5uBGMf6v/eoNSvLeKIIwb6+/1X/PIep/2qANGO8VbyL/AE6/41D/AJ5D1H+1QBlrfKLeQfbr77g/5ZD1H+1QBoareg3Nz/p19/yw/wCWQ/uf71ADLC9AaD/Tr7/j3m/5ZD+43+1QBAb5f3X+nX3+rT/lmPX/AHqALNrejFr/AKdff8fMv/LIei/7VAFFLyMQT4vr/hQeYh/ex/e96Aexe1e+H2q/H2+94mX/AJZj/a/2qDIigvcgH7dff8e0n/LIf7X+1QBHJe4k/wCP+++5H/yyH91f9qgC1bXw8i1/06+5ubj/AJZj+4n+1QaR2KEd8Ps1x/p191/55D2/2qCi9ql4p1G+/wBOvv8Aj8f/AJZD1b/aoMSKK9Bicfbr0/6MeDGMffH+1QBBY237xP3tuP3c3WT/AKZ0GpUmt8wRHzbf/VY/1nuaAeiNFbfF0n722/5CH/PT3FBPMZYt/wBxKPNt+VH/AC0+lAuY0dUtv9Iuf3tt/wAsf+Wn+xQHMNsLXLQnzrf/AI95v4/9hqehV3eKS3KxtCfKAktz+7QcSe9JqfYfNTjKUajtYtW9phbX97b5+0y/x+y1PtKfVv7gumrplBLb9xP+9t/uD/lp/tijnhLSN7+gnexf1a33XN+fOg5mXjzP96tXTnGPM0P2bSTloR29rgD99bf8e0n/AC0/3qhXe5irtXIpbbL/AOttvuR/8tP9laqwy1b237m0/e2//Hzcf8tP9hKT0NI7GfHb/wCj3H7236/89PcUhl/VLcf2hffvbb/j8f8A5ae5oM2RQW3yOPNt/wDj3PST/bFBLJrC6l3x4MH+rm626H/ln9KDYpy3cxt4uIP9V/z7J6n2oE9jTS6mN4n+o/5CH/PqvqP9mgzMoXM3kSf6j7o/5dl9v9mgDT1W6mFzcf6j/lj/AMuq/wBz/doAjsLuYGAkwD9xN/y7J/cb2oik5XNI6Wcd0V7aW/v9Zs7K1WyEf2Sa7ubueNUjtoYU3s7YQk8DoBzxjk18pnWd1MvVoo/ZPDvgihxdTxFTFOyTt820l+LNCPSvF7xrNaaVpV9YxzttvUuI1jdjA0+w5j3KwiiL4x096+Sjxli2rqkj9gfghw/TfLUxrT7fcu3dizeC/H1tbQqfDNo97cTXNs1is8JnR4fJdxtCHOBIcnoNhzjjcT4xxij/AAkjH/iC/Dk7wWPa0Wt9Nb+Xl+KKGt3HiDSNRtU1jR7KxTUpX8l4pI5gTHEkn8Kd0mRhz0PfFerl/EWJxmYQw01uv0PluMPCfLMgyGtmGDx7q8jj36trsuxJDdTlQf3H/HtJ/wAuy/7X+zX6HSblCTfR2P5o53Feytt1IpbubzD/AKj7kf8Ay6r/AHV/2asktW9zMYLXiDi4uP8Al2X+4n+zUs0jsUI7qUW84JgHP/Psnt7Uii9qlzMb+/P7j/j8f/l1X1P+zQZMihuZtsmfI/49j0tlH8Y/2aBE+l2kcvlP93Mc3DXSqR8mOm2tVG6FKqou1n9xXm06L7PEDg/u+94vqf8AZocPMn2yf2X9xopp0Qu0OEP+n5/4+06ZH+zU8vmL2sf5X9xlnTovJkwqD5R/y9p7f7NNQ8xOrH+V/czR1XTojcXH3D/qf+XtP7n+7T5PMn2q/lf3CWOnRDyOVA8ib/l8T+43+zUKKU9NylWtrBPm9CqumtBqWn39pdm0u7OJ1RzcwyqVdCjqySRsrKylgVYEEEgjk18/mmRyx+smj9Q4T8Qq/CMJ0o4VzjLfdfPTZ9U1sdD/AMJN4kuba0hk1u0kijdreNJdO0phGioyKADa9As0yj0EjAdTXhLhOCSXt7fJH30vGtzbl/Z+/wDel/XqP/4WN40nMhfxLbn92Y8nT9LJ2lkyP+PXkHYhx/sL6DA+Eoy0jX19EYS8ZIta5df/ALekZniw6h4m1WK71rVI9QmsZXMRRbO2BMiIrlvJhTccRRjnONgr1MHw28JiFinUXOuuh5HEHinVznKp5esH7OnO11dy21W5Vh06HaMBP+PeT/l7T/a/2a+tjDli1zJ3dz8NVZTTm0/uIZNOh8z7qH5I/wDl7T+6v+zRy+Ye1X8r+4swafELe24Qf6RcH/j7T+6n+zUuPmWqy7P7ijHYR/Z5wNvXp9rT2/2aXL5le2XZ/cXtU0+I398fkIN25/4+055P+zVcnmT7WP8AK/uZD9hhiilfapxbnhblSfvjttocbDU4y0s/uM6z+8n+5J/6BUmxXm/1Sf7n9TSA0Iv+Phf+vv8AqKkDPb7h+n+FNCZd1H/Wzf8AbP8A9BqiRLT7sX/XKT/0E1kv4gqX8UrydF/3Fr1l8J9DU+BFwdI/+vh/5LXkS+Jny8viZRi6S/T+ooj8SF1LWpfeuP8ArsP5VpV2O6r/AA0Rw/8AtF/61y0fiZzQ2GH/AFh/3U/kK7DQsp/qIP8ArtL/AOgrUspFCL7kv1/wpDLeo/8AH3df9fDfzNUARfcf/rif/QqYmf/Z',NULL,NULL,0,0,NULL),
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
) ENGINE=InnoDB AUTO_INCREMENT=364 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historie_eintraege`
--

LOCK TABLES `historie_eintraege` WRITE;
/*!40000 ALTER TABLE `historie_eintraege` DISABLE KEYS */;
INSERT INTO `historie_eintraege` VALUES
(1,'ausleihe',1,1,1,'ausgabe','Ausleihe erstellt: IPAD-001','iPad 10. Generation 64 GB wurde an Frau Becker ausgegeben. Faellig: 15.04.2026 14:00','migration','2026-04-08 08:00:00'),
(2,'ausleihe',2,10,2,'ausgabe','Ausleihe erstellt: BUCH-GE-001','Geschichte 9 wurde an Frau Becker ausgegeben. Faellig: offen','migration','2026-04-08 23:07:59'),
(3,'ausleihe',3,3,3,'ausgabe','Ausleihe erstellt: NETZ-001','Apple 20W USB-C Netzteil wurde an Herr Schneider ausgegeben. Faellig: offen','migration','2026-04-08 23:13:51'),
(4,'ausleihe',1,1,1,'rueckgabe','Rueckgabe verbucht: IPAD-001','iPad 10. Generation 64 GB wurde von Frau Becker zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-08 23:19:23'),
(5,'ausleihe',2,10,2,'rueckgabe','Rueckgabe verbucht: BUCH-GE-001','Geschichte 9 wurde von Frau Becker zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-08 23:19:28'),
(6,'exemplar',1,1,NULL,'exemplar_angelegt','Exemplar angelegt: IPAD-001','iPad 10. Generation 64 GB wurde im Bestand angelegt. Status: verfuegbar, Zustand: gut, Standort: Medienraum','migration','2026-04-08 22:59:12'),
(7,'exemplar',2,2,NULL,'exemplar_angelegt','Exemplar angelegt: PENCIL-001','Apple Pencil USB-C wurde im Bestand angelegt. Status: verfuegbar, Zustand: gut, Standort: Medienraum','migration','2026-04-08 22:59:12'),
(8,'exemplar',3,3,NULL,'exemplar_angelegt','Exemplar angelegt: NETZ-001','Apple 20W USB-C Netzteil wurde im Bestand angelegt. Status: verfuegbar, Zustand: sehr_gut, Standort: Lager Technik','migration','2026-04-08 22:59:12'),
(9,'exemplar',4,4,NULL,'exemplar_angelegt','Exemplar angelegt: TAST-001','Logitech Rugged Keyboard Folio wurde im Bestand angelegt. Status: verfuegbar, Zustand: gut, Standort: Medienraum','migration','2026-04-08 22:59:12'),
(10,'exemplar',5,5,NULL,'exemplar_angelegt','Exemplar angelegt: BEAMER-001','Epson EB-FH52 wurde im Bestand angelegt. Status: verfuegbar, Zustand: gebraucht, Standort: Lager Technik','migration','2026-04-08 22:59:12'),
(11,'exemplar',6,6,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-DE-001','Deutsch 7 wurde im Bestand angelegt. Status: verfuegbar, Zustand: sehr_gut, Standort: Bibliothek','migration','2026-04-08 22:59:12'),
(12,'exemplar',7,7,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-MA-001','Mathematik 7 wurde im Bestand angelegt. Status: verfuegbar, Zustand: neu, Standort: Bibliothek','migration','2026-04-08 22:59:12'),
(13,'exemplar',8,8,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-EN-001','Englisch 7 wurde im Bestand angelegt. Status: verfuegbar, Zustand: sehr_gut, Standort: Bibliothek','migration','2026-04-08 22:59:12'),
(14,'exemplar',9,9,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-BIO-001','Biologie 8 wurde im Bestand angelegt. Status: verfuegbar, Zustand: gut, Standort: Bibliothek','migration','2026-04-08 22:59:12'),
(15,'exemplar',10,10,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-GE-001','Geschichte 9 wurde im Bestand angelegt. Status: verfuegbar, Zustand: gut, Standort: Bibliothek','migration','2026-04-08 22:59:12'),
(21,'ausleihe',4,7,4,'ausgabe','Ausleihe erstellt: BUCH-MA-001','Mathematik 7 wurde an Klasse 7a ausgegeben.','weboberflaeche','2026-04-08 23:25:21'),
(22,'exemplar',7,7,4,'status_aenderung','Status geaendert: BUCH-MA-001','Mathematik 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-08 23:25:21'),
(23,'ausleihe',5,5,5,'ausgabe','Ausleihe erstellt: BEAMER-001','Epson EB-FH52 wurde an Frau Becker ausgegeben.','weboberflaeche','2026-04-08 23:27:04'),
(24,'exemplar',5,5,5,'status_aenderung','Status geaendert: BEAMER-001','Epson EB-FH52 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-08 23:27:04'),
(25,'ausleihe',6,4,6,'ausgabe','Ausleihe erstellt: TAST-001','Logitech Rugged Keyboard Folio wurde an Frau Becker ausgegeben.','weboberflaeche','2026-04-08 23:27:23'),
(26,'exemplar',4,4,6,'status_aenderung','Status geaendert: TAST-001','Logitech Rugged Keyboard Folio wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-08 23:27:23'),
(27,'ausleihe',7,9,7,'ausgabe','Ausleihe erstellt: BUCH-BIO-001','Biologie 8 wurde an Frau Becker ausgegeben.','weboberflaeche','2026-04-08 23:27:38'),
(28,'exemplar',9,9,7,'status_aenderung','Status geaendert: BUCH-BIO-001','Biologie 8 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-08 23:27:38'),
(29,'ausleihe',8,3,8,'ausgabe','Ausleihe erstellt: NETZ-001','Apple 20W USB-C Netzteil wurde an Herr Schneider ausgegeben.','weboberflaeche','2026-04-08 23:31:26'),
(30,'exemplar',3,3,8,'status_aenderung','Status geaendert: NETZ-001','Apple 20W USB-C Netzteil wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-08 23:31:26'),
(31,'klassensatz',5,NULL,NULL,'klassensatz_sammelausgabe','Klassensatz-Ausgabe gestartet: Klasse 7a','4 Buch-Exemplare werden an Klasse 7a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 10:51:49'),
(32,'ausleihe',9,6,9,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-DE-001','Deutsch 7 (Deutsch 7 - Satz A) wurde an Klasse 7a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 10:51:49'),
(33,'exemplar',6,6,9,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 10:51:49'),
(34,'ausleihe',10,16,10,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-DE-002','Deutsch 7 (Deutsch 7 - Satz A) wurde an Klasse 7a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 10:51:49'),
(35,'exemplar',16,16,10,'status_aenderung','Status geaendert: BUCH-DE-002','Deutsch 7 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 10:51:49'),
(36,'ausleihe',11,17,11,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-DE-003','Deutsch 7 (Deutsch 7 - Satz A) wurde an Klasse 7a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 10:51:49'),
(37,'exemplar',17,17,11,'status_aenderung','Status geaendert: BUCH-DE-003','Deutsch 7 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 10:51:49'),
(38,'ausleihe',12,18,12,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-DE-004','Deutsch 7 (Deutsch 7 - Satz A) wurde an Klasse 7a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 10:51:49'),
(39,'exemplar',18,18,12,'status_aenderung','Status geaendert: BUCH-DE-004','Deutsch 7 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 10:51:49'),
(40,'exemplar',16,16,NULL,'zustandsaenderung','Zustand geaendert: BUCH-DE-002','Deutsch 7 wurde von sehr_gut auf gebraucht gesetzt.','weboberflaeche','2026-04-09 10:52:31'),
(41,'ausleihe',13,19,13,'ausgabe','Ausleihe erstellt: BUCH-DE-005','Deutsch 7 wurde an Frau Becker ausgegeben. Faellig am 2026-04-23 14:00:00.','weboberflaeche','2026-04-09 10:54:36'),
(42,'exemplar',19,19,13,'status_aenderung','Status geaendert: BUCH-DE-005','Deutsch 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 10:54:36'),
(43,'ausleihe',14,2,14,'ausgabe','Ausleihe erstellt: PENCIL-001','Apple Pencil USB-C wurde an Frau Sarah Mueller ausgegeben. Faellig am 2026-04-23 14:00:00.','weboberflaeche','2026-04-09 11:37:17'),
(44,'exemplar',2,2,14,'status_aenderung','Status geaendert: PENCIL-001','Apple Pencil USB-C wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 11:37:17'),
(45,'ausleihe',6,4,6,'rueckgabe','Rueckgabe verbucht: TAST-001','Logitech Rugged Keyboard Folio wurde von Frau Becker zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-09 11:38:23'),
(46,'exemplar',4,4,6,'status_aenderung','Status geaendert: TAST-001','Logitech Rugged Keyboard Folio wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-09 11:38:23'),
(47,'exemplar',4,4,6,'zustandsaenderung','Zustand geaendert: TAST-001','Logitech Rugged Keyboard Folio wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-09 11:38:23'),
(48,'ausleihe',7,9,7,'rueckgabe','Rueckgabe verbucht: BUCH-BIO-001','Biologie 8 wurde von Frau Becker zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-09 11:38:29'),
(49,'exemplar',9,9,7,'status_aenderung','Status geaendert: BUCH-BIO-001','Biologie 8 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-09 11:38:29'),
(50,'exemplar',9,9,7,'zustandsaenderung','Zustand geaendert: BUCH-BIO-001','Biologie 8 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-09 11:38:29'),
(51,'ausleihe',13,19,13,'rueckgabe','Rueckgabe verbucht: BUCH-DE-005','Deutsch 7 wurde von Frau Becker zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-09 11:38:32'),
(52,'exemplar',19,19,13,'status_aenderung','Status geaendert: BUCH-DE-005','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-09 11:38:32'),
(53,'exemplar',19,19,13,'zustandsaenderung','Zustand geaendert: BUCH-DE-005','Deutsch 7 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-09 11:38:32'),
(54,'ausleihe',5,5,5,'rueckgabe','Rueckgabe verbucht: BEAMER-001','Epson EB-FH52 wurde von Frau Becker zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-09 11:38:38'),
(55,'exemplar',5,5,5,'status_aenderung','Status geaendert: BEAMER-001','Epson EB-FH52 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-09 11:38:38'),
(56,'exemplar',5,5,5,'zustandsaenderung','Zustand geaendert: BEAMER-001','Epson EB-FH52 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-09 11:38:38'),
(57,'ausleihe',4,7,4,'rueckgabe','Rueckgabe verbucht: BUCH-MA-001','Mathematik 7 wurde von Klasse 07a zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-09 11:42:50'),
(58,'exemplar',7,7,4,'status_aenderung','Status geaendert: BUCH-MA-001','Mathematik 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-09 11:42:50'),
(59,'exemplar',7,7,4,'zustandsaenderung','Zustand geaendert: BUCH-MA-001','Mathematik 7 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-09 11:42:50'),
(60,'ausleihe',9,6,9,'rueckgabe','Rueckgabe verbucht: BUCH-DE-001','Deutsch 7 wurde von Klasse 07a zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-09 11:42:52'),
(61,'exemplar',6,6,9,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-09 11:42:52'),
(62,'exemplar',6,6,9,'zustandsaenderung','Zustand geaendert: BUCH-DE-001','Deutsch 7 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-09 11:42:52'),
(63,'ausleihe',10,16,10,'rueckgabe','Rueckgabe verbucht: BUCH-DE-002','Deutsch 7 wurde von Klasse 07a zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-09 11:42:54'),
(64,'exemplar',16,16,10,'status_aenderung','Status geaendert: BUCH-DE-002','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-09 11:42:54'),
(65,'exemplar',16,16,10,'zustandsaenderung','Zustand geaendert: BUCH-DE-002','Deutsch 7 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-09 11:42:54'),
(66,'ausleihe',11,17,11,'rueckgabe','Rueckgabe verbucht: BUCH-DE-003','Deutsch 7 wurde von Klasse 07a zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-09 11:42:56'),
(67,'exemplar',17,17,11,'status_aenderung','Status geaendert: BUCH-DE-003','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-09 11:42:56'),
(68,'exemplar',17,17,11,'zustandsaenderung','Zustand geaendert: BUCH-DE-003','Deutsch 7 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-09 11:42:56'),
(69,'ausleihe',12,18,12,'rueckgabe','Rueckgabe verbucht: BUCH-DE-004','Deutsch 7 wurde von Klasse 07a zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-09 11:42:58'),
(70,'exemplar',18,18,12,'status_aenderung','Status geaendert: BUCH-DE-004','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-09 11:42:58'),
(71,'exemplar',18,18,12,'zustandsaenderung','Zustand geaendert: BUCH-DE-004','Deutsch 7 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-09 11:42:58'),
(72,'ausleihe',15,9,15,'ausgabe','Ausleihe erstellt: BUCH-BIO-001','Biologie 8 wurde an Ben Fischer 04a 06 ausgegeben. Faellig am 2026-04-16 14:00:00.','weboberflaeche','2026-04-09 13:14:51'),
(73,'exemplar',9,9,15,'status_aenderung','Status geaendert: BUCH-BIO-001','Biologie 8 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 13:14:51'),
(74,'exemplar',94,94,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-001','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-09 14:16:01'),
(75,'exemplar',95,95,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-002','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-09 14:16:01'),
(76,'exemplar',96,96,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-003','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-09 14:16:01'),
(77,'exemplar',97,97,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-004','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-09 14:16:01'),
(78,'exemplar',98,98,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-005','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-09 14:16:01'),
(79,'exemplar',99,99,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-006','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-09 14:16:01'),
(80,'exemplar',100,100,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-007','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-09 14:16:01'),
(81,'exemplar',101,101,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-008','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-09 14:16:01'),
(82,'exemplar',102,102,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-009','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-09 14:16:01'),
(83,'exemplar',103,103,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-010','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-09 14:16:01'),
(84,'exemplar',104,104,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-011','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09a.','weboberflaeche','2026-04-09 14:17:39'),
(85,'exemplar',105,105,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-012','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09a.','weboberflaeche','2026-04-09 14:17:39'),
(86,'exemplar',106,106,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-013','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09a.','weboberflaeche','2026-04-09 14:17:39'),
(87,'exemplar',107,107,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-014','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09a.','weboberflaeche','2026-04-09 14:17:39'),
(88,'exemplar',108,108,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-015','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09a.','weboberflaeche','2026-04-09 14:17:39'),
(89,'exemplar',109,109,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-016','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09a.','weboberflaeche','2026-04-09 14:17:39'),
(90,'exemplar',110,110,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-017','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09a.','weboberflaeche','2026-04-09 14:17:39'),
(91,'exemplar',111,111,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09a.','weboberflaeche','2026-04-09 14:17:39'),
(92,'exemplar',112,112,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-019','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09a.','weboberflaeche','2026-04-09 14:17:39'),
(93,'exemplar',113,113,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-020','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09a.','weboberflaeche','2026-04-09 14:17:39'),
(94,'exemplar',114,114,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-021','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09b.','weboberflaeche','2026-04-09 14:23:23'),
(95,'exemplar',115,115,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-022','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09b.','weboberflaeche','2026-04-09 14:23:23'),
(96,'exemplar',116,116,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-023','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09b.','weboberflaeche','2026-04-09 14:23:23'),
(97,'exemplar',117,117,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-024','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09b.','weboberflaeche','2026-04-09 14:23:23'),
(98,'exemplar',118,118,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-025','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09b.','weboberflaeche','2026-04-09 14:23:23'),
(99,'exemplar',119,119,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-026','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09b.','weboberflaeche','2026-04-09 14:23:23'),
(100,'exemplar',120,120,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-027','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09b.','weboberflaeche','2026-04-09 14:23:23'),
(101,'exemplar',121,121,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-028','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09b.','weboberflaeche','2026-04-09 14:23:23'),
(102,'exemplar',122,122,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-029','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09b.','weboberflaeche','2026-04-09 14:23:23'),
(103,'exemplar',123,123,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-16-030','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 09b.','weboberflaeche','2026-04-09 14:23:23'),
(104,'klassensatz',284,NULL,NULL,'klassensatz_sammelausgabe','Klassensatz-Ausgabe gestartet: Klasse 09a','10 Buch-Exemplare werden an Klasse 09a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 14:24:19'),
(105,'ausleihe',16,104,16,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-16-011','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 (Klasse 09a) wurde an Klasse 09a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 14:24:19'),
(106,'exemplar',104,104,16,'status_aenderung','Status geaendert: BUCH-16-011','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 14:24:19'),
(107,'ausleihe',17,105,17,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-16-012','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 (Klasse 09a) wurde an Klasse 09a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 14:24:19'),
(108,'exemplar',105,105,17,'status_aenderung','Status geaendert: BUCH-16-012','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 14:24:19'),
(109,'ausleihe',18,106,18,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-16-013','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 (Klasse 09a) wurde an Klasse 09a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 14:24:19'),
(110,'exemplar',106,106,18,'status_aenderung','Status geaendert: BUCH-16-013','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 14:24:19'),
(111,'ausleihe',19,107,19,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-16-014','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 (Klasse 09a) wurde an Klasse 09a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 14:24:19'),
(112,'exemplar',107,107,19,'status_aenderung','Status geaendert: BUCH-16-014','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 14:24:19'),
(113,'ausleihe',20,108,20,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-16-015','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 (Klasse 09a) wurde an Klasse 09a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 14:24:19'),
(114,'exemplar',108,108,20,'status_aenderung','Status geaendert: BUCH-16-015','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 14:24:19'),
(115,'ausleihe',21,109,21,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-16-016','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 (Klasse 09a) wurde an Klasse 09a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 14:24:19'),
(116,'exemplar',109,109,21,'status_aenderung','Status geaendert: BUCH-16-016','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 14:24:19'),
(117,'ausleihe',22,110,22,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-16-017','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 (Klasse 09a) wurde an Klasse 09a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 14:24:19'),
(118,'exemplar',110,110,22,'status_aenderung','Status geaendert: BUCH-16-017','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 14:24:19'),
(119,'ausleihe',23,111,23,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 (Klasse 09a) wurde an Klasse 09a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 14:24:19'),
(120,'exemplar',111,111,23,'status_aenderung','Status geaendert: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 14:24:19'),
(121,'ausleihe',24,112,24,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-16-019','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 (Klasse 09a) wurde an Klasse 09a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 14:24:19'),
(122,'exemplar',112,112,24,'status_aenderung','Status geaendert: BUCH-16-019','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 14:24:19'),
(123,'ausleihe',25,113,25,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-16-020','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 (Klasse 09a) wurde an Klasse 09a ausgegeben. Faellig am 2026-04-10 14:00:00.','weboberflaeche','2026-04-09 14:24:19'),
(124,'exemplar',113,113,25,'status_aenderung','Status geaendert: BUCH-16-020','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-09 14:24:19'),
(125,'exemplar',124,124,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-001','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: 07a.','weboberflaeche','2026-04-09 14:27:38'),
(126,'exemplar',125,125,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-002','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: 07a.','weboberflaeche','2026-04-09 14:27:38'),
(127,'exemplar',126,126,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-003','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: 07a.','weboberflaeche','2026-04-09 14:27:38'),
(128,'exemplar',127,127,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-004','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: 07a.','weboberflaeche','2026-04-09 14:27:38'),
(129,'exemplar',128,128,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-005','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: 07a.','weboberflaeche','2026-04-09 14:27:38'),
(130,'exemplar',129,129,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-006','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: 07a.','weboberflaeche','2026-04-09 14:27:38'),
(131,'exemplar',130,130,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-007','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: 07a.','weboberflaeche','2026-04-09 14:27:38'),
(132,'exemplar',131,131,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-008','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: 07a.','weboberflaeche','2026-04-09 14:27:38'),
(133,'exemplar',132,132,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-009','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: 07a.','weboberflaeche','2026-04-09 14:27:38'),
(134,'exemplar',133,133,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-010','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: 07a.','weboberflaeche','2026-04-09 14:27:38'),
(135,'exemplar',134,134,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-011','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 14:28:26'),
(136,'exemplar',135,135,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-012','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 14:28:26'),
(137,'exemplar',136,136,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-013','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 14:28:26'),
(138,'exemplar',137,137,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-014','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 14:28:26'),
(139,'exemplar',138,138,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-015','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 14:28:26'),
(140,'exemplar',139,139,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-016','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 14:28:26'),
(141,'exemplar',140,140,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-017','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 14:28:26'),
(142,'exemplar',141,141,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-018','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 14:28:26'),
(143,'exemplar',142,142,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-019','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 14:28:26'),
(144,'exemplar',143,143,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-020','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 14:28:26'),
(145,'exemplar',144,144,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-021','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 7a.','weboberflaeche','2026-04-09 15:05:24'),
(146,'exemplar',145,145,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-022','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 7a.','weboberflaeche','2026-04-09 15:05:24'),
(147,'exemplar',146,146,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-023','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 7a.','weboberflaeche','2026-04-09 15:05:24'),
(148,'exemplar',147,147,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-024','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 7a.','weboberflaeche','2026-04-09 15:05:24'),
(149,'exemplar',148,148,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-025','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 7a.','weboberflaeche','2026-04-09 15:05:24'),
(150,'exemplar',149,149,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-026','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 7a.','weboberflaeche','2026-04-09 15:05:24'),
(151,'exemplar',150,150,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-027','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 7a.','weboberflaeche','2026-04-09 15:05:24'),
(152,'exemplar',151,151,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-028','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 7a.','weboberflaeche','2026-04-09 15:05:24'),
(153,'exemplar',152,152,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-029','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 7a.','weboberflaeche','2026-04-09 15:05:24'),
(154,'exemplar',153,153,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-030','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 7a.','weboberflaeche','2026-04-09 15:05:24'),
(155,'exemplar',154,154,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-031','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 15:08:33'),
(156,'exemplar',155,155,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-032','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 15:08:33'),
(157,'exemplar',156,156,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-033','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 15:08:33'),
(158,'exemplar',157,157,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-034','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 15:08:33'),
(159,'exemplar',158,158,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-035','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 15:08:33'),
(160,'exemplar',159,159,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-17-036','Mathematik real wurde als neues Buch-Exemplar angelegt. Klassensatz: Klasse 07b.','weboberflaeche','2026-04-09 15:08:33'),
(161,'exemplar',160,160,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-001','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(162,'exemplar',161,161,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-002','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(163,'exemplar',162,162,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-003','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(164,'exemplar',163,163,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-004','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(165,'exemplar',164,164,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-005','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(166,'exemplar',165,165,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-006','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(167,'exemplar',166,166,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-007','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(168,'exemplar',167,167,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-008','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(169,'exemplar',168,168,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-009','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(170,'exemplar',169,169,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-010','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(171,'exemplar',170,170,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-011','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(172,'exemplar',171,171,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-012','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(173,'exemplar',172,172,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-013','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(174,'exemplar',173,173,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-014','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(175,'exemplar',174,174,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-18-015','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde als neues Buch-Exemplar angelegt. Klassensatz: 10A.','weboberflaeche','2026-04-09 15:15:11'),
(176,'exemplar',164,164,NULL,'status_aenderung','Status geaendert: BUCH-18-005','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde von verfuegbar auf defekt gesetzt.','weboberflaeche','2026-04-09 15:18:01'),
(177,'exemplar',164,164,NULL,'zustandsaenderung','Zustand geaendert: BUCH-18-005','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde von sehr_gut auf beschaedigt gesetzt.','weboberflaeche','2026-04-09 15:18:01'),
(178,'schaden',1,111,23,'schadensmeldung','Schaden gemeldet: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9: Cover defekt. Cover defekt, wird neu verllebt','weboberflaeche','2026-04-09 15:20:21'),
(179,'exemplar',111,111,NULL,'status_aenderung','Status geaendert: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde aufgrund einer Schadensmeldung auf defekt gesetzt.','weboberflaeche','2026-04-09 15:20:21'),
(180,'exemplar',111,111,NULL,'zustandsaenderung','Zustand geaendert: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde aufgrund einer Schadensmeldung auf beschaedigt gesetzt.','weboberflaeche','2026-04-09 15:20:21'),
(181,'ausleihe',14,2,14,'rueckgabe','Rueckgabe verbucht: PENCIL-001','Apple Pencil USB-C wurde von Frau Sarah Mueller zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-09 22:06:22'),
(182,'exemplar',2,2,14,'status_aenderung','Status geaendert: PENCIL-001','Apple Pencil USB-C wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-09 22:06:22'),
(183,'exemplar',2,2,14,'zustandsaenderung','Zustand geaendert: PENCIL-001','Apple Pencil USB-C wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-09 22:06:22'),
(184,'ausleihe',26,16,26,'ausgabe','Ausleihe erstellt: BUCH-DE-002','Deutsch 7 wurde an Ben Fischer 01a 06 ausgegeben. Faellig am 2026-04-17 14:00:00.','weboberflaeche','2026-04-10 10:58:06'),
(185,'exemplar',16,16,26,'status_aenderung','Status geaendert: BUCH-DE-002','Deutsch 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 10:58:06'),
(186,'ausleihe',26,16,26,'rueckgabe','Rueckgabe verbucht: BUCH-DE-002','Deutsch 7 wurde von Ben Fischer 01a 06 zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-10 20:21:54'),
(187,'exemplar',16,16,26,'status_aenderung','Status geaendert: BUCH-DE-002','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-10 20:21:54'),
(188,'exemplar',16,16,26,'zustandsaenderung','Zustand geaendert: BUCH-DE-002','Deutsch 7 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-10 20:21:54'),
(189,'ausleihe',27,6,27,'ausgabe','Ausleihe erstellt: BUCH-DE-001','Deutsch 7 wurde an Ben Fischer 01a 06 ausgegeben. Faellig am 2026-04-17 14:00:00.','weboberflaeche','2026-04-10 20:43:55'),
(190,'exemplar',6,6,27,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 20:43:55'),
(191,'ausleihe',27,6,27,'rueckgabe','Rueckgabe verbucht: BUCH-DE-001','Deutsch 7 wurde von Ben Fischer 01a 06 zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-10 20:44:34'),
(192,'exemplar',6,6,27,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-10 20:44:34'),
(193,'exemplar',6,6,27,'zustandsaenderung','Zustand geaendert: BUCH-DE-001','Deutsch 7 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-10 20:44:34'),
(194,'ausleihe',28,6,28,'ausgabe','Ausleihe erstellt: BUCH-DE-001','Deutsch 7 wurde an Ben Fischer 01a 06 ausgegeben. Faellig am 2026-04-17 14:00:00.','weboberflaeche','2026-04-10 20:51:40'),
(195,'exemplar',6,6,28,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 20:51:40'),
(196,'ausleihe',28,6,28,'rueckgabe','Rueckgabe verbucht: BUCH-DE-001','Deutsch 7 wurde von Ben Fischer 01a 06 zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-10 20:53:51'),
(197,'exemplar',6,6,28,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-10 20:53:51'),
(198,'exemplar',6,6,28,'zustandsaenderung','Zustand geaendert: BUCH-DE-001','Deutsch 7 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-10 20:53:51'),
(199,'ausleihe',29,6,29,'ausgabe','Ausleihe erstellt: BUCH-DE-001','Deutsch 7 wurde an Ben Fischer 01a 06 ausgegeben. Faellig am 2026-04-17 14:00:00.','weboberflaeche','2026-04-10 20:57:24'),
(200,'exemplar',6,6,29,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 20:57:24'),
(201,'ausleihe',29,6,29,'rueckgabe','Rueckgabe verbucht: BUCH-DE-001','Deutsch 7 wurde von Ben Fischer 01a 06 zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-10 20:58:01'),
(202,'exemplar',6,6,29,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-10 20:58:01'),
(203,'exemplar',6,6,29,'zustandsaenderung','Zustand geaendert: BUCH-DE-001','Deutsch 7 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-10 20:58:01'),
(204,'ausleihe',30,6,30,'ausgabe','Ausleihe erstellt: BUCH-DE-001','Deutsch 7 wurde an Ben Fischer 01a 06 ausgegeben. Faellig am 2026-04-17 14:00:00.','weboberflaeche','2026-04-10 21:00:10'),
(205,'exemplar',6,6,30,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:00:10'),
(206,'ausleihe',30,6,30,'rueckgabe','Rueckgabe verbucht: BUCH-DE-001','Deutsch 7 wurde von Ben Fischer 01a 06 zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-10 21:01:18'),
(207,'exemplar',6,6,30,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-10 21:01:18'),
(208,'exemplar',6,6,30,'zustandsaenderung','Zustand geaendert: BUCH-DE-001','Deutsch 7 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-10 21:01:18'),
(209,'ausleihe',31,6,31,'ausgabe','Ausleihe erstellt: BUCH-DE-001','Deutsch 7 wurde an Ben Fischer 01a 06 ausgegeben. Faellig am 2026-04-17 14:00:00.','weboberflaeche','2026-04-10 21:03:26'),
(210,'exemplar',6,6,31,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:03:26'),
(211,'ausleihe',31,6,31,'rueckgabe','Rueckgabe verbucht: BUCH-DE-001','Deutsch 7 wurde von Ben Fischer 01a 06 zurueckgegeben. Zustand: sehr_gut.','weboberflaeche','2026-04-10 21:03:51'),
(212,'exemplar',6,6,31,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-10 21:03:51'),
(213,'exemplar',6,6,31,'zustandsaenderung','Zustand geaendert: BUCH-DE-001','Deutsch 7 wurde mit Zustand sehr_gut verbucht.','weboberflaeche','2026-04-10 21:03:51'),
(214,'ausleihe',32,6,32,'ausgabe','Ausleihe erstellt: BUCH-DE-001','Deutsch 7 wurde an Ben Fischer 01a 06 ausgegeben. Faellig am 2026-04-17 14:00:00.','weboberflaeche','2026-04-10 21:04:36'),
(215,'exemplar',6,6,32,'status_aenderung','Status geaendert: BUCH-DE-001','Deutsch 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:04:36'),
(216,'ausleihe',32,6,32,'verlaengerung','Ausleihe verlaengert: BUCH-DE-001','Deutsch 7 fuer Ben Fischer 01a 06 wurde von Fri Apr 17 2026 14:00:00 GMT+0200 (Mitteleuropäische Sommerzeit) auf 2026-04-23T14:00 verlaengert.','weboberflaeche','2026-04-10 21:12:49'),
(217,'ausleihe',32,6,32,'verlaengerung','Ausleihe verlaengert: BUCH-DE-001','Deutsch 7 fuer Ben Fischer 01a 06 wurde von Thu Apr 23 2026 14:00:00 GMT+0200 (Mitteleuropäische Sommerzeit) auf 2026-04-23T14:00 verlaengert.','weboberflaeche','2026-04-10 21:14:17'),
(218,'ausleihe',32,6,32,'verlaengerung','Ausleihe verlaengert: BUCH-DE-001','Deutsch 7 fuer Ben Fischer 01a 06 wurde von Thu Apr 23 2026 14:00:00 GMT+0200 (Mitteleuropäische Sommerzeit) auf 2026-04-30T14:00 verlaengert.','weboberflaeche','2026-04-10 21:19:55'),
(219,'klassensatz',282,NULL,NULL,'klassensatz_sammelausgabe','Klassensatz-Ausgabe gestartet: Klasse 07a','10 Buch-Exemplare werden an Klasse 07a ausgegeben. Faellig am 2026-04-11 14:00:00.','weboberflaeche','2026-04-10 21:32:30'),
(220,'ausleihe',33,124,33,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-17-001','Mathematik real (07a) wurde an Klasse 07a ausgegeben. Faellig am 2026-04-11 14:00:00.','weboberflaeche','2026-04-10 21:32:30'),
(221,'exemplar',124,124,33,'status_aenderung','Status geaendert: BUCH-17-001','Mathematik real wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:32:30'),
(222,'ausleihe',34,125,34,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-17-002','Mathematik real (07a) wurde an Klasse 07a ausgegeben. Faellig am 2026-04-11 14:00:00.','weboberflaeche','2026-04-10 21:32:30'),
(223,'exemplar',125,125,34,'status_aenderung','Status geaendert: BUCH-17-002','Mathematik real wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:32:30'),
(224,'ausleihe',35,126,35,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-17-003','Mathematik real (07a) wurde an Klasse 07a ausgegeben. Faellig am 2026-04-11 14:00:00.','weboberflaeche','2026-04-10 21:32:30'),
(225,'exemplar',126,126,35,'status_aenderung','Status geaendert: BUCH-17-003','Mathematik real wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:32:30'),
(226,'ausleihe',36,127,36,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-17-004','Mathematik real (07a) wurde an Klasse 07a ausgegeben. Faellig am 2026-04-11 14:00:00.','weboberflaeche','2026-04-10 21:32:30'),
(227,'exemplar',127,127,36,'status_aenderung','Status geaendert: BUCH-17-004','Mathematik real wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:32:30'),
(228,'ausleihe',37,128,37,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-17-005','Mathematik real (07a) wurde an Klasse 07a ausgegeben. Faellig am 2026-04-11 14:00:00.','weboberflaeche','2026-04-10 21:32:30'),
(229,'exemplar',128,128,37,'status_aenderung','Status geaendert: BUCH-17-005','Mathematik real wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:32:30'),
(230,'ausleihe',38,129,38,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-17-006','Mathematik real (07a) wurde an Klasse 07a ausgegeben. Faellig am 2026-04-11 14:00:00.','weboberflaeche','2026-04-10 21:32:30'),
(231,'exemplar',129,129,38,'status_aenderung','Status geaendert: BUCH-17-006','Mathematik real wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:32:30'),
(232,'ausleihe',39,130,39,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-17-007','Mathematik real (07a) wurde an Klasse 07a ausgegeben. Faellig am 2026-04-11 14:00:00.','weboberflaeche','2026-04-10 21:32:30'),
(233,'exemplar',130,130,39,'status_aenderung','Status geaendert: BUCH-17-007','Mathematik real wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:32:30'),
(234,'ausleihe',40,131,40,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-17-008','Mathematik real (07a) wurde an Klasse 07a ausgegeben. Faellig am 2026-04-11 14:00:00.','weboberflaeche','2026-04-10 21:32:30'),
(235,'exemplar',131,131,40,'status_aenderung','Status geaendert: BUCH-17-008','Mathematik real wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:32:30'),
(236,'ausleihe',41,132,41,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-17-009','Mathematik real (07a) wurde an Klasse 07a ausgegeben. Faellig am 2026-04-11 14:00:00.','weboberflaeche','2026-04-10 21:32:30'),
(237,'exemplar',132,132,41,'status_aenderung','Status geaendert: BUCH-17-009','Mathematik real wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:32:30'),
(238,'ausleihe',42,133,42,'klassensatz_ausgabe','Klassensatz ausgegeben: BUCH-17-010','Mathematik real (07a) wurde an Klasse 07a ausgegeben. Faellig am 2026-04-11 14:00:00.','weboberflaeche','2026-04-10 21:32:30'),
(239,'exemplar',133,133,42,'status_aenderung','Status geaendert: BUCH-17-010','Mathematik real wurde ueber die Klassensatz-Ausgabe auf ausgeliehen gesetzt.','weboberflaeche','2026-04-10 21:32:30'),
(240,'exemplar',20,20,NULL,'zustandsaenderung','Zustand geaendert: BUCH-DE-006','Deutsch 7 wurde von sehr_gut auf gut gesetzt.','weboberflaeche','2026-04-11 00:27:35'),
(241,'exemplar',25,25,NULL,'zustandsaenderung','Zustand geaendert: BUCH-DE-011','Deutsch 7 wurde von sehr_gut auf gebraucht gesetzt.','weboberflaeche','2026-04-11 00:32:20'),
(242,'exemplar',160,160,NULL,'zustandsaenderung','Zustand geaendert: BUCH-18-001','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde von sehr_gut auf beschaedigt gesetzt.','weboberflaeche','2026-04-11 00:34:10'),
(243,'exemplar',160,160,NULL,'status_aenderung','Status geaendert: BUCH-18-001','Mittlerer Schulabschluss zentrale Prüfungen 2010 wurde von verfuegbar auf in_reparatur gesetzt.','weboberflaeche','2026-04-11 00:34:18'),
(244,'schaden',2,21,20,'schadensmeldung','Schaden gemeldet: BUCH-DE-007','Deutsch 7: Wasserschaden auf Deckblatt. grnau','weboberflaeche','2026-04-11 18:05:55'),
(245,'exemplar',21,21,NULL,'status_aenderung','Status geaendert: BUCH-DE-007','Deutsch 7 wurde aufgrund einer Schadensmeldung auf defekt gesetzt.','weboberflaeche','2026-04-11 18:05:55'),
(246,'exemplar',21,21,NULL,'zustandsaenderung','Zustand geaendert: BUCH-DE-007','Deutsch 7 wurde aufgrund einer Schadensmeldung auf beschaedigt gesetzt.','weboberflaeche','2026-04-11 18:05:55'),
(247,'reparatur',1,21,NULL,'reparatur_gestartet','Reparatur gestartet: BUCH-DE-007','Deutsch 7: Wird repariert (Dienstleister: Buch.de)','weboberflaeche','2026-04-11 18:06:47'),
(248,'exemplar',21,21,NULL,'status_aenderung','Status geaendert: BUCH-DE-007','Deutsch 7 wurde auf in_reparatur gesetzt.','weboberflaeche','2026-04-11 18:06:47'),
(249,'reparatur',1,21,NULL,'reparatur_abgeschlossen','Reparatur abgeschlossen: BUCH-DE-007','Deutsch 7 wurde abgeschlossen. Reparatur in der Arbeitsoberflaeche abgeschlossen.','weboberflaeche','2026-04-11 18:06:56'),
(250,'exemplar',21,21,NULL,'status_aenderung','Status geaendert: BUCH-DE-007','Deutsch 7 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-11 18:06:56'),
(251,'exemplar',21,21,NULL,'zustandsaenderung','Zustand geaendert: BUCH-DE-007','Deutsch 7 wurde auf gut gesetzt.','weboberflaeche','2026-04-11 18:06:56'),
(252,'reparatur',2,111,NULL,'reparatur_gestartet','Reparatur gestartet: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9: Reparatur dauert 2 Wochen (Dienstleister: BUch.de)','weboberflaeche','2026-04-11 18:07:53'),
(253,'exemplar',111,111,NULL,'status_aenderung','Status geaendert: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde auf in_reparatur gesetzt.','weboberflaeche','2026-04-11 18:07:53'),
(254,'reparatur',2,111,NULL,'reparatur_abgeschlossen','Reparatur abgeschlossen: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde abgeschlossen. Reparatur in der Arbeitsoberflaeche abgeschlossen.','weboberflaeche','2026-04-11 18:08:59'),
(255,'exemplar',111,111,NULL,'status_aenderung','Status geaendert: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-11 18:08:59'),
(256,'exemplar',111,111,NULL,'zustandsaenderung','Zustand geaendert: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde auf gut gesetzt.','weboberflaeche','2026-04-11 18:08:59'),
(257,'exemplar',175,175,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-19-001','Mathematik real wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-11 18:27:08'),
(258,'exemplar',176,176,NULL,'exemplar_angelegt','Exemplar angelegt: BUCH-19-002','Mathematik real wurde als neues Buch-Exemplar angelegt.','weboberflaeche','2026-04-11 19:17:34'),
(259,'exemplar',51,51,NULL,'geloescht','Exemplar geloescht: BUCH-DE-037','Deutsch 7 (BUCH-DE-037) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 21:45:32'),
(260,'exemplar',52,52,NULL,'geloescht','Exemplar geloescht: BUCH-DE-038','Deutsch 7 (BUCH-DE-038) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 21:45:32'),
(261,'exemplar',53,53,NULL,'geloescht','Exemplar geloescht: BUCH-DE-039','Deutsch 7 (BUCH-DE-039) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 21:45:32'),
(262,'exemplar',54,54,NULL,'geloescht','Exemplar geloescht: BUCH-DE-040','Deutsch 7 (BUCH-DE-040) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 21:45:32'),
(263,'exemplar',22,22,NULL,'geloescht','Exemplar geloescht: BUCH-DE-008','Deutsch 7 (BUCH-DE-008) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:26'),
(264,'exemplar',23,23,NULL,'geloescht','Exemplar geloescht: BUCH-DE-009','Deutsch 7 (BUCH-DE-009) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:26'),
(265,'exemplar',24,24,NULL,'geloescht','Exemplar geloescht: BUCH-DE-010','Deutsch 7 (BUCH-DE-010) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:26'),
(266,'exemplar',16,16,NULL,'geloescht','Exemplar geloescht: BUCH-DE-002','Deutsch 7 (BUCH-DE-002) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(267,'exemplar',17,17,NULL,'geloescht','Exemplar geloescht: BUCH-DE-003','Deutsch 7 (BUCH-DE-003) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(268,'exemplar',18,18,NULL,'geloescht','Exemplar geloescht: BUCH-DE-004','Deutsch 7 (BUCH-DE-004) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(269,'exemplar',19,19,NULL,'geloescht','Exemplar geloescht: BUCH-DE-005','Deutsch 7 (BUCH-DE-005) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(270,'exemplar',20,20,NULL,'geloescht','Exemplar geloescht: BUCH-DE-006','Deutsch 7 (BUCH-DE-006) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(271,'exemplar',21,21,NULL,'geloescht','Exemplar geloescht: BUCH-DE-007','Deutsch 7 (BUCH-DE-007) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(272,'exemplar',25,25,NULL,'geloescht','Exemplar geloescht: BUCH-DE-011','Deutsch 7 (BUCH-DE-011) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(273,'exemplar',26,26,NULL,'geloescht','Exemplar geloescht: BUCH-DE-012','Deutsch 7 (BUCH-DE-012) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(274,'exemplar',27,27,NULL,'geloescht','Exemplar geloescht: BUCH-DE-013','Deutsch 7 (BUCH-DE-013) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(275,'exemplar',28,28,NULL,'geloescht','Exemplar geloescht: BUCH-DE-014','Deutsch 7 (BUCH-DE-014) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(276,'exemplar',29,29,NULL,'geloescht','Exemplar geloescht: BUCH-DE-015','Deutsch 7 (BUCH-DE-015) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(277,'exemplar',30,30,NULL,'geloescht','Exemplar geloescht: BUCH-DE-016','Deutsch 7 (BUCH-DE-016) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:02:46'),
(278,'exemplar',31,31,NULL,'geloescht','Exemplar geloescht: BUCH-DE-017','Deutsch 7 (BUCH-DE-017) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(279,'exemplar',32,32,NULL,'geloescht','Exemplar geloescht: BUCH-DE-018','Deutsch 7 (BUCH-DE-018) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(280,'exemplar',33,33,NULL,'geloescht','Exemplar geloescht: BUCH-DE-019','Deutsch 7 (BUCH-DE-019) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(281,'exemplar',34,34,NULL,'geloescht','Exemplar geloescht: BUCH-DE-020','Deutsch 7 (BUCH-DE-020) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(282,'exemplar',35,35,NULL,'geloescht','Exemplar geloescht: BUCH-DE-021','Deutsch 7 (BUCH-DE-021) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(283,'exemplar',36,36,NULL,'geloescht','Exemplar geloescht: BUCH-DE-022','Deutsch 7 (BUCH-DE-022) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(284,'exemplar',37,37,NULL,'geloescht','Exemplar geloescht: BUCH-DE-023','Deutsch 7 (BUCH-DE-023) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(285,'exemplar',38,38,NULL,'geloescht','Exemplar geloescht: BUCH-DE-024','Deutsch 7 (BUCH-DE-024) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(286,'exemplar',39,39,NULL,'geloescht','Exemplar geloescht: BUCH-DE-025','Deutsch 7 (BUCH-DE-025) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(287,'exemplar',40,40,NULL,'geloescht','Exemplar geloescht: BUCH-DE-026','Deutsch 7 (BUCH-DE-026) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(288,'exemplar',41,41,NULL,'geloescht','Exemplar geloescht: BUCH-DE-027','Deutsch 7 (BUCH-DE-027) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(289,'exemplar',42,42,NULL,'geloescht','Exemplar geloescht: BUCH-DE-028','Deutsch 7 (BUCH-DE-028) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(290,'exemplar',43,43,NULL,'geloescht','Exemplar geloescht: BUCH-DE-029','Deutsch 7 (BUCH-DE-029) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(291,'exemplar',44,44,NULL,'geloescht','Exemplar geloescht: BUCH-DE-030','Deutsch 7 (BUCH-DE-030) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(292,'exemplar',45,45,NULL,'geloescht','Exemplar geloescht: BUCH-DE-031','Deutsch 7 (BUCH-DE-031) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:16'),
(293,'exemplar',46,46,NULL,'geloescht','Exemplar geloescht: BUCH-DE-032','Deutsch 7 (BUCH-DE-032) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:29'),
(294,'exemplar',47,47,NULL,'geloescht','Exemplar geloescht: BUCH-DE-033','Deutsch 7 (BUCH-DE-033) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:29'),
(295,'exemplar',48,48,NULL,'geloescht','Exemplar geloescht: BUCH-DE-034','Deutsch 7 (BUCH-DE-034) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:29'),
(296,'exemplar',49,49,NULL,'geloescht','Exemplar geloescht: BUCH-DE-035','Deutsch 7 (BUCH-DE-035) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:29'),
(297,'exemplar',50,50,NULL,'geloescht','Exemplar geloescht: BUCH-DE-036','Deutsch 7 (BUCH-DE-036) wurde aus dem Bestand entfernt.','weboberflaeche','2026-04-11 22:03:29'),
(298,'system',50,50,NULL,'angelegt','Mustereintrag 1','Beispielhafter Historieneintrag fuer Tests.','demo','2025-12-12 08:00:00'),
(299,'system',50,50,NULL,'aktualisiert','Mustereintrag 2','Beispielhafter Historieneintrag fuer Tests.','demo','2025-12-12 08:45:00'),
(300,'system',50,50,NULL,'ausgegeben','Mustereintrag 3','Beispielhafter Historieneintrag fuer Tests.','demo','2025-12-12 09:30:00'),
(301,'system',50,50,NULL,'zurueckgegeben','Mustereintrag 4','Beispielhafter Historieneintrag fuer Tests.','demo','2025-12-12 10:15:00'),
(302,'system',50,50,NULL,'pruefung','Mustereintrag 5','Beispielhafter Historieneintrag fuer Tests.','demo','2025-12-12 11:00:00'),
(303,'system',50,50,NULL,'aktualisiert','Mustereintrag 6','Beispielhafter Historieneintrag fuer Tests.','demo','2025-12-12 11:45:00'),
(304,'system',50,50,NULL,'angelegt','Mustereintrag 7','Beispielhafter Historieneintrag fuer Tests.','demo','2025-12-14 12:30:00'),
(305,'system',50,50,NULL,'kommentiert','Mustereintrag 8','Beispielhafter Historieneintrag fuer Tests.','demo','2025-12-13 13:15:00'),
(306,'system',50,50,NULL,'archiviert','Mustereintrag 9','Beispielhafter Historieneintrag fuer Tests.','demo','2025-12-12 14:00:00'),
(307,'system',50,50,NULL,'kontrolliert','Mustereintrag 10','Beispielhafter Historieneintrag fuer Tests.','demo','2025-12-11 14:45:00'),
(308,'ausleihe',43,79,43,'ausgabe','Ausleihe erstellt: IPAD-002','iPad 10. Generation 64 GB wurde an Frau Julia Wagner ausgegeben. Faellig am 2026-04-25 23:59:59.','weboberflaeche','2026-04-11 23:14:41'),
(309,'exemplar',79,79,43,'status_aenderung','Status geaendert: IPAD-002','iPad 10. Generation 64 GB wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-11 23:14:41'),
(310,'ausleihe',44,10,44,'ausgabe','Ausleihe erstellt: BUCH-GE-001','Geschichte 9 wurde an Frau Anna Becker ausgegeben. Faellig am 2026-04-25 23:59:59.','weboberflaeche','2026-04-11 23:21:33'),
(311,'exemplar',10,10,44,'status_aenderung','Status geaendert: BUCH-GE-001','Geschichte 9 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-11 23:21:33'),
(312,'ausleihe',44,10,44,'rueckgabe','Rueckgabe verbucht: BUCH-GE-001','Geschichte 9 wurde von Frau Anna Becker zurueckgegeben. Zustand: gebraucht.','weboberflaeche','2026-04-11 23:23:23'),
(313,'exemplar',10,10,44,'status_aenderung','Status geaendert: BUCH-GE-001','Geschichte 9 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-11 23:23:23'),
(314,'exemplar',10,10,44,'zustandsaenderung','Zustand geaendert: BUCH-GE-001','Geschichte 9 wurde mit Zustand gebraucht verbucht.','weboberflaeche','2026-04-11 23:23:23'),
(315,'ausleihe',22,110,22,'rueckgabe','Rueckgabe verbucht: BUCH-16-017','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde von Klasse 09a zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-12 10:32:54'),
(316,'exemplar',110,110,22,'status_aenderung','Status geaendert: BUCH-16-017','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-12 10:32:54'),
(317,'exemplar',110,110,22,'zustandsaenderung','Zustand geaendert: BUCH-16-017','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-12 10:32:54'),
(318,'ausleihe',24,112,24,'rueckgabe','Rueckgabe verbucht: BUCH-16-019','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde von Klasse 09a zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-12 10:33:45'),
(319,'exemplar',112,112,24,'status_aenderung','Status geaendert: BUCH-16-019','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-12 10:33:45'),
(320,'exemplar',112,112,24,'zustandsaenderung','Zustand geaendert: BUCH-16-019','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-12 10:33:45'),
(321,'ausleihe',25,113,25,'verlaengerung','Ausleihe verlaengert: BUCH-16-020','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 fuer Klasse 09a wurde von Fri Apr 10 2026 14:00:00 GMT+0200 (Mitteleuropäische Sommerzeit) auf 2026-04-17T14:00 verlaengert.','weboberflaeche','2026-04-12 10:33:55'),
(322,'ausleihe',25,113,25,'rueckgabe','Rueckgabe verbucht: BUCH-16-020','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde von Klasse 09a zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-12 10:34:19'),
(323,'exemplar',113,113,25,'status_aenderung','Status geaendert: BUCH-16-020','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-12 10:34:19'),
(324,'exemplar',113,113,25,'zustandsaenderung','Zustand geaendert: BUCH-16-020','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-12 10:34:19'),
(325,'ausleihe',23,111,23,'rueckgabe','Rueckgabe verbucht: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde von Klasse 09a zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-12 10:34:25'),
(326,'exemplar',111,111,23,'status_aenderung','Status geaendert: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-12 10:34:25'),
(327,'exemplar',111,111,23,'zustandsaenderung','Zustand geaendert: BUCH-16-018','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-12 10:34:25'),
(328,'ausleihe',21,109,21,'rueckgabe','Rueckgabe verbucht: BUCH-16-016','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde von Klasse 09a zurueckgegeben. Zustand: beschaedigt.','weboberflaeche','2026-04-12 10:34:33'),
(329,'exemplar',109,109,21,'status_aenderung','Status geaendert: BUCH-16-016','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde auf defekt gesetzt.','weboberflaeche','2026-04-12 10:34:33'),
(330,'exemplar',109,109,21,'zustandsaenderung','Zustand geaendert: BUCH-16-016','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde mit Zustand beschaedigt verbucht.','weboberflaeche','2026-04-12 10:34:33'),
(331,'ausleihe',16,104,16,'rueckgabe','Rueckgabe verbucht: BUCH-16-011','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde von Klasse 09a zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-12 10:35:06'),
(332,'exemplar',104,104,16,'status_aenderung','Status geaendert: BUCH-16-011','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-12 10:35:06'),
(333,'exemplar',104,104,16,'zustandsaenderung','Zustand geaendert: BUCH-16-011','Schnittpunkt, Ausgabe Nordrhein-Westfalen, EURO, Klasse 9 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-12 10:35:06'),
(334,'ausleihe',45,7,45,'ausgabe','Ausleihe erstellt: BUCH-MA-001','Mathematik 7 wurde an Ben Fischer 01a 06 ausgegeben. Faellig am 2026-04-19 14:00:00.','weboberflaeche','2026-04-12 10:41:47'),
(335,'exemplar',7,7,45,'status_aenderung','Status geaendert: BUCH-MA-001','Mathematik 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-12 10:41:47'),
(336,'ausleihe',46,8,46,'ausgabe','Ausleihe erstellt: BUCH-EN-001','Englisch 7 wurde an Ben Fischer 01a 06 ausgegeben. Faellig am 2026-04-19 23:59:59.','weboberflaeche','2026-04-12 11:00:39'),
(337,'exemplar',8,8,46,'status_aenderung','Status geaendert: BUCH-EN-001','Englisch 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-12 11:00:39'),
(338,'ausleihe',47,10,47,'ausgabe','Ausleihe erstellt: BUCH-GE-001','Geschichte 9 wurde an Ben Fischer 01a 06 ausgegeben. Faellig am 2026-02-02 23:59:59.','weboberflaeche','2026-04-12 20:20:54'),
(339,'exemplar',10,10,47,'status_aenderung','Status geaendert: BUCH-GE-001','Geschichte 9 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-12 20:20:54'),
(340,'ausleihe',48,17,48,'ausgabe','Ausleihe erstellt: BUCH-DE-003','Deutsch 7 wurde an Mia Beispiel 01a 01 ausgegeben. Faellig am 2026-01-01 23:59:59.','weboberflaeche','2026-04-12 20:41:49'),
(341,'exemplar',17,17,48,'status_aenderung','Status geaendert: BUCH-DE-003','Deutsch 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-12 20:41:49'),
(342,'ausleihe',49,82,49,'ausgabe','Ausleihe erstellt: IPAD-005','iPad 10. Generation 64 GB wurde an Herr Waedt ausgegeben. Faellig am 2026-04-20 23:59:59.','weboberflaeche','2026-04-13 22:56:43'),
(343,'exemplar',82,82,49,'status_aenderung','Status geaendert: IPAD-005','iPad 10. Generation 64 GB wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-13 22:56:43'),
(344,'ausleihe',50,83,50,'ausgabe','Ausleihe erstellt: IPAD-006','iPad 10. Generation 64 GB wurde an Herr Waedt ausgegeben. Faellig am 2026-04-01 23:59:59.','weboberflaeche','2026-04-13 22:57:12'),
(345,'exemplar',83,83,50,'status_aenderung','Status geaendert: IPAD-006','iPad 10. Generation 64 GB wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-13 22:57:12'),
(346,'ausleihe',51,2,51,'ausgabe','Ausleihe erstellt: PENCIL-001','Apple Pencil USB-C wurde an Herr Waedt ausgegeben. Faellig am 2026-04-01 23:59:59.','weboberflaeche','2026-04-13 22:58:03'),
(347,'exemplar',2,2,51,'status_aenderung','Status geaendert: PENCIL-001','Apple Pencil USB-C wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-13 22:58:03'),
(348,'ausleihe',52,87,52,'ausgabe','Ausleihe erstellt: IPAD-010','iPad 10. Generation 64 GB wurde an Herr Waedt ausgegeben. Faellig am 2026-04-21 23:59:59.','weboberflaeche','2026-04-14 08:23:26'),
(349,'exemplar',87,87,52,'status_aenderung','Status geaendert: IPAD-010','iPad 10. Generation 64 GB wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-14 08:23:26'),
(350,'ausleihe',53,86,53,'ausgabe','Ausleihe erstellt: IPAD-009','iPad 10. Generation 64 GB wurde an Herr Hanslick ausgegeben. Faellig am 2026-04-21 23:59:59.','weboberflaeche','2026-04-14 08:23:58'),
(351,'exemplar',86,86,53,'status_aenderung','Status geaendert: IPAD-009','iPad 10. Generation 64 GB wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-14 08:23:58'),
(352,'ausleihe',53,86,53,'rueckgabe','Rueckgabe verbucht: IPAD-009','iPad 10. Generation 64 GB wurde von Herr Hanslick zurueckgegeben. Zustand: beschaedigt.','weboberflaeche','2026-04-14 08:24:33'),
(353,'exemplar',86,86,53,'status_aenderung','Status geaendert: IPAD-009','iPad 10. Generation 64 GB wurde auf defekt gesetzt.','weboberflaeche','2026-04-14 08:24:33'),
(354,'exemplar',86,86,53,'zustandsaenderung','Zustand geaendert: IPAD-009','iPad 10. Generation 64 GB wurde mit Zustand beschaedigt verbucht.','weboberflaeche','2026-04-14 08:24:33'),
(355,'ausleihe',50,83,50,'rueckgabe','Rueckgabe verbucht: IPAD-006','iPad 10. Generation 64 GB wurde von Herr Waedt zurueckgegeben. Zustand: beschaedigt.','weboberflaeche','2026-04-14 10:15:36'),
(356,'exemplar',83,83,50,'status_aenderung','Status geaendert: IPAD-006','iPad 10. Generation 64 GB wurde auf defekt gesetzt.','weboberflaeche','2026-04-14 10:15:36'),
(357,'exemplar',83,83,50,'zustandsaenderung','Zustand geaendert: IPAD-006','iPad 10. Generation 64 GB wurde mit Zustand beschaedigt verbucht.','weboberflaeche','2026-04-14 10:15:36'),
(358,'ausleihe',47,10,47,'rueckgabe','Rueckgabe verbucht: BUCH-GE-001','Geschichte 9 wurde von Ben Fischer 01a 06 zurueckgegeben. Zustand: gut.','weboberflaeche','2026-04-14 20:10:28'),
(359,'exemplar',10,10,47,'status_aenderung','Status geaendert: BUCH-GE-001','Geschichte 9 wurde auf verfuegbar gesetzt.','weboberflaeche','2026-04-14 20:10:28'),
(360,'exemplar',10,10,47,'zustandsaenderung','Zustand geaendert: BUCH-GE-001','Geschichte 9 wurde mit Zustand gut verbucht.','weboberflaeche','2026-04-14 20:10:28'),
(361,'ausleihe',45,7,45,'verlaengerung','Ausleihe verlaengert: BUCH-MA-001','Mathematik 7 fuer Ben Fischer 01a 06 wurde von Sun Apr 19 2026 14:00:00 GMT+0200 (Mitteleuropäische Sommerzeit) auf 2026-04-29T14:00 verlaengert.','weboberflaeche','2026-04-14 20:12:15'),
(362,'ausleihe',54,16,54,'ausgabe','Ausleihe erstellt: BUCH-DE-002','Deutsch 7 wurde an Herr Waedt ausgegeben. Faellig am 2026-04-21 23:59:59.','weboberflaeche','2026-04-14 20:13:03'),
(363,'exemplar',16,16,54,'status_aenderung','Status geaendert: BUCH-DE-002','Deutsch 7 wurde auf ausgeliehen gesetzt.','weboberflaeche','2026-04-14 20:13:03');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
(6,'beamer','Beamer und Projektionsgeraete.',1);
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
  `sortierung` int(10) unsigned NOT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_klassen_bezeichnung` (`bezeichnung`),
  KEY `idx_klassen_stufe` (`stufe`),
  KEY `idx_klassen_sortierung` (`sortierung`)
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `klassen`
--

LOCK TABLES `klassen` WRITE;
/*!40000 ALTER TABLE `klassen` DISABLE KEYS */;
INSERT INTO `klassen` VALUES
(1,'01a','01','a',11,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(2,'02a','02','a',21,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(3,'03a','03','a',31,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(4,'04a','04','a',41,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(5,'05a','05','a',51,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(6,'06a','06','a',61,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(7,'07a','07','a',71,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(8,'08a','08','a',81,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(9,'09a','09','a',91,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(10,'10a','10','a',101,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(14,'01b','01','b',12,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(15,'02b','02','b',22,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(16,'03b','03','b',32,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(17,'04b','04','b',42,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(18,'05b','05','b',52,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(19,'06b','06','b',62,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(20,'07b','07','b',72,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(21,'08b','08','b',82,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(22,'09b','09','b',92,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(23,'10b','10','b',102,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(27,'01c','01','c',13,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(28,'02c','02','c',23,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(29,'03c','03','c',33,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(30,'04c','04','c',43,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(31,'05c','05','c',53,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(32,'06c','06','c',63,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(33,'07c','07','c',73,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(34,'08c','08','c',83,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(35,'09c','09','c',93,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(36,'10c','10','c',103,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(40,'01d','01','d',14,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(41,'02d','02','d',24,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(42,'03d','03','d',34,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(43,'04d','04','d',44,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(44,'05d','05','d',54,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(45,'06d','06','d',64,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(46,'07d','07','d',74,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(47,'08d','08','d',84,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(48,'09d','09','d',94,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(49,'10d','10','d',104,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(53,'01e','01','e',15,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(54,'02e','02','e',25,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(55,'03e','03','e',35,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(56,'04e','04','e',45,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(57,'05e','05','e',55,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(58,'06e','06','e',65,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(59,'07e','07','e',75,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(60,'08e','08','e',85,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(61,'09e','09','e',95,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(62,'10e','10','e',105,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(66,'01f','01','f',16,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(67,'02f','02','f',26,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(68,'03f','03','f',36,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(69,'04f','04','f',46,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(70,'05f','05','f',56,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(71,'06f','06','f',66,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(72,'07f','07','f',76,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(73,'08f','08','f',86,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(74,'09f','09','f',96,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(75,'10f','10','f',106,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(79,'01g','01','g',17,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(80,'02g','02','g',27,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(81,'03g','03','g',37,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(82,'04g','04','g',47,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(83,'05g','05','g',57,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(84,'06g','06','g',67,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(85,'07g','07','g',77,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(86,'08g','08','g',87,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(87,'09g','09','g',97,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(88,'10g','10','g',107,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(92,'01h','01','h',18,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(93,'02h','02','h',28,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(94,'03h','03','h',38,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(95,'04h','04','h',48,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(96,'05h','05','h',58,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(97,'06h','06','h',68,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(98,'07h','07','h',78,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(99,'08h','08','h',88,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(100,'09h','09','h',98,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(101,'10h','10','h',108,1,'2026-04-09 11:00:15','2026-04-09 11:00:15'),
(162,'EF','EF',NULL,140,1,'2026-04-09 11:02:56','2026-04-09 11:02:56'),
(163,'Q1','Q1',NULL,150,1,'2026-04-09 11:02:56','2026-04-09 11:02:56'),
(164,'Q2','Q2',NULL,160,1,'2026-04-09 11:02:56','2026-04-09 11:02:56'),
(165,'11','11',NULL,110,1,'2026-04-09 11:03:27','2026-04-09 11:03:27'),
(166,'12','12',NULL,120,1,'2026-04-09 11:03:27','2026-04-09 11:03:27'),
(167,'13','13',NULL,130,1,'2026-04-09 11:03:27','2026-04-09 11:03:27');
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
  UNIQUE KEY `uq_lehrkraefte_email` (`email`),
  KEY `idx_lehrkraefte_name` (`nachname`,`vorname`),
  KEY `idx_lehrkraefte_anzeigename` (`anzeigename`),
  KEY `idx_lehrkraefte_fachbereich` (`fachbereich`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lehrkraefte`
--

LOCK TABLES `lehrkraefte` WRITE;
/*!40000 ALTER TABLE `lehrkraefte` DISABLE KEYS */;
INSERT INTO `lehrkraefte` VALUES
(1,'BCK','Frau','Anna','Becker','Frau Anna Becker','L-BCK-001','anna.becker@schule.local','Deutsch',1,'Beispiel-Lehrkraft fuer Deutsch.','2026-04-09 11:27:18','2026-04-09 11:27:18'),
(2,'SND','Herr','Tobias','Schneider','Herr Tobias Schneider','L-SND-001','tobias.schneider@schule.local','Informatik',1,'Beispiel-Lehrkraft fuer IT und Medien.','2026-04-09 11:27:18','2026-04-09 11:27:18'),
(3,'MLR','Frau','Sarah','Mueller','Frau Sarah Mueller','L-MLR-001','sarah.mueller@schule.local','Mathematik',1,'Beispiel-Lehrkraft fuer Mathematik.','2026-04-09 11:27:18','2026-04-09 11:27:18'),
(4,'KCH','Herr','David','Koch','Herr David Koch','L-KCH-001','david.koch@schule.local','Biologie',1,'Beispiel-Lehrkraft fuer Naturwissenschaften.','2026-04-09 11:27:18','2026-04-09 11:27:18'),
(5,'WGN','Frau','Julia','Wagner','Frau Julia Wagner','L-WGN-001','julia.wagner@schule.local','Englisch',1,'Beispiel-Lehrkraft fuer Fremdsprachen.','2026-04-09 11:27:18','2026-04-09 11:27:18'),
(6,'HFM','Herr','Lars','Hoffmann','Herr Lars Hoffmann','L-HFM-001','lars.hoffmann@schule.local','Geschichte',1,'Beispiel-Lehrkraft fuer Gesellschaftslehre.','2026-04-09 11:27:18','2026-04-09 11:27:18'),
(7,'NMN','Frau','Katrin','Neumann','Frau Katrin Neumann','L-NMN-001','katrin.neumann@schule.local','Kunst',1,'Beispiel-Lehrkraft fuer Kunst.','2026-04-09 11:27:18','2026-04-09 11:27:18'),
(8,'FSR','Herr','Jan','Fischer','Herr Jan Fischer','L-FSR-001','jan.fischer@schule.local','Sport',1,'Beispiel-Lehrkraft fuer Sport.','2026-04-09 11:27:18','2026-04-09 11:27:18');
/*!40000 ALTER TABLE `lehrkraefte` ENABLE KEYS */;
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
  `vorname` varchar(100) NOT NULL,
  `nachname` varchar(100) NOT NULL,
  `anzeigename` varchar(220) NOT NULL,
  `barcode` varchar(150) DEFAULT NULL,
  `geburtsdatum` date DEFAULT NULL,
  `aktiv` tinyint(1) NOT NULL DEFAULT 1,
  `notizen` text DEFAULT NULL,
  `erstellt_am` datetime NOT NULL DEFAULT current_timestamp(),
  `aktualisiert_am` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_schueler_barcode` (`barcode`),
  KEY `idx_schueler_name` (`nachname`,`vorname`),
  KEY `idx_schueler_anzeigename` (`anzeigename`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schueler`
--

LOCK TABLES `schueler` WRITE;
/*!40000 ALTER TABLE `schueler` DISABLE KEYS */;
INSERT INTO `schueler` VALUES
(1,'Mia','Beispiel 01a','Mia Beispiel 01a 01','S-01A-001','2012-05-02',1,'Beispielschueler fuer Klasse 01a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(2,'Noah','Muster 01a','Noah Muster 01a 02','S-01A-002','2012-05-03',1,'Beispielschueler fuer Klasse 01a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(3,'Emma','Sommer 01a','Emma Sommer 01a 03','S-01A-003','2012-05-04',1,'Beispielschueler fuer Klasse 01a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(4,'Luca','Winter 01a','Luca Winter 01a 04','S-01A-004','2012-05-05',1,'Beispielschueler fuer Klasse 01a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(5,'Lea','Schulz 01a','Lea Schulz 01a 05','S-01A-005','2012-05-06',1,'Beispielschueler fuer Klasse 01a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(6,'Ben','Fischer 01a','Ben Fischer 01a 06','S-01A-006','2012-05-07',1,'Beispielschueler fuer Klasse 01a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(7,'Ida','Neumann 01a','Ida Neumann 01a 07','S-01A-007','2012-05-08',1,'Beispielschueler fuer Klasse 01a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(8,'Jonas','Klein 01a','Jonas Klein 01a 08','S-01A-008','2012-05-09',1,'Beispielschueler fuer Klasse 01a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(9,'Leni','Wagner 01a','Leni Wagner 01a 09','S-01A-009','2012-05-10',1,'Beispielschueler fuer Klasse 01a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(10,'Paul','Hoffmann 01a','Paul Hoffmann 01a 10','S-01A-010','2012-05-11',1,'Beispielschueler fuer Klasse 01a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(11,'Mia','Beispiel 02a','Mia Beispiel 02a 01','S-02A-001','2012-08-20',1,'Beispielschueler fuer Klasse 02a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(12,'Noah','Muster 02a','Noah Muster 02a 02','S-02A-002','2012-08-21',1,'Beispielschueler fuer Klasse 02a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(13,'Emma','Sommer 02a','Emma Sommer 02a 03','S-02A-003','2012-08-22',1,'Beispielschueler fuer Klasse 02a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(14,'Luca','Winter 02a','Luca Winter 02a 04','S-02A-004','2012-08-23',1,'Beispielschueler fuer Klasse 02a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(15,'Lea','Schulz 02a','Lea Schulz 02a 05','S-02A-005','2012-08-24',1,'Beispielschueler fuer Klasse 02a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(16,'Ben','Fischer 02a','Ben Fischer 02a 06','S-02A-006','2012-08-25',1,'Beispielschueler fuer Klasse 02a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(17,'Ida','Neumann 02a','Ida Neumann 02a 07','S-02A-007','2012-08-26',1,'Beispielschueler fuer Klasse 02a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(18,'Jonas','Klein 02a','Jonas Klein 02a 08','S-02A-008','2012-08-27',1,'Beispielschueler fuer Klasse 02a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(19,'Leni','Wagner 02a','Leni Wagner 02a 09','S-02A-009','2012-08-28',1,'Beispielschueler fuer Klasse 02a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(20,'Paul','Hoffmann 02a','Paul Hoffmann 02a 10','S-02A-010','2012-08-29',1,'Beispielschueler fuer Klasse 02a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(21,'Mia','Beispiel 03a','Mia Beispiel 03a 01','S-03A-001','2012-12-08',1,'Beispielschueler fuer Klasse 03a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(22,'Noah','Muster 03a','Noah Muster 03a 02','S-03A-002','2012-12-09',1,'Beispielschueler fuer Klasse 03a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(23,'Emma','Sommer 03a','Emma Sommer 03a 03','S-03A-003','2012-12-10',1,'Beispielschueler fuer Klasse 03a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(24,'Luca','Winter 03a','Luca Winter 03a 04','S-03A-004','2012-12-11',1,'Beispielschueler fuer Klasse 03a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(25,'Lea','Schulz 03a','Lea Schulz 03a 05','S-03A-005','2012-12-12',1,'Beispielschueler fuer Klasse 03a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(26,'Ben','Fischer 03a','Ben Fischer 03a 06','S-03A-006','2012-12-13',1,'Beispielschueler fuer Klasse 03a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(27,'Ida','Neumann 03a','Ida Neumann 03a 07','S-03A-007','2012-12-14',1,'Beispielschueler fuer Klasse 03a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(28,'Jonas','Klein 03a','Jonas Klein 03a 08','S-03A-008','2012-12-15',1,'Beispielschueler fuer Klasse 03a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(29,'Leni','Wagner 03a','Leni Wagner 03a 09','S-03A-009','2012-12-16',1,'Beispielschueler fuer Klasse 03a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(30,'Paul','Hoffmann 03a','Paul Hoffmann 03a 10','S-03A-010','2012-12-17',1,'Beispielschueler fuer Klasse 03a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(31,'Mia','Beispiel 04a','Mia Beispiel 04a 01','S-04A-001','2013-03-28',1,'Beispielschueler fuer Klasse 04a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(32,'Noah','Muster 04a','Noah Muster 04a 02','S-04A-002','2013-03-29',1,'Beispielschueler fuer Klasse 04a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(33,'Emma','Sommer 04a','Emma Sommer 04a 03','S-04A-003','2013-03-30',1,'Beispielschueler fuer Klasse 04a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(34,'Luca','Winter 04a','Luca Winter 04a 04','S-04A-004','2013-03-31',1,'Beispielschueler fuer Klasse 04a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(35,'Lea','Schulz 04a','Lea Schulz 04a 05','S-04A-005','2013-04-01',1,'Beispielschueler fuer Klasse 04a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(36,'Ben','Fischer 04a','Ben Fischer 04a 06','S-04A-006','2013-04-02',1,'Beispielschueler fuer Klasse 04a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(37,'Ida','Neumann 04a','Ida Neumann 04a 07','S-04A-007','2013-04-03',1,'Beispielschueler fuer Klasse 04a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(38,'Jonas','Klein 04a','Jonas Klein 04a 08','S-04A-008','2013-04-04',1,'Beispielschueler fuer Klasse 04a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(39,'Leni','Wagner 04a','Leni Wagner 04a 09','S-04A-009','2013-04-05',1,'Beispielschueler fuer Klasse 04a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(40,'Paul','Hoffmann 04a','Paul Hoffmann 04a 10','S-04A-010','2013-04-06',1,'Beispielschueler fuer Klasse 04a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(41,'Mia','Beispiel 05a','Mia Beispiel 05a 01','S-05A-001','2013-07-16',1,'Beispielschueler fuer Klasse 05a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(42,'Noah','Muster 05a','Noah Muster 05a 02','S-05A-002','2013-07-17',1,'Beispielschueler fuer Klasse 05a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(43,'Emma','Sommer 05a','Emma Sommer 05a 03','S-05A-003','2013-07-18',1,'Beispielschueler fuer Klasse 05a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(44,'Luca','Winter 05a','Luca Winter 05a 04','S-05A-004','2013-07-19',1,'Beispielschueler fuer Klasse 05a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(45,'Lea','Schulz 05a','Lea Schulz 05a 05','S-05A-005','2013-07-20',1,'Beispielschueler fuer Klasse 05a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(46,'Ben','Fischer 05a','Ben Fischer 05a 06','S-05A-006','2013-07-21',1,'Beispielschueler fuer Klasse 05a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(47,'Ida','Neumann 05a','Ida Neumann 05a 07','S-05A-007','2013-07-22',1,'Beispielschueler fuer Klasse 05a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(48,'Jonas','Klein 05a','Jonas Klein 05a 08','S-05A-008','2013-07-23',1,'Beispielschueler fuer Klasse 05a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(49,'Leni','Wagner 05a','Leni Wagner 05a 09','S-05A-009','2013-07-24',1,'Beispielschueler fuer Klasse 05a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(50,'Paul','Hoffmann 05a','Paul Hoffmann 05a 10','S-05A-010','2013-07-25',1,'Beispielschueler fuer Klasse 05a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(51,'Mia','Beispiel 06a','Mia Beispiel 06a 01','S-06A-001','2013-11-03',1,'Beispielschueler fuer Klasse 06a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(52,'Noah','Muster 06a','Noah Muster 06a 02','S-06A-002','2013-11-04',1,'Beispielschueler fuer Klasse 06a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(53,'Emma','Sommer 06a','Emma Sommer 06a 03','S-06A-003','2013-11-05',1,'Beispielschueler fuer Klasse 06a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(54,'Luca','Winter 06a','Luca Winter 06a 04','S-06A-004','2013-11-06',1,'Beispielschueler fuer Klasse 06a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(55,'Lea','Schulz 06a','Lea Schulz 06a 05','S-06A-005','2013-11-07',1,'Beispielschueler fuer Klasse 06a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(56,'Ben','Fischer 06a','Ben Fischer 06a 06','S-06A-006','2013-11-08',1,'Beispielschueler fuer Klasse 06a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(57,'Ida','Neumann 06a','Ida Neumann 06a 07','S-06A-007','2013-11-09',1,'Beispielschueler fuer Klasse 06a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(58,'Jonas','Klein 06a','Jonas Klein 06a 08','S-06A-008','2013-11-10',1,'Beispielschueler fuer Klasse 06a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(59,'Leni','Wagner 06a','Leni Wagner 06a 09','S-06A-009','2013-11-11',1,'Beispielschueler fuer Klasse 06a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(60,'Paul','Hoffmann 06a','Paul Hoffmann 06a 10','S-06A-010','2013-11-12',1,'Beispielschueler fuer Klasse 06a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(61,'Mia','Beispiel 07a','Mia Beispiel 07a 01','S-07A-001','2014-02-21',1,'Beispielschueler fuer Klasse 07a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(62,'Noah','Muster 07a','Noah Muster 07a 02','S-07A-002','2014-02-22',1,'Beispielschueler fuer Klasse 07a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(63,'Emma','Sommer 07a','Emma Sommer 07a 03','S-07A-003','2014-02-23',1,'Beispielschueler fuer Klasse 07a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(64,'Luca','Winter 07a','Luca Winter 07a 04','S-07A-004','2014-02-24',1,'Beispielschueler fuer Klasse 07a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(65,'Lea','Schulz 07a','Lea Schulz 07a 05','S-07A-005','2014-02-25',1,'Beispielschueler fuer Klasse 07a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(66,'Ben','Fischer 07a','Ben Fischer 07a 06','S-07A-006','2014-02-26',1,'Beispielschueler fuer Klasse 07a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(67,'Ida','Neumann 07a','Ida Neumann 07a 07','S-07A-007','2014-02-27',1,'Beispielschueler fuer Klasse 07a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(68,'Jonas','Klein 07a','Jonas Klein 07a 08','S-07A-008','2014-02-28',1,'Beispielschueler fuer Klasse 07a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(69,'Leni','Wagner 07a','Leni Wagner 07a 09','S-07A-009','2014-03-01',1,'Beispielschueler fuer Klasse 07a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(70,'Paul','Hoffmann 07a','Paul Hoffmann 07a 10','S-07A-010','2014-03-02',1,'Beispielschueler fuer Klasse 07a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(71,'Mia','Beispiel 08a','Mia Beispiel 08a 01','S-08A-001','2014-06-11',1,'Beispielschueler fuer Klasse 08a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(72,'Noah','Muster 08a','Noah Muster 08a 02','S-08A-002','2014-06-12',1,'Beispielschueler fuer Klasse 08a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(73,'Emma','Sommer 08a','Emma Sommer 08a 03','S-08A-003','2014-06-13',1,'Beispielschueler fuer Klasse 08a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(74,'Luca','Winter 08a','Luca Winter 08a 04','S-08A-004','2014-06-14',1,'Beispielschueler fuer Klasse 08a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(75,'Lea','Schulz 08a','Lea Schulz 08a 05','S-08A-005','2014-06-15',1,'Beispielschueler fuer Klasse 08a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(76,'Ben','Fischer 08a','Ben Fischer 08a 06','S-08A-006','2014-06-16',1,'Beispielschueler fuer Klasse 08a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(77,'Ida','Neumann 08a','Ida Neumann 08a 07','S-08A-007','2014-06-17',1,'Beispielschueler fuer Klasse 08a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(78,'Jonas','Klein 08a','Jonas Klein 08a 08','S-08A-008','2014-06-18',1,'Beispielschueler fuer Klasse 08a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(79,'Leni','Wagner 08a','Leni Wagner 08a 09','S-08A-009','2014-06-19',1,'Beispielschueler fuer Klasse 08a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(80,'Paul','Hoffmann 08a','Paul Hoffmann 08a 10','S-08A-010','2014-06-20',1,'Beispielschueler fuer Klasse 08a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(81,'Mia','Beispiel 09a','Mia Beispiel 09a 01','S-09A-001','2014-09-29',1,'Beispielschueler fuer Klasse 09a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(82,'Noah','Muster 09a','Noah Muster 09a 02','S-09A-002','2014-09-30',1,'Beispielschueler fuer Klasse 09a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(83,'Emma','Sommer 09a','Emma Sommer 09a 03','S-09A-003','2014-10-01',1,'Beispielschueler fuer Klasse 09a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(84,'Luca','Winter 09a','Luca Winter 09a 04','S-09A-004','2014-10-02',1,'Beispielschueler fuer Klasse 09a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(85,'Lea','Schulz 09a','Lea Schulz 09a 05','S-09A-005','2014-10-03',1,'Beispielschueler fuer Klasse 09a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(86,'Ben','Fischer 09a','Ben Fischer 09a 06','S-09A-006','2014-10-04',1,'Beispielschueler fuer Klasse 09a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(87,'Ida','Neumann 09a','Ida Neumann 09a 07','S-09A-007','2014-10-05',1,'Beispielschueler fuer Klasse 09a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(88,'Jonas','Klein 09a','Jonas Klein 09a 08','S-09A-008','2014-10-06',1,'Beispielschueler fuer Klasse 09a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(89,'Leni','Wagner 09a','Leni Wagner 09a 09','S-09A-009','2014-10-07',1,'Beispielschueler fuer Klasse 09a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(90,'Paul','Hoffmann 09a','Paul Hoffmann 09a 10','S-09A-010','2014-10-08',1,'Beispielschueler fuer Klasse 09a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(91,'Mia','Beispiel 10a','Mia Beispiel 10a 01','S-10A-001','2015-01-17',1,'Beispielschueler fuer Klasse 10a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(92,'Noah','Muster 10a','Noah Muster 10a 02','S-10A-002','2015-01-18',1,'Beispielschueler fuer Klasse 10a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(93,'Emma','Sommer 10a','Emma Sommer 10a 03','S-10A-003','2015-01-19',1,'Beispielschueler fuer Klasse 10a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(94,'Luca','Winter 10a','Luca Winter 10a 04','S-10A-004','2015-01-20',1,'Beispielschueler fuer Klasse 10a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(95,'Lea','Schulz 10a','Lea Schulz 10a 05','S-10A-005','2015-01-21',1,'Beispielschueler fuer Klasse 10a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(96,'Ben','Fischer 10a','Ben Fischer 10a 06','S-10A-006','2015-01-22',1,'Beispielschueler fuer Klasse 10a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(97,'Ida','Neumann 10a','Ida Neumann 10a 07','S-10A-007','2015-01-23',1,'Beispielschueler fuer Klasse 10a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(98,'Jonas','Klein 10a','Jonas Klein 10a 08','S-10A-008','2015-01-24',1,'Beispielschueler fuer Klasse 10a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(99,'Leni','Wagner 10a','Leni Wagner 10a 09','S-10A-009','2015-01-25',1,'Beispielschueler fuer Klasse 10a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(100,'Paul','Hoffmann 10a','Paul Hoffmann 10a 10','S-10A-010','2015-01-26',1,'Beispielschueler fuer Klasse 10a.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(101,'Mia','Beispiel 01b','Mia Beispiel 01b 01','S-01B-001','2012-05-13',1,'Beispielschueler fuer Klasse 01b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(102,'Noah','Muster 01b','Noah Muster 01b 02','S-01B-002','2012-05-14',1,'Beispielschueler fuer Klasse 01b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(103,'Emma','Sommer 01b','Emma Sommer 01b 03','S-01B-003','2012-05-15',1,'Beispielschueler fuer Klasse 01b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(104,'Luca','Winter 01b','Luca Winter 01b 04','S-01B-004','2012-05-16',1,'Beispielschueler fuer Klasse 01b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(105,'Lea','Schulz 01b','Lea Schulz 01b 05','S-01B-005','2012-05-17',1,'Beispielschueler fuer Klasse 01b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(106,'Ben','Fischer 01b','Ben Fischer 01b 06','S-01B-006','2012-05-18',1,'Beispielschueler fuer Klasse 01b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(107,'Ida','Neumann 01b','Ida Neumann 01b 07','S-01B-007','2012-05-19',1,'Beispielschueler fuer Klasse 01b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(108,'Jonas','Klein 01b','Jonas Klein 01b 08','S-01B-008','2012-05-20',1,'Beispielschueler fuer Klasse 01b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(109,'Leni','Wagner 01b','Leni Wagner 01b 09','S-01B-009','2012-05-21',1,'Beispielschueler fuer Klasse 01b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(110,'Paul','Hoffmann 01b','Paul Hoffmann 01b 10','S-01B-010','2012-05-22',1,'Beispielschueler fuer Klasse 01b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(111,'Mia','Beispiel 02b','Mia Beispiel 02b 01','S-02B-001','2012-08-31',1,'Beispielschueler fuer Klasse 02b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(112,'Noah','Muster 02b','Noah Muster 02b 02','S-02B-002','2012-09-01',1,'Beispielschueler fuer Klasse 02b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(113,'Emma','Sommer 02b','Emma Sommer 02b 03','S-02B-003','2012-09-02',1,'Beispielschueler fuer Klasse 02b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(114,'Luca','Winter 02b','Luca Winter 02b 04','S-02B-004','2012-09-03',1,'Beispielschueler fuer Klasse 02b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(115,'Lea','Schulz 02b','Lea Schulz 02b 05','S-02B-005','2012-09-04',1,'Beispielschueler fuer Klasse 02b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(116,'Ben','Fischer 02b','Ben Fischer 02b 06','S-02B-006','2012-09-05',1,'Beispielschueler fuer Klasse 02b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(117,'Ida','Neumann 02b','Ida Neumann 02b 07','S-02B-007','2012-09-06',1,'Beispielschueler fuer Klasse 02b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(118,'Jonas','Klein 02b','Jonas Klein 02b 08','S-02B-008','2012-09-07',1,'Beispielschueler fuer Klasse 02b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(119,'Leni','Wagner 02b','Leni Wagner 02b 09','S-02B-009','2012-09-08',1,'Beispielschueler fuer Klasse 02b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(120,'Paul','Hoffmann 02b','Paul Hoffmann 02b 10','S-02B-010','2012-09-09',1,'Beispielschueler fuer Klasse 02b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(121,'Mia','Beispiel 03b','Mia Beispiel 03b 01','S-03B-001','2012-12-19',1,'Beispielschueler fuer Klasse 03b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(122,'Noah','Muster 03b','Noah Muster 03b 02','S-03B-002','2012-12-20',1,'Beispielschueler fuer Klasse 03b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(123,'Emma','Sommer 03b','Emma Sommer 03b 03','S-03B-003','2012-12-21',1,'Beispielschueler fuer Klasse 03b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(124,'Luca','Winter 03b','Luca Winter 03b 04','S-03B-004','2012-12-22',1,'Beispielschueler fuer Klasse 03b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(125,'Lea','Schulz 03b','Lea Schulz 03b 05','S-03B-005','2012-12-23',1,'Beispielschueler fuer Klasse 03b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(126,'Ben','Fischer 03b','Ben Fischer 03b 06','S-03B-006','2012-12-24',1,'Beispielschueler fuer Klasse 03b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(127,'Ida','Neumann 03b','Ida Neumann 03b 07','S-03B-007','2012-12-25',1,'Beispielschueler fuer Klasse 03b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(128,'Jonas','Klein 03b','Jonas Klein 03b 08','S-03B-008','2012-12-26',1,'Beispielschueler fuer Klasse 03b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(129,'Leni','Wagner 03b','Leni Wagner 03b 09','S-03B-009','2012-12-27',1,'Beispielschueler fuer Klasse 03b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(130,'Paul','Hoffmann 03b','Paul Hoffmann 03b 10','S-03B-010','2012-12-28',1,'Beispielschueler fuer Klasse 03b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(131,'Mia','Beispiel 04b','Mia Beispiel 04b 01','S-04B-001','2013-04-08',1,'Beispielschueler fuer Klasse 04b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(132,'Noah','Muster 04b','Noah Muster 04b 02','S-04B-002','2013-04-09',1,'Beispielschueler fuer Klasse 04b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(133,'Emma','Sommer 04b','Emma Sommer 04b 03','S-04B-003','2013-04-10',1,'Beispielschueler fuer Klasse 04b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(134,'Luca','Winter 04b','Luca Winter 04b 04','S-04B-004','2013-04-11',1,'Beispielschueler fuer Klasse 04b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(135,'Lea','Schulz 04b','Lea Schulz 04b 05','S-04B-005','2013-04-12',1,'Beispielschueler fuer Klasse 04b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(136,'Ben','Fischer 04b','Ben Fischer 04b 06','S-04B-006','2013-04-13',1,'Beispielschueler fuer Klasse 04b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(137,'Ida','Neumann 04b','Ida Neumann 04b 07','S-04B-007','2013-04-14',1,'Beispielschueler fuer Klasse 04b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(138,'Jonas','Klein 04b','Jonas Klein 04b 08','S-04B-008','2013-04-15',1,'Beispielschueler fuer Klasse 04b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(139,'Leni','Wagner 04b','Leni Wagner 04b 09','S-04B-009','2013-04-16',1,'Beispielschueler fuer Klasse 04b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(140,'Paul','Hoffmann 04b','Paul Hoffmann 04b 10','S-04B-010','2013-04-17',1,'Beispielschueler fuer Klasse 04b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(141,'Mia','Beispiel 05b','Mia Beispiel 05b 01','S-05B-001','2013-07-27',1,'Beispielschueler fuer Klasse 05b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(142,'Noah','Muster 05b','Noah Muster 05b 02','S-05B-002','2013-07-28',1,'Beispielschueler fuer Klasse 05b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(143,'Emma','Sommer 05b','Emma Sommer 05b 03','S-05B-003','2013-07-29',1,'Beispielschueler fuer Klasse 05b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(144,'Luca','Winter 05b','Luca Winter 05b 04','S-05B-004','2013-07-30',1,'Beispielschueler fuer Klasse 05b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(145,'Lea','Schulz 05b','Lea Schulz 05b 05','S-05B-005','2013-07-31',1,'Beispielschueler fuer Klasse 05b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(146,'Ben','Fischer 05b','Ben Fischer 05b 06','S-05B-006','2013-08-01',1,'Beispielschueler fuer Klasse 05b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(147,'Ida','Neumann 05b','Ida Neumann 05b 07','S-05B-007','2013-08-02',1,'Beispielschueler fuer Klasse 05b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(148,'Jonas','Klein 05b','Jonas Klein 05b 08','S-05B-008','2013-08-03',1,'Beispielschueler fuer Klasse 05b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(149,'Leni','Wagner 05b','Leni Wagner 05b 09','S-05B-009','2013-08-04',1,'Beispielschueler fuer Klasse 05b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(150,'Paul','Hoffmann 05b','Paul Hoffmann 05b 10','S-05B-010','2013-08-05',1,'Beispielschueler fuer Klasse 05b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(151,'Mia','Beispiel 06b','Mia Beispiel 06b 01','S-06B-001','2013-11-14',1,'Beispielschueler fuer Klasse 06b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(152,'Noah','Muster 06b','Noah Muster 06b 02','S-06B-002','2013-11-15',1,'Beispielschueler fuer Klasse 06b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(153,'Emma','Sommer 06b','Emma Sommer 06b 03','S-06B-003','2013-11-16',1,'Beispielschueler fuer Klasse 06b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(154,'Luca','Winter 06b','Luca Winter 06b 04','S-06B-004','2013-11-17',1,'Beispielschueler fuer Klasse 06b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(155,'Lea','Schulz 06b','Lea Schulz 06b 05','S-06B-005','2013-11-18',1,'Beispielschueler fuer Klasse 06b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(156,'Ben','Fischer 06b','Ben Fischer 06b 06','S-06B-006','2013-11-19',1,'Beispielschueler fuer Klasse 06b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(157,'Ida','Neumann 06b','Ida Neumann 06b 07','S-06B-007','2013-11-20',1,'Beispielschueler fuer Klasse 06b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(158,'Jonas','Klein 06b','Jonas Klein 06b 08','S-06B-008','2013-11-21',1,'Beispielschueler fuer Klasse 06b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(159,'Leni','Wagner 06b','Leni Wagner 06b 09','S-06B-009','2013-11-22',1,'Beispielschueler fuer Klasse 06b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(160,'Paul','Hoffmann 06b','Paul Hoffmann 06b 10','S-06B-010','2013-11-23',1,'Beispielschueler fuer Klasse 06b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(161,'Mia','Beispiel 07b','Mia Beispiel 07b 01','S-07B-001','2014-03-04',1,'Beispielschueler fuer Klasse 07b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(162,'Noah','Muster 07b','Noah Muster 07b 02','S-07B-002','2014-03-05',1,'Beispielschueler fuer Klasse 07b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(163,'Emma','Sommer 07b','Emma Sommer 07b 03','S-07B-003','2014-03-06',1,'Beispielschueler fuer Klasse 07b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(164,'Luca','Winter 07b','Luca Winter 07b 04','S-07B-004','2014-03-07',1,'Beispielschueler fuer Klasse 07b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(165,'Lea','Schulz 07b','Lea Schulz 07b 05','S-07B-005','2014-03-08',1,'Beispielschueler fuer Klasse 07b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(166,'Ben','Fischer 07b','Ben Fischer 07b 06','S-07B-006','2014-03-09',1,'Beispielschueler fuer Klasse 07b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(167,'Ida','Neumann 07b','Ida Neumann 07b 07','S-07B-007','2014-03-10',1,'Beispielschueler fuer Klasse 07b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(168,'Jonas','Klein 07b','Jonas Klein 07b 08','S-07B-008','2014-03-11',1,'Beispielschueler fuer Klasse 07b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(169,'Leni','Wagner 07b','Leni Wagner 07b 09','S-07B-009','2014-03-12',1,'Beispielschueler fuer Klasse 07b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(170,'Paul','Hoffmann 07b','Paul Hoffmann 07b 10','S-07B-010','2014-03-13',1,'Beispielschueler fuer Klasse 07b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(171,'Mia','Beispiel 08b','Mia Beispiel 08b 01','S-08B-001','2014-06-22',1,'Beispielschueler fuer Klasse 08b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(172,'Noah','Muster 08b','Noah Muster 08b 02','S-08B-002','2014-06-23',1,'Beispielschueler fuer Klasse 08b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(173,'Emma','Sommer 08b','Emma Sommer 08b 03','S-08B-003','2014-06-24',1,'Beispielschueler fuer Klasse 08b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(174,'Luca','Winter 08b','Luca Winter 08b 04','S-08B-004','2014-06-25',1,'Beispielschueler fuer Klasse 08b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(175,'Lea','Schulz 08b','Lea Schulz 08b 05','S-08B-005','2014-06-26',1,'Beispielschueler fuer Klasse 08b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(176,'Ben','Fischer 08b','Ben Fischer 08b 06','S-08B-006','2014-06-27',1,'Beispielschueler fuer Klasse 08b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(177,'Ida','Neumann 08b','Ida Neumann 08b 07','S-08B-007','2014-06-28',1,'Beispielschueler fuer Klasse 08b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(178,'Jonas','Klein 08b','Jonas Klein 08b 08','S-08B-008','2014-06-29',1,'Beispielschueler fuer Klasse 08b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(179,'Leni','Wagner 08b','Leni Wagner 08b 09','S-08B-009','2014-06-30',1,'Beispielschueler fuer Klasse 08b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(180,'Paul','Hoffmann 08b','Paul Hoffmann 08b 10','S-08B-010','2014-07-01',1,'Beispielschueler fuer Klasse 08b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(181,'Mia','Beispiel 09b','Mia Beispiel 09b 01','S-09B-001','2014-10-10',1,'Beispielschueler fuer Klasse 09b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(182,'Noah','Muster 09b','Noah Muster 09b 02','S-09B-002','2014-10-11',1,'Beispielschueler fuer Klasse 09b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(183,'Emma','Sommer 09b','Emma Sommer 09b 03','S-09B-003','2014-10-12',1,'Beispielschueler fuer Klasse 09b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(184,'Luca','Winter 09b','Luca Winter 09b 04','S-09B-004','2014-10-13',1,'Beispielschueler fuer Klasse 09b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(185,'Lea','Schulz 09b','Lea Schulz 09b 05','S-09B-005','2014-10-14',1,'Beispielschueler fuer Klasse 09b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(186,'Ben','Fischer 09b','Ben Fischer 09b 06','S-09B-006','2014-10-15',1,'Beispielschueler fuer Klasse 09b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(187,'Ida','Neumann 09b','Ida Neumann 09b 07','S-09B-007','2014-10-16',1,'Beispielschueler fuer Klasse 09b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(188,'Jonas','Klein 09b','Jonas Klein 09b 08','S-09B-008','2014-10-17',1,'Beispielschueler fuer Klasse 09b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(189,'Leni','Wagner 09b','Leni Wagner 09b 09','S-09B-009','2014-10-18',1,'Beispielschueler fuer Klasse 09b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(190,'Paul','Hoffmann 09b','Paul Hoffmann 09b 10','S-09B-010','2014-10-19',1,'Beispielschueler fuer Klasse 09b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(191,'Mia','Beispiel 10b','Mia Beispiel 10b 01','S-10B-001','2015-01-28',1,'Beispielschueler fuer Klasse 10b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(192,'Noah','Muster 10b','Noah Muster 10b 02','S-10B-002','2015-01-29',1,'Beispielschueler fuer Klasse 10b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(193,'Emma','Sommer 10b','Emma Sommer 10b 03','S-10B-003','2015-01-30',1,'Beispielschueler fuer Klasse 10b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(194,'Luca','Winter 10b','Luca Winter 10b 04','S-10B-004','2015-01-31',1,'Beispielschueler fuer Klasse 10b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(195,'Lea','Schulz 10b','Lea Schulz 10b 05','S-10B-005','2015-02-01',1,'Beispielschueler fuer Klasse 10b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(196,'Ben','Fischer 10b','Ben Fischer 10b 06','S-10B-006','2015-02-02',1,'Beispielschueler fuer Klasse 10b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(197,'Ida','Neumann 10b','Ida Neumann 10b 07','S-10B-007','2015-02-03',1,'Beispielschueler fuer Klasse 10b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(198,'Jonas','Klein 10b','Jonas Klein 10b 08','S-10B-008','2015-02-04',1,'Beispielschueler fuer Klasse 10b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(199,'Leni','Wagner 10b','Leni Wagner 10b 09','S-10B-009','2015-02-05',1,'Beispielschueler fuer Klasse 10b.','2026-04-09 11:13:05','2026-04-09 11:13:05'),
(200,'Paul','Hoffmann 10b','Paul Hoffmann 10b 10','S-10B-010','2015-02-06',1,'Beispielschueler fuer Klasse 10b.','2026-04-09 11:13:05','2026-04-09 11:13:05');
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
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schueler_klassen`
--

LOCK TABLES `schueler_klassen` WRITE;
/*!40000 ALTER TABLE `schueler_klassen` DISABLE KEYS */;
INSERT INTO `schueler_klassen` VALUES
(1,1,1,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(2,2,1,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(3,3,1,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(4,4,1,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(5,5,1,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(6,6,1,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(7,7,1,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(8,8,1,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(9,9,1,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(10,10,1,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(11,11,2,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(12,12,2,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(13,13,2,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(14,14,2,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(15,15,2,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(16,16,2,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(17,17,2,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(18,18,2,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(19,19,2,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(20,20,2,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(21,21,3,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(22,22,3,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(23,23,3,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(24,24,3,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(25,25,3,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(26,26,3,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(27,27,3,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(28,28,3,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(29,29,3,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(30,30,3,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(31,31,4,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(32,32,4,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(33,33,4,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(34,34,4,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(35,35,4,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(36,36,4,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(37,37,4,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(38,38,4,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(39,39,4,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(40,40,4,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(41,41,5,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(42,42,5,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(43,43,5,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(44,44,5,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(45,45,5,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(46,46,5,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(47,47,5,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(48,48,5,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(49,49,5,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(50,50,5,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(51,51,6,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(52,52,6,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(53,53,6,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(54,54,6,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(55,55,6,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(56,56,6,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(57,57,6,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(58,58,6,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(59,59,6,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(60,60,6,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(61,61,7,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(62,62,7,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(63,63,7,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(64,64,7,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(65,65,7,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(66,66,7,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(67,67,7,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(68,68,7,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(69,69,7,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(70,70,7,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(71,71,8,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(72,72,8,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(73,73,8,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(74,74,8,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(75,75,8,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(76,76,8,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(77,77,8,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(78,78,8,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(79,79,8,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(80,80,8,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(81,81,9,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(82,82,9,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(83,83,9,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(84,84,9,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(85,85,9,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(86,86,9,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(87,87,9,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(88,88,9,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(89,89,9,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(90,90,9,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(91,91,10,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(92,92,10,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(93,93,10,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(94,94,10,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(95,95,10,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(96,96,10,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(97,97,10,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(98,98,10,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(99,99,10,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(100,100,10,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(101,101,14,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(102,102,14,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(103,103,14,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(104,104,14,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(105,105,14,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(106,106,14,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(107,107,14,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(108,108,14,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(109,109,14,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(110,110,14,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(111,111,15,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(112,112,15,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(113,113,15,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(114,114,15,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(115,115,15,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(116,116,15,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(117,117,15,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(118,118,15,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(119,119,15,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(120,120,15,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(121,121,16,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(122,122,16,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(123,123,16,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(124,124,16,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(125,125,16,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(126,126,16,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(127,127,16,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(128,128,16,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(129,129,16,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(130,130,16,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(131,131,17,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(132,132,17,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(133,133,17,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(134,134,17,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(135,135,17,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(136,136,17,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(137,137,17,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(138,138,17,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(139,139,17,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(140,140,17,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(141,141,18,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(142,142,18,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(143,143,18,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(144,144,18,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(145,145,18,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(146,146,18,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(147,147,18,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(148,148,18,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(149,149,18,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(150,150,18,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(151,151,19,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(152,152,19,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(153,153,19,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(154,154,19,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(155,155,19,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(156,156,19,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(157,157,19,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(158,158,19,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(159,159,19,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(160,160,19,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(161,161,20,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(162,162,20,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(163,163,20,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(164,164,20,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(165,165,20,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(166,166,20,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(167,167,20,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(168,168,20,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(169,169,20,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(170,170,20,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(171,171,21,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(172,172,21,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(173,173,21,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(174,174,21,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(175,175,21,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(176,176,21,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(177,177,21,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(178,178,21,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(179,179,21,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(180,180,21,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(181,181,22,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(182,182,22,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(183,183,22,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(184,184,22,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(185,185,22,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(186,186,22,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(187,187,22,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(188,188,22,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(189,189,22,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(190,190,22,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(191,191,23,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(192,192,23,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(193,193,23,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(194,194,23,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(195,195,23,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(196,196,23,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(197,197,23,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(198,198,23,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(199,199,23,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05'),
(200,200,23,'2026/27','2026-08-20',NULL,1,'2026-04-09 11:13:05','2026-04-09 11:13:05');
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

-- Dump completed on 2026-04-16  0:04:07
