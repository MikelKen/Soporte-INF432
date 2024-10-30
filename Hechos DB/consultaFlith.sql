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