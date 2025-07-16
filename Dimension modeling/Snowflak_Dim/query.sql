-- Country Dimension
CREATE TABLE Dim_Country (
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(100)
);

-- State Dimension
CREATE TABLE Dim_State (
    StateID INT PRIMARY KEY,
    StateName VARCHAR(100),
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES Dim_Country(CountryID)
);

-- City Dimension
CREATE TABLE Dim_City (
    CityID INT PRIMARY KEY,
    CityName VARCHAR(100),
    StateID INT,
    FOREIGN KEY (StateID) REFERENCES Dim_State(StateID)
);

-- Fact Sales Table
CREATE TABLE Fact_Sales (
    SaleID INT PRIMARY KEY,
    CityID INT,
    DateID DATE,
    Amount DECIMAL(10, 2),
    FOREIGN KEY (CityID) REFERENCES Dim_City(CityID)
);


-- Insert into Country
INSERT INTO Dim_Country VALUES (1, 'USA');

-- Insert into State
INSERT INTO Dim_State VALUES (10, 'Texas', 1);

-- Insert into City
INSERT INTO Dim_City VALUES (100, 'Dallas', 10);
INSERT INTO Dim_City VALUES (101, 'Austin', 10);

-- Insert into Fact Table
INSERT INTO Fact_Sales VALUES (1, 100, '2024-07-01', 300.00);
INSERT INTO Fact_Sales VALUES (2, 101, '2024-07-02', 450.00);

SELECT 
    fs.SaleID,
    dc.CountryName,
    ds.StateName,
    dct.CityName,
    fs.DateID,
    fs.Amount
FROM 
    Fact_Sales fs
JOIN Dim_City dct ON fs.CityID = dct.CityID
JOIN Dim_State ds ON dct.StateID = ds.StateID
JOIN Dim_Country dc ON ds.CountryID = dc.CountryID;
