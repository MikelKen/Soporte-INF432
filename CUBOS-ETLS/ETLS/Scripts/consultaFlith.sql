--CONSULTA TIEMPO
SELECT DISTINCT 
    Flight_Date AS fecha,
    CONVERT(INT, DATEPART(YEAR, Flight_Date)) AS year,
    DATENAME(MONTH, Flight_Date) AS month, 
    CONVERT(INT, DATEPART(DAY, Flight_Date)) AS day,
    DATENAME(WEEKDAY, Flight_Date) AS dayOfWeek 
FROM 
    Flight
WHERE 
    Flight_Date NOT IN (SELECT fecha FROM martFlight.dbo.dimTime);

--=========================================================================================
SELECT DISTINCT 
    ID AS id_airline, 
    Name AS name
FROM Airline
WHERE ID NOT IN (SELECT id_airline FROM martFlight.dbo.dimAirline)
MERGE martFlight.dbo.dimAirline AS target
USING (
    SELECT DISTINCT 
        ID AS id_airline, 
        Name AS name
    FROM Airline
) AS source
ON target.id_airline = source.id_airline

-- Actualiza los registros que existen pero tienen datos diferentes
WHEN MATCHED AND target.name <> source.name THEN
    UPDATE SET 
        target.name = source.name

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;




--==========================================================
--dim palne
SELECT DISTINCT 
    ID AS id_modelPlane, 
    Description, 
    Graphic
FROM Plane_Model
WHERE ID NOT IN (SELECT id_modelPlane FROM martFlight.dbo.dimModelPlane);
MERGE martFlight.dbo.dimModelPlane AS target
USING (
    SELECT DISTINCT 
        ID AS id_modelPlane, 
        Description, 
        Graphic
    FROM Plane_Model
) AS source
ON target.id_modelPlane = source.id_modelPlane

-- Actualiza los registros que existen pero tienen datos diferentes
WHEN MATCHED AND (
    target.Description <> source.Description OR
    target.Graphic <> source.Graphic
) THEN
    UPDATE SET 
        target.Description = source.Description,
        target.Graphic = source.Graphic

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


--=====================================================
use master
select * from Airport
select * from City
select * from Country
--dimAirport
SELECT DISTINCT 
    ap.ID AS id_airport, 
    ap.Name AS name, 
    c.Name AS city, 
    co.Name AS country
FROM Airport ap
JOIN City c ON ap.City_ID = c.ID
JOIN Country co ON c.Country_ID = co.ID
WHERE ap.ID NOT IN (SELECT id_airport FROM martFlight.dbo.dimAirport)
MERGE martFlight.dbo.dimAirport AS target
USING (
    SELECT DISTINCT 
        ap.ID AS id_airport, 
        ap.Name AS name, 
        c.Name AS city, 
        co.Name AS country
    FROM Airport ap
    JOIN City c ON ap.City_ID = c.ID
    JOIN Country co ON c.Country_ID = co.ID
) AS source
ON target.id_airport = source.id_airport

-- Actualiza los registros que existen pero tienen datos diferentes
WHEN MATCHED AND (
    target.name <> source.name OR
    target.city <> source.city OR
    target.country <> source.country
) THEN
    UPDATE SET 
        target.name = source.name,
        target.city = source.city,
        target.country = source.country

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;



--================================
select * from Flight
--status
select  distinct CASE 
        WHEN State = 1 THEN 'Confirmado' 
        ELSE 'Cancelado' 
		END AS name
from Flight f
where f.State not in (select distinct case
							when statusName = 'Confirmado' then 1
							else 0
							end 
					  from martFlight.dbo.dimFlightStatus)
MERGE martFlight.dbo.dimFlightStatus AS target
USING (
    SELECT DISTINCT 
        CASE 
            WHEN State = 1 THEN 'Confirmado' 
            ELSE 'Cancelado' 
        END AS name
    FROM Flight f
) AS source
ON target.statusName = source.name



-- Actualiza los registros que existen pero tienen datos diferentes
WHEN MATCHED AND target.statusName <> source.name THEN
    UPDATE SET 
        target.statusName = source.name

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;


--==================================
SELECT 
    dt.id AS time_id,
    da.id AS airline_id,
    dp.id AS model_plane,
    dap.id AS airport_id,
    ds.id AS status_id,
    SUM(CASE WHEN f.State = 1 THEN 1 ELSE 0 END) AS CantVueloConfirm,
    SUM(CASE WHEN f.State = 0 THEN 1 ELSE 0 END) AS CantVueloCancelled
FROM Flight f
JOIN martFlight.dbo.dimTime dt ON f.Flight_Date = dt.fecha
JOIN martFlight.dbo.dimAirline da ON f.Airline_ID = da.id_airline
JOIN martFlight.dbo.dimModelPlane dp ON f.Plane_ID = dp.id_modelPlane
JOIN martFlight.dbo.dimAirport dap ON f.Flight_Number_id = dap.id_airport
JOIN martFlight.dbo.dimFlightStatus ds ON 
    (CASE WHEN f.State = 1 THEN 'Confirmado' ELSE 'Cancelado' END) = ds.statusName
GROUP BY dt.id, da.id, dp.id, dap.id, ds.id

MERGE martFlight.dbo.factFlight AS target
USING (
    SELECT 
        dt.id AS time_id,
        da.id AS airline_id,
        dp.id AS model_plane,
        dap.id AS airport_id,
        ds.id AS status_id,
        SUM(CASE WHEN f.State = 1 THEN 1 ELSE 0 END) AS CantVueloConfirm,
        SUM(CASE WHEN f.State = 0 THEN 1 ELSE 0 END) AS CantVueloCancelled
    FROM Flight f
    JOIN martFlight.dbo.dimTime dt ON f.Flight_Date = dt.fecha
    JOIN martFlight.dbo.dimAirline da ON f.Airline_ID = da.id_airline
    JOIN martFlight.dbo.dimModelPlane dp ON f.Plane_ID = dp.id_modelPlane
    JOIN martFlight.dbo.dimAirport dap ON f.Flight_Number_id = dap.id_airport
    JOIN martFlight.dbo.dimFlightStatus ds ON 
        (CASE WHEN f.State = 1 THEN 'Confirmado' ELSE 'Cancelado' END) = ds.statusName
    GROUP BY dt.id, da.id, dp.id, dap.id, ds.id
) AS source
ON target.time_id = source.time_id
   AND target.airline_id = source.airline_id
   AND target.model_plane = source.model_plane
   AND target.airport_id = source.airport_id
   AND target.status_id = source.status_id

-- Actualiza los registros que existen pero tienen datos diferentes
WHEN MATCHED AND (
    target.CantVueloConfirm <> source.CantVueloConfirm OR
    target.CantVueloCancelled <> source.CantVueloCancelled
) THEN
    UPDATE SET 
        target.CantVueloConfirm = source.CantVueloConfirm,
        target.CantVueloCancelled = source.CantVueloCancelled

-- Elimina los registros en la tabla de destino que no existen en la fuente
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;



















-- CONSULTA VUELO
select f.id as id_flith,
		case
			when fc.ID is not null then 'Cancelado'
			else 'Confirmado'
		end as state
from Flight f LEFT JOIN Flight_Cancellation fc ON f.ID = fc.Flight_ID 

--CONSULTA AVION
select a.Registration_Number as id_airplane,
		a.Status as state, pm.Description as modelo
from Airplane a LEFT JOIN Plane_Model pm on a.Plane_Model_ID = pm.ID

--Consulta Hecho airolinea
WITH CancellationReasons AS (
    SELECT 
        A.ID AS Airline_ID,
        A.Name AS Airline_Name,  -- Asumiendo que el nombre de la aerolínea está en la columna 'Name'
        FC.Reason,
        COUNT(FC.ID) AS Reason_Count,
        ROW_NUMBER() OVER (PARTITION BY A.ID ORDER BY COUNT(FC.ID) DESC) AS RN
    FROM 
        Airline AS A
    LEFT JOIN 
        Flight AS F ON A.ID = F.Airline_ID
    LEFT JOIN 
        Flight_Cancellation AS FC ON F.ID = FC.Flight_ID
    GROUP BY 
        A.ID, A.Name, FC.Reason
)

SELECT 
    A.ID AS Airline_ID,
    CR.Airline_Name,  -- Nombre de la aerolínea
    COUNT(DISTINCT F.ID) AS Total_Flights,
    COUNT(DISTINCT AP.Registration_Number) AS Total_Airplanes,
    COUNT(DISTINCT FC.ID) AS Total_Cancellations,
    COALESCE(AVG(DATEDIFF(day, F.Flight_Date, FC.NewDepartureDate)), 0) AS Average_Cancellation_Days,
    CR.Reason AS Most_Frequent_Cancellation_Reason
FROM 
    Airline AS A
LEFT JOIN 
    Flight AS F ON A.ID = F.Airline_ID
LEFT JOIN 
    Airplane AS AP ON F.Plane_ID = AP.Registration_Number
LEFT JOIN 
    Flight_Cancellation AS FC ON F.ID = FC.Flight_ID
LEFT JOIN 
    CancellationReasons AS CR ON A.ID = CR.Airline_ID AND CR.RN = 1
GROUP BY 
    A.ID, CR.Airline_Name, CR.Reason;



	-------------------------

	WITH CancellationReasons AS (
    SELECT 
        A.ID AS Airline_ID,
        A.Name AS Airline_Name,
        FC.Reason,
        COUNT(FC.ID) AS Reason_Count,
        ROW_NUMBER() OVER (PARTITION BY A.ID ORDER BY COUNT(FC.ID) DESC) AS RN
    FROM 
        Airline AS A
    LEFT JOIN 
        Flight AS F ON A.ID = F.Airline_ID
    LEFT JOIN 
        Flight_Cancellation AS FC ON F.ID = FC.Flight_ID
    GROUP BY 
        A.ID, A.Name, FC.Reason
)

SELECT 
    A.ID AS Airline_ID,
    CR.Airline_Name,  -- Nombre de la aerolínea
    COUNT(DISTINCT F.ID) AS Total_Flights,
    COUNT(DISTINCT AP.Registration_Number) AS Total_Airplanes,
    COUNT(DISTINCT FC.ID) AS Total_Cancellations,
    COALESCE(AVG(DATEDIFF(day, F.Flight_Date, FC.NewDepartureDate)), 0) AS Average_Cancellation_Days,
    CR.Reason AS Most_Frequent_Cancellation_Reason,
    COUNT(DISTINCT FConfirmed.ID) AS Total_Confirmed_Flights  -- Conteo de vuelos confirmados (no en Flight_Cancellation)
FROM 
    Airline AS A
LEFT JOIN 
    Flight AS F ON A.ID = F.Airline_ID
LEFT JOIN 
    Airplane AS AP ON F.Plane_ID = AP.Registration_Number
LEFT JOIN 
    Flight_Cancellation AS FC ON F.ID = FC.Flight_ID
LEFT JOIN 
    CancellationReasons AS CR ON A.ID = CR.Airline_ID AND CR.RN = 1
LEFT JOIN 
    Flight AS FConfirmed ON A.ID = FConfirmed.Airline_ID AND FConfirmed.ID NOT IN (SELECT Flight_ID FROM Flight_Cancellation) -- Vuelos no cancelados
GROUP BY 
    A.ID, CR.Airline_Name, CR.Reason;




	--------------------------------------------
	WITH CancellationReasons AS (
    SELECT 
        A.ID AS Airline_ID,
        A.Name AS Airline_Name,
        FC.Reason,
        COUNT(FC.ID) AS Reason_Count,
        ROW_NUMBER() OVER (PARTITION BY A.ID ORDER BY COUNT(FC.ID) DESC) AS RN
    FROM 
        Airline AS A
    LEFT JOIN 
        Flight AS F ON A.ID = F.Airline_ID
    LEFT JOIN 
        Flight_Cancellation AS FC ON F.ID = FC.Flight_ID
    GROUP BY 
        A.ID, A.Name, FC.Reason
)

SELECT 
    A.ID AS Airline_ID,
    CR.Airline_Name,  
    COUNT(DISTINCT F.ID) AS Total_Flights,
    COUNT(DISTINCT AP.Registration_Number) AS Total_Airplanes,
    COUNT(DISTINCT FC.ID) AS Total_Cancellations,
    COALESCE(CAST(COUNT(DISTINCT FC.ID) AS FLOAT) / NULLIF(COUNT(DISTINCT F.ID), 0), 0) AS Average_Cancellations_Per_Flight, -- Promedio de vuelos cancelados por aerolínea
    CR.Reason AS Most_Frequent_Cancellation_Reason,
    COUNT(DISTINCT FConfirmed.ID) AS Total_Confirmed_Flights
FROM 
    Airline AS A
LEFT JOIN 
    Flight AS F ON A.ID = F.Airline_ID
LEFT JOIN 
    Airplane AS AP ON F.Plane_ID = AP.Registration_Number
LEFT JOIN 
    Flight_Cancellation AS FC ON F.ID = FC.Flight_ID
LEFT JOIN 
    CancellationReasons AS CR ON A.ID = CR.Airline_ID AND CR.RN = 1
LEFT JOIN 
    Flight AS FConfirmed ON A.ID = FConfirmed.Airline_ID AND FConfirmed.ID NOT IN (
    SELECT Flight_ID FROM Flight_Cancellation) 
GROUP BY 
    A.ID, CR.Airline_Name, CR.Reason;


	-----------------------------------------------
	SELECT 
    A.ID AS id_Aeroline,
    DF.id_flith AS flith_id,
    AP.id_airplane AS airplane_id,
    COUNT(DISTINCT AP.id_airplane) AS cantAirplane,
    COALESCE(CAST(COUNT(FC.ID) AS FLOAT) / NULLIF(COUNT(DISTINCT DF.id_flith), 0), 0) AS avgFlithCandelled,
    CR.Reason AS motiveCancelledFrecuency
FROM 
    airportScript.dbo.Airline AS A
LEFT JOIN 
    airportScript.dbo.Flight AS F ON A.ID = F.Airline_ID
LEFT JOIN 
    airportScript.dbo.Flight_Cancellation AS FC ON F.ID = FC.Flight_ID
LEFT JOIN 
    martAeroline.dbo.dimFlith AS DF ON F.ID = DF.id_flith
LEFT JOIN 
    martAeroline.dbo.dimAirplane AS AP ON F.Plane_ID = AP.id_airplane
LEFT JOIN 
    (SELECT 
         A.ID AS Airline_ID,
         FC.Reason,
         COUNT(FC.ID) AS Reason_Count,
         ROW_NUMBER() OVER (PARTITION BY A.ID ORDER BY COUNT(FC.ID) DESC) AS RN
     FROM 
         airportScript.dbo.Airline AS A
     LEFT JOIN 
         airportScript.dbo.Flight AS F ON A.ID = F.Airline_ID
     LEFT JOIN 
         airportScript.dbo.Flight_Cancellation AS FC ON F.ID = FC.Flight_ID
     GROUP BY 
         A.ID, FC.Reason
    ) AS CR ON A.ID = CR.Airline_ID AND CR.RN = 1
GROUP BY 
    A.ID, DF.id_flith, AP.id_airplane, CR.Reason;
	---------------------------------------------------------------



	
SELECT 
    A.ID AS id_Aeroline,
    DF.id_flith AS flith_id,
    AP.id_airplane AS airplane_id,
    COUNT(DISTINCT AP.id_airplane) AS cantAirplane,
    COALESCE(CAST(COUNT(FC.ID) AS FLOAT) / NULLIF(COUNT(DISTINCT DF.id_flith), 0), 0) AS avgFlithCandelled,
    CR.Reason AS motiveCancelledFrecuency
FROM 
    airportScript.dbo.Airline AS A
LEFT JOIN 
   airportScript.dbo.Flight AS F ON A.ID = F.Airline_ID
LEFT JOIN 
   airportScript.dbo.Flight_Cancellation AS FC ON F.ID = FC.Flight_ID
LEFT JOIN 
    martAeroline.dbo.dimFlith AS DF ON F.ID = DF.id_flith
LEFT JOIN 
  martAeroline.dbo.dimAirplane AS AP ON F.Plane_ID = AP.id_airplane
LEFT JOIN 
    (SELECT 
         A.ID AS Airline_ID,
         FC.Reason,
         COUNT(FC.ID) AS Reason_Count,
         ROW_NUMBER() OVER (PARTITION BY A.ID ORDER BY COUNT(FC.ID) DESC) AS RN
     FROM 
        airportScript.dbo.Airline AS A
     LEFT JOIN 
    airportScript.dbo.Flight AS F ON A.ID = F.Airline_ID
     LEFT JOIN 
       airportScript.dbo.Flight_Cancellation AS FC ON F.ID = FC.Flight_ID
     GROUP BY 
         A.ID, FC.Reason
    ) AS CR ON A.ID = CR.Airline_ID AND CR.RN = 1
GROUP BY 
    A.ID, A.Name, DF.id_flith, AP.id_airplane, CR.Reason;


	use airportScript






SELECT 
    dt.id AS time_id,
    da.id AS airline_id,
    dp.id AS model_plane,
    dap.id AS airport_id,
    ds.id AS status_id
    --SUM(CASE WHEN f.State = 1 THEN 1 ELSE 0 END) AS CantVueloConfirm,
    --SUM(CASE WHEN f.State = 0 THEN 1 ELSE 0 END) AS CantVueloCancelled
FROM Flight f
INNER JOIN martFlight.dbo.dimTime dt ON CONVERT(DATE,f.Flight_Date) = dt.fecha
INNER JOIN martFlight.dbo.dimAirline da ON f.Airline_ID = da.id_airline
INNER JOIN martFlight.dbo.dimModelPlane dp ON f.Plane_ID = dp.id_modelPlane
INNER JOIN martFlight.dbo.dimAirport dap ON f.Flight_Number_id = dap.id_airport
INNER JOIN martFlight.dbo.dimFlightStatus ds ON 
    (CASE WHEN f.State = 1 THEN 'Confirmado' ELSE 'Cancelado' END) = ds.statusName
GROUP BY dt.id, da.id, dp.id, dap.id, ds.id

select * from dimCustomer
select * from dimPayment
select * from dimStatusReserve
select * from dimTime
select * from facReservation

select f.Flight_Date  from Flight f

select * from martFlight.dbo.dimTime
select * from martFlight.dbo.dimAirline
select * from martFlight.dbo.dimModelPlane
select * from martFlight.dbo.dimAirport
select * from martFlight.dbo.dimFlightStatus
select * from martFlight.dbo.factFlight


select * from martPayment.dbo.factPayment
select * from martReserve.dbo.facReservation
select * from martTicket.dbo.factTicket