-- MySQL dump 10.13  Distrib 5.1.49, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: crawler_development
-- ------------------------------------------------------
-- Server version	5.1.49-3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `available_fields`
--

DROP TABLE IF EXISTS `available_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `available_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `field_name` varchar(255) NOT NULL,
  `parser_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `PK` (`id`),
  UNIQUE KEY `field_name` (`field_name`,`parser_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `available_fields`
--

LOCK TABLES `available_fields` WRITE;
/*!40000 ALTER TABLE `available_fields` DISABLE KEYS */;
INSERT INTO `available_fields` VALUES (11,'Additional details',1),(14,'Additional details',2),(26,'Additional details',3),(7,'Brief description',1),(27,'Brief description',3),(42,'City',5),(6,'Department description',1),(16,'Department description',2),(28,'Department description',3),(8,'Detailed description',1),(29,'Detailed description',3),(25,'How to apply',1),(24,'How to apply',2),(30,'How to apply',3),(12,'html',1),(18,'html',2),(31,'html',3),(38,'html',5),(44,'Job Description',5),(10,'Job requirements',1),(19,'Job requirements',2),(32,'Job requirements',3),(3,'Location',1),(20,'Location',2),(33,'Location',3),(5,'Organization Name',1),(21,'Organization Name',2),(34,'Organization Name',3),(41,'Part Time ',5),(39,'Post Date',5),(35,'ref_code',3),(37,'ref_code',5),(45,'Requirements',5),(43,'State',5),(40,'Title',5),(2,'Working title',1),(23,'Working title',2),(36,'Working title',3);
/*!40000 ALTER TABLE `available_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logins`
--

DROP TABLE IF EXISTS `logins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `login` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `url` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logins`
--

LOCK TABLES `logins` WRITE;
/*!40000 ALTER TABLE `logins` DISABLE KEYS */;
/*!40000 ALTER TABLE `logins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parsers`
--

DROP TABLE IF EXISTS `parsers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parsers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `PK` (`id`),
  UNIQUE KEY `parser_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parsers`
--

LOCK TABLES `parsers` WRITE;
/*!40000 ALTER TABLE `parsers` DISABLE KEYS */;
INSERT INTO `parsers` VALUES (1,'OracleIrecruitment_v1','Oracle - irecruitment','Parser to parse IRecruitment based sites.\r\nDistinctive feature of the site is \"Search\" button in job search form.\r\nAnother option is \"Go\" label on this button, in this case use \"Oracle - irecruit\" parser'),(2,'OracleIrecruitment_v2','Oracle - irecruit','Parser to parse IRecruitment based sites.\r\nDistinctive feature of the site is \"Go\" button in job search form.\r\nAnother option is \"Search\" label on this button, in this case use \"Oracle - irecruitment\" parser'),(3,'Brassring','Brassring','To scrap site using Brassringengine'),(5,'UltiRecruit','Ulti Recruit','');
/*!40000 ALTER TABLE `parsers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `result_fields`
--

DROP TABLE IF EXISTS `result_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `result_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `xpath_id` int(11) NOT NULL,
  `value` text NOT NULL,
  `result_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `PK` (`id`),
  UNIQUE KEY `unique_field` (`result_id`,`xpath_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `result_fields`
--

LOCK TABLES `result_fields` WRITE;
/*!40000 ALTER TABLE `result_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `result_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results`
--

DROP TABLE IF EXISTS `results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `time_crawled` datetime NOT NULL,
  `link` text NOT NULL,
  `html` text,
  `ref_code` varchar(255) DEFAULT NULL,
  `site_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `PK` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results`
--

LOCK TABLES `results` WRITE;
/*!40000 ALTER TABLE `results` DISABLE KEYS */;
/*!40000 ALTER TABLE `results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20110818125720'),('20110818130045'),('20110818130051'),('20110818130053'),('20110818130069'),('20110818130077'),('20110826092118'),('20110826111103'),('20110829113920'),('20110903094029');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `active` varchar(1) NOT NULL DEFAULT 'y',
  `url` text NOT NULL,
  `parser_id` int(11) NOT NULL,
  `login_id` int(11) DEFAULT NULL,
  `save_html` varchar(1) NOT NULL DEFAULT 'n',
  `runs` int(11) NOT NULL DEFAULT '0',
  `status` varchar(255) NOT NULL DEFAULT 'idle',
  `last_run` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `PK` (`id`),
  UNIQUE KEY `site_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (1,'iRecruitment','y','https://irecruitment.oracle.com/OA_HTML/RF.jsp?function_id=1038712&resp_id=23350&resp_appl_id=800&security_group_id=0&lang_code=US&params=.1VlTZi5hyKHcE3E6mrZaB91phg4LLW-2ZXXJFOuaJdg-6ALqWl2AqDOwJZdQVEM&oas=f9bSTzElHujSgfFdBZBb-g',1,NULL,'y',7,'idle','2011-09-06 17:25:49'),(4,'LGMC','y','http://irecruit.lgmc.com/OA_HTML/OA.jsp?_rc=IRC_VIS_JOB_SEARCH_PAGE&_ri=800&SeededSearchFlag=N&Contractor=Y&Employee=Y&OASF=IRC_VIS_JOB_SEARCH_PAGE&_ti=1808067168&oapc=2&OAMC=75478_9_0&menu=Y&oaMenuLevel=1&oas=QHZS5wWEOk2m60TtPf56bg',2,NULL,'y',2,'idle','2011-09-06 17:03:08'),(5,'Brassring','y','https://sstagingjobs.brassring.com/1033/ASP/TG/cim_advsearch.asp?partnerid=20052&siteid=5005',3,NULL,'y',9,'idle','2011-09-06 16:59:12'),(6,'AECOM','y','https://jobs.aecom.com/1033/ASP/TG/cim_advsearch.asp?partnerid=20052&siteid=5022',3,NULL,'y',1,'idle','2011-09-06 17:24:50'),(7,'UBS','y','https://jobs.ubs.com/1033/ASP/TG/cim_advsearch.asp?partnerid=25008&siteid=5012',3,NULL,'y',1,'Saved 541','2011-09-06 16:46:04'),(8,'Atlantic SouthEast Airlanes','y','https://www2.ultirecruit.com/SKY1000B/JobBoard/ListJobs.aspx?__VT=ExtCan',5,NULL,'y',1,'idle','2011-09-08 09:27:11'),(11,'Bapthis Health Systems','y','https://www10.ultirecruit.com/bap1001/JobBoard/ListJobs.aspx?__VT=ExtCan',5,NULL,'y',2,'idle','2011-09-08 10:28:19'),(12,'MEDNAX','y','https://www.ultirecruit.com/PED1000/jobboard/SearchJobs.aspx?Page=Search',5,NULL,'y',4,'idle','2011-09-08 11:00:11'),(13,'Unity Health','y','https://www.ultirecruit.com/par1007/JobBoard/SearchJobs.aspx?Page=Search',5,NULL,'y',2,'idle','2011-09-08 11:05:38'),(14,'PharmaNet','y','https://www.ultirecruit.com/pha1001/JobBoard/SearchJobs.aspx?Page=Search',5,NULL,'y',1,'idle','2011-09-08 11:05:01'),(15,'Micro Center','y','https://www.ultirecruit.com/MIC1003/jobboard/ListJobs.aspx?__VT=ExtCan',5,NULL,'y',1,'idle','2011-09-08 11:08:34');
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xpath`
--

DROP TABLE IF EXISTS `xpath`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xpath` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) NOT NULL,
  `available_field_id` int(11) NOT NULL,
  `xpath` longtext NOT NULL,
  `delimiter` varchar(255) DEFAULT NULL,
  `show_in_index` int(11) NOT NULL DEFAULT '1',
  `show_in_full` int(11) NOT NULL DEFAULT '1',
  `pos` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_field_name` (`site_id`,`available_field_id`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xpath`
--

LOCK TABLES `xpath` WRITE;
/*!40000 ALTER TABLE `xpath` DISABLE KEYS */;
INSERT INTO `xpath` VALUES (5,1,2,'//*[@id=\"JobTitle\"]','',1,1,1),(6,1,3,'//*[@id=\"DerivedLocale\"]','',1,1,2),(7,1,5,'//*[@id=\"IrcPostingOrgName\"]','',1,1,3),(8,1,6,'/html/body/form/span[2]/div//div/div[2]/span/table//tr[4]/td/table//tr/td/div/div/table//tr/td[2]/table//tr[9]/td[3]','',0,1,4),(9,1,7,'/html/body/form/span[2]/div//div/div[2]/span/table//tr[4]/td/table//tr/td/div/div/table//tr/td[2]/table//tr[13]/td[3]','',1,1,5),(10,1,8,'/html/body/form/span[2]/div//div/div[2]/span/table//tr[4]/td/table//tr/td/div/div/table//tr/td[2]/table//tr[17]/td[3]','',0,1,6),(11,1,10,'/html/body/form/span[2]/div//div/div[2]/span/table//tr[4]/td/table//tr/td/div/div/table//tr/td[2]/table//tr[21]/td[3]','',0,1,7),(12,1,11,'/html/body/form/span[2]/div//div/div[2]/span/table//tr[4]/td/table//tr/td/div/div/table//tr/td[2]/table//tr[25]/td[3]','',0,1,8),(13,1,12,'/html/body/form/span[2]/div/div[4]/div/div[2]/span/table/tr[4]/td/table/tr/td/div/div/table/tr/td[2]','',0,1,9),(23,4,23,'//*[@id=\"JobTitle\"]','',1,1,1),(24,4,20,'//*[@id=\"DerivedLocale\"]','',1,1,2),(25,4,21,'//*[@id=\"IrcPostingOrgName\"]','',1,1,3),(26,4,16,'/html/body/form/span[2]/div/div[3]/span/table//tr[4]/td/table//tr/td/table//tr/td[2]/table//tr[3]/td[3]','',0,1,4),(27,4,19,'/html/body/form/span[2]/div/div[3]/span/table//tr[4]/td/table//tr/td/table//tr/td[2]/table//tr[13]/td[3]','',0,1,5),(28,4,14,'/html/body/form/span[2]/div/div[3]/span/table//tr[4]/td/table//tr/td/table//tr/td[2]/table//tr[17]/td[3]','',0,1,6),(29,4,24,'/html/body/form/span[2]/div/div[3]/span/table//tr[4]/td/table//tr/td/table//tr/td[2]/table//tr[21]/td[3]','',1,1,7),(30,4,18,'//*[@id=\"Description\"]','',1,1,8),(31,5,36,'//*[@id=\"Position Title\"]','',1,1,1),(32,5,33,'//*[@id=\"Office Region\"]\r\n\r\n//*[@id=\"Office Location\"]',', ',1,1,2),(33,5,28,'//*[@id=\"About the Business Line\"]','',0,1,3),(34,5,27,'//*[@id=\"About the Business Line\"]','',1,1,4),(35,5,32,'//*[@id=\"Job Description\"]','',0,1,5),(36,5,26,'//*[@id=\"What We Offer\"]','',0,1,6),(37,5,35,'//*[@id=\"Requisition/Vacancy No.\"]','',1,1,7),(38,5,31,'//table[@id=\"con\"]/tr/td/table[2]/tr/td/a/form[6]/table/tr[2]/td','',1,1,8),(39,6,36,'//*[@id=\"Position Title\"]','',1,1,1),(40,6,33,'//*[@id=\"Office Region\"]\r\n\r\n//*[@id=\"Office Location\"]',', ',1,1,2),(41,6,28,'//*[@id=\"About the Business Line\"]','',0,1,3),(42,6,27,'//*[@id=\"About the Business Line\"]','',1,1,4),(43,6,32,'//*[@id=\"Job Description\"]','',0,1,5),(44,6,26,'//*[@id=\"What We Offer\"]','',0,1,6),(45,6,35,'//*[@id=\"Requisition/Vacancy No.\"]','',1,1,7),(46,6,31,'//table[@id=\"con\"]/tr/td/table[2]/tr/td/a/form[6]/table/tr[2]/td','',1,1,8),(47,7,36,'//*[@id=\"Title\"]','',1,1,1),(48,7,33,'//*[@id=\"Location\"]\r\n\r\n//*[@id=\"City\"]',', ',1,1,2),(49,7,27,'//*[@id=\"Function Category\"] \r\n\r\n//*[@id=\"Business Divisions\"] \r\n\r\n//*[@id=\"Job Type\"]',' / ',0,1,3),(50,7,29,'//*[@id=\"Description\"]','',0,1,4),(51,7,32,'//*[@id=\"Requirements\"]','',0,1,5),(52,7,30,'//*[@id=\"Take the next step\"]','',1,1,6),(53,7,26,'//*[@id=\"Our Offering\"]','',0,1,7),(54,7,35,'//span[@id=\"Job Reference #\"]','',1,1,8),(55,7,31,'/html/body/table/tr/td/table/tr/td/a/table/tr[10]/td/table/tr/td[2]/table/tr[2]/td/table[2]/tr/td/a/form[6]/table/tr[2]/td/table[4]','',1,1,9),(56,8,37,'//td[@id=\"DataCell_Req_Code\"]','',1,1,1),(57,8,39,'//td[@id=\"DataCell_Req_PostDate\"]','',1,1,2),(58,8,40,'//td[@id=\"DataCell_Req_TitleFK\"]','',1,1,3),(59,8,41,'//td[@id=\"DataCell_Req_PartTime\"]','',1,1,4),(60,8,42,'//td[@id=\"DataCell_Req_City\"]','',1,1,5),(61,8,43,'//td[@id=\"DataCell_Req_State\"]','',0,1,6),(62,8,44,'//td[@id=\"DataCell_Req_Description\"]','',0,1,7),(63,8,45,'//td[@id=\"DataCell_Req_Requirements\"]','',0,1,8),(64,8,38,'/html/body/div/div[2]/div[2]/table/tr/td[2]','',0,1,9),(83,11,37,'//td[@id=\"DataCell_Req_Code\"]','',1,1,1),(84,11,39,'//td[@id=\"DataCell_Req_PostDate\"]','',1,1,2),(85,11,40,'//td[@id=\"DataCell_Req_TitleFK\"]','',1,1,3),(86,11,41,'//td[@id=\"DataCell_Req_PartTime\"]','',1,1,4),(87,11,42,'//td[@id=\"DataCell_Req_City\"]','',1,1,5),(88,11,43,'//td[@id=\"DataCell_Req_State\"]','',0,1,6),(89,11,44,'//td[@id=\"DataCell_Req_Description\"]','',0,1,7),(90,11,45,'//td[@id=\"DataCell_Req_Requirements\"]','',0,1,8),(91,11,38,'//form[@id=\"PXForm\"]','',0,1,9),(92,12,37,'//td[@id=\"DataCell_Req_Code\"]','',1,1,1),(93,12,39,'//td[@id=\"DataCell_Req_PostDate\"]','',1,1,2),(94,12,40,'//td[@id=\"DataCell_Req_TitleFK\"]','',1,1,3),(96,12,42,'//td[@id=\"DataCell_Req_City\"]','',1,1,5),(97,12,43,'//td[@id=\"DataCell_Req_State\"]','',0,1,6),(98,12,44,'//td[@id=\"DataCell_Req_Description\"]','',0,1,7),(99,12,45,'//td[@id=\"DataCell_Req_Requirements\"]','',0,1,8),(100,12,38,'/html/body/div/div[2]/div[2]/table/tr/td[2]','',0,1,9),(101,13,37,'//td[@id=\"DataCell_Req_Code\"]','',1,1,1),(102,13,39,'//td[@id=\"DataCell_Req_PostDate\"]','',1,1,2),(103,13,40,'//td[@id=\"DataCell_Req_TitleFK\"]','',1,1,3),(104,13,41,'//td[@id=\"DataCell_Req_PartTime\"]','',1,1,4),(105,13,42,'//td[@id=\"DataCell_Req_City\"]','',1,1,5),(106,13,43,'//td[@id=\"DataCell_Req_State\"]','',0,1,6),(107,13,44,'//td[@id=\"DataCell_Req_Description\"]','',0,1,7),(108,13,45,'//td[@id=\"DataCell_Req_Requirements\"]','',0,1,8),(109,13,38,'//form[@id=\"PXForm\"]','',0,1,9),(110,14,37,'//td[@id=\"DataCell_Req_Code\"]','',1,1,1),(111,14,39,'//td[@id=\"DataCell_Req_PostDate\"]','',1,1,2),(112,14,40,'//td[@id=\"DataCell_Req_TitleFK\"]','',1,1,3),(113,14,41,'//td[@id=\"DataCell_Req_PartTime\"]','',1,1,4),(114,14,42,'//td[@id=\"DataCell_Req_City\"]','',1,1,5),(115,14,43,'//td[@id=\"DataCell_Req_State\"]','',0,1,6),(116,14,44,'//td[@id=\"DataCell_Req_Description\"]','',0,1,7),(117,14,45,'//td[@id=\"DataCell_Req_Requirements\"]','',0,1,8),(118,14,38,'//form[@id=\"PXForm\"]','',0,1,9),(119,15,37,'//td[@id=\"DataCell_Req_Code\"]','',1,1,1),(120,15,39,'//td[@id=\"DataCell_Req_PostDate\"]','',1,1,2),(121,15,40,'//td[@id=\"DataCell_Req_TitleFK\"]','',1,1,3),(122,15,41,'//td[@id=\"DataCell_Req_PartTime\"]','',1,1,4),(123,15,42,'//td[@id=\"DataCell_Req_City\"]','',1,1,5),(124,15,43,'//td[@id=\"DataCell_Req_State\"]','',0,1,6),(125,15,44,'//td[@id=\"DataCell_Req_Description\"]','',0,1,7),(126,15,45,'//td[@id=\"DataCell_Req_Requirements\"]','',0,1,8),(127,15,38,'//form[@id=\"PXForm\"]','',0,1,9);
/*!40000 ALTER TABLE `xpath` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-09-08 13:47:39
