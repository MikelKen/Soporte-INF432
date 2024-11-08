use master;

create database martFlight;
use martFlight;

---------------------------------------------

create table dimTime(
	id int primary key identity,
	fecha date,
	year int,
	month varchar(50),
	day varchar(50),
);

--dimAirline
create table dimAirline(
	id int primary key identity,
	id_airline int,
	name VARCHAR(100)
);

--dimModelPlane
create table dimModelPlane(
	id int primary key identity,
	id_modelPlane int,
	description VARCHAR(60),
	graphic VARCHAR(50)
);
--select 
-- dimAirport
create table dimAirport(
	id int primary key identity,
	id_airport int,
	name VARCHAR(100),
	city VARCHAR(30),
	country VARCHAR(30),
);

-- dimStatusFlight
CREATE TABLE dimFlightStatus (
		id int PRIMARY KEY identity,
        statusName VARCHAR(20) NOT NULL -- 'Confirmado' o 'Cancelado'
);
	

--factFlight
create table factFlight(
	id int primary key identity,
	time_id int,
	airline_id int,
	model_plane int,
	airport_id int,
	status_id int,
	CantVueloConfirm int,
	CantVueloCancelled int,
	foreign key (time_id) references dimTime(id),
	foreign key (airline_id) references dimAirline(id),
	foreign key (model_plane) references dimModelPlane(id), 
	foreign key (airport_id) references dimAirport(id),
	foreign key (status_id) references dimFlightStatus(id)
);




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
