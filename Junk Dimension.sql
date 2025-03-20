-- Junk Dimension
  --A Junk Dimension consolidates miscellaneous attributes that don't fit neatly into other dimensions.
CREATE TABLE Order_Junk_Dimension (
    JunkID SERIAL PRIMARY KEY,
    OrderPriority VARCHAR(50),
    OrderType VARCHAR(50)
);

-- Insert some combinations of attributes
INSERT INTO Order_Junk_Dimension (OrderPriority, OrderType)
VALUES ('High', 'Online'),
       ('Low', 'In-Store'),
       ('Medium', 'Online');

-- Query the Junk Dimension
SELECT * FROM Order_Junk_Dimension;
