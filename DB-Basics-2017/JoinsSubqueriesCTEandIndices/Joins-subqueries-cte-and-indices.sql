USE SoftUni

--problem 01.Employee Address
SELECT TOP 5
	   e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText 
  FROM Employees AS e
  JOIN Addresses AS a
    ON e.AddressID = a.AddressID
ORDER BY a.AddressID

--problem 02.Addresses with Towns
SELECT TOP 50
	   e.FirstName, 
	   e.LastName, 
	   t.Name AS Town, 
	   a.AddressText 
  FROM Employees AS e
  JOIN Addresses AS a
    ON e.AddressID = a.AddressID
  JOIN Towns AS t
    ON a.TownID = t.TownID
 ORDER BY e.FirstName, e.LastName

--problem 03.Sales Employee
SELECT e.EmployeeID,
	   e.FirstName, 
	   e.LastName, 
	   d.Name AS DepartmentName 
  FROM Employees AS e
  JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentId
 WHERE d.Name = 'Sales'
 ORDER BY e.EmployeeId

--problem 04.Employee Departments
SELECT TOP 5
	   e.EmployeeID,
	   e.FirstName, 
	   e.Salary, 
	   d.Name AS DepartmentName 
  FROM Employees AS e
  JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentId
 WHERE e.Salary > 15000
 ORDER BY d.DepartmentId

--problem 05.Employees Without Project
SELECT TOP (3)
	   e.EmployeeID, e.FirstName 
  FROM Employees AS e 
  LEFT OUTER JOIN EmployeesProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
  LEFT OUTER JOIN Projects AS p
    ON ep.ProjectID = p.ProjectID
 WHERE ep.EmployeeID IS NULL

--problem 06.Employees Hired After
SELECT e.FirstName, 
	   e.LastName, 
	   e.HireDate,
	   d.Name AS DeptName 
  FROM Employees AS e
  JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentId
 WHERE d.Name IN ('Sales', 'Finance') and e.HireDate > '19990101'
 ORDER BY e.EmployeeId


--problem 07.Employees With Project
SELECT TOP (5) 
	   e.EmployeeID, 
	   e.FirstName, 
	   p.Name AS ProjectName
  FROM Employees AS e 
  JOIN EmployeesProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
  JOIN Projects AS p
    ON ep.ProjectID = p.ProjectID
 WHERE p.StartDate > 13/08/2002 
	   AND p.EndDate IS NULL
 ORDER BY e.EmployeeID

--problem 08.Employee 24
SELECT e.EmployeeID, 
	   e.FirstName,
	   CASE
	     WHEN DATEPART (YEAR, p.StartDate) >= 2005 THEN NULL 
	     ELSE p.Name
	   END 
	   AS [ProjectName]
  FROM Employees AS e 
  JOIN EmployeesProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
  JOIN Projects AS p
    ON ep.ProjectID = p.ProjectID
 WHERE e.EmployeeID = 24 

--problem 09.Employee Manager
SELECT e.EmployeeID, 
	   e.FirstName, 
	   e.ManagerID, 
	   m.FirstName AS ManagerName 
  FROM Employees AS e
  JOIN Employees AS m
    ON e.ManagerID = m.EmployeeID
 WHERE e.ManagerID IN (3, 7)

--problem 10.Employee Summary
SELECT TOP (50)
	   e.EmployeeID, 
	   e.FirstName + ' ' + e.LastName AS EmployeeName, 
	   m.FirstName + ' ' + m.LastName AS ManagerName,
	   d.Name AS DepartmentName
  FROM Employees AS e
  JOIN Employees AS m
    ON e.ManagerID = m.EmployeeID
  JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
 ORDER BY e.EmployeeID

--problem 11.Min Average Salary
SELECT MIN(avgs) AS MinAverageSalary 
  FROM
  (
  SELECT AVG(Salary) AS avgs 
    FROM Employees
   GROUP BY DepartmentID
  )
  AS AverageSalaries

----------------
USE Geography


--problem 12.Highest Peaks in Bulgaria
SELECT mc.CountryCode, 
	   m.MountainRange, 
	   p.PeakName, 
	   p.Elevation 
  FROM MountainsCountries AS mc
  JOIN Mountains AS m
    ON mc.MountainId = m.Id
  JOIN Peaks AS p
    ON m.Id = p.MountainId
 WHERE mc.CountryCode = 'BG' 
   AND p.Elevation > 2835
 ORDER BY p.Elevation DESC

--problem 13.Count Mountain Ranges
SELECT cc.CountryCode,
	   COUNT(cc.MountainRange) AS MountainRanges 
	   FROM(
       SELECT mc.CountryCode AS CountryCode , 
       	   m.MountainRange AS MountainRange
         FROM MountainsCountries AS mc
         JOIN Mountains AS m
           ON mc.MountainId = m.Id
        WHERE mc.CountryCode IN('BG', 'US', 'RU')) AS cc
 GROUP BY cc.CountryCode

--problem 14.Countries with Rivers
SELECT TOP(5)
	   c.CountryName, 
       r.RiverName 
  FROM Countries AS c
  JOIN Continents AS con
	ON c.ContinentCode = con.ContinentCode
  LEFT JOIN CountriesRivers AS cr
	ON c.CountryCode = cr.CountryCode
  LEFT JOIN Rivers AS r
	ON cr.RiverId = r.Id
 WHERE con.ContinentName = 'Africa'
 ORDER BY c.CountryName

--problem 15.Continents and Currencies

SELECT OrderedCurrencies.ContinentCode,
	   OrderedCurrencies.CurrencyCode,
	   OrderedCurrencies.CurrencyUsage
  FROM Continents AS c
  JOIN (
	   SELECT ContinentCode AS [ContinentCode],
	   COUNT(CurrencyCode) AS [CurrencyUsage],
	   CurrencyCode as [CurrencyCode],
	   DENSE_RANK() OVER (PARTITION BY ContinentCode 
	                      ORDER BY COUNT(CurrencyCode) DESC
						  ) AS [Rank]
	   FROM Countries
	   GROUP BY ContinentCode, CurrencyCode
	   HAVING COUNT(CurrencyCode) > 1
	   )
	   AS OrderedCurrencies
    ON c.ContinentCode = OrderedCurrencies.ContinentCode
 WHERE OrderedCurrencies.Rank = 1

--problem 16.Countries without any Mountains
SELECT COUNT(*) 
FROM (
	 SELECT mc.CountryCode 
	   FROM Countries AS c
	   LEFT OUTER JOIN MountainsCountries AS mc
		ON c.CountryCode = mc.CountryCode
	  WHERE mc.CountryCode IS NULL
	 ) AS CountriesWithoutMountains

--problem 17.Highest Peak and Longest River by Country

SELECT TOP (5)
       Sorted.CountryName, 
	   MAX(Sorted.PeakElevation) AS HighestPeakElevation, 
	   MAX(Sorted.RiverLength) AS LongestRiverLength
  FROM (
         SELECT c.CountryName AS CountryName,
         	   p.Elevation AS PeakElevation, 
         	   r.Length AS RiverLength 
           FROM Countries AS c
         LEFT JOIN MountainsCountries AS mc
         ON c.CountryCode = mc.CountryCode
         LEFT JOIN Peaks AS p
         ON mc.MountainId = p.MountainId
         LEFT JOIN CountriesRivers AS cr
         ON c.CountryCode = cr.CountryCode
         LEFT JOIN Rivers AS r
         ON cr.RiverId = r.Id
        ) AS Sorted
 GROUP BY Sorted.CountryName
 ORDER BY MAX(Sorted.PeakElevation) DESC, 
	      MAX(Sorted.RiverLength) DESC, 
		  Sorted.CountryName

--problem 18.Highest Peak Name and Elevation by Country










