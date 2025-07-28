
#  Fast Changing Dimensions 


##  Problem Statement

Fast-changing attributes (e.g., browsing behavior, session data) change frequently and are not suitable for SCD Type 2 due to excessive row versions.

### Example – E-commerce Customer Table

| CustomerID | Name | Last_Page_Viewed | Interest_Category | Session_Count |
|------------|------|------------------|-------------------|---------------|
| 1          | Ali  | Home             | Electronics       | 3             |

Attributes like `Last_Page_Viewed` and `Interest_Category` change frequently and don’t require full historical tracking.

---

##  Solution 1: Mini-Dimension

Separate fast-changing attributes into a **mini-dimension**, referenced by a foreign key in the main dimension.

### `dim_customer` (Core Dimension)

| Column       | Type   | Description           |
|--------------|--------|-----------------------|
| customer_id  | INT PK | Unique customer ID    |
| name         | STRING | Static attribute      |
| email        | STRING | Static attribute      |
| behavior_id  | INT FK | Refers to mini-dim ID |

### `dim_customer_behavior` (Mini-Dimension)

| Column            | Type   | Description              |
|-------------------|--------|--------------------------|
| behavior_id       | INT PK | Surrogate key            |
| last_page_viewed  | STRING | Last visited page        |
| interest_category | STRING | Current interest         |
| session_count     | INT    | Number of sessions       |

 A new `behavior_id` is created only when behavior changes.

---

##  Solution 2: Fact Table

Track changes in a **fact table** as events, storing behavior with timestamps for detailed analysis.

### `fact_customer_behavior`

| Column            | Type      | Description              |
|-------------------|-----------|--------------------------|
| event_id          | BIGINT PK | Unique event identifier  |
| customer_id       | INT FK    | Reference to customer    |
| event_timestamp   | DATETIME  | Timestamp of event       |
| page_viewed       | STRING    | Page visited             |
| interest_category | STRING    | New interest             |
| is_new_session    | BOOLEAN   | Session flag             |

 Useful for real-time analytics and event-based models.

---

##  Comparison

| Aspect                | Mini-Dimension                   | Fact Table                          |
|-----------------------|----------------------------------|-------------------------------------|
| Storage Cost          | Lower                            | Higher                              |
| Historical Tracking   | Limited to behavior snapshots    | Full event history                  |
| Query Complexity      | Moderate                         | Higher                              |
| Real-time Use Cases   |  Less suitable                 |  Ideal for streaming/analytics    |

---

##  Hybrid Approach

Use both:
- **Mini-Dimension** for current behavior snapshot
- **Fact Table** for full behavioral tracking

This allows fast queries on current state and deep insights from historical data.

---



## Visual Model


###  Solution 1: Mini-Dimension (Snapshot-Based)
```

                        +----------------------+
                        |    dim_customer      |   ← Main dimension
                        +----------------------+
                        | customer_id (PK)     |
                        | name                 |
                        | email                |
                        | behavior_id (FK)     |   ← Link to mini-dimension
                        +----------------------+
                                    |
                                    ▼
                        +-----------------------------+
                        |  dim_customer_behavior      |   ← Mini-dimension
                        +-----------------------------+
                        | behavior_id (PK)            |
                        | last_page_viewed            |
                        | interest_category           |
                        | session_count               |
                        +-----------------------------+
```
###  Solution 2: Fact Table (Event-Driven)
```
                                +----------------------+
                                |    dim_customer      |   ← Main dimension
                                +----------------------+
                                | customer_id (PK)     |
                                | name                 |
                                | email                |
                                | event_id (FK)     |   ← Link to fact table
                                +----------------------+
                                            |
                                            ▼
                        +-------------------------------------+
                        |      fact_customer_behavior         |   ← Event-level fact table
                        +-------------------------------------+
                        | event_id (PK)                       |
                        | customer_id (FK)                    |
                        | event_timestamp                     |
                        | page_viewed                         |
                        | interest_category                   |
                        | is_new_session                      |
                        +-------------------------------------+

```
