/*****************************************************************************************************
								IT440/IT540 FINAL PROJECT SPRING 2017
									SUBMITTED BY:
								1) Sule Gimba USman
								2) Khalid Diriye Yusuf

******************************************************************************************************/

--Database Creation
GO
CREATE DATABASE Cinema

GO
USE Cinema
GO
--Create Rating Table
CREATE TABLE Rating(
RatingID CHAR(5) NOT NULL,
RatingName VARCHAR(100) NOT NULL,
RatingDescription VARCHAR(1000) NULL,
CONSTRAINT PK_Rating PRIMARY KEY (RatingID)
)-- end of Rating table creation
GO
--Create Movie table
CREATE TABLE Movie(
MovieID INT IDENTITY (1,1) NOT NULL,
Title VARCHAR(300) NOT NULL,
ReleaseDate DATETIME NOT NULL,
Runtime VARCHAR(20) NOT NULL,
RatingID CHAR(5)  NOT NULL,

CONSTRAINT PK_Movie PRIMARY KEY CLUSTERED (MovieID),

CONSTRAINT FK_Movie_Rating FOREIGN KEY(RatingID) REFERENCES dbo.Rating(RatingID)
)--end of Movie table creation
GO
--Create Genre Table
CREATE TABLE Genre(
GenreID INT IDENTITY (1,1) NOT NULL,
GenreName VARCHAR(100) NULL,
CONSTRAINT PK_Genre PRIMARY KEY CLUSTERED (GenreID), 
)--end of Genre table creation
GO 
--Create MovieGenre table
CREATE TABLE MovieGenre(
MovieGenreID INT IDENTITY (1,1) NOT NULL,
MovieID INT NOT NULL,
GenreID INT NOT NULL,
CONSTRAINT PK_MovieGenreID PRIMARY KEY CLUSTERED (MovieGenreID),

CONSTRAINT FK_MovieGenre_Movie FOREIGN KEY(MovieID)REFERENCES dbo.Movie(MovieID),

CONSTRAINT FK_MovieGenre_Genre FOREIGN KEY (GenreID) REFERENCES dbo.Genre(GenreID)
)--end of table MoveiGenre creation

GO
--Create Auditorium table
CREATE TABLE Auditorium(
AuditoriumID INT IDENTITY(1,1) NOT NULL,
AuditoriumName VARCHAR(150) NOT NULL,
AvailableSeats INT NOT NULL,

CONSTRAINT PK_Auditorium PRIMARY KEY CLUSTERED (AuditoriumID)
)--end of Auditorium table creation

GO
--Create Showing table
CREATE TABLE Showing(
ShowingID INT IDENTITY(1,1) NOT NULL,
ShowDate DATE NOT NULL,
ShowTime VARCHAR(20) NOT NULL,
MovieID INT NOT NULL,
AuditoriumID INT NOT NULL,

CONSTRAINT PK_Showing PRIMARY KEY (ShowingID),

CONSTRAINT FK_Showing_Movie FOREIGN KEY (MovieID) REFERENCES dbo.Movie(MovieID),

CONSTRAINT FK_Showing_Auditorium FOREIGN KEY (AuditoriumID) REFERENCES dbo.Auditorium (AuditoriumID)
)--end of Showing table creation

GO
--create Customer table
CREATE TABLE Customer(
CustomerID INT IDENTITY(1,1) NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Gender CHAR(5) NULL,
DOB DATETIME NULL,
Email VARCHAR(100) NULL,

CONSTRAINT PK_Customer PRIMARY KEY CLUSTERED (CustomerID)
)--end of Customer table creation

GO
--create Order table
CREATE TABLE [Order](
OrderID INT IDENTITY (1,1) NOT NULL,
CustomerID INT NOT NULL,
OrderDate DATETIME NOT NULL,

CONSTRAINT PK_Order PRIMARY KEY CLUSTERED (OrderID),

CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerID) REFERENCES dbo.Customer(CustomerID)
)--end of Order table creation

GO
--Create Category table
CREATE TABLE Category(
CategoryID INT IDENTITY(1,1) NOT NULL,
Name VARCHAR(100) NOT NULL,
Cat_Description VARCHAR(1000) NULL,

CONSTRAINT PK_Category PRIMARY KEY CLUSTERED (CategoryID) 
)--end of category table creation

GO
--Create Ticket Table
CREATE TABLE Ticket(
TicketID INT IDENTITY(1,1) NOT NULL,
ShowingID INT NOT NULL,
CategoryID INT NOT NULL,
Price DECIMAL(10,2),

CONSTRAINT PK_Ticket PRIMARY KEY CLUSTERED (TicketID),

CONSTRAINT FK_Ticket_Showing FOREIGN KEY (ShowingID) REFERENCES dbo.Showing(ShowingID),

CONSTRAINT FK_Ticket_Category FOREIGN KEY (CategoryID) REFERENCES dbo.Category(CategoryID),

CONSTRAINT CK_Price CHECK (Price >= 0)
)--end of Ticket table creation

GO
--Create OrderDetail table
CREATE TABLE OrderDetail(
OrderID INT NOT NULL,
TicketID INT NOT NULL,
No_Of_Tickets INT NOT NULL,

CONSTRAINT PK_OrderDetail PRIMARY KEY CLUSTERED (OrderID, TicketID),

CONSTRAINT FK_OrderDetail_Order FOREIGN KEY (OrderID) REFERENCES dbo.[Order](OrderID),

CONSTRAINT FK_OrderDetail_Ticket FOREIGN KEY (TicketID) REFERENCES dbo.Ticket(TicketID)
)--end of orderDetail table creation
--------------------------------------------END OF TABLE CREATION-------------------------------------------------------------
/************************************************************************************************************************/
--we begin Insert into Movie table
--We set Identity_Insert on so that we can insert our own value into the Identity column
USE Cinema
GO 
SET IDENTITY_INSERT Movie ON
--we implement NOCHECK constraint to remove the foreign key constraint on the Movie table
ALTER TABLE Movie NOCHECK CONSTRAINT ALL
GO
INSERT INTO Movie(MovieID, Title,ReleaseDate,Runtime,RatingID) VALUES(1,'Prison Break','2015-05-22','1h 52min','R')
INSERT INTO Movie(MovieID, Title,ReleaseDate,Runtime,RatingID) VALUES(2,'Bat Man','2010-01-13','2h 5min','PG')
INSERT INTO Movie(MovieID, Title,ReleaseDate,Runtime,RatingID) VALUES(3,'Last Man Standing','2009-04-02','1h 10min','G')
INSERT INTO Movie(MovieID, Title,ReleaseDate,Runtime,RatingID) VALUES(4,'Black Maria','2011-06-12','2h 52min','PG13')
INSERT INTO Movie(MovieID, Title,ReleaseDate,Runtime,RatingID) VALUES(5,'Iron Man','2011-05-26','1h 25min','PG')
INSERT INTO Movie(MovieID, Title,ReleaseDate,Runtime,RatingID) VALUES(6,'Cat and Lion Fight','2014-11-02','1h 11min','R')
INSERT INTO Movie(MovieID, Title,ReleaseDate,Runtime,RatingID) VALUES(7,'Watchman Dog Night','2014-01-20','1h 30min','PG13')
INSERT INTO Movie(MovieID, Title,ReleaseDate,Runtime,RatingID) VALUES(8,'Fast and Furious','2015-11-18','2h 30min','PG13')
INSERT INTO Movie(MovieID, Title,ReleaseDate,Runtime,RatingID) VALUES(9,'Dangerous King','2013-03-21','1h 40min','PG')
INSERT INTO Movie(MovieID, Title,ReleaseDate,Runtime,RatingID) VALUES(10,'Shortman Devil','2016-07-17','1h 52min','NC-17')
--We now set the CHECK constraint again on the Movie table to activate all constraints
ALTER TABLE Movie CHECK CONSTRAINT ALL
SET IDENTITY_INSERT Movie OFF
/************************************************************************************************************************/
GO
--We begin Insert into Rating table
--We deactivate all constraint before inserting into the Rating table
ALTER TABLE Rating NOCHECK CONSTRAINT ALL
INSERT INTO Rating(RatingID,RatingName,RatingDescription) VALUES('G','General Audiences','All ages admitted. Nothing that would offend parents for viewing by children.')
INSERT INTO Rating(RatingID,RatingName,RatingDescription) VALUES('NC-17','Adults Only','No One 17 and Under Admitted. Clearly adult. Children are not admitted.')
INSERT INTO Rating(RatingID,RatingName,RatingDescription) VALUES('PG','Parental Guidance Suggested','Some material may not be suitable for children. Parents urged to give "parental guidance". May contain some material parents might not like for their young children.')
INSERT INTO Rating(RatingID,RatingName,RatingDescription) VALUES('PG-13','Parents Strongly Cautioned','Some material may be inappropriate for children under 13. Parents are urged to be cautious. Some material may be inappropriate for pre-teenagers.')
INSERT INTO Rating(RatingID,RatingName,RatingDescription) VALUES('R','Restricted','Under 17 requires accompanying parent or adult guardian. Contains some adult material. Parents are urged to learn more about the film before taking their young children with them.')
--We now set the CHECK constraint again on the Rating table to activate all constraints
ALTER TABLE Rating CHECK CONSTRAINT ALL
/************************************************************************************************************************/
GO
--We begin insert into the Genre Table
-- We deactivate all check constraint to allow easy insert into the Genre Table
ALTER TABLE Genre NOCHECK CONSTRAINT ALL
--We set Identity insert on 
SET IDENTITY_INSERT Genre ON
INSERT INTO Genre(GenreID, GenreName) VALUES(1,'Action')
INSERT INTO Genre(GenreID, GenreName) VALUES(2,'Old school')
INSERT INTO Genre(GenreID, GenreName) VALUES(3,'Comedy')
INSERT INTO Genre(GenreID, GenreName) VALUES(4,'Seasonal')
INSERT INTO Genre(GenreID, GenreName) VALUES(5,'Cartoon')
INSERT INTO Genre(GenreID, GenreName) VALUES(6,'Horror')
INSERT INTO Genre(GenreID, GenreName) VALUES(7,'Concert')
INSERT INTO Genre(GenreID, GenreName) VALUES(8,'War')
INSERT INTO Genre(GenreID, GenreName) VALUES(9,'Documentary')
INSERT INTO Genre(GenreID, GenreName) VALUES(10,'Classic')
ALTER TABLE Genre CHECK CONSTRAINT ALL
SET IDENTITY_INSERT Genre OFF
/************************************************************************************************************************/
GO
--We begin insert into the Movie Genre table
SET IDENTITY_INSERT MovieGenre ON
ALTER TABLE MovieGenre NOCHECK CONSTRAINT ALL

INSERT INTO MovieGenre(MovieGenreID, MovieID, GenreID) VALUES(1, 3, 2)
INSERT INTO MovieGenre(MovieGenreID, MovieID, GenreID) VALUES(2, 1, 4)
INSERT INTO MovieGenre(MovieGenreID, MovieID, GenreID) VALUES(3, 4, 7)
INSERT INTO MovieGenre(MovieGenreID, MovieID, GenreID) VALUES(4, 3, 1)
INSERT INTO MovieGenre(MovieGenreID, MovieID, GenreID) VALUES(5, 6, 5)
INSERT INTO MovieGenre(MovieGenreID, MovieID, GenreID) VALUES(6, 9, 3)
INSERT INTO MovieGenre(MovieGenreID, MovieID, GenreID) VALUES(7, 5, 8)
INSERT INTO MovieGenre(MovieGenreID, MovieID, GenreID) VALUES(8, 5, 2)
INSERT INTO MovieGenre(MovieGenreID, MovieID, GenreID) VALUES(9, 10, 5)
INSERT INTO MovieGenre(MovieGenreID, MovieID, GenreID) VALUES(10, 9, 8)

ALTER TABLE MovieGenre CHECK CONSTRAINT ALL
SET IDENTITY_INSERT MovieGenre OFF
/************************************************************************************************************************/
GO
--We begin insert into Auditorium Table
SET IDENTITY_INSERT Auditorium ON
ALTER TABLE Auditorium NOCHECK CONSTRAINT ALL

INSERT INTO Auditorium(AuditoriumID,AuditoriumName,AvailableSeats) VALUES(1, 'Amstrong 234',120)
INSERT INTO Auditorium(AuditoriumID,AuditoriumName,AvailableSeats) VALUES(2, 'Morison 101',100)
INSERT INTO Auditorium(AuditoriumID,AuditoriumName,AvailableSeats) VALUES(3, 'Winsink 211',200)
INSERT INTO Auditorium(AuditoriumID,AuditoriumName,AvailableSeats) VALUES(4, 'Carkoski 001',80)
INSERT INTO Auditorium(AuditoriumID,AuditoriumName,AvailableSeats) VALUES(5, 'CSU Ballroom',110)
INSERT INTO Auditorium(AuditoriumID,AuditoriumName,AvailableSeats) VALUES(6, 'Art and Gallery',170)
INSERT INTO Auditorium(AuditoriumID,AuditoriumName,AvailableSeats) VALUES(7, 'CSU 254',55)
INSERT INTO Auditorium(AuditoriumID,AuditoriumName,AvailableSeats) VALUES(8, 'Wickie Center 205',140)
INSERT INTO Auditorium(AuditoriumID,AuditoriumName,AvailableSeats) VALUES(9, 'Tailor Centre 80',210)
INSERT INTO Auditorium(AuditoriumID,AuditoriumName,AvailableSeats) VALUES(10, 'Mayers Field',125)

SET IDENTITY_INSERT Auditorium OFF
ALTER TABLE Auditorium CHECK CONSTRAINT ALL
/************************************************************************************************************************/
GO
--We begin insert into table
SET IDENTITY_INSERT Customer ON 
ALTER TABLE Customer NOCHECK CONSTRAINT ALL

INSERT INTO Customer(CustomerID,FirstName,LastName,Gender,DOB,Email) VALUES(1,'Sule','Gimba','M','1984-07-17','sule.gimba@mnsu.edu')
INSERT INTO Customer(CustomerID,FirstName,LastName,Gender,DOB,Email) VALUES(2,'Khalid','Diriye','M','1982-01-12','khalid.diriye@mnsu.edu')
INSERT INTO Customer(CustomerID,FirstName,LastName,Gender,DOB,Email) VALUES(3,'Ambore','Isaac','M','1983-10-01','ambore.isaac@mnsu.edu')
INSERT INTO Customer(CustomerID,FirstName,LastName,Gender,DOB,Email) VALUES(4,'Halima','Abdulganiyu','F','1994-03-17','halima.abdul@mnsu.edu')
INSERT INTO Customer(CustomerID,FirstName,LastName,Gender,DOB,Email) VALUES(5,'Alissa','Lilhaugen','F','1996-11-07','alissa.lilhaugen@mnsu.edu')
INSERT INTO Customer(CustomerID,FirstName,LastName,Gender,DOB,Email) VALUES(6,'Tope','Olawole','F','1999-12-23','tope.olawole@mnsu.edu')
INSERT INTO Customer(CustomerID,FirstName,LastName,Gender,DOB,Email) VALUES(7,'Erik','Jacobson','M','1992-05-28','erik.jacobson@mnsu.edu')
INSERT INTO Customer(CustomerID,FirstName,LastName,Gender,DOB,Email) VALUES(8,'Fatima','Jackson','F','1986-04-01','fatima.jackson@mnsu.edu')
INSERT INTO Customer(CustomerID,FirstName,LastName,Gender,DOB,Email) VALUES(9,'Dalton','Caltron','M','1987-09-12','dalton.caltron@mnsu.edu')
INSERT INTO Customer(CustomerID,FirstName,LastName,Gender,DOB,Email) VALUES(10,'Alan','Smith','M','1984-03-23','alan.smith@mnsu.edu')

ALTER TABLE Customer CHECK CONSTRAINT ALL
SET IDENTITY_INSERT Customer OFF
/************************************************************************************************************************/
GO
--We begin insert into Category table
SET IDENTITY_INSERT Category ON
ALTER TABLE Category NOCHECK CONSTRAINT ALL

INSERT INTO Category(CategoryID, Name, Cat_Description) VALUES(1,'Normal','Approved for both adult and children')
INSERT INTO Category(CategoryID, Name, Cat_Description) VALUES(2,'Kids Under 12','For children under the age of 12 years')
INSERT INTO Category(CategoryID, Name, Cat_Description) VALUES(3,'Students','Good for student development')
INSERT INTO Category(CategoryID, Name, Cat_Description) VALUES(4,'Age 65 Above','Approved only for old people above 65 years of age')
INSERT INTO Category(CategoryID, Name, Cat_Description) VALUES(5,'Veterans','Suitable for only Veterans')
INSERT INTO Category(CategoryID, Name, Cat_Description) VALUES(6,'Women','Only for women')
INSERT INTO Category(CategoryID, Name, Cat_Description) VALUES(7,'Atletic','For Atletic development')
INSERT INTO Category(CategoryID, Name, Cat_Description) VALUES(8,'Corps','Approved only for US Corp workers')
INSERT INTO Category(CategoryID, Name, Cat_Description) VALUES(9,'Hispanic','Hispanic culture')
INSERT INTO Category(CategoryID, Name, Cat_Description) VALUES(10,'Black','Black history and culture')

SET IDENTITY_INSERT Category OFF
ALTER TABLE Category CHECK CONSTRAINT ALL
/************************************************************************************************************************/
GO
--We begin insert into Showing table
SET IDENTITY_INSERT Showing ON
ALTER TABLE Showing NOCHECK CONSTRAINT ALL

INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(1,'2010-02-11','08:15',1,2)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(2,'2010-02-11','08:15',1,4)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(3,'2010-02-11','10:30',1,3)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(4,'2010-02-11','10:45',2,1)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(5,'2010-02-11','09:30',2,10)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(6,'2012-06-28','14:20',4,6)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(7,'2012-06-28','07:15',4,2)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(8,'2012-06-28','08:15',4,9)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(9,'2012-09-19','08:35',6,8)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(10,'2012-09-19','12:30',6,5)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(11,'2014-10-01','08:15',8,9)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(12,'2014-10-01','08:15',5,4)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(13,'2014-10-23','16:00',7,7)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(14,'2014-12-13','20:35',7,5)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(15,'2014-12-13','14:25',3,6)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(16,'2016-04-06','08:45',5,8)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(17,'2016-04-06','10:00',3,3)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(18,'2016-07-11','09:05',3,6)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(19,'2016-07-11','12:30',5,1)
INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) VALUES(20,'2016-08-22','08:15',2,9)

ALTER TABLE Showing CHECK CONSTRAINT ALL
SET IDENTITY_INSERT Showing OFF
/************************************************************************************************************************/
GO

--We begin Insert into Ticket table
SET IDENTITY_INSERT Ticket ON
ALTER TABLE Ticket NOCHECK CONSTRAINT ALL

INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(1,1,1,12.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(2,2,1,12.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(3,3,2,5.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(4,4,2,5.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(5,5,3,8.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(6,6,3,8.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(7,7,4,6.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(8,8,4,6.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(9,9,5,10.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(10,10,5,10.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(11,11,6,9.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(12,12,6,9.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(13,13,7,15.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(14,14,7,15.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(15,15,8,7.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(16,16,8,7.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(17,17,9,4.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(18,18,9,4.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(19,19,10,11.00)
INSERT INTO Ticket(TicketID,ShowingID,CategoryID,Price) VALUES(20,20,10,11.00)

SET IDENTITY_INSERT Ticket OFF
ALTER TABLE Ticket CHECK CONSTRAINT ALL
/************************************************************************************************************************/
GO
--We begin Insert into Order table
SET IDENTITY_INSERT [Order] ON
ALTER TABLE [Order] NOCHECK CONSTRAINT ALL

INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(1,1,'2014-07-22')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(2,1,'2014-10-08')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(3,2,'2014-07-22')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(4,2,'2014-10-11')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(5,3,'2015-03-14')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(6,3,'2015-07-25')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(7,4,'2015-07-22')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(8,4,'2015-09-13')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(9,5,'2014-04-10')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(10,5,'2014-09-21')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(11,6,'2013-02-03')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(12,6,'2014-07-27')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(13,7,'2013-04-06')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(14,7,'2013-11-21')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(15,8,'2016-06-20')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(16,8,'2017-01-28')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(17,9,'2014-03-20')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(18,9,'2014-12-03')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(19,10,'2016-04-29')
INSERT INTO [Order](OrderID,CustomerID,OrderDate) VALUES(20,10,'2016-07-03')

SET IDENTITY_INSERT [Order] OFF
ALTER TABLE [Order] CHECK CONSTRAINT ALL
/************************************************************************************************************************/
GO
--We begin Insert into the OrderDetail table
ALTER TABLE OrderDetail NOCHECK CONSTRAINT  ALL

INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(1,1,100)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(2,3,200)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(3,2,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(4,1,0)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(5,3,0)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(6,4,0)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(7,5,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(8,6,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(9,5,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(10,7,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(11,4,120)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(12,8,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(13,1,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(14,18,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(15,7,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(16,14,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(17,10,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(18,17,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(19,18,5)
INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets) VALUES(20,9,140)

ALTER TABLE OrderDetail CHECK CONSTRAINT ALL

/************************************************************************************************************************/
