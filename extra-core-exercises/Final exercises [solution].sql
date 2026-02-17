/* =====================================================
   Core Querying Data with Transact-SQL

   Copyright
   © Info Support
   • All Rights Reserved •
   This data may not be copied or distributed without the
   prior approval of Info Support
   www.infosupport.com
   =================================================== */

/* Final Exercises */

/* --------------------------------------------------------------------------------------
  Exercise 1
  Step-by-step exercise to retrieve all the orders with a large order quantity and 
  a low average sales amount per product. 
  In general, the previous step is needed to create the code of the next step. Good luck!
  --------------------------------------------------------------------------------------- */

/* 1. Select the top 1000 rows of the sales orders table in the database adventureworks. (hint: use the SalesOrderHeader table in the SalesLT schema) */

USE [adventureworks]
GO

SELECT TOP (1000) [SalesOrderID]
  , [RevisionNumber]
  , [OrderDate]
  , [DueDate]
  , [ShipDate]
  , [Status]
  , [OnlineOrderFlag]
  , [SalesOrderNumber]
  , [PurchaseOrderNumber]
  , [AccountNumber]
  , [CustomerID]
  , [ShipToAddressID]
  , [BillToAddressID]
  , [ShipMethod]
  , [CreditCardApprovalCode]
  , [SubTotal]
  , [TaxAmt]
  , [Freight]
  , [TotalDue]
  , [Comment]
  , [rowguid]
  , [ModifiedDate]
FROM [SalesLT].[SalesOrderHeader];

/* 2. Select all rows (hint: use a *) of the sales order table. Add all address information to these sales orders using a join on the ShipToAddress. Give the tables aliases and use these aliases in the join clause. */

SELECT 
  *
FROM [SalesLT].[SalesOrderHeader] AS soh
INNER JOIN [SalesLT].[Address] AS a 
ON a.AddressID = soh.ShipToAddressID;


/* 3. Select only the sales order that are shipped to the United States. */

SELECT 
  *
FROM [SalesLT].[SalesOrderHeader] AS soh
INNER JOIN [SalesLT].[Address] AS a 
ON a.AddressID = soh.ShipToAddressID
WHERE CountryRegion = 'United States';


/* 4. Add the names of the customers to the above table. Only show the sales order number, the first name of the customer, the last name of the customer and their title. */
 
SELECT 
  soh.SalesOrderNumber
  , c.FirstName
  , c.LastName
  , c.Title
FROM [SalesLT].[SalesOrderHeader] AS soh
INNER JOIN [SalesLT].[Customer] AS c ON soh.CustomerID = c.CustomerID
INNER JOIN [SalesLT].[Address] AS a ON a.AddressID = soh.ShipToAddressID
WHERE CountryRegion = 'United States';


/* 5. Create an new column that combines the title of the customer with the full name of the customer. (eg. Mr. John Johnson).  Do not show the original columns of the customer table. */

SELECT 
  soh.SalesOrderNumber
  , c.Title + ' ' +  c.FirstName + ' ' + c.LastName AS TitleName
FROM [SalesLT].[SalesOrderHeader] AS soh
INNER JOIN [SalesLT].[Customer] AS c ON soh.CustomerID = c.CustomerID
INNER JOIN [SalesLT].[Address] AS a ON a.AddressID = soh.ShipToAddressID
WHERE CountryRegion = 'United States';

-- Or alternatively using the CONCAT function:
SELECT 
  soh.SalesOrderNumber
  , CONCAT(c.Title, ' ', c.FirstName, ' ', c.LastName) AS TitleName
FROM [SalesLT].[SalesOrderHeader] AS soh
INNER JOIN [SalesLT].[Customer] AS c ON soh.CustomerID = c.CustomerID
INNER JOIN [SalesLT].[Address] AS a ON a.AddressID = soh.ShipToAddressID
WHERE CountryRegion = 'United States';

-- Or even more clean with the CONCAT_WS function: 
SELECT 
  soh.SalesOrderNumber
  , CONCAT_WS(' ', c.Title, c.FirstName, c.LastName) AS TitleName
FROM [SalesLT].[SalesOrderHeader] AS soh
INNER JOIN [SalesLT].[Customer] AS c ON soh.CustomerID = c.CustomerID
INNER JOIN [SalesLT].[Address] AS a ON a.AddressID = soh.ShipToAddressID
WHERE CountryRegion = 'United States';

/* 6. Add the total amount that the customer spent. Use the LineTotal from the SalesOrderDetail table. Remember the ‘GROUP BY’ clause when using an aggregate. */

SELECT 
	soh.SalesOrderNumber
	, c.Title + ' ' +  c.FirstName + ' ' + c.LastName AS TitleName
	, SUM(sod.LineTotal) AS OrderTotal 
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.Customer AS c ON soh.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS sod ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN [SalesLT].[Address] AS a ON a.AddressID = soh.ShipToAddressID
WHERE CountryRegion = 'United States'
GROUP BY 
  soh.SalesOrderNumber
  , c.Title + ' ' +  c.FirstName + ' ' + c.LastName;

/* 7. Add also the total quantity that a customer purchased and the average amount per product. */

SELECT 
  soh.SalesOrderNumber
  , c.Title + ' ' +  c.FirstName + ' ' + c.LastName AS TitleName
  , SUM(sod.LineTotal) AS OrderTotal 
  , AVG(sod.LineTotal) AS OrderAVG
  , SUM(sod.OrderQty) AS QuantityTotal
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.Customer AS c ON soh.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS sod ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN [SalesLT].[Address] AS a ON a.AddressID = soh.ShipToAddressID
WHERE CountryRegion = 'United States'
GROUP BY 
  soh.SalesOrderNumber
  , c.Title + ' ' +  c.FirstName + ' ' + c.LastName;

/* 8. Only show the orders that sold at least 20 products to a customer. */

SELECT 
  soh.SalesOrderNumber
  , c.Title + ' ' +  c.FirstName + ' ' + c.LastName AS TitleName
  , SUM(sod.LineTotal) AS OrderTotal 
  , AVG(sod.LineTotal) AS OrderAVG
  , SUM(sod.OrderQty) AS QuantityTotal
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.Customer AS c ON soh.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS sod ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN [SalesLT].[Address] AS a ON a.AddressID = soh.ShipToAddressID
WHERE CountryRegion = 'United States'
GROUP BY 
  soh.SalesOrderNumber
  , c.Title + ' ' +  c.FirstName + ' ' + c.LastName
HAVING SUM(sod.OrderQty) >= 20;

/* 9. Show the subset of these orders that has an average amount per product less than 1000. */

SELECT 
	soh.SalesOrderNumber
	, c.Title + ' ' +  c.FirstName + ' ' + c.LastName AS TitleName
	, SUM(sod.LineTotal) AS OrderTotal 
	, AVG(sod.LineTotal) AS OrderAVG
	, SUM(sod.OrderQty) AS QuantityTotal
FROM SalesLT.SalesOrderHeader AS soh
INNER JOIN SalesLT.Customer AS c ON soh.CustomerID = c.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS sod ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN [SalesLT].[Address] AS a ON a.AddressID = soh.ShipToAddressID
WHERE CountryRegion = 'United States'
GROUP BY 
  soh.SalesOrderNumber
  , c.Title + ' ' +  c.FirstName + ' ' + c.LastName
HAVING 
  SUM(sod.OrderQty) >= 20
  AND AVG(sod.LineTotal) < 1000;

/* --------------------------------------------------------------------------------------
  Exercise 2
  Step-by-step exercise to show the most popular products that were sold.
  In general, the previous step is needed to create the code of the next step. Good luck!
  --------------------------------------------------------------------------------------- */

/* 1. Select all rows (hint: use a *) of the product table. */

SELECT 
  *
FROM SalesLT.Product;

/* 2. Add the product category table to the product table. Make sure that all product categories are shown even if a product category is not coupled to a product. Give the tables aliases and use these aliases in the join clause. */

SELECT 
  *
FROM SalesLT.Product AS p 
RIGHT OUTER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID;

/* 3. Add the parent product category to the previous table. Make sure that all parent product categories are shown even if the parent product category is a NULL value in the previous table. Again, use an alias. */

SELECT 
  *
FROM SalesLT.Product AS p 
RIGHT OUTER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
LEFT OUTER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID;

/* 4. Only show the columns product name, the product category and the parent product category. */

SELECT 
  p.Name AS ProductName
  , pc.name AS CategoryName
  , ppc.name AS ParentCategoryName
FROM SalesLT.Product AS p 
RIGHT OUTER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
LEFT OUTER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID;

/* 5. Some categories don’t have a parent category. Replace these ‘empty’ values with: ‘The category is already the parent’. Use a CASE statement. */

SELECT 
  p.Name AS ProductName
  , pc.name AS CategoryName
  , CASE
      WHEN ppc.Name IS NULL THEN  'The category is already the parent'
      ELSE                        ppc.Name 
    END AS ParentCategoryName
FROM SalesLT.Product AS p 
RIGHT OUTER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
LEFT OUTER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID;

-- There are alternative options instead of using a CASE statement:
--   IIF(ppc.[name] IS NULL, 'category already the parent', ppc.[name])
--   ISNULL(ppc.[name], 'category already the parent')
--   COALESCE(ppc.[name], 'category already the parent')

/* 6. Return only the rows that contain the word ‘bike’ somewhere in the category name. */

SELECT 
  p.Name AS ProductName
  , pc.name AS CategoryName
  , CASE
      WHEN ppc.Name IS NULL THEN  'The category is already the parent'
    ELSE                          ppc.Name 
    END AS ParentCategoryName
FROM SalesLT.Product AS p 
RIGHT OUTER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
LEFT OUTER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID
WHERE pc.Name LIKE '%bike%';

/* 7. Retrieve the Sellstartdate and show in the format 'month spelled out Year' (eg. October 2020). Make sure it creates a date (using format), not a string. */

SELECT 
  p.Name AS ProductName
  , pc.name AS CategoryName
  , CASE
      WHEN ppc.Name IS NULL THEN  'The category is already the parent'
      ELSE                        ppc.Name 
      END AS ParentCategoryName
    , FORMAT(p.SellStartDate, 'MMMM yyyy') AS StartSellDate
FROM SalesLT.Product AS p 
RIGHT OUTER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
LEFT OUTER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID
WHERE pc.Name LIKE '%bike%';

/* 8. Use a subquery in the SELECT clause to get the total quantity sold per product. */

SELECT 
  p.Name AS ProductName
  , pc.name AS CategoryName
  , CASE
    WHEN ppc.Name IS NULL THEN  'The category is already the parent'
    ELSE                        ppc.Name 
    END AS ParentCategoryName
  , FORMAT(p.SellStartDate, 'MMMM yyyy') AS StartSellDate
  , (
      SELECT SUM(sod.OrderQty)
      FROM [SalesLT].[SalesOrderDetail] AS sod
      WHERE sod.ProductID = p.ProductID
    ) AS SoldTotal
FROM SalesLT.Product AS p 
RIGHT OUTER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
LEFT OUTER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID
WHERE pc.Name LIKE '%bike%';

/* 9. Use a subquery in the WHERE clause to filter the products that have an actual sale. (eg. the quantity sold is not null). Make this happen using the EXISTS operator. */

SELECT 
  p.Name AS ProductName
  , pc.name AS CategoryName
  , CASE
    WHEN ppc.Name IS NULL THEN  'The category is already the parent'
    ELSE                        ppc.Name 
    END AS ParentCategoryName
  , FORMAT(p.SellStartDate, 'MMMM yyyy') AS StartSellDate
  , (
      SELECT SUM(sod.OrderQty)
      FROM [SalesLT].[SalesOrderDetail] AS sod
      WHERE sod.ProductID = p.ProductID
      ) AS SoldTotal
FROM SalesLT.Product AS p 
RIGHT OUTER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
LEFT OUTER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID
WHERE 
  pc.Name LIKE '%bike%'
  AND EXISTS 
  (
    SELECT 1
    FROM SalesLT.SalesOrderDetail AS sod
    WHERE sod.ProductID = p.ProductID
  );

-- Note:
-- We use 'SELECT 1' in the subquery in the WHERE clause. 
-- It's also possible to use 'SELECT *'. 
-- It's not recommended to use 'SELECT sod.OrderQty'. 
-- SQL server does not have to collect the values of this column when using '1' or '*'. 

/* 10. Show the results from most popular item to least sold item. */

SELECT 
  p.Name AS ProductName
  , pc.name AS CategoryName
  , CASE
    WHEN ppc.Name IS NULL THEN  'The category is already the parent'
    ELSE                        ppc.Name 
    END AS ParentCategoryName
  , FORMAT(p.SellStartDate, 'MMMM yyyy') AS StartSellDate
  , (
      SELECT SUM(sod.OrderQty)
      FROM [SalesLT].[SalesOrderDetail] AS sod
      WHERE sod.ProductID = p.ProductID
    ) AS SoldTotal
FROM SalesLT.Product AS p 
RIGHT OUTER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
LEFT OUTER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID
WHERE 
  pc.Name LIKE '%bike%'
  AND EXISTS 
  (
    SELECT 1
    FROM SalesLT.SalesOrderDetail AS sod
    WHERE sod.ProductID = p.ProductID
  )
ORDER BY SoldTotal DESC;

/* 11. We are only interested in the top 22 percent sold products. Show the results. */

SELECT TOP 22 PERCENT
  p.Name AS ProductName
  , pc.name AS CategoryName
  , CASE
    WHEN ppc.Name IS NULL THEN  'The category is already the parent'
    ELSE                        ppc.Name 
    END AS ParentCategoryName
    , FORMAT(p.SellStartDate, 'MMMM yyyy') AS StartSellDate
, (
      SELECT SUM(sod.OrderQty)
      FROM [SalesLT].[SalesOrderDetail] AS sod
      WHERE sod.ProductID = p.ProductID
  ) AS SoldTotal
FROM SalesLT.Product AS p 
RIGHT OUTER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
LEFT OUTER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID
WHERE 
  pc.Name LIKE '%bike%'
  AND EXISTS 
  (
    SELECT 1
    FROM SalesLT.SalesOrderDetail AS sod
    WHERE sod.ProductID = p.ProductID
  )
ORDER BY SoldTotal DESC;

/* 12. We see that only one of the two products that sold a total of 17 units are shown in the previous query. 
       Show both products using the keyword 'TIES'. */

SELECT TOP 22 PERCENT WITH TIES
  p.Name AS ProductName
  , pc.name AS CategoryName
  , CASE
    WHEN ppc.Name IS NULL THEN  'The category is already the parent' 
    ELSE                        ppc.Name 
    END AS ParentCategoryName
  , FORMAT(p.SellStartDate, 'MMMM yyyy') AS StartSellDate
  , (
      SELECT SUM(sod.OrderQty)
      FROM [SalesLT].[SalesOrderDetail] AS sod
      WHERE sod.ProductID = p.ProductID
    ) AS SoldTotal
FROM SalesLT.Product AS p 
RIGHT OUTER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
LEFT OUTER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID
WHERE 
  pc.Name LIKE '%bike%'
  AND EXISTS 
  (
    SELECT 1
    FROM SalesLT.SalesOrderDetail AS sod
    WHERE sod.ProductID = p.ProductID
  )
ORDER BY SoldTotal DESC;

/* --------------------------------------------------------------------------------------
    Exercise 3
    Let's make it a bit harder. 
    This is not a step-by-step exercise, but here we create a query in a couple of steps.
    Still, the previous steps are partly needed to create the code for the next steps. 
    Good luck!
  --------------------------------------------------------------------------------------- */

/* 1. Give for every selling record in the database the following information: 
      Order number, product name, quantity, selling price without discount (=unit price), 
      discount factor presented as a percentage with zero decimals, 
      the standard cost of a product and the list price of a product.
      Make sure that the lowest order number is on top. */

SELECT 
  sh.SalesOrderNumber
  , p.[Name]
  , sod.OrderQty
  , sod.UnitPrice                       AS SellingPrice
  , FORMAT(sod.UnitPriceDiscount, 'P0') AS DiscountFactor
  , p.StandardCost
  , p.ListPrice
FROM SalesLT.SalesOrderDetail AS sod
INNER JOIN SalesLT.Product AS p 
ON p.ProductID = sod.ProductID
INNER JOIN SalesLT.SalesOrderHeader AS sh 
ON sh.SalesOrderID = sod.SalesOrderID
ORDER BY sh.SalesOrderNumber ASC;

-- Explanation:
-- The base of the query consists of order lines. 
-- These can be found in 'SalesOrderDetail'. 
-- The sales order number can be found in the table with order headers, so we need a join. 
-- Also, we need some product information so we create a join to the Product table. 
-- There are multiple ways to create the percentage format asked for. 
-- This link gives a couple of examples: 
-- https://database.guide/4-ways-to-convert-a-number-to-a-percentage-in-sql-server-t-sql/

/* 2. Calculate the actual selling price per unit. Use the unit price and the discount for this calculation.
      These columns will become obsolete and hence can be deleted from display. */

SELECT 
  sh.SalesOrderNumber
  , p.[Name]
  , sod.OrderQty
  , sod.UnitPrice * (1 - sod.UnitPriceDiscount) AS ActualSellingUnitPrice
  , p.StandardCost
  , p.ListPrice
FROM SalesLT.SalesOrderDetail AS sod
INNER JOIN SalesLT.Product AS p 
ON p.ProductID = sod.ProductID
INNER JOIN SalesLT.SalesOrderHeader AS sh 
ON sh.SalesOrderID = sod.SalesOrderID
ORDER BY sh.SalesOrderNumber ASC;

-- Explanation:
-- We use the same tables that are used in the previous step.
-- The actual selling price of a product is the selling price, 
-- also known as the unit price from sales order details, minus the discount given. 
-- Because the discount is number between 0 and 1, 
-- we use the calculation (1 – discount) as the part we still have to pay of the unit price. 

/* 3. Calculate the total revenue per selling record. 
      Also, calculate the percentage of the revenue with respect to the standard costs. 
      Show only the outliers that have a profit rate of 20% or more or a loss rate of 20% or less. 
      Order by the total revenue per selling record from least profitable sell to most profitable sell. 
      Do not use a formula in the order by. 
      We are not interested in the costs and list price of a product anymore from here on. */

SELECT 
  sh.SalesOrderNumber
  , p.[Name]
  , sod.OrderQty
  , sod.UnitPrice * (1 - sod.UnitPriceDiscount)   AS ActualSellingUnitPrice
  , (sod.UnitPrice * (1 - sod.UnitPriceDiscount) 
    - p.StandardCost) * sod.OrderQty              AS RevenueLine
  , sod.UnitPrice * (1 - sod.UnitPriceDiscount) 
    / p.StandardCost                              AS PercentageRevenue
  , p.StandardCost
  , p.ListPrice
FROM SalesLT.SalesOrderDetail AS sod
INNER JOIN SalesLT.Product AS p 
ON p.ProductID = sod.ProductID
INNER JOIN SalesLT.SalesOrderHeader AS sh 
ON sh.SalesOrderID = sod.SalesOrderID
WHERE sod.UnitPrice * (1 - sod.UnitPriceDiscount) / p.StandardCost NOT BETWEEN 0.8 AND 1.2
ORDER BY RevenueLine ASC;

-- Explanation:
-- In the previous step we calculated the actual selling price of a product. 
-- The standard costs are also available. The formula to calculate the revenue of a product = 
-- selling price of a product – costs of a product. 
-- The revenue for a line is then the revenue * quantity. 
-- To calculate a percentage with respect to the costs, we want to know how much of the sell covered the costs. 
-- Hence, we divide the selling price by the costs. 
-- If we sold a product for a bigger amount than the costs than the result should be above 1 (or 100%). 
-- To only show outliers we filter the query so that the percentage is below 0.8 (80%) or above 1.2 (120%).
-- Note that we use the alias in the order by.

/* 4. Finally, we want to know which sales order was the most profitable and 
      which sales order was the most loss-making. */
SELECT
  sh.SalesOrderNumber
  , SUM(
    (
      sod.UnitPrice * (1 - sod.UnitPriceDiscount) 
      - p.StandardCost
    ) * sod.OrderQty
  ) AS RevenueLine
FROM SalesLT.SalesOrderDetail AS sod
INNER JOIN SalesLT.Product AS p 
ON p.ProductID = sod.ProductID
INNER JOIN SalesLT.SalesOrderHeader AS sh 
ON sh.SalesOrderID = sod.SalesOrderID
GROUP BY sh.SalesOrderNumber
ORDER BY RevenueLine DESC;

-- Explanation:
-- At last, we focus on the sales orders instead of the sales lines. 
-- But because data from the sales order detail table is needed we have to use a GROUP BY. 
-- The wanted information is to sum the amount earned per order. 
-- This revenue is already calculated in the previous step, so we use that formula to sum this amount and 
-- group by sales order number. 
-- Order by revenue (ascending or descending) to look up the most profitable and 
-- the most loss-making order with corresponding amounts.

/* --------------------------------------------------------------------------------------
  Exercise 4
  Again, let's create a query. This is not a step-by-step exercise, but here we create a query in a couple of steps.
  Still, the previous steps are partly needed to create the code for the next steps. Good luck!
  --------------------------------------------------------------------------------------- */

/* 1. Retrieve all products that have start sell date in the year 2002 and the month June. On top of that we want to see all products with an end sell date that is on or before 30 June 2007. Show name, color, weight and both dates. */

SELECT 
  p.[Name]
  , p.Color
  , p.[Weight]
  , p.SellStartDate
  , p.SellEndDate
FROM SalesLT.Product AS p
WHERE (
  MONTH(p.SellStartDate) = 6 
  AND YEAR(p.SellStartDate) = 2002
) 
OR p.SellEndDate <= '20070630';   -- 👈 universal date format

-- Better:
SELECT 
  p.[Name]
  , p.Color
  , p.[Weight]
  , p.SellStartDate
  , p.SellEndDate
FROM SalesLT.Product AS p
WHERE (
  p.SellStartDate >= '20020601'    -- 👈 use the index if available
  AND p.SellStartDate < '20020701'
)
OR p.SellEndDate <= '20070630';

-- Explanation:
-- The only table that is needed is the Product table.
-- There are multiple ways to Rome to achieve the date criteria. 
-- First possibility is shown above. 
-- We can also use the MOTNH and YEAR function to meet the SellStartDate criterium
-- (This is shown in exercise 2 below). 
-- For the SellEndDate we use the <= operator to achieve 'smaller or equal then'. 
-- It is also possible to use the DATEPART function. 

/* 2. The weight of some of these products are unknown (NULL value). 
      Replace these values with a zero. 
      Instead of the product name, show the parent product category name. 
      Show only the products that have a parent category. Use aliases for convenience. */

SELECT 
  ppc.[Name]                AS ParentProductCategoryName
  , p.Color
  , ISNULL(p.[Weight], 0)   AS [Weight]
  , p.SellStartDate
  , p.SellEndDate
FROM SalesLT.Product AS p
INNER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
INNER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID
WHERE	(
  p.SellStartDate >= '20020601'
  AND p.SellStartDate < '20020701'
)
OR p.SellEndDate <= '20070630';	

-- Explanation:
-- It makes perfect sense to use the ISNULL function to replace a NULL value with a specified value. 
-- In Microsoft's lab 01 this function is discussed in the section 'Handle NULL values'.
-- Of course it is also possible to use the COALESCE() function or a CASE statement. 
-- The parent product category name is fetched by joining two times the product category table 
-- on the product category ID. 
-- You did this already in exercise 2 of this document. 
-- An inner join is used because we only want to see the products that have a parent.

/* 3. Per parent category and color, we are interested in de average weight of these combined groups. (eg. For Bikes that are black, what is the average weight?). The database doesn’t have a color registered for every parent category. Every accessory without a color is purple and every component without a color is orange, make sure this is shown in the result. Don’t show the date columns. Order the categories from A to Z and the colors from Z to A. Which parent category with corresponding color has the highest average weight? */

SELECT 
  ppc.[Name]                AS ParentProductCategoryName
  , CASE
      WHEN p.Color IS NULL AND ppc.[Name] = 'Accessories'     THEN 'Purple'
      WHEN p.Color IS NULL AND ppc.[Name] = 'Components'      THEN 'Orange'
  ELSE                                                             p.Color
  END                       AS Color
  , AVG(ISNULL(p.[Weight], 0))  AS AverageWeight
FROM SalesLT.Product AS p
INNER JOIN [SalesLT].[ProductCategory] AS pc 
ON pc.ProductCategoryID = p.ProductCategoryID
INNER JOIN [SalesLT].[ProductCategory] AS ppc 
ON ppc.ProductCategoryID = pc.ParentProductCategoryID
WHERE	(
  p.SellStartDate >= '20020601'
  AND p.SellStartDate < '20020701'
)
OR p.SellEndDate <= '20070630'
GROUP BY
  ppc.[Name]
  , CASE
      WHEN p.Color IS NULL AND ppc.[Name] = 'Accessories'     THEN 'Purple'
      WHEN p.Color IS NULL AND ppc.[Name] = 'Components'      THEN 'Orange'
      ELSE                                                         p.Color
    END
ORDER BY
  ppc.[Name]
  , Color	DESC;

-- Explanation:
-- As asked, we are interested in the average weight of a product with a certain color. 
-- Because an aggregate is needed, we know that we have to use an AVERAGE operator on the weight and 
-- that we have to group by the product category name and color to not raise an error. 
-- A CASE statement is used to 'change' the colors. 
-- When a color has a NULL value and belongs to a certain category, we change the colors. 
-- This results in a case statement with multiple lines (for every category that needs change) and 
-- an 'AND' in every line. 
-- The order by has a ascending part and a descending part as stated in the question.
