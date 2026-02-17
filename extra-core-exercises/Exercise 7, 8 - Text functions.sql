/* =====================================================
   Core Querying Data with Transact-SQL

   Copyright
   © Info Support
   • All Rights Reserved •
   This data may not be copied or distributed without the
   prior approval of Info Support
   www.infosupport.com
   =================================================== */

/* 🌶 Exercise 7 - Text functions */

/* 1. Write a query to retrieve data from the Customer table this way:

      FirstName   LengthFirstName   LastName    SalesPerson   SpecialCode
      Orlando     7                 GEE         pamela0       a_bike_store>>gee
      Keith       5                 HARRIS      david8        progressive_sports>>harris
      Donna       5                 CARRERAS    jillian0      advanced_bike_components>>carreras
      ...         ...               ...         ...           ...

      (result: 847 rows) */


/* 🌶🌶 Exercise 8 - Text functions */

/* 1. Write another query to retrieve data from the Customer table this way:

      CompanyName               NrOfWords   CustomerName
      A Bike Store              3           Orlando N. Gee
      Progressive Sports        2           Keith Harris
      Advanced Bike Components  3           Donna F. Carreras
      Modular Cycle Systems     3           Janet M. Gates
      ...                       ...         ...

      To solve the CustomerName challenge, you might use the IIF() scalar function. 
      A couple of solutions will be discussed after the exercise.

      (result: 847 rows) */
