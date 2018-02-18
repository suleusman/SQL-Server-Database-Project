/*****************************************************************************************************
								IT440/IT540 FINAL PROJECT SPRING 2017
									SUBMITTED BY:
								1) Sule Gimba USman
								2) Khalid Diriye Yusuf

******************************************************************************************************/
/*A.	Only ‘M’ or ‘F’ can be entered as a gender for a customer.*/
-----------------------------------------SOLUTIOn A----------------------------------------------------
GO
USE Cinema
GO
CREATE TRIGGER TR_FinalProjectSolution_A
ON Customer
AFTER INSERT  
AS
BEGIN
DECLARE @NoOfRowsAffected INT
SET @NoOfRowsAffected = @@ROWCOUNT
IF @NoOfRowsAffected = 0
	BEGIN
		RETURN
	END 
IF @NoOfRowsAffected > 1
	BEGIN
		RAISERROR('Sorry! Only one row can be updated at a time',3,2)
		ROLLBACK TRANSACTION
	END
	BEGIN
	DECLARE @Gender CHAR(20)
	SELECT @Gender = Gender FROM INSERTED
	IF (upper(LTRIM(RTRIM(@Gender))) = 'F' OR upper(LTRIM(RTRIM(@Gender))) = 'M')
		BEGIN
		PRINT 'Good Job. One Customer Added'
		END
	ELSE
	BEGIN
	RAISERROR('Sorry! Only F or M value is expected for Gender',3,2)
		ROLLBACK TRANSACTION
	END
	END
END

---We try the Insert Statemnet Below
Go
INSERT INTO Customer(FirstName,LastName,Gender,DOB,Email)  VALUES('Gana', 'Americana','A','2000-01-17',NULL)
----------------------------------------------OUTPUT-----------------------------------------------------------
/*	Sorry! Only F or M value is expected for Gender
	Msg 50000, Level 3, State 2
	Msg 3609, Level 16, State 1, Line 39
	The transaction ended in the trigger. The batch has been aborted.
*************************************************************************************************************/


/*B.	Every Order needs to have at least one OrderDetail record.*/
--------------------------------------------SOLUTION B---------------------------------------------------
GO
USE Cinema
GO
CREATE PROCEDURE PR_FinalProjectSolution_B	
---Variables Declaration
	@CustomerID INT,
	@OrderDate DATETIME,
	@TicketID INT,
	@No_Of_Tickets INT
AS
BEGIN
DECLARE @counter INT
SET @counter = @@TRANCOUNT
IF @counter > 0
BEGIN
	SAVE TRANSACTION foo
END
ELSE
BEGIN
	BEGIN TRANSACTION
END
BEGIN TRY
	BEGIN
	INSERT INTO [Order](CustomerID,OrderDate)
	VALUES(@CustomerID,@OrderDate)
	INSERT INTO OrderDetail(OrderID, TicketID, No_Of_Tickets)
	VALUES(@@IDENTITY,@TicketID,@No_Of_Tickets)
		
	IF @counter = 0
	COMMIT TRANSACTION
	END
END TRY
BEGIN CATCH
IF @counter >0
BEGIN
	RAISERROR('Rollback to save point foo', 15,1)
	ROLLBACK TRANSACTION foo
END
ELSE
BEGIN
	RAISERROR('Rollback entire transaction', 15,1)
	ROLLBACK TRANSACTION
END
END CATCH
END

 ---We execute and commit the transaction with input values to the declared variables
EXEC PR_FinalProjectSolution_B 2,'2016-11-22', 3, 300

/*C. Ticket: the combination of ShowingID and CategoryID needs to be unique.*/
--------------------------------------------SOLUTION C---------------------------------------------------
GO
USE Cinema
GO
ALTER TABLE Ticket ADD CONSTRAINT UC_Ticket UNIQUE(ShowingID,CategoryID) 

--We try the Update Statement below
Update Ticket SET ShowingID = 1 where TicketID = 2
----------------------------------------OUTPUT----------------------------------------------------------
/*	Msg 2627, Level 14, State 1, Line 63
	Violation of UNIQUE KEY constraint 'UC_Ticket'. Cannot insert duplicate key in object 'dbo.Ticket'. 
	The duplicate key value is (1, 1). The statement has been terminated.
*************************************************************************************************************/

/*D.	Only one movie can be displayed at a time in an auditorium.*/
--------------------------------------------SOLUTION D---------------------------------------------------
GO
USE Cinema
GO
ALTER TABLE Showing ADD CONSTRAINT UC_Showing UNIQUE(ShowDate,ShowTime,AuditoriumID) 

--We try to show a movie with date, time and auditorium that already exist in the Showing table
INSERT INTO Showing(ShowDate,ShowTime,MovieID,AuditoriumID) VALUES('2010-02-11','08:15',2,2)
----------------------------------------OUTPUT----------------------------------------------------------
/*	Msg 2627, Level 14, State 1, Line 78
Violation of UNIQUE KEY constraint 'UC_Showing'. Cannot insert duplicate key in object 'dbo.Showing'. 
The duplicate key value is (2010-02-11, 08:15, 2). The statement has been terminated.
********************************************************************************************************/

/*E. It is not allowed sell more tickets than there are seats available for a showing.  */
--------------------------------------------SOLUTION E---------------------------------------------------
GO
USE Cinema
GO
CREATE PROCEDURE PR_FinalProjectSolution_E	
---Variables Declaration
	@CustomerID INT,
	@OrderDate DATETIME,
	@TicketID INT,
	@No_Of_Tickets INT
AS
BEGIN
DECLARE @counter INT
SET @counter = @@TRANCOUNT
IF @counter > 0
BEGIN
	SAVE TRANSACTION foo
END
ELSE
BEGIN
	BEGIN TRANSACTION
END
BEGIN TRY
	BEGIN
	INSERT INTO [Order](CustomerID,OrderDate)
	VALUES(@CustomerID,@OrderDate)
	INSERT INTO OrderDetail(OrderID, TicketID, No_Of_Tickets)
	VALUES(@@IDENTITY,@TicketID,@No_Of_Tickets)

	DECLARE @TotalSeat INT,
			@TotalSold INT
	SELECT @TotalSeat = AvailableSeats FROM Auditorium WHERE AuditoriumID IN(SELECT AuditoriumID FROM Showing WHERE ShowingID IN
 (SELECT ShowingID FROM Ticket WHERE TicketID = @TicketID ) )
 SELECT TotalSold = SUM(No_Of_Tickets) FROM OrderDetail WHERE TicketID = @TicketID
 Group By TicketID
 IF (@TotalSeat - @TotalSold) >= 0
		BEGIN
			PRINT 'Your Ticket Order is Successful'
		END
		ELSE
		BEGIN
			RAISERROR('Sorry! The Ticket you want to buy is no longer available', 3,2)
			ROLLBACK TRANSACTION
		END
		
	IF @counter = 0
	COMMIT TRANSACTION
	END
END TRY
BEGIN CATCH
IF @counter >0
BEGIN
	RAISERROR('Rollback to save point foo', 15,1)
	ROLLBACK TRANSACTION foo
END
ELSE
BEGIN
	RAISERROR('Rollback entire transaction', 15,1)
	ROLLBACK TRANSACTION
END
END CATCH
END

 ---Execute and commit the transaction with input values to the declared variables
EXEC PR_FinalProjectSolution_E 2, '2016-11-22', 3, 300
	


/*F. If a customer has ordered a ticket it is not allowed to change any information for that showing. */
--------------------------------------------SOLUTION F---------------------------------------------------
GO
USE Cinema
GO
CREATE TRIGGER TR_FinalProjectSolution_F
ON Showing
INSTEAD OF UPDATE
AS
BEGIN
DECLARE @NoOfRowsAffected INT
SET @NoOfRowsAffected = @@ROWCOUNT
IF @NoOfRowsAffected = 0
	BEGIN
		RETURN
	END ELSE
IF @NoOfRowsAffected > 1
	BEGIN
		RAISERROR('Sorry! Only one row can be updated at a time',3,2)
		ROLLBACK TRANSACTION
	END
ELSE
	BEGIN
	DECLARE @ShowingID INT
	SELECT @ShowingID = ShowingID FROM INSERTED
	IF EXISTS(SELECT OrderID from OrderDetail where TicketID IN(SELECT TicketID from Ticket WHERE ShowingID = @ShowingID) )
		BEGIN
		RAISERROR('Sorry! you can not edit a show you have already ordered for', 3,2)
		END
	END
END

--We test the Trigger with the Update statement below
UPDATE Showing SET MovieID = 6 WHERE ShowingID = 2
--------------------------------------------OUTPUT----------------------------------------------------------------
/*		Sorry! you can not edit a show you have already ordered for
		Msg 50000, Level 3, State 2

		(1 row(s) affected)
------------------------------------------------------------------------------------------------------------------*/


/*G. A movie needs to be released before it can be shown to the customers. */
--------------------------------------------SOLUTION G---------------------------------------------------

GO
USE Cinema
GO
CREATE PROCEDURE PR_FinalProjectSolution_G
@ShowingID INT,
@ShowingDate DATETIME,
@ShowingTime DATETIME,
@MovieID INT,
@AuditoriumID INT
AS
BEGIN
DECLARE @count INT
SET @count = @@TRANCOUNT 
IF @count > 0
	BEGIN
		SAVE TRANSACTION foo
	END
ELSE
	BEGIN
		BEGIN TRAN
	END
	BEGIN TRY
	--All codes goes herer
	
	DECLARE @MovieReleaseDate DATETIME		
	SELECT @MovieReleaseDate = ReleaseDate FROM Movie WHERE MovieID = @MovieID 
	IF(@MovieReleaseDate > @ShowingDate)
		BEGIN
			RAISERROR('Sorry! The Movie you want to Show to the Customers has not been released',1,2)
			ROLLBACK TRANSACTION
		END
		ELSE
		BEGIN
			INSERT INTO Showing(ShowingID,ShowDate,ShowTime,MovieID,AuditoriumID) 
			VALUES(@ShowingID,@ShowingDate,@ShowingTime,@MovieID,@AuditoriumID)
		IF @count = 0
		COMMIT TRAN
		END
	END TRY
	BEGIN CATCH
		IF @count > 0
		BEGIN
			RAISERROR('Rollback the save transaction foo',1,2)
			ROLLBACK TRANSACTION foo
		END
		ELSE
		BEGIN
			RAISERROR('Rollback the entire transaction',1,2)
			ROLLBACK TRAN
		END
	END CATCH
END

-----We Test our Procedure with the below input

EXECUTE PR_FinalProjectSolution_G  1,'2000-11-01','08:30',3,5

------------------------------------OUTPUT---------------------------------------------------------------
/*		
		Sorry! The Movie you want to Show to the Customers has not been released
		Msg 50000, Level 1, State 2
---------------------------------------------------------------------------------------------------------*/

/*H. A Customer needs to be older than 13 to order a ticket.*/
--------------------------------------------SOLUTION H---------------------------------------------------
GO
USE Cinema
GO
CREATE PROCEDURE PR_FinalProjectSolution_H
--@OrderID INT,
@CustomerID INT,
@OrderDate DATETIME,
@TicketID INT,
@No_Of_Tickets INT
AS
BEGIN
DECLARE @count INT
SET @count = @@TRANCOUNT 
IF @count > 0
	BEGIN
		SAVE TRANSACTION foo
	END
ELSE
	BEGIN
		BEGIN TRAN
	END
	BEGIN TRY
	--All codes goes herer
	
	DECLARE @CustomerDOB DATETIME,
			@CustomerAge INT		
	SELECT @CustomerDOB = DOB FROM Customer WHERE CustomerID = @CustomerID
	SET @CustomerAge =  YEAR(GETDATE())-YEAR(@CustomerDOB)
	IF(@CustomerAge <= 13)
		BEGIN
			RAISERROR('Sorry! You are too young to order for a Ticket',1,2)
		END
		ELSE
		BEGIN
			INSERT INTO [Order](CustomerID,OrderDate) 
			VALUES(@CustomerID,@OrderDate)
			INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets)
			VALUES(@@IDENTITY,@TicketID,@No_Of_Tickets)
		IF @count = 0
		COMMIT TRAN
		END
	END TRY
	BEGIN CATCH
		IF @count > 0
		BEGIN
			RAISERROR('Rollback the save transaction foo',1,2)
			ROLLBACK TRANSACTION foo
		END
		ELSE
		BEGIN
			RAISERROR('Rollback the entire transaction',1,2)
			ROLLBACK TRAN
		END
	END CATCH
END 
GO
---We try to execute the Procedure with the Insert statement below
BEGIN TRANSACTION
EXECUTE PR_FinalProjectSolution_H 10,'2017-02-11',4,2
COMMIT TRANSACTION
---------------------------------OUTPUT---------------------------------------------------------
/*	Sorry! You are too young to order for a Ticket
    Msg 50000, Level 1, State 2
-----------------------------------------------------------------------------------------------*/

/*I.	A Customer that is younger than 17 is not allowed to purchase a ticket for an R-rated movie.*/
--------------------------------------------SOLUTION I---------------------------------------------------
GO
USE Cinema
GO
CREATE PROCEDURE PR_FinalProjectSolution_I
--@OrderID INT,
@CustomerID INT,
@OrderDate DATETIME,
@TicketID INT,
@No_Of_Tickets INT
AS
BEGIN
DECLARE @count INT
SET @count = @@TRANCOUNT 
IF @count > 0
	BEGIN
		SAVE TRANSACTION foo
	END
ELSE
	BEGIN
		BEGIN TRAN
	END
	BEGIN TRY
	BEGIN
	DECLARE @RatingName VARCHAR(100),
		@CustomerDOB DATETIME,
		@CustomerAge INT

	SELECT @RatingName = RatingName FROM Rating WHERE RatingID IN(SELECT RatingID FROM Movie WHERE MovieID IN
	(SELECT MovieID FROM Showing WHERE ShowingID IN(SELECT ShowingID FROM Ticket WHERE TicketID = @TicketID ) ))	

	SELECT @CustomerDOB = DOB FROM Customer WHERE CustomerID = @CustomerID
	SET @CustomerAge =  YEAR(GETDATE())-YEAR(@CustomerDOB)
	IF(@RatingName = 'Restricted' AND @CustomerAge < 17)
		BEGIN
			RAISERROR('Sorry! you are under 17 and not allowed to purchase a ticket for an R-rated movie', 3,2)
		END
		ELSE
		BEGIN
			INSERT INTO [Order](CustomerID,OrderDate) 
			VALUES(@CustomerID,@OrderDate)
			INSERT INTO OrderDetail(OrderID,TicketID,No_Of_Tickets)
			VALUES(@@IDENTITY,@TicketID,@No_Of_Tickets)
		IF @count = 0
		COMMIT TRAN
		END
	END
	END TRY
	BEGIN CATCH
		IF @count > 0
		BEGIN
			RAISERROR('Rollback the save transaction foo',1,2)
			ROLLBACK TRANSACTION foo
		END
		ELSE
		BEGIN
			RAISERROR('Rollback the entire transaction',1,2)
			ROLLBACK TRAN
		END
	END CATCH
END 
--We try the input as below
GO
BEGIN TRANSACTION
EXECUTE PR_FinalProjectSolution_I 10,'2017-02-11',2,2
COMMIT TRANSACTION
------------------------------------OUTPUT--------------------------------------------------------------
/*    Sorry! you are under 17 and not allowed to purchase a ticket for an R-rated movie
      Msg 50000, Level 3, State 2
--------------------------------------------------------------------------------------------------------*/

/*J. A movie is required to have at least one genre.  */
---------------------------------SOLUTION J--------------------------------------------------------------
GO
USE Cinema
GO
CREATE PROCEDURE PR_FinalProjectSolution_J	
---Variables Declaration
	@Title VARCHAR(300),
	@ReleaseDate DATETIME,
	@Runtime VARCHAR(50),
	@RatingID CHAR(5),
	@GenreID INT
AS
BEGIN
DECLARE @counter INT
SET @counter = @@TRANCOUNT
IF @counter > 0
BEGIN
	SAVE TRANSACTION foo
END
ELSE
BEGIN
	BEGIN TRANSACTION
END
BEGIN TRY
	BEGIN
	INSERT INTO Movie(Title,ReleaseDate,Runtime,RatingID)
	VALUES(@Title,@ReleaseDate,@Runtime,@RatingID)
	INSERT INTO MovieGenre(MovieID, GenreID)
	VALUES(@@IDENTITY,@GenreID)
		
	IF @counter = 0
	COMMIT TRANSACTION
	END
END TRY
BEGIN CATCH
IF @counter >0
BEGIN
	RAISERROR('Rollback to save point foo', 15,1)
	ROLLBACK TRANSACTION foo
END
ELSE
BEGIN
	RAISERROR('Rollback entire transaction', 15,1)
	ROLLBACK TRANSACTION
END
END CATCH
END

 ---We execute and commit the transaction with input values to the declared variables
EXEC PR_FinalProjectSolution_J 'Good Olden Days', '2016-11-22','2:30', G,1


