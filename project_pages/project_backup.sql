/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.5.29-MariaDB, for Linux (x86_64)
--
-- Host: classmysql.engr.oregonstate.edu    Database: cs340_carbonei
-- ------------------------------------------------------
-- Server version	10.11.16-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Customer_store`
--

DROP TABLE IF EXISTS `Customer_store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Customer_store` (
  `customer_store_ID` int(11) NOT NULL AUTO_INCREMENT,
  `customer_ID` int(11) NOT NULL,
  `Stores_location_ID` int(11) NOT NULL,
  PRIMARY KEY (`customer_store_ID`,`customer_ID`,`Stores_location_ID`),
  KEY `fk_Customers_has_Stores_Stores1_idx` (`Stores_location_ID`),
  KEY `fk_Customers_has_Stores_Customers1_idx` (`customer_ID`),
  CONSTRAINT `fk_Customers_has_Stores_Customers1` FOREIGN KEY (`customer_ID`) REFERENCES `Customers` (`customer_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Customers_has_Stores_Stores1` FOREIGN KEY (`Stores_location_ID`) REFERENCES `Stores` (`location_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customer_store`
--

LOCK TABLES `Customer_store` WRITE;
/*!40000 ALTER TABLE `Customer_store` DISABLE KEYS */;
INSERT INTO `Customer_store` VALUES (1,1,3),(2,2,1),(3,3,2),(4,2,3),(5,1,2);
/*!40000 ALTER TABLE `Customer_store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Customers`
--

DROP TABLE IF EXISTS `Customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Customers` (
  `customer_ID` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  PRIMARY KEY (`customer_ID`),
  UNIQUE KEY `customer_ID_UNIQUE` (`customer_ID`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customers`
--

LOCK TABLES `Customers` WRITE;
/*!40000 ALTER TABLE `Customers` DISABLE KEYS */;
INSERT INTO `Customers` VALUES (1,'Taylor','Murray','murrayt@hello.com'),(2,'Jeremy','Grant','Grant'),(3,'Kate','Whitaker','whitakate@hello.com');
/*!40000 ALTER TABLE `Customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Items`
--

DROP TABLE IF EXISTS `Items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Items` (
  `item_ID` int(11) NOT NULL AUTO_INCREMENT,
  `item_cost` double NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `location_ID` int(11) NOT NULL,
  PRIMARY KEY (`item_ID`,`location_ID`),
  UNIQUE KEY `item_ID_UNIQUE` (`item_ID`),
  KEY `fk_Items_Stores1_idx` (`location_ID`),
  CONSTRAINT `fk_Items_Stores1` FOREIGN KEY (`location_ID`) REFERENCES `Stores` (`location_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Items`
--

LOCK TABLES `Items` WRITE;
/*!40000 ALTER TABLE `Items` DISABLE KEYS */;
INSERT INTO `Items` VALUES (1,2,'Chocolate Chip Cookie',2),(2,3,'Red Velvet Cupcake',1),(3,4,'Bacon Cheddar Croissant',3),(4,2,'Chocolate Chip Cookie',3),(5,3,'Red Velvet Cupcake',2);
/*!40000 ALTER TABLE `Items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ordered_Item`
--

DROP TABLE IF EXISTS `Ordered_Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ordered_Item` (
  `ordered_itemID` int(11) NOT NULL,
  `order_ID` int(11) NOT NULL,
  `item_ID` int(11) NOT NULL,
  PRIMARY KEY (`ordered_itemID`,`order_ID`,`item_ID`),
  UNIQUE KEY `ordered_ItemID_UNIQUE` (`ordered_itemID`),
  KEY `fk_Items_has_Orders_Orders1_idx` (`order_ID`),
  KEY `fk_Items_has_Orders_Items1_idx` (`item_ID`),
  CONSTRAINT `fk_Items_has_Orders_Items1` FOREIGN KEY (`item_ID`) REFERENCES `Items` (`item_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Items_has_Orders_Orders1` FOREIGN KEY (`order_ID`) REFERENCES `Orders` (`order_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ordered_Item`
--

LOCK TABLES `Ordered_Item` WRITE;
/*!40000 ALTER TABLE `Ordered_Item` DISABLE KEYS */;
INSERT INTO `Ordered_Item` VALUES (1,1,1),(2,1,5),(3,2,3),(4,2,4),(5,3,2);
/*!40000 ALTER TABLE `Ordered_Item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Orders`
--

DROP TABLE IF EXISTS `Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Orders` (
  `order_ID` int(11) NOT NULL AUTO_INCREMENT,
  `order_cost` double NOT NULL,
  `item_count` int(11) NOT NULL,
  `customer_ID` int(11) NOT NULL,
  `location_ID` int(11) NOT NULL,
  PRIMARY KEY (`order_ID`,`customer_ID`,`location_ID`),
  UNIQUE KEY `order_ID_UNIQUE` (`order_ID`),
  KEY `fk_Orders_Customers_idx` (`customer_ID`),
  KEY `fk_Orders_Stores1_idx` (`location_ID`),
  CONSTRAINT `fk_Orders_Customers` FOREIGN KEY (`customer_ID`) REFERENCES `Customers` (`customer_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Stores1` FOREIGN KEY (`location_ID`) REFERENCES `Stores` (`location_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Orders`
--

LOCK TABLES `Orders` WRITE;
/*!40000 ALTER TABLE `Orders` DISABLE KEYS */;
INSERT INTO `Orders` VALUES (1,5,2,3,2),(2,6,2,1,3),(3,3,1,2,1);
/*!40000 ALTER TABLE `Orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Stores`
--

DROP TABLE IF EXISTS `Stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stores` (
  `location_ID` int(11) NOT NULL AUTO_INCREMENT,
  `location_name` varchar(50) NOT NULL,
  `total_transaction_count` int(11) NOT NULL,
  PRIMARY KEY (`location_ID`),
  UNIQUE KEY `location_ID_UNIQUE` (`location_ID`),
  UNIQUE KEY `location_name_UNIQUE` (`location_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stores`
--

LOCK TABLES `Stores` WRITE;
/*!40000 ALTER TABLE `Stores` DISABLE KEYS */;
INSERT INTO `Stores` VALUES (1,'Maple Avenue',200),(2,'Cedar Street',250),(3,'Oak Place',300);
/*!40000 ALTER TABLE `Stores` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-30 19:02:49
