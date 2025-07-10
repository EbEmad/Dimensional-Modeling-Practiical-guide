# Slowly Changing Dimensions (SCD) Explained

Slowly Changing Dimensions (SCD) are used in data warehousing to manage and track changes in dimension attributes over time.

For example, if a customer's address changes, do we:
- Overwrite the old address?
- Store the new address in a new row?
- Keep both addresses in the same row?

This leads to different types of SCDs.

---

##  Type 1: Overwrite (No History)

- The old data is overwritten with the new data.
- No history of changes is maintained.
- Simple and space-efficient.
- Best used when historical accuracy is **not** important.

### Example:

| CustomerID | Name  | Address     |
|------------|-------|-------------|
| 101        | John  | Cairo       |

John moves to Alexandria:

| CustomerID | Name  | Address     |
|------------|-------|-------------|
| 101        | John  | Alexandria  |

 Cannot tell where John lived before.

---

##  Type 2: Add New Row (Full History)

- Each change in a dimension attribute results in a **new row**.
- Tracks historical changes over time.
- Requires columns like `StartDate`, `EndDate`, `IsCurrent`, or `Version`.

### Example:

| CustomerID | Name  | Address     | StartDate  | EndDate    | IsCurrent |
|------------|-------|-------------|------------|------------|-----------|
| 101        | John  | Cairo       | 2022-01-01 | 2023-06-30 | No        |
| 101        | John  | Alexandria  | 2023-07-01 | NULL       | Yes       |

 Accurate history is preserved.

---

## Type 3: Store Previous Value (Limited History)

- The old value is stored in **additional columns** within the same row.
- Tracks limited historical changes (e.g., only current and one previous value).
- Simpler than Type 2 but with limited usefulness.

### Example:

| CustomerID | Name  | CurrentAddress | PreviousAddress |
|------------|-------|----------------|-----------------|
| 101        | John  | Alexandria     | Cairo           |

 Cannot store more than one historical change.

---

##  Type 4: History Table

- Current data is stored in the main dimension table.
- Historical data is moved to a **separate history table**.
- Useful for archiving changes while keeping the current table light.

### Example:

**Current Table (DimCustomer):**

| CustomerID | Name  | Address     |
|------------|-------|-------------|
| 101        | John  | Alexandria  |

**History Table (Customer_History):**

| CustomerID | Name  | Address | StartDate  | EndDate    |
|------------|-------|---------|------------|------------|
| 101        | John  | Cairo   | 2022-01-01 | 2023-06-30 |

 Separates current and historical data.

---

##  Summary Table

| Type | Tracks History | How                             | Use Case                                |
|------|----------------|----------------------------------|------------------------------------------|
| 1    |  No           | Overwrite old data               | Non-critical historical tracking         |
| 2    |  Full         | Add new row for each change      | Audit logs, customer history             |
| 3    |  Limited      | Add columns for old values       | Track recent changes, light history      |
| 4    |  Full (External) | Separate history table       | Large datasets with archival needs       |

---

##  Best Practices

- Use **Type 2** if tracking full history is important.
- Use **Type 1** if changes are not significant to your analysis.
- Use **Type 3** for small, limited changes (e.g., last known state).
- Use **Type 4** for archiving in large systems.

