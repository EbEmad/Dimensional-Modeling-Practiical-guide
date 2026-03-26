-- 1. Date Dimension (The "Actor")
CREATE TABLE Dim_Date (
    Date_Key INT PRIMARY KEY, -- YYYYMMDD
    Full_Date DATE,
    Day_Name VARCHAR(10),
    Month_Name VARCHAR(10),
    Year INT,
    Is_Holiday BOOLEAN
);

-- 2. Fact Table (The "Scene" where the actor plays different roles)
CREATE TABLE Fact_Sales (
    Sale_ID SERIAL PRIMARY KEY,
    Product_Name VARCHAR(100),
    Order_Date_Key INT REFERENCES Dim_Date(Date_Key), -- Role 1
    Ship_Date_Key INT REFERENCES Dim_Date(Date_Key),  -- Role 2
    Delivery_Date_Key INT REFERENCES Dim_Date(Date_Key), -- Role 3
    Amount DECIMAL(12, 2)
);

-- 3. Insert Sample Data
INSERT INTO Dim_Date VALUES 
(20240701, '2024-07-01', 'Monday', 'July', 2024, FALSE),
(20240703, '2024-07-03', 'Wednesday', 'July', 2024, FALSE),
(20240705, '2024-07-05', 'Friday', 'July', 2024, FALSE);

INSERT INTO Fact_Sales (Product_Name, Order_Date_Key, Ship_Date_Key, Delivery_Date_Key, Amount) VALUES 
('Laptop X1', 20240701, 20240703, 20240705, 1500.00);

-- 4. Querying multiple roles using Aliases
-- We join ONLY ONE physical table (Dim_Date) multiple times
SELECT 
    f.Sale_ID,
    f.Product_Name,
    ord.Full_Date AS Order_Date,
    shp.Full_Date AS Ship_Date,
    del.Full_Date AS Delivery_Date,
    -- Business Logic: Calculating Lead Time (in days)
    (shp.Full_Date - ord.Full_Date) AS Days_to_Ship,
    (del.Full_Date - shp.Full_Date) AS Days_in_Transit
FROM Fact_Sales f
JOIN Dim_Date ord ON f.Order_Date_Key = ord.Date_Key
JOIN Dim_Date shp ON f.Ship_Date_Key = shp.Date_Key
JOIN Dim_Date del ON f.Delivery_Date_Key = del.Date_Key;