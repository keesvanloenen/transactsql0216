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
