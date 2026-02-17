-- POSSIBLE SOLUTIONS FOR THREE REPETITION EXERCISES

-- 1. Write a query that shows SalesOrderId, OrderDate, Customer Full Name (existing of FirstName, MiddleName and LastName) and Order Total
--    - Use tables: Customer, SalesOrderHeader, SalesOrderDetail
--    - Calculate the subtotals for each OrderDetail ("OrderRegel") manually, 
--      taking into account: OrderQty, UnitPrice and UnitPriceDiscount

SELECT 
    *
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.SalesOrderDetail AS sod
ON soh.SalesOrderID = sod.SalesOrderID;

SELECT 
    soh.SalesOrderID
    , soh.OrderDate
    , (sod.OrderQty * sod.UnitPrice) * (1 - sod.UnitPriceDiscount)  AS OrderlineTotal
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.SalesOrderDetail AS sod
ON soh.SalesOrderID = sod.SalesOrderID;

SELECT 
    soh.SalesOrderID
    , soh.OrderDate
    , SUM((sod.OrderQty * sod.UnitPrice) * (1 - sod.UnitPriceDiscount)) AS OrderTotal
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.SalesOrderDetail AS sod
ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY 
    soh.SalesOrderID
    , soh.OrderDate;


SELECT 
    soh.SalesOrderID
    , soh.OrderDate
    , CONCAT_WS(' ', c.FirstName, c.MiddleName, c.LastName)        AS CustomerFullName
    , SUM((sod.OrderQty * sod.UnitPrice) * (1 - sod.UnitPriceDiscount)) AS OrderTotal
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.SalesOrderDetail AS sod
ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN SalesLT.Customer AS c
ON soh.CustomerID = c.CustomerID
GROUP BY 
    soh.SalesOrderID
    , soh.OrderDate
    , CONCAT_WS(' ', c.FirstName, c.MiddleName, c.LastName);

-- Alternatief

WITH OrderRegels AS
(
    SELECT 
        SalesOrderID
        , SUM((OrderQty * UnitPrice) * (1 - UnitPriceDiscount)) AS OrderTotal
    FROM SalesLT.SalesOrderDetail
    GROUP BY SalesOrderID
),
CustomerDetails AS
(
    SELECT 
        CustomerId 
        , CONCAT_WS(' ', FirstName, MiddleName, LastName)     AS CustomerFullName
    FROM SalesLT.Customer
)
SELECT 
    soh.SalesOrderID
    , soh.OrderDate
    , cd.CustomerFullName
    , org.OrderTotal
FROM OrderRegels AS org
INNER JOIN SalesLT.SalesOrderHeader AS soh
ON org.SalesOrderID = soh.SalesOrderId
INNER JOIN CustomerDetails AS cd
ON soh.CustomerID = cd.CustomerID;

-- 2. Which customers have got at least one order. Optimize next query:

SELECT DISTINCT c.LastName
FROM SalesLT.Customer c
INNER JOIN SalesLT.SalesOrderHeader o 
ON c.CustomerID = o.CustomerId;

SELECT c.LastName
FROM SalesLT.Customer c
WHERE EXISTS
(
    SELECT 
        1
    FROM SalesLT.SalesOrderHeader soh
    WHERE soh.CustomerID = c.CustomerID
);

-- 3. Next query returns the product with the most recent productid and its category.
-- Add one line to the query so that PER CATEGORY the product with the most recent productid is returned.

SELECT 
    pc.Name			AS Categorie,
    p.Name			AS Product,
    p.ProductID		AS ProductID
FROM SalesLT.ProductCategory AS pc
INNER JOIN SalesLT.Product AS p
ON pc.ProductCategoryID = p.ProductCategoryID
WHERE p.ProductID = 
(
	SELECT MAX(ProductID)
	FROM SalesLT.Product
    WHERE ProductCategoryID = pc.ProductCategoryID
);

SELECT 
    pc.Name			AS Categorie,
    p.Name			AS Product,
    p.ProductID		AS ProductID
FROM SalesLT.ProductCategory AS pc
INNER JOIN SalesLT.Product AS p
ON pc.ProductCategoryID = p.ProductCategoryID
WHERE p.ProductID IN
(
	SELECT MAX(ProductID)
	FROM SalesLT.Product
    GROUP BY ProductCategoryID
);

-- -----------------------------------------------------------------------------

-- Explicite conversie
-- CAST vs CONVERT

SELECT CAST(CustomerID AS varchar) FROM SalesLT.Customer;
SELECT CONVERT(varchar, CustomerID) FROM SalesLT.Customer;
SELECT CONVERT(varchar, OrderDate, 105) FROM SalesLT.SalesOrderHeader;      -- optional magic number
SELECT FORMAT(OrderDate, 'dd-MMMM-yyyy') FROM SalesLT.SalesOrderHeader;     -- leesbaarder, maar trager, want CLR

-- -----------------------------------------------------------------------------

-- CASE vs IIF

SELECT DISTINCT title FROM SalesLT.Customer

-- Gebruik CASE om waardes in een kolom naar iets anders om te zetten
SELECT 
    CASE
        WHEN title IN ('Sr.', 'Mr.') THEN 'De heer'
        ELSE                              'Mevrouw'
    END AS aanspreektitel
    , title 
    , CompanyName
FROM SalesLT.Customer;

-- Bij een boolean expressie is IIF korter
-- IIF betekent Immediate IF:
-- IIF(boolean expressie, indien WAAR, indien ONWAAR)
SELECT 
    IIF (title IN ('Sr.', 'Mr.'), 'De heer', 'Mevrouw') AS aanspreektitel
    , title 
    , CompanyName
FROM SalesLT.Customer;

-- ------------------------------------------------------------------------

-- PIVOT

SELECT
    *
FROM SalesLT.CategoryQtyYearOrderID
PIVOT 
(
  SUM(Qty) FOR OrderYear IN 
  ([2024], [2025], [2026])
) AS pvt;

-- Dynamic SQL
--EXEC('SELECT * FROM SalesLT.Address')

SELECT DISTINCT QUOTENAME(Category) FROM SalesLT.CategoryQtyYear

GO

-- -------------------------------------------------------------

DECLARE @columns AS nvarchar(MAX) = N'';

WITH UniekeCategorieen AS
(
    SELECT DISTINCT Category
    FROM SalesLT.CategoryQtyYear
)
SELECT @columns += N', ' + QUOTENAME(Category)
FROM UniekeCategorieen;

SET @columns = RIGHT(@columns, LEN(@columns) - 2);
PRINT @columns;

DECLARE @sql AS nvarchar(MAX) = N'SELECT
    *
FROM SalesLT.CategoryQtyYear
PIVOT 
(
  SUM(Qty) FOR Category IN 
  (' + @columns + N')
) AS pvt;';

-- EXEC(@sql);                  -- onveilig!

EXEC sp_executesql @sql;        -- veiliger

-- ----------------------------------------------------------------------------
GO

DECLARE @columns AS nvarchar(MAX) = N'';

WITH UniekeCategorieen AS
(
    SELECT DISTINCT Category
    FROM SalesLT.CategoryQtyYear
)
SELECT @columns += N', ' + QUOTENAME(Category)
FROM UniekeCategorieen;

SET @columns = RIGHT(@columns, LEN(@columns) - 2);
PRINT @columns;

DECLARE @sql AS nvarchar(MAX) = N'SELECT
    *
FROM SalesLT.CategoryQtyYear
PIVOT 
(
  SUM(Qty) FOR Category IN 
  (' + @columns + N')
) AS pvt
WHERE OrderYear = @orderYear';


DECLARE @oy AS int = 2024;       -- voorbeeldjaar

EXEC sp_executesql 
    @sql,               -- de dynamische sql
    N'@orderYear int',  -- de definitie van de parameter
    @orderYear = @oy;  -- waarde toewijzing

-- ----------------------------------------------------------------------------
GO

CREATE OR ALTER PROCEDURE SalesLT.ToonsDraaitabel
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @columns AS nvarchar(MAX) = N'';

WITH UniekeCategorieen AS
(
    SELECT DISTINCT Category
    FROM SalesLT.CategoryQtyYear
)
SELECT @columns += N', ' + QUOTENAME(Category)
FROM UniekeCategorieen;

SET @columns = RIGHT(@columns, LEN(@columns) - 2);
PRINT @columns;

DECLARE @sql AS nvarchar(MAX) = N'SELECT
    *
FROM SalesLT.CategoryQtyYear
PIVOT 
(
  SUM(Qty) FOR Category IN 
  (' + @columns + N')
) AS pvt
WHERE OrderYear = @orderYear';


DECLARE @oy AS int = 2024;       -- voorbeeldjaar

EXEC sp_executesql 
    @sql,               -- de dynamische sql
    N'@orderYear int',  -- de definitie van de parameter
    @orderYear = @oy;  -- waarde toewijzing

END;

EXEC SalesLT.ToonsDraaitabel

-- ----------------------------------------------------------------------------
-- Declareren/Instantiëren van variabelen @Tim

--DECLARE @stukjeAchternaam AS varchar(50);
--SET @stukjeAchternaam = 'rr';

DECLARE @stukjeAchternaam AS varchar(50) = 'rr';

SELECT * FROM SalesLT.Customer WHERE LastName LIKE CONCAT('%', @stukjeAchternaam, '%')

PRINT @stukjeAchternaam;
GO

DECLARE @aantal AS int = 0;

SELECT @aantal = COUNT(*) FROM SalesLT.Customer WHERE LastName LIKE '%rr%';

PRINT CONCAT_WS(' ', 'Aantal is nu:', @aantal);



