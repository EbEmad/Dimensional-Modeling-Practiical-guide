#  What Are Conformed Dimensions?

In a dimensional data warehouse, **Conformed Dimensions** are dimension tables that are **shared across multiple fact tables** while maintaining the **same structure, meaning, and keys**.

They serve as a **common reference point** for different business processes, such as sales, support, finance, etc., allowing you to:

- Perform **integrated analysis** across business domains  
- Maintain **data consistency** across subject areas  
- **Reuse ETL pipelines** and reduce data duplication  
- Enable **cross-functional reporting** (e.g., linking purchases to customer complaints)

---
#  Real-World Example: Customer Across Sales and Support

Suppose we’re tracking both **sales transactions** and **customer support tickets** in our data warehouse.

---

##  Conformed Dimension: `Dim_Customer`

| Customer_ID | Customer_Name |
|-------------|---------------|
| 101         | John Smith    |

This table is shared by both sales and support processes.

---

## Fact Table: `Fact_Sales`

| Sale_ID | Customer_ID | Product_ID | Date_ID  | Amount |
|---------|-------------|------------|----------|--------|
| 1       | 101         | 555        | 20230701 | 50.00  |

---

## Fact Table: `Fact_Support_Tickets`

| Ticket_ID | Customer_ID | Product_ID | Date_ID  | Issue   |
|-----------|-------------|------------|----------|---------|
| 9001      | 101         | 555        | 20230703 | Damaged |

---
```sql
SELECT 
    fs.Sale_ID,
    fst.Ticket_ID,
    FORMAT(CONVERT(DATE, CAST(fs.Date_ID AS CHAR(8)), 112), 'yyyy-MM-dd') AS Sale_Date,
    fs.Amount AS Sale_Amount,
    fst.Issue AS Support_Issue,
    dc.Customer_Name
FROM Fact_Sales fs
JOIN Fact_Support_Tickets fst 
    ON fs.Customer_ID = fst.Customer_ID 
    AND fs.Product_ID = fst.Product_ID
JOIN Dim_Customer dc 
    ON fs.Customer_ID = dc.Customer_ID
WHERE fs.Customer_ID = 101;
```

##  Query Result: Sales with Support Tickets (Customer 101 - John Smith)

| Sale_ID | Ticket_ID | Sale_Date   | Sale_Amount | Support_Issue | Customer_Name | 
|---------|-----------|-------------|-------------|---------------|---------------|
| 1       | 9001      | 2023-07-01  | 50.00       | Damaged       | John Smith    |

By using `Dim_Customer`, `Dim_Product`, and `Dim_Date` (all conformed dimensions), we can join `Fact_Sales` and `Fact_Support_Tickets` seamlessly in a single report.

---

##  Diagram: Conformed Dimensions in Action

                                 +------------------+
                                 |   Dim_Customer   |
                                 +------------------+
                                    ▲           ▲
                                    |           |
                             +-------------+   +----------------------+
                             |  Fact_Sales  |   | Fact_Support_Tickets |
                             +-------------+   +----------------------+

         (Same applies for Dim_Product and Dim_Date)
---

##  Key Characteristics of Conformed Dimensions

| **Characteristic**                    | **Matched in Your Explanation**                                                                                                                                |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1. Same Primary Keys**              |  `Customer_ID` is used as the **primary key** in `Dim_Customer`, and as a **foreign key** in both `Fact_Sales` and `Fact_Support_Tickets`.                    |
| **2. Same Business Meaning**          |  Each `Customer_ID` refers to the **same real-world entity** (`John Smith`) whether in the context of a sale or a support ticket.                             |
| **3. Shared Structure & Granularity** | The schema (columns and data types) of `Dim_Customer` remains the **same**, and each row represents a **single customer** (customer-level granularity).      |
| **4. Reusability Across Fact Tables** | `Dim_Customer` is **reused** in multiple fact tables, enabling **unified reporting and queries** across different business processes like sales and support. |
