USE tempdb;
GO

-- Extra Recursion demo

DROP TABLE IF EXISTS Medewerkers;
GO

CREATE TABLE Medewerkers
(
    Id			int IDENTITY,
    Naam		nvarchar(100) NOT NULL,
    ManagerId	int NULL
);
GO

INSERT INTO Medewerkers 
(Naam, ManagerId) 
VALUES 
('Toon', NULL), -- Id = 1 
('Mirjam', 1),  -- Id = 2
('Bas', 1),		-- Id = 3
('Lammert', 1), -- Id = 4
('Ab', 2),		-- Id = 5
('Bo', 3),		-- Id = 6
('Cas', 4),		-- Id = 7
('Dik', 5),		-- Id = 8
('Fem', 6),		-- Id = 9
('Gabi', 6);	-- Id = 10
GO

-- 1. Maak een self-join om in één overzicht namen van medewerkers en managers te tonen
-- 2. We willen ook het level kunnen tonen:
--    Toon = Level 1
--    Mirjam, Bas, Lammert = Level 2
--    etc.

SELECT 
    m1.Naam   AS medewerker
    ,m2.Naam  AS manager
FROM Medewerkers AS m1
LEFT OUTER JOIN Medewerkers AS m2
ON m1.ManagerId = m2.Id;

-- Anchor Member: startpunt (top v/d hierarchy = Toon)
-- Recursive Member: het herhalende deel dat steeds dieper graaft

WITH MedewerkersManagers AS
(
    -- Anchor Member
    SELECT 
        *
        , 1 AS Level 
    FROM Medewerkers
    WHERE ManagerId IS NULL
    UNION ALL
    -- Recursive Member
    SELECT 
        m.*
        , Level + 1
    FROM Medewerkers AS m
    INNER JOIN MedewerkersManagers AS mm
    ON m.ManagerId = mm.Id
)
SELECT 
    mm.Naam     AS Medewerker
    , m.Naam    AS Manager
    , mm.Level
FROM MedewerkersManagers AS mm
LEFT OUTER JOIN Medewerkers AS m
ON mm.ManagerId = m.Id
ORDER BY 
    mm.Level
    , m.Id;
