#  Role-Playing Dimension

##  What is a Role-Playing Dimension?

A **Role-Playing Dimension** is a **single dimension table** that is used multiple times in a fact table, each time with a **different role or meaning**.

>  Think of it like an actor who plays different characters in different scenes — it’s the **same actor (table)**, but performing **different roles**.

The most common example is a **Date Dimension**, which can be reused to represent:
- Order Date
- Ship Date
- Delivery Date

---

##  Why Use a Role-Playing Dimension?

Instead of creating separate tables for each date type (`Order_Date`, `Ship_Date`, etc.), we:
- Use one central `Date_Dimension` table.
- Join it multiple times using **aliases** to represent each role.

This approach:
-  Avoids duplication of data
-  Keeps the model clean and normalized
-  Makes maintenance easier

---


                          +---------------------+
                          |    Date_Dimension   |
                          +---------------------+
                          | DateID (PK)         |
                          | FullDate            |
                          | Day                 |
                          | Month               |
                          | Year                |
                          | Weekday             |
                          +---------------------+
                                ▲    ▲     ▲
                                |    |     |
                                |    |     |
              +---------------------------------------------+
              |                Sales_Fact                   |
              +---------------------------------------------+
              | SalesID (PK)                                |
              | OrderDateID  --> Role: Order Date           |
              | ShipDateID   --> Role: Shipping Date        |
              | DeliveryDateID --> Role: Delivery Date      |
              | SalesAmount                                 |
              +---------------------------------------------+



# Sales Data Analysis

## Database Tables

### Date_Dimension Table

| DateID | FullDate   | Day | Month | Year | Weekday   |
|--------|------------|-----|-------|------|-----------|
| 1      | 2024-07-01 | 1   | 7     | 2024 | Monday    |
| 2      | 2024-07-02 | 2   | 7     | 2024 | Tuesday   |
| 3      | 2024-07-03 | 3   | 7     | 2024 | Wednesday |
| 4      | 2024-07-04 | 4   | 7     | 2024 | Thursday  |

### Sales_Fact Table

| SalesID | OrderDateID | ShipDateID | DeliveryDateID | SalesAmount |
|---------|-------------|------------|----------------|-------------|
| 101     | 1           | 2          | 4              | 250.00      |
| 102     | 2           | 3          | 4              | 400.00      |

## SQL Query

```sql
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
```

## Query Results

| SalesID | Order_Date | Ship_Date  | Delivery_Date | SalesAmount |
|---------|------------|------------|---------------|-------------|
| 101     | 2024-07-01 | 2024-07-02 | 2024-07-04    | 250.00      |
| 102     | 2024-07-02 | 2024-07-03 | 2024-07-04    | 400.00      |

## Analysis

This query joins the `Sales_Fact` table with the `Date_Dimension` table three times to:
1. Get the full order date
2. Get the full ship date
3. Get the full delivery date

The results show the complete timeline for each sale with human-readable dates.