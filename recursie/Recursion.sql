USE master;
GO

DROP DATABASE IF EXISTS Recursion;

CREATE DATABASE Recursion;
GO

USE Recursion;
GO

DROP TABLE IF EXISTS dbo.courses;
DROP TABLE IF EXISTS dbo.domains;
GO

CREATE TABLE dbo.domains
(
	domain_id INT IDENTITY PRIMARY KEY,
	domain_name NVARCHAR(25) NULL,
	parent_id INT NULL FOREIGN KEY REFERENCES dbo.domains(domain_id)
);

CREATE TABLE dbo.courses
(
	course_id INT IDENTITY PRIMARY KEY,
	course_name NVARCHAR(25) NULL,
	domain_id INT NOT NULL FOREIGN KEY REFERENCES dbo.domains(domain_id)
);
GO

INSERT INTO dbo.domains
(domain_name, parent_id)
VALUES
('Info Support', NULL),
('Staff', 1),
('IT', 1),
('Reception', 2),
('HR', 2),
('Apps', 3),
('Frontend', 6),
('Backend', 6);
GO

INSERT INTO dbo.courses
(course_name, domain_id)
VALUES
('DevOps', 3),
('Security', 3),
('HTML', 7),
('C#', 8),
('AVG', 5),
('Java', 8);
GO

SELECT * FROM Domains
SELECT * FROM Courses

WITH CourseDomain AS
(
	-- Start domain to look down from (or up)
	SELECT domain_id, domain_name, parent_id
	FROM dbo.domains
	WHERE domain_name = 'frontend'

	UNION ALL

	SELECT child.domain_id, child.domain_name, child.parent_id
	FROM CourseDomain AS parent
	INNER JOIN dbo.domains AS child 
	ON child.domain_id = parent.parent_id		-- up the hierarchy
	--INNER JOIN dbo.domains AS child 
	--ON child.parent_id = parent.domain_id		-- down the hierarchy
)
SELECT cd.domain_name --, c.course_name
FROM CourseDomain AS cd
--INNER JOIN dbo.courses AS c
--ON cd.domain_id = c.domain_id;
