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

/* 2. Add a filter: only retrieve products where StandardCost is higher than 500.
      (result: 86 rows) */

/* 3. Add another filter: only red products. 
      (result: 20 rows) */

/* 4. Add another filter: ProductNumber should start with 'BK'.
      (result: 14 rows) */

/* 5. Extend previous filter: 
      Retrieve products where ProductNumber starts with 'BK' and the product with ProductID 717.
      (result: 15 rows) */

/* 6. Sort the result. ListPrice with highest value on top. */


/* 🌶🌶 Exercise 2 - Filter with WHERE */

/* 1. Write a query on the Customer table which retrieves all female customers.
      Tip: start writing another query retrieving all unique values for Title.
      (result: 344 rows) */

/* 2. Add another filter: the SalesPerson should be one of three:
      david8, garrett1, pamela0
      (result: 93 rows) */

/* 3. Add another filter: the CompanyName must contain the string 'bike' or 'cycle' 
      (result 42 rows) */

/* 4. Add another filter: MiddleName shouldn't be NULL
      (result 34 rows) */

/* 5. Sort the result on SalesPerson (A-Z), 
      use as second sorting column ModifiedDate (most recent on top). */