-- Conformed Dimension: Dim_Date
CREATE TABLE Dim_Date (
    Date_Key INT PRIMARY KEY, -- Format: YYYYMMDD
    Full_Date DATE,
    Day_Of_Week VARCHAR(10),
    Month_Name VARCHAR(10),
    Quarter INT,
    Year INT
);

-- Conformed Dimension: Dim_Product
CREATE TABLE Dim_Product (
    Product_Key INT PRIMARY KEY,
    SKU VARCHAR(20),
    Product_Name VARCHAR(100),
    Category VARCHAR(50)
);

-- Conformed Dimension: Dim_Store
CREATE TABLE Dim_Store (
    Store_Key INT PRIMARY KEY,
    Store_Name VARCHAR(100),
    City VARCHAR(50),
    Region VARCHAR(50)
);

-- Fact Table 1: Sales (Business Process: Retail Sales)
CREATE TABLE Fact_Sales (
    Sale_ID SERIAL PRIMARY KEY,
    Date_Key INT REFERENCES Dim_Date(Date_Key),
    Product_Key INT REFERENCES Dim_Product(Product_Key),
    Store_Key INT REFERENCES Dim_Store(Store_Key),
    Quantity_Sold INT,
    Sales_Amount DECIMAL(12, 2)
);

-- Fact Table 2: Inventory (Business Process: Warehouse Management)
-- Note: This shares Date, Product, and Store with Fact_Sales
CREATE TABLE Fact_Inventory (
    Inventory_ID SERIAL PRIMARY KEY,
    Date_Key INT REFERENCES Dim_Date(Date_Key),
    Product_Key INT REFERENCES Dim_Product(Product_Key),
    Store_Key INT REFERENCES Dim_Store(Store_Key),
    Quantity_On_Hand INT
);

-- 1. Insert Data into Conformed Dimensions
INSERT INTO Dim_Product (Product_Key, SKU, Product_Name, Category) VALUES
(1, 'LPT-X1', 'Laptop X1', 'Electronics'),
(2, 'PHN-Y2', 'Phone Y2', 'Electronics');

INSERT INTO Dim_Date (Date_Key, Full_Date, Day_Of_Week, Month_Name, Quarter, Year) VALUES
(20230701, '2023-07-01', 'Saturday', 'July', 3, 2023),
(20230702, '2023-07-02', 'Sunday', 'July', 3, 2023);

INSERT INTO Dim_Store (Store_Key, Store_Name, City, Region) VALUES
(10, 'Main Street Store', 'New York', 'North');

-- 2. Insert Data into Fact Tables
INSERT INTO Fact_Sales (Date_Key, Product_Key, Store_Key, Quantity_Sold, Sales_Amount) VALUES
(20230701, 1, 10, 5, 5000.00),
(20230701, 2, 10, 10, 8000.00);

INSERT INTO Fact_Inventory (Date_Key, Product_Key, Store_Key, Quantity_On_Hand) VALUES
(20230701, 1, 10, 2), -- Sold 5 but only 2 left? Warning!
(20230701, 2, 10, 50);

-- 3. DRILL-ACROSS QUERY
-- Comparing Sales vs Inventory using Conformed Dimensions
-- We use a Common Table Expression (CTE) to aggregate facts before joining
WITH Sales_Agg AS (
    SELECT 
        Product_Key, 
        Date_Key, 
        SUM(Quantity_Sold) as Total_Sold
    FROM Fact_Sales
    GROUP BY Product_Key, Date_Key
),
Inventory_Agg AS (
    SELECT 
        Product_Key, 
        Date_Key, 
        SUM(Quantity_On_Hand) as Stock_Level
    FROM Fact_Inventory
    GROUP BY Product_Key, Date_Key
)
SELECT 
    p.Product_Name,
    d.Full_Date,
    COALESCE(s.Total_Sold, 0) as Sold,
    COALESCE(i.Stock_Level, 0) as On_Hand,
    CASE 
        WHEN i.Stock_Level < s.Total_Sold THEN 'CRITICAL: Low Stock'
        WHEN i.Stock_Level < s.Total_Sold * 2 THEN 'Warning: Restock Soon'
        ELSE 'Healthy'
    END as Inventory_Status
FROM Dim_Product p
JOIN Dim_Date d ON 1=1 -- Typical for cross-join reports or use specific dates
LEFT JOIN Sales_Agg s ON p.Product_Key = s.Product_Key AND d.Date_Key = s.Date_Key
LEFT JOIN Inventory_Agg i ON p.Product_Key = i.Product_Key AND d.Date_Key = i.Date_Key
WHERE s.Total_Sold IS NOT NULL OR i.Stock_Level IS NOT NULL
ORDER BY d.Full_Date;
