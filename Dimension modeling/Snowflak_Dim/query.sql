-- 1. Country Dimension (Top level)
CREATE TABLE Dim_Country (
    Country_Key SERIAL PRIMARY KEY,
    Country_Name VARCHAR(100) UNIQUE
);

-- 2. State Dimension (Mid level)
CREATE TABLE Dim_State (
    State_Key SERIAL PRIMARY KEY,
    State_Name VARCHAR(100),
    Country_Key INT REFERENCES Dim_Country(Country_Key)
);

-- 3. City Dimension (Low level)
CREATE TABLE Dim_City (
    City_Key SERIAL PRIMARY KEY,
    City_Name VARCHAR(100),
    State_Key INT REFERENCES Dim_State(State_Key)
);

-- 4. Date Dimension
CREATE TABLE Dim_Date (
    Date_Key INT PRIMARY KEY, -- YYYYMMDD
    Full_Date DATE
);

-- 5. Fact Table
CREATE TABLE Fact_Sales (
    Sale_ID SERIAL PRIMARY KEY,
    City_Key INT REFERENCES Dim_City(City_Key),
    Date_Key INT REFERENCES Dim_Date(Date_Key),
    Amount DECIMAL(12, 2)
);

-- 6. Insert Sample Data
INSERT INTO Dim_Country (Country_Name) VALUES ('USA'), ('Canada');

INSERT INTO Dim_State (State_Name, Country_Key) VALUES 
('Texas', 1), ('California', 1), ('Ontario', 2);

INSERT INTO Dim_City (City_Name, State_Key) VALUES 
('Dallas', 1), ('Austin', 1), ('Los Angeles', 2), ('Toronto', 3);

INSERT INTO Dim_Date VALUES (20240701, '2024-07-01'), (20240702, '2024-07-02');

INSERT INTO Fact_Sales (City_Key, Date_Key, Amount) VALUES 
(1, 20240701, 500.00), -- Dallas
(2, 20240701, 300.00), -- Austin
(3, 20240702, 700.00), -- LA
(4, 20240702, 400.00); -- Toronto

-- 7. Hierarchical Query (Joining through the entire chain)
-- "Show me Sales by Country and State"
SELECT 
    co.Country_Name,
    s.State_Name,
    SUM(f.Amount) as Total_Sales,
    COUNT(f.Sale_ID) as Transaction_Count
FROM Fact_Sales f
JOIN Dim_City c ON f.City_Key = c.City_Key
JOIN Dim_State s ON c.State_Key = s.State_Key
JOIN Dim_Country co ON s.Country_Key = co.Country_Key
GROUP BY co.Country_Name, s.State_Name
ORDER BY Total_Sales DESC;
