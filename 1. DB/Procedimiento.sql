use airportBase;
go
--Procedure for country


IF OBJECT_ID('InsertCountry', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertCountry;
END;
go
CREATE PROCEDURE InsertCountry
AS
BEGIN
IF NOT EXISTS (SELECT 1 FROM Country)
    BEGIN
   	INSERT INTO Country (Name) VALUES 
	('Bolivia'), 
	('Argentina'), 
	('Chile'), 
	('Brasil'), 
	('Peru'), 
	('Colombia'), 
	('Ecuador'), 
	('Paraguay'), 
	('Uruguay'), 
	('Venezuela');
end
END;
GO
-----------------------------------------------------------------------
--Procedure for city
IF OBJECT_ID('InsertCity', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertCity;
END;
go
CREATE PROCEDURE InsertCity
AS
BEGIN
    -- Verifica si la tabla City está vacía
    IF NOT EXISTS (SELECT 1 FROM City)
    BEGIN
        -- Si está vacía, inserta las ciudades
        INSERT INTO City (Country_id, Name) VALUES 
        (1, 'Santa Cruz'), 
        (2, 'Buenos Aires'), 
        (3, 'Santiago'), 
        (4, 'Rio de Janeiro'), 
        (5, 'Lima'), 
        (6, 'Bogotá'), 
        (7, 'Quito'), 
        (8, 'Asunción'), 
        (9, 'Montevideo'), 
        (10, 'Caracas');
    END
END;
GO



-----------------------------------------------------------------------
--Procedure for Airport
IF OBJECT_ID('InsertAirport', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertAirport;
END;
go
CREATE PROCEDURE InsertAirport
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Airport)
	begin
	INSERT INTO Airport (Name, City_id) VALUES 
	('Airport Viru Viru', 1), 
	('Airport Ezeiza', 2), 
	('Airport Arturo Merino Benítez', 3), 
	('Airport Galeão', 4), 
	('Airport Jorge Chávez', 5), 
	('Airport El Dorado', 6), 
	('Airport Mariscal Sucre', 7), 
	('Airport Silvio Pettirossi', 8), 
	('Airport Carrasco', 9), 
	('Airport de Maiquetía', 10);
	end
END;
GO

-----------------------------------------------------------------------
--Procedure for PlanelModel
IF OBJECT_ID('InsertPlanelModel', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertPlanelModel;
END;
go
CREATE PROCEDURE  InsertPlanelModel
AS
BEGIN
IF NOT EXISTS (SELECT 1 FROM Plane_Model)
	begin
	INSERT INTO Plane_Model (Description, Graphic) VALUES 
	('Boeing 737', 'Grafico1'), 
	('Airbus A320', 'Grafico2'), 
	('Boeing 777', 'Grafico3'), 
	('Airbus A380', 'Grafico4'), 
	('Embraer 190', 'Grafico5'), 
	('Boeing 747', 'Grafico6'), 
	('Airbus A330', 'Grafico7'), 
	('Cessna 172', 'Grafico8'), 
	('Bombardier CRJ200', 'Grafico9'), 
	('Boeing 787', 'Grafico10');
	end
END;
GO

-----------------------------------------------------------------------
--Procedure for State Airplane
IF OBJECT_ID('InsertStateAirplane','P') is not null
begin
	DROP PROCEDURE InsertStateAirplane
end;
go
CREATE PROCEDURE InsertStateAirplane
AS
BEGIN
IF NOT EXISTS (SELECT 1 FROM State_Airplane)
	begin
	INSERT INTO State_Airplane (name) VALUES
	('Active'),
	('Inactive'),
	('Maintenance')
end
END
go
-------------------------------------------------------------------
--Procedure for Airplane
IF OBJECT_ID('InsertAirplane', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertAirplane;
END;
go
CREATE PROCEDURE InsertAirplane
    @NumberOfRows INT -- Cantidad a insertar
AS
BEGIN
    DECLARE @i INT = 0;

    WHILE @i < @NumberOfRows
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION
            INSERT INTO Airplane (Registration_Number, Begin_of_Operation, Status_ID, Plane_Model_ID)
            SELECT 
                -- Generación de un número de registro aleatorio entre un rango (ej. 10000 y 99999)
                ABS(CHECKSUM(NEWID()) % 90000) + 10000 AS Registration_Number,
                -- Fecha de inicio de operación aleatoria en los últimos 10 años
                DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 3650), GETDATE()) AS Begin_of_Operation,
                -- Selección aleatoria de Status_ID
                (SELECT TOP 1 ID FROM State_Airplane ORDER BY NEWID()) AS Status_ID,
                -- Selección aleatoria de Plane_Model_ID de la tabla Plane_Model
                (SELECT TOP 1 ID FROM Plane_Model ORDER BY NEWID()) AS Plane_Model_ID;
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
			PRINT 'Error: ' + ERROR_MESSAGE();
        END CATCH;
        SET @i = @i + 1;
    END;
END;
GO



-----------------------------------------------------------------------
--Procedure for FlightNumbers
IF OBJECT_ID('InsertFlightNumbers', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertFlightNumbers;
END;
go
CREATE PROCEDURE InsertFlightNumbers
    @NumberOfRows INT -- Cantidad a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;     
        INSERT INTO Flight_Number (Departure_Time, Type, Airport_Start, Airport_Goal)
        SELECT 
            -- Hora de salida aleatoria entre las 00:00 y las 23:59
            CONVERT(TIME, DATEADD(MINUTE, ABS(CHECKSUM(NEWID()) % 1440), '00:00:00')) AS Departure_Time,
            -- Tipo aleatorio (0 o 1)
            ABS(CHECKSUM(NEWID()) % 2) AS Type,
            -- Aeropuerto de salida aleatorio
            (SELECT TOP 1 id FROM Airport ORDER BY NEWID()) AS Airport_Start,
            -- Aeropuerto de llegada aleatorio, asegurándose que no sea igual al de salida
            (SELECT TOP 1 id FROM Airport WHERE id <> (SELECT TOP 1 id FROM Airport ORDER BY NEWID()) ORDER BY NEWID()) AS Airport_Goal;
            -- Avión aleatorio (Plane_id) de la tabla Plane_Model
            --(SELECT TOP 1 id FROM Plane_Model ORDER BY NEWID()) AS Plane_id;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
		PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO




--=====================================================================
--Procedure for Seat
IF OBJECT_ID('InsertSeats', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertSeats;
END;
go
CREATE PROCEDURE  InsertSeats
    @NumberOfRows INT -- Cantidad a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;    
        INSERT INTO Seat (Size, Number, Location, Plane_Model_ID)
        SELECT 
            -- Estado aleatorio ('Small', 'Medium', 'Large')
            CASE ABS(CHECKSUM(NEWID()) % 3)
                WHEN 0 THEN 'Small'
                WHEN 1 THEN 'Medium'
                WHEN 2 THEN 'Large'
            END AS Size,
			-- Número aleatorio de asiento positivo
            ABS(CHECKSUM(NEWID()) % 1000) + 1 AS Number,
			-- Estado aleatorio ('Window', 'Aisle', 'Middle','Left','Right')
            CASE ABS(CHECKSUM(NEWID()) % 5)
                WHEN 0 THEN 'Window'
                WHEN 1 THEN 'Aisle'
                WHEN 2 THEN 'Middle'
				WHEN 3 THEN 'Left'
                WHEN 4 THEN 'Right'
            END AS Location,
            -- Selección aleatoria de Plane_Model_ID de la tabla Plane_Model
            (SELECT TOP 1 ID FROM Plane_Model ORDER BY NEWID()) AS Plane_Model_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO

--===================================================================
--Procedure for Airline
IF OBJECT_ID('InsertAirline', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertAirline;
END;
go
CREATE PROCEDURE InsertAirline
AS
BEGIN
   	INSERT INTO Airline (Name, Country_ID) VALUES 
	('Boliviana de Aviación (BoA)',1),
	('Aerolíneas Argentinas',2), 
	('Flybondi',2),
	('LATAM Airlines',3), 
    ('Sky Airline',3),
	('GOL Linhas Aéreas',4),
    ('Azul Brazilian Airlines',4),
	('LATAM Perú',5),
	('Sky Airline Perú',5),
    ('Avianca',6), 
    ('Viva Air Colombia',6),
	('Avianca Ecuador',7), 
	('LATAM Ecuador',7),
	('Paranair',8),
	('Amaszonas Uruguay',9),
	('Conviasa',10),
    ('Avior Airlines',10);

END;
GO

--===================================================================
IF OBJECT_ID('InsertFlights', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertFlights;
END;
GO

CREATE PROCEDURE InsertFlights
    @NumberOfRows INT -- Cantidad a insertar
AS
BEGIN
    DECLARE @i INT = 0;

    WHILE @i < @NumberOfRows
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;   

            -- Generar valores aleatorios y coherentes para el vuelo
            DECLARE @departureTime DATE = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365), CONVERT(DATE, GETDATE())); -- Fecha de salida
            DECLARE @departureHour TIME = CONVERT(TIME, DATEADD(MINUTE, ABS(CHECKSUM(NEWID()) % 1440), '00:00:00')); -- Hora de salida
            DECLARE @arrivalDate DATE = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 3), @departureTime); -- Fecha de llegada (posterior o igual a la de salida)
            DECLARE @arrivalHour TIME = 
                CASE 
                    WHEN @arrivalDate = @departureTime 
                    THEN DATEADD(MINUTE, ABS(CHECKSUM(NEWID()) % 1440), @departureHour) -- Asegurar coherencia el mismo día
                    ELSE CONVERT(TIME, DATEADD(MINUTE, ABS(CHECKSUM(NEWID()) % 1440), '00:00:00')) -- Hora aleatoria
                END;

            -- Insertar en la tabla Flight
            INSERT INTO Flight (Boarding_Time, Flight_Date, Gate, Check_In_Counter, departureTime, departureHour, arrivalDate, arrivalHour, FlightNumber, Flight_Number_ID, Plane_ID, Airline_ID)
            SELECT
                CONVERT(TIME, DATEADD(MINUTE, ABS(CHECKSUM(NEWID()) % 1440), '00:00:00')) AS Boarding_Time, -- Hora de abordaje
                @departureTime AS Flight_Date, -- Fecha de vuelo
                ABS(CHECKSUM(NEWID()) % 255) + 1 AS Gate, -- Puerta aleatoria
                ABS(CHECKSUM(NEWID()) % 2) AS Check_In_Counter, -- Check-in counter aleatorio
                @departureTime AS departureTime, -- Fecha de salida
                @departureHour AS departureHour, -- Hora de salida
                @arrivalDate AS arrivalDate, -- Fecha de llegada
                @arrivalHour AS arrivalHour, -- Hora de llegada
                ABS(CHECKSUM(NEWID()) % 9999) + 1 AS FlightNumber, -- Número de vuelo aleatorio
                (SELECT TOP 1 ID FROM Flight_Number ORDER BY NEWID()) AS Flight_Number_ID, -- ID de Flight_Number
                (SELECT TOP 1 ID FROM Plane_Model ORDER BY NEWID()) AS Plane_ID, -- ID de Plane_Model
                (SELECT TOP 1 ID FROM Airline ORDER BY NEWID()) AS Airline_ID; -- ID de Airline

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            PRINT 'Error: ' + ERROR_MESSAGE();
        END CATCH;
        SET @i = @i + 1;
    END;
END;
GO


--============================================================================
--Procedure for Available_Seat
IF OBJECT_ID('InsertAvailable_Seat', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertAvailable_Seat;
END;
go
CREATE PROCEDURE InsertAvailable_Seat
    @NumberOfRows INT -- Cantidad de registros a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;  
        -- Insertar en la tabla Type_Assigment
        INSERT INTO Available_Seat (Date,Time,Flight_ID, Seat_ID)
        SELECT
		 -- Fecha aleatoria en el futuro o el día actual
            DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365), CONVERT(DATE, GETDATE())) AS Date,
            -- Hora aleatoria entre las 00:00 y las 23:59
            CONVERT(TIME, DATEADD(MINUTE, ABS(CHECKSUM(NEWID()) % 1440), '00:00:00')) AS Time,
            -- Fecha aleatoria en el futuro o el día actual
           (SELECT TOP 1 ID FROM Flight ORDER BY NEWID()) AS Flight_ID ,
            -- ID del vuelo selecionado seleccionado
			(SELECT TOP 1 ID FROM Seat ORDER BY NEWID()) AS Seat_ID ;
         COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;           

        SET @i = @i + 1;
    END;
END;
GO

--=============================================================================
--Procedure for Passenger_Type
IF OBJECT_ID('InsertPassenger_Type', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertPassenger_Type;
END;
go
CREATE PROCEDURE InsertPassenger_Type
AS
BEGIN
if not exists (select 1 from Passenger_Type) 
begin
	INSERT INTO Passenger_Type(Name) VALUES
	('Regular Customer'),
	('VIP Customer'),
	('Economic Class Customer'),
	('Business Class Customer'),
	('First Class Customer'),
	('Frequent Customer');
end

END;
GO

--======================================================================
-- Crear el procedimiento para cargar datos desde el CSV
IF OBJECT_ID('LoadPersonDataFrom', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE LoadPersonDataFrom;
END;
go
CREATE PROCEDURE LoadPersonDataFrom
AS
BEGIN
    BEGIN TRY
        -- Check if the temporary table already exists
        IF OBJECT_ID('tempdb..TempPersonData') IS NULL
        BEGIN
            -- Create a temporary table to load data from the CSV file
            CREATE TABLE TempPersonData (
                Name VARCHAR(50),
                Phone VARCHAR(20),
                Email VARCHAR(50)
            );
            
            -- Load data from the CSV file into the temporary table
            BULK INSERT TempPersonData
            FROM 'C:\Temp\person.csv' -- Change the file path
            WITH (
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n',
                FIRSTROW = 2 -- Assumes the first row is the header
            );
        END
    END TRY
    BEGIN CATCH
        -- Handle any errors during execution
        PRINT 'Error occurred during BULK INSERT operation';
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
GO


--Procedure for Person

IF OBJECT_ID('InsertDataFromTempToPerson', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertDataFromTempToPerson;
END;
go
CREATE PROCEDURE InsertDataFromTempToPerson
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Person)
	begin
    -- Declarar variables para almacenar los datos temporales
    DECLARE @Name VARCHAR(50);
    DECLARE @Phone VARCHAR(20);
    DECLARE @Email VARCHAR(50);
    DECLARE @RandomType VARCHAR(15);
    DECLARE @PersonTypeID INT;

    -- Declarar el cursor para iterar sobre los datos de #TempPersonData
    DECLARE cur CURSOR FOR
    SELECT Name, Phone, Email FROM TempPersonData;  -- Asegúrate de que #TempPersonData tenga los datos correctos

    -- Abrir el cursor
    OPEN cur;
    FETCH NEXT FROM cur INTO @Name, @Phone, @Email;

    -- Iterar sobre cada fila obtenida por el cursor
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Seleccionar un valor aleatorio de la tabla @TypeList
		SET @RandomType = 
			CASE ABS(CHECKSUM(NEWID()) % 3)
			WHEN 0 THEN 'Crew Member'
			WHEN 1 THEN 'Passenger'--'Passenger'
			WHEN 2 THEN 'Customer'
		END;

		IF @RandomType IS NULL
		BEGIN
			-- Insertar los datos en la tabla Person
			INSERT INTO Person (Name, Phone, Email)
			VALUES (@Name, @Phone, @Email);
		END
		ELSE
		BEGIN
			-- Insertar los datos en la tabla Person
			INSERT INTO Person (Name, Phone, Email, Type)
			VALUES (@Name, @Phone, @Email, @RandomType);
		END  

        -- Pasar a la siguiente fila del cursor
        FETCH NEXT FROM cur INTO @Name, @Phone, @Email;
    END;

    -- Cerrar y liberar el cursor
    CLOSE cur;
    DEALLOCATE cur;
	end
END;
GO

--=============================================================================
--Procedure for Passenger
IF OBJECT_ID('InsertPassengers', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertPassengers;
END;
go
CREATE PROCEDURE InsertPassengers
    @NumberOfRows INT -- Cantidad de pasajeros a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;  
        -- Insertar en la tabla Passenger
        INSERT INTO Passenger (Number_Of_Flights, Person_ID,Passenger_Type_ID)
        SELECT 
            -- Número aleatorio de vuelos entre 0 y 100
            ABS(CHECKSUM(NEWID()) % 101) AS Number_Of_Flights,
            -- Persona aleatoria (Person_ID)
			(SELECT TOP 1 ID FROM Person ORDER BY NEWID()) AS Person_ID,
			 -- Tipo de asignación aleatorio (Type_Assigment_ID)
			(SELECT TOP 1 ID FROM Passenger_Type ORDER BY NEWID()) AS Passenger_Type_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO

--=============================================================================
--Procedure for Type Customer
IF OBJECT_ID('InsertTypeCustomer','P') is not null
begin
	DROP PROCEDURE InsertTypeCustomer
end;
go
CREATE PROCEDURE InsertTypeCustomer
AS
BEGIN
    -- Verifica si la tabla Type_Customer está vacía
    IF NOT EXISTS (SELECT 1 FROM Type_Customer)
    BEGIN
        -- Si está vacía, inserta los tipos de cliente
        INSERT INTO Type_Customer (name) VALUES
        ('Natural Customer'),
        ('Legal Customer');
    END
END;
GO


---------------------------------------------------------------------
--Procedure for Customer
IF OBJECT_ID('InsertCustomer', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertCustomer;
END;
go
CREATE PROCEDURE InsertCustomer
    @NumberOfRows INT -- Cantidad de pasajeros a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;    
        -- Insertar en la tabla Passenger
        INSERT INTO Customer (Loyalty_Points, Person_ID,TypeCustomer_ID)
        SELECT 
            -- Número aleatorio de vuelos entre 0 y 100
            ABS(CHECKSUM(NEWID()) % 100) AS Loyalty_Points,
            -- Persona aleatoria (Person_ID)
			(SELECT TOP 1 ID FROM Person ORDER BY NEWID()) AS Person_ID,
			-- Tipo de cliente aleatorio ('Natural Customer', 'Legal Customer')
			(SELECT TOP 1 ID FROM Type_Customer ORDER BY NEWID()) AS TypeCustomer_ID
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO


--=============================================================================
--Procedure for Crew_Member
IF OBJECT_ID('InsertCrew_Member', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertCrew_Member;
END;
go
CREATE PROCEDURE InsertCrew_Member
    @NumberOfRows INT -- Cantidad de pasajeros a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;    
        -- Insertar en la tabla Passenger
        INSERT INTO Crew_Member (Flying_Hours, Person_ID)
        SELECT 
            -- Número aleatorio de vuelos entre 0 y 100
            ABS(CHECKSUM(NEWID()) % 2000) AS Flying_Hours,
            -- Persona aleatoria (Person_ID)
			(SELECT TOP 1 ID FROM Person ORDER BY NEWID()) AS Person_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO
--============================================================================
--Procedure for Crew_Rol
IF OBJECT_ID('InsertCrew_Rol', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertCrew_Rol;
END;
go
CREATE PROCEDURE InsertCrew_Rol
AS
BEGIN
if not exists (select 1 from Crew_Rol) 
begin
	INSERT INTO Crew_Rol(Name) VALUES
	('Commander'),
	('Co-pilot'),
	('flight engineer'),
	('Security'),
	('Customer servicer'),
	('Emergencies');
end

END;
GO

--=============================================================================
--Procedure for Crew_Assigment
IF OBJECT_ID('InsertCrewAssignments', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertCrewAssignments;
END;
go
CREATE PROCEDURE InsertCrewAssignments
    @NumberOfRows INT -- Cantidad de asignaciones de tripulación a insertar
AS
BEGIN
    DECLARE @i INT = 0;
WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;     
        -- Insertar en la tabla Crew_Assigment
        INSERT INTO Crew_Assigment (Date, Crew_Rol_ID, Flight_ID, Crew_Member_ID)
        SELECT 
            -- Fecha aleatoria en los últimos 5 años
            DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 1825), GETDATE()) AS Date,
            -- Rol de tripulación aleatorio (Crew_Rol_ID)
			(SELECT TOP 1 ID FROM Crew_Rol ORDER BY NEWID()) AS Crew_Rol_ID ,
            -- Vuelo aleatorio (Flight_ID)
			(SELECT TOP 1 ID FROM Flight ORDER BY NEWID()) AS Flight_ID ,
            -- Miembro de la tripulación aleatorio (Crew_Member_ID)
			(SELECT TOP 1 ID FROM Crew_Member ORDER BY NEWID()) AS Crew_Member_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO

--=============================================================================

--Procedure for Frequent_Flyer_Card
IF OBJECT_ID('InsertFrequentFlyerCards', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertFrequentFlyerCards;
END;
go
CREATE PROCEDURE InsertFrequentFlyerCards
    @NumberOfRows INT -- Cantidad de tarjetas de pasajero frecuente a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;     
        -- Insertar en la tabla Frequent_Flyer_Card
        INSERT INTO Frequent_Flyer_Card (Miles, Meal_Code, Passenger_ID)
        SELECT 
            -- Millas aleatorias entre 100 y 8000
            ABS(CHECKSUM(NEWID()) % 7901) + 100 AS Miles,
            -- Código de comida aleatorio entre 1 y 10
            ABS(CHECKSUM(NEWID()) % 10) + 1 AS Meal_Code,
            -- Pasajero aleatorio (Passenger_ID)
			(SELECT TOP 1 ID FROM Passenger ORDER BY NEWID()) AS Passenger_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
		PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO

--=============================================================================
--Procedure for Flight_Cancellation
IF OBJECT_ID('InsertFlightCancellations', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertFlightCancellations;
END;
go
CREATE PROCEDURE InsertFlightCancellations
    @NumberOfRows INT -- Cantidad de cancelaciones de vuelo a insertar
AS
BEGIN
   DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN	
    BEGIN TRY
        BEGIN TRANSACTION;        
        -- Insertar en la tabla Flight_Cancellation
        INSERT INTO Flight_Cancellation (Reason, NewDepartureDate, Flight_ID)
        SELECT 
            -- Razón aleatoria con al menos 16 caracteres
            CASE ABS(CHECKSUM(NEWID()) % 5)
                WHEN 0 THEN 'Adverse weather conditions' --Condiciones meteorológicas adversas'
                WHEN 1 THEN 'Technical problems' --Problemas de salud'
                WHEN 2 THEN 'Lack of crew' --falta de tripulacion
                WHEN 3 THEN 'Operational problems'
                WHEN 4 THEN 'Security issues' --problemas de seguridad
            END AS Reason,
            -- Nueva fecha de salida aleatoria en los próximos 30 días
            DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 31), GETDATE()) AS NewDepartureDate,
            -- Vuelo aleatorio (Flight_ID)
            (SELECT TOP 1 ID FROM Flight ORDER BY NEWID()) AS Flight_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
    SET @i = @i + 1;
END;
END;
GO

--=============================================================================
--Procedure for Flight_Reprograming
IF OBJECT_ID('InsertFlightReprogramings', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertFlightReprogramings;
END;
go
CREATE PROCEDURE InsertFlightReprogramings
    @NumberOfRows INT -- Cantidad de reprogramaciones de vuelo a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < 30--@NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;   
        -- Insertar en la tabla Flight_Reprograming
        INSERT INTO Flight_Reprograming (NewDepartureDate, NewDepartureTime, Flight_ID)
        SELECT 
            -- Nueva fecha de salida aleatoria en los próximos 30 días
            DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 31), GETDATE()) AS NewDepartureDate,
            -- Nueva hora de salida aleatoria entre las 00:00 y las 23:59
            CONVERT(TIME, DATEADD(MINUTE, ABS(CHECKSUM(NEWID()) % 1440), '00:00:00')) AS NewDepartureTime,
            -- Cancelación de vuelo aleatoria (Flight_Cancellation_ID)
			(SELECT TOP 1 ID FROM Flight ORDER BY NEWID()) AS Flight_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO

--=============================================================================
--Procedure for Payment_Type
IF OBJECT_ID('InsertPayment_Type', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertPayment_Type;
END;
go
CREATE PROCEDURE InsertPayment_Type
AS
BEGIN
if not exists (select 1 from Payment_Type) 
begin
	INSERT INTO Payment_Type(Name) VALUES
	('Credit and debit cards'),
	('Cash'),
	('PayPal'),
	('Online banking');
end

END;
GO

--=============================================================================
IF OBJECT_ID('InsertCurrency', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertCurrency;
END;
go
CREATE PROCEDURE InsertCurrency
AS
BEGIN
if not exists (select 1 from Currency) 
begin
	INSERT INTO Currency(code) VALUES
	('Bs'),
	('USD')
end

END;
GO
-------------------------------------------------------------
--Procedure for Payment
IF OBJECT_ID('InsertPayments', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertPayments;
END;
go
CREATE PROCEDURE InsertPayments
    @NumberOfRows INT -- Cantidad de pagos a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;   
        -- Insertar en la tabla Payment
        INSERT INTO Payment (Currency_ID, Amount, Date, Payment_Type_ID)
        SELECT 
            -- Moneda aleatoria (Bs o USD)
			(SELECT TOP 1 ID FROM Currency ORDER BY NEWID()) AS Currency_ID,
            -- Monto aleatorio entre 1 y 10000
            ABS(CHECKSUM(NEWID()) % 10000) + 1 AS Amount,
            -- Fecha aleatoria en los últimos 365 días
            DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 365), GETDATE()) AS Date,
            -- Tipo de pago aleatorio (Payment_Type_ID)
			(SELECT TOP 1 ID FROM Payment_Type ORDER BY NEWID()) AS Payment_Type_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO

--=============================================================================
--Procedure for Document_Type
IF OBJECT_ID('InsertDocument_Type', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertDocument_Type;
END;
go
CREATE PROCEDURE InsertDocument_Type
AS
BEGIN
if not exists (select 1 from Document_Type) 
begin
	INSERT INTO Document_Type (Name) VALUES 
	('Pasaporte'), 
	('Licencia de Conducir'), 
	('DNI'),  
	('Visa'), 
	('ID Militar'), 
	('Carnet Universitario'), 
	('Certificado de Nacimiento');
end

END;
GO
--=============================================================================
--Procedure for Document
IF OBJECT_ID('InsertDocuments', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertDocuments;
END;
go
CREATE PROCEDURE InsertDocuments
    @NumberOfRows INT -- Cantidad de documentos a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; 
        -- Insertar en la tabla Document
        INSERT INTO Document (Date_of_Issue, Valid_Date, Document_Type_ID, Country_ID)
        SELECT 
            -- Fecha de emisión aleatoria en los últimos 5 años
            DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 1825), GETDATE()) AS Date_of_Issue,
            -- Fecha de validez aleatoria dentro de los próximos 10 años
            DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 3650), GETDATE()) AS Valid_Date,
            -- Tipo de documento aleatorio (Document_Type_ID)
			(SELECT TOP 1 ID FROM Document_Type ORDER BY NEWID()) AS Document_Type_ID,
            -- País aleatorio (Country_ID)
			(SELECT TOP 1 ID FROM Country ORDER BY NEWID()) AS Country_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO

--=============================================================================
--Procedure for Category
IF OBJECT_ID('InsertCategory', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertCategory;
END;
go
CREATE PROCEDURE InsertCategory
AS
BEGIN
if not exists (select 1 from Category) 
begin
	INSERT INTO Category (Name, price) VALUES 
	('Economic', 300),
	('Business', 350),
	('First Class', 400),
	('Premium Economic', 450);
end

END;
GO
--=============================================================================
--Procedure for Ticket
IF OBJECT_ID('InsertTickets', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertTickets;
END;
go
CREATE PROCEDURE InsertTickets
    @NumberOfRows INT -- Cantidad de tickets a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; 
        -- Insertar en la tabla Ticket
        INSERT INTO Ticket (Number, Date_Ticket, Category_id, Document_ID, Passenger_ID)
        SELECT 
            -- Número aleatorio mayor a 0
            ABS(CHECKSUM(NEWID()) % 100000) + 1 AS Number,
			DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365), CONVERT(DATE, GETDATE())) AS Date_Ticket,
            -- Categoría aleatoria (Category_id)
			(SELECT TOP 1 ID FROM Category ORDER BY NEWID()) AS Category_id,
			-- Documento (Document_ID)
			(SELECT TOP 1 ID FROM Document ORDER BY NEWID()) AS Document_ID,
			-- Pasajero aleatorio (Passenger_ID)
            (SELECT TOP 1 ID FROM Passenger ORDER BY NEWID()) AS Passenger_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO

--=============================================================================
--Procedure for Reserve
IF OBJECT_ID('InsertReserves', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertReserves;
END;
go
CREATE PROCEDURE InsertReserves
    @NumberOfRows INT -- Cantidad de reservas a insertar
AS
BEGIN
    DECLARE @i INT = 0;

    WHILE @i < @NumberOfRows
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            -- Generar una cantidad de tickets aleatoria entre 1 y 5 para esta reserva
            DECLARE @TicketCount INT = ABS(CHECKSUM(NEWID()) % 5) + 1;

            -- Insertar en la tabla Reserve
            INSERT INTO Reserve (State, Reservation_Date, TicketCount, Customer_ID, Payment_ID, Ticketing_Code)
            SELECT
                -- Estado aleatorio (0 o 1)
                ABS(CHECKSUM(NEWID()) % 2),
                -- Fecha de reserva aleatoria en los últimos 30 días
                DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 30), GETDATE()),
                -- Cantidad de tickets generada
                @TicketCount,
                -- Cliente aleatorio
                (SELECT TOP 1 ID FROM Customer ORDER BY NEWID()) AS Customer_ID,
                -- Pago aleatorio
                (SELECT TOP 1 ID FROM Payment ORDER BY NEWID()) AS Payment_ID,
                -- Código de ticket aleatorio
                (SELECT TOP 1 Ticketing_Code FROM Ticket ORDER BY NEWID()) AS Ticketing_Code;

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            PRINT 'Error: ' + ERROR_MESSAGE();
        END CATCH;

        SET @i = @i + 1;
    END;
END;
GO


--=============================================================================
--Procedure for Confirmation
/*IF OBJECT_ID('InsertConfirmation', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertConfirmation;
END;
go
CREATE PROCEDURE InsertConfirmation
    @NumberOfRows INT -- Cantidad de reservas a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;  
        -- Insertar en la tabla Reserve
        INSERT INTO Confirmation (Date, Reserve_ID)
		SELECT
                -- Fecha de confimacion aleatoria en los últimos 30 días
                DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 30), GETDATE()),
                -- reserva aleatoria
  				(SELECT TOP 1 ID FROM Reserve ORDER BY NEWID()) AS Reserve_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;     
        SET @i = @i + 1;
    END;
END;
GO*/
--==========================================================================
--Procedure for Cancellation
/*IF OBJECT_ID('InsertCancellations', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertCancellations;
END;
go
CREATE PROCEDURE InsertCancellations
    @NumberOfRows INT -- Cantidad de cancelaciones a insertar
AS
BEGIN
    -- Declarar variables
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;  
            -- Insertar en la tabla Cancellation
            INSERT INTO Cancellation (Reason, Cancellation_Date, Penalty, Reserve_ID)
            SELECT
                -- Razón aleatoria de al menos 6 caracteres
                CASE ABS(CHECKSUM(NEWID()) % 6)
                    WHEN 0 THEN 'Health problems' --Problemas de salud
                    WHEN 1 THEN 'Changes at work' --Cambios en el trabajo
                    WHEN 2 THEN 'Family emergencies' --Emergencias familiares
                    WHEN 3 THEN 'Financial problems' --Problemas financieros
                    WHEN 4 THEN 'Change of plans' --Cambio de planes
                    WHEN 5 THEN 'Incomplete documentation' --Documentación incompleta
                END AS Reason,
                -- Fecha de cancelación aleatoria dentro de los últimos 30 días
                DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 30), GETDATE()) AS Cancellation_Date,
                -- Penalidad aleatoria entre 100 y 500
                ABS(CHECKSUM(NEWID()) % 401) + 100 AS Penalty,
                (SELECT TOP 1 ID FROM Reserve ORDER BY NEWID()) AS Reserve_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
            SET @i = @i + 1;
	END;
END;
GO
*/

--=============================================================================
--Procedure for Coupon
IF OBJECT_ID('InsertCoupons', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertCoupons;
END;
go
CREATE PROCEDURE InsertCoupons
    @NumberOfRows INT -- Cantidad de cupones a insertar
AS
BEGIN
    DECLARE @i INT = 0;

    WHILE @i < @NumberOfRows
    BEGIN
	    BEGIN TRY
        BEGIN TRANSACTION;  
        -- Insertar en la tabla Coupon
        INSERT INTO Coupon (Date_of_Redemption, Class, Standby, Meal_Code, Ticketing_Code, Flight_ID)
        SELECT
            -- Fecha de redención aleatoria en los próximos 30 días
            DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 30), GETDATE()),
            -- Clase aleatoria
            CASE ABS(CHECKSUM(NEWID()) % 4)
                WHEN 0 THEN 'Economic'
                WHEN 1 THEN 'Premium Economic'
                WHEN 2 THEN 'Business'
                ELSE 'First Class'
            END AS Class,
            -- Estado de standby aleatorio
            CASE ABS(CHECKSUM(NEWID()) % 2)
                WHEN 0 THEN 'Confirmed'
                ELSE 'Waiting'
            END AS Standby,
            -- Código de comida aleatorio entre 1 y 10
            ABS(CHECKSUM(NEWID()) % 10) + 1,
			-- Seleccionar un código de ticket aleatorio
			(SELECT TOP 1 Ticketing_Code FROM Ticket ORDER BY NEWID()) AS Ticketing_Code,
		    -- Seleccionar un vuelo aleatorio
			(SELECT TOP 1 ID FROM Flight ORDER BY NEWID()) AS Flight_ID;
         COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;       
        SET @i = @i + 1;
    END;
END;
GO

--=============================================================================
--Procedure for Boarding_Pass
IF OBJECT_ID('InsertBoardingPasses', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertBoardingPasses;
END;
go
CREATE PROCEDURE InsertBoardingPasses
    @NumberOfRows INT -- Cantidad de pases de abordar a insertar
AS
BEGIN
    DECLARE @i INT = 0;

 WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;  
        -- Insertar en la tabla Boarding_Pass
        INSERT INTO Boarding_Pass (Gate, Coupon_ID)
		SELECT
            -- Número de puerta aleatorio entre 1 y 50
            ABS(CHECKSUM(NEWID()) % 50) + 1 AS Gate,
            -- Cupón aleatorio
			(SELECT TOP 1 ID FROM Coupon ORDER BY NEWID()) AS Coupon_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO

--=============================================================================
--Procedure for Pieces_of_Luggage

IF OBJECT_ID('InsertPiecesOfLuggage', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertPiecesOfLuggage;
END;
GO
CREATE PROCEDURE InsertPiecesOfLuggage
    @NumberOfRows INT -- Cantidad de registros a insertar
AS
BEGIN
    DECLARE @i INT = 0;

    WHILE @i < @NumberOfRows
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION; 
            -- Insertar en la tabla Pieces_of_Luggage
            INSERT INTO Pieces_of_Luggage (Number, Weight, Length, Width, Height, BaggageType, ExtraWeight, Price, Handling_cost, Coupon_ID)
            SELECT
                -- Número de piezas de equipaje aleatorio entre 1 y 5
                ABS(CHECKSUM(NEWID()) % 5) + 1 AS Number,
                -- Peso aleatorio entre 0 y 50
                CAST(ABS(CHECKSUM(NEWID()) % 50) + (RAND() * 0.99) AS DECIMAL(5, 2)) AS Weight,
                -- Largo aleatorio entre 30 y 100 cm
                CAST(ABS(CHECKSUM(NEWID()) % 70) + 30 AS DECIMAL(5, 2)) AS Length,
                -- Ancho aleatorio entre 20 y 70 cm
                CAST(ABS(CHECKSUM(NEWID()) % 50) + 20 AS DECIMAL(5, 2)) AS Width,
                -- Alto aleatorio entre 10 y 50 cm
                CAST(ABS(CHECKSUM(NEWID()) % 40) + 10 AS DECIMAL(5, 2)) AS Height,
                -- Tipo de equipaje aleatorio
                CASE ABS(CHECKSUM(NEWID()) % 3)
                    WHEN 0 THEN 'Maleta'
                    WHEN 1 THEN 'Bolsa de mano'
                    ELSE 'Equipaje Deportivo'
                END AS BaggageType,
                -- Peso extra aleatorio entre 0 y 10
                CAST(ABS(CHECKSUM(NEWID()) % 11) AS DECIMAL(5, 2)) AS ExtraWeight,
                -- Precio aleatorio entre 5 y 100
                CAST(ABS(CHECKSUM(NEWID()) % 96) + 5 AS DECIMAL(5, 2)) AS Price,
                -- Costo de manejo aleatorio entre 1 y 20
                CAST(ABS(CHECKSUM(NEWID()) % 20) + 1 AS DECIMAL(5, 2)) AS Handling_cost,
                -- Cupón aleatorio
                (SELECT TOP 1 ID FROM Coupon ORDER BY NEWID()) AS Coupon_ID;
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
        END CATCH;
        SET @i = @i + 1;
    END;
END;
GO
--=============================================================================
--Procedure for Baggage_Check_In
IF OBJECT_ID('InsertBaggageCheckIns', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertBaggageCheckIns;
END;
go
CREATE PROCEDURE InsertBaggageCheckIns
    @NumberOfRows INT -- Cantidad de registros a insertar
AS
BEGIN
    DECLARE @i INT = 0;

WHILE @i < @NumberOfRows
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION; 
        -- Insertar en la tabla Baggage_Check_In
        INSERT INTO Baggage_Check_In (Prohibited_Item, Weight, Pieces_of_Luggage_ID)
        SELECT
            -- Artículo prohibido aleatorio (0 o 1)
            ABS(CHECKSUM(NEWID()) % 2) AS Prohibited_Item,
            -- Peso aleatorio entre 0 y 50
            CAST(ABS(CHECKSUM(NEWID()) % 50) + (RAND() * 0.99) AS DECIMAL(5, 2)) AS Weight,
            -- ID de piezas de equipaje aleatorio
            (SELECT TOP 1 ID FROM Pieces_of_Luggage ORDER BY NEWID()) AS Pieces_of_Luggage_ID;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO

--=============================================================================
--Procedure for Check_In
IF OBJECT_ID('InsertCheck_In', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE InsertCheck_In;
END;
go
CREATE PROCEDURE InsertCheck_In
    @NumberOfRows INT -- Cantidad de registros a insertar
AS
BEGIN
    DECLARE @i INT = 0;

    WHILE @i < @NumberOfRows
    BEGIN
	    BEGIN TRY
        BEGIN TRANSACTION;   
        -- Insertar en la tabla Available_Seat_Coupon
        INSERT INTO Check_In (Coupon_id, Available_Seat_id)
        SELECT
            -- Cupón aleatorio
            (SELECT TOP 1 ID FROM Coupon ORDER BY NEWID()) AS Coupon_id,
            -- Asiento disponible aleatorio
            (SELECT TOP 1 ID FROM Available_Seat ORDER BY NEWID()) AS Available_Seat_id;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH;
        SET @i = @i + 1;
    END;
END;
GO
