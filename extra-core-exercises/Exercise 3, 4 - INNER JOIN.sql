/* =====================================================
   Core Querying Data with Transact-SQL

   Copyright
   © Info Support
   • All Rights Reserved •
   This data may not be copied or distributed without the
   prior approval of Info Support
   www.infosupport.com
   =================================================== */

/* 🌶 Exercise 3 - INNER JOIN */

/* 1. Write a query which retrieves information from the OrderHeader and OrderDetail tables in one result set:

      SalesOrderID  OrderDate                 SalesOrderDetailID  OrderQty    UnitPrice   ProductID
      71774         2008-06-01 00:00:00.000   110562              1           356,8980    836
      71774         2008-06-01 00:00:00.000   110563              1           356,8980    822
      ...           ...                       ...                 ...         ...         ...

      (result: 542 rows) */

/* 🌶🌶 Exercise 4 - INNER JOIN */

/* 1. Extend the query from the previous exercies. Instead of ProductID show the name of the product. 
      Use a clear field alias.
      (result: 542 rows) */


/* 2. Extend the query again. Add a column where the ProductDescription is shown. 
      Use the ER diagram to find out how this value can be retrieved.
      (result: 3246 rows) */
