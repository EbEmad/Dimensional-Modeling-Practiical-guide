
--Outrigger Dimension
  --An Outrigger Dimension is a dimension table that is linked to another dimension table.


CREATE TABLE Location_Dimension (
    LocationID INT PRIMARY KEY,
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255)
);

CREATE TABLE Customer_Dimension (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    LocationID INT,
    FOREIGN KEY (LocationID) REFERENCES Location_Dimension(LocationID)
);
