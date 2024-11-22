--TIME



SELECT 
	--Flight_Number_id AS flightId,
    CONVERT(DATE, departureTime) AS FlightDate,
    YEAR(CONVERT(DATE, departureTime)) AS Year,
	MONTH(CONVERT(DATE, departureTime)) AS Month,
    DATENAME(MONTH, CONVERT(DATE, departureTime)) AS MonthName,
    DAY(CONVERT(DATE, departureTime)) AS Day,
    DATENAME(WEEKDAY, CONVERT(DATE, departureTime)) AS DayName,
    DATEPART(week, CONVERT(DATE, departureTime)) AS Week,
    CASE 
        WHEN MONTH(CONVERT(DATE, departureTime)) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(CONVERT(DATE, departureTime)) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(CONVERT(DATE, departureTime)) BETWEEN 7 AND 9 THEN 3
        WHEN MONTH(CONVERT(DATE, departureTime)) BETWEEN 10 AND 12 THEN 4
    END AS Quarter
FROM Flight
UNION
SELECT 
	Flight_Number_id AS flightId,
    arrivalDate AS FlightDate,
    YEAR(arrivalDate) AS Year,
	MONTH(arrivalDate) AS Month,
    DATENAME(MONTH, arrivalDate) AS MonthName,
	DAY(arrivalDate) AS Day,
    DATENAME(WEEKDAY, arrivalDate) AS DayName,
    DATEPART(week, arrivalDate) AS Week,
    CASE 
        WHEN MONTH(arrivalDate) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(arrivalDate) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(arrivalDate) BETWEEN 7 AND 9 THEN 3
        WHEN MONTH(arrivalDate) BETWEEN 10 AND 12 THEN 4
    END AS Quarter
FROM Flight f
WHERE  NOT IN (SELECT mf.FlightDate FROM martFlightPrueba.dbo.dimTime mf)

ORDER BY FlightDate;



-----------------------
SELECT DISTINCT 
    CONVERT(DATE, departureTime) AS FlightDate,
    YEAR(CONVERT(DATE, departureTime)) AS Year,
    MONTH(CONVERT(DATE, departureTime)) AS Month,
    DATENAME(MONTH, CONVERT(DATE, departureTime)) AS MonthName,
    DAY(CONVERT(DATE, departureTime)) AS Day,
    DATENAME(WEEKDAY, CONVERT(DATE, departureTime)) AS DayName,
    DATEPART(week, CONVERT(DATE, departureTime)) AS Week,
    CASE 
        WHEN MONTH(CONVERT(DATE, departureTime)) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(CONVERT(DATE, departureTime)) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(CONVERT(DATE, departureTime)) BETWEEN 7 AND 9 THEN 3
        WHEN MONTH(CONVERT(DATE, departureTime)) BETWEEN 10 AND 12 THEN 4
    END AS Quarter
FROM Flight
WHERE CONVERT(DATE, departureTime) NOT IN (
    SELECT mf.FlightDate FROM martFlightPrueba.dbo.dimTime mf
)
UNION
SELECT DISTINCT
    CONVERT(DATE, arrivalDate) AS FlightDate,
    YEAR(arrivalDate) AS Year,
    MONTH(arrivalDate) AS Month,
    DATENAME(MONTH, arrivalDate) AS MonthName,
    DAY(arrivalDate) AS Day,
    DATENAME(WEEKDAY, arrivalDate) AS DayName,
    DATEPART(week, arrivalDate) AS Week,
    CASE 
        WHEN MONTH(arrivalDate) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(arrivalDate) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(arrivalDate) BETWEEN 7 AND 9 THEN 3
        WHEN MONTH(arrivalDate) BETWEEN 10 AND 12 THEN 4
    END AS Quarter
FROM Flight f
WHERE arrivalDate NOT IN (
    SELECT mf.FlightDate FROM martFlightPrueba.dbo.dimTime mf
)
ORDER BY FlightDate;




------------------------------------------------------------------------------------------------
--AIRLINE

SELECT DISTINCT 
    ID AS id_airline, 
    Name AS name
FROM Airline
WHERE ID NOT IN (SELECT id_airline FROM martFlightPrueba.dbo.dimAirline)
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

--============================================================================================
--PLANE MODEL
--dim palne
SELECT DISTINCT 
    ID AS id_modelPlane, 
    Description, 
    Graphic
FROM Plane_Model
WHERE ID NOT IN (SELECT id_modelPlane FROM martFlightPrueba.dbo.dimModelPlane);
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

--========================================================================================
--AIRPORT
SELECT 
	FN.id AS id_flightNum,
    FN.Departure_Time AS departureTime,
    ASal.Name AS aeroExit,
    ALle.Name AS aeroArrival,
    CSal.Name AS cityExit,
    CLle.Name AS cityArrival,
    PSal.Name AS countryExit,
    PLle.Name AS countryArrival
FROM 
    Flight_Number FN INNER JOIN Airport ASal ON FN.Airport_Start = ASal.ID
				INNER JOIN Airport ALle ON FN.Airport_Goal = ALle.ID
				INNER JOIN City CSal ON ASal.City_ID = CSal.ID
				INNER JOIN City CLle ON ALle.City_ID = CLle.ID
				INNER JOIN Country PSal ON CSal.Country_ID = PSal.ID
				INNER JOIN Country PLle ON CLle.Country_ID = PLle.ID
WHERE FN.id NOT IN (SELECT id_flightNum FROM martFlightPrueba.dbo.dimAirport)

-----------------------------------------------------------------------------------------
--Crew Role
SELECT ca.ID as crew_id,f.ID as fligth_id, cr.Name
FROM Crew_Rol cr 
	INNER JOIN Crew_Assigment ca on cr.ID = ca.Crew_Rol_ID
	INNER JOIN Flight f ON ca.Flight_ID = f.ID
WHERE ca.ID NOT IN (SELECT crew_id FROM martFlightPrueba.dbo.dimCrewRole);



-------------------------------------------------------------------------------------------
select * from Flight




WITH FlightDates AS (
    SELECT DISTINCT CONVERT(DATE, departureTime) AS FlightDate
    FROM Flight
    UNION
    SELECT DISTINCT arrivalDate
    FROM Flight
)

WITH FlightSegments AS (
    -- Vuelos en la misma fecha
    SELECT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, departureHour, arrivalHour), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM Flight
    WHERE departureTime = arrivalDate

    UNION ALL

    -- Primer segmento: Desde la hora de salida hasta el final del día de salida
    SELECT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        departureTime AS fechaLlegada,
        '23:59:59' AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, departureHour, '23:59:59'), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM Flight
    WHERE departureTime <> arrivalDate

    UNION ALL

    -- Segundo segmento: Desde el inicio del día de llegada hasta la hora de llegada
    SELECT
        id,
        FORMAT(arrivalDate, 'yyyy-MM-dd') AS fechaFligth,
        arrivalDate AS fechaSalida,
        '00:00:00' AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', arrivalHour), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM Flight
    WHERE departureTime <> arrivalDate
)

SELECT 
    dt.id AS time_id,
    da.id AS airline_id,
	dm.id AS modelPlane_id,
	dai.id AS airport_id,
    f.departureTime AS departureTime,
    f.departureHour AS departureHour,
    f.arrivalDate AS arrivalDate,
    f.arrivalHour AS arrivalHour
FROM 
    Flight f
	INNER JOIN Flight_Number fn ON f.Flight_Number_id = fn.ID
	INNER JOIN martFlightPrueba.dbo.dimTime dt ON dt.FlightDate = CONVERT(DATE, f.departureTime) OR dt.FlightDate = f.arrivalDate
	INNER JOIN martFlightPrueba.dbo.dimAirline da ON f.Airline_ID = da.id_airline
	INNER JOIN martFlightPrueba.dbo.dimModelPlane dm ON f.Plane_ID = dm.id_modelPlane
	INNER JOIN martFlightPrueba.dbo.dimAirport dai ON f.ID = dai.id_flightNum
WHERE 
    dt.FlightDate IN (SELECT FlightDate FROM FlightDates)
ORDER BY 
    dt.FlightDate;






 
WITH FlightDates AS (
    SELECT DISTINCT CONVERT(DATE, departureTime) AS FlightDate
    FROM Flight
    UNION
    SELECT DISTINCT arrivalDate
    FROM Flight
),

FlightSegments AS (
    -- Vuelos en la misma fecha
    SELECT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, departureHour, arrivalHour), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM Flight
    WHERE departureTime = arrivalDate

    UNION ALL

    -- Primer segmento: Desde la hora de salida hasta el final del día de salida
    SELECT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        departureTime AS fechaLlegada,
        '23:59:59' AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, departureHour, '23:59:59'), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM Flight
    WHERE departureTime <> arrivalDate

    UNION ALL

    -- Segundo segmento: Desde el inicio del día de llegada hasta la hora de llegada
    SELECT
        id,
        FORMAT(arrivalDate, 'yyyy-MM-dd') AS fechaFligth,
        arrivalDate AS fechaSalida,
        '00:00:00' AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', arrivalHour), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM Flight
    WHERE departureTime <> arrivalDate
)

SELECT 
    dt.id AS time_id,
    da.id AS airline_id,
    dm.id AS modelPlane_id,
    dai.id AS airport_id,
	fs.fechaFligth,   
    f.departureTime AS departureTime,
    f.departureHour AS departureHour,
    f.arrivalDate AS arrivalDate,
    f.arrivalHour AS arrivalHour,
    --fs.fechaFligth,               -- Campo de fecha del segmento
    fs.duracionVueloHours         -- Campo de duración del vuelo
FROM 
    Flight f
    INNER JOIN Flight_Number fn ON f.Flight_Number_id = fn.ID
    INNER JOIN martFlightPrueba.dbo.dimTime dt ON dt.FlightDate = CONVERT(DATE, f.departureTime) OR dt.FlightDate = f.arrivalDate
    INNER JOIN martFlightPrueba.dbo.dimAirline da ON f.Airline_ID = da.id_airline
    INNER JOIN martFlightPrueba.dbo.dimModelPlane dm ON f.Plane_ID = dm.id_modelPlane
    INNER JOIN martFlightPrueba.dbo.dimAirport dai ON f.ID = dai.id_flightNum
    INNER JOIN FlightSegments fs ON fs.id = f.ID  -- Join con los segmentos de vuelo
WHERE 
    dt.FlightDate IN (SELECT FlightDate FROM FlightDates)
ORDER BY 
    dt.FlightDate;







	WITH FlightDates AS (
    SELECT DISTINCT CONVERT(DATE, departureTime) AS FlightDate
    FROM Flight
    UNION
    SELECT DISTINCT arrivalDate
    FROM Flight
),

FlightSegments AS (
    -- Vuelos en la misma fecha
    SELECT DISTINCT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, departureHour, arrivalHour), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM Flight
    WHERE departureTime = arrivalDate

    UNION ALL

    -- Primer segmento: Desde la hora de salida hasta el final del día de salida
    SELECT DISTINCT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        departureTime AS fechaLlegada,
        '23:59:59' AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, departureHour, '23:59:59'), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM Flight
    WHERE departureTime <> arrivalDate

    UNION ALL

    -- Segundo segmento: Desde el inicio del día de llegada hasta la hora de llegada
    SELECT DISTINCT
        id,
        FORMAT(arrivalDate, 'yyyy-MM-dd') AS fechaFligth,
        arrivalDate AS fechaSalida,
        '00:00:00' AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', arrivalHour), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM Flight
    WHERE departureTime <> arrivalDate
)

SELECT 
    dt.id AS time_id,
    da.id AS airline_id,
    dm.id AS modelPlane_id,
    dai.id AS airport_id,
	f.FlightNumber AS flight_number,
    fs.fechaFligth AS flight_date,   
    f.departureTime AS departureTime,
    f.departureHour AS departureHour,
    f.arrivalDate AS arrivalDate,
    f.arrivalHour AS arrivalHour,
    fs.duracionVueloHours         -- Campo de duración del vuelo

	
FROM 
    Flight f
    INNER JOIN Flight_Number fn ON f.Flight_Number_id = fn.ID
    --INNER JOIN martFlightPrueba.dbo.dimTime dt    ON dt.FlightDate = CONVERT(DATE, f.departureTime) 
    INNER JOIN martFlightPrueba.dbo.dimAirline da ON f.Airline_ID = da.id_airline
    INNER JOIN martFlightPrueba.dbo.dimModelPlane dm ON f.Plane_ID = dm.id_modelPlane
    INNER JOIN martFlightPrueba.dbo.dimAirport dai ON f.ID = dai.id_flightNum
	INNER JOIN martFlightPrueba.dbo.dimCrewRole dc ON f.ID = dc.fligth_id
    INNER JOIN FlightSegments fs ON fs.id = f.ID
	INNER JOIN martFlightPrueba.dbo.dimTime dt 
        ON dt.FlightDate = CONVERT(DATE, fs.fechaFligth) 
			
WHERE 
    dt.FlightDate IN (SELECT FlightDate FROM FlightDates)
ORDER BY 
    f.FlightNumber, dt.FlightDate;

-------------------------------------------------------------------------

select * from martFlightPrueba.dbo.dimTime
select * from Flight f












WITH FlightDates AS (
    SELECT DISTINCT CONVERT(DATE, departureTime) AS FlightDate
    FROM Flight
    UNION
    SELECT DISTINCT arrivalDate
    FROM Flight
),

FlightSegments AS (
    -- Vuelos en la misma fecha
    SELECT DISTINCT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        DATEDIFF(SECOND, 
                 CAST(departureHour AS DATETIME), 
                 CAST(arrivalHour AS DATETIME)) AS total_seconds
    FROM Flight
    WHERE departureTime = arrivalDate

    UNION ALL

    -- Primer segmento: Desde la hora de salida hasta el final del día de salida
    SELECT DISTINCT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        departureTime AS fechaLlegada,
        '23:59:59' AS horaLlegada,
        DATEDIFF(SECOND, 
                 CAST(departureHour AS DATETIME), 
                 CAST('23:59:59' AS DATETIME)) AS total_seconds
    FROM Flight
    WHERE departureTime <> arrivalDate

    UNION ALL

    -- Segundo segmento: Desde el inicio del día de llegada hasta la hora de llegada
    SELECT DISTINCT
        id,
        FORMAT(arrivalDate, 'yyyy-MM-dd') AS fechaFligth,
        arrivalDate AS fechaSalida,
        '00:00:00' AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        DATEDIFF(SECOND, 
                 CAST('00:00:00' AS DATETIME), 
                 CAST(arrivalHour AS DATETIME)) AS total_seconds
    FROM Flight
    WHERE departureTime <> arrivalDate
)

SELECT 
    dt.id AS time_id,
    da.id AS airline_id,
    dm.id AS modelPlane_id,
    dai.id_flightNum AS airport_id,
	dc.id AS crewRole_id,
    f.FlightNumber AS flight_number,
    fs.fechaFligth AS flight_date,   
    f.departureTime AS departureTime,
    f.departureHour AS departureHour,
    f.arrivalDate AS arrivalDate,
    f.arrivalHour AS arrivalHour,
    -- Duración del vuelo en formato HH:mm
    FORMAT(DATEADD(SECOND, fs.total_seconds, '00:00:00'), 'HH:mm') AS flight_duration_hour,
    -- Duración del vuelo en minutos
    fs.total_seconds / 60.0 AS total_minutes,
    -- Duración del vuelo en horas
    fs.total_seconds / 3600.0 AS total_hours
FROM 
    Flight f
    INNER JOIN Flight_Number fn ON f.Flight_Number_id = fn.ID
    INNER JOIN martFlightPrueba.dbo.dimAirline da ON f.Airline_ID = da.id_airline
    INNER JOIN martFlightPrueba.dbo.dimModelPlane dm ON f.Plane_ID = dm.id_modelPlane
    INNER JOIN martFlightPrueba.dbo.dimAirport dai ON f.ID = dai.id_flightNum
    INNER JOIN martFlightPrueba.dbo.dimCrewRole dc ON f.ID = dc.fligth_id
    INNER JOIN FlightSegments fs ON fs.id = f.ID
    INNER JOIN martFlightPrueba.dbo.dimTime dt 
        ON dt.FlightDate = CONVERT(DATE, fs.fechaFligth) 
WHERE 
    dt.FlightDate IN (SELECT FlightDate FROM FlightDates)
ORDER BY 
    f.FlightNumber, dt.FlightDate;
















