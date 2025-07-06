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
