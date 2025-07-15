#  Snowflake Dimension

## Explanation

### What Is a Snowflake Dimension?

A **Snowflake Dimension** is a type of dimension modeling technique in data warehousing where the dimension data is **normalized** into multiple related tables, rather than being stored in a single denormalized table.

It represents **hierarchical relationships** explicitly by breaking down the dimension into levels — for example:  
`Country → State → City`.

This design reduces data redundancy and improves data integrity, but at the cost of more complex joins.

---

#  Example: Snowflake Dimension in a Sales Model

## 1. Dimension Tables

### `Dim_Country`

| CountryID | CountryName |
|-----------|-------------|
| 1         | USA         |

---

### `Dim_State`

| StateID | StateName | CountryID |
|---------|-----------|-----------|
| 10      | Texas     | 1         |

---

### `Dim_City`

| CityID | CityName | StateID |
|--------|----------|---------|
| 100    | Dallas   | 10      |
| 101    | Austin   | 10      |

---

### `Dim_Date`

| DateID  | FullDate   | Day | Month | Quarter | Year |
|---------|------------|-----|-------|---------|------|
| 20240701| 2024-07-01 | 1   | 7     | Q3      | 2024 |
| 20240702| 2024-07-02 | 2   | 7     | Q3      | 2024 |

---

## 2. Fact Table

### `Fact_Sales`

| SaleID | CityID | DateID   | Amount |
|--------|--------|----------|--------|
| 1      | 100    | 20240701 | 300.00 |
| 2      | 101    | 20240702 | 450.00 |

---

## 3. Query Output Example

| SaleID | CountryName | StateName | CityName | FullDate   | Amount |
|--------|-------------|-----------|----------|------------|--------|
| 1      | USA         | Texas     | Dallas   | 2024-07-01 | 300.00 |
| 2      | USA         | Texas     | Austin   | 2024-07-02 | 450.00 |

---

# Visual Model
                                                    +---------------------+
                                                    |     Dim_Country     |
                                                    +---------------------+
                                                    | CountryID (PK)      |
                                                    | CountryName         |
                                                    +---------------------+
                                                                ▲
                                                                |
                                                    +---------------------+
                                                    |      Dim_State      |
                                                    +---------------------+
                                                    | StateID (PK)        |
                                                    | StateName           |
                                                    | CountryID (FK)      |
                                                    +---------------------+
                                                                ▲
                                                                |
                                                    +---------------------+
                                                    |      Dim_City       |
                                                    +---------------------+
                                                    | CityID (PK)         |
                                                    | CityName            |
                                                    | StateID (FK)        |
                                                    +---------------------+
                                                                ▲
                                                                |
                                    +------------------+       +-------------------+
                                    |   Dim_Date       |       |    Fact_Sales     |
                                    +------------------+       +-------------------+
                                    | DateID (PK)      |<------| DateID (FK)       |
                                    | FullDate         |       | CityID (FK)       |
                                    | Day, Month, etc. |       | Amount            |
                                    +------------------+       | SaleID (PK)       |
                                                               +-------------------+



##  Key Benefits

| Benefit                | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| **Storage Efficiency** | Removes redundant data by splitting hierarchies into separate tables        |
| **Data Integrity**     | Foreign key constraints ensure consistency across levels                     |
| **Query Flexibility**  | Enables analysis at multiple levels (e.g., by country, state, or city)       |
| **Maintainability**    | Easier to update individual dimensions without affecting others              |

---

##  Trade-offs

| Advantage              | Trade-off                       |
|------------------------|----------------------------------|
| Reduces redundancy     | Requires more joins              |
| Clean structure        | Slightly complex query writing   |
| Easier updates         | May lead to slower performance   |

---

##  When to Use a Snowflake Schema

Use a Snowflake Schema when:
- Your dimensions have clear hierarchical levels (e.g., region → country → state → city).
- You want to **reduce data redundancy**.
- You prioritize **data quality and integrity** over query speed.
- You're building a **scalable data warehouse** that will grow in complexity over time.



