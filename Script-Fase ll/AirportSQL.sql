--ESTUDIANTE: VINO APAZA VANESA
--REGISTRO: 220053243

if db_id('AirportSoport') is null
begin
	create database AirportSoport;
end
go

Use AirportSoport;
go

if OBJECT_ID(N'[dbo].[Country]', 'U') IS NULL
begin
	Create table Country 
   (
	Id INT primary key identity(1,1),
	Namee VARCHAR(30) not null
   )
end
go


if OBJECT_ID(N'[dbo].[City]', 'U') IS NULL
begin
	Create table City
	(
	Id INT primary key identity (1,1),
	Namee VARCHAR(30) not null,
	Id_Country INT not null,
	foreign key (Id_Country) references Country(Id)
	)
end
go


if OBJECT_ID(N'[dbo].[Customer]', 'U') IS NULL
begin
	Create table Customer
	(
		Ci INT primary key,
		Date_of_Birth date not null,
		Namee Varchar(20)  not null
	)
end
go


if OBJECT_ID(N'[dbo].[Pasaport]', 'U') IS NULL
begin
	Create table Pasaport
	(
	Pasoport_Number INT primary key,
	Country_of_issue INT,
	expiration_date DATE not null,
	Issue_Date DATE not null,
	Ci_Custumer INT not null,
	foreign key (Ci_Custumer) references Customer(Ci)
	)
end
go

if OBJECT_ID(N'[dbo].[FrequentFiyerCard]', 'U') IS NULL
begin
	Create table FrequentFiyerCard
	(
	FFC_Number INT primary key,
	Miles INT not null,
	Meal_Code VARCHAR(10) not null,
	Ci_Customer INT not null,
	foreign key (Ci_Customer) references Customer(Ci)
	)
end
go



if OBJECT_ID(N'[dbo].[Ticket]', 'U') IS NULL
begin
	Create table Ticket
	(
	Ticketing_Code INT primary key,
	Number INT not null,
	Ci_Customer INT not null,
	foreign key (Ci_Customer) references Customer(Ci)
	)
end
go



if OBJECT_ID(N'[dbo].[Airport]', 'U') IS NULL
begin
	Create table Airport
	(
	Id INT primary key identity(1,1),
	Namee VARCHAR (50) not null,
	Id_City INT not null,
	foreign key (Id_City) references City(Id)
	)
end
go




if OBJECT_ID(N'[dbo].[PlaneModel]', 'U') IS NULL
begin
	Create table PlaneModel
	(
	Id INT primary key identity(1,1),
	Descriptionn VARCHAR(50) not null,
	Graphic VARCHAR(50) not null
	)

end
go


if OBJECT_ID(N'[dbo].[Airplane]', 'U') IS NULL
begin
	Create table Airplane
	(
	Registration_Number INT primary key,
	Begin_of_Number DATE not null,
	Statuss VARCHAR(50) not null,
	Id_PlaneModel INT not null,
	foreign key (Id_PlaneModel) references PlaneModel(Id)
	)
end
go



if OBJECT_ID(N'[dbo].[FlightNumber]', 'U') IS NULL
begin
	Create table FlightNumber
	(
	Id INT primary key identity(1,1),
	Departure_Time TIME not null,
	Typee VARCHAR(50) not null,
	Airline VARCHAR(100) not null,
	Id_Start INT not null,
	Id_Goal INT not null,
	Id_Category INT not null,
	foreign key (Id_Start) references Airport(Id), 
	foreign key (Id_Goal) references Airport(Id)
	)
end
go

if OBJECT_ID(N'[dbo].[Category]', 'U') IS NULL
begin 
	Create table Category 
	(
	Id INT primary key identity(1,1),
	Namee VARCHAR(30) NOT NULL
	)
end
go



if OBJECT_ID(N'[dbo].[Flight]', 'U') IS NULL
begin
	Create table Flight
	(
	Id INT primary key identity(1,1),
	Boarding_Time TIME not null,
	Flight_Date DATE not null,
	Gate INT not null,
	Check_in_Counter VARCHAR(20) not null,
	Id_FlightNumber INT not null,
	Id_Category INT not null,
	foreign key (Id_FlightNumber) references FlightNumber (Id),
	foreign key (Id_Category) references Category(Id)
	)
end
go



if OBJECT_ID(N'[dbo].[Seat]', 'U') IS NULL
begin
	Create table Seat
	(
	Id INT primary key identity(1,1),
	Size INT not null,
	Number INT not null,
	Locationn VARCHAR(50) not null,
	Id_PlaneModel INT not null,
	foreign key (Id_PlaneModel) references PlaneModel(Id)
	)

end
go


if OBJECT_ID(N'[dbo].[AvailableSeat]', 'U') IS NULL
begin
	Create table AvailableSeat
	(
	Id INT primary key identity(1,1),
	Id_Fligth INT not null,
	Id_Seat INT not null,
	foreign key (Id_Fligth) references Flight(Id),
	foreign key (Id_Seat) references Seat(Id)
	)
end
go


if OBJECT_ID(N'[dbo].[Coupon]', 'U') IS NULL
begin
	Create table Coupon
	(
	Id INT primary key identity(1,1),
	Date_of_Redemption DATE not null,
	Class VARCHAR(20) not null,
	Standbyy CHAR(2) not null,
	Meal_Code VARCHAR(5) not null,
	Id_Ticket INT not null,
	Id_Flight INT not null,
	Id_Available INT, 
	foreign key (Id_Ticket) references Ticket(Ticketing_Code),
	foreign key (Id_Flight) references Flight(Id),
	foreign key (Id_Available) references AvailableSeat(Id)
	)
end
go

if OBJECT_ID(N'[dbo].[PiecesOfLuggage]', 'U') IS NULL
begin
	Create table PiecesOfLuggage
	(
	Number INT primary key identity(1,1),
	Weightt DECIMAL not null,
	Id_Coupon INT not null,
	foreign key (Id_Coupon) references Coupon(Id)
	)
end
go

-- POBLACIÓN DE DATOS

-- Country
INSERT INTO Country (Namee) VALUES
('USA'),
('Canada'),
('Mexico'),
('Brazil'),
('Argentina'),
('Spain'),
('France'),
('Germany'),
('Japan'),
('Australia');

--City
INSERT INTO City (Namee, Id_Country) VALUES
('New York', 1),
('Toronto', 2),
('Mexico City', 3),
('Rio de Janeiro', 4),
('Buenos Aires', 5),
('Madrid', 6),
('Paris', 7),
('Berlin', 8),
('Tokyo', 9),
('Sydney', 10);


--Customer
INSERT INTO Customer (Ci, Date_of_Birth, Namee) VALUES
(1001, '1980-05-15', 'John Doe'),
(1002, '1985-09-22', 'Jane Smith'),
(1003, '1990-12-10', 'Carlos Garcia'),
(1004, '1975-03-05', 'Maria Hernandez'),
(1005, '1988-07-30', 'David Brown'),
(1006, '1992-11-18', 'Emily Suarez'),
(1007, '1970-01-25', 'Michael Born'),
(1008, '1995-04-09', 'Laura Garcia'),
(1009, '1982-06-21', 'Robert Kitmeru'),
(1010, '1998-08-14', 'Sophia Perez');

--Pasaport
INSERT INTO Pasaport (Pasoport_Number, Country_of_issue, expiration_date, Issue_Date, Ci_Custumer) VALUES
(5001, 1, '2030-05-15', '2020-05-15', 1001),
(5002, 2, '2031-09-22', '2021-09-22', 1002),
(5003, 3, '2032-12-10', '2022-12-10', 1003),
(5004, 4, '2029-03-05', '2019-03-05', 1004),
(5005, 5, '2033-07-30', '2023-07-30', 1005),
(5006, 6, '2028-11-18', '2018-11-18', 1006),
(5007, 7, '2027-01-25', '2017-01-25', 1007),
(5008, 8, '2034-04-09', '2024-04-09', 1008),
(5009, 9, '2026-06-21', '2016-06-21', 1009),
(5010, 10, '2035-08-14', '2025-08-14', 1010);


--FrequentFiyerCard
INSERT INTO FrequentFiyerCard (FFC_Number, Miles, Meal_Code, Ci_Customer) VALUES
(4001, 50000, 'VEG', 1001),
(4002, 35000, 'NON', 1002),
(4003, 20000, 'VEG', 1003),
(4004, 45000, 'NON', 1004),
(4005, 55000, 'VEG', 1005),
(4006, 60000, 'NON', 1006),
(4007, 70000, 'VEG', 1007),
(4008, 25000, 'NON', 1008),
(4009, 80000, 'VEG', 1009),
(4010, 65000, 'NON', 1010);


-- Ticket
INSERT INTO Ticket (Ticketing_Code, Number, Ci_Customer) VALUES
(7001, 1001, 1001),
(7002, 1002, 1002),
(7003, 1003, 1003),
(7004, 1004, 1004),
(7005, 1005, 1005),
(7006, 1006, 1006),
(7007, 1007, 1007),
(7008, 1008, 1008),
(7009, 1009, 1009),
(7010, 1010, 1010);


--Airport
INSERT INTO Airport (Namee, Id_City) VALUES
('John F. Kennedy International Airport', 1),
('Toronto Pearson International Airport', 2),
('Benito Juarez International Airport', 3),
('Galeão International Airport', 4),
('Ministro Pistarini International Airport', 5),
('Adolfo Suárez Madrid–Barajas Airport', 6),
('Charles de Gaulle Airport', 7),
('Berlin Brandenburg Airport', 8),
('Narita International Airport', 9),
('Sydney Airport', 10);


--PlaneModel
INSERT INTO PlaneModel (Descriptionn, Graphic) VALUES
('Boeing 747', 'boeing747.png'),
('Airbus A320', 'airbusA320.png'),
('Boeing 737', 'boeing737.png'),
('Airbus A380', 'airbusA380.png'),
('Boeing 777', 'boeing777.png'),
('Airbus A330', 'airbusA330.png'),
('Boeing 787', 'boeing787.png'),
('Airbus A350', 'airbusA350.png'),
('Boeing 767', 'boeing767.png'),
('Airbus A340', 'airbusA340.png');


--Airplane
INSERT INTO Airplane (Registration_Number, Begin_of_Number, Statuss, Id_PlaneModel) VALUES
(3001, '2020-01-15', 'Active', 1),
(3002, '2020-03-22', 'Active', 2),
(3003, '2019-05-30', 'Inactive', 3),
(3004, '2018-11-10', 'Active', 4),
(3005, '2021-07-05', 'Active', 5),
(3006, '2017-08-18', 'Inactive', 6),
(3007, '2022-02-25', 'Active', 7),
(3008, '2016-12-01', 'Active', 8),
(3009, '2019-09-14', 'Inactive', 9),
(3010, '2020-06-20', 'Active', 10);


--FlightNumber
INSERT INTO FlightNumber (Departure_Time, Typee, Airline, Id_Start, Id_Goal, Id_Category) VALUES
('10:00:00', 'Domestic', 'American Airlines', 1, 2, 1),
('12:00:00', 'International', 'Air Canada', 2, 3, 2),
('15:00:00', 'Domestic', 'Aeromexico', 3, 4, 3),
('08:00:00', 'International', 'LATAM', 4, 5, 4),
('18:00:00', 'Domestic', 'Aerolineas Argentinas', 5, 6, 5),
('14:00:00', 'International', 'Iberia', 6, 7, 6),
('11:00:00', 'Domestic', 'Air France', 7, 8, 7),
('13:00:00', 'International', 'Lufthansa', 8, 9, 8),
('09:00:00', 'Domestic', 'ANA', 9, 10, 9),
('17:00:00', 'International', 'Qantas', 10, 1, 10);

--Category
INSERT INTO Category (Namee) VALUES
('Economy'),
('Business'),
('First Class'),
('Premium Economy'),
('Basic Economy'),
('Economy Plus'),
('Business Plus'),
('First Class Plus'),
('Premium Business'),
('Executive');

--Flight
INSERT INTO Flight (Boarding_Time, Flight_Date, Gate, Check_in_Counter, Id_FlightNumber, Id_Category) VALUES
('09:30:00', '2024-08-21', 1, 'A01', 1, 1),
('11:30:00', '2024-08-21', 2, 'B02', 2, 2),
('14:30:00', '2024-08-21', 3, 'C03', 3, 3),
('07:30:00', '2024-08-21', 4, 'D04', 4, 4),
('17:30:00', '2024-08-21', 5, 'E05', 5, 5),
('13:30:00', '2024-08-21', 6, 'F06', 6, 6),
('10:30:00', '2024-08-21', 7, 'G07', 7, 7),
('12:30:00', '2024-08-21', 8, 'H08', 8, 8),
('15:30:00', '2024-08-21', 9, 'I09', 9, 9),
('18:30:00', '2024-08-21', 10, 'J10', 10, 10);



--Seat
INSERT INTO Seat (Size, Number, Locationn, Id_PlaneModel) VALUES
(32, 1, 'Window', 1),
(32, 2, 'Aisle', 1),
(32, 3, 'Window', 2),
(34, 4, 'Aisle', 2),
(34, 5, 'Window', 3),
(35, 6, 'Aisle', 3),
(33, 7, 'Window', 4),
(33, 8, 'Aisle', 4),
(32, 9, 'Window', 5),
(32, 10, 'Aisle', 5);


--AvailableSeat
INSERT INTO AvailableSeat (Id_Fligth, Id_Seat) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10);


--Coupon
INSERT INTO Coupon (Date_of_Redemption, Class, Standbyy, Meal_Code, Id_Ticket, Id_Flight, Id_Available) VALUES
('2024-08-22', 'Economy', 'NO', 'VEG', 7001, 1, 1),
('2024-08-23', 'Business', 'NO', 'NON', 7002, 2, 3),
('2024-08-24', 'First Class', 'NO', 'VEG', 7003, 3, 5),
('2024-08-25', 'Economy', 'NO', 'NON', 7004, 4, 7),
('2024-08-26', 'Business', 'NO', 'VEG', 7005, 5, 9),
('2024-08-27', 'Economy', 'NO', 'NON', 7006, 6, 2),
('2024-08-28', 'First Class', 'NO', 'VEG', 7007, 7, 4),
('2024-08-29', 'Business', 'NO', 'NON', 7008, 8, 6),
('2024-08-30', 'Economy', 'NO', 'VEG', 7009, 9, 8),
('2024-08-31', 'First Class', 'NO', 'NON', 7010, 10, 10);


--PiecesOfLuggage
INSERT INTO PiecesOfLuggage (Weightt, Id_Coupon) VALUES
(23.5, 1),
(18.2, 2),
(25.0, 3),
(20.3, 4),
(22.1, 5),
(19.5, 6),
(21.7, 7),
(24.8, 8),
(17.9, 9),
(26.4, 10);


