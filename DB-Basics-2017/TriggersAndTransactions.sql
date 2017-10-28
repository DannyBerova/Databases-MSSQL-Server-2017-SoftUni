USE Bank
GO

--problem 1

--CREATE TABLE Logs (
--       LogId INT PRIMARY KEY IDENTITY,
--       AccountId INT,
--       OldSum Money,
--       NewSum Money
--       )


CREATE TRIGGER InsertNewEntryIntoLogs ON Accounts
 AFTER UPDATE
    AS
INSERT INTO Logs
VALUES(
       (SELECT Id FROM inserted),
	   (SELECT Balance FROM deleted),
	   (SELECT Balance FROM inserted)
	   )

GO
--problem 2

--CREATE TABLE NotificationEmails (
--       Id INT PRIMARY KEY IDENTITY,
--	     Recipient INT,
--	     Subject VARCHAR(MAX),
--	     Body VARCHAR(MAX)
--	   )

CREATE TRIGGER CreateNewNotificationEmail ON Logs
 AFTER INSERT
    AS
 BEGIN
INSERT INTO NotificationEmails
VALUES(
       (SELECT AccountId FROM inserted),
	   (CONCAT('Balance change for account: ', (SELECT AccountId FROM inserted))),
	   (CONCAT('On ',(SELECT GETDATE() FROM inserted),
	    'your balance was changed from ', (SELECT OldSum FROM inserted), 
		'to ', (SELECT NewSum FROM inserted), '.'))
	   )
   END

GO

--problem 3

CREATE PROCEDURE usp_DepositMoney (@AccountId INT, @MoneyAmount MONEY) 
    AS
 BEGIN TRANSACTION
 UPDATE Accounts
    SET Balance += @MoneyAmount
  WHERE Id = @AccountId
 COMMIT

GO
--problem 4

CREATE PROCEDURE usp_WithdrawMoney (@AccountId INT, @MoneyAmount MONEY)
    AS
 BEGIN TRANSACTION
 UPDATE Accounts
    SET Balance -= @MoneyAmount
  WHERE Id = @AccountId
 COMMIT

GO
--problem 5

CREATE PROCEDURE usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(15, 4))
AS
BEGIN
	BEGIN TRANSACTION
	  EXEC dbo.usp_WithdrawMoney @SenderId, @Amount
	  EXEC dbo.usp_DepositMoney @ReceiverId, @Amount
	  IF 
	  (
	    SELECT Balance 
	      FROM Accounts
	     WHERE Accounts.Id = @SenderId ) < 0
	  BEGIN
	  	ROLLBACK
	  END
	  ELSE
	  BEGIN
	  COMMIT
	END
END

GO

--problem 5.1 /Melik's (Vladi's) solution with lots of raiseerors

CREATE PROCEDURE usp_TransferMoney (@senderId int, @receiverId int, @transferAmount money)
AS
BEGIN 

  DECLARE @senderBalanceBefore money = (SELECT Balance FROM Accounts WHERE Id = @senderId);

  IF(@senderBalanceBefore IS NULL)
  BEGIN
    RAISERROR('Invalid sender account!', 16, 1);
    RETURN;

  END   

  DECLARE @receiverBalanceBefore money = (SELECT Balance FROM Accounts WHERE Id = @receiverId);  

  IF(@receiverBalanceBefore IS NULL)
  BEGIN
    RAISERROR('Invalid receiver account!', 16, 1);
    RETURN;
  END   

  IF(@senderId = @receiverId)
  BEGIN
    RAISERROR('Sender and receiver accounts must be different!', 16, 1);
    RETURN;
  END  

  IF(@transferAmount <= 0)
  BEGIN
    RAISERROR ('Transfer amount must be positive!', 16, 1); 
    RETURN;

  END 

  BEGIN TRANSACTION
  EXEC usp_WithdrawMoney @senderId, @transferAmount;
  EXEC usp_DepositMoney @receiverId, @transferAmount;

  DECLARE @senderBalanceAfter money = (SELECT Balance FROM Accounts WHERE Id = @senderId);
  DECLARE @receiverBalanceAfter money = (SELECT Balance FROM Accounts WHERE Id = @receiverId);  

  IF((@senderBalanceAfter <> @senderBalanceBefore - @transferAmount) OR 
     (@receiverBalanceAfter <> @receiverBalanceBefore + @transferAmount))
    BEGIN
      ROLLBACK;
      RAISERROR('Invalid account balances!', 16, 1);
      RETURN;
    END

  COMMIT;

END

go

USE Diablo
--problem 6 - Bullsized's solution

CREATE TRIGGER tr_RestrictHigherLevelItems
ON UserGameItems AFTER INSERT
AS
BEGIN
	DECLARE @ItemMinLevel INT = 
	(
		SELECT i.MinLevel FROM inserted AS ins
		INNER JOIN Items AS i ON i.Id = ins.ItemId
	)
	DECLARE @UserLevel INT = 
	(
		SELECT ug.[Level] FROM inserted AS ins
		INNER JOIN UsersGames AS ug ON ug.Id = ins.UserGameId
	)

	IF (@UserLevel < @ItemMinLevel)
	BEGIN
		RAISERROR('Your level is too low to aquire that item!', 16, 1)
		ROLLBACK
		RETURN
	END
END


GO

--problem 7 * Course's old instance solution -- Melik's GitHub and small correction
DECLARE @gameName nvarchar(50) = 'Safflower'
DECLARE @username nvarchar(50) = 'Stamat'

DECLARE @userGameId int = (
                           SELECT ug.Id 
                           FROM UsersGames AS ug
                           JOIN Users AS u ON ug.UserId = u.Id
                           JOIN Games AS g ON ug.GameId = g.Id
                           WHERE u.Username = @username AND g.Name = @gameName)

DECLARE @userGameLevel int = (SELECT Level FROM UsersGames WHERE Id = @userGameId)
DECLARE @itemsCost money, @availableCash money, @minLevel int, @maxLevel int

SET @minLevel = 11
SET @maxLevel = 12
SET @availableCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameId)
SET @itemsCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel)

IF (@availableCash >= @itemsCost AND @userGameLevel >= @maxLevel) 

BEGIN 
  BEGIN TRANSACTION  
  UPDATE UsersGames SET Cash -= @itemsCost WHERE Id = @userGameId 
  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK
    RAISERROR('Could not make payment', 16, 1)
  END
  ELSE
  BEGIN
    INSERT INTO UserGameItems (ItemId, UserGameId) 
    (SELECT Id, @userGameId FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) 

    IF((SELECT COUNT(*) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) <> @@ROWCOUNT)
    BEGIN
      ROLLBACK; 
      RAISERROR('Could not buy items', 16, 1)
    END	
    ELSE COMMIT;
  END
END

SET @minLevel = 19
SET @maxLevel = 21
SET @availableCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameId)
SET @itemsCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel)

IF (@availableCash >= @itemsCost AND @userGameLevel >= @maxLevel) 

BEGIN 
  BEGIN TRANSACTION  
  UPDATE UsersGames SET Cash -= @itemsCost WHERE Id = @userGameId 

  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK
    RAISERROR('Could not make payment', 16, 1)
  END
  ELSE
  BEGIN
    INSERT INTO UserGameItems (ItemId, UserGameId) 
    (SELECT Id, @userGameId FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) 

    IF((SELECT COUNT(*) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) <> @@ROWCOUNT)
    BEGIN
      ROLLBACK
      RAISERROR('Could not buy items', 16, 1)
    END	
    ELSE COMMIT;
  END
END

SELECT i.Name AS [Item Name]
  FROM UserGameItems AS ugi
  JOIN Items AS i ON i.Id = ugi.ItemId
  JOIN UsersGames AS ug ON ug.Id = ugi.UserGameId
  JOIN Games AS g ON g.Id = ug.GameId
 WHERE g.Name = @gameName
 ORDER BY [Item Name]

GO
USE SoftUni

--problem 8

CREATE PROCEDURE usp_AssignProject (@employeeId INT, @projectID INT)
AS
BEGIN
	BEGIN TRAN
	INSERT INTO EmployeesProjects 
	VALUES (@employeeId, @projectID)
	IF(SELECT COUNT(ProjectID)
	     FROM EmployeesProjects
	    WHERE EmployeeID = @employeeId) > 3
	BEGIN
		RAISERROR('The employee has too many projects!', 16, 1)
		ROLLBACK
		RETURN
	END
	COMMIT
END

GO

--problem 9

CREATE TABLE Deleted_Employees
(
  EmployeeId INT PRIMARY KEY IDENTITY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  MiddleName VARCHAR(50),
  JobTitle VARCHAR(50),
  DepartmentId INT,
  Salary DECIMAL (15, 2)
)

--do not submit table creation!
GO
-------
CREATE TRIGGER tr_DeleteEmployees ON Employees
AFTER DELETE 
AS
BEGIN
  INSERT INTO Deleted_Employees
  SELECT FirstName, 
         LastName, 
  	   MiddleName, 
  	   JobTitle, 
  	   DepartmentID, 
  	   Salary 
  FROM deleted
END

-----
GO
