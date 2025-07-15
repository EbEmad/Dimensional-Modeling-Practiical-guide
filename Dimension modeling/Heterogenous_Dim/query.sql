CREATE TABLE Dim_Party (
    PartyID INT PRIMARY KEY,
    PartyType VARCHAR(20),           -- 'Customer', 'Employee', 'Supplier'
    FullName VARCHAR(100),
    Email VARCHAR(100),
    HireDate DATE,
    CustomerSince DATE,
    CompanyName VARCHAR(100)
);

INSERT INTO Dim_Party (PartyID, PartyType, FullName, Email, HireDate, CustomerSince, CompanyName) VALUES
(1, 'Customer', 'Sarah Ali', 'sarah@gmail.com', NULL, '2022-05-01', NULL),
(2, 'Employee', 'Ahmed Khaled', 'ahmed@store.com', '2019-03-15', NULL, NULL),
(3, 'Supplier', NULL, 'sales@acme.com', NULL, NULL, 'Acme Supplies');


CREATE TABLE Fact_Sales (
    OrderID INT PRIMARY KEY,
    PartyID INT,
    OrderDate DATE,
    Amount DECIMAL(10, 2),
    FOREIGN KEY (PartyID) REFERENCES Dim_Party(PartyID)
);

INSERT INTO Fact_Sales (OrderID, PartyID, OrderDate, Amount) VALUES
(1001, 1, '2023-12-01', 250.00),
(1002, 2, '2023-12-02', 800.00),
(1003, 3, '2023-12-03', 500.00);

SELECT
    f.OrderID,
    p.PartyType,
    p.FullName,
    p.Email,
    f.OrderDate,
    f.Amount
FROM Fact_Sales f
JOIN Dim_Party p ON f.PartyID = p.PartyID;
