
USE SoftUni

--problem 1
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
			  AS
		  SELECT FirstName AS [First Name], 
				 LastName AS [Last Name] 
            FROM Employees 
           WHERE Salary > 35000

EXEC usp_GetEmployeesSalaryAbove35000
GO

--problem 2
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber (@Number DECIMAL(18, 4))
              AS
		  SELECT FirstName AS [First Name],
		         LastName AS [Last Name]
		    FROM Employees
		   WHERE Salary >= @Number

EXEC usp_GetEmployeesSalaryAboveNumber 48100
GO

--problem 3
CREATE PROCEDURE usp_GetTownsStartingWith (@SearchedChars NVARCHAR(MAX))
              AS
	      SELECT [Name] AS Town
      	    FROM Towns
		   WHERE SUBSTRING(Name, 1, LEN(@SearchedChars)) = @SearchedChars

EXEC usp_GetTownsStartingWith 'bor'
GO

--problem 4
CREATE PROCEDURE usp_GetEmployeesFromTown (@TownName VARCHAR(50))
              AS
	      SELECT FirstName AS [First Name],
		         LastName AS [Last Name]
		    FROM Employees AS e
	  INNER JOIN Addresses AS a 
		      ON a.AddressID = e.AddressID
	  INNER JOIN Towns AS t 
		      ON t.TownID = a.TownID
	WHERE t.Name = @TownName

EXEC usp_GetEmployeesFromTown 'Sofia'
GO

--problem 5
CREATE FUNCTION ufn_GetSalaryLevel (@Salary DECIMAL (18, 4))
  RETURNS VARCHAR(10)
	   AS
	   BEGIN
		 DECLARE @SalaryLevel VARCHAR(10)
		 IF (@Salary < 30000)
		     BEGIN
				SET @SalaryLevel = 'Low'
			 END
		 ELSE IF (@Salary BETWEEN 30000 AND 50000)
			 BEGIN
				SET @SalaryLevel = 'Average'
			 END
		 ELSE
			BEGIN
				SET @SalaryLevel = 'High'
			END

			RETURN @SalaryLevel
	   END

SELECT FirstName, LastName, Salary, dbo.ufn_GetSalaryLevel(Salary) AS SalaryLevel
FROM Employees
ORDER BY Salary DESC
GO

--problem 6
CREATE PROCEDURE usp_EmployeesBySalaryLevel (@LevelOfSalary VARCHAR(10))
              AS
		  SELECT FirstName AS [First Name],
		         LastName AS [Last Name]
		    FROM Employees
		   WHERE dbo.ufn_GetSalaryLevel(Salary) = @LevelOfSalary

EXEC usp_EmployeesBySalaryLevel 'Low'
GO

--problem 7
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(max), @word VARCHAR(max))
  RETURNS BIT
  AS
  BEGIN
    DECLARE @isComprised BIT = 0;
    DECLARE @currentIndex INT = 1;
    DECLARE @currentChar CHAR;

    WHILE(@currentIndex <= LEN(@word))
    BEGIN

      SET @currentChar = SUBSTRING(@word, @currentIndex, 1);
      IF(CHARINDEX(@currentChar, @setOfLetters) = 0)
        RETURN @isComprised;
      SET @currentIndex += 1;

    END

    RETURN @isComprised + 1;

  END

GO
SELECT dbo.ufn_IsWordComprised('oistmiahf', 'Sofia')
GO
SELECT dbo.ufn_IsWordComprised('oistmiahf', 'halves')
GO

--problem 8
 CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
          AS
 ALTER TABLE Departments
ALTER COLUMN ManagerID INT NULL

DELETE FROM EmployeesProjects
 WHERE EmployeeID IN 
	   (
	   	SELECT EmployeeID FROM Employees
	   	WHERE DepartmentID = @departmentId
	   )

UPDATE Employees
   SET ManagerID = NULL
 WHERE ManagerID IN 
	   (
		SELECT EmployeeID FROM Employees
		WHERE DepartmentID = @departmentId
	   )


UPDATE Departments
   SET ManagerID = NULL
 WHERE ManagerID IN 
	   (
		SELECT EmployeeID FROM Employees
		WHERE DepartmentID = @departmentId
	   )

DELETE FROM Employees
 WHERE EmployeeID IN 
	   (
	   	SELECT EmployeeID FROM Employees
	   	WHERE DepartmentID = @departmentId
	   )

DELETE FROM Departments
 WHERE DepartmentID = @departmentId
SELECT COUNT(*) AS [Employees Count] 
 FROM Employees AS e
 JOIN Departments AS d
   ON d.DepartmentID = e.DepartmentID
WHERE e.DepartmentID = @departmentId
GO

USE Bank

--problem 9
CREATE PROC usp_GetHoldersFullName
AS
  SELECT CONCAT(FirstName, ' ', LastName) AS [Full Name]
  FROM AccountHolders

EXEC usp_GetHoldersFullName
GO

--problem 10
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan (@Parameter DECIMAL(16, 2))
              AS
		  SELECT ah.FirstName AS [First Name],
		         ah.LastName AS [Last Name]
		    FROM AccountHolders AS ah
	  INNER JOIN Accounts AS a
		      ON a.AccountHolderId = ah.Id
		GROUP BY ah.FirstName, ah.LastName
		  HAVING SUM(a.Balance) > @Parameter

EXEC usp_GetHoldersWithBalanceHigherThan 12346.78
GO

--problem 11
CREATE FUNCTION ufn_CalculateFutureValue (@sum money, @annualIntRate float, @years int)
  RETURNS money
  AS
  BEGIN
    RETURN @sum * POWER(1 + @annualIntRate, @years);  
  END

SELECT dbo.ufn_CalculateFutureValue(1000, 0.10, 5) AS FV
GO

--problem 12
CREATE PROC usp_CalculateFutureValueForAccount (@AccountId int, @InterestRate float)
  AS
  BEGIN
    DECLARE @years int = 5;

    SELECT a.Id AS [Account Id],
           ah.FirstName AS [First Name],
           ah.LastName AS [Last Name], 
           a.Balance AS [Current Balance],
           dbo.ufn_CalculateFutureValue(a.Balance, @InterestRate, @years) AS [Balance in 5 years]
      FROM AccountHolders AS ah
      JOIN Accounts AS a ON ah.Id = a.AccountHolderId
     WHERE a.Id = @AccountId

  END

EXEC usp_CalculateFutureValueForAccount 1, 0.10
GO

--problem 13
CREATE FUNCTION ufn_CashInUsersGames(@gameName NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN
	SELECT SUM(Cash) AS SumCash FROM 
		(
		       SELECT ug.Cash, 
			          ROW_NUMBER() OVER(ORDER BY Cash DESC) AS RowNum 
		         FROM UsersGames AS ug
		   INNER JOIN Games AS g
		           ON g.Id = ug.GameId
		        WHERE g.Name = @gameName
		) AS CashList
     WHERE RowNum % 2 = 1