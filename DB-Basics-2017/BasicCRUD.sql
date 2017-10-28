--problem 1
USE SoftUni
GO

--problem 2
SELECT * FROM Departments

--problem 3
SELECT Name FROM Departments

--problem 4
SELECT * FROM Employees
SELECT FirstName, LastName, Salary FROM Employees

--problem 5
SELECT FirstName, MiddleName, LastName FROM Employees

--problem 6
SELECT FirstName + '.' + LastName + '@softuni.bg' 
    AS [Full Email Address] 
  FROM Employees

--problem 7
SELECT DISTINCT Salary FROM Employees

--problem 8
SELECT * FROM Employees
 WHERE JobTitle = 'Sales Representative'

--problem 9
SELECT FirstName, LastName, JobTitle FROM Employees
 WHERE Salary BETWEEN 20000 and 30000

--problem 10
SELECT FirstName + ' ' + MiddleName + ' ' + LastName 
    AS [Full Name] FROM Employees
WHERE Salary = 12500 or Salary = 14000 or Salary = 23600 or Salary = 25000

--problem 11
SELECT FirstName, LastName FROM Employees
 WHERE ManagerID IS NULL

--problem 12
SELECT FirstName, LastName, Salary FROM Employees
 WHERE Salary > 50000
 ORDER BY Salary DESC

--problem 13
SELECT TOP 5 FirstName, LastName FROM Employees
 ORDER BY Salary DESC

--problem 14
SELECT FirstName, LastName FROM Employees
WHERE NOT DepartmentID = 4

--problem 15
SELECT * FROM Employees
ORDER BY Salary DESC, FirstName, LastName DESC, MiddleName
GO

--problem 16
CREATE VIEW V_EmployeesSalaries AS
SELECT FirstName, LastName, Salary
  FROM Employees
GO

--problem 17
CREATE VIEW v_EmployeeNameJobTitle AS
SELECT FirstName + ' ' + ISNULL(MiddleName, '') + ' ' + LastName AS [Full Name], JobTitle AS [Job Title] 
  FROM Employees
GO

--problem 18
SELECT DISTINCT JobTitle 
  FROM Employees
 ORDER BY JobTitle

--problem 19
SELECT TOP 10 * FROM Projects
 ORDER BY StartDate, Name

--problem 20
SELECT TOP 7 FirstName, LastName, HireDate 
  FROM Employees
 ORDER BY HireDate DESC

--problem 21
UPDATE Employees
   SET Salary *= 1.12
 WHERE DepartmentID = 1 OR DepartmentID = 2 OR DepartmentID = 4 OR DepartmentID = 11

SELECT Salary FROM Employees
GO


USE Geography
GO

--problem 22
SELECT PeakName FROM Peaks
 ORDER BY PeakName

--problem 23
SELECT TOP 30 CountryName, Population FROM Countries
 WHERE ContinentCode = 'EU'
 ORDER BY Population DESC, CountryName

--problem 24
SELECT CountryName, 
	   CountryCode, 
	   (CASE 
			WHEN CurrencyCode = 'EUR' 
			THEN 'Euro' 
			ELSE 'Not Euro' 
			END)
		 AS [Currency] 
	   FROM Countries
 ORDER BY CountryName


USE Diablo

--problem 25
SELECT Name FROM Characters
 ORDER BY Name
