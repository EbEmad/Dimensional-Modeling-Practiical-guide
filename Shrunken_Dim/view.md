# Shrunken Rollup Dimension

##  What is a Shrunken Rollup Dimension?

A **Shrunken Rollup Dimension** (also called **Shrunken Dimension**) is a **subset** of a larger dimension table. It is used when you need a **less detailed version** of a dimension to join with an **aggregated or summarized fact table**.

---

##  Key Characteristics

- **Subset of rows and columns** from the base (full) dimension.
- Used in **summary-level fact tables**.
- Helps to **reduce complexity and improve performance** in queries.
- Maintains **conformed dimension structure** but with less detail.

---

##  Example: Product Dimension

### Full Product Dimension

Used in detailed sales fact tables.

| ProductID | ProductName | Brand | Category | SubCategory | Size | Color |
|-----------|-------------|--------|----------|-------------|------|-------|

### Shrunken Product Dimension

Used in summarized sales fact tables (e.g., by category).

| Category | SubCategory |

This smaller table is a **shrunken version** of the full dimension.

---

##  Use Case

Imagine you have:

- A detailed fact table `Sales_Fact` at the transaction level, using a full `Customer` dimension.
- A summarized fact table `Monthly_Region_Sales` that only needs customer region info.

Instead of joining the full customer dimension, you use a **Shrunken Customer Dimension**:

### Full Customer Dimension

| CustomerID | Name | Age | Address | City | Region |
|------------|------|-----|---------|------|--------|

### Shrunken Customer Dimension

| CustomerID | Region |

---

##  Implementation Tips

- **Physically** stored as a separate table in the warehouse.
- Or **logically** created using a **view** or **transformation** during ETL/ELT.
- Should still be **conformed** (compatible with the base dimension's keys and values).

---

##  When to Use a Shrunken Dimension?

- When building **aggregated fact tables**.
- When you need **faster queries** with fewer joins.
- When only a **subset of dimension attributes** are relevant.
- To ensure **consistency** while optimizing performance.




