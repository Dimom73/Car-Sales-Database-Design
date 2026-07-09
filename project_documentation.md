# Project Documentation — Car Sales Database Design

## Overview

This project is based on a car sales dataset that combines vehicle sale transactions, customer information, dealer details, car specifications, and regional data in one flat structure.

The purpose of the project is to transform this flat dataset into a relational SQL Server database that supports cleaner data management and future analytical work.

## Dataset Description

Each row in the original dataset represents one completed car sale transaction.

The dataset includes information about:

- the car that was sold
- the customer who purchased the car
- the dealer involved in the sale
- the region where the sale took place
- the sale price and sale date

The original dataset contained 16 columns and 23,906 rows. For the public GitHub version, a 200-row anonymized sample is included.

## Dataset Columns

- `Car_id` — unique identifier for each car record
- `Date` — sale transaction date
- `Customer_Name` — anonymized customer identifier in the public sample
- `Gender` — customer gender
- `Annual_Income` — customer annual income
- `Dealer_Name` — dealer name
- `Dealer_No` — dealer number
- `Dealer_Region` — dealer region
- `Company` — car manufacturer or brand
- `Model` — car model
- `Body_Style` — car body style
- `Engine` — engine specification
- `Transmission` — transmission type
- `Color` — exterior car color
- `Price` — sale price
- `Phone` — anonymized phone identifier in the public sample

## Database Tables

### Customers

Stores customer-related information.

Columns:

- `CustomerID` — primary key
- `CustomerName`
- `Gender`
- `AnnualIncome`

### Regions

Stores dealer region information.

Columns:

- `RegionID` — primary key
- `RegionName`

### Dealers

Stores dealer information.

Columns:

- `DealerID` — primary key
- `DealerName`
- `DealerNo`

### Companies

Stores car company or manufacturer names.

Columns:

- `CompanyID` — primary key
- `CompanyName`

### Models

Stores car model names.

Columns:

- `ModelID` — primary key
- `ModelName`

### Body Styles

Stores car body style categories.

Columns:

- `BodyStyleID` — primary key
- `BodyStyleName`

### Cars

Stores car specifications and connects each car to company, model, and body style tables.

Columns:

- `CarID` — primary key
- `CompanyID` — foreign key
- `ModelID` — foreign key
- `BodyStyleID` — foreign key
- `Color`
- `Engine`
- `Transmission`

### Sales

Stores the actual sale transactions.

Columns:

- `SaleID` — primary key
- `SaleDate`
- `CustomerID` — foreign key
- `DealerID` — foreign key
- `RegionID` — foreign key
- `CarID` — foreign key
- `Price`
- `Phone`

## SQL Process

The project follows these main steps:

1. Create the SQL Server database.
2. Import the car sales dataset into a staging table.
3. Create relational tables.
4. Insert data into each table.
5. Resolve relationships using joins.
6. Create a database diagram.

## Design Decisions

- Repeated entities such as dealers, companies, models, regions, and body styles were separated into dedicated tables.
- `Customers` uses an identity-based primary key because customer names may repeat.
- `Sales` acts as the central transaction table and connects the main entities.
- Phone values are stored in the `Sales` table because they are treated as part of the sale transaction in the dataset.
- The public sample anonymizes customer names and phone values before publishing.

## Business Value

The relational structure makes the dataset easier to query, analyze, and maintain. It can support future work such as:

- sales analysis by region
- sales analysis by dealer
- sales analysis by car company or model
- customer income analysis
- Power BI dashboard creation
- Python exploratory data analysis

## Learning Outcome

This project helped practice SQL Server database design, table creation, primary and foreign keys, data loading, joins, documentation, and preparing a clean data structure for future analysis.
