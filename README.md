# Dimensional-Modeling-Practiical-guide


# Dimensional Modeling Schemas

This repository contains SQL schemas and example data for various types of dimensional modeling. Dimensional modeling is used in data warehousing and business intelligence to structure data for efficient querying and reporting.
![Fact Star Diagram](/fact-star-80bd6bb932bba008854f4bb3ac567c2a.png)

## Contents

1. **Product Dimension**: Basic schema for product information.
2. **Customer Dimension**: Includes examples for Slowly Changing Dimensions (SCD) Types 1, 2, 3, and 4.
3. **Junk Dimension**: Consolidates miscellaneous attributes.
4. **Degenerate Dimension**: Shows how to handle dimensions that exist only in the fact table.
5. **Role-Playing Dimension**: Demonstrates a single dimension used in multiple roles.
6. **Outrigger Dimension**: Links one dimension table to another.
7. **Conformed Dimension**: Shared dimensions used across multiple fact tables.

## Schemas

```sql
CREATE TABLE Customer_DimensionSCD1 (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255)
);
```
```sql
CREATE TABLE Customer_DimensionSCD2 (
    CustomerSurrogateID SERIAL PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    IsCurrent CHAR(1)
);
```

```sql
CREATE TABLE Customer_DimensionSCD3 (
    CustomerSurrogateID SERIAL PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255),
    PreviousCity VARCHAR(255)
);
```

```sql
CREATE TABLE Customer_DimensionSCD4 (
    CustomerSurrogateID SERIAL PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255)
);

CREATE TABLE Customer_Historical_DimensionSCD4 (
    HistoricalID SERIAL PRIMARY KEY,
    CustomerID INT,
    CustomerName VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255),
    ChangeDate DATE
);
```

```sql
CREATE TABLE Order_Junk_Dimension (
    JunkID SERIAL PRIMARY KEY,
    OrderPriority VARCHAR(50),
    OrderType VARCHAR(50)
);
```

```sql
Degenerate Dimension
CREATE TABLE Sales_Fact (
    SalesID SERIAL PRIMARY KEY,
    OrderNumber VARCHAR(50), -- Degenerate Dimension
    ProductID INT,
    CustomerID INT,
    SalesAmount DECIMAL(10, 2),
    SalesDate DATE
);
```

```sql
Role-Playing Dimension
CREATE TABLE Date_Dimension (
    DateID INT PRIMARY KEY,
    FullDate DATE,
    Day INT,
    Month INT,
    Year INT,
    Weekday VARCHAR(50)
);

CREATE TABLE Sales_Fact (
    SalesID INT PRIMARY KEY,
    OrderDateID INT,
    ShipDateID INT,
    DeliveryDateID INT,
    SalesAmount DECIMAL(10, 2),
    FOREIGN KEY (OrderDateID) REFERENCES Date_Dimension(DateID),
    FOREIGN KEY (ShipDateID) REFERENCES Date_Dimension(DateID),
    FOREIGN KEY (DeliveryDateID) REFERENCES Date_Dimension(DateID)
);
```

```sql
Outrigger Dimension
CREATE TABLE Location_Dimension (
    LocationID INT PRIMARY KEY,
    City VARCHAR(255),
    State VARCHAR(255),
    Country VARCHAR(255)
);

CREATE TABLE Customer_Dimension (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255),
    LocationID INT,
    FOREIGN KEY (LocationID) REFERENCES Location_Dimension(LocationID)
);
```

```sql
Conformed Dimension
CREATE TABLE Date_Dimension (
    DateID INT PRIMARY KEY,
    FullDate DATE,
    Day INT,
    Month INT,
    Year INT
);

CREATE TABLE Sales_Fact (
    SalesID INT PRIMARY KEY,
    DateID INT,
    SalesAmount DECIMAL(10, 2),
    FOREIGN KEY (DateID) REFERENCES Date_Dimension(DateID)
);

CREATE TABLE Inventory_Fact (
    InventoryID INT PRIMARY KEY,
    DateID INT,
    Quantity INT,
    FOREIGN KEY (DateID) REFERENCES Date_Dimension(DateID)
);
```

# Usage

To use these schemas, execute the SQL statements in your database management system. You can modify and extend the schemas based on your specific requirements.

# License

This project is licensed under the MIT License - see the LICENSE file for details.

# Contact

For questions or comments, please reach out to muhamedfahmy7474@gmail.com.


This updated `README.md` file provides a clear description of each dimensional modeling schema and their purpose.

