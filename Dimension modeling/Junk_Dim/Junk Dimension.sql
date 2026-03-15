-- 1. Setup Standard Dimensions
CREATE TABLE Dim_Product (
    Product_Key SERIAL PRIMARY KEY,
    Product_Name VARCHAR(100)
);

CREATE TABLE Dim_Date (
    Date_Key INT PRIMARY KEY, -- YYYYMMDD
    Full_Date DATE
);

-- 2. Setup Junk Dimension
-- This will store all possible combinations of our small flags
CREATE TABLE Dim_Junk (
    Junk_Key SERIAL PRIMARY KEY,
    Is_Promo VARCHAR(3),      -- Yes/No
    Is_First_Order VARCHAR(3), -- Yes/No
    Order_Type VARCHAR(20)     -- Online/In-store/Phone
);

-- 3. GENERATING THE JUNK DIMENSION (Cartesian Product)
-- In a real ETL, you would cross-join all possible values
INSERT INTO Dim_Junk (Is_Promo, Is_First_Order, Order_Type)
SELECT p.val, f.val, t.val
FROM 
    (SELECT 'Yes' as val UNION SELECT 'No') p,
    (SELECT 'Yes' as val UNION SELECT 'No') f,
    (SELECT 'Online' as val UNION SELECT 'In-store' UNION SELECT 'Phone') t;

-- 4. Setup Fact Table
CREATE TABLE Fact_Sales (
    Sale_ID SERIAL PRIMARY KEY,
    Product_Key INT REFERENCES Dim_Product(Product_Key),
    Date_Key INT REFERENCES Dim_Date(Date_Key),
    Junk_Key INT REFERENCES Dim_Junk(Junk_Key),
    Amount DECIMAL(12, 2)
);

-- 5. Insert Sample Data
INSERT INTO Dim_Product (Product_Name) VALUES ('Laptop X1'), ('Phone Y2');
INSERT INTO Dim_Date VALUES (20230701, '2023-07-01');

-- To insert into fact, we find the correct Junk_Key
INSERT INTO Fact_Sales (Product_Key, Date_Key, Junk_Key, Amount)
SELECT 
    1, 
    20230701, 
    (SELECT Junk_Key FROM Dim_Junk WHERE Is_Promo = 'Yes' AND Is_First_Order = 'No' AND Order_Type = 'Online'),
    1500.00;

-- 6. Practical Query
-- "Show me total sales for Promotional Online orders vs Non-Promotional"
SELECT 
    j.Is_Promo,
    j.Order_Type,
    SUM(f.Amount) as Total_Sales,
    COUNT(*) as Transaction_Count
FROM Fact_Sales f
JOIN Dim_Junk j ON f.Junk_Key = j.Junk_Key
GROUP BY j.Is_Promo, j.Order_Type
ORDER BY Total_Sales DESC;

