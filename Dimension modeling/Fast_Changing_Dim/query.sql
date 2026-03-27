-- 1. Core Dimension Table (DIM_CUSTOMER)
CREATE TABLE DIM_CUSTOMER (
    customer_key SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    behavior_key INT -- Link to current Mini-Dimension profile
);

-- 2. Mini-Dimension (DIM_BEHAVIOR_MINI)
CREATE TABLE DIM_BEHAVIOR_MINI (
    behavior_key SERIAL PRIMARY KEY,
    bracket_age VARCHAR(20),
    interest_category VARCHAR(50),
    loyalty_tier VARCHAR(20)
);

ALTER TABLE DIM_CUSTOMER 
ADD CONSTRAINT fk_behavior_mini 
FOREIGN KEY (behavior_key) REFERENCES DIM_BEHAVIOR_MINI(behavior_key);

-- 3. Sales Fact Table (FACT_SALES)
CREATE TABLE FACT_SALES (
    sale_id SERIAL PRIMARY KEY,
    customer_key INT REFERENCES DIM_CUSTOMER(customer_key),
    behavior_key INT REFERENCES DIM_BEHAVIOR_MINI(behavior_key), -- Snapshot at time of sale
    amount DECIMAL(12, 2)
);

-- 4. Behavioral Fact Table (FACT_CUSTOMER_BEHAVIOR)
-- For high-frequency tracking (Event Stream)
CREATE TABLE FACT_CUSTOMER_BEHAVIOR (
    event_id BIGSERIAL PRIMARY KEY,
    customer_key INT REFERENCES DIM_CUSTOMER(customer_key),
    event_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    page_url VARCHAR(255),
    action_type VARCHAR(50)
);

-- 5. Sample Data Insertion
INSERT INTO DIM_BEHAVIOR_MINI (bracket_age, interest_category, loyalty_tier) VALUES 
('26-35', 'Electronics', 'Silver'),
('26-35', 'Home Decor', 'Silver'),
('36-45', 'Books', 'Gold');

INSERT INTO DIM_CUSTOMER (name, email, behavior_key) VALUES 
('Alice Johnson', 'alice@email.com', 1),
('Bob Smith', 'bob@email.com', 3);

INSERT INTO FACT_SALES (customer_key, behavior_key, amount) VALUES 
(1, 1, 1500.00),
(2, 3, 400.00);

INSERT INTO FACT_CUSTOMER_BEHAVIOR (customer_key, page_url, action_type) VALUES 
(1, '/products/laptop-pro', 'View'),
(1, '/cart/add/laptop-pro', 'Click'),
(2, '/books/data-modeling', 'View');

-- 6. "Customer 360" Query (Matches README structure)
SELECT 
    c.name,
    m.interest_category,
    m.loyalty_tier,
    s.amount AS last_sale_amount,
    b.page_url AS last_page_url
FROM DIM_CUSTOMER c
JOIN DIM_BEHAVIOR_MINI m ON c.behavior_key = m.behavior_key
LEFT JOIN FACT_SALES s ON c.customer_key = s.customer_key
LEFT JOIN (
    SELECT DISTINCT ON (customer_key) 
        customer_key, page_url 
    FROM FACT_CUSTOMER_BEHAVIOR 
    ORDER BY customer_key, event_time DESC
) b ON c.customer_key = b.customer_key;





