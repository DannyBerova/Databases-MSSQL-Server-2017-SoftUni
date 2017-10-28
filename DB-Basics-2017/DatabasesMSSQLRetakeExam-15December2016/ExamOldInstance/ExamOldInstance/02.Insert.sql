INSERT INTO Messages(Content, SentOn, ChatId, UserId)
SELECT CONCAT(u.Age, '-', u.Gender, '-', l.Latitude, '-', l.Longitude) AS Content,
	   '2016-12-15' AS SentOn,
	   CASE 
	     WHEN u.Gender = 'F' THEN CEILING(SQRT(u.Age * 2))
	     WHEN u.Gender = 'M' THEN CEILING(POWER(u.Age / 18, 3))
	     END AS ChatId,
	   u.Id AS UserId
  FROM Users AS u
 INNER JOIN Locations AS l ON l.Id = u.LocationId
 WHERE u.Id BETWEEN 10 AND 20

