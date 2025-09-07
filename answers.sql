-- Question 1: Transforming ProductDetail table to First Normal Form (1NF)
-- Split the comma-separated product list into individual rows

CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

INSERT INTO ProductDetail VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');


SELECT 
    OrderID,
    CustomerName,
    TRIM(value) AS Product
FROM ProductDetail
CROSS APPLY STRING_SPLIT(Products, ',');

CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

INSERT INTO OrderDetails VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Question 2: Creating Customers table to eliminate partial dependency
-- This separates customer info from product details
--The original table violated 3NF due to transitive dependencies: CustomerName and customerRegion depended on customerID , which itself depended on OrderID . To resolve this, I created separate tables for Orders and Customers, ensuring that all non-key attributes depend only on the primary key of their respective tables.
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Customers VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');


-- Question 3: Creating Products table to normalize product data
-- Each product is stored in its own row, linked to OrderID
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Customers(OrderID)
);

INSERT INTO OrderProducts VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);