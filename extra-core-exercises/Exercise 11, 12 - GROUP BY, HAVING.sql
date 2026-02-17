/* =====================================================
   Core Querying Data with Transact-SQL

   Copyright
   © Info Support
   • All Rights Reserved •
   This data may not be copied or distributed without the
   prior approval of Info Support
   www.infosupport.com
   =================================================== */

/* 🌶 Exercise 11 - GROUP BY, HAVING */

/* 1. Use the table Customer.
      Retrieve per SalesPerson the number of customers where this is at least 140 customers
      (result: 3 rows) */

/* 2. Copy paste the previous query. 
      Now filter out the companies: 'Greater Bike Store', 'Metro Manufacturing' and 'Corner Bicycle Supply'.ABORT
      (result: 2 rows) */

/* 3. Write a brand new query using the table Customer.
      Show middle names (excluding NULL values) which occur at least 25 times, highest count on top:

      MiddleName  count
      J.          112
      M.          75
      ...         ...
      E.          25

      (result: 8 rows)
*/


/* 🌶🌶 Exercise 12 - GROUP BY, HAVING */

/* 1. Use the table SalesOrderDetail to retrieve these details:

      SalesOrderID    total
      71784           89869,2764
      71936           79589,616
      71938           74160,228
      71783           65683,3681
      71797           65123,4635
      71902           59894,2092

      Requirements:
      * DON'T USE the existing LineTotal column!
      * Exclude orders with a SalesOrderID less than 71780.
      * Only show orders with a total of at least 55000. Highest on top.
*/
