-- 1. Full Base Dimension (Detailed Grain)
CREATE TABLE Dim_Store (
    Store_Key SERIAL PRIMARY KEY,
    Store_Name VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(50),
    Region VARCHAR(50),
    Manager_Name VARCHAR(100)
);

-- 2. Atomic Fact Table (Detailed Sales)
CREATE TABLE Fact_Sales_Atomic (
    Sale_ID SERIAL PRIMARY KEY,
    Store_Key INT REFERENCES Dim_Store(Store_Key),
    Sale_Date DATE,
    Amount DECIMAL(12, 2)
);

-- 3. Shrunken Dimension (Rollup Grain)
-- This can be a physical table for performance
CREATE TABLE Dim_Store_Region (
    State VARCHAR(50),
    Region VARCHAR(50),
    PRIMARY KEY (State, Region)
);

-- 4. Aggregated Fact Table (Monthly Regional Summary)
CREATE TABLE Fact_Sales_Regional_Monthly (
    State VARCHAR(50),
    Region VARCHAR(50),
    Month_Key CHAR(7), -- e.g., '2024-01'
    Total_Amount DECIMAL(15, 2),
    PRIMARY KEY (State, Region, Month_Key)
);

-- 5. Populating Sample Data
INSERT INTO Dim_Store (Store_Name, City, State, Region, Manager_Name) VALUES
('Central Outlet', 'Boston', 'MA', 'East', 'Alice Johnson'),
('North Hub', 'Cambridge', 'MA', 'East', 'Charlie Brown'),
('Urban Depot', 'San Diego', 'CA', 'West', 'John Doe');

INSERT INTO Fact_Sales_Atomic (Store_Key, Sale_Date, Amount) VALUES
(1, '2024-01-02', 1200.00),
(2, '2024-01-03', 800.00),
(3, '2024-01-02', 950.00);

-- 6. Populating the Shrunken Dimension from the Base Table
INSERT INTO Dim_Store_Region (State, Region)
SELECT DISTINCT State, Region 
FROM Dim_Store;

-- 7. Populating the Aggregated Fact (ETL/Drill-Up Process)
INSERT INTO Fact_Sales_Regional_Monthly (State, Region, Month_Key, Total_Amount)
SELECT 
    d.State,
    d.Region,
    TO_CHAR(f.Sale_Date, 'YYYY-MM'),
    SUM(f.Amount)
FROM Fact_Sales_Atomic f
JOIN Dim_Store d ON f.Store_Key = d.Store_Key
GROUP BY d.State, d.Region, TO_CHAR(f.Sale_Date, 'YYYY-MM');

-- 8. Querying the Shrunken Path (Efficient for Summaries)
SELECT 
    r.Region,
    r.State,
    f.Total_Amount
FROM Fact_Sales_Regional_Monthly f
JOIN Dim_Store_Region r ON f.State = r.State AND f.Region = r.Region
WHERE f.Month_Key = '2024-01';

