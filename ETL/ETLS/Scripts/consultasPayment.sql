SELECT DISTINCT 
    Reservation_Date AS fecha,
    CONVERT(INT, DATEPART(YEAR, Reservation_Date)) AS year,
    DATENAME(MONTH, Reservation_Date) AS month, -- Nombre del mes en letras
    CONVERT(INT, DATEPART(WEEK, Reservation_Date)) AS week, --quitar si no es necesario
    CONVERT(INT, DATEPART(DAY, Reservation_Date)) AS day,
    DATENAME(WEEKDAY, Reservation_Date) AS day_name -- Nombre del día en letras
FROM Reserve r


--esto use
SELECT DISTINCT 
    Date AS fecha,
    CONVERT(INT, DATEPART(YEAR, Date)) AS year,
    DATENAME(MONTH, Date) AS month, 
    CONVERT(INT, DATEPART(DAY, Date)) AS day,
    DATENAME(WEEKDAY, Date) AS dayOfWeek 
FROM 
    Payment
WHERE 
    Date NOT IN (SELECT fecha FROM martPayment.dbo.dimTime);

--select * from Payment 

--===================================================================================================

SELECT DISTINCT 
    c.ID AS id_customer,
    p.Name AS name,
    tc.Name AS type
FROM Customer c
JOIN Person p ON c.Person_ID = p.ID
JOIN Type_Customer tc ON c.TypeCustomer_ID = tc.ID;

--use este
select c.ID as id_customer, p.Name as name,tc.name as type, c.Loyalty_Points as loyaltyPoints
from Customer c INNER JOIN Person p ON (c.Person_ID = p.ID)
				  INNER JOIN Type_Customer tc ON(c.TypeCustomer_ID=tc.ID)
where c.ID not in(select id_customer from martPayment.dbo.dimCustomer)

MERGE martPayment.dbo.dimCustomer AS target
USING (
    SELECT 
        c.ID AS id_customer, 
        p.Name AS name, 
        tc.Name AS type, 
        c.Loyalty_Points AS loyaltyPoints
    FROM 
        Customer c 
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

--===================================================================================================
--TYPEPAYMENT
SELECT DISTINCT 
    pt.ID AS id_typePayment,
    pt.Name AS typePayment
FROM Payment_Type pt
where pt.ID not in(select id_typePayment from martPayment.dbo.dimTypePayment)

MERGE martPayment.dbo.dimTypePayment AS target
USING (
    SELECT DISTINCT 
        pt.ID AS id_typePayment, 
        pt.Name AS typePayment
    FROM Payment_Type pt
) AS source
ON target.id_typePayment = source.id_typePayment

-- Actualiza los registros que existen pero tienen datos diferentes
WHEN MATCHED AND target.typePayment <> source.typePayment THEN
    UPDATE SET 
        target.typePayment = source.typePayment

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;



--===================================================================================================

SELECT
    dt.id AS time_id,
    dc.id AS customer_id,
    dtp.id AS typePayment_id,
    COUNT(p.ID) AS CantPagoRealizado,
    SUM(p.Amount) AS MontoTotalPago
FROM 
    Payment p
    INNER JOIN Reserve r ON p.ID = r.Payment_ID
    INNER JOIN martPayment.dbo.dimTime dt ON CONVERT(DATE, p.Date) = dt.fecha
    INNER JOIN martPayment.dbo.dimCustomer dc ON r.Customer_ID = dc.id_customer
    INNER JOIN martPayment.dbo.dimTypePayment dtp ON p.Payment_Type_ID = dtp.id_typePayment
WHERE p.ID NOT IN (SELECT id FROM martPayment.dbo.factPayment)
GROUP BY 
    dt.id, dc.id, dtp.id;

