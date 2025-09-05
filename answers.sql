-- Creating original table for 1NF--
The original ProductDetail table violated 1NF because the Products column contained multiple values. I used a string-splitting function to separate each product into its own row, ensuring atomicity.
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);


INSERT INTO ProductDetail VALUES
(101, 'Mary Mawunyo', 'Laptop, Mouse'),
(102, 'Abigail Sekpor', 'Tablet, Keyboard, Mouse'),
(103, 'Bernice Alpha', 'Phone');

-- Transforming to 1NF--
The OrderDetails table violated 2NF due to a partial dependency: CustomerName depended only on OrderID. I resolved this by creating two tables — one for customer info and one for product details — ensuring every non-key column depends on the full primary key.
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
(101, 'Mary Mawunyo', 'Laptop', 2),
(101, 'Mary Mawunyo', 'Mouse', 1),
(102, 'Abigail Sekpor', 'Tablet', 3),
(102, 'Abigail Sekpor', 'Keyboard', 1),
(102, 'Abigail Sekpor', 'Mouse', 2),
(103, 'Bernice Alpha', 'Phone', 1);

-- Split into Two Tables--
The original table violated 3NF due to transitive dependencies: CustomerName and customerRegion depended on customerID , which itself depended on OrderID . To resolve this, I created separate tables for Orders and Customers, ensuring that all non-key attributes depend only on the primary key of their respective tables.
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Customers VALUES
(101, 'Mary Mawunyo'),
(102, 'Abigail Sekpor'),
(103, 'Bernice Alpha');

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