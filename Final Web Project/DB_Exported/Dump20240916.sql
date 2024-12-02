CREATE DATABASE  IF NOT EXISTS `kata_strofh` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `kata_strofh`;
-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: kata_strofh
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrator`
--

DROP TABLE IF EXISTS `administrator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `administrator` (
  `UserID` int DEFAULT NULL,
  `AdminID` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`AdminID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `administrator_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrator`
--

LOCK TABLES `administrator` WRITE;
/*!40000 ALTER TABLE `administrator` DISABLE KEYS */;
INSERT INTO `administrator` VALUES (11,1),(12,2),(13,3),(14,4);
/*!40000 ALTER TABLE `administrator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcementitems`
--

DROP TABLE IF EXISTS `announcementitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcementitems` (
  `AnnouncementItemID` int NOT NULL AUTO_INCREMENT,
  `AnnouncementID` int DEFAULT NULL,
  `ItemID` int DEFAULT NULL,
  `Quantity` int NOT NULL,
  PRIMARY KEY (`AnnouncementItemID`),
  UNIQUE KEY `uq_announcement_item` (`AnnouncementID`,`ItemID`),
  KEY `AnnouncementID` (`AnnouncementID`),
  KEY `ItemID` (`ItemID`),
  CONSTRAINT `announcementitems_ibfk_1` FOREIGN KEY (`AnnouncementID`) REFERENCES `announcements` (`AnnouncementID`) ON DELETE CASCADE,
  CONSTRAINT `announcementitems_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `items` (`ItemID`) ON DELETE CASCADE,
  CONSTRAINT `announcementitems_chk_1` CHECK ((`Quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcementitems`
--

LOCK TABLES `announcementitems` WRITE;
/*!40000 ALTER TABLE `announcementitems` DISABLE KEYS */;
INSERT INTO `announcementitems` VALUES (1,1,1,10),(2,1,2,50),(3,2,3,75),(4,2,1,150),(5,3,2,200),(6,4,3,100),(7,7,1,100),(8,7,3,50),(9,7,7,70),(10,8,4,2),(12,9,4,2),(13,9,6,2),(14,9,3,22);
/*!40000 ALTER TABLE `announcementitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcements` (
  `AnnouncementID` int NOT NULL AUTO_INCREMENT,
  `AdminID` int DEFAULT NULL,
  `DateCreated` datetime NOT NULL,
  PRIMARY KEY (`AnnouncementID`),
  KEY `AdminID` (`AdminID`),
  KEY `DateCreated` (`DateCreated`),
  CONSTRAINT `announcements_ibfk_1` FOREIGN KEY (`AdminID`) REFERENCES `administrator` (`AdminID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
INSERT INTO `announcements` VALUES (1,1,'2024-05-01 10:00:00'),(2,2,'2024-05-15 14:30:00'),(3,1,'2024-05-01 10:00:00'),(4,2,'2024-05-15 14:30:00'),(5,2,'2024-06-15 14:30:00'),(6,3,'2024-05-15 14:30:00'),(7,1,'2024-09-16 02:38:18'),(8,4,'2024-09-16 02:56:23'),(9,4,'2024-09-16 02:56:33');
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `baselocation`
--

DROP TABLE IF EXISTS `baselocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `baselocation` (
  `BaseID` int NOT NULL AUTO_INCREMENT,
  `BaseName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Latitude` decimal(10,8) NOT NULL,
  `Longitude` decimal(11,8) NOT NULL,
  PRIMARY KEY (`BaseID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `baselocation`
--

LOCK TABLES `baselocation` WRITE;
/*!40000 ALTER TABLE `baselocation` DISABLE KEYS */;
INSERT INTO `baselocation` VALUES (1,'Main Base',38.04035147,23.78224611);
/*!40000 ALTER TABLE `baselocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `CategoryID` int NOT NULL AUTO_INCREMENT,
  `CategoryName` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`CategoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Food'),(2,'Medicine'),(3,'Clothing'),(4,'-----'),(5,'2d hacker'),(6,'animal care'),(7,'animal flood'),(8,'animal food'),(9,'baby essentials'),(10,'beverages'),(11,'books'),(12,'cleaning supplies'),(13,'cleaning supplies.'),(14,'clothing and cover'),(15,'cold weather'),(16,'communication items'),(17,'communications'),(18,'disability and assistance items'),(19,'earthquake safety'),(20,'electronic devices'),(21,'energy drinks'),(22,'financial support'),(23,'first aid'),(24,'flood'),(25,'fuel and energy'),(26,'hacker of class'),(27,'hot weather'),(28,'household items'),(29,'humanitarian shelters'),(30,'insect repellents'),(31,'kitchen supplies'),(32,'medical supplies'),(33,'mental health support'),(34,'navigation tools'),(35,'new cat'),(36,'ood'),(37,'personal hygiene'),(38,'pet supplies'),(39,'shoes'),(40,'sleep essentilals'),(41,'solar-powered devices'),(42,'special items'),(43,'test'),(44,'test category'),(45,'test1'),(46,'test_0'),(47,'tools'),(48,'tools and equipment'),(49,'water purification'),(50,'Μedicines');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `citizen`
--

DROP TABLE IF EXISTS `citizen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `citizen` (
  `UserID` int DEFAULT NULL,
  `CitizenID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Surname` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Phone` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Latitude` decimal(10,8) NOT NULL,
  `Longitude` decimal(11,8) NOT NULL,
  PRIMARY KEY (`CitizenID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `citizen_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `citizen`
--

LOCK TABLES `citizen` WRITE;
/*!40000 ALTER TABLE `citizen` DISABLE KEYS */;
INSERT INTO `citizen` VALUES (6,1,'Jane','Doe','123-456-7890',38.04161800,23.78762700),(7,2,'John','Doe','987-654-3210',38.03932500,23.79466300),(8,3,'Alice','Smith','555-555-5555',38.04173700,23.79206500),(9,4,'Mariana','Mitsena','555-555-5555',38.04273700,23.79306500),(10,5,'Mariana','Mitsena','555-555-5555',38.04293700,23.79706500);
/*!40000 ALTER TABLE `citizen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `ItemID` int NOT NULL AUTO_INCREMENT,
  `CategoryID` int NOT NULL,
  `Name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DetailName` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DetailValue` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ItemID`),
  UNIQUE KEY `Name` (`Name`),
  KEY `CategoryID` (`CategoryID`),
  CONSTRAINT `items_ibfk_1` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=217 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES (1,1,'Rice','volume','1kg bag of rice'),(2,1,'Bread','quantity','1 loaf of bread'),(3,2,'Aspirin','Pack of','4'),(4,2,'Band-Aid','Pack of','10'),(5,3,'Shirt','Size','M'),(6,3,'Jacket','Size','L'),(7,3,'Blanket','Size','Queen'),(8,10,'water','volume','1.5l'),(9,10,'orange juice','volume','250ml'),(10,1,'sardines','brand','Trata'),(11,1,'canned corn','weight','500g'),(12,1,'chocolate','weight','100g'),(13,3,'men sneakers','size','44'),(14,5,'test product','weight','500g'),(15,24,'test val','Details','600ml'),(16,1,'spaghetti','grams','500'),(17,1,'croissant','calories','200'),(18,1,'biscuits','',''),(19,32,'bandages','','25 pcs'),(20,32,'disposable gloves','','100 pcs'),(21,32,'gauze','',''),(22,32,'antiseptic','','250ml'),(23,32,'first aid kit','',''),(24,32,'painkillers','volume','200mg'),(25,1,'fakes','',''),(26,37,'menstrual pads','stock','500'),(27,37,'tampon','stock','500'),(28,37,'toilet paper','stock','300'),(29,37,'baby wipes','volume','500gr'),(30,37,'toothbrush','stock','500'),(31,37,'toothpaste','stock','250'),(32,32,'vitamin c','stock','200'),(33,32,'multivitamines','stock','200'),(34,32,'paracetamol','stock','2000'),(35,32,'ibuprofen','stock ','10'),(36,12,'cleaning rag','',''),(37,12,'detergent','',''),(38,12,'disinfectant','',''),(39,12,'mop','',''),(40,12,'plastic bucket','',''),(41,12,'scrub brush','',''),(42,12,'dust mask','',''),(43,12,'broom','',''),(44,47,'hammer','',''),(45,47,'skillsaw','',''),(46,47,'prybar','',''),(47,47,'shovel','',''),(48,47,'flashlight','',''),(49,47,'duct tape','',''),(50,3,'underwear','',''),(51,3,'socks','',''),(52,3,'warm jacket','',''),(53,3,'raincoat','',''),(54,3,'gloves','',''),(55,3,'pants','',''),(56,3,'boots','',''),(57,31,'dishes','',''),(58,31,'pots','',''),(59,31,'paring knives','',''),(60,31,'pan','',''),(61,31,'glass','',''),(62,5,'t22','wtwty','wytwty'),(63,10,'coca cola','Volume','500ml'),(64,30,'spray','volume','75ml'),(65,30,'outdoor spiral','duration','7 hours'),(66,9,'baby bottle','volume','250ml'),(67,9,'pacifier','material','silicone'),(68,1,'condensed milk','weight','400gr'),(69,1,'cereal bar','weight','23,5gr'),(70,47,'pocket knife','Number of different tools','3'),(71,32,'water disinfection tablets','Basic Ingredients','Iodine'),(72,20,'radio','Power','Batteries'),(73,24,'kitchen appliances','','(scrubbers, rubber gloves, kitchen detergent, laundry soap)'),(74,15,'winter hat','',''),(75,15,'winter gloves','',''),(76,15,'scarf','',''),(77,15,'thermos','',''),(78,10,'tea','volume','500ml'),(79,8,'dog food','volume','500g'),(80,8,'cat food','volume','500g'),(81,1,'canned','',''),(82,12,'chlorine','volume','500ml'),(83,12,'medical gloves','volume','20pieces'),(84,3,'t-shirt','size','XL'),(85,27,'cooling fan','',''),(86,27,'cool scarf','',''),(87,47,'whistle','',''),(88,15,'blankets','',''),(89,15,'sleeping bag','',''),(90,32,'thermometer','',''),(91,12,'towels','',''),(92,12,'wet wipes','',''),(93,47,'fire extinguisher','',''),(94,1,'fruits','',''),(95,39,'Αθλητικά','Νο 46',''),(96,1,'Πασατέμπος','',''),(97,23,'betadine','Povidone iodine 10%','240 ml'),(98,23,'cotton wool','100% Hydrofile','70gr'),(99,1,'crackers','Quantity per package','10'),(100,37,'sanitary pads','piece','10 pieces'),(101,37,'sanitary wipes','pank','10 packs'),(102,32,'electrolytes','packet of pills','20 pills'),(103,32,'pain killers','packet of pills','20 pills'),(104,10,'juice','volume','500ml'),(105,32,'sterilized saline','volume','100ml'),(106,32,'antihistamines','pills','10 pills'),(107,1,'instant pancake mix','',''),(108,1,'lacta','weight','105g'),(109,1,'canned tuna','',''),(110,47,'batteries','6 pack',''),(111,47,'can opener','1',''),(112,1,'Πατατάκια','weight','45g'),(113,37,'Σερβιέτες','pcs','18'),(114,1,'dry cranberries','weight','100'),(115,1,'dry apricots','weight','100'),(116,1,'dry figs','weight','100'),(117,1,'Παξιμάδια','weight','200g'),(118,43,'test item','volume','200g'),(119,32,'tampons','',''),(120,38,'plaster set','1',''),(121,38,'elastic bandages','','12'),(122,38,'traumaplast','','20'),(123,38,'thermal blanket','','2'),(124,38,'burn gel','ml','500'),(125,38,'pet carrier','','2'),(126,38,'pet dishes','','10'),(127,38,'plastic bags','','20'),(128,38,'toys','','5'),(129,38,'burn pads','','5'),(130,1,'cheese','grams','1000'),(131,1,'lettuce','grams','500'),(132,1,'eggs','pair','10'),(133,1,'steaks','grams','1000'),(134,1,'beef burgers','grams','500'),(135,1,'tomatoes','grams','1000'),(136,1,'onions','grams','500'),(137,1,'flour','grams','1000'),(138,1,'pastel','','7'),(139,1,'nuts','grams','500'),(140,50,'dramamines','','5'),(141,50,'nurofen','','10'),(142,50,'imodium','','5'),(143,50,'emetostop','','5'),(144,50,'xanax','','5'),(145,50,'saflutan','','2'),(146,50,'sadolin','','3'),(147,50,'depon','','20'),(148,50,'panadol','','6'),(149,50,'ponstan','','10'),(150,50,'algofren','10','600ml'),(151,50,'effervescent depon','67','1000mg'),(152,10,'cold coffee','10','330ml'),(153,21,'hell','22','330'),(154,21,'monster','31','500ml'),(155,21,'redbull','40','330ml'),(156,21,'powerade','23','500ml'),(157,21,'prime','15','500ml'),(158,47,'lighter','16','Mini'),(159,15,'isothermally shirts','5','Medium'),(160,27,'shorts','20',''),(161,1,'chicken','5','1.5kg'),(162,37,'sanitary napkins','30','500g'),(163,32,'covid-19 tests','20',''),(164,10,'club soda','volume','500ml'),(165,18,'wheelchairs','quantity','100'),(166,16,'mobile phones','iphone','200'),(167,31,'spoon','',''),(168,31,'fork','',''),(169,16,'mototrbo r7','band','UHF/VHF'),(170,16,'rm la 250 (vhf linear Ενισχυτής 140-150mhz)','Frequency','140-150Mhz'),(171,29,'humanitarian general purpose tent system (hgpts)','PART NUMBER','C14Y016X016-T'),(172,29,'celina dynamic small shelter','dimensions',' 20’x32.5’'),(173,29,'multi-purpose area shelter system, type-i','TYPE','Frame Structure, Expandable, Air- Transportable'),(174,3,'trousers','',''),(175,3,'shoes','',''),(176,3,'hoodie','',''),(177,1,'macaroni','',''),(178,19,'silver blanket','',''),(179,19,'helmet','',''),(180,19,'disposable toilet','',''),(181,19,'self-generated flashlight','',''),(182,40,'mattresses','size','1.90X60'),(183,40,'matches','pack','60'),(184,40,'heater','Volts','208'),(185,40,'earplugs','material','plastic'),(186,34,'compass','Type','Digital'),(187,34,'map','Material','Paper'),(188,34,'gps','Type','Waterproof'),(189,32,'first aid','1','1'),(190,32,'bandage','','5'),(191,32,'mask','','10'),(192,32,'medicines','',''),(193,1,'canned goods','2','80g'),(194,1,'snacks','3','100g'),(195,1,'cereals','1','800g'),(196,14,'caps','',''),(197,48,'repair tools','',''),(198,37,'soap and shampoo','1','200ml'),(199,37,'toothpastes and toothbrushes','',''),(200,42,'diapers','',''),(201,42,'animal food','',''),(202,28,'plates','',''),(203,28,'cups','',''),(204,28,'cutlery','',''),(205,28,'cleaning supplies','',''),(206,28,'home repair tools','',''),(207,11,'lord of the rings','pages','230'),(208,25,'gasoline','galons','20'),(209,25,'power banks','quantity','5'),(210,44,'test item2','volume','500ml'),(211,50,'t4 levothyroxine','pills','60 pills'),(212,41,'solar charger','',''),(213,41,'solar-powered radio','',''),(214,41,'solar torch','',''),(215,33,'stress ball','',''),(216,33,'guided meditation audio','','');
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offeritems`
--

DROP TABLE IF EXISTS `offeritems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offeritems` (
  `OfferItemID` int NOT NULL AUTO_INCREMENT,
  `OfferID` int DEFAULT NULL,
  `ItemID` int DEFAULT NULL,
  `Quantity` int NOT NULL,
  PRIMARY KEY (`OfferItemID`),
  UNIQUE KEY `uq_request_item` (`OfferID`,`ItemID`),
  KEY `OfferID` (`OfferID`),
  KEY `ItemID` (`ItemID`),
  CONSTRAINT `offeritems_ibfk_1` FOREIGN KEY (`OfferID`) REFERENCES `offers` (`OfferID`) ON DELETE CASCADE,
  CONSTRAINT `offeritems_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `items` (`ItemID`) ON DELETE CASCADE,
  CONSTRAINT `offeritems_chk_1` CHECK ((`Quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offeritems`
--

LOCK TABLES `offeritems` WRITE;
/*!40000 ALTER TABLE `offeritems` DISABLE KEYS */;
INSERT INTO `offeritems` VALUES (1,1,1,20),(2,2,2,30),(3,3,3,5),(4,4,3,23),(5,5,1,19),(6,6,7,26),(7,7,5,34),(8,8,6,19),(9,9,4,20),(10,10,2,36),(11,11,1,69),(12,11,7,3000),(13,12,1,1),(14,13,1,1),(15,14,1,1),(16,15,1,1),(17,16,1,1),(18,17,1,1),(19,18,1,1),(20,19,1,1),(21,20,1,1),(22,21,1,1),(23,22,1,1),(24,23,1,1),(25,24,1,1),(26,25,1,1),(27,26,1,1),(28,27,1,1),(29,28,1,1),(30,29,1,1),(31,30,1,1),(32,31,1,1),(33,32,1,1),(34,33,1,1),(35,34,1,1),(36,35,1,1),(37,36,1,1),(38,37,1,1),(39,38,1,1),(40,39,1,1),(41,40,1,1),(42,41,1,1),(43,42,1,1),(44,43,1,1),(45,44,1,1),(46,45,1,1),(47,46,1,1),(48,47,1,1),(49,48,1,1),(50,49,1,1),(51,50,1,1),(52,51,1,1),(53,52,1,1),(54,53,1,1),(55,54,1,1),(56,55,1,1),(57,56,1,1),(58,57,1,1),(59,58,1,1),(60,59,1,1),(61,60,1,1),(62,61,1,1),(63,62,7,70),(64,63,2,50),(67,65,2,200);
/*!40000 ALTER TABLE `offeritems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offers`
--

DROP TABLE IF EXISTS `offers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offers` (
  `OfferID` int NOT NULL AUTO_INCREMENT,
  `CitizenID` int DEFAULT NULL,
  `Status` enum('PENDING','INPROGRESS','FINISHED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `DateCreated` datetime NOT NULL,
  `DateAssignedVehicle` datetime DEFAULT NULL,
  `DateFinished` datetime DEFAULT NULL,
  `RescuerID` int DEFAULT NULL,
  PRIMARY KEY (`OfferID`),
  KEY `CitizenID` (`CitizenID`),
  KEY `RescuerID` (`RescuerID`),
  KEY `DateCreated` (`DateCreated`),
  KEY `DateAssignedVehicle` (`DateAssignedVehicle`),
  CONSTRAINT `offers_ibfk_1` FOREIGN KEY (`CitizenID`) REFERENCES `citizen` (`CitizenID`) ON DELETE CASCADE,
  CONSTRAINT `offers_ibfk_2` FOREIGN KEY (`RescuerID`) REFERENCES `rescuer` (`RescuerID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offers`
--

LOCK TABLES `offers` WRITE;
/*!40000 ALTER TABLE `offers` DISABLE KEYS */;
INSERT INTO `offers` VALUES (1,1,'INPROGRESS','2024-09-16 02:37:45','2024-09-16 03:10:12',NULL,2),(2,1,'PENDING','2024-09-16 02:37:45',NULL,NULL,NULL),(3,2,'PENDING','2024-09-16 02:37:45',NULL,NULL,NULL),(4,2,'FINISHED','2024-09-16 02:37:45','2024-09-16 02:58:31','2024-09-16 03:01:47',2),(5,3,'PENDING','2024-09-16 02:37:45',NULL,NULL,NULL),(6,3,'INPROGRESS','2024-09-16 02:37:45','2024-09-16 02:53:17',NULL,3),(7,3,'PENDING','2024-09-16 02:37:45',NULL,NULL,NULL),(8,4,'INPROGRESS','2024-09-16 02:37:45','2024-09-16 02:53:41',NULL,4),(9,5,'PENDING','2024-09-16 02:37:45',NULL,NULL,NULL),(10,5,'PENDING','2024-09-16 02:37:45',NULL,NULL,NULL),(11,2,'PENDING','2024-09-16 02:38:16',NULL,NULL,NULL),(12,1,'FINISHED','2024-05-14 00:00:00','2024-05-15 00:00:00','2024-05-16 00:00:00',1),(13,1,'FINISHED','2024-05-15 00:00:00','2024-05-16 00:00:00','2024-05-17 00:00:00',1),(14,1,'FINISHED','2024-05-16 00:00:00','2024-05-17 00:00:00','2024-05-18 00:00:00',1),(15,1,'FINISHED','2024-05-17 00:00:00','2024-05-18 00:00:00','2024-05-19 00:00:00',1),(16,1,'FINISHED','2024-05-18 00:00:00','2024-05-19 00:00:00','2024-05-20 00:00:00',1),(17,1,'FINISHED','2024-05-19 00:00:00','2024-05-20 00:00:00','2024-05-21 00:00:00',1),(18,1,'FINISHED','2024-05-20 00:00:00','2024-05-21 00:00:00','2024-05-22 00:00:00',1),(19,1,'FINISHED','2024-05-21 00:00:00','2024-05-22 00:00:00','2024-05-23 00:00:00',1),(20,1,'FINISHED','2024-05-22 00:00:00','2024-05-23 00:00:00','2024-05-24 00:00:00',1),(21,1,'FINISHED','2024-05-23 00:00:00','2024-05-24 00:00:00','2024-05-25 00:00:00',1),(22,1,'FINISHED','2024-05-24 00:00:00','2024-05-25 00:00:00','2024-05-26 00:00:00',1),(23,1,'FINISHED','2024-05-25 00:00:00','2024-05-26 00:00:00','2024-05-27 00:00:00',1),(24,1,'FINISHED','2024-05-26 00:00:00','2024-05-27 00:00:00','2024-05-28 00:00:00',1),(25,1,'FINISHED','2024-05-27 00:00:00','2024-05-28 00:00:00','2024-05-29 00:00:00',1),(26,1,'FINISHED','2024-05-28 00:00:00','2024-05-29 00:00:00','2024-05-30 00:00:00',1),(27,1,'FINISHED','2024-05-29 00:00:00','2024-05-30 00:00:00','2024-05-31 00:00:00',1),(28,1,'FINISHED','2024-05-30 00:00:00','2024-05-31 00:00:00','2024-06-01 00:00:00',1),(29,1,'FINISHED','2024-05-31 00:00:00','2024-06-01 00:00:00','2024-06-02 00:00:00',1),(30,1,'FINISHED','2024-06-01 00:00:00','2024-06-02 00:00:00','2024-06-03 00:00:00',1),(31,1,'FINISHED','2024-06-02 00:00:00','2024-06-03 00:00:00','2024-06-04 00:00:00',1),(32,1,'FINISHED','2024-06-03 00:00:00','2024-06-04 00:00:00','2024-06-05 00:00:00',1),(33,1,'FINISHED','2024-06-04 00:00:00','2024-06-05 00:00:00','2024-06-06 00:00:00',1),(34,1,'FINISHED','2024-06-05 00:00:00','2024-06-06 00:00:00','2024-06-07 00:00:00',1),(35,1,'FINISHED','2024-06-06 00:00:00','2024-06-07 00:00:00','2024-06-08 00:00:00',1),(36,1,'FINISHED','2024-06-07 00:00:00','2024-06-08 00:00:00','2024-06-09 00:00:00',1),(37,1,'FINISHED','2024-06-08 00:00:00','2024-06-09 00:00:00','2024-06-10 00:00:00',1),(38,1,'FINISHED','2024-06-09 00:00:00','2024-06-10 00:00:00','2024-06-11 00:00:00',1),(39,1,'FINISHED','2024-06-10 00:00:00','2024-06-11 00:00:00','2024-06-12 00:00:00',1),(40,1,'FINISHED','2024-06-11 00:00:00','2024-06-12 00:00:00','2024-06-13 00:00:00',1),(41,1,'FINISHED','2024-06-12 00:00:00','2024-06-13 00:00:00','2024-06-14 00:00:00',1),(42,1,'FINISHED','2024-06-13 00:00:00','2024-06-14 00:00:00','2024-06-15 00:00:00',1),(43,1,'FINISHED','2024-06-14 00:00:00','2024-06-15 00:00:00','2024-06-16 00:00:00',1),(44,1,'FINISHED','2024-06-15 00:00:00','2024-06-16 00:00:00','2024-06-17 00:00:00',1),(45,1,'FINISHED','2024-06-16 00:00:00','2024-06-17 00:00:00','2024-06-18 00:00:00',1),(46,1,'FINISHED','2024-06-17 00:00:00','2024-06-18 00:00:00','2024-06-19 00:00:00',1),(47,1,'FINISHED','2024-06-18 00:00:00','2024-06-19 00:00:00','2024-06-20 00:00:00',1),(48,1,'FINISHED','2024-06-19 00:00:00','2024-06-20 00:00:00','2024-06-21 00:00:00',1),(49,1,'FINISHED','2024-06-20 00:00:00','2024-06-21 00:00:00','2024-06-22 00:00:00',1),(50,1,'FINISHED','2024-06-21 00:00:00','2024-06-22 00:00:00','2024-06-23 00:00:00',1),(51,1,'FINISHED','2024-06-22 00:00:00','2024-06-23 00:00:00','2024-06-24 00:00:00',1),(52,1,'FINISHED','2024-06-23 00:00:00','2024-06-24 00:00:00','2024-06-25 00:00:00',1),(53,1,'FINISHED','2024-06-24 00:00:00','2024-06-25 00:00:00','2024-06-26 00:00:00',1),(54,1,'FINISHED','2024-06-25 00:00:00','2024-06-26 00:00:00','2024-06-27 00:00:00',1),(55,1,'FINISHED','2024-06-26 00:00:00','2024-06-27 00:00:00','2024-06-28 00:00:00',1),(56,1,'FINISHED','2024-06-27 00:00:00','2024-06-28 00:00:00','2024-06-29 00:00:00',1),(57,1,'FINISHED','2024-06-28 00:00:00','2024-06-29 00:00:00','2024-06-30 00:00:00',1),(58,1,'FINISHED','2024-06-29 00:00:00','2024-06-30 00:00:00','2024-07-01 00:00:00',1),(59,1,'FINISHED','2024-06-30 00:00:00','2024-07-01 00:00:00','2024-07-02 00:00:00',1),(60,1,'FINISHED','2024-07-01 00:00:00','2024-07-02 00:00:00','2024-07-03 00:00:00',1),(61,1,'FINISHED','2024-07-02 00:00:00','2024-07-03 00:00:00','2024-07-04 00:00:00',1),(62,5,'PENDING','2024-09-16 03:11:03',NULL,NULL,NULL),(63,4,'PENDING','2024-09-16 05:27:08',NULL,NULL,NULL),(65,4,'PENDING','2024-09-16 05:44:30',NULL,NULL,NULL);
/*!40000 ALTER TABLE `offers` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BeforeAssignRescuerToOffer` BEFORE UPDATE ON `offers` FOR EACH ROW BEGIN
    DECLARE taskCount INT;

    IF NEW.RescuerID IS NOT NULL AND NEW.Status != 'FINISHED' THEN
        SELECT COUNT(*) INTO taskCount
        FROM (
            SELECT RescuerID FROM Requests WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS'
            UNION ALL
            SELECT RescuerID FROM Offers WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS'
        ) AS RescuerTasks;

        IF taskCount >= 4 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Rescuer has reached the maximum number of tasks.', MYSQL_ERRNO = 6002;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PreventReassignInProgressOffer` BEFORE UPDATE ON `offers` FOR EACH ROW BEGIN
    IF OLD.Status = 'INPROGRESS' AND OLD.RescuerID IS NOT NULL AND OLD.RescuerID != NEW.RescuerID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'In-progress offers cannot be reassigned.', MYSQL_ERRNO = 5004;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PreventPendingOfferFinished` BEFORE UPDATE ON `offers` FOR EACH ROW BEGIN
    IF OLD.Status = 'PENDING' AND NEW.Status = 'FINISHED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pending offers cannot be marked as finished.', MYSQL_ERRNO = 5006;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PreventFinishedOfferAlteration` BEFORE UPDATE ON `offers` FOR EACH ROW BEGIN
    IF OLD.Status = 'FINISHED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Finished offers cannot be altered.', MYSQL_ERRNO = 5008;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `requestitems`
--

DROP TABLE IF EXISTS `requestitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requestitems` (
  `RequestItemID` int NOT NULL AUTO_INCREMENT,
  `RequestID` int DEFAULT NULL,
  `ItemID` int DEFAULT NULL,
  `Quantity` int NOT NULL,
  PRIMARY KEY (`RequestItemID`),
  UNIQUE KEY `uq_request_item` (`RequestID`,`ItemID`),
  KEY `RequestID` (`RequestID`),
  KEY `ItemID` (`ItemID`),
  CONSTRAINT `requestitems_ibfk_1` FOREIGN KEY (`RequestID`) REFERENCES `requests` (`RequestID`) ON DELETE CASCADE,
  CONSTRAINT `requestitems_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `items` (`ItemID`) ON DELETE CASCADE,
  CONSTRAINT `requestitems_chk_1` CHECK ((`Quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requestitems`
--

LOCK TABLES `requestitems` WRITE;
/*!40000 ALTER TABLE `requestitems` DISABLE KEYS */;
INSERT INTO `requestitems` VALUES (1,1,1,10),(2,2,2,5),(3,3,3,3),(4,4,2,7),(5,5,3,10),(6,6,4,15),(7,7,5,7),(8,8,6,10),(9,9,7,15),(11,11,7,15),(12,12,3,10),(13,13,3,15),(14,14,1,15),(15,15,1,888),(16,15,7,30),(17,16,1,1),(18,17,1,1),(19,18,1,1),(20,19,1,1),(21,20,1,1),(22,21,1,1),(23,22,1,1),(24,23,1,1),(25,24,1,1),(26,25,1,1),(27,26,1,1),(28,27,1,1),(29,28,1,1),(30,29,1,1),(31,30,1,1),(32,31,1,1),(33,32,1,1),(34,33,1,1),(35,34,1,1),(36,35,1,1),(37,36,1,1),(38,37,1,1),(39,38,1,1),(40,39,1,1),(41,40,1,1),(42,41,1,1),(43,42,1,1),(44,43,1,1),(45,44,1,1),(46,45,1,1),(47,46,1,1),(48,47,1,1),(49,48,1,1),(50,49,1,1),(51,50,1,1),(52,51,1,1),(53,52,1,1),(54,53,1,1),(55,54,1,1),(56,55,1,1),(57,56,1,1),(58,57,1,1),(59,58,1,1),(60,59,1,1),(61,60,1,1),(62,61,1,1),(63,62,1,1),(64,63,1,1),(65,64,1,1),(66,65,1,1),(67,66,207,10),(73,72,42,10),(74,73,22,10);
/*!40000 ALTER TABLE `requestitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requests` (
  `RequestID` int NOT NULL AUTO_INCREMENT,
  `CitizenID` int DEFAULT NULL,
  `Status` enum('PENDING','INPROGRESS','FINISHED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `NumberofPeople` int NOT NULL,
  `DateCreated` datetime NOT NULL,
  `DateAssignedVehicle` datetime DEFAULT NULL,
  `DateFinished` datetime DEFAULT NULL,
  `RescuerID` int DEFAULT NULL,
  PRIMARY KEY (`RequestID`),
  KEY `CitizenID` (`CitizenID`),
  KEY `RescuerID` (`RescuerID`),
  KEY `DateCreated` (`DateCreated`),
  KEY `DateAssignedVehicle` (`DateAssignedVehicle`),
  CONSTRAINT `requests_ibfk_1` FOREIGN KEY (`CitizenID`) REFERENCES `citizen` (`CitizenID`) ON DELETE CASCADE,
  CONSTRAINT `requests_ibfk_2` FOREIGN KEY (`RescuerID`) REFERENCES `rescuer` (`RescuerID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` VALUES (1,1,'PENDING',1,'2024-09-16 02:37:43',NULL,NULL,NULL),(2,1,'PENDING',2,'2024-09-16 02:37:43',NULL,NULL,NULL),(3,1,'INPROGRESS',1,'2024-09-16 02:37:43','2024-09-16 02:49:44',NULL,1),(4,2,'PENDING',1,'2024-09-16 02:37:43',NULL,NULL,NULL),(5,2,'INPROGRESS',4,'2024-09-16 02:37:43','2024-09-16 02:50:23',NULL,3),(6,3,'PENDING',1,'2024-09-16 02:37:43',NULL,NULL,NULL),(7,3,'PENDING',1,'2024-09-16 02:37:43',NULL,NULL,NULL),(8,3,'PENDING',1,'2024-09-16 02:37:43',NULL,NULL,NULL),(9,4,'INPROGRESS',1,'2024-09-16 02:37:43','2024-09-16 02:51:52',NULL,4),(11,5,'PENDING',1,'2024-09-16 02:37:43',NULL,NULL,NULL),(12,5,'PENDING',1,'2024-09-16 02:37:43',NULL,NULL,NULL),(13,5,'PENDING',1,'2024-09-16 02:37:43',NULL,NULL,NULL),(14,5,'PENDING',1,'2024-09-16 02:37:43',NULL,NULL,NULL),(15,2,'INPROGRESS',10,'2024-09-16 02:38:14','2024-09-16 03:02:43',NULL,2),(16,1,'FINISHED',1,'2024-05-14 00:00:00','2024-05-15 00:00:00','2024-05-16 00:00:00',1),(17,1,'FINISHED',1,'2024-05-15 00:00:00','2024-05-16 00:00:00','2024-05-17 00:00:00',1),(18,1,'FINISHED',1,'2024-05-16 00:00:00','2024-05-17 00:00:00','2024-05-18 00:00:00',1),(19,1,'FINISHED',1,'2024-05-17 00:00:00','2024-05-18 00:00:00','2024-05-19 00:00:00',1),(20,1,'FINISHED',1,'2024-05-18 00:00:00','2024-05-19 00:00:00','2024-05-20 00:00:00',1),(21,1,'FINISHED',1,'2024-05-19 00:00:00','2024-05-20 00:00:00','2024-05-21 00:00:00',1),(22,1,'FINISHED',1,'2024-05-20 00:00:00','2024-05-21 00:00:00','2024-05-22 00:00:00',1),(23,1,'FINISHED',1,'2024-05-21 00:00:00','2024-05-22 00:00:00','2024-05-23 00:00:00',1),(24,1,'FINISHED',1,'2024-05-22 00:00:00','2024-05-23 00:00:00','2024-05-24 00:00:00',1),(25,1,'FINISHED',1,'2024-05-23 00:00:00','2024-05-24 00:00:00','2024-05-25 00:00:00',1),(26,1,'FINISHED',1,'2024-05-24 00:00:00','2024-05-25 00:00:00','2024-05-26 00:00:00',1),(27,1,'FINISHED',1,'2024-05-25 00:00:00','2024-05-26 00:00:00','2024-05-27 00:00:00',1),(28,1,'FINISHED',1,'2024-05-26 00:00:00','2024-05-27 00:00:00','2024-05-28 00:00:00',1),(29,1,'FINISHED',1,'2024-05-27 00:00:00','2024-05-28 00:00:00','2024-05-29 00:00:00',1),(30,1,'FINISHED',1,'2024-05-28 00:00:00','2024-05-29 00:00:00','2024-05-30 00:00:00',1),(31,1,'FINISHED',1,'2024-05-29 00:00:00','2024-05-30 00:00:00','2024-05-31 00:00:00',1),(32,1,'FINISHED',1,'2024-05-30 00:00:00','2024-05-31 00:00:00','2024-06-01 00:00:00',1),(33,1,'FINISHED',1,'2024-05-31 00:00:00','2024-06-01 00:00:00','2024-06-02 00:00:00',1),(34,1,'FINISHED',1,'2024-06-01 00:00:00','2024-06-02 00:00:00','2024-06-03 00:00:00',1),(35,1,'FINISHED',1,'2024-06-02 00:00:00','2024-06-03 00:00:00','2024-06-04 00:00:00',1),(36,1,'FINISHED',1,'2024-06-03 00:00:00','2024-06-04 00:00:00','2024-06-05 00:00:00',1),(37,1,'FINISHED',1,'2024-06-04 00:00:00','2024-06-05 00:00:00','2024-06-06 00:00:00',1),(38,1,'FINISHED',1,'2024-06-05 00:00:00','2024-06-06 00:00:00','2024-06-07 00:00:00',1),(39,1,'FINISHED',1,'2024-06-06 00:00:00','2024-06-07 00:00:00','2024-06-08 00:00:00',1),(40,1,'FINISHED',1,'2024-06-07 00:00:00','2024-06-08 00:00:00','2024-06-09 00:00:00',1),(41,1,'FINISHED',1,'2024-06-08 00:00:00','2024-06-09 00:00:00','2024-06-10 00:00:00',1),(42,1,'FINISHED',1,'2024-06-09 00:00:00','2024-06-10 00:00:00','2024-06-11 00:00:00',1),(43,1,'FINISHED',1,'2024-06-10 00:00:00','2024-06-11 00:00:00','2024-06-12 00:00:00',1),(44,1,'FINISHED',1,'2024-06-11 00:00:00','2024-06-12 00:00:00','2024-06-13 00:00:00',1),(45,1,'FINISHED',1,'2024-06-12 00:00:00','2024-06-13 00:00:00','2024-06-14 00:00:00',1),(46,1,'FINISHED',1,'2024-06-13 00:00:00','2024-06-14 00:00:00','2024-06-15 00:00:00',1),(47,1,'FINISHED',1,'2024-06-14 00:00:00','2024-06-15 00:00:00','2024-06-16 00:00:00',1),(48,1,'FINISHED',1,'2024-06-15 00:00:00','2024-06-16 00:00:00','2024-06-17 00:00:00',1),(49,1,'FINISHED',1,'2024-06-16 00:00:00','2024-06-17 00:00:00','2024-06-18 00:00:00',1),(50,1,'FINISHED',1,'2024-06-17 00:00:00','2024-06-18 00:00:00','2024-06-19 00:00:00',1),(51,1,'FINISHED',1,'2024-06-18 00:00:00','2024-06-19 00:00:00','2024-06-20 00:00:00',1),(52,1,'FINISHED',1,'2024-06-19 00:00:00','2024-06-20 00:00:00','2024-06-21 00:00:00',1),(53,1,'FINISHED',1,'2024-06-20 00:00:00','2024-06-21 00:00:00','2024-06-22 00:00:00',1),(54,1,'FINISHED',1,'2024-06-21 00:00:00','2024-06-22 00:00:00','2024-06-23 00:00:00',1),(55,1,'FINISHED',1,'2024-06-22 00:00:00','2024-06-23 00:00:00','2024-06-24 00:00:00',1),(56,1,'FINISHED',1,'2024-06-23 00:00:00','2024-06-24 00:00:00','2024-06-25 00:00:00',1),(57,1,'FINISHED',1,'2024-06-24 00:00:00','2024-06-25 00:00:00','2024-06-26 00:00:00',1),(58,1,'FINISHED',1,'2024-06-25 00:00:00','2024-06-26 00:00:00','2024-06-27 00:00:00',1),(59,1,'FINISHED',1,'2024-06-26 00:00:00','2024-06-27 00:00:00','2024-06-28 00:00:00',1),(60,1,'FINISHED',1,'2024-06-27 00:00:00','2024-06-28 00:00:00','2024-06-29 00:00:00',1),(61,1,'FINISHED',1,'2024-06-28 00:00:00','2024-06-29 00:00:00','2024-06-30 00:00:00',1),(62,1,'FINISHED',1,'2024-06-29 00:00:00','2024-06-30 00:00:00','2024-07-01 00:00:00',1),(63,1,'FINISHED',1,'2024-06-30 00:00:00','2024-07-01 00:00:00','2024-07-02 00:00:00',1),(64,1,'FINISHED',1,'2024-07-01 00:00:00','2024-07-02 00:00:00','2024-07-03 00:00:00',1),(65,1,'FINISHED',1,'2024-07-02 00:00:00','2024-07-03 00:00:00','2024-07-04 00:00:00',1),(66,5,'PENDING',1,'2024-09-16 03:10:52',NULL,NULL,NULL),(72,4,'PENDING',1,'2024-09-16 05:37:48',NULL,NULL,NULL),(73,4,'PENDING',1,'2024-09-16 05:38:28',NULL,NULL,NULL);
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `BeforeAssignRescuerToRequest` BEFORE UPDATE ON `requests` FOR EACH ROW BEGIN
    DECLARE taskCount INT;

    IF NEW.RescuerID IS NOT NULL AND NEW.Status != 'FINISHED' THEN
        SELECT COUNT(*) INTO taskCount
        FROM (
            SELECT RescuerID FROM Requests WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS'
            UNION ALL
            SELECT RescuerID FROM Offers WHERE RescuerID = NEW.RescuerID AND Status = 'INPROGRESS'
        ) AS RescuerTasks;

        IF taskCount >= 4 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Rescuer has reached the maximum number of tasks.', MYSQL_ERRNO = 6002;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PreventReassignInProgressRequest` BEFORE UPDATE ON `requests` FOR EACH ROW BEGIN
    IF OLD.Status = 'INPROGRESS' AND OLD.RescuerID IS NOT NULL AND OLD.RescuerID != NEW.RescuerID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'In-progress requests cannot be reassigned.', MYSQL_ERRNO = 5003;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PreventPendingRequestFinished` BEFORE UPDATE ON `requests` FOR EACH ROW BEGIN
    IF OLD.Status = 'PENDING' AND NEW.Status = 'FINISHED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pending requests cannot be marked as finished.', MYSQL_ERRNO = 5005;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `PreventFinishedRequestAlteration` BEFORE UPDATE ON `requests` FOR EACH ROW BEGIN
    IF OLD.Status = 'FINISHED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Finished requests cannot be altered.', MYSQL_ERRNO = 5007;  
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rescuer`
--

DROP TABLE IF EXISTS `rescuer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rescuer` (
  `UserID` int DEFAULT NULL,
  `RescuerID` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`RescuerID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `rescuer_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `users` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rescuer`
--

LOCK TABLES `rescuer` WRITE;
/*!40000 ALTER TABLE `rescuer` DISABLE KEYS */;
INSERT INTO `rescuer` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(16,6);
/*!40000 ALTER TABLE `rescuer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `Username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Role` enum('Administrator','Rescuer','Citizen') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Username` (`Username`),
  UNIQUE KEY `Username_2` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'john_dwoe','123','Rescuer'),(2,'AxileasVil','123','Rescuer'),(3,'Sjanec_doe','securepassworcd456','Rescuer'),(4,'ssmitDh','securepassword789','Rescuer'),(5,'VasilisPapa','3424r44','Rescuer'),(6,'jane_doce','securepassword456','Citizen'),(7,'john_dose','securepassword123','Citizen'),(8,'alixce_smith','securepassword789','Citizen'),(9,'Marianamits','3424r44','Citizen'),(10,'NikosMav','3424r44','Citizen'),(11,'admin_user','adminpassword','Administrator'),(12,'admin_muser2','adminpassword2','Administrator'),(13,'admin_usegayr3','adminpassword3','Administrator'),(14,'OrestisM','1233','Administrator'),(16,'oamakris','taf123','Rescuer');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicleitems`
--

DROP TABLE IF EXISTS `vehicleitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicleitems` (
  `VehicleItemID` int NOT NULL AUTO_INCREMENT,
  `VehicleID` int DEFAULT NULL,
  `ItemID` int DEFAULT NULL,
  `Quantity` int NOT NULL,
  PRIMARY KEY (`VehicleItemID`),
  UNIQUE KEY `uq_vehicle_item` (`VehicleID`,`ItemID`),
  KEY `VehicleID` (`VehicleID`),
  KEY `ItemID` (`ItemID`),
  CONSTRAINT `vehicleitems_ibfk_1` FOREIGN KEY (`VehicleID`) REFERENCES `vehicles` (`VehicleID`) ON DELETE CASCADE,
  CONSTRAINT `vehicleitems_ibfk_2` FOREIGN KEY (`ItemID`) REFERENCES `items` (`ItemID`) ON DELETE CASCADE,
  CONSTRAINT `vehicleitems_chk_1` CHECK ((`Quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicleitems`
--

LOCK TABLES `vehicleitems` WRITE;
/*!40000 ALTER TABLE `vehicleitems` DISABLE KEYS */;
INSERT INTO `vehicleitems` VALUES (1,1,1,10),(2,1,2,5),(3,2,3,29),(4,2,1,31),(5,3,2,20),(6,3,3,10),(7,4,1,30),(8,4,2,25),(9,4,3,15),(10,5,1,10),(11,5,2,5),(12,5,3,7);
/*!40000 ALTER TABLE `vehicleitems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehicles`
--

DROP TABLE IF EXISTS `vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicles` (
  `VehicleID` int NOT NULL AUTO_INCREMENT,
  `RescuerID` int DEFAULT NULL,
  `Latitude` decimal(10,8) NOT NULL,
  `Longitude` decimal(11,8) NOT NULL,
  PRIMARY KEY (`VehicleID`),
  KEY `RescuerID` (`RescuerID`),
  CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`RescuerID`) REFERENCES `rescuer` (`RescuerID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicles`
--

LOCK TABLES `vehicles` WRITE;
/*!40000 ALTER TABLE `vehicles` DISABLE KEYS */;
INSERT INTO `vehicles` VALUES (1,1,38.04816300,23.79188600),(2,2,38.03962268,23.79480198),(3,3,38.04616300,23.79643000),(4,4,38.04459300,23.78110400),(5,5,38.04334315,23.77287171),(6,6,38.04045292,23.77613906);
/*!40000 ALTER TABLE `vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouse`
--

DROP TABLE IF EXISTS `warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouse` (
  `ItemID` int DEFAULT NULL,
  `Quantity` int NOT NULL,
  UNIQUE KEY `ItemID` (`ItemID`),
  UNIQUE KEY `uq_warehouse_item` (`ItemID`),
  CONSTRAINT `warehouse_ibfk_1` FOREIGN KEY (`ItemID`) REFERENCES `items` (`ItemID`) ON DELETE CASCADE,
  CONSTRAINT `warehouse_chk_1` CHECK ((`Quantity` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `warehouse`
--

LOCK TABLES `warehouse` WRITE;
/*!40000 ALTER TABLE `warehouse` DISABLE KEYS */;
INSERT INTO `warehouse` VALUES (1,566),(2,50),(3,71),(4,33),(5,33),(6,696969),(7,696969),(8,5),(9,5),(10,5),(11,5),(12,5),(13,5),(14,5),(15,5),(16,5),(17,5),(18,5),(19,5),(20,5),(21,5),(22,5),(23,5),(24,5),(25,5),(26,5),(27,5),(28,5),(29,5),(30,5),(31,5),(32,5),(33,5),(34,5),(35,5),(36,5),(37,5),(38,5),(39,5),(40,5),(41,5),(42,5),(43,5),(44,5),(45,5),(46,5),(47,5),(48,5),(49,5),(50,5),(51,5),(52,5),(53,5),(54,5),(55,5),(56,5),(57,5),(58,5),(59,5),(60,5),(61,5),(62,5),(63,5),(64,5),(65,5),(66,5),(67,5),(68,5),(69,5),(70,5),(71,5),(72,5),(73,5),(74,5),(75,5),(76,5),(77,5),(78,5),(79,5),(80,5),(81,5),(82,5),(83,5),(84,5),(85,5),(86,5),(87,5),(88,5),(89,5),(90,5),(91,5),(92,5),(93,5),(94,5),(95,5),(96,5),(97,5),(98,5),(99,5),(100,5),(101,5),(102,5),(103,5),(104,5),(105,5),(106,5),(107,5),(108,5),(109,5),(110,5),(111,5),(112,5),(113,5),(114,5),(115,5),(116,5),(117,5),(118,5),(119,5),(120,5),(121,5),(122,5),(123,5),(124,5),(125,5),(126,5),(127,5),(128,5),(129,5),(130,5),(131,5),(132,5),(133,5),(134,5),(135,5),(136,5),(137,5),(138,5),(139,5),(140,5),(141,5),(142,5),(143,5),(144,5),(145,5),(146,5),(147,5),(148,5),(149,5),(150,5),(151,5),(152,5),(153,5),(154,5),(155,5),(156,5),(157,5),(158,5),(159,5),(160,5),(161,5),(162,5),(163,5),(164,5),(165,5),(166,5),(167,5),(168,5),(169,5),(170,5),(171,5),(172,5),(173,5),(174,5),(175,5),(176,5),(177,5),(178,5),(179,5),(180,5),(181,5),(182,5),(183,5),(184,5),(185,5),(186,5),(187,5),(188,5),(189,5),(190,5),(191,5),(192,5),(193,5),(194,5),(195,5),(196,5),(197,5),(198,5),(199,5),(200,5),(201,5),(202,5),(203,5),(204,5),(205,5),(206,5),(207,5),(208,5),(209,5),(210,5),(211,5),(212,5),(213,5),(214,5),(215,5),(216,5);
/*!40000 ALTER TABLE `warehouse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'kata_strofh'
--

--
-- Dumping routines for database 'kata_strofh'
--
/*!50003 DROP PROCEDURE IF EXISTS `AssignOffer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AssignOffer`(
    IN p_OfferID INT,
    IN p_RescuerID INT
)
BEGIN
    UPDATE Offers SET RescuerID = p_RescuerID, Status = 'INPROGRESS', DateAssignedVehicle = NOW() 
    WHERE OfferID = p_OfferID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AssignRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AssignRequest`(
    IN p_RequestID INT,
    IN p_RescuerID INT
)
BEGIN
    UPDATE Requests SET RescuerID = p_RescuerID, Status = 'INPROGRESS', DateAssignedVehicle = NOW() 
    WHERE RequestID = p_RequestID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CancelOffer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelOffer`(
    IN p_offerID INT
)
BEGIN
    
    SELECT 'CancelOffer called with OfferID =', p_offerID;
    
    UPDATE Offers
    SET Status = 'PENDING', DateAssignedVehicle = NULL, RescuerID = NULL
    WHERE OfferID = p_offerID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CancelRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelRequest`(
    IN reqID INT
)
BEGIN
    UPDATE Requests
    SET Status = 'PENDING', DateAssignedVehicle = NULL, RescuerID = NULL
    WHERE RequestID = reqID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateNewAdmin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateNewAdmin`(
    IN username VARCHAR(255),
    IN password VARCHAR(255)
)
BEGIN
    DECLARE user_id INT;

    
    INSERT INTO Users (username, password) VALUES (username, password);

    
    SET user_id = LAST_INSERT_ID();

    
    INSERT INTO Administrator (UserID) VALUES (user_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateNewAnnouncement` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateNewAnnouncement`(
    IN admin_id INT,
    IN item_names VARCHAR(1000),  
    IN quantities VARCHAR(1000)   
)
BEGIN
    DECLARE item_name VARCHAR(255);
    DECLARE quantity INT;
    DECLARE total_items INT;
    DECLARE announcement_id INT;
    DECLARE i INT DEFAULT 1;
    DECLARE found_item_id INT;
    DECLARE item_count INT;

    
    SET total_items = LENGTH(item_names) - LENGTH(REPLACE(item_names, ',', '')) + 1;

    
    SET item_count = 0;

    
    WHILE i <= total_items DO
        
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        
        SELECT COUNT(*) INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        
        IF found_item_id > 0 AND quantity > 0 THEN
            
            SET item_count = item_count + 1;
        END IF;

        SET i = i + 1;
    END WHILE;

    
    IF item_count <> total_items THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more items do not exist in the database or invalid quantities provided', MYSQL_ERRNO = 4001;
    END IF;

    
    INSERT INTO Announcements (AdminID, DateCreated)
    VALUES (admin_id, NOW());

    
    SET announcement_id = LAST_INSERT_ID();

    
    SET i = 1;

    
    WHILE i <= total_items DO
        
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        
        SELECT ItemID INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        
        IF found_item_id > 0 AND quantity > 0 THEN
            INSERT INTO AnnouncementItems (AnnouncementID, ItemID, Quantity)
            VALUES (announcement_id, found_item_id, quantity);
        END IF;

        SET i = i + 1;
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateNewCitizen` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateNewCitizen`(
    IN username VARCHAR(255),
    IN password VARCHAR(255),
    IN first_name VARCHAR(255),
    IN last_name VARCHAR(255),
    IN phone_number VARCHAR(255),
    IN latitude DOUBLE,
    IN longitude DOUBLE
)
BEGIN
    DECLARE user_id INT;

    
    INSERT INTO Users (username, password ,Role) VALUES (username, password, 'Citizen');

    
    SET user_id = LAST_INSERT_ID();

    
    INSERT INTO Citizen (UserID, Name, Surname, Phone, Latitude, Longitude)
    VALUES (user_id, first_name, last_name, phone_number, latitude, longitude);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateNewOffer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateNewOffer`(
    IN citizen_id INT,
    IN item_names VARCHAR(1000),  
    IN quantities VARCHAR(1000)   
)
BEGIN
    DECLARE item_name VARCHAR(255);
    DECLARE quantity INT;
    DECLARE total_items INT;
    DECLARE offer_id INT;
    DECLARE i INT DEFAULT 1;
    DECLARE found_item_id INT;
    DECLARE item_count INT;

    
    SET total_items = LENGTH(item_names) - LENGTH(REPLACE(item_names, ',', '')) + 1;

    
    SET item_count = 0;

    
    WHILE i <= total_items DO
        
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        
        SELECT COUNT(*) INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        
        IF found_item_id > 0 AND quantity > 0 THEN
            
            SET item_count = item_count + 1;
        END IF;

        SET i = i + 1;
    END WHILE;

    
    IF item_count <> total_items THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more items do not exist in the database or invalid quantities provided', MYSQL_ERRNO = 4001;
    END IF;

    
    INSERT INTO Offers (CitizenID,Status,DateCreated)
    VALUES (citizen_id,'PENDING',NOW());

    
    SET offer_id = LAST_INSERT_ID();

    
    SET i = 1;

    
    WHILE i <= total_items DO
        
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        
        SELECT ItemID INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        
        IF found_item_id > 0 AND quantity > 0 THEN
            INSERT INTO OfferItems (OfferID, ItemID, Quantity)
            VALUES (offer_id, found_item_id, quantity)
            ON DUPLICATE KEY UPDATE Quantity = Quantity + VALUES(Quantity);
        END IF;

        SET i = i + 1;
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateNewRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateNewRequest`(
    IN citizen_id INT,
    IN NumberofPeople INT,
    IN item_names VARCHAR(1000),  
    IN quantities VARCHAR(1000)   
)
BEGIN
    DECLARE item_name VARCHAR(255);
    DECLARE quantity INT;
    DECLARE total_items INT;
    DECLARE request_id INT;
    DECLARE i INT DEFAULT 1;
    DECLARE found_item_id INT;
    DECLARE item_count INT;
    

    
    SET total_items = LENGTH(item_names) - LENGTH(REPLACE(item_names, ',', '')) + 1;

    
    SET item_count = 0;

    
    WHILE i <= total_items DO
        
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        
        SELECT COUNT(*) INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        
        IF found_item_id > 0 AND quantity > 0 THEN
            
            SET item_count = item_count + 1;
        END IF;

        SET i = i + 1;
    END WHILE;

    
    IF item_count <> total_items THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'One or more items do not exist in the database or invalid quantities provided', MYSQL_ERRNO = 4001;
    END IF;

    
    INSERT INTO Requests (CitizenID,NumberofPeople,Status,DateCreated)
    VALUES (citizen_id,NumberofPeople,'PENDING',NOW());

    
    SET request_id = LAST_INSERT_ID();

    
    SET i = 1;

    
    WHILE i <= total_items DO
        
        SET item_name = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(item_names, ',', i), ',', -1));

        
        SET quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(quantities, ',', i), ',', -1)) AS UNSIGNED);

        
        SELECT ItemID INTO found_item_id
        FROM Items
        WHERE Name = item_name
        LIMIT 1;

        
        IF found_item_id > 0 AND quantity > 0 THEN
            INSERT INTO RequestItems (RequestID, ItemID, Quantity)
            VALUES (request_id, found_item_id, quantity)
            ON DUPLICATE KEY UPDATE Quantity = Quantity + VALUES(Quantity);
        END IF;

        SET i = i + 1;
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateNewRescuer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateNewRescuer`(
    IN username VARCHAR(255),
    IN password VARCHAR(255),
    IN latitude DOUBLE,
    IN longitude DOUBLE
)
BEGIN
    DECLARE user_id INT;
    DECLARE rescuer_id INT;

    
    INSERT INTO Users (username, password ,Role ) VALUES (username, password, 'Rescuer');

    
    SET user_id = LAST_INSERT_ID();

    
    INSERT INTO Rescuer (UserID) VALUES (user_id);

    
    SET rescuer_id = LAST_INSERT_ID();

    
    INSERT INTO Vehicles (RescuerID, Latitude, Longitude) VALUES (rescuer_id, latitude, longitude);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `FinishOffer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FinishOffer`(
    IN p_offerID INT
)
BEGIN
    UPDATE Offers
    SET Status = 'FINISHED',  DateFinished = NOW()
    WHERE OfferID = p_offerID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `FinishRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `FinishRequest`(
    IN reqID INT
)
BEGIN
    UPDATE Requests
    SET Status = 'FINISHED' , DateFinished = NOW()
    WHERE RequestID = reqID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GenerateEntries` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateEntries`(IN num_entries INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE base_date DATE DEFAULT '2024-05-14';  -- Start date 4 months before max date (14/09/2024)
    DECLARE max_date DATE DEFAULT '2024-09-14';   -- Max date is 14/09/2024
    
    -- Loop through the number of entries specified
    WHILE i <= num_entries DO
        -- Exit the loop if base_date exceeds max_date
        IF base_date > max_date THEN
            SET i = num_entries + 1;  -- Exit the loop by setting i beyond num_entries
        ELSE
            -- Insert Request
            INSERT INTO Requests (CitizenID, NumberofPeople, Status, DateCreated, DateAssignedVehicle, DateFinished, RescuerID)
            VALUES (1,1,  'FINISHED', base_date, base_date + INTERVAL 1 DAY, base_date + INTERVAL 2 DAY, 1);
            -- Insert corresponding RequestItem
            INSERT INTO RequestItems (RequestID, ItemID, Quantity)
            VALUES (LAST_INSERT_ID(), 1, 1);
            -- Insert Offer
            INSERT INTO Offers (CitizenID, Status, DateCreated, DateAssignedVehicle, DateFinished, RescuerID)
            VALUES (1, 'FINISHED', base_date, base_date + INTERVAL 1 DAY, base_date + INTERVAL 2 DAY, 1);
            -- Insert corresponding OfferItem
            INSERT INTO OfferItems (OfferID, ItemID, Quantity)
            VALUES (LAST_INSERT_ID(), 1, 1);
            -- Increment the base date by 1 day
            SET base_date = base_date + INTERVAL 1 DAY;
            -- Increment the loop counter
            SET i = i + 1;
        END IF;
    END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `LoadFromWarehouseToVehicle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `LoadFromWarehouseToVehicle`(
    IN p_RescuerID INT,
    IN p_ItemIDs VARCHAR(1000),  
    IN p_Quantities VARCHAR(1000)  
)
BEGIN
    DECLARE v_VehicleID INT;
    DECLARE v_ItemID INT;
    DECLARE v_Quantity INT;
    DECLARE v_WarehouseQuantity INT;
    DECLARE total_items INT;
    DECLARE i INT DEFAULT 1;
    DECLARE v_ErrorMessage VARCHAR(255);  
    
    
    SET total_items = LENGTH(p_ItemIDs) - LENGTH(REPLACE(p_ItemIDs, ',', '')) + 1;

    
    SELECT VehicleID INTO v_VehicleID
    FROM Vehicles
    WHERE RescuerID = p_RescuerID;

    IF v_VehicleID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No vehicle assigned to the rescuer.';
    END IF;

    
    START TRANSACTION;

    
    WHILE i <= total_items DO
        
        SET v_ItemID = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p_ItemIDs, ',', i), ',', -1)) AS UNSIGNED);

        
        SET v_Quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p_Quantities, ',', i), ',', -1)) AS UNSIGNED);

        
        SELECT Quantity INTO v_WarehouseQuantity
        FROM Warehouse
        WHERE ItemID = v_ItemID;

        IF v_WarehouseQuantity IS NULL THEN
            SET v_ErrorMessage = CONCAT('Error: Item "', v_ItemID, '" is not available in the warehouse.');
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = v_ErrorMessage;
        ELSEIF v_WarehouseQuantity < v_Quantity THEN
            SET v_ErrorMessage = CONCAT('Error: Insufficient quantity of item "', v_ItemID, '" in the warehouse.');
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = v_ErrorMessage;
        END IF;

        
        INSERT INTO VehicleItems (VehicleID, ItemID, Quantity)
        VALUES (v_VehicleID, v_ItemID, v_Quantity)
        ON DUPLICATE KEY UPDATE Quantity = Quantity + v_Quantity;

        
        UPDATE Warehouse
        SET Quantity = Quantity - v_Quantity
        WHERE ItemID = v_ItemID;

        
        IF (v_WarehouseQuantity - v_Quantity) <= 0 THEN
            DELETE FROM Warehouse WHERE ItemID = v_ItemID;
        END IF;

        SET i = i + 1;
    END WHILE;

    
    COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `LoadVehicleFromOffer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `LoadVehicleFromOffer`(
    IN p_OfferID INT,
    IN p_RescuerID INT
)
BEGIN
    DECLARE v_VehicleID INT;
    DECLARE v_ItemID INT;
    DECLARE v_OfferQuantity INT;
    DECLARE v_VehicleQuantity INT;
    DECLARE done INT DEFAULT 0;

    
    DECLARE offer_items_cursor CURSOR FOR 
    SELECT ItemID, Quantity FROM OfferItems WHERE OfferID = p_OfferID;

    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    
    IF NOT EXISTS (SELECT 1 FROM Offers WHERE OfferID = p_OfferID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Offer does not exist.';
    END IF;

    
    IF NOT EXISTS (SELECT 1 FROM Offers WHERE OfferID = p_OfferID AND RescuerID = p_RescuerID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Rescuer is not assigned to this offer.';
    END IF;

    
    SELECT VehicleID INTO v_VehicleID FROM Vehicles WHERE RescuerID = p_RescuerID;

    IF v_VehicleID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No vehicle assigned to the rescuer.';
    END IF;

    
    START TRANSACTION;

    
    OPEN offer_items_cursor;

    
    items_loop: LOOP
        
        FETCH offer_items_cursor INTO v_ItemID, v_OfferQuantity;

        
        IF done = 1 THEN
            LEAVE items_loop;
        END IF;

        
        IF EXISTS (SELECT 1 FROM VehicleItems WHERE VehicleID = v_VehicleID AND ItemID = v_ItemID) THEN
            
            SELECT Quantity INTO v_VehicleQuantity
            FROM VehicleItems 
            WHERE VehicleID = v_VehicleID AND ItemID = v_ItemID;

            
            UPDATE VehicleItems
            SET Quantity = v_VehicleQuantity + v_OfferQuantity
            WHERE VehicleID = v_VehicleID AND ItemID = v_ItemID;
        ELSE
            
            INSERT INTO VehicleItems (VehicleID, ItemID, Quantity)
            VALUES (v_VehicleID, v_ItemID, v_OfferQuantity);
        END IF;
    END LOOP;

    
    CLOSE offer_items_cursor;

    
    COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UnloadFromVehicleToWarehouse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UnloadFromVehicleToWarehouse`(
    IN p_RescuerID INT,
    IN p_ItemIDs VARCHAR(1000),  
    IN p_Quantities VARCHAR(1000)  
)
BEGIN
    DECLARE v_VehicleID INT;
    DECLARE v_ItemID INT;
    DECLARE v_Quantity INT;
    DECLARE v_VehicleQuantity INT;
    DECLARE total_items INT;
    DECLARE i INT DEFAULT 1;
    DECLARE v_ErrorMessage VARCHAR(255);  
    
    
    SET total_items = LENGTH(p_ItemIDs) - LENGTH(REPLACE(p_ItemIDs, ',', '')) + 1;

    
    SELECT VehicleID INTO v_VehicleID
    FROM Vehicles
    WHERE RescuerID = p_RescuerID;

    IF v_VehicleID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No vehicle assigned to the rescuer.';
    END IF;

    
    START TRANSACTION;

    
    WHILE i <= total_items DO
        
        SET v_ItemID = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p_ItemIDs, ',', i), ',', -1)) AS UNSIGNED);

        
        SET v_Quantity = CAST(TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p_Quantities, ',', i), ',', -1)) AS UNSIGNED);

        
        SELECT Quantity INTO v_VehicleQuantity
        FROM VehicleItems
        WHERE VehicleID = v_VehicleID AND ItemID = v_ItemID;

        IF v_VehicleQuantity IS NULL THEN
            SET v_ErrorMessage = CONCAT('Item "', v_ItemID, '" is not available in the vehicle.');
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = v_ErrorMessage;
        ELSEIF v_VehicleQuantity < v_Quantity THEN
            SET v_ErrorMessage = CONCAT('Insufficient quantity of item "', v_ItemID, '" in the vehicle.');
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = v_ErrorMessage;
        END IF;

        
        
        INSERT INTO Warehouse (ItemID, Quantity)
        VALUES (v_ItemID, v_Quantity)
        ON DUPLICATE KEY UPDATE Quantity = Warehouse.Quantity + v_Quantity;

        
        UPDATE VehicleItems
        SET Quantity = Quantity - v_Quantity
        WHERE VehicleID = v_VehicleID AND ItemID = v_ItemID;

        
        IF (v_VehicleQuantity - v_Quantity) <= 0 THEN
            DELETE FROM VehicleItems WHERE VehicleID = v_VehicleID AND ItemID = v_ItemID;
        END IF;

        SET i = i + 1;
    END WHILE;

    
    COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UnloadVehicleOnRequestCompletion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UnloadVehicleOnRequestCompletion`(
    IN p_RescuerID INT,
    IN p_RequestID INT
)
BEGIN
    DECLARE v_VehicleID INT;
    DECLARE v_ItemID INT;
    DECLARE v_RequestedQuantity INT;
    DECLARE v_VehicleQuantity INT;
    DECLARE v_ItemName VARCHAR(255);  
    DECLARE done INT DEFAULT 0;
    DECLARE v_ErrorMessage VARCHAR(255);  
    
    
    DECLARE request_items_cursor CURSOR FOR 
    SELECT ri.ItemID, ri.Quantity, i.Name
    FROM RequestItems ri
    JOIN Items i ON ri.ItemID = i.ItemID
    WHERE RequestID = p_RequestID;

    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    
    IF NOT EXISTS (SELECT 1 FROM Requests WHERE RequestID = p_RequestID AND RescuerID = p_RescuerID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Rescuer is not assigned to this request.';
    END IF;

    
    SELECT VehicleID INTO v_VehicleID FROM Vehicles WHERE RescuerID = p_RescuerID;

    IF v_VehicleID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No vehicle assigned to the rescuer.';
    END IF;

    
    START TRANSACTION;

    
    OPEN request_items_cursor;

    
    items_loop: LOOP
        
        FETCH request_items_cursor INTO v_ItemID, v_RequestedQuantity, v_ItemName;

        
        IF done = 1 THEN
            LEAVE items_loop;
        END IF;

        
        SELECT Quantity INTO v_VehicleQuantity 
        FROM VehicleItems 
        WHERE VehicleID = v_VehicleID AND ItemID = v_ItemID;

        
        IF v_VehicleQuantity IS NULL THEN
            SET v_ErrorMessage = CONCAT('Error: Item "', v_ItemName, '" (ID ', v_ItemID, ') does not exist in the vehicle.');
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = v_ErrorMessage;
        ELSE
            
            IF v_VehicleQuantity < v_RequestedQuantity THEN
                SET v_ErrorMessage = CONCAT('Error: Insufficient quantity of item "', v_ItemName, '" (ID ', v_ItemID, ') in the vehicle.');
                SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = v_ErrorMessage;
            ELSE
                
                UPDATE VehicleItems
                SET Quantity = Quantity - v_RequestedQuantity
                WHERE VehicleID = v_VehicleID AND ItemID = v_ItemID;

                
                IF (v_VehicleQuantity - v_RequestedQuantity) <= 0 THEN
                    DELETE FROM VehicleItems WHERE VehicleID = v_VehicleID AND ItemID = v_ItemID;
                END IF;
            END IF;
        END IF;
    END LOOP;

    
    CLOSE request_items_cursor;

    
    COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-16 22:18:21
