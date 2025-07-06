--Degenerate Dimension

  --A Degenerate Dimension is a dimension that does not have its own dimension table but exists in the fact table.
  
  -- Fact table with degenerate dimension
CREATE TABLE Sales_Fact (
    SalesID SERIAL PRIMARY KEY,
    OrderNumber VARCHAR(50), -- Degenerate Dimension
    ProductID INT,
    CustomerID INT,
    SalesAmount DECIMAL(10, 2),
    SalesDate DATE
);
INSERT INTO Sales_Fact (SalesID, OrderNumber,ProductID,CustomerID,SalesAmount,SalesDate)
VALUES (1,123,5445,9009,900,'2024-08-17'),
       (2,124,5446,9010,500,'2024-08-17'),
        (3,124,5447,9011,900,'2024-08-17');


-- Query that uses the degenerate dimension
SELECT OrderNumber, SUM(SalesAmount)
FROM Sales_Fact
GROUP BY OrderNumber;
