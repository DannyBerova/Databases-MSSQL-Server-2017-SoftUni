use Softuni

--problem 1
SELECT FirstName, LastName
  FROM Employees
 WHERE FirstName LIKE 'SA%'

--problem 2
SELECT FirstName, LastName
 FROM Employees
WHERE LastName LIKE '%ei%'

--problem 3
SELECT FirstName 
  FROM Employees
 WHERE DepartmentID IN (3, 10) AND 
		(HireDate >= 1995 OR HireDate <= 2005)

--problem 4
SELECT FirstName, LastName 
  FROM Employees
 WHERE JobTitle NOT LIKE '%engineer%'

--problem 5
SELECT Name 
  FROM Towns
 WHERE LEN(Name) = 5 OR LEN(Name) = 6
 ORDER BY Name

--problem 6
SELECT TownID, Name 
  FROM Towns
 WHERE Name LIKE '[MKBE]%'
 ORDER BY [Name]

--problem 7
SELECT TownID, Name 
  FROM Towns
 WHERE Name LIKE '[^RBD]%'
 ORDER BY [Name]
 GO

--problem 8
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName 
  FROM Employees
 WHERE DATEPART(YEAR, HireDate) > 2000
 GO

--problem 9
SELECT FirstName, LastName 
  FROM Employees
 WHERE LEN(LastName) = 5

USE Geography

--problem 10
SELECT CountryName, IsoCode 
  FROM Countries
 WHERE CountryName LIKE '%A%A%A%'
 ORDER BY IsoCode

--problem 11
SELECT PeakName, 
	   RiverName,
	   LOWER(PeakName + RIGHT(RiverName, LEN(RiverName) - 1)) AS Mix
  FROM Peaks, Rivers
 WHERE RIGHT(PeakName,1) = LEFT(RiverName,1)
 ORDER BY Mix

USE Diablo

--problem 12
SELECT TOP (50) Name, FORMAT(Start, 'yyyy-MM-dd') AS Start
  FROM Games
 WHERE YEAR(Start) BETWEEN 2011 AND 2012
 ORDER BY Start, Name

--problem 13
SELECT Username, 
	   RIGHT(Email, LEN(Email) - CHARINDEX('@', Email, 1)) 
	   AS [Email Provider]
  FROM Users
 ORDER BY [Email Provider], Username

--problem 14
SELECT Username, IpAddress 
  FROM Users
 WHERE IpAddress LIKE '___.1%.%.___'
 ORDER BY Username

--problem 15
SELECT [Name] as Game,
       CASE 
         WHEN DATEPART(HOUR, Start) BETWEEN 0 AND 11 THEN 'Morning'
         WHEN DATEPART(HOUR, Start) BETWEEN 12 AND 17 THEN 'Afternoon'
         WHEN DATEPART(HOUR, Start) BETWEEN 18 AND 23 THEN 'Evening'
       END 
	AS [Part of the Day],
       CASE
         WHEN Duration <= 3 THEN 'Extra Short'
         WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
         WHEN Duration > 6 THEN 'Long'
         ELSE 'Extra Long'
       END 
	AS [Duration]
  FROM Games
 ORDER BY [Name], 
		  [Duration],
		  [Part of the Day]


USE Orders

--problem 16

SELECT ProductName,
	   OrderDate,
	   DATEADD(DAY, 3, OrderDate) AS [Pay Due],
	   DATEADD(MONTH, 1, OrderDate) AS [Delivery Due]
FROM Orders

USE Master

--problem 17
CREATE TABLE People(
  Id INT PRIMARY KEY IDENTITY NOT NULL,
  [Name] VARCHAR(50) NOT NULL,
  Birthdate DATE
)

INSERT INTO People 
VALUES ('Victor', '2000-12-07'),
	   ('Steven', '1992-09-10'),
	   ('Stephen', '1910-09-19'),
	   ('John', '2010-01-06')

SELECT [Name],
DATEDIFF(YEAR, Birthdate, GETDATE()) AS [Age in Years],
DATEDIFF(MONTH, Birthdate, GETDATE()) AS [Age in Months],
DATEDIFF(DAY, Birthdate, GETDATE()) AS [Age in Days],
DATEDIFF(MINUTE, Birthdate, GETDATE()) AS [Age in Minutes]
FROM People
