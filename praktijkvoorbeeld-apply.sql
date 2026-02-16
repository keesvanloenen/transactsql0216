-- *****************************************************************
-- Praktijkvoorbeeld van het gebruik van APPLY
-- SQL Server heeft Dynamic Management (DM) VIEWS en TVFs.
-- Deze kunnen enkel via  APPLY gekoppeld worden.
-- VIEW: sys.dm_exec_query_stats bevat sql_handle kolom.
-- TVF: sys.dm_exec_sql_text(sql_handle). Retourneert de query text.
-- *****************************************************************

USE adventureworks;
GO

-- Eerst 5x uitvoeren. Deze query willen we straks kunnen opsporen.
SELECT color FROM SalesLT.Product;

-- Willen we info over hoe vaak deze query wanneer werd uitgevoerd en hoe veel ms dat duurde, 
-- dan bevat de view dm_exec_query_stats alle info. De query zelf is lastig op te sporen, want de stats view 
-- bevat geen sql text zoals 'SELECT city':
SELECT * FROM sys.dm_exec_query_stats qs;

-- We kunnen enkele WHERE clauses toevoegen in de hoop de juiste query te vinden:
SELECT * 
FROM sys.dm_exec_query_stats qs
WHERE qs.execution_count = 5
AND qs.last_execution_time > DATEADD(minute, -10, SYSDATETIME());

-- Nog handiger zou zijn om daarbij ook de sql text te kunnen gebruiken.
-- Deze is beschikbaar via de DM TVF dm_exec_sql_text. 
-- Input parameter voor deze TVF is de unieke handle (geleverd door de view)
SELECT *
FROM sys.dm_exec_sql_text(0x0200000082E989272480641763F5F34DA3C553B47F46EE080000000000000000000000000000000000000000);

-- Deze TVF bevat dus een text kolom met daarin de query text: 'SELECT city FROM HR.Employees';
-- De view en TVF zouden we dus kunnen koppelen via een APPLY:
SELECT 
	dm_tvf.text
	, dm_view.execution_count
	, dm_view.total_elapsed_time
	, dm_view.sql_handle
FROM sys.dm_exec_query_stats AS dm_view
CROSS APPLY sys.dm_exec_sql_text(dm_view.sql_handle) AS dm_tvf
WHERE dm_view.execution_count = 5
AND dm_tvf.text LIKE '%color%' 
ORDER BY dm_view.total_elapsed_time DESC;
