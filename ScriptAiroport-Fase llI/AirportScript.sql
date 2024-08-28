-- Estudiante: Vino Apaza Vanesa

 
 /*if db_id('Airport') is not null
begin
	use master; 
	drop database Airport;
end
go

create database Airport;
go */

 if db_id('Airport') is null
begin
	create database Airport;
end
go

Use Airport;
go


if OBJECT_ID(N'[dbo].[TypeDocument]', 'U') IS NULL
begin
	create table TypeDocument
	(
		Id INT primary key identity(1,1),
		Namee VARCHAR(30) not null,
		UNIQUE (Namee)
	)
	CREATE INDEX TypeDocu_Name ON TypeDocument(Namee);
end
go


if OBJECT_ID(N'[dbo].[Customer]', 'U') IS NULL
begin
	Create table Customer
	(
		Ci INT primary key,
		Date_of_Birth date not null,
		Namee Varchar(20)  not null,
		UNIQUE (Namee),
		CONSTRAINT CHK_Ci_Positive CHECK (Ci > 0),
		CONSTRAINT CHK_Dte_of_Birth CHECK (Date_of_Birth <= GETDATE()),
		CONSTRAINT CHK_Name_Length CHECK (LEN(Namee) >= 3)
	)
	
	CREATE INDEX Customer_Name ON Customer(Namee);
end
go


if OBJECT_ID(N'[dbo].[Country]', 'U') IS NULL
begin
	Create table Country 
   (
		Id INT primary key identity(1,1),
		Namee VARCHAR(30) not null,
		UNIQUE (Namee),
   )

   CREATE INDEX Country_Name ON Country(Namee);
end
go


if OBJECT_ID(N'[dbo].[City]', 'U') IS NULL
begin
	Create table City
	(
		Id INT primary key identity (1,1),
		Namee VARCHAR(30) not null,
		Id_Country INT not null,
		UNIQUE (Namee),
		foreign key (Id_Country) references Country(Id)
	)

	CREATE INDEX City_Name ON City(Namee);
end
go

if OBJECT_ID(N'[dbo].[Document]', 'U') IS NULL
begin 
	Create table Document
	(
		Number INT primary key,
		Expiration_date DATE not null,
		Issue_Date DATE not null,
		Ci_Custumer INT not null,
		Country_of_issue INT not null,
		Type_Document INT not null,
		UNIQUE (Number),
		CONSTRAINT CHK_Expiration_date CHECK (Expiration_date > Issue_Date),
		CONSTRAINT CHK_Issue_date CHECK (Issue_Date <= GETDATE()),
		foreign key (Ci_Custumer) references Customer(Ci),
		foreign key (Country_of_issue) references Country(Id),
		foreign key (Type_Document) references TypeDocument(Id)
	)

	CREATE INDEX DocumentExpiration ON Document(Expiration_date);
	CREATE INDEX DocumentIssue ON Document(Issue_Date);
	CREATE INDEX DocumentCustomer ON Document(Ci_Custumer);
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
		UNIQUE (FFC_Number),
		CONSTRAINT CHK_Miles CHECK (Miles >= 100 AND Miles <= 8000),
		foreign key (Ci_Customer) references Customer(Ci)
	)

	CREATE INDEX FrequentCustomer ON FrequentFiyerCard(Ci_Customer);
end
go

if OBJECT_ID(N'[dbo].[Category]', 'U') IS NULL
begin 
	Create table Category 
	(
		Id INT primary key identity(1,1),
		Namee VARCHAR(30) NOT NULL,
		UNIQUE (Namee),
		CONSTRAINT CHK_Name CHECK (Namee IN ('Economico','Negocio','Primera Clase','Premium Economico'))
	)

	CREATE INDEX CategoryName ON Category(Namee);
end
go

if OBJECT_ID(N'[dbo].[Ticket]', 'U') IS NULL
begin
	Create table Ticket
	(
		Ticketing_Code VARCHAR(10) primary key,
		Number INT not null,
		Ci_Customer INT not null,
		Id_Category INT not null,
		UNIQUE (Ticketing_Code),
		UNIQUE (Number),
		CONSTRAINT CHK_Number CHECK (Number > 0),
		foreign key (Ci_Customer) references Customer(Ci),
		foreign key (Id_Category) references Category(ID)
	)

	CREATE INDEX TicketNumber ON Ticket (Number);
	CREATE INDEX TicketCustomer ON Ticket(Ci_Customer);
end
go


if OBJECT_ID(N'[dbo].[Airport]', 'U') IS NULL
begin
	Create table Airport
	(
		Id INT primary key identity(1,1),
		Namee VARCHAR (50) not null,
		Id_City INT not null,
		UNIQUE (Namee),
		CONSTRAINT CHK_Naame CHECK (LEN(Namee) > 0),
		foreign key (Id_City) references City(Id)
	)

	CREATE INDEX AirportName ON Airport(Namee); 
end
go

if OBJECT_ID(N'[dbo].[PlaneModel]', 'U') IS NULL
begin
	Create table PlaneModel
	(
		Id INT primary key identity(1,1),
		Descriptionn VARCHAR(50) not null default 'No hay descripcion',
		Graphic VARCHAR(50) not null default 'No hay graficos disponibles',  
		CONSTRAINT UQ_Description UNIQUE (Descriptionn),
		CONSTRAINT CHK_Description CHECK (LEN(Descriptionn) > 0),
		CONSTRAINT CHK_Graphic CHECK (LEN(Graphic) > 0)
	)
end
go

if OBJECT_ID(N'[dbo].[Airplane]', 'U') IS NULL
begin
	Create table Airplane
	(
		Registration_Number INT primary key,
		Begin_of_Operation DATE not null,
		Statuss VARCHAR(50) not null default 'Activo',
		Id_PlaneModel INT not null,
		UNIQUE (Registration_Number),
		CONSTRAINT CHK_Begin CHECK (Begin_of_Operation <= GETDATE()),
		CONSTRAINT CHK_Statuss CHECK (Statuss IN ('Activo','Inactivo','En Mantenimiento')),
		foreign key (Id_PlaneModel) references PlaneModel(Id)
	)

	CREATE INDEX AirplaneBegin ON Airplane(Begin_of_Operation);
	CREATE NONCLUSTERED INDEX AirplaneActive ON Airplane(Statuss) WHERE Statuss = 'Activo';

end
go

if OBJECT_ID(N'[dbo].[FlightNumber]', 'U') IS NULL
begin
	Create table FlightNumber
	(
		Id INT primary key identity(1,1),
		Departure_Time TIME not null,
		Descriptionn VARCHAR(100) not null default 'Sin Descripcion',
		Typee VARCHAR(50) not null default 'Domestico',
		Airline VARCHAR(100) not null,
		Id_Start INT not null,
		Id_Goal INT not null,
		Id_Plane INT not null,
		CONSTRAINT CHK_Departure CHECK (Departure_Time >= '00:00:00' or Departure_Time < '24:00:00'),
		CONSTRAINT CHK_Different CHECK (Id_Start <> Id_Goal),
		foreign key (Id_Start) references Airport(Id), 
		foreign key (Id_Goal) references Airport(Id),
		foreign key (Id_Plane) references PlaneModel(Id)
	)

	CREATE INDEX FlighDeparture ON FlightNumber (Departure_Time);
	CREATE INDEX FlighAirplane ON FlightNumber(Airline);
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
		CONSTRAINT CHK_Flight CHECK (Flight_Date >= GETDATE()),
		CONSTRAINT CHK_Gate CHECK  (Gate > 0),
		foreign key (Id_FlightNumber) references FlightNumber (Id),
	)

	CREATE INDEX FlightBoarding ON Flight(Boarding_Time);
	CREATE INDEX FlightGate ON Flight(Gate);
end
go

if OBJECT_ID(N'[dbo].[Seat]', 'U') IS NULL
begin
	Create table Seat
	(
		Number INT primary key,
		Size VARCHAR(15) not null, --grande, pequeño y mediano
		Locationn VARCHAR(50) not null default 'Pasillo',
		Id_PlaneModel INT not null,
		CONSTRAINT CHK_Size CHECK (Size IN('Grande','Pequeño','Mediano')),
		CONSTRAINT CHK_Location CHECK (Locationn IN ('Ventana','Pasillo','Medio')),
		foreign key (Id_PlaneModel) references PlaneModel(Id)
	)

	CREATE INDEX SeatSize ON Seat(Size);
	CREATE INDEX SeatLocation ON Seat(Locationn);
end
go


if OBJECT_ID(N'[dbo].[AvailableSeat]', 'U') IS NULL
begin
	Create table AvailableSeat
	(
		Number INT primary key identity(1,1),
		Id_Fligth INT not null,
		Id_Seat INT not null,
		foreign key (Id_Fligth) references Flight(Id),
		foreign key (Id_Seat) references Seat(Number)
	)
end
go

if OBJECT_ID(N'[dbo].[Coupon]', 'U') IS NULL
begin
	Create table Coupon
	(
		Id INT primary key identity(1,1),
		Date_of_Redemption DATE not null, --fecha de reembolso
		Class VARCHAR(20) not null default 'Economico',
		Standbyy CHAR(2) not null, -- apoyo
		Meal_Code VARCHAR(5) not null,
		Id_Ticket VARCHAR(10) not null,
		Id_Flight INT not null,
		Id_Available INT not null, 
		CONSTRAINT CHK_Class CHECK (Class IN ('Economico','Negocio','Primera Clase')),
		CONSTRAINT CHK_Standby CHECK (Standbyy IN ('Y','N')),
		foreign key (Id_Ticket) references Ticket(Ticketing_Code),
		foreign key (Id_Flight) references Flight(Id),
		foreign key (Id_Available) references AvailableSeat(Number)
	)

	CREATE INDEX CouponRedempion ON Coupon(Date_of_Redemption);
end
go

if OBJECT_ID(N'[dbo].[PiecesOfLuggage]', 'U') IS NULL
begin
	Create table PiecesOfLuggage
	(
		Number INT primary key identity(1,1),
		Weightt DECIMAL(12,2) not null default 0,
		Id_Coupon INT not null,
		CONSTRAINT CHK_Weight CHECK (Weightt BETWEEN 0.5 AND 50),
		foreign key (Id_Coupon) references Coupon(Id)
	)

	CREATE INDEX PiecesWeightt ON PiecesOfLuggage(Weightt)
end
go



--POBLACION DE DATOS
--TypeDocument
if not exists (select 1 from TypeDocument)
begin
	INSERT INTO TypeDocument (Namee) VALUES 
	('Pasaporte'), 
	('Licencia de Conducir'), 
	('DNI'),  
	('Visa'), 
	('ID Militar'), 
	('Carnet Universitario'), 
	('Certificado de Nacimiento');
select * from TypeDocument
end;


--Customer
if not exists (select 1 from Customer)
begin
	INSERT INTO Customer (Ci, Date_of_Birth, Namee) VALUES 
	(123456, '1990-01-01', 'Juan Perez'), 
	(234567, '1985-05-05', 'Maria Lopez'), 
	(345678, '1970-07-07', 'Carlos Garcia'), 
	(456789, '1995-09-09', 'Ana Martinez'), 
	(567890, '2000-03-03', 'Luis Hernandez'), 
	(678901, '1980-11-11', 'Marta Rodriguez'), 
	(789012, '1993-02-02', 'Pedro Sanchez'), 
	(890123, '1975-04-04', 'Lucia Gonzalez'), 
	(901234, '1988-06-06', 'Roberto Flores'), 
	(101112, '1999-12-12', 'Elena Suarez');
select * from Customer
end


--Country
if not exists (select 1 from Country)
begin
	INSERT INTO Country (Namee) VALUES 
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
select * from Country
end;



--City
if not exists (select 1 from City)
begin
	INSERT INTO City (Namee, Id_Country) VALUES 
	('La Paz', 1), 
	('Buenos Aires', 2), 
	('Santiago', 3), 
	('Rio de Janeiro', 4), 
	('Lima', 5), 
	('Bogotá', 6), 
	('Quito', 7), 
	('Asunción', 8), 
	('Montevideo', 9), 
	('Caracas', 10);
select * from City
end;


--Document
if not exists (select 1 from Document)
begin
	INSERT INTO Document (Number, Expiration_date, Issue_Date, Ci_Custumer, Country_of_issue, Type_Document) VALUES 
	(1001, '2030-01-01', '2020-01-01', 123456, 1, 1), 
	(1002, '2028-05-05', '2018-05-05', 234567, 2, 2), 
	(1003, '2025-07-07', '2015-07-07', 345678, 3, 3), 
	(1004, '2029-09-09', '2019-09-09', 456789, 4, 4), 
	(1005, '2032-03-03', '2022-03-03', 567890, 5, 5), 
	(1006, '2027-11-11', '2017-11-11', 678901, 6, 6), 
	(1007, '2024-02-02', '2014-02-02', 789012, 7, 7), 
	(1008, '2031-04-04', '2021-04-04', 890123, 8, 1), 
	(1009, '2026-06-06', '2016-06-06', 901234, 9, 2), 
	(1010, '2033-12-12', '2023-12-12', 101112, 10, 4);
select * from Document

end;

--FrequebtFuyerCard
if not exists (select 1 from FrequentFiyerCard)
begin
	INSERT INTO FrequentFiyerCard (FFC_Number, Miles, Meal_Code, Ci_Customer) VALUES 
	(2001, 1000, 'A01', 123456), 
	(2002, 1500, 'B02', 234567), 
	(2003, 2000, 'C03', 345678), 
	(2004, 2500, 'D04', 456789), 
	(2005, 3000, 'E05', 567890), 
	(2006, 3500, 'F06', 678901), 
	(2007, 4000, 'G07', 789012), 
	(2008, 4500, 'H08', 890123), 
	(2009, 5000, 'I09', 901234), 
	(2010, 5500, 'J10', 101112);
select * from FrequentFiyerCard
end;



--Category
if not exists (select 1 from Category)
begin
	INSERT INTO Category (Namee) VALUES
	('Economico'),
	('Negocio'),
	('Primera Clase'),
	('Premium Economico');
select * from Category
end;



--Ticket
if not exists (select 1 from Ticket)
begin
	INSERT INTO Ticket (Ticketing_Code, Number, Ci_Customer,Id_Category) VALUES 
	('T001', 1, 123456,1), 
	('T002', 2, 234567,2), 
	('T003', 3, 345678,3), 
	('T004', 4, 456789,4), 
	('T005', 5, 567890,1), 
	('T006', 6, 678901,2), 
	('T007', 7, 789012,3), 
	('T008', 8, 890123,4), 
	('T009', 9, 901234,3), 
	('T010', 10, 101112,1);
select * from Ticket
end;



--Airport
if not exists (select 1 from Airport)
begin
	INSERT INTO Airport (Namee, Id_City) VALUES 
	('Aeropuerto El Alto', 1), 
	('Aeropuerto Ezeiza', 2), 
	('Aeropuerto Arturo Merino Benítez', 3), 
	('Aeropuerto Galeão', 4), 
	('Aeropuerto Jorge Chávez', 5), 
	('Aeropuerto El Dorado', 6), 
	('Aeropuerto Mariscal Sucre', 7), 
	('Aeropuerto Silvio Pettirossi', 8), 
	('Aeropuerto Carrasco', 9), 
	('Aeropuerto de Maiquetía', 10);
select * from Airport
end;



--PlaneModel
if not exists (select 1 from PlaneModel)
begin
	INSERT INTO PlaneModel (Descriptionn, Graphic) VALUES 
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
select * from PlaneModel
end;


--Airplane
if not exists (select 1 from Airplane)
begin
	INSERT INTO Airplane (Registration_Number, Begin_of_Operation, Statuss, Id_PlaneModel) VALUES 
	(3001, '2020-01-01', 'Activo', 1), 
	(3002, '2020-02-01', 'Activo', 2), 
	(3003, '2020-03-01', 'En Mantenimiento', 3), 
	(3004, '2020-04-01', 'Activo', 4), 
	(3005, '2020-05-01', 'Inactivo', 5), 
	(3006, '2020-06-01', 'Activo', 6), 
	(3007, '2020-07-01', 'Activo', 7), 
	(3008, '2020-08-01', 'En Mantenimiento', 8), 
	(3009, '2020-09-01', 'Inactivo', 9), 
	(3010, '2020-10-01', 'Activo', 10);
select * from Airplane
end


--FlightNumber
if not exists (select 1 from FlightNumber)
begin
	INSERT INTO FlightNumber (Departure_Time, Descriptionn, Typee, Airline, Id_Start, Id_Goal, Id_Plane) VALUES 
	('10:00:00', 'Vuelo a Buenos Aires', 'Internacional', 'Aerolíneas Argentinas', 1, 2, 1), 
	('12:00:00', 'Vuelo a Santiago', 'Internacional', 'LATAM', 1, 3, 2), 
	('14:00:00', 'Vuelo a Lima', 'Internacional', 'Avianca', 1, 5, 3), 
	('16:00:00', 'Vuelo a Bogotá', 'Internacional', 'Copa Airlines', 1, 6, 4), 
	('18:00:00', 'Vuelo a Río de Janeiro', 'Internacional', 'GOL', 1, 4, 5), 
	('20:00:00', 'Vuelo a Quito', 'Internacional', 'TAME', 1, 7, 6), 
	('22:00:00', 'Vuelo a Asunción', 'Internacional', 'Paranair', 1, 8, 7), 
	('00:00:00', 'Vuelo a Montevideo', 'Internacional', 'Pluna', 1, 9, 8), 
	('02:00:00', 'Vuelo a Caracas', 'Internacional', 'Conviasa', 1, 10, 9), 
	('04:00:00', 'Vuelo a Buenos Aires', 'Internacional', 'Aerolíneas Argentinas', 2, 1, 10);
select * from FlightNumber
end


--Flight
if not exists (select 1 from Flight)
begin
	INSERT INTO Flight (Boarding_Time, Flight_Date, Gate, Check_in_Counter, Id_FlightNumber) VALUES
	('08:00:00', '2024-09-01', 1, 'A01', 1),
	('09:30:00', '2024-09-02', 2, 'A02', 2),
	('10:45:00', '2024-09-03', 3, 'A03', 3),
	('12:15:00', '2024-09-04', 4, 'A04', 4),
	('14:00:00', '2024-09-05', 5, 'A05', 5),
	('15:30:00', '2024-09-06', 6, 'A06', 6),
	('17:00:00', '2024-09-07', 7, 'A07', 7),
	('18:45:00', '2024-09-08', 8, 'A08', 8),
	('20:00:00', '2024-09-09', 9, 'A09', 9),
	('22:15:00', '2024-09-10', 10, 'A10', 10);
select * from Flight
end


--Seat
if not exists (select 1 from Seat)
begin
	INSERT INTO Seat (Number, Size, Locationn, Id_PlaneModel) VALUES
	(1, 'Grande', 'Ventana', 1),
	(2, 'Mediano', 'Pasillo', 1),
	(3, 'Pequeño', 'Medio', 1),
	(4, 'Grande', 'Pasillo', 2),
	(5, 'Mediano', 'Ventana', 2),
	(6, 'Pequeño', 'Medio', 2),
	(7, 'Grande', 'Ventana', 3),
	(8, 'Mediano', 'Pasillo', 3),
	(9, 'Pequeño', 'Medio', 3),
	(10, 'Grande', 'Ventana', 4);
select * from Seat
end


--AvailableSeat
if not exists (select 1 from AvailableSeat)
begin
	INSERT INTO AvailableSeat (Id_Fligth, Id_Seat) VALUES
	(1, 1),
	(2, 2),
	(3, 3),
	(4, 4),
	(5, 5),
	(6, 6),
	(7, 7),
	(8, 8),
	(9, 9),
	(10, 10);
select * from AvailableSeat
end


--Coupon
if not exists (select 1 from Coupon)
begin
	INSERT INTO Coupon (Date_of_Redemption, Class, Standbyy, Meal_Code, Id_Ticket, Id_Flight, Id_Available) VALUES
	('2024-09-01', 'Economico', 'Y', 'MC1', 'T001', 1, 1),
	('2024-09-02', 'Negocio', 'N', 'MC2', 'T002', 2, 2),
	('2024-09-03', 'Primera Clase', 'Y', 'MC3', 'T003', 3, 3),
	('2024-09-04', 'Economico', 'N', 'MC4', 'T004', 4, 4),
	('2024-09-05', 'Negocio', 'Y', 'MC5', 'T005', 5, 5),
	('2024-09-06', 'Primera Clase', 'N', 'MC6', 'T006', 6, 6),
	('2024-09-07', 'Economico', 'Y', 'MC7', 'T007', 7, 7),
	('2024-09-08', 'Negocio', 'N', 'MC8', 'T008', 8, 8),
	('2024-09-09', 'Primera Clase', 'Y', 'MC9', 'T009', 9, 9),
	('2024-09-10', 'Economico', 'N', 'MC10', 'T010', 10, 10);
select * from Coupon
end;


--PiecesOfLuggage
if not exists (select 1 from PiecesOfLuggage)
begin
	INSERT INTO PiecesOfLuggage (Weightt, Id_Coupon) VALUES
	(10.5, 1),
	(15.0, 2),
	(8.2, 3),
	(12.3, 4),
	(18.4, 5),
	(20.0, 6),
	(25.1, 7),
	(30.5, 8),
	(40.7, 9),
	(50.0, 10);
select * from PiecesOfLuggage
end;



