CREATE DATABASE Minions

CREATE TABLE Minions(
Id INT NOT NULL PRIMARY KEY,
Name NVARCHAR(50),
Age INT
)

CREATE TABLE Towns(
Id INT NOT NULL PRIMARY KEY,
Name NVARCHAR(50)
)


ALTER TABLE Minions
ADD TownId INT NOT NULL 

ALTER TABLE Minions
ADD CONSTRAINT FK_Town FOREIGN KEY (TownId) REFERENCES Towns(Id)

INSERT INTO Towns (Id, Name)
 VALUES (1, 'Sofia'), 
		(2, 'Plovdiv'), 
		(3, 'Varna')

INSERT INTO Minions (Id, Name, Age, TownId)
 VALUES (1, 'Kevin', 22, 1), 
		(2, 'Bob', 15, 3),
		(3, 'Steward', NULL , 2)
		

TRUNCATE TABLE Minions

DROP TABLE Minions
DROP TABLE Towns

CREATE TABLE People(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Name NVARCHAR(200) NOT NULL,
Picture VARBINARY CHECK (DATALENGTH(Picture) < 900 * 1024),
Height DECIMAL(10, 2),
Weight DECIMAL(10, 2),
Gender CHAR(1) NOT NULL CHECK(Gender = 'm' OR Gender = 'f'),
Birthdate DATE NOT NULL,
Biography NVARCHAR(MAX)
)

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Emil', NULL, 0.92, 14.80, 'm', '2015-07-16', 'Boss in command'),
	   ('Nick', NULL, 1.92, 103.50, 'm', '2015-07-16', 'Boss in charge'),
	   ('Danny', NULL, 1.64, 66.00, 'f', '2015-07-16', 'Boss for real'),
	   ('Mia', NULL, 0.45, 7.80, 'm', '2014.03.31', 'Cat in command'),
	   ('Bear', NULL, 0.38, 0.20, 'm', '2015-10-16', 'Toy slave')
	   

CREATE TABLE Users(
Id INT PRIMARY KEY IDENTITY NOT NULL,
Username VARCHAR(30) UNIQUE NOT NULL,
Password VARCHAR(26) NOT NULL,
Picture VARBINARY CHECK (DATALENGTH(Picture) < 900 * 1024),
LastLoginTime DATETIME NOT NULL,
IsDeleted BIT
)

INSERT INTO Users(Username, Password, LastLoginTime, IsDeleted)
VALUES ('GrandeBoss', 'aaAAaa', GETDATE(), 0),
	   ('DadBoss', 'BBbbBB', GETDATE(), 0),
	   ('MOMyyY', '123123', GETDATE(), 0),
	   ('CATcat', 'MEOOW', GETDATE(), 0),
	   ('toyBear', 'abcdef12', GETDATE(), 1)
	   
	   
ALTER TABLE Users
DROP CONSTRAINT [PK__Users__3214EC07DFD2C8BD]

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id, Username)

ALTER TABLE Users
ADD CONSTRAINT PassMinLength
CHECK (DATALENGTH (Password) >= 5)

ALTER TABLE Users
ADD DEFAULT GETDATE() FOR LastLoginTime

ALTER TABLE Users
DROP CONSTRAINT PK_Users

ALTER TABLE Users
ADD CONSTRAINT PK_Users PRIMARY KEY (Id)

ALTER TABLE Users
ADD CONSTRAINT uc_Username UNIQUE (Username)

ALTER TABLE Users
ADD CONSTRAINT uc_UsernameLength CHECK (DATALENGTH (Username) >= 3)


CREATE DATABASE Movies 


CREATE TABLE Directors (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	DirectorName NVARCHAR(200) NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Genres (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	GenreName NVARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	CategoryName NVARCHAR(50) NOT NULL,
	Notes NVARCHAR(MAX)
)

CREATE TABLE Movies (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Title NVARCHAR(100) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
	CopyrightYear DATE,
	[Length] BIGINT,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	Rating INT,
	Notes NVARCHAR(MAX)
)

INSERT INTO Directors (DirectorName, Notes) 
VALUES ('Gosho', 'A neat one'),
		('Pesho The Director', 'Oscar winner'),
		('Martin Scorsezov', 'From our crew'),
		('Boys favorite one', 'Boom-boom, bang-bang'),
		('The Smart One', 'An absolute push-up puff')

INSERT INTO Genres(GenreName, Notes) 
VALUES ('Comedy', 'aaaahahahahahhaaa wet pants'),
		('Thriller', 'whoooooo-booo-whoooa'),
		('Drama', 'seriously messed-up'),
		('Love story', 'some sugar-candy b*llshi**'),
		('Animation', 'not only for kids')

INSERT INTO Categories(CategoryName, Notes) 
VALUES ('Category One', 'One note'),
		('Category Two', '2'),
		('Category Three', '3'),
		('Category Four', 'Four'),
		('Category Five', 'Five')

INSERT INTO Movies (Title, DirectorId, CopyrightYear, [Length], GenreId, Rating, Notes)
 VALUES ('Go Go Go', 1, '2000', '100', 1, 10, 'hihohi'),
		('Oscar Winner Moovie', 2, '2000', '200', 3, 10, 'Bla-bla'),
		('Gun fight and some dirty looks', 3, '2000', '120', 3, 9, 'tadadadaaaa'),
		('Titanic Fast and Furry', 4, '2001', '300', 4, 1, 'blaaaah'),
		('Finding Kung-Fu Panda', 5, '2017', '120', 5, 10, 'favorite one!')

--VERS 2

CREATE DATABASE CarRental 

CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	CategoryName VARCHAR(50) NOT NULL,
	DailyRate DECIMAL(10, 2), 
	WeeklyRate DECIMAL(10, 2), 
	MonthlyRate DECIMAL(10, 2),
	WeekendRate DECIMAL(10, 2)
	)

INSERT INTO Categories (CategoryName, DailyRate, WeeklyRate, MonthlyRate, WeekendRate) 
VALUES ('Slow', 3.55, 15.00, 70.00, 5.50), 
		('Fast', 5.55, 18.00, 88.00, 6.50),
		('Cruisin', 4.55, 17.00, 80.00, 6.50)

CREATE TABLE Cars (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	PlateNumber VARCHAR(MAX) NOT NULL,
	Manufacturer VARCHAR(50),
	Model VARCHAR(50) NOT NULL,
	CarYear INT,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Doors INT,
	Picture VARBINARY(MAX),
	Condition VARCHAR(150),
	Available BIT NOT NULL
)

INSERT INTO Cars (PlateNumber, Model, CarYear, CategoryId, Available)
VALUES ('AA 1111 AA', 'PPPORSH', 2000, 2, 1),
		('BB 1111 BB', 'Benc', 2000, 2, 1),
		('AA 2222 AA', 'Turtle', 2005, 1, 0)

CREATE TABLE Employees(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName VARCHAR (50) NOT NULL,
	LastName VARCHAR (50) NOT NULL,
	Title VARCHAR (50),
	Notes VARCHAR(MAX)
)


INSERT INTO Employees (FirstName, LastName, Title)
VALUES ('Peter', 'Smith', 'Driver'),
		 ('John', 'Doe', 'Assistant'),
		 ('Sam', 'Duncan', 'Manager')


CREATE TABLE Customers(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	DriverLicenceNumber INT NOT NULL UNIQUE,
	FullName VARCHAR (100) NOT NULL,
	Address VARCHAR (200),
	City VARCHAR (100),
	ZIPCode INT,
	Notes VARCHAR (MAX)
)

INSERT INTO Customers (DriverLicenceNumber, FullName, Address, City, ZIPCode)
VALUES ('12121212', 'Papoi Papoev', 'Some address', 'Varna', 9000), 
		('23232323', 'Papoi Papoev Jr', 'Same address', 'Varna', 9000),
		('12121234', 'Papoi Papoev Sr', 'Another address', 'Plovdiv', 4000)


CREATE TABLE RentalOrders (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	CustomerId INT FOREIGN KEY REFERENCES Customers(Id) NOT NULL,
	CarId INT NOT NULL,
	TankLevel DECIMAL (10, 2),
	KilometrageStart INT,
	KilometrageEnd INT,
	TotalKilometrage INT,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	TotalDays AS DATEDIFF(DAY, StartDate, EndDate),
	RateApplied VARCHAR (50),
	TaxRate DECIMAL(10, 2),
	OrderStatus VARCHAR(100),
	Notes VARCHAR(MAX)
)

INSERT INTO RentalOrders (EmployeeId, CustomerId, CarId, TankLevel, StartDate, EndDate) 
VALUES (1, 1, 1, 32, '05/05/2000', '10/05/2000'),
		(1, 2, 1, 5, '05/05/2017', '10/05/2017'),
		(1, 3, 2, 6, '05/05/2010', '10/05/2010')
		
		
		
CREATE DATABASE Hotel
USE Hotel

CREATE TABLE Employees (
		Id INT PRIMARY KEY IDENTITY NOT NULL,
		FirstName NVARCHAR(50) NOT NULL,
		LastName NVARCHAR(100) NOT NULL,
		Title NVARCHAR(100),
		Notes NVARCHAR(MAX)
)

INSERT INTO Employees (FirstName, LastName) 
VALUES ('Papoi', 'Papoev'),
        ('Douglas', 'Adams'),
		('Terry', 'Pratchet')

CREATE TABLE Customers (
		AccountNumber INT PRIMARY KEY IDENTITY NOT NULL,
		FirstName NVARCHAR(50) NOT NULL,
		LastName NVARCHAR(50) NOT NULL,
		PhoneNumber INT,
		EmergencyName NVARCHAR(100),
		EmergencyNumber INT,
		Notes NVARCHAR(MAX)
)
INSERT INTO Customers (FirstName, LastName) 
VALUES ('Granny', 'Weatherwax'),
		('Maggrat', 'Garlic'),
		('Aunt', 'Ogg')

CREATE TABLE RoomStatus (
		RoomStatus NVARCHAR(50) PRIMARY KEY NOT NULL,
		Notes NVARCHAR(MAX)
)

INSERT INTO RoomStatus (RoomStatus) 
VALUES ('Ready to use'),
		('Available'),
		('Occupied')

CREATE TABLE RoomTypes (
		RoomType NVARCHAR(50) PRIMARY KEY NOT NULL,
		Notes NVARCHAR(MAX)
)

INSERT INTO RoomTypes (RoomType) 
VALUES ('Apartment'),
		('Studio'),
		('Double')

CREATE TABLE BedTypes (
		BedType NVARCHAR(50) PRIMARY KEY NOT NULL,
		Notes NVARCHAR(MAX)
)

INSERT INTO BedTypes (BedType) 
VALUES ('Single'),
		('Double'),
		('KingSize')

CREATE TABLE Rooms (
		RoomNumber INT PRIMARY KEY IDENTITY NOT NULL,
		RoomType NVARCHAR(50) FOREIGN KEY REFERENCES RoomTypes(RoomType),
		BedType NVARCHAR(50) FOREIGN KEY REFERENCES BedTypes(BedType),
		Rate DECIMAL(10,2),
		RoomStatus NVARCHAR(50),
		Notes NVARCHAR(MAX)
)

INSERT INTO Rooms (Rate) 
VALUES (25.00),
		(38.00),
		(49.99)

CREATE TABLE Payments (
		Id INT PRIMARY KEY IDENTITY NOT NULL,
		EmployeeId INT,
		PaymentDate DATE,
		AccountNumber INT,
		FirstDateOccipied DATE,
		LastDateOccupied DATE,
		TotalDays AS DATEDIFF(DAY, FirstDateOccipied, LastDateOccupied),
		AmountCharged DECIMAL(10, 2),
		TaxRate DECIMAL(10, 2),
		TaxAmount DECIMAL(10, 2),
		PaymentTotal DECIMAL(15, 2),
		Notes NVARCHAR(MAX)
)

INSERT INTO Payments (EmployeeId, PaymentDate, AmountCharged) 
VALUES (1, GETDATE(), 100.00),
		(2, GETDATE(), 2000.00),
		(3, GETDATE(), 2500.00)

CREATE TABLE Occupancies (
		Id INT PRIMARY KEY IDENTITY NOT NULL,
		EmployeeId INT,
		DateOccipied DATE,
		AccountNumber INT,
		RoomNumber INT,
		RateApplied DECIMAL(10, 2),
		PhoneCharge DECIMAL(10, 2),
		Notes NVARCHAR(MAX)
)

INSERT INTO Occupancies (EmployeeId, RoomNumber, RateApplied, Notes) 
VALUES (1, 49.99, 13, 'Granny'),
		(2, 49.99, 23,  'Maggrat'),
		(3, 49.99, 32, 'Aunty')

		
		
CREATE DATABASE SoftUni
GO  

USE SoftUni
GO

CREATE TABLE Towns (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(50)
)

CREATE TABLE Addresses (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	AddressText NVARCHAR(100),
	TownId INT FOREIGN KEY REFERENCES Towns(Id)
)

CREATE TABLE Departments (
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	Name NVARCHAR(50)
)

CREATE TABLE Employees
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	FirstName NVARCHAR(50),
	MiddleName NVARCHAR(50),
	LastName NVARCHAR(50),
	JobTitle NVARCHAR(35),
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id),
	HireDate DATE,
	Salary DECIMAL(10,2),
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)




		




