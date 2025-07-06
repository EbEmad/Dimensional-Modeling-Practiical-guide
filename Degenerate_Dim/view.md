                                +------------------+
                                |  Dim_Customer    |
                                +------------------+
                                        ▲
                                        |
                                +-------------+
                                |  Fact Table  |
                                | Sales_Fact   |
                                +-------------+
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


##  Degenerate Dimension – Summary

- A **Degenerate Dimension (DD)** is a **dimension attribute** that:
  - Exists **within the fact table**
  - Has **no separate dimension table**
- It is used for **reporting**, **filtering**, or **grouping**
- Typical examples: **Order numbers**, **Invoice IDs**, **Transaction numbers**
- These values lack additional descriptive data, so there's **no need to normalize** them into a dimension table

