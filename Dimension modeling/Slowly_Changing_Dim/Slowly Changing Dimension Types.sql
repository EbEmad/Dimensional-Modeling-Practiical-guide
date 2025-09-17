-- Active: 1758037311124@@127.0.0.1@5432@mydb
CREATE TABLE Stg_Customer ( -- The incomming table from source system
    CustomerID INT PRIMARY KEY,         -- business key, unique per customer
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL
);

-- Insert initial customer records [Assuming these are the initial records from source system]
-- ⚠️ You will need to insert this initial data before trying and testing any SCD ⚠️
TRUNCATE TABLE Stg_Customer;
INSERT INTO Stg_Customer (CustomerID, CustomerName, City, State, Country)
VALUES 
    (1, 'John Doe', 'New York', 'NY', 'USA'),
    (2, 'Jane Smith', 'Los Angeles', 'CA', 'USA'),
    (3, 'Alice Johnson', 'Chicago', 'IL', 'USA'),
    (4, 'Bob Brown', 'Houston', 'TX', 'USA'),
    (5, 'Emily Davis', 'Phoenix', 'AZ', 'USA');

-- In this file we will see different types of Slowly Changing Dimension (SCD)
-- And try to show how they are populated using ETL practices

-- SCHEMA FOR SCD1
CREATE TABLE Customer_DimensionSCD1 (    -- Slowly Changing Dimension Type 1
    CustomerID INT PRIMARY KEY,          -- Unique identifier for the customer
    CustomerName VARCHAR(255),           -- Name of the customer
    City VARCHAR(255),                   -- Current city of the customer
    State VARCHAR(255),                  -- Current state of the customer
    Country VARCHAR(255)                 -- Current country of the customer
);

-- SCD1 OVERWRITE The old value
-- ETL Practice for SCD1:

TRUNCATE TABLE Customer_DimensionSCD1; -- Clear existing data
INSERT INTO Customer_DimensionSCD1 -- Overwriting all changes
SELECT * FROM Stg_Customer;

SELECT * from Customer_DimensionSCD1 where CustomerID = 1;



--SCHEMA FOR SCD2
CREATE TABLE Customer_DimensionSCD2 (       -- Slowly Changing Dimension Type 2    
    CustomerSurrogateID SERIAL PRIMARY KEY,
    CustomerID INT, 
    CustomerName VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255),
    StartDate DATE, -- When this record became active
    EndDate DATE, -- When this record was superseded
    IsCurrent CHAR(1)
);
-- ETL Practice for SCD2:

-- Step 1
-- Updates to mark old records as historical(Inactive) [Does nothing for the first run]
UPDATE Customer_DimensionSCD2 scd
SET endDate = NOW(), isCurrent = 'N' -- When changes caught make current record inactive 
FROM 
    -- using stagging table (Source) with dimension table to get active record (isCurrent = 'Y') and detect changes 
     Stg_Customer stg
WHERE 
    scd.customerID = stg.customerID
    AND scd.isCurrent = 'Y' 
    AND( -- Detecting Changes
        scd.CustomerName <> stg.CustomerName
        OR scd.City <> stg.City
        OR scd.State <> stg.State
        OR scd.Country <> stg.Country
    )

-- Step 2
-- Inserting new records for new or changed customers
INSERT INTO Customer_DimensionSCD2 (CustomerID, CustomerName, City, State, Country, StartDate, EndDate, IsCurrent)
SELECT
    stg.CustomerID,
    stg.CustomerName,
    stg.City,
    stg.State,
    stg.Country,
    NOW() AS StartDate, -- Current date as start date
    NULL AS EndDate, -- No end date for current record
    'Y' AS IsCurrent -- Marking this as the current record
FROM 
    Stg_Customer stg LEFT JOIN Customer_DimensionSCD2 scd -- Left join in case new customers inserted
    ON stg.customerID = scd.customerID AND scd.isCurrent = 'Y'
WHERE 
    scd.customerID IS NULL -- new customer or changed (As we converted all changed records to 'N' so no join happens)  

-- Note📝:
-- We can have used Triggers to handle some types of SCDs but its not a good practice 
-- it's recommended to handle is via ETL processes for better control and auditing

-- Query to see effect of SCD2
SELECT * FROM Customer_DimensionSCD2
ORDER BY CustomerID;

SELECT * FROM Stg_Customer;

-- Insert the new records [you can use Insert or Update]
Truncate table Stg_Customer;
INSERT INTO Stg_Customer
VALUES
    (1, 'John Doe', 'Las Vegas', 'NV', 'USA'),
    (2, 'Jane Smith', 'Arlington', 'DC', 'USA'),
    (6, 'New Customer', 'New York', 'NY', 'USA')

-- Repeat the Step 1 and Step 2 again 

-- Query to see all versions of CustomerID 1
SELECT * FROM Customer_DimensionSCD2 WHERE CustomerID = 1;



-- SCHEMA FOR SCD3 - Adding a new column

CREATE TABLE Customer_DimensionSCD3 (
    CustomerSurrogateID SERIAL PRIMARY KEY, -- Surrogate key
    CustomerID INT,                        -- Business key
    CustomerName VARCHAR(255),             -- Name of the customer
    City VARCHAR(255),                     -- Current city of the customer
    State VARCHAR(255),                    -- Current state of the customer
    Country VARCHAR(255),                  -- Current country of the customer
    PreviousCity VARCHAR(255)              -- Previous city for limited history
);

-- ETL Practice for SCD3:

-- Step 1
-- Update city and shift the current city to PreviousCity
UPDATE Customer_DimensionSCD3 scd
SET PreviousCity = scd.City, -- Store the old value
    City = stg.City -- Update the current city
FROM Stg_Customer stg
WHERE 
    stg.CustomerID = scd.CustomerID
    AND stg.City <> scd.City;

-- Step 2
-- Insert new customers if any
INSERT INTO Customer_DimensionSCD3 (customerID, CustomerName, City, State, Country, PreviousCity)
SELECT 
    stg.CustomerID, stg.CustomerName, stg.City, stg.State, stg.Country, NULL
FROM 
    Stg_Customer stg LEFT JOIN Customer_DimensionSCD3 scd
    ON stg.customerID = scd.customerID
WHERE 
    scd.customerID IS NULL; -- New customer insertion

-- Query to see the the staging table and dimension
SELECT * FROM Stg_Customer;
SELECT * FROM Customer_DimensionSCD3;

-- Now lets change some cities and add a new customer
TRUNCATE TABLE Stg_Customer ;
INSERT INTO Stg_Customer -- You could use UPDATE or INSERT we are just testing here
VALUES 
    (1, 'John Doe', 'Boston', 'NY', 'USA'),
    (2, 'Jane Smith', 'San Francisco', 'CA', 'USA'),
    (3, 'Alice Johnson', 'Seattle', 'IL', 'USA'),
    (4, 'Bob Brown', 'Dallas', 'TX', 'USA'),
    (5, 'Emily Davis', 'Denver', 'AZ', 'USA'),
    (6, 'New Customer', 'New York', 'NY', 'USA');

-- Go repeat Step 1 and Step 2 then query the dimension to see the effect of SCD3


SELECT * FROM Customer_DimensionSCD3 WHERE CustomerID = 1;



-- SCHEMA FOR SCD4
-- Customer_DimensionSCD4 Table has current values in 
-- Customer_Historical_DimensionSCD4 Table has the old VALUES (History)

CREATE TABLE Customer_DimensionSCD4 (
    CustomerID INT PRIMARY KEY,                        -- The main Dim usually keeps the natural/business key
    CustomerName VARCHAR(255),             -- Name of the customer
    City VARCHAR(255),                     -- Current city of the customer
    State VARCHAR(255),                    -- Current state of the customer
    Country VARCHAR(255)                   -- Current country of the customer
);

CREATE TABLE Customer_Historical_DimensionSCD4 (
    HistoricalID SERIAL PRIMARY KEY,       -- Unique identifier for historical records [Surrogate key]
    CustomerID INT,                        -- Business key
    CustomerName VARCHAR(255),             -- Name of the customer
    City VARCHAR(255),                     -- Previous city
    State VARCHAR(255),                    -- Previous state
    Country VARCHAR(255),                  -- Previous country
    ChangeDate DATE                        -- Date of change
);

SELECT * FROM Stg_Customer;

-- ETL Practice for SCD4:

-- Step 1
-- If changes is comming from source (Stg_Customer) load the old values from Customer_Dimension
-- to Customer_Historical_DimensionSCD4 table first
INSERT INTO Customer_Historical_DimensionSCD4 (CustomerID, CustomerName, City, State, Country, ChangeDate)
SELECT
    scd.CustomerID,
    scd.CustomerName,
    scd.City,
    scd.State,
    scd.Country,
    NOW() AS ChangeDate
FROM 
    Customer_DimensionSCD4 scd JOIN Stg_Customer stg
    ON scd.CustomerID = stg.CustomerID
WHERE -- Detecting Changes
    scd.City <> stg.City
    OR scd.State <> stg.State
    OR scd.Country <> stg.Country;


-- Step 2
-- Then insert or update the new or changed records to Customer_DimensionSCD4 table 
-- This technique is called "Upsert" (Update + Insert) very common in ETL Processes
INSERT INTO Customer_DimensionSCD4
SELECT
    stg.CustomerID,
    stg.CustomerName,
    stg.City,
    stg.State,
    stg.Country
FROM 
    Stg_Customer stg LEFT JOIN Customer_DimensionSCD4 scd
    ON stg.customerID = scd.customerID
WHERE 
    scd.customerID IS NULL -- new customer
    OR scd.City <> stg.City
    OR scd.State <> stg.State
    OR scd.Country <> stg.Country
ON CONFLICT (CustomerID) 
DO UPDATE SET
    CustomerName = EXCLUDED.CustomerName,
    City = EXCLUDED.City,
    State = EXCLUDED.State,
    Country = EXCLUDED.Country;


-- Query to see the current records
SELECT * FROM Stg_Customer;
SELECT * FROM Customer_DimensionSCD4;
SELECT * FROM Customer_Historical_DimensionSCD4;


-- Now lets change some cities and add a new customer
TRUNCATE TABLE Stg_Customer ;
INSERT INTO Stg_Customer -- You could use UPDATE or INSERT we are just testing here
VALUES 
    (1, 'John Doe', 'Boston', 'NY', 'USA'),
    (2, 'Jane Smith', 'San Francisco', 'CA', 'USA'),
    (3, 'Alice Johnson', 'Seattle', 'IL', 'USA'),
    (4, 'Bob Brown', 'Dallas', 'TX', 'USA'),
    (5, 'Emily Davis', 'Denver', 'AZ', 'USA'),
    (6, 'New Customer', 'New York', 'NY', 'USA');

-- Go repeat Step 1 and Step 2 then query to see the records of Dimension and History

-- Query to see historical records
SELECT * FROM Customer_Historical_DimensionSCD4 WHERE CustomerID = 1;