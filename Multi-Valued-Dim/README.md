#  Multi-Valued Dimensions

##  1. What is a Multi-Valued Dimension?

A **Multi-Valued Dimension (MVD)** is a situation where **one fact record** is associated with **multiple values** in a dimension.

---

##  2. Simple Example

Imagine you are tracking **students and their favorite colors**.

###  Normal Case (Single-Valued Dimension)

| Student | Favorite Color |
|---------|----------------|
| Sarah   | Red            |
| Ali     | Blue           |
| Mariam  | Green          |

You can easily design:

### Student Table (Fact)
| StudentID | Name  | ColorID |
|-----------|-------|---------|
| 1         | Sarah | 1       |

### Color Dimension Table
| ColorID | Color  |
|---------|--------|
| 1       | Red    |

Each student is linked to **one** color → easy to join.

---

##  3. Problem: Student Likes Many Colors

| Student | Favorite Colors        |
|---------|------------------------|
| Sarah   | Red, Blue              |
| Ali     | Blue, Green            |
| Mariam  | Green                  |

Now, one student is related to **multiple dimension values** → **Multi-Valued Dimension**.

---

##  Why This is a Problem

- You can’t store multiple values in one `ColorID` column.
- You can’t easily query or join if values are stored as comma-separated lists.
- You can’t predict how many values (so can't use ColorID1, ColorID2...ColorIDn).

---

## 4. The Solution: Use a Bridge Table

Break the many-to-many relationship using a **Bridge Table** .

### 1. Student Table
| StudentID | Name  |
|-----------|-------|
| 1         | Sarah |
| 2         | Ali   |

### 2. Color Dimension Table
| ColorID | Color  |
|---------|--------|
| 1       | Red    |
| 2       | Blue   |
| 3       | Green  |

### 3. StudentColor Bridge Table
| StudentID | ColorID |
|-----------|---------|
| 1         | 1       | ← Sarah likes Red  
| 1         | 2       | ← Sarah likes Blue  
| 2         | 2       | ← Ali likes Blue  
| 2         | 3       | ← Ali likes Green  

This design allows:
- Easy joins
- Scalable to any number of colors per student
- Clean, normalized schema


                          +------------------+
                          |   Dim_Color      |
                          |------------------|
                          | ColorID (PK)     |
                          | ColorName        |
                          +------------------+
                                   ▲
                                   |
                                   |
                        +------------------------+
                        |  Bridge_StudentColor   |
                        |------------------------|
                        | StudentID (PK)(FK)     |
                        | ColorID (PK)(FK)       |
                        +------------------------+
                                   ▲
                                   |
                          +------------------+
                          |   Dim_Student    |
                          |------------------|
                          | StudentID (PK)   |
                          | Name             |
                          +------------------+


