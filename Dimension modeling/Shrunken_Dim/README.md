#  Shrunken Rollup Dimension

##  What is a Shrunken Rollup Dimension?

A **Shrunken Rollup Dimension** (or simply **Shrunken Dimension**) is a **subset of a larger dimension table**, designed for use with **aggregated or summarized fact tables**.

It is often **physically smaller** (fewer columns/rows), providing **less granularity**, yet still maintaining a **conformed structure** with the original full dimension.

---

##  Key Characteristics

- Subset of **columns and/or rows** from a base dimension.
- Used in **summary-level fact tables**.
- Improves **query performance** and **simplifies joins**.
- Maintains **conformed semantics** across the data model.
- Can be **physical (table)** or **logical (view)**.

---

##  Example Scenario: Store Dimension

###  Full Store Dimension

Used in detailed transactional reporting:

| StoreID | StoreName       | City       | State | Region | Address             | ManagerName   | StoreType |
|---------|------------------|------------|-------|--------|----------------------|----------------|-----------|
| 1001    | Central Outlet   | Boston     | MA    | East   | 12 Main St           | Alice Johnson  | Mall      |
| 1002    | Urban Depot      | San Diego  | CA    | West   | 45 Ocean Blvd        | John Doe       | Street    |
| ...     | ...              | ...        | ...   | ...    | ...                  | ...            | ...       |

Used in a fact table like `Store_Sales_Fact`:

| SaleID | StoreID | Date       | ProductID | UnitsSold | Revenue |
|--------|---------|------------|-----------|-----------|---------|
| 501    | 1001    | 2024-01-02 | P123      | 4         | 120.00  |

---

###  Shrunken Store Dimension

Used in regional or summary reporting:

| Region | State |
|--------|--------|
| East   | MA     |
| West   | CA     |
| ...    | ...    |

Used in an aggregated fact table like `Regional_Sales_Monthly`:

| Region | State | Month     | TotalSales |
|--------|-------|-----------|------------|
| East   | MA    | 2024-01   | 52,300.00  |
| West   | CA    | 2024-01   | 39,000.00  |

---
##  Visual Model

                            +----------------------------+                      +-----------------------------+
                            |     Full Store Dimension   |                      |   Shrunken Store Dimension  |
                            +----------------------------+                      +-----------------------------+
                            | StoreID                    |                      | Region                      |
                            | StoreName                  |                      | State                       |
                            | City                       |                      +-----------------------------+
                            | State                      |
                            | Region                     |                                 ▲
                            | Address                    |                                 |
                            | ManagerName                |                                 |
                            | StoreType                  |                                 |
                            +----------------------------+                                 |
                                        ▲                                                  |
                                        |                                                  |
                                        ▼                                                  ▼
                            +----------------------------+                      +-----------------------------+
                            |      Store_Sales_Fact      |                      |   Regional_Sales_Monthly    |
                            +----------------------------+                      +-----------------------------+
                            | SaleID                     |                      | Region                      |
                            | StoreID                    |                      | State                       |
                            | Date                       |                      | Month                       |
                            | ProductID                  |                      | TotalSales                  |
                            | UnitsSold                  |                      +-----------------------------+
                            | Revenue                    |
                            +----------------------------+


## When to Use a Shrunken Dimension?

Use shrunken dimensions when:

- You need **high-level summaries** (e.g., by region or category).
- Full detail isn’t necessary (e.g., StoreName, Manager, Address).
- You want to **boost performance** for summary dashboards.
- You want to maintain **semantic consistency** without using the full dimension.




