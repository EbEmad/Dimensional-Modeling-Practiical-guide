-- 1. Regular Dimensions
CREATE TABLE Dim_Customer (
    Customer_Key INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE Dim_Product (
    Product_Key INT PRIMARY KEY,
    Product_Name VARCHAR(100),
    Category VARCHAR(50)
);

CREATE TABLE Dim_Date (
    Date_Key INT PRIMARY KEY,
    Full_Date DATE
);

-- 2. Fact Table with Degenerate Dimension
-- Order_Number is the Degenerate Dimension (stored directly in the fact)
CREATE TABLE Fact_Sales (
    Sale_ID SERIAL PRIMARY KEY,
    Order_Number VARCHAR(20), -- Degenerate Dimension
    Customer_Key INT REFERENCES Dim_Customer(Customer_Key),
    Product_Key INT REFERENCES Dim_Product(Product_Key),
    Date_Key INT REFERENCES Dim_Date(Date_Key),
    Total_Amount DECIMAL(12, 2)
);

-- 3. Insert Sample Data
INSERT INTO Dim_Customer VALUES (1, 'John Doe', 'john@example.com');
INSERT INTO Dim_Product VALUES (10, 'Laptop X', 'Electronics'), (20, 'Mouse Y', 'Electronics');
INSERT INTO Dim_Date VALUES (20230701, '2023-07-01');

-- Note: Multiple rows in the fact table can share the same Order_Number
INSERT INTO Fact_Sales (Order_Number, Customer_Key, Product_Key, Date_Key, Total_Amount) VALUES 
('ORD-1001', 1, 10, 20230701, 1200.00), -- Line item 1 of order 1001
('ORD-1001', 1, 20, 20230701, 50.00),   -- Line item 2 of order 1001
('ORD-1002', 1, 10, 20230701, 1200.00); -- New order 1002

-- 4. Practical Queries using Degenerate Dimension

-- A. Grouping by Degenerate Dimension (Order Level analysis)
SELECT 
    Order_Number, 
    COUNT(Product_Key) as Item_Count,
    SUM(Total_Amount) as Order_Total
FROM Fact_Sales
GROUP BY Order_Number;

-- B. Combining Regular and Degenerate Dimensions
-- Show customer info along with their specific orders
SELECT 
    c.Customer_Name,
    f.Order_Number,
    SUM(f.Total_Amount) as Order_Value
FROM Fact_Sales f
JOIN Dim_Customer c ON f.Customer_Key = c.Customer_Key
GROUP BY c.Customer_Name, f.Order_Number
ORDER BY c.Customer_Name;
