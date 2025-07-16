-- Create the Date Dimension table
CREATE TABLE Dim_Date (
    Date_ID INT PRIMARY KEY,
    Date DATE NOT NULL,
    Month VARCHAR(3) NOT NULL
    -- (Additional date attributes like Year, Quarter, DayOfWeek could be added)
);

-- Create the Fact Orders table
CREATE TABLE Fact_Orders (
    Order_ID INT PRIMARY KEY,
    Order_Date_ID INT NOT NULL,
    Ship_Date_ID INT NOT NULL,
    Delivery_Date_ID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (Order_Date_ID) REFERENCES Dim_Date(Date_ID),
    FOREIGN KEY (Ship_Date_ID) REFERENCES Dim_Date(Date_ID),
    FOREIGN KEY (Delivery_Date_ID) REFERENCES Dim_Date(Date_ID)
);

-- Insert sample data into Dim_Date
INSERT INTO Dim_Date (Date_ID, Date, Month) VALUES
(101, '2024-01-01', 'Jan'),
(102, '2024-01-15', 'Jan'),
(103, '2024-02-01', 'Feb'),
(104, '2024-02-03', 'Feb'),
(105, '2024-02-05', 'Feb'),
(106, '2024-03-01', 'Mar');

-- Insert sample data into Fact_Orders
INSERT INTO Fact_Orders (Order_ID, Order_Date_ID, Ship_Date_ID, Delivery_Date_ID, Amount) VALUES
(1, 101, 103, 105, 500.00),
(2, 102, 104, 106, 700.00);

-- Query demonstrating swappable dimension
SELECT
    o.Order_ID,
    od.Date AS Order_Date,
    od.Month AS Order_Month,
    sd.Date AS Ship_Date,
    sd.Month AS Ship_Month,
    dd.Date AS Delivery_Date,
    dd.Month AS Delivery_Month,
    o.Amount,
    -- Calculate days between order and ship
    DATEDIFF(day, od.Date, sd.Date) AS Days_To_Ship,
    -- Calculate days between ship and delivery
    DATEDIFF(day, sd.Date, dd.Date) AS Shipping_Duration
FROM 
    Fact_Orders o
JOIN 
    Dim_Date od ON o.Order_Date_ID = od.Date_ID
JOIN 
    Dim_Date sd ON o.Ship_Date_ID = sd.Date_ID
JOIN 
    Dim_Date dd ON o.Delivery_Date_ID = dd.Date_ID;