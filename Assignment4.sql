--Sherwin Rahimi 2/5/2022--
USE Northwind
GO
--Q1 Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.--
CREATE VIEW [view_product_order_rahimi] AS
(SELECT p.ProductName, SUM(od.Quantity) Quantity
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductName)
GO

--Q2 Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter. --
CREATE OR ALTER PROC [sp_product_order_quantity_rahimi](@ProductID INT) AS
BEGIN
	SELECT SUM(od.Quantity) Quantity
	FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
	WHERE p.ProductID = @ProductID
END
GO

--Q3 Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an 
--input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.--
CREATE OR ALTER PROC [sp_product_order_city_rahimi](@productName nvarchar(40)) AS
BEGIN
	SELECT TOP 5 o.ShipCity
	FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID JOIN Orders o ON o.OrderID = od.OrderID
	WHERE p.ProductName = @productName
	GROUP BY o.ShipCity
	ORDER BY SUM(od.Quantity) DESC
END
GO

EXEC [sp_product_order_city_rahimi] @productName = 'Alice Mutton'

--Q4 Create 2 new tables “people_rahimi” “city_rahimi”. 
--City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. 
--People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
--Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. 
--Create a view “Packers_your_name” lists all people from Green Bay. 
--If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.--
CREATE TABLE [city_rahimi](
id int PRIMARY KEY IDENTITY(1,1),
City varchar(40) not null);
GO

CREATE TABLE [people_rahimi](
id int PRIMARY KEY IDENTITY(1,1),
[Name] varchar(40) not null,
City int FOREIGN KEY REFERENCES city_rahimi(id));
GO

INSERT INTO [city_rahimi](City)
VALUES('Seattle'),
	('Green Bay');
GO

INSERT INTO [people_rahimi]([Name],City)
VALUES('Aaron Rodgers',2),
	('Russell Wilson', 1),
	('Jody Nelson', 2);
GO

UPDATE city_rahimi
SET City = 'Madison'
WHERE City = 'Seattle'

GO
CREATE VIEW [Packers_Sherwin_Rahimi] AS(
SELECT [name]
FROM people_rahimi p join city_rahimi c on p.City = c.id
WHERE c.City = 'Green Bay'
)
GO

drop table people_rahimi
drop table city_rahimi
drop view packers_sherwin_rahimi

--Q5 Create a stored procedure “sp_birthday_employees_[you_last_name]” 
--that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.--
GO
CREATE PROC sp_birthday_employees_rahimi AS
BEGIN
	SELECT e.FirstName + ' ' + e.LastName EmployeeName, e.BirthDate 
	INTO birthday_employee_rahimi
	FROM Employees e
	WHERE MONTH(e.BirthDate) = 02;
END
GO

drop table birthday_employee_rahimi