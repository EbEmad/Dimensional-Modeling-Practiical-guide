--Role-Playing Dimension
  --A Role-Playing Dimension is a single dimension that can play multiple roles in the fact table.

CREATE TABLE Date_Dimension (
    DateID INT PRIMARY KEY,
    FullDate DATE,
    Day INT,
    Month INT,
    Year INT,
    Weekday VARCHAR(50)
);

-- Used in the fact table as different roles
CREATE TABLE Sales_Fact (
    SalesID INT PRIMARY KEY,
    OrderDateID INT,
    ShipDateID INT,
    DeliveryDateID INT,
    SalesAmount DECIMAL(10, 2),
    FOREIGN KEY (OrderDateID) REFERENCES Date_Dimension(DateID),
    FOREIGN KEY (ShipDateID) REFERENCES Date_Dimension(DateID),
    FOREIGN KEY (DeliveryDateID) REFERENCES Date_Dimension(DateID)
);

-- Insert data into Date_Dimension
INSERT INTO Date_Dimension (DateID, FullDate, Day, Month, Year, Weekday)
VALUES 
(1, '2024-07-01', 1, 7, 2024, 'Monday'),
(2, '2024-07-02', 2, 7, 2024, 'Tuesday'),
(3, '2024-07-03', 3, 7, 2024, 'Wednesday'),
(4, '2024-07-04', 4, 7, 2024, 'Thursday');

-- Insert data into Sales_Fact
INSERT INTO Sales_Fact (SalesID, OrderDateID, ShipDateID, DeliveryDateID, SalesAmount)
VALUES 
(101, 1, 2, 4, 250.00),
(102, 2, 3, 4, 400.00);


SELECT 
  SF.SalesID,
  OD.FullDate AS Order_Date,
  SD.FullDate AS Ship_Date,
  DD.FullDate AS Delivery_Date,
  SF.SalesAmount
FROM 
  Sales_Fact SF
JOIN Date_Dimension OD ON SF.OrderDateID = OD.DateID
JOIN Date_Dimension SD ON SF.ShipDateID = SD.DateID
JOIN Date_Dimension DD ON SF.DeliveryDateID = DD.DateID;