USE adventureworks;
GO

-- Refresher

-- Subqueries:
-- Query tussen haakjes in de SELECT of WHERE
-- single value = subquery retourneert 1 resultaat (bijv. een MAX waarde of AVG waarde)
-- multi value = subquery retourneert 0, 1 of meerdere resultaten

-- self-contained = subquery die los als query gedraaid kan worden
-- correlated = subquery die input van de outer query krijgt

-- Subquery in the SELECT
SELECT
  [Name]
  , ListPrice
  , (
      SELECT AVG(ListPrice)
      FROM SalesLT.Product
    ) AS AvgListPrice
  , ListPrice - (SELECT AVG(ListPrice) FROM SalesLT.Product) AS [Difference]
FROM SalesLT.Product;

-- Correlated subquery
SELECT 
  o.CustomerID
  , o.OrderDate
FROM SalesLT.SalesOrderHeader AS o
WHERE o.SalesOrderID =
(
  SELECT 
    MIN(SalesOrderID)
  FROM SalesLT.SalesOrderHeader
  WHERE CustomerID = o.CustomerID
);

-- --------------------------------------------------------------------------

-- Lab 1: 
/* 1. Every product in the database has a related ProductModel. 
      Sometimes there are multiple products related to the same model.
      This usually occurs when there are different sizes available.
      Write a query to identify ProductModels with more than 3 attached products. 
      Show the ProductModel name as well as the count of related products. 
      Sort results on most related products.
      (result: 27 rows) */

SELECT 
   pm.Name
   , COUNT(*) AS RelatedProducts
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductModel AS pm 
ON p.ProductModelID = pm.ProductModelID
GROUP BY pm.Name
HAVING COUNT(*) > 3
ORDER BY RelatedProducts DESC;

/* 2. Your colleagues don't like the color blue, you'll have to extend the previous query.
      Filter out any products with the color blue as well as products of unknown color.
      Also include some calculations: average weight, maximum listprice and total costs.
      (result: 26 rows) */

SELECT 
   pm.Name
   , COUNT(*) AS RelatedProducts
   , AVG(p.Weight) AS AverageWeight
   , MAX(p.ListPrice) AS MaximumListPrice
   , SUM(p.StandardCost) AS TotalCosts
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID
WHERE p.Color <> 'Blue'
AND p.Color IS NOT NULL
GROUP BY pm.Name
HAVING COUNT(*) > 3
ORDER BY RelatedProducts DESC;

/* 3. Your colleagues would also like to know how many related products are no longer sold.
    Add a column that shows the number of related products with a SellEndDate 
    (effectively no longer sold).
    Add another column calculating the percentage of products no longer sold. 
    Show this percentage with 1 decimal. 
    (result: 26 rows) */

SELECT 
   pm.Name
   , COUNT(*) AS RelatedProducts
   , COUNT(p.SellEndDate) AS ProductsNotSold
   , CAST(
      COUNT(p.SellEndDate) / (COUNT(*) * .01) AS decimal(4,1)
     ) AS PercentageNotSold
   , AVG(p.Weight) AS AverageWeight
   , MAX(p.ListPrice) AS MaximumListPrice
   , SUM(p.StandardCost) AS TotalCosts
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID
WHERE p.Color <> 'Blue' AND p.Color IS NOT NULL
GROUP BY pm.Name
HAVING COUNT(*) > 3
ORDER BY RelatedProducts DESC;


-- Conversion
SELECT SYSDATETIME() FROM SalesLT.Address;      -- Now
SELECT 'aard' + 'bei' FROM SalesLT.Address;     -- varchar + varchar = varchar

-- Implicit conversion smallint -> money:
-- smallint * money -> money * money = money
SELECT OrderQty * UnitPrice FROM SalesLt.SalesOrderDetail;

-- Explicit conversion datetime2 -> varchar
-- varchar + datetime2 -> datetime2 + datetime = ERROR
SELECT 'KvL ' + CAST(SYSDATETIME() AS varchar) + DB_NAME(), * FROM SalesLT.Address

-- Gebruik CONCAT(), deze converteert alles naar een varchar on the fly:
SELECT CONCAT('KvL', SYSDATETIME(), DB_NAME()), * FROM SalesLT.Address 
SELECT CONCAT_WS(',', 'KvL', SYSDATETIME(), DB_NAME()), * FROM SalesLT.Address; 

-- -------------------------------------------------------------------------------
GO

-- 1. VIEW
CREATE OR ALTER VIEW SalesLT.DatIsEenGoedeVraag
AS
SELECT 
   pm.Name
   , COUNT(*) AS RelatedProducts
   , AVG(p.Weight) AS AverageWeight
   , MAX(p.ListPrice) AS MaximumListPrice
   , SUM(p.StandardCost) AS TotalCosts
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID
WHERE p.Color <> 'Blue'
AND p.Color IS NOT NULL
GROUP BY pm.Name
HAVING COUNT(*) > 3
-- ORDER BY RelatedProducts DESC;

GO

-- Gebruik VIEW in query
SELECT * FROM SalesLT.DatIsEenGoedeVraag
WHERE Name LIKE '%frame%';

GO

CREATE OR ALTER VIEW SalesLT.OverviewForNameContainingFrame
AS
SELECT 
   pm.Name
   , COUNT(*) AS RelatedProducts
   , AVG(p.Weight) AS AverageWeight
   , MAX(p.ListPrice) AS MaximumListPrice
   , SUM(p.StandardCost) AS TotalCosts
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductModel AS pm
ON p.ProductModelID = pm.ProductModelID
WHERE p.Color <> 'Blue'
AND p.Color IS NOT NULL
AND p.Name LIKE '%frame%'
GROUP BY pm.Name
HAVING COUNT(*) > 3;
GO

-- ------------------------------------------------------------------------------------

-- TABLE VALUED FUNCTION (TVF)
-- FUNCTION die een TABLE retourneert, een soort View met parameter(s):
CREATE OR ALTER FUNCTION SalesLT.OverviewForNameContainingN(@stukjeNaam AS nvarchar(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
       pm.Name
       , COUNT(*) AS RelatedProducts
       , AVG(p.Weight) AS AverageWeight
       , MAX(p.ListPrice) AS MaximumListPrice
       , SUM(p.StandardCost) AS TotalCosts
    FROM SalesLT.Product AS p
    INNER JOIN SalesLT.ProductModel AS pm
    ON p.ProductModelID = pm.ProductModelID
    WHERE p.Color <> 'Blue'
    AND p.Color IS NOT NULL
    AND p.Name LIKE CONCAT('%',@stukjeNaam,'%')
    GROUP BY pm.Name
    HAVING COUNT(*) > 3
);
GO

-- Gebruik TABLE VALUED FUNCTION (TVF)
SELECT * FROM SalesLT.OverviewForNameContainingN(N'road');

-- ------------------------------------------------------------------------------------
GO

-- CROSS APPLY (en OUTER APPLY)
CREATE OR ALTER FUNCTION Top3HeavyProductsByCategoryID
    (@ProductCategoryId AS int)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP (3) WITH TIES
        * 
    FROM SalesLT.Product
    WHERE ProductCategoryID = @ProductCategoryId
    ORDER BY Weight DESC
);
GO

-- We gebruiken APPLY als we een tabel of view willen 'joinen' met een TVF.

-- CROSS APPLY ~ INNER JOIN
SELECT 
    * 
FROM SalesLT.ProductCategory AS pc
CROSS APPLY Top3HeavyProductsByCategoryID(pc.ProductCategoryID);

-- Voeg een categorie zonder producten toe, deze categorie willen we straks óók ophalen:
INSERT INTO SalesLT.ProductCategory
(ParentProductCategoryID, Name)
VALUES
(2, 'Snoep');

-- OUTER APPLY ~ LEFT OUTER JOIN
SELECT 
    * 
FROM SalesLT.ProductCategory AS pc
CROSS APPLY Top3HeavyProductsByCategoryID(pc.ProductCategoryID);

-- -------------------------------------------------------------

-- 3. Derived Table (Subquery achter de FROM)
SELECT 
    LEN(dummy.Address) AS LengteAddress
    , COUNT(*) AS Aantal
FROM
(
    SELECT 
       c.CompanyName
       , COALESCE(a.AddressLine1, a.AddressLine2, a.City) AS Address
    FROM SalesLT.Customer AS c
    INNER JOIN SalesLT.CustomerAddress AS ca
    ON c.CustomerID = ca.CustomerID
    INNER JOIN SalesLT.Address AS a
    ON ca.AddressID = a.AddressID
) AS dummy
GROUP BY LEN(dummy.Address)
HAVING COUNT(*) >= 25
ORDER BY Aantal DESC;

-- ------------------------------------------------------------------------

-- 4. Common Table Expression (CTE)
WITH dummy AS
(
    SELECT 
       c.CompanyName
       , COALESCE(a.AddressLine1, a.AddressLine2, a.City) AS Address
    FROM SalesLT.Customer AS c
    INNER JOIN SalesLT.CustomerAddress AS ca
    ON c.CustomerID = ca.CustomerID
    INNER JOIN SalesLT.Address AS a
    ON ca.AddressID = a.AddressID
)
SELECT 
    LEN(d.Address) AS LengteAddress
    , COUNT(*) AS Aantal
FROM dummy AS d
GROUP BY LEN(d.Address)
HAVING COUNT(*) >= 25
ORDER BY Aantal DESC;

-- ------------------------------------------------------------------------


