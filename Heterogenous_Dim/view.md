#  Heterogeneous Dimension – Explained with Real Example

##  What is a Heterogeneous Dimension?

A **Heterogeneous Dimension** is a **single dimension table** that stores data for **multiple entity types** that play a similar role in a fact table. 

Each row in the dimension represents a **different kind of entity**, and a column like `EntityType` or `PartyType` helps identify what kind of entity it is.

---

##  Real-Life Scenario: Online Store

In an online store system, multiple types of parties can place orders:

-  Customers
-  Employees
-  Suppliers

Rather than creating 3 separate dimension tables, we use **one dimension table** to represent all of them: `Dim_Party`.

---

##  Table: `Dim_Party` (Heterogeneous Dimension)

| PartyID | PartyType  | FullName      | Email             | HireDate   | CustomerSince | CompanyName    |
|---------|------------|---------------|-------------------|------------|----------------|----------------|
| 1       | Customer   | Sarah Ali     | sarah@gmail.com   | NULL       | 2022-05-01     | NULL           |
| 2       | Employee   | Ahmed Khaled  | ahmed@store.com   | 2019-03-15 | NULL           | NULL           |
| 3       | Supplier   | NULL          | sales@acme.com    | NULL       | NULL           | Acme Supplies  |

- `PartyType` distinguishes the entity type.
- Only some columns apply depending on the type:
  - `CustomerSince` → only for customers
  - `HireDate` → only for employees
  - `CompanyName` → only for suppliers

---

##  Fact Table: `Fact_Sales`

| OrderID | PartyID | OrderDate  | Amount |
|---------|---------|------------|--------|
| 1001    | 1       | 2023-12-01 | 250    |
| 1002    | 2       | 2023-12-02 | 800    |
| 1003    | 3       | 2023-12-03 | 500    |

Each sale is linked to one party in `Dim_Party`, whether it's a customer, employee, or supplier.

---
## Visual Model
                       +---------------------------+
                       |        Dim_Party          |
                       +---------------------------+
                       | PartyID (PK)              |
                       | PartyType                 |
                       | FullName                  |
                       | Email                     |
                       | HireDate                  |
                       | CustomerSince             |
                       | CompanyName               |
                       +---------------------------+
                                ▲
                                |
                                |
                       +----------------------+
                       |      Fact_Sales      |
                       +----------------------+
                       | OrderID (PK)         |
                       | PartyID (FK)         |
                       | OrderDate            |
                       | Amount               |
                       +----------------------+

##  Why Use Heterogeneous Dimensions?

###  Advantages:
- Reduces the number of dimension tables.
- Makes fact table joins simpler (one foreign key like `PartyID`).
- Useful when different entities **play the same role** in transactions.

###  Disadvantages:
- Many columns may be NULL (sparse data).
- Requires a `PartyType` filter to avoid incorrect aggregations.
- Harder to enforce data validation rules.

---

##  When to Use

Use when:
- Multiple entity types serve the **same purpose** in your data model.
- You want to **simplify joins** and **reduce schema complexity**.

Don’t use when:
- Different entities have **too few shared attributes**.
- NULLs dominate the table.

---



