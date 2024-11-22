select * from Flight

use master;

create database martFlightPrueba;
use martFlightPrueba;

---------------------------------------------

create table dimTime(
	id int primary key identity,

	FlightDate date,
	Year int,
	Month int,
	MonthName varchar(50),
	Day int,	
	DayName varchar(50),
	Week int,
	Quarter int,
);

select * from dimTime
--dimAirline
create table dimAirline(
	id int primary key identity,
	id_airline int,
	name VARCHAR(100)
);
select * from dimAirline

--dimModelPlane
create table dimModelPlane( --avion
	id int primary key identity,
	id_modelPlane int,
	description VARCHAR(60),
	graphic VARCHAR(50)
);

select * from dimModelPlane
--select 
-- dimAirport
create table dimAirport(
	id int primary key identity,
	id_flightNum int,
	departureTime Time(0),
	aeroExit VARCHAR(100),   --aeropuerto de salida
	aeroArrival VARCHAR(100), --aeropuesto de llegada
	cityExit VARCHAR(50),
	cityArrival VARCHAR(50),
	countryExit VARCHAR(50),
	countryArrival VARCHAR(50),
);
select * from dimAirport

--crew role
CREATE TABLE dimCrewRole (
	id int primary key identity(1,1),
	crew_id int,
	fligth_id int,
	name varchar(30),	
);
select * from dimCrewRole

select * from dimAirport
--factFlight
create table factFlight(
	id int primary key identity(1,1),
	time_id int,
	airline_id int,
	modelPlane_id int,
	airport_id int,
	crewRole_id int,
	flight_number int,
	flight_date date,
	departureTime date,
	departureHour time(0),
	arrivalDate date,
	arrivalHour time(0),
	flight_duration_hour time(0),
	total_minutes decimal(10,2),--flight_duration_by_time
	total_hours decimal(10,2),
	foreign key (time_id) references dimTime(id),
	foreign key (airline_id) references dimAirline(id),
	foreign key (modelPlane_id) references dimModelPlane(id), 
	foreign key (airport_id) references dimAirport(id),
	foreign key (crewRole_id) references dimCrewRole(id)
);

select * from factFlight