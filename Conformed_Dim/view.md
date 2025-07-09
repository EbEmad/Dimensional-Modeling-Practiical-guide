### Shared Dimension: Dim_Customer

| Customer_ID | Customer_Name |
|-------------|---------------|
| 101         | John Smith    |

###  Fact Table: Fact_Sales

| Sale_ID | Customer_ID | Product_ID | Date_ID  | Amount |
|---------|-------------|------------|----------|--------|
| 1       | 101         | 555        | 20230701 | 50.00  |


###  Fact Table: Fact_Support_Tickets

| Ticket_ID | Customer_ID | Product_ID | Date_ID  | Issue   |
|-----------|-------------|------------|----------|---------|
| 9001      | 101         | 555        | 20230703 | Damaged |


###  Query Result: Sales with Support Tickets (CustomerID 101 - John Smith)

| Sale_ID | Ticket_ID | Sale_Date   | Sale_Amount | Support_Issue | Customer_Name | Product_Name |
|---------|-----------|-------------|-------------|---------------|---------------|--------------|
| 1       | 9001      | 2023-07-01  | 50.00       | Damaged       | John Smith    | Laptop X     |
 
 
 
 
                                    +------------------+
                                    |  Dim_Customer    |
                                    +------------------+
                                        ▲       ▲
                                        |       |
                                +---------+       +---------+
                                |                             |
                        +-------------------+       +------------------------+
                        |   Fact_Sales       |       |   Fact_Support_Tickets |
                        +-------------------+       +------------------------+

                        (Same thing for Dim_Product and Dim_Date)


### Explanation: Conformed Dimensions in Action

The diagram above illustrates the concept of **Conformed Dimensions** in a dimensional data warehouse.

- `Dim_Customer` is a **shared dimension** connected to both `Fact_Sales` and `Fact_Support_Tickets`.  
- Similarly, `Dim_Product` and `Dim_Date` (not shown for brevity) are also linked to both fact tables.
- These dimensions are considered **conformed** because:
  - They use the **same primary keys**
  - They maintain a **consistent meaning and structure**
  - They are reused across **multiple fact tables**

This design allows analysts to:
- Perform **cross-domain reporting** (e.g., analyzing how customer issues relate to purchases)
- Maintain **data consistency** across business processes
- Avoid data duplication and reduce ETL complexity

In essence, **conformed dimensions** act as a **common vocabulary** for the entire data warehouse, enabling seamless integration of facts from different processes.
