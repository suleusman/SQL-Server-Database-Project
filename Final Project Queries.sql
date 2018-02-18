/*****************************************************************************************************
								IT440/IT540 FINAL PROJECT SPRING 2017
									SUBMITTED BY:
								1) Sule Gimba USman
								2) Khalid Diriye Yusuf

******************************************************************************************************/

-- i.	Return all movies that have not sold any tickets.
SELECT m.MovieID, m.Title, a.AvailableSeats, SUM(od.No_Of_Tickets) AS Num_Ticket_Sold
FROM Movie m
JOIN Showing s ON m.MovieID = s.MovieID
JOIN Ticket t ON s.ShowingID = t.ShowingID
JOIN OrderDetail od ON od.TicketID = t.TicketID
JOIN Auditorium a ON s.AuditoriumID = a.AuditoriumID
WHERE od.No_Of_Tickets = 0
GROUP BY m.MovieID, m.Title, a.AvailableSeats, od.No_Of_Tickets;

----------------------------------------------OUTPUT-----------------------------------------------------------
/*	MovieID     Title                                                                                                                                                                                                                                                            AvailableSeats Num_Ticket_Sold
----------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- -------------- ---------------
1           Prison Break                                                                                                                                                                                                                                                     100            0
2           Bat Man                                                                                                                                                                                                                                                          120            0
1           Prison Break                                                                                                                                                                                                                                                     200            0

(3 row(s) affected)

*************************************************************************************************************/

--ii.	Return the total sales per movie per year.
SELECT m.MovieID, m.Title as MovieTitle, YEAR(o.OrderDate) as SalesYear, SUM(od.No_Of_Tickets) AS TotalSales
FROM [Order] o
JOIN OrderDetail od ON o.OrderID = od.OrderID
JOIN Ticket t ON od.TicketID = t.TicketID
JOIN Showing s ON t.ShowingID = s.ShowingID
JOIN Movie m ON s.MovieID = m.MovieID
GROUP BY m.MovieID, m.Title, YEAR(o.OrderDate)
ORDER BY m.MovieID, YEAR(o.OrderDate);

----------------------------------------------OUTPUT-----------------------------------------------------------
/*	MovieID     MovieTitle                                                                                                                                                                                                                                                       SalesYear   TotalSales
----------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------- -----------
1           Prison Break                                                                                                                                                                                                                                                     2013        5
1           Prison Break                                                                                                                                                                                                                                                     2014        305
1           Prison Break                                                                                                                                                                                                                                                     2015        0
2           Bat Man                                                                                                                                                                                                                                                          2013        120
2           Bat Man                                                                                                                                                                                                                                                          2014        5
2           Bat Man                                                                                                                                                                                                                                                          2015        5
3           Last Man Standing                                                                                                                                                                                                                                                2013        5
3           Last Man Standing                                                                                                                                                                                                                                                2014        5
3           Last Man Standing                                                                                                                                                                                                                                                2016        5
4           Black Maria                                                                                                                                                                                                                                                      2014        10
4           Black Maria                                                                                                                                                                                                                                                      2015        5
4           Black Maria                                                                                                                                                                                                                                                      2016        5
6           Cat and Lion Fight                                                                                                                                                                                                                                               2014        5
6           Cat and Lion Fight                                                                                                                                                                                                                                               2016        140
7           Watchman Dog Night                                                                                                                                                                                                                                               2017        5

(15 row(s) affected)                                                                                                                                                                                                        2017-01-28 00:00:00.000 5
*************************************************************************************************************/

--iii.	Return the number of available seats for each movie per showing date.

SELECT m.MovieID, s.ShowDate, a.AvailableSeats, s.ShowTime
FROM Auditorium a
JOIN Showing s
ON a.AuditoriumID = s.AuditoriumID
JOIN Movie m
ON s.MovieID = m.MovieID
GROUP BY m.MovieID, s.ShowDate, a.AvailableSeats, s.ShowTime;

----------------------------------------------OUTPUT-----------------------------------------------------------
/*	MovieID     ShowDate   AvailableSeats ShowTime
----------- ---------- -------------- --------------------
1           2010-02-11 80             08:15
1           2010-02-11 100            08:15
1           2010-02-11 200            10:30
2           2010-02-11 120            10:45
2           2010-02-11 125            09:30
2           2016-08-22 210            08:15
3           2014-12-13 170            14:25
3           2016-04-06 200            10:00
3           2016-07-11 170            09:05
4           2012-06-28 100            07:15
4           2012-06-28 170            14:20
4           2012-06-28 210            08:15
5           2014-10-01 80             08:15
5           2016-04-06 140            08:45
5           2016-07-11 120            12:30
6           2012-09-19 110            12:30
6           2012-09-19 140            08:35
7           2014-10-23 55             16:00
7           2014-12-13 110            20:35
8           2014-10-01 210            08:15

(20 row(s) affected)
*************************************************************************************************************/

--iv.	Return the number of tickets sold per year per category.

SELECT t.CategoryID, YEAR(o.OrderDate) AS OrdersPerYr, SUM(od.No_Of_Tickets) AS Num_tickets
FROM OrderDetail od
JOIN [Order] o ON od.OrderID = o.OrderID
JOIN Ticket t on od.TicketID = t.TicketID
GROUP BY t.CategoryID, YEAR(o.OrderDate);

----------------------------------------------OUTPUT-----------------------------------------------------------
/*	CategoryID  OrdersPerYr Num_tickets
----------- ----------- -----------
1           2013        5
2           2013        120
9           2013        5
1           2014        105
2           2014        200
3           2014        5
4           2014        10
5           2014        5
9           2014        5
2           2015        0
3           2015        10
4           2016        5
5           2016        140
9           2016        5
7           2017        5

(15 row(s) affected)
*************************************************************************************************************/

--v.	Return all the movies that have had sold out showings.

SELECT s.MovieID, od.OrderID, od.TicketID, SUM(od.No_Of_Tickets) AS Num_Showings, a.AvailableSeats
FROM OrderDetail od
JOIN Ticket t ON od.TicketID = t.TicketID
JOIN Showing s ON t.ShowingID = s.ShowingID
JOIN Auditorium a ON a.AuditoriumID = s.AuditoriumID
GROUP BY s.MovieID,od.OrderID, od.TicketID, a.AvailableSeats
HAVING a.AvailableSeats = SUM(od.No_Of_Tickets);

SELECT * 
FROM Auditorium

SELECT *
FROM OrderDetail

----------------------------------------------OUTPUT-----------------------------------------------------------
/*	MovieID     OrderID     TicketID    Num_Showings AvailableSeats
----------- ----------- ----------- ------------ --------------
1           1           1           100          100
1           2           3           200          200
2           11          4           120          120
6           20          9           140          140

(4 row(s) affected)
*************************************************************************************************************/




--vi.	Return per category the number of moviegoers. 

SELECT t.CategoryID, SUM(od.No_Of_Tickets) AS Number_Of_Moviegoers
FROM Customer c
JOIN [Order] o ON c.CustomerID = o.CustomerID
JOIN OrderDetail od ON o.OrderID = od.OrderID
JOIN Ticket t ON od.TicketID = t.TicketID
GROUP BY t.CategoryID;

----------------------------------------------OUTPUT-----------------------------------------------------------
/*	CategoryID  Number_Of_Moviegoers
----------- --------------------
1           110
2           320
3           15
4           15
5           145
7           5
9           15

(7 row(s) affected)
*************************************************************************************************************/


--vii.	What’s the average age of the moviegoers per movie.

SELECT s.MovieID, AVG(CONVERT(INT, DATEDIFF(d, c.DOB, GETDATE())/365.25)) AS Average_Age_Of_Moviegoers
FROM Customer c
JOIN [Order] o ON c.CustomerID = o.CustomerID
JOIN OrderDetail od ON o.OrderID = od.OrderID
JOIN Ticket t ON od.TicketID = t.TicketID
JOIN Showing s ON t.ShowingID = s.ShowingID
GROUP BY s.MovieID;

----------------------------------------------OUTPUT-----------------------------------------------------------
/*	MovieID     Average_Age_Of_Moviegoers
----------- -------------------------
1           31
2           23
3           28
4           22
6           31
7           31

(6 row(s) affected)
*************************************************************************************************************/
