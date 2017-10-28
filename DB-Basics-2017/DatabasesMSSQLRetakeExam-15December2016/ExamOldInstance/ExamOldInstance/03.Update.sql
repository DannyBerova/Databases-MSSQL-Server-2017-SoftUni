UPDATE Chats
SET StartDate = (SELECT MIN(m.SentOn) FROM Chats AS c
				 INNER JOIN Messages AS m ON m.ChatId = c.Id
				 WHERE c.Id = Chats.Id)
WHERE Chats.Id IN(SELECT c.Id FROM Chats AS c
				  INNER JOIN Messages AS m ON m.ChatId = c.Id
				  GROUP BY c.Id, c.StartDate
				  HAVING c.StartDate > MIN(m.SentOn)
				  )