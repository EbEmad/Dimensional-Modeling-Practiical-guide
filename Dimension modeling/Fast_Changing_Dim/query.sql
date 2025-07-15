-- Core Dimension Table
create table dim_customer(
    customer_id int primary key,
    name varchar(100),
    email varchar(100),
    behavior_id int,
    FOREIGN key (behavior_id) references dim_behavior(behavior_id)
);


-- Mini-Dimension Tabel for fast-Canging Attributes
create table dim_customer_behavior(
    behavior_id int PRIMARY KEY,
    last_page_viewed varchar(100),
    interest_category varchar(100),
    session_count int
);


-- Fact Table
create table fact_customer_behavior(
    event_id BIGSERIAL PRIMARY KEY,
    customer_id int,
    event_timestamp TIMESTAMP,
    page_viewed varchar(100),
    is_new_session BOOLEAN,
    FOREIGN key (customer_id) references dim_customer(customer_id),
    #FOREIGN key (behavior_id) references dim_customer_behavior(behavior_id)
);



-- Then insert customers with initial behaviors
INSERT INTO dim_customer 
(customer_id, name, email, behavior_id)
VALUES 
(101, 'Alice Johnson', 'alice@example.com', 1),
(102, 'Bob Smith', 'bob@example.com', 2);


-- First insert behaviors
INSERT INTO dim_customer_behavior 
(behavior_id, last_page_viewed, interest_category, session_count)
VALUES 
(1, 'Home', 'Electronics', 1),
(2, 'Products', 'Electronics', 2),
(3, 'Cart', 'Books', 3);

-- Insert behavioral events
INSERT INTO fact_customer_behavior 
(customer_id, event_timestamp, page_viewed, is_new_session)
VALUES
(101, '2023-11-01 09:00:00', 'Home', TRUE),
(101, '2023-11-01 09:02:30', 'Products', FALSE),
(101, '2023-11-01 09:05:15', 'Product/123', FALSE),
(101, '2023-11-01 09:10:00', 'Cart', FALSE),
(102, '2023-11-01 10:00:00', 'Home', TRUE),
(102, '2023-11-01 10:01:45', 'Products', FALSE);




-- Query 1: Current customer state with behavior
SELECT 
    c.customer_id,
    c.name,
    b.last_page_viewed AS current_page,
    b.interest_category,
    b.session_count
FROM dim_customer c
JOIN dim_customer_behavior b ON c.behavior_id = b.behavior_id
WHERE b.valid_to IS NULL;

-- Query 2: Customer journey from fact table
SELECT 
    customer_id,
    event_timestamp,
    page_viewed,
    is_new_session
FROM fact_customer_behavior
WHERE customer_id = 101
ORDER BY event_timestamp;





