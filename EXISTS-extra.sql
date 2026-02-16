USE tempdb;     -- Handig voor demo's
GO

DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Orders;
GO

-- Maak 2 tabellen: Customers en Orders
CREATE TABLE Customers (
    Id      int PRIMARY KEY,
    Name    nvarchar(100)
);

CREATE TABLE Orders (
    Id          int IDENTITY PRIMARY KEY,
    CustomerId  int,
    OrderDate   date
);

-- Voeg 3 customers toe
INSERT INTO Customers 
VALUES (1, 'Ab'), (2, 'Bo'), (3, 'Cas');

--------------------------------
-- Voeg 1000 orders toe voor Ab 
--------------------------------

DECLARE @Counter AS int = 1;

WHILE @Counter <= 1000
BEGIN
    INSERT INTO dbo.Orders (CustomerId, OrderDate)
    VALUES (1, '2025-01-01');

    SET @Counter += 1;
END;

-------------------------------------------------
-- Voeg 1 order toe voor Bo
-------------------------------------------------

INSERT INTO dbo.Orders (CustomerId, OrderDate)
VALUES (2, '2025-03-01');

-- Vraag 1: Welke customers hebben tenminste 1 order?
-- Vraag 2: Welke customers hebben nog geen enkele order?

-- Vraag 1.
SELECT DISTINCT
    c.Name
FROM Customers AS c
INNER JOIN Orders AS o
ON c.Id = o.CustomerId;

SELECT 
    c.Name 
FROM Customers AS c
WHERE EXISTS
(
    SELECT 1 FROM Orders AS o
    WHERE c.Id = o.CustomerId
);

-- Vraag 2

SELECT c.Name 
FROM Customers AS c
LEFT OUTER JOIN Orders AS o
ON c.Id = o.CustomerId
WHERE o.Id IS NULL;

SELECT c.Name 
FROM Customers AS c
WHERE NOT EXISTS
(
    SELECT 1 FROM Orders AS o
    WHERE c.Id = o.CustomerId
);

-- Gebruik het knopje "Include Actual Execution Plan" om queries te vergelijken