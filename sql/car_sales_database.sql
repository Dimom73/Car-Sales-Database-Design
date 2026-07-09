--1) Creating Database
CREATE DATABASE "Cars Sales"
USE [Cars Sales]

--2) Uploading Excel file car_sales_data
--3) Creating tables
/*
Customers
CustomerID PK (IDENTITY) CustomerName Gender AnnualIncome

Regions
RegionID PK (IDENTITY) RegionName

Dealers
DealerID PK (IDENTITY) DealerName DealerNo

Companies
CompanyID PK (IDENTITY) CompanyName

Models
ModelID PK (IDENTITY) ModelName

BodyStyles
BodyStyleID PK (IDENTITY) BodyStyleName

Cars
CarID PK CompanyID FK ModelID FK BodyStyleID FK Color Engine Transmission

Sales
SaleID PK (IDENTITY) SaleDate CustomerID FK DealerID FK RegionID FK CarID FK Price Phone
*/

CREATE TABLE Customers
(
CustomerID INT IDENTITY(1,1),
CustomerName VARCHAR(255),
Gender VARCHAR(255), -- Stored directly (few variations in the dataset)
AnnualIncome INT, -- Stored as INT because income values are whole numbers in dataset
CONSTRAINT PK_CUSTOMER PRIMARY KEY (CustomerID)
)

CREATE TABLE Regions
(
RegionID INT IDENTITY(1,1),
RegionName VARCHAR(255),
CONSTRAINT PK_REGION PRIMARY KEY (RegionID)
)

CREATE TABLE Dealers
(
DealerID INT IDENTITY(1,1),
DealerName VARCHAR(255),
DealerNo VARCHAR(255), -- Kept as VARCHAR to match the dataset format
CONSTRAINT PK_DEALER PRIMARY KEY (DealerID)
)

CREATE TABLE Companies
(
CompanyID INT IDENTITY(1,1),
CompanyName VARCHAR(255),
CONSTRAINT PK_COMPANY PRIMARY KEY (CompanyID)
)

CREATE TABLE Models
(
ModelID INT IDENTITY(1,1),
ModelName VARCHAR(255),
CONSTRAINT PK_MODEL PRIMARY KEY (ModelID)
)

CREATE TABLE [Body Styles]
(
BodyStyleID INT IDENTITY(1,1),
BodyStyleName VARCHAR(255),
CONSTRAINT PK_BODYSTYLE PRIMARY KEY (BodyStyleID)
)

CREATE TABLE Cars
(
CarID VARCHAR(255),
CompanyID INT,
ModelID INT,
BodyStyleID INT,
Color VARCHAR(255), -- Stored directly (few variations in the dataset)
Engine VARCHAR(255), -- Stored directly (few variations in the dataset)
Transmission VARCHAR(255), -- Stored directly (few variations in the dataset)
CONSTRAINT PK_CAR PRIMARY KEY (CarID),
CONSTRAINT FK_COMPANY FOREIGN KEY (CompanyID) REFERENCES Companies (CompanyID),
CONSTRAINT FK_MODEL FOREIGN KEY (ModelID) REFERENCES Models (ModelID),
CONSTRAINT FK_BODYSTYLE FOREIGN KEY (BodyStyleID) REFERENCES [Body Styles] (BodyStyleID)
)

CREATE TABLE Sales
(
SaleID INT IDENTITY(1,1),
SaleDate DATETIME,
CustomerID INT,
DealerID INT,
RegionID INT,
CarID VARCHAR(255),
Price FLOAT, -- Stored in FLOAT to support decimal values
Phone VARCHAR(255), -- Phone is stored here because it is associated with the sale transaction in the dataset
CONSTRAINT PK_SALE PRIMARY KEY (SaleID),
CONSTRAINT FK_CUSTOMER FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID),
CONSTRAINT FK_DEALER FOREIGN KEY (DealerID) REFERENCES Dealers (DealerID),
CONSTRAINT FK_REGION FOREIGN KEY (RegionID) REFERENCES Regions (RegionID),
CONSTRAINT FK_CAR FOREIGN KEY (CarID) REFERENCES Cars (CarID)
)

--4) Adding data to the tables from car_sales_data

-- Customers: Inserted from dataset (names may repeat, but each row represents a unique customer in this dataset)
INSERT INTO Customers(CustomerName,Gender,AnnualIncome)
SELECT Customer_Name,Gender,Annual_Income
FROM car_sales_data

-- Regions: Using DISTINCT to build a clean list of Regions
INSERT INTO Regions(RegionName)
SELECT DISTINCT Dealer_Region
FROM car_sales_data

-- Dealers: Using DISTINCT to build a clean list of Dealers
INSERT INTO Dealers(DealerName,DealerNo)
SELECT DISTINCT Dealer_Name,Dealer_No
FROM car_sales_data

-- Companies: Using DISTINCT to build a clean list of Companies
INSERT INTO Companies(CompanyName)
SELECT DISTINCT Company
FROM car_sales_data

-- Models: Using DISTINCT to build a clean list of Models
INSERT INTO Models(ModelName)
SELECT DISTINCT model
FROM car_sales_data

-- Body Styles: Using DISTINCT to build a clean list of Body Styles
INSERT INTO [Body Styles](BodyStyleName)
SELECT DISTINCT Body_Style
FROM car_sales_data

-- Cars: Resolving foreign keys by using JOIN
INSERT INTO Cars(CarID,CompanyID,ModelID,BodyStyleID,Color,Engine,Transmission)
SELECT DISTINCT D.Car_id,C.CompanyID,M.ModelID,BS.BodyStyleID,D.Color,D.Engine,D.Transmission
FROM car_sales_data D JOIN Companies C
ON C.CompanyName = D.Company
JOIN Models M
ON M.ModelName = D.Model
JOIN [Body Styles] BS
ON BS.BodyStyleName = D.Body_Style

-- Sales: Inserting transactions and resolving foreign keys using JOINs
-- I used multiple matching conditions with AND in the Customers/Dealers JOINs because names and sometimes dealer names, can repeat in the dataset.
-- Without it, it creates duplicates.
INSERT INTO Sales(SaleDate,CustomerID,DealerID,RegionID,CarID,Price,Phone)
SELECT D.Date,CU.CustomerID,DE.DealerID,R.RegionID,D.Car_id,D.Price,D.Phone
FROM car_sales_data D JOIN Customers CU
ON CU.CustomerName = D.Customer_Name
AND CU.Gender = D.Gender
AND CU.AnnualIncome = D.Annual_Income
JOIN Dealers DE
ON DE.DealerName = D.Dealer_Name
AND DE.DealerNo = D.Dealer_NO
JOIN Regions R
ON R.RegionName = D.Dealer_Region