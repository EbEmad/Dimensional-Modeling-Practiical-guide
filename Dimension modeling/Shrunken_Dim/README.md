# Shrunken Rollup Dimensions

A **Shrunken Rollup Dimension** (or simply **Shrunken Dimension**) is a **subset** of a larger base dimension. It contains a subset of the rows and/or columns of the original dimension and is used to support **aggregated fact tables**.

## The Concept: Granularity Alignment
In dimensional modeling, fact tables often exist at different levels of detail (grain). 
- An **Atomic Fact** (e.g., individual sales) needs the **Full Dimension**.
- An **Aggregated Fact** (e.g., monthly regional totals) needs a **Shrunken Dimension**.

---

## Visualizing the Shrunken Pattern

The Shrunken Dimension is a "rollup" of the base dimension. It remains **conformed** because the attributes it *does* contain are identical in name and meaning to the base dimension.

```mermaid
erDiagram
    DIM_STORE ||--o{ FACT_SALES_ATOMIC : "at_store"
    DIM_STORE_REGION ||--o{ FACT_SALES_REGIONAL_MONTHLY : "at_region"

    DIM_STORE {
        int store_key PK
        string store_name
        string city
        string state
        string region
        string manager_name
    }

    DIM_STORE_REGION {
        string state PK
        string region
    }

    FACT_SALES_ATOMIC {
        int sale_id PK
        int store_key FK
        decimal amount
    }

    FACT_SALES_REGIONAL_MONTHLY {
        string state FK
        string region FK
        string month_key
        decimal total_amount
    }
```

---

## Key Benefits

| Benefit | Description |
| :--- | :--- |
| **Performance** | Smaller tables mean faster joins and smaller indexes. |
| **Simplicity** | Aggregated reports don't need to join to massive detailed dimensions. |
| **Consistency** | Since it's a subset of the base dimension, "Region" means the same thing in both. |
| **Storage** | Reduces the footprint of summary-level data marts. |

---

## Star Schema vs. Aggregation Path

| Feature | Base Dimension | Shrunken Dimension |
| :--- | :--- | :--- |
| **Grain** | Atomic (e.g., Individual Store) | Rollup (e.g., State/Region) |
| **Columns** | All attributes (Manager, Address, etc.) | Only grouping attributes. |
| **Fact Table** | Transactional (Item level) | Aggregated (Monthly/Daily summary) |

---

## Implementation Note
Shrunken dimensions can be implemented as:
1. **Physical Tables**: Best for performance in large-scale warehouses.
2. **Database Views**: `SELECT DISTINCT region, state FROM dim_store`. Best for maintenance (logic is in one place).
imension.
