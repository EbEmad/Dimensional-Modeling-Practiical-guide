CREATE TABLE Customer_DimensionSCD1 (
    CustomerID INT PRIMARY KEY,          -- Unique identifier for the customer
    CustomerName VARCHAR(255),           -- Name of the customer
    City VARCHAR(255),                   -- Current city of the customer
    State VARCHAR(255),                  -- Current state of the customer
    Country VARCHAR(255)            -- Current country of the customer
    -- Indicates if this is the current record (Y/N)
);


-- Insert initial customer records

INSERT INTO Customer_DimensionSCD1 (CustomerID, CustomerName, City, State, Country)
VALUES 
(1, 'John Doe', 'New York', 'NY', 'USA'),

(2, 'Jane Smith', 'Los Angeles', 'CA', 'USA'),

(3, 'Alice Johnson', 'Chicago', 'IL', 'USA'),

(4, 'Bob Brown', 'Houston', 'TX', 'USA'),

(5, 'Emily Davis', 'Phoenix', 'AZ', 'USA');


--SCD1 OVERWRITE The old value

UPDATE Customer_DimensionSCD1
SET City = 'DC'
WHERE CustomerID = 1;

SELECT * from Customer_DimensionSCD1 where CustomerID = 1;


--SCD2 - Adding a new row 


--SCHEMA FOR SCD2
CREATE TABLE Customer_DimensionSCD2 (
    CustomerSurrogateID SERIAL PRIMARY KEY,
    CustomerID INT, 
    CustomerName VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    IsCurrent CHAR(1)
);



-- Insert the new record with updated values
INSERT INTO Customer_DimensionSCD2 (CustomerID, CustomerName, City, State, Country, StartDate, EndDate, IsCurrent)
VALUES 
(1, 'John Doe', 'New York', 'NY', 'USA', '2023-01-01', NULL, 'Y');

-- Mark the old record as historical
UPDATE Customer_DimensionSCD2
SET EndDate = '2024-08-16', IsCurrent = 'N'
WHERE CustomerID = 1 AND IsCurrent = 'Y';

-- Insert the new record with updated values
INSERT INTO Customer_DimensionSCD2 (CustomerID, CustomerName, City, State, Country, StartDate, EndDate, IsCurrent)
VALUES (1, 'John Doe', 'California', 'LA', 'USA', '2024-08-17', NULL, 'Y');


-- Query to see all versions of CustomerID 1
SELECT * FROM Customer_DimensionSCD2 WHERE CustomerID = 1;




-- SCD3 - Adding a new column

CREATE TABLE Customer_DimensionSCD3 (
    CustomerSurrogateID SERIAL PRIMARY KEY, -- Surrogate key
    CustomerID INT,                        -- Business key
    CustomerName VARCHAR(255),             -- Name of the customer
    City VARCHAR(255),                     -- Current city of the customer
    State VARCHAR(255),                    -- Current state of the customer
    Country VARCHAR(255),                  -- Current country of the customer
    PreviousCity VARCHAR(255)              -- Previous city for limited history
);


-- Insert initial record
INSERT INTO Customer_DimensionSCD3 (CustomerID, CustomerName, City, State, Country, PreviousCity)
VALUES 
(1, 'John Doe', 'New York', 'NY', 'USA', NULL);


-- Query to see the updated record


-- Update city and shift the current city to PreviousCity
UPDATE Customer_DimensionSCD3
SET PreviousCity = City, -- Store the old value
    City = 'San Francisco' -- Update the current city
WHERE CustomerID = 1;


SELECT * FROM Customer_DimensionSCD3 WHERE CustomerID = 1;




--SCD 4 - Historical Table has the old VALUES & and the current value in the main Customer_DimensionSCD3

CREATE TABLE Customer_DimensionSCD4 (
    CustomerSurrogateID SERIAL PRIMARY KEY, -- Surrogate key
    CustomerID INT,                        -- Business key
    CustomerName VARCHAR(255),             -- Name of the customer
    City VARCHAR(255),                     -- Current city of the customer
    State VARCHAR(255),                    -- Current state of the customer
    Country VARCHAR(255)                   -- Current country of the customer
);

CREATE TABLE Customer_Historical_DimensionSCD4 (
    HistoricalID SERIAL PRIMARY KEY,       -- Unique identifier for historical records
    CustomerID INT,                        -- Business key
    CustomerName VARCHAR(255),             -- Name of the customer
    City VARCHAR(255),                     -- Previous city
    State VARCHAR(255),                    -- Previous state
    Country VARCHAR(255),                  -- Previous country
    ChangeDate DATE                        -- Date of change
);

-- Insert current record into the main table
INSERT INTO Customer_DimensionSCD4 (CustomerID, CustomerName, City, State, Country)
VALUES 
(1, 'John Doe', 'New York', 'NY', 'USA');

-- Insert historical record into the historical table
INSERT INTO Customer_Historical_DimensionSCD4 (CustomerID, CustomerName, City, State, Country, ChangeDate)
VALUES 
(1, 'John Doe', 'Los Angeles', 'CA', 'USA', '2024-08-17');


-- Query to see the current records
SELECT * FROM Customer_DimensionSCD4;

-- Query to see historical records
SELECT * FROM Customer_Historical_DimensionSCD4 WHERE CustomerID = 1;

