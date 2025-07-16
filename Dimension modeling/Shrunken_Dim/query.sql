-- 1. Full Store Dimension
CREATE TABLE store_dim (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(50),
    region VARCHAR(50),
    address VARCHAR(255),
    manager_name VARCHAR(100),
    store_type VARCHAR(50)
);

-- 2. Store Sales Fact Table (Detailed)
CREATE TABLE store_sales_fact (
    sale_id INT PRIMARY KEY,
    store_id INT,
    sale_date DATE,
    product_id VARCHAR(20),
    units_sold INT,
    revenue DECIMAL(10,2),
    FOREIGN KEY (store_id) REFERENCES store_dim(store_id)
);

-- 3. Shrunken Store Dimension (Region-Level)
CREATE TABLE store_region_dim AS
SELECT DISTINCT region, state
FROM store_dim;

-- 4. Regional Sales Monthly (Aggregated Summary)
CREATE TABLE regional_sales_monthly (
    region VARCHAR(50),
    state VARCHAR(50),
    month CHAR(7),
    total_sales DECIMAL(12,2)
);

-- Insert sample data into store_dim
INSERT INTO store_dim (store_id, store_name, city, state, region, address, manager_name, store_type)
VALUES
(1001, 'Central Outlet', 'Boston', 'MA', 'East', '12 Main St', 'Alice Johnson', 'Mall'),
(1002, 'Urban Depot', 'San Diego', 'CA', 'West', '45 Ocean Blvd', 'John Doe', 'Street');

-- Insert sample data into store_sales_fact
INSERT INTO store_sales_fact (sale_id, store_id, sale_date, product_id, units_sold, revenue)
VALUES
(501, 1001, '2024-01-02', 'P123', 4, 120.00);

-- Insert sample data into regional_sales_monthly
INSERT INTO regional_sales_monthly (region, state, month, total_sales)
VALUES
('East', 'MA', '2024-01', 52300.00),
('West', 'CA', '2024-01', 39000.00);


-- option1 without shrunken dimension
SELECT 
    ssf.sale_id,
    ssf.sale_date,
    sd.store_name,
    sd.city,
    sd.state,
    sd.region,
    ssf.product_id,
    ssf.units_sold,
    ssf.revenue
FROM 
    store_sales_fact ssf
JOIN 
    store_dim sd ON ssf.store_id = sd.store_id;



-- option2 with shrunken dimension
SELECT 
    rsm.region,
    rsm.state,
    rsm.month,
    rsm.total_sales
FROM 
    regional_sales_monthly rsm
JOIN 
    store_region_dim srd ON rsm.region = srd.region AND rsm.state = srd.state;

