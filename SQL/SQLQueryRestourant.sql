CREATE DATABASE Restaurant
USE Restaurant

CREATE TABLE Meals
(
MealId INT PRIMARY KEY IDENTITY,
MealName NVARCHAR(25) NOT NULL,
Price DECIMAL(18,2) NOT NULL,
)

CREATE TABLE Tables
(
TableId INT PRIMARY KEY IDENTITY,
TableNumber INT NOT NULL UNIQUE
)

CREATE TABLE Orders
(
OrderId INT PRIMARY KEY IDENTITY,
TableId INT NOT NULL,
MealId INT NOT NULL,
OrderDateTime DATETIME NOT NULL,
FOREIGN KEY (TableId) REFERENCES Tables(TableId),
FOREIGN KEY (MealId) REFERENCES Meals(MealId)
)
ALTER TABLE Orders ADD Quantity INT NOT NULL DEFAULT 1

INSERT INTO Meals (MealName,Price)
VALUES
('Toyuq kababi',6.00),
('Lule kababi',7.00),
('Antrikot kababi',9.00)

INSERT INTO Tables (TableNumber)
VALUES
(1),(2),(3)

INSERT INTO Orders (TableId,MealId,OrderDateTime,Quantity)
VALUES
(1,2,'2025-06-13 15:25:00',3),
(1,1,'2025-06-13 17:25:00',2),
(2,3,'2025-06-14 13:55:00',4)


SELECT 
t.TableId,
t.TableNumber,
(SELECT ISNULL(SUM(o.Quantity),0) FROM Orders o WHERE o.TableId = t.TableId) TotalOrder
FROM Tables t



SELECT 
m.MealId,
m.MealName,
m.Price,
(SELECT ISNULL(SUM(o.Quantity),0) FROM Orders o WHERE o.MealId = m.MealId)  TotalOrder,
m.Price*(SELECT ISNULL(SUM(o.Quantity),0) FROM Orders o WHERE o.MealId = m.MealId) TotalPrice
FROM Meals m 
--elave olaraq totalprice gorunur--


SELECT 
t.TableId,
t.TableNumber,
m.MealName,
m.Price,
(SELECT ISNULL(SUM(o.Quantity),0) FROM Orders o WHERE o.MealId = m.MealId)  TotalOrder,
m.Price*(SELECT ISNULL(SUM(o.Quantity),0) FROM Orders o WHERE o.MealId = m.MealId) TotalPrice
FROM Meals m 
JOIN Orders o 
ON o.MealId = m.MealId
JOIN Tables t
ON t.TableId=o.TableId
WHERE o.Quantity > 0;


SELECT DATEDIFF(HOUR,MIN(OrderDateTime),MAX(OrderDateTime)) HoursDiff FROM Orders WHERE TableId=1


SELECT t.TableId, t.TableNumber,
(SELECT ISNULL(SUM(o.Quantity),0) FROM Orders o WHERE o.TableId = t.TableId) TotalOrder
FROM Tables t
LEFT JOIN Orders o 
ON t.TableId = o.TableId
WHERE o.OrderId IS NULL


SELECT * FROM Orders o 
WHERE o.OrderDateTime<DATEADD(MINUTE,-30,GETDATE())


SElECT * FROM Tables t
WHERE
NOT EXISTS
(SELECT o.TableId FROM Orders o WHERE o.TableId=t.TableId)


SELECT * FROM Tables t
JOIN Orders o
ON o.TableId=t.TableId
WHERE 
o.OrderDateTime<DATEADD(MINUTE,-60,GETDATE())






