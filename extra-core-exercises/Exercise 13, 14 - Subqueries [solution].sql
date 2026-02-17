/* =====================================================
   Core Querying Data with Transact-SQL

   Copyright
   © Info Support
   • All Rights Reserved •
   This data may not be copied or distributed without the
   prior approval of Info Support
   www.infosupport.com
   =================================================== */

/* 🌶 Exercise 13 - Subqueries */

/* 1. Write a solution with a subquery to show ALL fields from the most recent order.
      Use the table SalesOrderDetail.
      (result: 1 row) */

SELECT 
    * 
FROM SalesLT.SalesOrderDetail
WHERE SalesOrderID = 
(
    SELECT
        MAX(SalesOrderID)
    FROM SalesLT.SalesOrderDetail
);

/* 2. Write a solution with a subquery to show the Name and ListPrice of products,
      where ListPrice is greater than the average ListPrice. Use the table Product.
      (result: 102 rows) */

SELECT 
    [Name]
    , ListPrice
FROM SalesLT.Product
WHERE ListPrice >
(
    SELECT AVG(ListPrice)
    FROM SalesLT.Product
);

/* 3. Copy paste the previous query and add a column AvgListPrice.
      (result: 102 rows) */

SELECT 
    [Name]
    , ListPrice
    , (
        SELECT AVG(ListPrice)
        FROM SalesLT.Product
      ) AS AvgListPrice
FROM SalesLT.Product
WHERE ListPrice >
(
    SELECT AVG(ListPrice)
    FROM SalesLT.Product
);

/* 4. Copy paste the previous query and add a column DifferentFromAverage containing
      the difference between the ListPrice and the AvgListPrice.
      (result: 102 rows) */

SELECT 
    [Name]
    , ListPrice
    , (
        SELECT AVG(ListPrice)
        FROM SalesLT.Product
      ) AS AvgListPrice
    , ListPrice -
      (
        SELECT AVG(ListPrice)
        FROM SalesLT.Product
      )
FROM SalesLT.Product
WHERE ListPrice >
(
    SELECT AVG(ListPrice)
    FROM SalesLT.Product
);

/* 🌶🌶 Exercise 14 - Subqueries */

/* 1. Querying the tables SalesLT.ProductCategory and SalesLT.Product, 
      retrieve a list of Product Name and Color where the ProductCategory Name doesn't contain 'Bikes'.
      Write 2 solutions: one with a JOIN, the other with a subquery.
      (result: 198 rows)
*/

SELECT 
   p.[Name]
   , Color
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductCategory AS pc
ON p.ProductCategoryID = pc.ProductCategoryID
WHERE pc.[Name] NOT LIKE '%Bikes%';

SELECT 
   [Name]
   , Color
FROM SalesLT.Product
WHERE ProductCategoryID IN
(
    SELECT 
        ProductCategoryID
    FROM SalesLT.ProductCategory
    WHERE [Name] NOT LIKE '%Bikes%'
);
