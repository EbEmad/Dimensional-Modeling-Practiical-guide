--Conformed Dimension
  --A Conformed Dimension is a dimension that is shared across multiple fact tables.

CREATE TABLE Date_Dimension (
    DateID INT PRIMARY KEY,
    FullDate DATE,
    Day INT,
    Month INT,
    Year INT
);

-- Used in multiple fact tables
CREATE TABLE Sales_Fact (
    SalesID INT PRIMARY KEY,
    DateID INT,
    SalesAmount DECIMAL(10, 2),
    FOREIGN KEY (DateID) REFERENCES Date_Dimension(DateID)
);

CREATE TABLE Inventory_Fact (
    InventoryID INT PRIMARY KEY,
    DateID INT,
    Quantity INT,
    FOREIGN KEY (DateID) REFERENCES Date_Dimension(DateID)
);



