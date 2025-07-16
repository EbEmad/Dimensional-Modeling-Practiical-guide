-- Without Junk Dimension

CREATE TABLE Dim_Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(50)
);

CREATE TABLE Dim_Date (
    Date_ID INT PRIMARY KEY,
    Date_Value DATE
);

CREATE TABLE Dim_Is_Promo (
    Is_Promo_ID INT PRIMARY KEY,
    Is_Promo VARCHAR(3)
);

CREATE TABLE Dim_Is_First_Order (
    Is_First_ID INT PRIMARY KEY,
    Is_First_Order VARCHAR(3)
);

CREATE TABLE Dim_Order_Type (
    Order_Type_ID INT PRIMARY KEY,
    Order_Type VARCHAR(20)
);

CREATE TABLE Fact_Sales_No_Junk (
    Sale_ID INT PRIMARY KEY,
    Product_ID INT,
    Date_ID INT,
    Amount DECIMAL(10,2),
    Is_Promo_ID INT,
    Is_First_ID INT,
    Order_Type_ID INT,
    
    FOREIGN KEY (Product_ID) REFERENCES Dim_Product(Product_ID),
    FOREIGN KEY (Date_ID) REFERENCES Dim_Date(Date_ID),
    FOREIGN KEY (Is_Promo_ID) REFERENCES Dim_Is_Promo(Is_Promo_ID),
    FOREIGN KEY (Is_First_ID) REFERENCES Dim_Is_First_Order(Is_First_ID),
    FOREIGN KEY (Order_Type_ID) REFERENCES Dim_Order_Type(Order_Type_ID)
);



--  With Junk Dimension

CREATE TABLE Dim_Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(50)
);

CREATE TABLE Dim_Date (
    Date_ID INT PRIMARY KEY,
    Date_Value DATE
);

CREATE TABLE Dim_Junk (
    Junk_ID INT PRIMARY KEY,
    Is_Promo VARCHAR(3),
    Is_First_Order VARCHAR(3),
    Order_Type VARCHAR(20)
);


CREATE TABLE Fact_Sales_With_Junk (
    Sale_ID INT PRIMARY KEY,
    Product_ID INT,
    Date_ID INT,
    Amount DECIMAL(10,2),
    Junk_ID INT,

    FOREIGN KEY (Product_ID) REFERENCES Dim_Product(Product_ID),
    FOREIGN KEY (Date_ID) REFERENCES Dim_Date(Date_ID),
    FOREIGN KEY (Junk_ID) REFERENCES Dim_Junk(Junk_ID)
);

