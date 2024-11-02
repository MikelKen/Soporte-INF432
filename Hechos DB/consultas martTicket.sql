use master
--CONSULTAS MART RESERVE
--dimTime
SELECT DISTINCT 
    Reservation_Date AS fecha,
    CONVERT(INT,DATEPART(YEAR, Reservation_Date)) AS year,
    CONVERT(VARCHAR,DATEPART(MONTH, Reservation_Date)) AS month,
    CONVERT(INT, DATEPART(WEEK, Reservation_Date)) AS week,--quitar
    CONVERT(INT, DATEPART(DAY, Reservation_Date)) AS day
FROM Reserve;

--dimCustomer
select c.ID as id_customer, p.Name as name,tc.name as type, c.Loyalty_Points as loyaltyPoints
from Customer c INNER JOIN Person p ON (c.Person_ID = p.ID)
				  INNER JOIN Type_Customer tc ON(c.TypeCustomer_ID=tc.ID)
where c.ID not in(select id_customer from martReserve.dbo.dimCustomer)

--dimPayment
select p.ID as id_payment, pt.Name as type, p.Amount as amount, c.code as currency
from Payment p INNER JOIN Payment_Type pt ON (p.Payment_Type_ID=pt.ID)
				INNER JOIN Currency c ON (c.ID=p.Currency_ID)
where p.ID not in(select id_payment from martReserve.dbo.dimPayment)

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