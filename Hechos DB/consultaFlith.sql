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
