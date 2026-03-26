-- 1. Secondary Dimension (Outrigger)
-- This stores details that are shared across multiple entries in the main dimension
CREATE TABLE Dim_Address (
    Address_Key SERIAL PRIMARY KEY,
    City VARCHAR(100),
    Country VARCHAR(100),
    Region VARCHAR(50)
);

-- 2. Main Dimension
-- This links to the outrigger table instead of storing city/country directly
CREATE TABLE Dim_Customer (
    Customer_Key SERIAL PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Address_Key INT REFERENCES Dim_Address(Address_Key) -- FK to Outrigger
);

-- 3. Fact Table
-- The fact table connects ONLY to the main dimension
CREATE TABLE Fact_Sales (
    Sale_ID SERIAL PRIMARY KEY,
    Customer_Key INT REFERENCES Dim_Customer(Customer_Key),
    Amount DECIMAL(12, 2)
);

-- 4. Sample Data
INSERT INTO Dim_Address (City, Country, Region) VALUES ('Cairo', 'Egypt', 'MENA');
INSERT INTO Dim_Customer (Customer_Name, Address_Key) VALUES ('John Smith', 1);
INSERT INTO Fact_Sales (Customer_Key, Amount) VALUES (1, 1500.00);

-- 5. Querying from Fact through to Outrigger
-- Note the TWO joins required to get the City
SELECT 
    f.Sale_ID,
    c.Customer_Name,
    a.City,
    a.Country,
    f.Amount
FROM Fact_Sales f
JOIN Dim_Customer c ON f.Customer_Key = c.Customer_Key
JOIN Dim_Address a ON c.Address_Key = a.Address_Key
WHERE a.Country = 'Egypt';
