-- Full Customer Dimension
CREATE TABLE customer_dim (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    age INT,
    address VARCHAR(255),
    city VARCHAR(100),
    region VARCHAR(50),
    signup_date DATE
);

-- Shrunken Customer Dimension (only Region info)
CREATE TABLE customer_region_dim AS
SELECT DISTINCT
    customer_id,
    region
FROM
    customer_dim;

-- OR
-- Shrunken Customer Dimension as a View
CREATE VIEW customer_region_dim AS
SELECT DISTINCT
    customer_id,
    region
FROM
    customer_dim;
