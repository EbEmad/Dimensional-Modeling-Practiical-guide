
## Degenerate Dimension – Summary

- A **Degenerate Dimension (DD)** is a **dimension attribute** that:
  - Exists **within the fact table**
  - Has **no separate dimension table**
- It is used for **reporting**, **filtering**, or **grouping**
- Typical examples: **Order numbers**, **Invoice IDs**, **Transaction numbers**
- These values lack additional descriptive data, so there's **no need to normalize** them into a dimension table


###  Fact Table: Sales (with Degenerate Dimension - `OrderNumber`)

| SalesID | OrderNumber | ProductID | CustomerID | SalesAmount | SalesDate   |
|---------|-------------|-----------|------------|-------------|-------------|
| 1       | 123         | 5445      | 9009       | 900.00      | 2024-08-17  |
| 2       | 123         | 5445      | 9010       | 500.00      | 2024-08-17  |
| 3       | 124         | 5888      | 9009       | 250.00      | 2024-08-18  |
| 4       | 125         | 5445      | 9011       | 700.00      | 2024-08-19  |
| 5       | 126         | 5445      | 9012       | 1200.00     | 2024-08-20  |
         
                            
                                +------------------+
                                |  Dim_Customer    |
                                +------------------+
                                        ▲
                                        |
                                +-------------+
                                |  Fact Table  |
                                | Sales_Fact   |
                                +-------------+
                                | SalesID      | 
                                | OrderNumber  |  <-- Degenerate Dimension
                                | ProductID    |
                                | CustomerID   |
                                | SalesAmount  |
                                | SalesDate    |
                                +-------------+
                                        ▲
                                        |
                                +----------------+
                                |  Dim_Product   |
                                +----------------+

