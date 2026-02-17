/* =====================================================
   Core Querying Data with Transact-SQL

   Copyright
   © Info Support
   • All Rights Reserved •
   This data may not be copied or distributed without the
   prior approval of Info Support
   www.infosupport.com
   =================================================== */

/* 🌶 Exercise 1 - Filter with WHERE */

/* 1. Write a query which retrieves all rows and fields from SalesLT.Product.
      (result: 295 rows) */

SELECT 
  *
FROM SalesLT.Product;

/* 2. Add a filter: only retrieve products where StandardCost is higher than 500.
      (result: 86 rows) */

SELECT 
  * 
FROM SalesLT.Product
WHERE StandardCost > 500;

/* 3. Add another filter: only red products. 
      (result: 20 rows) */

SELECT 
  * 
FROM SalesLT.Product
WHERE StandardCost > 500
AND color = 'Red';

/* 4. Add another filter: ProductNumber should start with 'BK'.
      (result: 14 rows) */

SELECT 
    * 
FROM SalesLT.Product
WHERE StandardCost > 500
AND color = 'Red'
AND ProductNumber LIKE 'BK%';

/* 5. Extend previous filter: 
      Retrieve products where ProductNumber starts with 'BK' and the product with ProductID 717.
      (result: 15 rows) */

SELECT 
    * 
FROM SalesLT.Product
WHERE StandardCost > 500
AND color = 'Red'
AND (ProductNumber LIKE 'BK%'
OR ProductID = 717);

/* 6. Sort the result. ListPrice with highest value on top. */

SELECT 
  * 
FROM SalesLT.Product
WHERE StandardCost > 500
AND color = 'Red'
AND (ProductNumber LIKE 'BK%'
OR ProductID = 717)
ORDER BY ListPrice DESC;


/* 🌶🌶 Exercise 2 - Filter with WHERE */

/* 1. Write a query on the Customer table which retrieves all female customers.
      Tip: start writing another query retrieving all unique values for Title.
      (result: 344 rows) */

SELECT 
    * 
FROM SalesLT.Customer
WHERE title IN ('Sra.', 'Ms.');

/* 2. Add another filter: the SalesPerson should be one of three:
      david8, garrett1, pamela0
      (result: 93 rows) */

SELECT 
    * 
FROM SalesLT.Customer
WHERE title IN ('Sra.', 'Ms.')
AND SalesPerson IN ('adventure-works\david8', 'adventure-works\garrett1', 'adventure-works\pamela0');

/* 3. Add another filter: the CompanyName must contain the string 'bike' or 'cycle' 
      (result 42 rows) */

SELECT 
    * 
FROM SalesLT.Customer
WHERE title IN ('Sra.', 'Ms.')
AND SalesPerson IN ('adventure-works\david8', 'adventure-works\garrett1', 'adventure-works\pamela0')
AND (CompanyName LIKE '%bike%' OR CompanyName LIKE '%cycle%');

/* 4. Add another filter: MiddleName shouldn't be NULL
      (result 34 rows) */

SELECT 
    * 
FROM SalesLT.Customer
WHERE title IN ('Sra.', 'Ms.')
AND SalesPerson IN ('adventure-works\david8', 'adventure-works\garrett1', 'adventure-works\pamela0')
AND (CompanyName LIKE '%bike%' OR CompanyName LIKE '%cycle%')
AND MiddleName IS NOT NULL;

/* 5. Sort the result on SalesPerson (A-Z), 
      use as second sorting column ModifiedDate (most recent on top). */

SELECT * FROM SalesLT.Customer
WHERE title IN ('Sra.', 'Ms.')
AND SalesPerson IN ('adventure-works\david8', 'adventure-works\garrett1', 'adventure-works\pamela0')
AND (CompanyName LIKE '%bike%' OR CompanyName LIKE '%cycle%')
AND MiddleName IS NOT NULL
ORDER BY SalesPerson ASC, ModifiedDate DESC;