use master
--CONSULTAS MART RESERVE
--dimTime
SELECT DISTINCT 
    Reservation_Date AS fecha,
    CONVERT(INT,DATEPART(YEAR, Reservation_Date)) AS year,
    CONVERT(VARCHAR,DATEPART(MONTH, Reservation_Date)) AS month,
    CONVERT(INT, DATEPART(WEEK, Reservation_Date)) AS week,--quitar
    CONVERT(INT, DATEPART(DAY, Reservation_Date)) AS day
FROM Reserve r
where r.Reservation_Date not in(select fecha from martReserve.dbo.dimTime)


SELECT DISTINCT 
    Reservation_Date AS fecha,
    CONVERT(INT, DATEPART(YEAR, Reservation_Date)) AS year,
    DATENAME(MONTH, Reservation_Date) AS month, -- Nombre del mes en letras
    CONVERT(INT, DATEPART(WEEK, Reservation_Date)) AS week, --quitar si no es necesario
    CONVERT(INT, DATEPART(DAY, Reservation_Date)) AS day,
    DATENAME(WEEKDAY, Reservation_Date) AS day_name -- Nombre del día en letras
FROM Reserve r


SELECT DISTINCT 
    Reservation_Date AS fecha,
    CONVERT(INT, DATEPART(YEAR, Reservation_Date)) AS year,
    DATENAME(MONTH, Reservation_Date) AS month, 
    CONVERT(INT, DATEPART(DAY, Reservation_Date)) AS day,
    DATENAME(WEEKDAY, Reservation_Date) AS dayOfWeek 
FROM 
    Reserve
WHERE 
    Reservation_Date NOT IN (SELECT fecha FROM martReserve.dbo.dimTime);




--dimCustomer
select c.ID as id_customer, p.Name as name,tc.name as type, c.Loyalty_Points as loyaltyPoints
from Customer c INNER JOIN Person p ON (c.Person_ID = p.ID)
				  INNER JOIN Type_Customer tc ON(c.TypeCustomer_ID=tc.ID)
where c.ID not in(select id_customer from martReserve.dbo.dimCustomer)

MERGE martReserve.dbo.dimCustomer AS target
USING (
    SELECT 
        c.ID AS id_customer, 
        p.Name AS name, 
        tc.Name AS type, 
        c.Loyalty_Points AS loyaltyPoints
    FROM Customer c
    INNER JOIN Person p ON c.Person_ID = p.ID
    INNER JOIN Type_Customer tc ON c.TypeCustomer_ID = tc.ID
) AS source
ON target.id_customer = source.id_customer

-- Actualiza los registros que existen pero tienen datos diferentes
WHEN MATCHED AND (
    target.name <> source.name OR
    target.type <> source.type OR
    target.loyaltyPoints <> source.loyaltyPoints
) THEN
    UPDATE SET 
        target.name = source.name,
        target.type = source.type,
        target.loyaltyPoints = source.loyaltyPoints

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;




select * from Customer
--dimPayment
select p.ID as id_payment, pt.Name as type, p.Amount as amount, c.code as currency
from Payment p INNER JOIN Payment_Type pt ON (p.Payment_Type_ID=pt.ID)
				INNER JOIN Currency c ON (c.ID=p.Currency_ID)
where p.ID not in(select id_payment from martReserve.dbo.dimPayment)

MERGE martReserve.dbo.dimPayment AS target
USING (
    SELECT 
        p.ID AS id_payment, 
        pt.Name AS type, 
        p.Amount AS amount, 
        c.code AS currency
    FROM Payment p
    INNER JOIN Payment_Type pt ON p.Payment_Type_ID = pt.ID
    INNER JOIN Currency c ON p.Currency_ID = c.ID
) AS source
ON target.id_payment = source.id_payment

-- Actualiza los registros que existen pero tienen datos diferentes
WHEN MATCHED AND (
    target.type <> source.type OR
    target.amount <> source.amount OR
    target.currency <> source.currency
) THEN
    UPDATE SET 
        target.type = source.type,
        target.amount = source.amount,
        target.currency = source.currency

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


--dimStatusReserve
select  distinct CASE 
        WHEN State = 1 THEN 'Cancelado' 
        ELSE 'Confirmado' 
		END AS name
from Reserve r
where r.State not in (select distinct case
							when name = 'Confirmado' then 0
							else 1 
							end 
					  from martReserve.dbo.dimStatusReserve)

MERGE martReserve.dbo.dimStatusReserve AS target
USING (
    SELECT DISTINCT 
        CASE 
            WHEN State = 1 THEN 'Cancelado' 
            ELSE 'Confirmado' 
        END AS name
    FROM Reserve r
) AS source
ON target.name = source.name

-- Si el estado ya existe en `dimStatusReserve` pero con un valor diferente, se actualizará
WHEN MATCHED AND target.name <> source.name THEN
    UPDATE SET 
        target.name = source.name

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

--facReservation

SELECT
    dt.id AS time_id,
    dc.id AS customer_id,
    dp.id AS payment_id,
    ds.id AS status_id,
    COUNT(r.ID) AS count_reserve
FROM 
    Reserve r
    INNER JOIN martReserve.dbo.dimTime dt ON CONVERT(DATE, r.Reservation_Date) = dt.fecha
    INNER JOIN martReserve.dbo.dimCustomer dc ON r.Customer_ID = dc.id_customer
    INNER JOIN martReserve.dbo.dimPayment dp ON r.Payment_ID = dp.id
    INNER JOIN martReserve.dbo.dimStatusReserve ds ON 
        (CASE WHEN r.State = 1 THEN 'Cancelado' ELSE 'Confirmado' END) = ds.name
--WHERE r.id not in (	select id from martReserve.dbo.facReservation)
GROUP BY 
    dt.id, dc.id, dp.id, ds.id;


	select * from martReserve.dbo.facReservation


SELECT
    dt.id AS time_id,
    dc.id AS customer_id,
    dp.id AS payment_id,
    ds.id AS status_id,
    COUNT(r.ID) AS count_reserve,
    SUM(p.Amount) AS total_amount
FROM 
    Reserve r
    INNER JOIN Payment p ON r.Payment_ID = p.ID
    INNER JOIN martReserve.dbo.dimTime dt ON CONVERT(DATE, r.Reservation_Date) = dt.fecha
    INNER JOIN martReserve.dbo.dimCustomer dc ON r.Customer_ID = dc.id_customer
    INNER JOIN martReserve.dbo.dimPayment dp ON r.Payment_ID = dp.id
    INNER JOIN martReserve.dbo.dimStatusReserve ds ON 
        (CASE WHEN r.State = 1 THEN 'Cancelado' ELSE 'Confirmado' END) = ds.name
where r.id not in(select id from martReserve.dbo.facReservation)
GROUP BY 
    dt.id, dc.id, dp.id, ds.id;














	SELECT
    dt.id AS time_id,
    dc.id AS customer_id,
    dp.id AS payment_id,
    ds.id AS status_id,
    COUNT(r.ID) AS count_reserve,
    SUM(p.Amount) AS total_amount
FROM 
    Reserve r
    INNER JOIN Payment p ON r.Payment_ID = p.ID
    INNER JOIN martReserve.dbo.dimTime dt ON CONVERT(DATE, r.Reservation_Date) = dt.fecha
    INNER JOIN martReserve.dbo.dimCustomer dc ON r.Customer_ID = dc.id_customer
    INNER JOIN martReserve.dbo.dimPayment dp ON r.Payment_ID = dp.id
    INNER JOIN martReserve.dbo.dimStatusReserve ds ON 
        (CASE WHEN r.State = 1 THEN 'Cancelado' ELSE 'Confirmado' END) = ds.name
--where r.id not in(select id from martReserve.dbo.facReservation)
GROUP BY 
    dt.id, dc.id, dp.id, ds.id;

	select * from martReserve.dbo.facReservation

	select * from Reserve


/*PARA PRUEBA*/
--Cantidad de reservas confirmadas y canceladas por cliente:
SELECT 
    dc.name AS Cliente,
    ds.name AS Estado,
    SUM(fr.count_reserve) AS CantidadReservas
FROM 
    facReservation fr
    INNER JOIN dimCustomer dc ON fr.customer_id = dc.id
    INNER JOIN dimStatusReserve ds ON fr.status_id = ds.id
	where dc.name = 'Abel Uribe Cerro'
GROUP BY 
    dc.name, ds.name;
--Cantidad de reservas por tipo de cliente y tipo de pago:
SELECT 
    dc.type AS TipoCliente,
    dp.type AS TipoPago,
    ds.Estado AS Estado,
    SUM(fr.count_reserve) AS CantidadReservas
FROM 
    facReservation fr
    INNER JOIN dimCustomer dc ON fr.customer_id = dc.id
    INNER JOIN dimPayment dp ON fr.payment_id = dp.id
    INNER JOIN dimStatusReserve ds ON fr.status_id = ds.id
GROUP BY 
    dc.type, dp.type, ds.Estado;
--Cantidad de reservas por año y estado:
SELECT 
    dt.year AS Año,
    ds.Estado AS Estado,
    SUM(fr.count_reserve) AS CantidadReservas
FROM 
    facReservation fr
    INNER JOIN dimTime dt ON fr.time_id = dt.id
    INNER JOIN dimStatusReserve ds ON fr.status_id = ds.id
GROUP BY 
    dt.year, ds.Estado;


/*############################# TICKET ################################*/
--dimCategory
select id as id_category, Name as name, price
from Category 
where Name not in(select name from martTicket.dbo.dimCategory)
MERGE martTicket.dbo.dimCategory AS target
USING (
    SELECT 
        id AS id_category, 
        Name AS name, 
        price
    FROM Category
) AS source
ON target.id_category = source.id_category

-- Actualiza los registros que existen pero tienen datos diferentes
WHEN MATCHED AND (
    target.name <> source.name OR
    target.price <> source.price
) THEN
    UPDATE SET 
        target.name = source.name,
        target.price = source.price

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


--dimPassenger
select p.ID as id_passenger, pe.Name as name, pt.Name as type
from Passenger p INNER JOIN Person pe ON (p.Person_ID=pe.id)
				 INNER JOIN Passenger_Type pt ON (p.Passenger_Type_ID = pt.ID)
where p.ID not in(select id_passenger from martTicket.dbo.dimPassenger)


MERGE martReserve.dbo.dimStatusReserve AS target
USING (
    SELECT DISTINCT 
        CASE 
            WHEN State = 1 THEN 'Cancelado' 
            ELSE 'Confirmado' 
        END AS name
    FROM Reserve r
) AS source
ON target.name = source.name

-- Si el estado ya existe en `dimStatusReserve` pero con un valor diferente, se actualizará
WHEN MATCHED AND target.name <> source.name THEN
    UPDATE SET 
        target.name = source.name

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


select * from Passenger

--dimDocument
select d.id as id_document, d.Date_of_Issue as date_issue, 
		d.Valid_Date as valid_date, dt.Name as type
from Document d INNER JOIN Document_Type dt ON (d.Document_Type_ID = dt.ID)
where d.id not in(select id_document from martTicket.dbo.dimDocument)

MERGE martTicket.dbo.dimDocument AS target
USING (
    SELECT 
        d.ID AS id_document, 
        d.Date_of_Issue AS date_issue, 
        d.Valid_Date AS valid_date, 
        dt.Name AS type
    FROM Document d
    INNER JOIN Document_Type dt ON d.Document_Type_ID = dt.ID
) AS source
ON target.id_document = source.id_document

-- Actualiza los registros que existen pero tienen datos diferentes
WHEN MATCHED AND (
    target.date_issue <> source.date_issue OR
    target.valid_date <> source.valid_date OR
    target.type <> source.type
) THEN
    UPDATE SET 
        target.date_issue = source.date_issue,
        target.valid_date = source.valid_date,
        target.type = source.type

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


select * from Document


--dimTime
SELECT DISTINCT 
    Date_Ticket AS fecha,
    CONVERT(INT,DATEPART(YEAR, Date_Ticket)) AS year,
    CONVERT(VARCHAR,DATEPART(MONTH, Date_Ticket)) AS month,
    CONVERT(INT, DATEPART(WEEK, Date_Ticket)) AS week,--quitar
    CONVERT(INT, DATEPART(DAY, Date_Ticket)) AS day
FROM Ticket t
where t.Date_Ticket not in(select fecha from martTicket.dbo.dimTime)



SELECT DISTINCT 
    Date_Ticket AS fecha,
    CONVERT(INT, DATEPART(YEAR, Date_Ticket)) AS year,
    DATENAME(MONTH, Date_Ticket) AS month, 
    DATENAME(WEEKDAY, Date_Ticket) AS day
FROM 
    Ticket t
WHERE 
    t.Date_Ticket NOT IN (SELECT fecha FROM martTicket.dbo.dimTime);
select * from Ticket

--factTicket
SELECT 
      t.Number as ticketNumber,
    dc.id AS category_id,
    dp.id AS passenger_id,
    dd.id AS document_id,
    dt.id AS time_id,
    COUNT(*) AS ticket_count,
	SUM(dc.price) AS total_price
FROM 
    Ticket t
JOIN martTicket.dbo.dimCategory dc ON t.Category_ID = dc.id_category
JOIN martTicket.dbo.dimPassenger dp ON t.Passenger_ID = dp.id_passenger
JOIN martTicket.dbo.dimDocument dd ON t.Document_ID = dd.id_document
JOIN martTicket.dbo.dimTime dt ON t.Date_Ticket = dt.fecha
where t.Number not in(select ticketNumber from martTicket.dbo.factTicket)
GROUP BY 
    dc.id, dp.id, dd.id, dt.id, t.Number



select * from ticket


--PARA PRUEBA
--Cantidad de tickets por categoría:
SELECT dc.name, SUM(ft.ticket_count) AS total_tickets
FROM factTicket ft
JOIN dimCategory dc ON ft.category_id = dc.id
GROUP BY dc.name;

--Porcentaje de tickets por categoría:
SELECT dc.name,
       SUM(ft.ticket_count) * 100.0 / (SELECT SUM(ticket_count) FROM factTicket) AS porcentaje_tickets
FROM factTicket ft
JOIN dimCategory dc ON ft.category_id = dc.id
GROUP BY dc.name;

--Análisis temporal (si incluyes dimDate):
SELECT d.year, d.month, SUM(ft.ticket_count) AS total_tickets
FROM factTicket ft
JOIN dimDate d ON ft.date_issued_id = d.id
GROUP BY d.year, d.month;
