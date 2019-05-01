-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema brendasbakeries
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `brendasbakeries` ;

-- -----------------------------------------------------
-- Schema brendasbakeries
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `brendasbakeries` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `brendasbakeries` ;

-- -----------------------------------------------------
-- Table `Customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Customer` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `Customer` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `LastName` VARCHAR(45) NULL,
  `FirstName` VARCHAR(45) NULL,
  `Email` VARCHAR(45) NULL,
  `Phone` VARCHAR(12) NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `Shop`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Shop` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `Shop` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `City` VARCHAR(45) NULL,
  `State` VARCHAR(2) NULL,
  `ZIP` VARCHAR(9) NULL,
  `Phone` VARCHAR(12) NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `Employee`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Employee` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `Employee` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `LastName` VARCHAR(45) NULL,
  `FirstName` VARCHAR(45) NULL,
  `Address` VARCHAR(45) NULL,
  `City` VARCHAR(45) NULL,
  `State` VARCHAR(2) NULL,
  `ZIP` VARCHAR(9) NULL,
  `County` VARCHAR(45) NULL,
  `Phone` VARCHAR(12) NULL,
  `BirthDate` DATE NULL,
  `HireDate` DATE NULL,
  `SSN` VARCHAR(11) NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `Sale`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Sale` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `Sale` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Date` DATE NULL,
  `CustomerID` INT NOT NULL,
  `ShopID` INT NOT NULL,
  `EmployeeID` INT NOT NULL,
  PRIMARY KEY (`ID`, `CustomerID`, `ShopID`, `EmployeeID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC),
  INDEX `fk_Sale_Customer_idx` (`CustomerID` ASC),
  INDEX `fk_Sale_Shop1_idx` (`ShopID` ASC),
  INDEX `fk_Sale_Employee1_idx` (`EmployeeID` ASC),
  CONSTRAINT `fk_Sale_Customer`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `Customer` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sale_Shop1`
    FOREIGN KEY (`ShopID`)
    REFERENCES `Shop` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sale_Employee1`
    FOREIGN KEY (`EmployeeID`)
    REFERENCES `Employee` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `Schedule`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Schedule` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `Schedule` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `ShopID` INT NOT NULL,
  `EmployeeID` INT NOT NULL,
  PRIMARY KEY (`ID`, `ShopID`, `EmployeeID`),
  INDEX `fk_Shop_has_Employee_Employee1_idx` (`EmployeeID` ASC),
  INDEX `fk_Shop_has_Employee_Shop1_idx` (`ShopID` ASC),
  CONSTRAINT `fk_Shop_has_Employee_Shop1`
    FOREIGN KEY (`ShopID`)
    REFERENCES `Shop` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Shop_has_Employee_Employee1`
    FOREIGN KEY (`EmployeeID`)
    REFERENCES `Employee` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `Recipe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Recipe` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `Recipe` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `Quantity` INT NULL,
  `MeasureID` INT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `Product`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Product` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `Product` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `RecipeID` INT NOT NULL,
  PRIMARY KEY (`ID`, `RecipeID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC),
  INDEX `fk_Product_Recipe1_idx` (`RecipeID` ASC),
  CONSTRAINT `fk_Product_Recipe1`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `Recipe` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `UnitOfMeasure`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `UnitOfMeasure` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `UnitOfMeasure` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `SaleLineItem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SaleLineItem` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `SaleLineItem` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Price` DECIMAL(5,2) NULL,
  `Quantity` INT NULL,
  `UnitOfMeasureID` INT NOT NULL,
  `ProductID` INT NOT NULL,
  `SaleID` INT NOT NULL,
  PRIMARY KEY (`ID`, `UnitOfMeasureID`, `ProductID`, `SaleID`),
  INDEX `fk_Product_has_Sale_Sale1_idx` (`SaleID` ASC),
  INDEX `fk_Product_has_Sale_Product1_idx` (`ProductID` ASC),
  INDEX `fk_SaleLineItem_UnitOfMeasure1_idx` (`UnitOfMeasureID` ASC),
  CONSTRAINT `fk_Product_has_Sale_Product1`
    FOREIGN KEY (`ProductID`)
    REFERENCES `Product` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_has_Sale_Sale1`
    FOREIGN KEY (`SaleID`)
    REFERENCES `Sale` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SaleLineItem_UnitOfMeasure1`
    FOREIGN KEY (`UnitOfMeasureID`)
    REFERENCES `UnitOfMeasure` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `Vendor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Vendor` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `Vendor` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `ContractDate` DATE NULL,
  `Address` VARCHAR(45) NULL,
  `City` VARCHAR(45) NULL,
  `State` VARCHAR(2) NULL,
  `ZIP` VARCHAR(9) NULL,
  `Phone` VARCHAR(12) NULL,
  PRIMARY KEY (`ID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC))
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `Orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Orders` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `Orders` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `OrdersDate` DATE NULL,
  `Price` DECIMAL(5,2) NULL,
  `SupplyID` INT NULL,
  `VendorID` INT NOT NULL,
  `EmployeeID` INT NOT NULL,
  PRIMARY KEY (`ID`, `VendorID`, `EmployeeID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC),
  INDEX `fk_Orders_Vendor1_idx` (`VendorID` ASC),
  INDEX `fk_Orders_Employee1_idx` (`EmployeeID` ASC),
  CONSTRAINT `fk_Orders_Vendor1`
    FOREIGN KEY (`VendorID`)
    REFERENCES `Vendor` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Employee1`
    FOREIGN KEY (`EmployeeID`)
    REFERENCES `Employee` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `Ingredient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Ingredient` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `Ingredient` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(45) NULL,
  `Quantity` INT NULL,
  `UnitOfMeasureID` INT NOT NULL,
  PRIMARY KEY (`ID`, `UnitOfMeasureID`),
  UNIQUE INDEX `ID_UNIQUE` (`ID` ASC),
  INDEX `fk_Ingredient_UnitOfMeasure1_idx` (`UnitOfMeasureID` ASC),
  CONSTRAINT `fk_Ingredient_UnitOfMeasure1`
    FOREIGN KEY (`UnitOfMeasureID`)
    REFERENCES `UnitOfMeasure` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `OrdersLineItem`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OrdersLineItem` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `OrdersLineItem` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Cost` DECIMAL(5,2) NULL,
  `OrdersID` INT NOT NULL,
  `IngredientID` INT NOT NULL,
  `UnitOfMeasureID` INT NOT NULL,
  PRIMARY KEY (`ID`, `OrdersID`, `IngredientID`, `UnitOfMeasureID`),
  INDEX `fk_Orders_has_Ingredient_Ingredient1_idx` (`IngredientID` ASC),
  INDEX `fk_Orders_has_Ingredient_Orders1_idx` (`OrdersID` ASC),
  INDEX `fk_Orders_has_Ingredient_UnitOfMeasure1_idx` (`UnitOfMeasureID` ASC),
  CONSTRAINT `fk_Orders_has_Ingredient_Orders1`
    FOREIGN KEY (`OrdersID`)
    REFERENCES `Orders` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_has_Ingredient_Ingredient1`
    FOREIGN KEY (`IngredientID`)
    REFERENCES `Ingredient` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_has_Ingredient_UnitOfMeasure1`
    FOREIGN KEY (`UnitOfMeasureID`)
    REFERENCES `UnitOfMeasure` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `IngredientRecipe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `IngredientRecipe` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `IngredientRecipe` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `Quantity` VARCHAR(45) NULL,
  `RecipeID` INT NOT NULL,
  `IngredientID` INT NOT NULL,
  `UnitOfMeasureID` INT NOT NULL,
  PRIMARY KEY (`ID`, `RecipeID`, `IngredientID`, `UnitOfMeasureID`),
  INDEX `fk_Recipe_has_Ingredient_Ingredient1_idx` (`IngredientID` ASC),
  INDEX `fk_Recipe_has_Ingredient_Recipe1_idx` (`RecipeID` ASC),
  INDEX `fk_IngredientRecipe_UnitOfMeasure1_idx` (`UnitOfMeasureID` ASC),
  CONSTRAINT `fk_Recipe_has_Ingredient_Recipe1`
    FOREIGN KEY (`RecipeID`)
    REFERENCES `Recipe` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Recipe_has_Ingredient_Ingredient1`
    FOREIGN KEY (`IngredientID`)
    REFERENCES `Ingredient` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_IngredientRecipe_UnitOfMeasure1`
    FOREIGN KEY (`UnitOfMeasureID`)
    REFERENCES `UnitOfMeasure` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
