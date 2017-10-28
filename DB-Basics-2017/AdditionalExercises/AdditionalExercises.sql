
USE Diablo

--Problem 1. Number of Users for Email Provider
SELECT ep.[Email Provider], 
       COUNT(ep.Username) AS [Number Of Users]
  FROM(
       SELECT Username, 
	          RIGHT(Email, LEN(Email) - CHARINDEX('@', Email, 1)) 
	          AS [Email Provider]
         FROM Users
       ) AS ep
  GROUP BY ep.[Email Provider]
  ORDER BY [Number Of Users] DESC, [Email Provider]

--Problem 2. All User in Games
SELECT g.Name AS Game,
       gt.Name AS [Game Type],
	   u.Username AS Username,
	   ug.Level,
	   ug.Cash,
	   ch.Name
  FROM Games AS g
 INNER JOIN UsersGames AS ug ON ug.GameId = g.Id
 INNER JOIN GameTypes AS gt ON gt.Id = g.GameTypeId
 INNER JOIN Characters AS ch ON ch.Id = ug.CharacterId
 INNER JOIN Users AS u ON u.Id = ug.UserId
 ORDER BY ug.Level DESC, u.Username, g.Name


--Problem 3. Users in Games with Their Items
SELECT u.Username AS Username,
       g.Name AS Game,
       COUNT(i.Id) AS ItemsCount,
       SUM(i.Price) AS Cash
  FROM Games AS g
 INNER JOIN UsersGames AS ug ON ug.GameId = g.Id
 INNER JOIN Users AS u ON u.Id = ug.UserId
 INNER JOIN UserGameItems AS ugt ON ugt.UserGameId = ug.Id
 INNER JOIN Items AS i ON i.Id = ugt.ItemId
 GROUP BY u.Username, g.Name
HAVING COUNT(i.Id) >= 10
 ORDER BY ItemsCount DESC, Cash DESC, u.Username

--Problem 4. User in Games with Their Statistics
SELECT u.Username,  
       g.Name AS Game, 
	   MAX(c.Name) AS Character, 
       MAX(cs.Strength) + MAX(gts.Strength) + SUM(gis.Strength) AS Strength, 
       MAX(cs.Defence) + MAX(gts.Defence) + SUM(gis.Defence) AS Defence, 
       MAX(cs.Speed) + MAX(gts.Speed) + SUM(gis.Speed) AS Speed, 
       MAX(cs.Mind) + MAX(gts.Mind) + SUM(gis.Mind) AS Mind, 
       MAX(cs.Luck) + MAX(gts.Luck) + SUM(gis.Luck) AS Luck
  FROM UsersGames AS ug
  JOIN Users AS u ON ug.UserId = u.Id
  JOIN Games AS g ON ug.GameId = g.Id
  JOIN Characters AS c ON ug.CharacterId = c.Id
  JOIN [Statistics] AS cs ON c.StatisticId = cs.Id
  JOIN GameTypes AS gt ON gt.Id = g.GameTypeId
  JOIN [Statistics] AS gts ON gts.Id = gt.BonusStatsId
  JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
  JOIN Items AS i ON i.Id = ugi.ItemId
  JOIN [Statistics] AS gis ON gis.Id = i.StatisticId
 GROUP BY u.Username, g.Name
 ORDER BY Strength DESC, 
          Defence DESC, 
		  Speed DESC, 
		  Mind DESC, 
		  Luck DESC

--Problem 5. All Items with Greater than Average Statistics

SELECT i.Name, 
       i.Price, 
	   i.MinLevel, 
       s.Strength, 
	   s.Defence, 
	   s.Speed, 
	   s.Luck, 
	   s.Mind
  FROM (  
       SELECT Id FROM [Statistics]
       WHERE Mind > (SELECT AVG(Mind  * 1.0) FROM [Statistics]) AND
             Luck > (SELECT AVG(Luck  * 1.0) FROM [Statistics]) AND
             Speed > (SELECT AVG(Speed * 1.0) FROM [Statistics])
        ) AS av
  JOIN [Statistics] AS s ON av.Id = s.Id
  JOIN Items AS i ON i.StatisticId = s.Id
 ORDER BY i.Name

--Problem 6. Display All Items with Information about Forbidden Game Type
SELECT i.Name AS [Item Name],
       i.Price,
	   i.MinLevel,
	   gt.Name AS [Forbidden Game Type]
 FROM Items AS i
 LEFT JOIN GameTypeForbiddenItems AS gtfi ON gtfi.ItemId = i.Id
 LEFT JOIN GameTypes AS gt ON gt.Id = gtfi.GameTypeId
ORDER BY [Forbidden Game Type] DESC, [Item Name] 


--Problem 7. Buy Items for User in Game

DECLARE @gameName nvarchar(50) = 'Edinburgh'
DECLARE @username nvarchar(50) = 'Alex'

DECLARE @userGameId int = (
  SELECT ug.Id 
  FROM UsersGames AS ug
  JOIN Users AS u ON ug.UserId = u.Id
  JOIN Games AS g ON ug.GameId = g.Id
  WHERE u.Username = @username AND g.Name = @gameName
  )

DECLARE @availableCash money = (
  SELECT Cash FROM UsersGames WHERE Id = @userGameId)

DECLARE @purchasePrice money = (
  SELECT SUM(Price) FROM Items WHERE Name IN 
  ('Blackguard', 'Bottomless Potion of Amplification', 'Eye of Etlich (Diablo III)',
  'Gem of Efficacious Toxin', 'Golden Gorget of Leoric', 'Hellfire Amulet')
  )

IF (@availableCash >= @purchasePrice) 
BEGIN 
  BEGIN TRANSACTION  
  UPDATE UsersGames SET Cash -= @purchasePrice WHERE Id = @userGameId

  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK
	RAISERROR('Could not make payment', 16, 1)
	RETURN
  END

  INSERT INTO UserGameItems (ItemId, UserGameId) 
    (SELECT Id, @userGameId FROM Items WHERE Name IN 
    ('Blackguard', 'Bottomless Potion of Amplification', 'Eye of Etlich (Diablo III)',
    'Gem of Efficacious Toxin', 'Golden Gorget of Leoric', 'Hellfire Amulet')) 

  IF((SELECT COUNT(*) FROM Items WHERE Name IN 
      ('Blackguard', 'Bottomless Potion of Amplification', 'Eye of Etlich (Diablo III)', 
	  'Gem of Efficacious Toxin', 'Golden Gorget of Leoric', 'Hellfire Amulet')
	  ) <> @@ROWCOUNT)
  BEGIN
    ROLLBACK
	RAISERROR('Could not buy items', 16, 1)
	RETURN
  END	
  COMMIT
END

SELECT u.Username, 
       g.Name, 
	   ug.Cash, 
	   i.Name AS [Item Name]
  FROM UsersGames AS ug
  JOIN Games AS g ON ug.GameId = g.Id
  JOIN Users AS u ON ug.UserId = u.Id
  JOIN UserGameItems AS ugi ON ug.Id = ugi.UserGameId
  JOIN Items AS i ON i.Id = ugi.ItemId
 WHERE g.Name = @gameName


USE Geography

--Problem 8. Peaks and Mountains
SELECT p.PeakName,
       m.MountainRange AS Mountain,
	   p.Elevation
  FROM Peaks AS p
  JOIN Mountains AS m ON m.Id = p.MountainId
 ORDER BY p.Elevation DESC, p.PeakName

--Problem 9. Peaks with Their Mountain, Country and Continent
SELECT p.PeakName,
       m.MountainRange AS Mountain,
	   c.CountryName,
	   con.ContinentName
  FROM Peaks AS p
  JOIN Mountains AS m ON m.Id = p.MountainId
  JOIN MountainsCountries AS mc ON mc.MountainId = m.Id
  JOIN Countries AS c ON c.CountryCode = mc.CountryCode
  JOIN Continents AS con ON con.ContinentCode = c.ContinentCode
 ORDER BY p.PeakName, c.CountryName

--Problem 10. Rivers by Country
SELECT c.CountryName,
       con.ContinentName,
	   COUNT(r.Id) AS RiversCount,
	   ISNULL(SUM(r.Length), 0) AS TotalLength
  FROM Countries AS c
  LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
  LEFT JOIN Rivers AS r ON r.Id = cr.RiverId
 INNER JOIN Continents AS con ON con.ContinentCode = c.ContinentCode
 GROUP BY c.CountryName, con.ContinentName
 ORDER BY RiversCount DESC, TotalLength DESC, c.CountryName
  

--Problem 11. Count of Countries by Currency
SELECT cu.CurrencyCode, 
       cu.Description AS Currency,
	   COUNT(co.CountryCode) AS NumberOfCountries
  FROM Currencies AS cu
  LEFT JOIN Countries AS co ON co.CurrencyCode = cu.CurrencyCode
 GROUP BY cu.CurrencyCode, cu.Description
 ORDER BY NumberOfCountries DESC, cu.Description

--Problem 12. Population and Area by Continent
SELECT con.ContinentName AS ContinentName,
       SUM(cou.AreaInSqKm) AS CountriesArea,
       SUM(CAST(cou.[Population] AS float)) AS CountriesPopulation 
  FROM Continents AS con
  JOIN Countries AS cou ON cou.ContinentCode = con.ContinentCode
 GROUP BY con.ContinentName
 ORDER BY CountriesPopulation DESC

--Problem 13. Monasteries by Country

--SUB 1
CREATE TABLE Monasteries (
  Id INT PRIMARY KEY IDENTITY, 
  Name VARCHAR (100) NOT NULL, 
  CountryCode CHAR(2) FOREIGN KEY REFERENCES Countries(CountryCode))

--SUB 2
  INSERT INTO Monasteries(Name, CountryCode) VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')

--SUB 3
--ALTER TABLE Countries
--ADD IsDeleted BIT NOT NULL DEFAULT 0

--SUB 4
UPDATE Countries
SET [IsDeleted] = 1
WHERE CountryCode IN(
       SELECT a.Code 
	     FROM (SELECT c.CountryCode AS Code, 
		             COUNT(cr.RiverId) AS CountRivers FROM Countries AS c
                JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
               GROUP BY c.CountryCode
              ) AS a
        WHERE a.CountRivers > 3)

--SUB 5
SELECT m.Name AS Monastery,
       f.CountryName AS Country 
	   FROM Monasteries AS m
JOIN (SELECT * FROM Countries
      WHERE IsDeleted = 0) AS f
	  ON f.CountryCode = m.CountryCode
ORDER BY m.Name

--Problem 14. Monasteries by Continents and Countries

--SUB 1
UPDATE Countries
   SET CountryName = 'Burma'
 WHERE CountryName = 'Myanmar'

--SUB 2
INSERT INTO Monasteries (Name, CountryCode)
    (SELECT 'Hanga Abbey', 
	        CountryCode
       FROM Countries AS c 
      WHERE CountryName = 'Tanzania')

--SUB 3
 INSERT INTO Monasteries (Name, CountryCode)
   (SELECT 'Myin-Tin-Daik', 
           CountryCode
      FROM Countries AS c 
     WHERE CountryName = 'Myanmar')


--SUB 4
SELECT con.ContinentName AS ContinentName,
       cou.CountryName AS CountryName,
	   COUNT (m.Id) AS MonasteriesCount
  FROM Continents AS con
  JOIN Countries AS cou ON cou.ContinentCode = con.ContinentCode
  LEFT JOIN Monasteries AS m ON m.CountryCode = cou.CountryCode
 WHERE cou.IsDeleted = 0
 GROUP BY con.ContinentName, cou.CountryName
 ORDER BY MonasteriesCount DESC, CountryName
