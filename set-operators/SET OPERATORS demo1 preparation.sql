USE adventureworks;
GO

DROP TABLE IF EXISTS dbo.Customers;
DROP TABLE IF EXISTS dbo.Employees;

CREATE TABLE dbo.Customers
(
	id				int IDENTITY
	, email			nvarchar(50)
	, city 			nvarchar(50)
	, postalcode 	nvarchar(25)
	, country 		nvarchar(50)
);

CREATE TABLE dbo.Employees
(
	id				int IDENTITY
	, lastname 		nvarchar(50)
	, city			nvarchar(50)
	, country		nvarchar(40)
);
GO

INSERT INTO dbo.Customers
VALUES
('a@a.com', 'Amsterdam', '1111', 'Netherlands'),
('b@b.com', 'Barcelona', '2222', 'Spain'),
('c@c.com', 'Coevorden', '3333', 'Netherlands'),
('d@d.com', 'Dublin', '4444', 'Ireland'),
('e@e.com', 'Ede', '5555', 'Netherlands'),
('f@f.com', 'Hoboken', '6666', 'België'),
('g@g.com', 'Hoboken', '7777', 'US');

INSERT INTO dbo.Employees
VALUES
('de Jong', 'Amsterdam', 'Netherlands'),
('Abdulrahman', 'Amsterdam', 'Netherlands'),
('Harvey', 'Dublin', 'Ireland'),
('José', 'Barcelona', 'Spain'),
('van Puffelen', 'Amsterdam', 'Netherlands'),
('Jeltsin', 'Hoboken', 'US');
GO


SELECT city, country FROM Customers
INTERSECT
SELECT city, country FROM Employees

-- DROP TABLE IF EXISTS dbo.Customers;
-- DROP TABLE IF EXISTS dbo.Employees;
