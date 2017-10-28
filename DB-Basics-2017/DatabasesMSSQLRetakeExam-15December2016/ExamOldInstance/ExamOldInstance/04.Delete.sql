DELETE FROM Locations
WHERE Id NOT IN (SELECT DISTINCT LocationId FROM Users
                 WHERE LocationId IS NOT NULL)