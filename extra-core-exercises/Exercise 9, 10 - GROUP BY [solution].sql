/* =====================================================
   Core Querying Data with Transact-SQL

   Copyright
   © Info Support
   • All Rights Reserved •
   This data may not be copied or distributed without the
   prior approval of Info Support
   www.infosupport.com
   =================================================== */

/* 🌶 Exercise 9 - GROUP BY */

/* 1. Use the table Customer. Write a query which retrieves per SalesPerson the number of customers. 
      Use a COUNT(*) and GROUP BY. (result: 9 rows) */

SELECT 
    SalesPerson
    , COUNT(*)      AS count
FROM SalesLT.Customer
GROUP BY SalesPerson;

/* 2. How often is each Title used? Write a new query to answer that.
      (result: 5 rows) */

SELECT 
    Title
    , COUNT(*)      AS count
FROM SalesLT.Customer
GROUP BY Title;

/* 3. How often is each Suffix used? Write a new query.
      (result: 6 rows) */

SELECT 
    Suffix
    , COUNT(*) 
FROM SalesLT.Customer
GROUP BY Suffix;

/* 4. How often is each combination Title, Suffix used? Write a new query.
      (result: 10 rows) */

SELECT 
    Title
    , Suffix
    , COUNT(*) 
FROM SalesLT.Customer
GROUP BY 
    Title
    , Suffix;

/* 🌶🌶  Exercise 10 - GROUP BY */

/* 1. Get a list on how often each Color is used in the table Product.
      (result: 10 rows) */

SELECT 
    color
    , COUNT(*) 
FROM SalesLT.Product
GROUP BY color;

/* 2. Retrieve this resultset:
      
      ProductCategoryID   count  most_expensive_price   cheapest_price  avg_price
      5                   32     3399,9900              539,9900        1683,3650
      6                   43     3578,2700              539,9900        1597,4500
      ...                 ...    ...                    ...             ...

      (result: 37 rows) */

SELECT
    ProductCategoryID
    , COUNT(*)          AS count
    , MAX(ListPrice)    AS most_expensive_price
    , MIN(ListPrice)    AS cheapest_price
    , AVG(ListPrice)    AS avg_price
FROM SalesLT.Product
GROUP BY ProductCategoryID;

/* 3. Copy paste the previous query. 
      Update the query to show the ProductCategoryName instead of ProductCategoryID
      (result: 37 rows)
*/

SELECT
    pc.Name
    , COUNT(*)          AS count
    , MAX(p.ListPrice)    AS most_expensive_price
    , MIN(p.ListPrice)    AS cheapest_price
    , AVG(p.ListPrice)    AS avg_price
FROM SalesLT.Product AS p
INNER JOIN SalesLT.ProductCategory AS pc
ON p.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name;
