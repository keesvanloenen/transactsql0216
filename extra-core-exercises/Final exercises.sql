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

/* 2. Select all rows (hint: use a *) of the sales order table. Add all address information to these sales orders using a join on the ShipToAddress. Give the tables aliases and use these aliases in the join clause. */

/* 3. Select only the sales order that are shipped to the United States. */

/* 4. Add the names of the customers to the above table. Only show the sales order number, the first name of the customer, the last name of the customer and their title. */

/* 5. Create an new column that combines the title of the customer with the full name of the customer. (eg. Mr. John Johnson).  Do not show the original columns of the customer table. */

/* 6. Add the total amount that the customer spent. Use the LineTotal from the SalesOrderDetail table. Remember the ‘GROUP BY’ clause when using an aggregate. */

/* 7. Add also the total quantity that a customer purchased and the average amount per product. */

/* 8. Only show the orders that sold at least 20 products to a customer. */

/* 9. Show the subset of these orders that has an average amount per product less than 1000. */

/* --------------------------------------------------------------------------------------
  Exercise 2
  Step-by-step exercise to show the most popular products that were sold.
  In general, the previous step is needed to create the code of the next step. Good luck!
  --------------------------------------------------------------------------------------- */

/* 1. Select all rows (hint: use a *) of the product table. */

/* 2. Add the product category table to the product table. Make sure that all product categories are shown even if a product category is not coupled to a product. Give the tables aliases and use these aliases in the join clause. */

/* 3. Add the parent product category to the previous table. Make sure that all parent product categories are shown even if the parent product category is a NULL value in the previous table. Again, use an alias. */

/* 4. Only show the columns product name, the product category and the parent product category. */

/* 5. Some categories don’t have a parent category. Replace these ‘empty’ values with: ‘The category is already the parent’. Use a CASE statement. */

/* 6. Return only the rows that contain the word ‘bike’ somewhere in the category name. */

/* 7. Retrieve the Sellstartdate and show in the format 'month spelled out Year' (eg. October 2020). Make sure it creates a date (using format), not a string. */

/* 8. Use a subquery in the SELECT clause to get the total quantity sold per product. */

/* 9. Use a subquery in the WHERE clause to filter the products that have an actual sale. (eg. the quantity sold is not null). Make this happen using the EXISTS operator. */

/* 10. Show the results from most popular item to least sold item. */

/* 11. We are only interested in the top 22 percent sold products. Show the results. */

/* 12. We see that only one of the two products that sold a total of 17 units are shown in the previous query. 
       Show both products using the keyword 'TIES'. */

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

/* 2. Calculate the actual selling price per unit. Use the unit price and the discount for this calculation.
      These columns will become obsolete and hence can be deleted from display. */

/* 3. Calculate the total revenue per selling record. 
      Also, calculate the percentage of the revenue with respect to the standard costs. 
      Show only the outliers that have a profit rate of 20% or more or a loss rate of 20% or less. 
      Order by the total revenue per selling record from least profitable sell to most profitable sell. 
      Do not use a formula in the order by. 
      We are not interested in the costs and list price of a product anymore from here on. */

/* 4. Finally, we want to know which sales order was the most profitable and 
      which sales order was the most loss-making. */

/* --------------------------------------------------------------------------------------
  Exercise 4
  Again, let's create a query. This is not a step-by-step exercise, but here we create a query in a couple of steps.
  Still, the previous steps are partly needed to create the code for the next steps. Good luck!
  --------------------------------------------------------------------------------------- */

/* 1. Retrieve all products that have start sell date in the year 2002 and the month June. On top of that we want to see all products with an end sell date that is on or before 30 June 2007. Show name, color, weight and both dates. */

/* 2. The weight of some of these products are unknown (NULL value). 
      Replace these values with a zero. 
      Instead of the product name, show the parent product category name. 
      Show only the products that have a parent category. Use aliases for convenience. */

/* 3. Per parent category and color, we are interested in de average weight of these combined groups. (eg. For Bikes that are black, what is the average weight?). The database doesn’t have a color registered for every parent category. Every accessory without a color is purple and every component without a color is orange, make sure this is shown in the result. Don’t show the date columns. Order the categories from A to Z and the colors from Z to A. Which parent category with corresponding color has the highest average weight? */