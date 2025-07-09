# Geographic Sales Data Model

##  Dimension Tables

### Dim_Country
| CountryID | CountryName |
|-----------|-------------|
| 1         | USA         |

### Dim_State
| StateID | StateName | CountryID |
|---------|-----------|-----------|
| 10      | Texas     | 1         |

### Dim_City
| CityID | CityName | StateID |
|--------|----------|---------|
| 100    | Dallas   | 10      |
| 101    | Austin   | 10      |

##  Fact Table: Fact_Sales
| SaleID | CityID | DateID     | Amount |
|--------|--------|------------|--------|
| 1      | 100    | 2024-07-01 | 300.00 |
| 2      | 101    | 2024-07-02 | 450.00 |

###  Query Results: Sales by Geography

| SaleID | CountryName | StateName | CityName | DateID     | Amount |
|--------|-------------|-----------|----------|------------|--------|
| 1      | USA         | Texas     | Dallas   | 2024-07-01 | 300.00 |
| 2      | USA         | Texas     | Austin   | 2024-07-02 | 450.00 |


                                                +---------------------+
                                                |    Dim_Country      |
                                                +---------------------+
                                                | CountryID (PK)      |
                                                | CountryName         |
                                                +---------------------+
                                                            ▲
                                                            |
                                                            |
                                                +---------------------+
                                                |     Dim_State       |
                                                +---------------------+
                                                | StateID (PK)        |
                                                | StateName           |
                                                | CountryID (FK)      |
                                                +---------------------+
                                                            ▲
                                                            |
                                                            |
                                                +---------------------+
                                                |     Dim_City        |
                                                +---------------------+
                                                | CityID (PK)         |
                                                | CityName            |
                                                | StateID (FK)        |
                                                +---------------------+
                                                            ▲
                                                            |
                                                            |
                                                +---------------------+
                                                |     Fact_Sales      |
                                                +---------------------+
                                                | SaleID (PK)         |
                                                | CityID (FK)         |
                                                | DateID              |
                                                | Amount              |
                                                +---------------------+



# Snowflake Schema Explained

## Core Concept
- **Normalized dimensions** split into multiple tables
- **Hierarchical relationships** (Country → State → City)
- **Resembles snowflake shape** with branching connections

##  Key Components

### 1. Dimension Tables
- **Dim_Country** (Top-level)
  - `CountryID` (PK)
  - `CountryName`

- **Dim_State** (Mid-level) 
  - `StateID` (PK)
  - `StateName`
  - `CountryID` (FK → Dim_Country)

- **Dim_City** (Leaf-level)
  - `CityID` (PK)
  - `CityName`
  - `StateID` (FK → Dim_State)

### 2. Fact Table
- **Fact_Sales**
  - `SaleID` (PK)
  - `CityID` (FK → Dim_City)
  - `DateID`
  - `Amount`

##  Why This Works

1. **Data Integrity**  
   - Clear PK/FK relationships prevent orphan records
   - Ensures valid geographic hierarchies

2. **Storage Efficiency**  
   - No duplicate country/state names
   - Smaller dimension tables

3. **Query Flexibility**  
   - Analyze at any level: country → state → city
   - Easy to add new geographic levels

##  Considerations

| Advantage | Trade-off |
|-----------|-----------|
| Clean hierarchies | More complex queries |
| Reduced storage | Additional joins |
| Easy maintenance | Slightly slower performance |
