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



