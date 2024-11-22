create database examen
use examen 



---------------------------------------------------------------------

if object_id('Country','U') is null
begin
	create table Country(
		ID int identity(1,1) primary key not null,
		Name varchar(30) not null,
	);
end
go

---------------------------------------------------------------------

if object_id('City', 'U') is null
begin
    create table City(
        ID int identity(1,1) primary key,
        Country_ID int not null,
        Name varchar(30) not null unique,
        foreign key (Country_ID) references Country(ID) 
    );
end
go

---------------------------------------------------------------------

if object_id('Airport', 'U') is null
begin
    create table Airport(
        ID int identity(1,1) primary key,
        Name varchar(100) not null unique check (len(Name) > 2),
        City_ID int not null,
        foreign key (City_ID) references City(ID)
    );
end
go

---------------------------------------------------------------------

if object_id('Plane_Model', 'U') is null
begin
    create table Plane_Model(
        ID int identity(1,1) primary key,
        Description varchar(60) not null check (len(Description) > 4),
        Graphic varchar(50) not null check (len(Graphic) > 4)
    );
end
go

---------------------------------------------------------------------

if object_id('Airplane', 'U') is null
begin
    create table Airplane(
		id int identity (1,1) primary key,
        Registration_Number int not null,
        Begin_of_Operation date not null check (Begin_of_Operation <= GETDATE()),
      --  Status_ID integer not null,-- varchar(15) Default 'Active' not null check (Status IN ('Active', 'Inactive', 'Maintenance')),
        Plane_Model_ID int null,
        foreign key (Plane_Model_ID) references Plane_Model(ID),
		--foreign key (Status_ID) references State_Airplane(ID)
    );
end
go

--------------------------------------------------------------

if object_id('Flight_Number', 'U') is null
begin
    create table Flight_Number(
        id int identity(1,1) primary key,
        Departure_Time time(0) not null,
        Type bit not null,
        Airport_Start int not null,
        Airport_Goal int not null,
        foreign key (Airport_Start) references Airport(id) ON DELETE NO ACTION,
        foreign key (Airport_Goal) references Airport(id) ON DELETE NO ACTION,
        CONSTRAINT Check_Airport check (Airport_Start <> Airport_Goal)
    );
end
go

---------------------------------------------------------------------

if object_id('Airline', 'U') is null
begin
    create table Airline(
        ID int identity(1,1) primary key,
        Name varchar(100) not null check (len(Name) > 5),
		Country_ID int not null,
		foreign key (Country_ID) references Country(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Flight', 'U') is null
begin
    create table Flight(
        ID int identity(1,1) primary key,
        Boarding_Time time(0) not null,
		FlightNumber int not null,
        Flight_Date date not null check (Flight_Date >= CONVERT(DATE, GETDATE())),
        Gate tinyint not null check (Gate BETWEEN 1 AND 255),
        Check_In_Counter bit not null,
        departureTime date not null,  --fecha de salida
		departureHour time(0) not null,  --hora de salida
		arrivalDate date not null,	--fecha de llegada
		arrivalHour time(0) not null,
        Flight_Number_id int not null,
        Plane_ID int not null,
        Airline_ID int not null,
        foreign key (Flight_Number_ID) references Flight_Number(ID) ON DELETE NO ACTION,
        foreign key (Plane_ID) references Plane_Model(ID) ON DELETE NO ACTION,
        foreign key (Airline_ID) references Airline(ID) ON DELETE NO ACTION
    );
end
go
------------------------------------------------------------------------------------

if object_id('Person', 'U') is null
begin
    create table Person(
        ID int identity(1,1) primary key,
        Name varchar(50) not null unique check (len(Name) > 5),
		Phone varchar(20) not null,
		Email varchar(50) not null check (len(Email) > 10),
		Type varchar(50)  default 'Passenger' not null check (
            Type like '%Passenger%' or 
            Type like '%Crew Member%' or 
            Type like '%Customer%' or
			Type is null
        )
    );
end
go

---------------------------------------------------------------------


if object_id('Crew_Member', 'U') is null
begin
    create table Crew_Member(
        ID int identity(1,1) primary key,
        Flying_Hours int not null,
		Type varchar(50) not null default 'Crew Member' check ( Type in('Crew Member')),
		Person_ID int not null,
		foreign key (Person_ID) references Person(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Crew_Rol', 'U') is null
begin
    create table Crew_Rol(
        ID int identity(1,1) primary key,
        Name varchar(30) not null check (len(Name) > 5),
    );
end
go

---------------------------------------------------------------------

if object_id('Crew_Assigment', 'U') is null
begin
    create table Crew_Assigment(
        ID int identity(1,1) primary key,
		Date date not null,
		Crew_Rol_ID int not null,
		Flight_ID int not null,
		Crew_Member_ID int not null,
		foreign key (Crew_Rol_ID) references Crew_Rol(ID) ON DELETE NO ACTION,
		foreign key (Flight_ID) references Flight(ID) ON DELETE NO ACTION,
		foreign key (Crew_Member_ID) references Crew_Member(ID) ON DELETE NO ACTION,
    );
end
go

SELECT * FROM Flight

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



EXEC InsertFlights @NumberOfRows = 10;
