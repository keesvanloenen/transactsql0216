-- ***********************************
-- Deel 4: WINDOW function vs Subquery
-- ***********************************
-- Als Window Function
SELECT
	datum
	, aantal
	, SUM(aantal) OVER (ORDER BY datum) AS perc
FROM bestellingen;

-- Als Subquery
SELECT
    b.datum,
    b.aantal,
    (
		SELECT SUM(b2.aantal) 
		FROM bestellingen b2 
		WHERE b2.datum <= b.datum
	) AS perc
FROM bestellingen b;

-- Bij meer data presteert de Window Function (veel) beter
-- Onderstaand script geeft de Bestellingen tabel meer rijen
-- Herhaal daarna bovenstaande 2 queries en vergelijk
TRUNCATE TABLE Bestellingen;

WITH Numbers AS (
    SELECT TOP (2500)
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
)
INSERT INTO bestellingen (Datum, Aantal)
SELECT 
    DATEADD(DAY, n, '2020-01-01')		 AS Datum,  -- Startdatum
    ABS(CHECKSUM(NEWID(), n)) % 300 + 1  AS Aantal  -- Random aantal tussen 1 en 300
FROM Numbers;
GO

SELECT datum, aantal FROM bestellingen;	-- 2500 rijen ipv 6
