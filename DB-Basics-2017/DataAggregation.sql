
USE Gringotts

--PROBLEM 1
SELECT COUNT(Id) AS Count 
  FROM WizzardDeposits

--PROBLEM 2
SELECT MAX(MagicWandSize) AS LongestMagicWand 
  FROM WizzardDeposits

--PROBLEM 3
SELECT DepositGroup, 
	   MAX(MagicWandSize) AS LongestMagicWand 
  FROM WizzardDeposits
 GROUP BY DepositGroup

--PROBLEM 4
SELECT TOP (2) DepositGroup
  FROM WizzardDeposits
 GROUP BY DepositGroup
 ORDER BY AVG(MagicWandSize)

--PROBLEM 5
SELECT DepositGroup, 
	   SUM(DepositAmount) AS TotalSum 
  FROM WizzardDeposits
 GROUP BY DepositGroup

--PROBLEM 6
SELECT DepositGroup, 
	   SUM(DepositAmount) AS TotalSum 
  FROM WizzardDeposits
 WHERE MagicWandCreator = 'Ollivander family'
 GROUP BY DepositGroup

--PROBLEM 7
SELECT DepositGroup, 
	   SUM(DepositAmount) AS TotalSum 
  FROM WizzardDeposits
 WHERE MagicWandCreator = 'Ollivander family'
 GROUP BY DepositGroup
 HAVING SUM(DepositAmount) < 150000
 ORDER BY TotalSum DESC

--PROBLEM 8
SELECT DepositGroup, 
	   MagicWandCreator, 
	   MIN(DepositCharge) AS MinDepositCharge 
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, 
	     DepositGroup

--PROBLEM 9
SELECT AgeGroups.AgeGroup, COUNT(*) AS WizardCount 
  FROM (
SELECT
  CASE
	 WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
	 WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
	 WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
	 WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
	 WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
	 WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
	 WHEN Age >= 61 THEN '[61+]'
   END AS AgeGroup
  FROM WizzardDeposits) AS AgeGroups
 GROUP BY AgeGroups.AgeGroup


--PROBLEM 10
SELECT LEFT(FirstName, 1) AS FirstLetter 
  FROM WizzardDeposits
 WHERE DepositGroup = 'Troll Chest'
 GROUP BY LEFT(FirstName, 1)
 ORDER BY FirstLetter

--PROBLEM 11
SELECT DepositGroup, 
	   IsDepositExpired, 
	   AVG(DepositInterest) AS AverageInterest
  FROM WizzardDeposits
 WHERE DepositStartDate > '1985.01.01'
 GROUP BY DepositGroup, IsDepositExpired
 ORDER BY DepositGroup DESC, IsDepositExpired

--PROBLEM 12
SELECT SUM(WizzDeposit.Difference) AS SumDifference 
FROM(
SELECT FirstName AS [Host Wizard], 
	   DepositAmount AS [Host Wizard Deposit],
	   LEAD(FirstName) OVER (ORDER BY Id) AS [Gues tWizard],
	   LEAD(DepositAmount) OVER (ORDER BY Id) AS [Guest Wizard Deposit],
	   DepositAmount - LEAD(DepositAmount) OVER (ORDER BY Id) AS [Difference] 
 FROM WizzardDeposits) AS WizzDeposit


USE SoftUni

--PROBLEM 13
SELECT DepartmentID, 
	   MIN(Salary) AS MinimumSalary 
  FROM Employees
 WHERE DepartmentID IN (2, 5, 7) AND HireDate > '01/01/2000'
 GROUP BY DepartmentID
 ORDER BY DepartmentID

--PROBLEM 14
SELECT * INTO PlayingTable FROM Employees
 WHERE Salary > 30000

DELETE FROM PlayingTable
 WHERE ManagerId = 42

UPDATE PlayingTable
   SET Salary += 5000
 WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS AverageSalary
  FROM PlayingTable
 GROUP BY DepartmentID

--PROBLEM 15
SELECT DepartmentID, MAX(Salary) AS MaxSalary
  FROM Employees
 GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--PROBLEM 17
SELECT COUNT(Salary) AS Count
  FROM Employees
 WHERE ManagerID IS NULL

--PROBLEM 18
SELECT OrderedSalaries.DepartmentID, 
	   OrderedSalaries.Salary AS ThirdHighestSalary 
  FROM (
	   SELECT DepartmentId,
	   MAX(Salary) AS Salary,
	   DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY Salary DESC) AS Rank
	   FROM Employees
	   GROUP BY DepartmentID, Salary
	   )
	   AS OrderedSalaries
WHERE Rank=3

--PROBLEM 19
SELECT TOP 10 FirstName, 
			  LastName, 
			  DepartmentID FROM Employees AS e1
 WHERE Salary > 
			  (
			  SELECT AVG(Salary) FROM Employees AS e2
			  WHERE e1.DepartmentID = e2.DepartmentID
			  GROUP BY DepartmentID
			  )
ORDER BY DepartmentID


