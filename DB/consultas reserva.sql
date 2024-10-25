--Customer
select Distinct per.Name as name,TypeCustomer as type, cus.Loyalty_Points as loyaltyPoints
from Customer cus INNER JOIN Person per ON (cus.Person_ID = per.ID)

--Payment
select distinct payt.Name, pay.Amount, pay.Currency
from Payment pay INNER JOIN Payment_Type payt ON (pay.Payment_Type_ID=payt.ID)

--Tiempo
SELECT DISTINCT 
    Reservation_Date AS fecha,
    CONVERT(INT,DATEPART(YEAR, Reservation_Date)) AS year,
    CONVERT(VARCHAR,DATEPART(MONTH, Reservation_Date)) AS month,
    CONVERT(INT, DATEPART(WEEK, Reservation_Date)) AS week,--quitar
    CONVERT(INT, DATEPART(DAY, Reservation_Date)) AS day
FROM Reserve;

--Reserve
SELECT 
    r.Customer_ID,
    COUNT(CASE WHEN r.State = 1 THEN 1 END) AS cantReservasConfirmadas,
    COUNT(CASE WHEN r.State = 0 THEN 1 END) AS cantReservasCanceladas,
    CAST(COUNT(CASE WHEN r.State = 0 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS porcentajeReservasCanceladas,
    CAST(COUNT(CASE WHEN r.State = 1 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS porcentajeReservasConfirmadas
FROM 
    Reserve r
GROUP BY 
    r.Customer_ID;




	SELECT 
    c.id AS customer_id,
    t.id AS time_id,
    p.id AS payment_id,
    SUM(CASE WHEN r.State = 1 THEN 1 ELSE 0 END) AS ConfirmedReservations,
    SUM(CASE WHEN r.State = 0 THEN 1 ELSE 0 END) AS CanceledReservations,
    CAST(SUM(CASE WHEN r.State = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS ConfirmedPercentage,
    CAST(SUM(CASE WHEN r.State = 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS CanceledPercentage
FROM 
    airportScript.dbo.Reserve r
    INNER JOIN airportData.dbo.dimCustomer c ON r.Customer_ID = c.id
    INNER JOIN airportData.dbo.dimTime t ON r.Reservation_Date = t.fecha
    INNER JOIN airportData.dbo.dimPayment p ON r.Payment_ID = p.id
GROUP BY 
    c.id, t.id, p.id;
------------------------------------------------------------------------------

		SELECT 
    c.id AS dimCustomerID,
    t.id AS dimTimeID,
    p.id AS dimPaymentID,
    SUM(CASE WHEN r.State = 1 THEN 1 ELSE 0 END) AS ConfirmedReservations,
    SUM(CASE WHEN r.State = 0 THEN 1 ELSE 0 END) AS CanceledReservations
FROM 
    Reserve r
    INNER JOIN airportData.dbo.dimCustomer c ON r.Customer_ID = c.id
    INNER JOIN airportData.dbo.dimTime t ON r.Reservation_Date = t.fecha
    INNER JOIN airportData.dbo.dimPayment p ON r.Payment_ID = p.id
GROUP BY 
    c.id, t.id, p.id;



	SELECT 
    CASE 
        WHEN COUNT(R.ID) = 0 THEN 0
        ELSE (CAST(COUNT(C.Reserve_ID) AS FLOAT) / COUNT(R.ID)) * 100
    END AS Percentage_Cancelled
FROM 
    Reserve R
LEFT JOIN 
    Cancellation C ON R.ID = C.Reserve_ID;



	SELECT 
    r.Customer_ID,
    COUNT(*) AS totalReservas,
    COUNT(CASE WHEN r.State = 1 THEN 1 END) AS cantReservasConfirmadas,
    COUNT(CASE WHEN r.State = 0 THEN 1 END) AS cantReservasCanceladas,
    CAST(COUNT(CASE WHEN r.State = 1 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS porcentajeReservasConfirmadas,
    CAST(COUNT(CASE WHEN r.State = 0 THEN 1 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS porcentajeReservasCanceladas
FROM 
    Reserve r
GROUP BY 
    r.Customer_ID;


/***********************************************************************/
SELECT 
    c.id AS customer_id,
    t.id AS time_id,
    p.id AS payment_id,
    SUM(CASE WHEN r.State = 1 THEN 1 ELSE 0 END) AS ConfirmedReservations,
    SUM(CASE WHEN r.State = 0 THEN 1 ELSE 0 END) AS CanceledReservations,
    CAST(SUM(CASE WHEN r.State = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS ConfirmedPercentage,
    CAST(SUM(CASE WHEN r.State = 0 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS CanceledPercentage
FROM 
    Reserve r
    INNER JOIN airportData.dbo.dimCustomer c ON r.Customer_ID = c.id
    INNER JOIN airportData.dbo.dimTime t ON r.Reservation_Date = t.fecha
    INNER JOIN airportData.dbo.dimPayment p ON r.Payment_ID = p.id
GROUP BY 
    c.id, t.id, p.id;


/**CONSULTA PARA TICKET**/
--category
select distinct c.Name
from Category c

--document
select distinct dt.Name
from Document d INNER JOIN Document_Type dt ON (d.Document_Type_ID=dt.ID)

--passenger
select distinct p.Name AS name, pt.Name as type
from Person p INNER JOIN Passenger ps ON (p.ID = ps.Person_ID)
			  INNER JOIN Passenger_Type pt ON (ps.Passenger_Type_ID = pt.ID)

-- Ticket
SELECT 
    Passenger_ID,
    COUNT(*) AS Total_Tickets,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Ticket)) AS Percentage_Tickets
FROM 
    Ticket t
	
GROUP BY 
    Passenger_ID;




SELECT 
    dc.id AS category_id,
    dp.id AS passenger_id,
    dd.id AS document_id,
    COUNT(t.Ticketing_Code) AS cantidadTickets,
    (COUNT(t.Ticketing_Code) * 100.0 / (SELECT COUNT(*) FROM Ticket)) AS porcentajeTickets
FROM 
    Ticket t
    INNER JOIN Category c ON t.Category_ID = c.id
    INNER JOIN ticketMart.dbo.dimCategory dc ON c.Name = dc.name
    INNER JOIN Passenger ps ON t.Passenger_ID = ps.ID
    INNER JOIN Person p ON ps.Person_ID = p.ID
    INNER JOIN ticketMart.dbo.dimPassenger dp ON p.Name = dp.name
    INNER JOIN Document d ON t.Document_ID = d.id
    INNER JOIN Document_Type dt ON d.Document_Type_ID = dt.ID
    INNER JOIN ticketMart.dbo.dimDocument dd ON dt.Name = dd.type
GROUP BY 
    dc.id, dp.id, dd.id;
