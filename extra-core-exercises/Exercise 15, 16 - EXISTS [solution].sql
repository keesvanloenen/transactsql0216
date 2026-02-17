/* =====================================================
   Core Querying Data with Transact-SQL

   Copyright
   © Info Support
   • All Rights Reserved •
   This data may not be copied or distributed without the
   prior approval of Info Support
   www.infosupport.com
   =================================================== */

/* 🌶🌶🌶 Exercise 15 - EXISTS */

/* 1. Write a JOIN query to retrieve ProductID and ThumbNailPhoto from Product 
      where the Productcategory contains either 'Caps' or 'Bib'.
      (result: 4 rows) */

SELECT
    p.ProductID
    , p.ThumbNailPhoto
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductCategory AS pc
ON p.ProductCategoryID = pc.ProductCategoryID
WHERE pc.[Name] LIKE '%Caps%' 
OR pc.[Name] LIKE '%Bib%';

/* 2. Copy paste the previous query. 
      Then rewrite the query to a solution with a selfcontained, multivalued subquery.
      (result: 4 rows) */

SELECT 
    p.ProductID
    , p.ThumbNailPhoto
FROM SalesLT.Product AS p
WHERE p.ProductCategoryID IN
(
    SELECT 
        ProductCategoryID
    FROM SalesLT.ProductCategory
    WHERE 
    (
        [Name] LIKE '%Caps%' 
        OR [Name] LIKE '%Bib%'
    )
);

/* 3. Copy paste the previous query.
      Then rewrite the query to a solution with a correlated subquery and EXISTS.
      (result: 4 rows) */

SELECT 
    p.ProductID
    , p.ThumbNailPhoto
FROM SalesLT.Product AS p
WHERE EXISTS
(
    SELECT 
        1
    FROM SalesLT.ProductCategory
    WHERE 
    (
        [Name] LIKE '%Caps%' 
        OR [Name] LIKE '%Bib%'
    )
    AND ProductCategoryID = p.ProductCategoryID
);


/* 🌶🌶🌶 Exercise 16 - EXISTS */

/* 1. Use the tables SalesOrderHeader and Customer to retrieve all orders 
      where the customer's CompanyName is 'Channel Outlet'. Use EXISTS.
      (result: 1 row) */

SELECT 
    * 
FROM SalesLT.SalesOrderHeader AS h
WHERE EXISTS
(
    SELECT 
        1
    FROM SalesLT.Customer 
    WHERE CompanyName = 'Channel Outlet'
    AND CustomerID = h.CustomerID
);

/* 2. Use the tables Product and SalesOrderDetail to retrieve product names 
      which are used in more than 5 orders. Again, use EXISTS.
      (result: 28 rows) */

SELECT 
    p.Name
FROM SalesLT.Product AS p
WHERE EXISTS
(
    SELECT 
        COUNT(*)
    FROM SalesLT.SalesOrderDetail
    WHERE ProductID = p.ProductID
    GROUP BY ProductID
    HAVING COUNT(*) > 5
);
