-- Active: 1751631291387@@127.0.0.1@5433@postgres
-- Active: 1751444695567@@localhost@5432
--  Conformed Dimension: Date
CREATE TABLE Dim_Date (
    Date_ID INT PRIMARY KEY,
    FullDate DATE,
    Day INT,
    Month INT,
    Year INT
);

-- Conformed Dimension: Customer
CREATE TABLE Dim_Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100)
);

-- Conformed Dimension: Product
CREATE TABLE Dim_Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100)
);

-- Fact Table: Sales
CREATE TABLE Fact_Sales (
    Sale_ID INT PRIMARY KEY,
    Customer_ID INT,
    Product_ID INT,
    Date_ID INT,
    Amount DECIMAL(10, 2),
    FOREIGN KEY (Customer_ID) REFERENCES Dim_Customer(Customer_ID),
    FOREIGN KEY (Product_ID) REFERENCES Dim_Product(Product_ID),
    FOREIGN KEY (Date_ID) REFERENCES Dim_Date(Date_ID)
);

-- Fact Table: Support Tickets
CREATE TABLE Fact_Support_Tickets (
    Ticket_ID INT PRIMARY KEY,
    Customer_ID INT,
    Product_ID INT,
    Date_ID INT,
    Issue VARCHAR(100),
    FOREIGN KEY (Customer_ID) REFERENCES Dim_Customer(Customer_ID),
    FOREIGN KEY (Product_ID) REFERENCES Dim_Product(Product_ID),
    FOREIGN KEY (Date_ID) REFERENCES Dim_Date(Date_ID)
);



-- Insert into shared dimensions
INSERT INTO Dim_Customer VALUES (101, 'John Smith');
INSERT INTO Dim_Product VALUES (555, 'Laptop X');
INSERT INTO Dim_Date VALUES (20230701, '2023-07-01', 1, 7, 2023);
INSERT INTO Dim_Date VALUES (20230703, '2023-07-03', 3, 7, 2023);

-- Insert into fact tables
INSERT INTO Fact_Sales VALUES (1, 101, 555, 20230701, 50.00);
INSERT INTO Fact_Support_Tickets VALUES (9001, 101, 555, 20230703, 'Damaged');






-- get the result

SELECT 
    s.Sale_ID,
    t.Ticket_ID,
    d.FullDate AS Sale_Date,
    s.Amount AS Sale_Amount,
    t.Issue AS Support_Issue,
    c.Customer_Name,
    p.Product_Name
FROM Fact_Sales s
JOIN Dim_Date d ON s.Date_ID = d.Date_ID
JOIN Fact_Support_Tickets t ON t.Customer_ID = s.Customer_ID AND t.Product_ID = s.Product_ID
JOIN Dim_Customer c ON s.Customer_ID = c.Customer_ID
JOIN Dim_Product p ON s.Product_ID = p.Product_ID
WHERE s.Customer_ID = 101;
