-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema bookingsystem
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `bookingsystem` ;

-- -----------------------------------------------------
-- Schema bookingsystem
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bookingsystem` DEFAULT CHARACTER SET utf8mb3 ;
USE `bookingsystem` ;

-- -----------------------------------------------------
-- Table `bookingsystem`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bookingsystem`.`customer` ;

CREATE TABLE IF NOT EXISTS `bookingsystem`.`customer` (
  `CustomerID` INT NOT NULL AUTO_INCREMENT,
  `F_Name` VARCHAR(45) NOT NULL,
  `L_Name` VARCHAR(45) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Address` VARCHAR(45) NOT NULL,
  `Telephone` VARCHAR(11) NOT NULL,
  `CreditCard` VARCHAR(16) NULL DEFAULT NULL,
  `Password` VARCHAR(16) NULL DEFAULT NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE INDEX `CustomerID_UNIQUE` (`CustomerID` ASC) VISIBLE,
  UNIQUE INDEX `CreditCard_UNIQUE` (`CreditCard` ASC) VISIBLE,
  UNIQUE INDEX `Password_UNIQUE` (`Password` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 38
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bookingsystem`.`event`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bookingsystem`.`event` ;

CREATE TABLE IF NOT EXISTS `bookingsystem`.`event` (
  `EventID` INT NOT NULL AUTO_INCREMENT,
  `Title` VARCHAR(45) NOT NULL,
  `Description` VARCHAR(255) NOT NULL,
  `Language` VARCHAR(45) NOT NULL,
  `Type` ENUM('Theatre', 'Musical', 'Opera', 'Concert') NOT NULL,
  `Duration` TIME NOT NULL,
  `Price` DOUBLE NOT NULL,
  PRIMARY KEY (`EventID`))
ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bookingsystem`.`performance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bookingsystem`.`performance` ;

CREATE TABLE IF NOT EXISTS `bookingsystem`.`performance` (
  `PerformanceID` INT NOT NULL AUTO_INCREMENT,
  `Date` DATE NOT NULL,
  `Time` ENUM('Morning', 'Evening') NOT NULL,
  `Circle_seat` INT UNSIGNED NOT NULL,
  `Stall_seat` INT UNSIGNED NOT NULL,
  `EventID` INT NOT NULL,
  PRIMARY KEY (`PerformanceID`),
  UNIQUE INDEX `PerformanceID_UNIQUE` (`PerformanceID` ASC) VISIBLE,
  INDEX `EventID_idx` (`EventID` ASC) VISIBLE,
  CONSTRAINT `EventID`
    FOREIGN KEY (`EventID`)
    REFERENCES `bookingsystem`.`event` (`EventID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 39
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `bookingsystem`.`ticket`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bookingsystem`.`ticket` ;

CREATE TABLE IF NOT EXISTS `bookingsystem`.`ticket` (
  `TicketID` INT NOT NULL AUTO_INCREMENT,
  `PerformanceID` INT NOT NULL,
  `Date` DATE NOT NULL,
  `Time` ENUM('Morning', 'Evening') NOT NULL,
  `price` DOUBLE NOT NULL,
  `Seat_Type` ENUM('Circle', 'Stall') NOT NULL,
  `Concessionary` BIT(1) NOT NULL,
  PRIMARY KEY (`TicketID`),
  UNIQUE INDEX `TicketID_UNIQUE` (`TicketID` ASC) VISIBLE,
  INDEX `TicketPID_idx` (`PerformanceID` ASC) VISIBLE,
  CONSTRAINT `TicketPID`
    FOREIGN KEY (`PerformanceID`)
    REFERENCES `bookingsystem`.`performance` (`PerformanceID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 33
DEFAULT CHARACTER SET = utf8mb3;

USE `bookingsystem` ;

-- -----------------------------------------------------
-- Placeholder table for view `bookingsystem`.`card_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookingsystem`.`card_details` (`email` INT, `creditcard` INT);

-- -----------------------------------------------------
-- Placeholder table for view `bookingsystem`.`list_events`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookingsystem`.`list_events` (`performanceID` INT, `title` INT, `description` INT, `date` INT, `time` INT, `language` INT, `circle_seat` INT, `Stall_seat` INT, `type` INT, `duration` INT, `Price` INT);

-- -----------------------------------------------------
-- Placeholder table for view `bookingsystem`.`login_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bookingsystem`.`login_details` (`email` INT, `password` INT);

-- -----------------------------------------------------
-- procedure addTicket
-- -----------------------------------------------------

USE `bookingsystem`;
DROP procedure IF EXISTS `bookingsystem`.`addTicket`;

DELIMITER $$
USE `bookingsystem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `addTicket`(IN Performance_ID INT ,
The_Date Date, 
IN  The_Time Enum('Morning','Evening'), 
IN  The_Price Double, 
IN  Seat_Type Enum('Circle','Stall'),
IN  Is_Concessionary TINYINT)
begin
declare exit handler for sqlexception
begin
rollback;
end;
start transaction;
if Is_Concessionary = 1 then set The_Price = The_Price * 0.75;
end if;

Insert into bookingsystem.ticket (PerformanceID, Date, Time, Price, Seat_Type, Concessionary)
values (Performance_ID ,The_Date, The_Time, The_Price, Seat_Type, Is_Concessionary);

if Seat_Type = 'Circle' Then Update performance set Circle_seat = Circle_seat -1 where PerformanceID = Performance_ID;
else Update performance set Stall_seat = Stall_seat -1 where PerformanceID = Performance_ID; 
end if; 
commit work;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure debug_msg
-- -----------------------------------------------------

USE `bookingsystem`;
DROP procedure IF EXISTS `bookingsystem`.`debug_msg`;

DELIMITER $$
USE `bookingsystem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `debug_msg`(enabled INTEGER, msg VARCHAR(255))
BEGIN
  IF enabled THEN
    select concat('** ', msg) AS '** DEBUG:';
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure register
-- -----------------------------------------------------

USE `bookingsystem`;
DROP procedure IF EXISTS `bookingsystem`.`register`;

DELIMITER $$
USE `bookingsystem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `register`(
in name varchar(45),
in surname varchar(45),
in email varchar(45),
in address varchar(45),
in telephone varchar(11),
in card varchar(16),
in pass varchar(16) 
)
begin
declare exit handler for sqlexception
begin
rollback;
end;
start transaction;
insert into customer(F_Name, L_Name, Email, Address, Telephone, CreditCard, Password)
values(name,surname,email,address,telephone,card,pass);
select * from login_details where email = email;
commit work;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure removeBasket
-- -----------------------------------------------------

USE `bookingsystem`;
DROP procedure IF EXISTS `bookingsystem`.`removeBasket`;

DELIMITER $$
USE `bookingsystem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `removeBasket`(IN Ticket_ID INT
)
begin
declare exit handler for sqlexception
begin
rollback;
end;
start transaction;

 
 delete from bookingsystem.ticket where TicketID = Ticket_ID;
 -- call debug_msg(TRUE, 'Before Circle updated');
 
 -- call debug_msg(TRUE, 'After Circle updated');

-- call debug_msg(TRUE, 'Before Stall updated');

 -- call debug_msg(TRUE, 'After Stall updated');
commit work;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure removeTicket
-- -----------------------------------------------------

USE `bookingsystem`;
DROP procedure IF EXISTS `bookingsystem`.`removeTicket`;

DELIMITER $$
USE `bookingsystem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `removeTicket`(IN Ticket_ID INT,
IN Performance_ID int,
IN Seat_Type enum('Circle', 'Stall')
)
begin
declare exit handler for sqlexception
begin
rollback;
end;
start transaction;

 
 if Seat_Type = 'Circle' Then
 -- call debug_msg(TRUE, 'Before Circle updated');
 Update performance set Circle_seat = Circle_seat + 1 where PerformanceID = Performance_ID;
 -- call debug_msg(TRUE, 'After Circle updated');
 else
-- call debug_msg(TRUE, 'Before Stall updated');
 Update performance set Stall_seat = Stall_seat + 1 where PerformanceID = Performance_ID;
 -- call debug_msg(TRUE, 'After Stall updated');
 end if; 
 
 delete from bookingsystem.ticket where TicketID = Ticket_ID;


commit work;
end$$

DELIMITER ;

-- -----------------------------------------------------
-- View `bookingsystem`.`card_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bookingsystem`.`card_details`;
DROP VIEW IF EXISTS `bookingsystem`.`card_details` ;
USE `bookingsystem`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bookingsystem`.`card_details` AS select `bookingsystem`.`customer`.`Email` AS `email`,`bookingsystem`.`customer`.`CreditCard` AS `creditcard` from `bookingsystem`.`customer`;

-- -----------------------------------------------------
-- View `bookingsystem`.`list_events`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bookingsystem`.`list_events`;
DROP VIEW IF EXISTS `bookingsystem`.`list_events` ;
USE `bookingsystem`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bookingsystem`.`list_events` AS select `bookingsystem`.`performance`.`PerformanceID` AS `performanceID`,`bookingsystem`.`event`.`Title` AS `title`,`bookingsystem`.`event`.`Description` AS `description`,`bookingsystem`.`performance`.`Date` AS `date`,`bookingsystem`.`performance`.`Time` AS `time`,`bookingsystem`.`event`.`Language` AS `language`,`bookingsystem`.`performance`.`Circle_seat` AS `circle_seat`,`bookingsystem`.`performance`.`Stall_seat` AS `Stall_seat`,`bookingsystem`.`event`.`Type` AS `type`,`bookingsystem`.`event`.`Duration` AS `duration`,format(`bookingsystem`.`event`.`Price`,2) AS `Price` from (`bookingsystem`.`event` left join `bookingsystem`.`performance` on((`bookingsystem`.`performance`.`EventID` = `bookingsystem`.`event`.`EventID`)));

-- -----------------------------------------------------
-- View `bookingsystem`.`login_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bookingsystem`.`login_details`;
DROP VIEW IF EXISTS `bookingsystem`.`login_details` ;
USE `bookingsystem`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bookingsystem`.`login_details` AS select `bookingsystem`.`customer`.`Email` AS `email`,`bookingsystem`.`customer`.`Password` AS `password` from `bookingsystem`.`customer`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
