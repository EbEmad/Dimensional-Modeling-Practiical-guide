--  1. Create Students Table (Fact Table)
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(100)
);

-- 2. Create Colors Table (Dimension Table)
CREATE TABLE Colors (
    ColorID INT PRIMARY KEY,
    ColorName VARCHAR(50)
);

--  3. Create Bridge Table (Many-to-Many Relationship)
CREATE TABLE StudentColor (
    StudentID INT,
    ColorID INT,
    PRIMARY KEY (StudentID, ColorID),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (ColorID) REFERENCES Colors(ColorID)
);

--  4. Insert Data into Students Table
INSERT INTO Students (StudentID, Name) VALUES
(1, 'Sarah'),
(2, 'Ali'),
(3, 'Mariam');

--  5. Insert Data into Colors Table
INSERT INTO Colors (ColorID, ColorName) VALUES
(1, 'Red'),
(2, 'Blue'),
(3, 'Green');

--  6. Insert Data into Bridge Table (StudentColor)
INSERT INTO StudentColor (StudentID, ColorID) VALUES
(1, 1),  -- Sarah likes Red
(1, 2),  -- Sarah likes Blue
(2, 2),  -- Ali likes Blue
(2, 3),  -- Ali likes Green
(3, 3);  -- Mariam likes Green

--  7. Final Query: Get All Favorite Colors per Student
SELECT 
    s.Name AS StudentName,
    c.ColorName AS FavoriteColor
FROM 
    Students s
JOIN 
    StudentColor sc ON s.StudentID = sc.StudentID
JOIN 
    Colors c ON sc.ColorID = c.ColorID
ORDER BY 
    s.Name;