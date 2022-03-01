-- Drop database if exist
DROP DATABASE IF EXISTS MsQaMig;

-- Create database MsQaMig
CREATE DATABASE MsQaMig;

-- Create table Roles
CREATE TABLE MsQaMig.dbo.Roles (
	Id int IDENTITY(1,1) NOT NULL,
	Name nvarchar(256) COLLATE Latin1_General_100_CI_AS NOT NULL,
	CONSTRAINT [PK_dbo.Roles] PRIMARY KEY (Id)
);
 CREATE  UNIQUE NONCLUSTERED INDEX RoleNameIndex ON MsQaMig.dbo.Roles (  Name ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;

-- Create table Users
CREATE TABLE MsQaMig.dbo.Users (
	UserId int IDENTITY(1,1) NOT NULL,
	UserName nvarchar(256) COLLATE Latin1_General_100_CI_AS NOT NULL,
	Email nvarchar(256) COLLATE Latin1_General_100_CI_AS NULL,
	EmailConfirmed bit NOT NULL,
	DateCreated datetime DEFAULT '1900-01-01T00:00:00.000' NOT NULL,
	DateDisabled datetime NULL,
	RoleId int NOT NULL,
	CONSTRAINT PK_Users PRIMARY KEY (UserId),
	CONSTRAINT FK_Roles FOREIGN KEY (RoleId) REFERENCES MsQaMig.dbo.Roles(Id)
);
 CREATE  UNIQUE NONCLUSTERED INDEX UserNameIndex ON MsQaMig.dbo.Users (  UserName ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
	 
-- Create table Prices
CREATE TABLE MsQaMig.dbo.Prices (
	PriceId int IDENTITY(1,1) NOT NULL,
	Small money NULL,
	Medium money NULL,
	Large money NULL,
	UniSize money NULL,
	CONSTRAINT PK_Price PRIMARY KEY (PriceId)
);

-- Create tabe Addresses
CREATE TABLE MsQaMig.dbo.Address (
	AddressId int IDENTITY(1,1) NOT NULL,
	Country nvarchar(40) COLLATE Latin1_General_100_CI_AS NOT NULL,
	Street nvarchar(100) COLLATE Latin1_General_100_CI_AS NOT NULL,
	HouseNumber nvarchar(8) COLLATE Latin1_General_100_CI_AS NULL,
	City nvarchar(40) COLLATE Latin1_General_100_CI_AS NOT NULL,
	PostalCode varchar(5) COLLATE Latin1_General_100_CI_AS NULL,
	PhoneNumber1 varchar(20) COLLATE Latin1_General_100_CI_AS NULL,
	PhoneNumber2 varchar(20) COLLATE Latin1_General_100_CI_AS NULL,
	CONSTRAINT PK_Address PRIMARY KEY (AddressId)
);

-- Create table Restaurants
CREATE TABLE MsQaMig.dbo.Restaurants (
	RestaurantId int IDENTITY(1,1) NOT NULL,
	AddressId int NULL,
	Name nvarchar(100) COLLATE Latin1_General_100_CI_AS NOT NULL,
	Email nvarchar(256) COLLATE Latin1_General_100_CI_AS NOT NULL,
	PIB varchar(20) COLLATE Latin1_General_100_CI_AS NOT NULL,
	LogoImage nvarchar(2000) COLLATE Latin1_General_100_CI_AS NULL,
	Description nvarchar(300) COLLATE Latin1_General_100_CI_AS NULL,
	NotPartner bit NOT NULL,
	CONSTRAINT PK_Restaurant PRIMARY KEY (RestaurantId),
	CONSTRAINT FK_Restaurant_Address_2 FOREIGN KEY (AddressId) REFERENCES MsQaMig.dbo.Address(AddressId) ON DELETE CASCADE ON UPDATE CASCADE
);
 CREATE NONCLUSTERED INDEX FK_Address ON MsQaMig.dbo.Restaurants (  AddressId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;

-- Create table Profiles
CREATE TABLE MsQaMig.dbo.Profiles (
	ProfileId int NOT NULL,
	AddressId int NOT NULL,
	RestaurantId int NULL,
	Gender nvarchar(50) COLLATE Latin1_General_100_CI_AS NULL,
	FirstName nvarchar(50) COLLATE Latin1_General_100_CI_AS NOT NULL,
	LastName nvarchar(50) COLLATE Latin1_General_100_CI_AS NOT NULL,
	ProfileImage nvarchar(2000) COLLATE Latin1_General_100_CI_AS NULL,
	Description nvarchar(300) COLLATE Latin1_General_100_CI_AS NULL,
	CONSTRAINT PK_Profile PRIMARY KEY (ProfileId),
	CONSTRAINT FK_Address_1 FOREIGN KEY (AddressId) REFERENCES MsQaMig.dbo.Address(AddressId),
	CONSTRAINT FK_Restaurant_4 FOREIGN KEY (RestaurantId) REFERENCES MsQaMig.dbo.Restaurants(RestaurantId),
	CONSTRAINT FK_Users_10 FOREIGN KEY (ProfileId) REFERENCES MsQaMig.dbo.Users(UserId) ON DELETE CASCADE ON UPDATE CASCADE	
);
 CREATE NONCLUSTERED INDEX IX_Address ON MsQaMig.dbo.Profiles (  AddressId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX FK_Restaurant ON MsQaMig.dbo.Profiles (  RestaurantId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
	 

-- Create table Foods
CREATE TABLE MsQaMig.dbo.Foods (
	FoodId int IDENTITY(1,1) NOT NULL,
	RestaurantId int NOT NULL,
	OrderCounter int NOT NULL,
	DateCreated datetime NOT NULL,
	DeleteDate datetime NULL,
	IsAvailable bit DEFAULT 1 NOT NULL,
	Description nvarchar(2100) COLLATE Latin1_General_100_CI_AS NULL,
	Title nvarchar(50) COLLATE Latin1_General_100_CI_AS NOT NULL,
	PriceId int NULL,
	PhotoPath varchar(2000) COLLATE Latin1_General_100_CI_AS NOT NULL,
	CONSTRAINT PK_Food PRIMARY KEY (FoodId),
	CONSTRAINT FK_Property_Restaurant FOREIGN KEY (RestaurantId) REFERENCES MsQaMig.dbo.Restaurants(RestaurantId),
	CONSTRAINT FK_Property_Price FOREIGN KEY (PriceId) REFERENCES MsQaMig.dbo.Prices(PriceId)	
);

 CREATE NONCLUSTERED INDEX IX_Restaurant ON MsQaMig.dbo.Foods (  RestaurantId ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX IX_Property_OrderCounter ON MsQaMig.dbo.Foods (  OrderCounter ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;

-- Create table Metadata
CREATE TABLE MsQaMig.dbo.Metadata (
	MetadataId int IDENTITY(1,1) NOT NULL,
	FoodId int NOT NULL,
	MetadataName nvarchar(500) COLLATE Latin1_General_100_CI_AS NULL,
	Value nvarchar(500) COLLATE Latin1_General_100_CI_AS NULL,
	DateModified datetime NULL,
	CONSTRAINT PK_Metadata PRIMARY KEY (FoodId,MetadataId),
	CONSTRAINT FK_Metadata_Food_3 FOREIGN KEY (FoodId) REFERENCES MsQaMig.dbo.Foods(FoodId) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create table Photos
CREATE TABLE MsQaMig.dbo.Photos (
	PhotoId int IDENTITY(1,1) NOT NULL,
	FoodId int NOT NULL,
	Photo varchar(2000) COLLATE Latin1_General_100_CI_AS NOT NULL,
	Type int NOT NULL,
	CONSTRAINT PK_Photo PRIMARY KEY (PhotoId)
);


-- Populate table Roles
INSERT INTO MsQaMig.dbo.Roles
    (Name)
VALUES('User');

INSERT INTO MsQaMig.dbo.Roles
    (Name)
VALUES('PremiumUser');

INSERT INTO MsQaMig.dbo.Roles
    (Name)
VALUES('Seller');

INSERT INTO MsQaMig.dbo.Roles
    (Name)
VALUES('Admin');


-- Kupac insert query

INSERT INTO MsQaMig.dbo.Address
(Country, Street, HouseNumber, City, PostalCode, PhoneNumber1, PhoneNumber2)
VALUES('Srbija', 'Nikole Pašića', '23', 'Niš', '18000', '+38161111111', '+3816222222');
INSERT INTO MsQaMig.dbo.Users
(UserName, Email, EmailConfirmed, DateCreated, RoleId)
VALUES('Kupac', 'kupac@gmail.com', 1, '2022-01-15T00:00:00.000', 1);
INSERT INTO MsQaMig.dbo.Profiles
(ProfileId, AddressId, Gender, FirstName, LastName, ProfileImage, Description)
VALUES(1, 1, 'Male', 'Kupac', 'Kupic', 'https://sm.ign.com/t/ign_sr/news/m/mr-robot-e/mr-robot-ending-after-season-4_qt7j.1280.jpg', '');

-- Restoran insert query

INSERT INTO MsQaMig.dbo.Address
(Country, Street, HouseNumber, City, PostalCode, PhoneNumber1, PhoneNumber2)
VALUES('Srbija', 'Nikole Pašića', '24', 'Niš', '18000', '+38163333333', '+3816444444444');

INSERT INTO MsQaMig.dbo.Address
(Country, Street, HouseNumber, City, PostalCode, PhoneNumber1, PhoneNumber2)
VALUES('Srbija', 'Nikole Pašića', '25', 'Niš', '18000', '+38165555555', '+38166666666');

INSERT INTO MsQaMig.dbo.Users
(UserName, Email, EmailConfirmed, DateCreated, DateDisabled, RoleId)
VALUES('Restoran', 'restoran@gmail.com', 1, '2022-01-15T00:00:00.000', '', 3);

INSERT INTO MsQaMig.dbo.Restaurants
(AddressId, Name, Email, PIB, LogoImage, Description, NotPartner)
VALUES(3, 'Jakarta', 'jakarta@gmail.com', '666', 'https://indonesia.tripcanvas.co/wp-content/uploads/2016/09/3-1-outdoor-via-jojothen.jpg', 'Lorem ipsum jakarta', 1);

INSERT INTO MsQaMig.dbo.Profiles
(ProfileId, AddressId, RestaurantId, Gender, FirstName, LastName, ProfileImage, Description)
VALUES(2, 2, 1, 'Male', 'Restoran', 'Restoranic', 'https://indonesia.tripcanvas.co/wp-content/uploads/2016/09/3-1-outdoor-via-jojothen.jpg', 'Lorem ipsum');

-- Foods insert qeury
INSERT INTO MsQaMig.dbo.Prices
(Small, Medium, [Large], UniSize)
VALUES(100, 150, 200, null);

INSERT INTO MsQaMig.dbo.Foods
(RestaurantId, OrderCounter, DateCreated, DeleteDate, IsAvailable, Description, Title, PriceId, PhotoPath)
VALUES(1, 0, '2022-01-15T00:00:00.000', '', 1, 'Pita sa sirom i jajima', 'Pita sa sirom', 1, 'https://i.ytimg.com/vi/wvRXhxNDbBA/maxresdefault.jpg');

INSERT INTO MsQaMig.dbo.Metadata
(FoodId, MetadataName, Value, DateModified)
VALUES(1, 'Small', '100gr', '2022-01-15T00:00:00.000');

INSERT INTO MsQaMig.dbo.Metadata
(FoodId, MetadataName, Value, DateModified)
VALUES(1, 'Medium', '200gr', '2022-01-15T00:00:00.000');

INSERT INTO MsQaMig.dbo.Metadata
(FoodId, MetadataName, Value, DateModified)
VALUES(1, 'Large', '300gr', '2022-01-15T00:00:00.000');

-- Photos insert query
INSERT INTO MsQaMig.dbo.Photos
(FoodId, Photo, [Type])
VALUES (1, 'https://i.ytimg.com/vi/wvRXhxNDbBA/maxresdefault.jpg', 1);

INSERT INTO MsQaMig.dbo.Photos
(FoodId, Photo, [Type])
VALUES (1, 'https://i.ytimg.com/vi/eakTCIumbJM/maxresdefault.jpg', 2);

INSERT INTO MsQaMig.dbo.Photos
(FoodId, Photo, [Type])
VALUES (2, 'https://i.ytimg.com/vi/d2QUKZHrpVM/maxresdefault.jpg', 1);

INSERT INTO MsQaMig.dbo.Photos
(FoodId, Photo, [Type])
VALUES (2, 'https://i.ytimg.com/vi/GBtbllOx31Y/maxresdefault.jpg', 2);
