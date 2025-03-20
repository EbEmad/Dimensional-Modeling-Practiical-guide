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

