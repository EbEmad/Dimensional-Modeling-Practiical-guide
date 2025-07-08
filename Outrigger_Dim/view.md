# Outrigger Dimension

## What is an Outrigger Dimension?

An **Outrigger Dimension** is a **secondary dimension table** that is linked to a **main dimension table**, instead of being connected directly to the **fact table**.

Think of it as a **dimension of a dimension**.

---

## Example:


Imagine we have the following dimension table for customers:

### `Dim_Customer`

| CustomerID | Name     | AddressID |
|------------|----------|-----------|
| 1          | John Doe | 101       |

Now we store addresses in a separate table:

### `Dim_Address` (Outrigger Dimension)

| AddressID | City     | Country   |
|-----------|----------|-----------|
| 101       | Cairo    | Egypt     |

Here, `Dim_Address` is an **outrigger dimension** because it connects to `Dim_Customer`, not to the fact table directly.

---
                       +------------------------+
                       |   Location_Dimension   |
                       +------------------------+
                       | LocationID (PK)        |
                       | City                   |
                       | State                  |
                       | Country                |
                       +------------------------+
                                 ▲
                                 │
                                 │ FK
                       +------------------------+
                       |   Customer_Dimension   |
                       +------------------------+
                       | CustomerID (PK)        |
                       | CustomerName           |
                       | LocationID (FK)        |
                       +------------------------+


## When to Use:

- To **normalize** dimension data (especially when sub-attributes are reused).
- When certain details (like addresses, categories, etc.) are **shared** across many entries in the main dimension.

---

##  Considerations:

- Simplifies storage and reduces redundancy.
- But can make queries **more complex**.
- Common in a **snowflake schema**, less preferred in a **star schema**.

---

## Summary:

> Outrigger Dimensions help organize related dimension data more efficiently but should be used carefully to balance **query performance** and **data normalization**.

