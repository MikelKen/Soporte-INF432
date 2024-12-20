use master

if db_id('airport') is null
begin
	create database airport;
end
go

use airport;
go

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
if object_id('State_Airplane', 'U') is null
begin
	create table State_Airplane (
		ID integer identity(1,1) primary key,
		name varchar(50) not null,
	)
end
go

---------------------------------------------------------------------

if object_id('Airplane', 'U') is null
begin
    create table Airplane(
		id int identity (1,1) primary key,
        Registration_Number int not null,
        Begin_of_Operation date not null check (Begin_of_Operation <= GETDATE()),
        Status_ID integer not null,-- varchar(15) Default 'Active' not null check (Status IN ('Active', 'Inactive', 'Maintenance')),
        Plane_Model_ID int null,
        foreign key (Plane_Model_ID) references Plane_Model(ID),
		foreign key (Status_ID) references State_Airplane(ID)
    );
end
go

---------------------------------------------------------------------

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

if object_id('Seat', 'U') is null
begin
    create table Seat(
        ID int identity(1,1) primary key,
        Size varchar(10) default 'Medium'not null,-- check (Size IN ('Small', 'Medium', 'Large')),
        Number int not null unique check (Number > 0),
        Location varchar(30) default 'Window' not null,-- check (Location IN ('Window','Aisle','Middle','Left','Right')),
        Plane_Model_ID int not null,
        foreign key (Plane_Model_ID) references Plane_Model(ID) ON DELETE NO ACTION
    );
end
go

---------------------------------------------------------------------

if object_id('Airline', 'U') is null
begin
    create table Airline(
        ID int identity(1,1) primary key,
        Name varchar(100) not null ,
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

---------------------------------------------------------------------

if object_id('Flight_Cancellation', 'U') is null
begin
    create table Flight_Cancellation(
        ID int identity(1,1) primary key,
		Reason varchar(75) not null default 'Sin Especificar' check (len(Reason)>5),
        NewDepartureDate date not null,
		Flight_ID int not null,
		foreign key (Flight_ID) references Flight(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Flight_Reprograming', 'U') is null
begin
    create table Flight_Reprograming(
        ID int identity(1,1) primary key,
        NewDepartureDate date not null,
		NewDepartureTime time not null,
		Flight_ID int not null,
		foreign key (Flight_ID) references Flight(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------

if object_id('Available_Seat', 'U') is null --Check in
begin
    create table Available_Seat(
        ID int identity(1,1) primary key,
		Date date not null,
		Time time not null,
        Flight_ID int not null,
        Seat_ID int not null,
        foreign key (Flight_ID) references Flight(ID) ON DELETE NO ACTION,
        foreign key (Seat_ID) references Seat(ID) ON DELETE NO ACTION
    );
end
go

---------------------------------------------------------------------

if object_id('Passenger_Type', 'U') is null
begin
    create table Passenger_Type(
        ID int identity(1,1) primary key,
        Name varchar(30) not null check (len(Name) > 5),
    );
end
go

---------------------------------------------------------------------

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

if object_id('Passenger', 'U') is null
begin
    create table Passenger(
        ID int identity(1,1) primary key,
        Number_Of_Flights int not null,
		Person_ID int not null,
		Passenger_Type_ID int not null,
		foreign key (Passenger_Type_ID) references Passenger_Type(ID) ON DELETE NO ACTION,
		foreign key (Person_ID) references Person(ID) ON DELETE NO ACTION,
    );
end
go

---------------------------------------------------------------------
if object_id ('Type_Customer', 'U') is null
begin
	create table Type_Customer (
		ID integer identity(1,1) primary key,
		name varchar(50) not null
	);
end
go
--------------------------------------------------------------------------
if object_id('Customer', 'U') is null
begin
    create table Customer(
        ID int identity(1,1) primary key,
        Loyalty_Points int not null,
		Person_ID int not null,
		TypeCustomer_ID integer not null,-- Varchar(50) not null check (TypeCustomer IN ('Natural Customer ','Legal Customer')),
		foreign key (Person_ID) references Person(ID) ON DELETE NO ACTION,
		foreign key (TypeCustomer_ID) references Type_Customer(ID) ON DELETE NO ACTION,
    );
end
go

----------------------------------------------------------------------
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

---------------------------------------------------------------------

if object_id('Frequent_Flyer_Card', 'U') is null
begin
    create table Frequent_Flyer_Card(
        FFC_Number int identity(1,1) primary key,
        Miles int not null check (Miles >= 100 AND Miles <= 8000),
        Meal_Code int not null default 3 check (Meal_Code >= 1 AND Meal_Code <= 10),
        Passenger_ID int not null,
        foreign key (Passenger_ID) references Passenger(ID) 
    );
end
go

---------------------------------------------------------------------

if object_id('Payment_Type', 'U') is null
begin
    create table Payment_Type(
        ID int identity(1,1) primary key,
        Name varchar(40) not null check (len(Name) > 2),
    );
end
go

---------------------------------------------------------------------
if object_id ('Currency', 'U') is null
begin
	create table Currency(
		ID integer identity(1,1) primary key,
		code varchar(10) not null,
	);
end
go
---------------------------------------------------------------------
if object_id('Payment', 'U') is null
begin
    create table Payment(
        ID int identity(1,1) primary key,
		Currency_ID  integer not null,-- varchar(10) not null default 'Bs', --check (Currency in ('Bs', 'USD')),
		Amount int not null,
		Date date not null,
		Payment_Type_ID int not null,
		foreign key (Payment_Type_ID) references Payment_Type(ID) ON DELETE NO ACTION,
		foreign key (Currency_ID) references Currency(ID),
	);
end
go

---------------------------------------------------------------------

if object_id('Document_Type', 'U') is null
begin
    create table Document_Type(
        ID int identity(1,1) primary key,
        Name varchar(50) not null check (len(Name) > 2),
    );
end
go

---------------------------------------------------------------------

if object_id('Document', 'U') is null
begin
    create table Document(
        id int identity(1,1) primary key,
        Date_of_Issue date not null check (Date_of_Issue <= GETDATE()),
        Valid_Date date not null,
        Document_Type_ID int not null,
        Country_ID int not null,
        foreign key (Country_ID) references Country(id) ON DELETE NO ACTION,
        foreign key (Document_Type_ID) references Document_Type(ID) ON DELETE NO ACTION
    );
end
go

---------------------------------------------------------------------

if object_id('Category', 'U') is null
begin
    create table Category(
        id int identity(1,1) primary key,
        Name varchar(20) not null, --check(Name IN ('Economic', 'Premium Economic', 'Business', 'First Class')),
		price decimal(10,2),
    );
end
go

/*
SELECT con.name AS constraint_name
FROM sys.check_constraints AS con
JOIN sys.tables AS t ON con.parent_object_id = t.object_id
WHERE t.name = 'Category';

ALTER TABLE Category
DROP CONSTRAINT NombreDelCheckConstraint;

*/
---------------------------------------------------------------------

if object_id('Ticket', 'U') is null
begin
    create table Ticket(
        Ticketing_Code int identity(1,1) primary key,
        Number int not null check (Number > 0),
		Date_Ticket date not null,
        Category_ID int not null,
		Document_ID int not null,
		Passenger_ID int not null,
        foreign key (Category_ID) references Category(ID) ON DELETE NO ACTION,
		foreign key (Document_ID) references Document(ID) ON DELETE NO ACTION,
		Foreign key (Passenger_ID) references Passenger(ID)
    );
end
go

---------------------------------------------------------------------

if object_id('Reserve', 'U') is null
begin
    create table Reserve(
        ID int identity(1,1) primary key,
		State bit not null default 1,
		Reservation_Date date not null default getdate(),
		TicketCount int not null check (TicketCount > 0),
        Customer_ID int not null,
		Payment_ID int not null,
		Ticketing_Code int not null,
        foreign key (Customer_ID) references Customer(ID) ON DELETE NO ACTION,
		foreign key (Payment_ID) references Payment(ID) ON DELETE NO ACTION,
		foreign key (Ticketing_Code) references Ticket(Ticketing_Code) ON DELETE NO ACTION,
    );
end
go


---------------------------------------------------------------------

if object_id('Coupon', 'U') is null
begin
    create table Coupon(
	id int identity(1,1) primary key,
	Date_of_Redemption date not null check (Date_of_Redemption >= GETDATE()),
	Class varchar(20) not null, --check (Class IN ('Economic', 'Premium Economic', 'Business', 'First Class')),
	Standby varchar(20) not null check (Standby IN ('Confirmed', 'Waiting')),
	Meal_Code int not null check (Meal_Code >= 1 AND Meal_Code <= 10),
	Ticketing_Code int not null,
	Flight_ID int not null,
	foreign key (Ticketing_Code) references Ticket(Ticketing_Code)  ON DELETE NO ACTION,
	foreign key (Flight_ID) references Flight(ID)  ON DELETE NO ACTION,
	);
end
go

---------------------------------------------------------------------

if object_id('Boarding_Pass', 'U') is null
begin 
	create table Boarding_Pass(
		id int  identity(1,1) primary key,
		Gate int not null,
		Coupon_ID int not null,
		foreign key (Coupon_ID ) references Coupon(ID ) ON DELETE NO ACTION,
	);
end
go

---------------------------------------------------------------------

if object_id('Pieces_of_Luggage', 'U') is null
begin
    create table Pieces_of_Luggage(
		ID int identity(1,1) primary key,
		Number int not null check (Number > 0),
		Weight decimal not null check (Weight >= 0 AND Weight <= 50),
		--Dimensions
		Length decimal(5,2) not null, -- Largo en cm
        Width decimal(5,2) not null,  -- Ancho en cm
        Height decimal(5,2) not null, -- Alto en cm
		BaggageType varchar(50) not null, --check (BaggageType in ('Maleta','Bolsa de mano', 'Equipaje Deportivo')),
		ExtraWeight decimal(10,2),
		Price decimal(5,2),
		Handling_cost decimal (5,2), 
		Coupon_ID int not null,
		foreign key (Coupon_ID) references Coupon(ID)
	);
end
go

---------------------------------------------------------------------

if object_id ('Baggage_Check_In', 'U') is null
begin
	create table Baggage_Check_In(
		ID int identity (1, 1) primary key,
		Prohibited_Item bit default(0) not null,
		Weight decimal check (Weight >= 0 AND Weight <= 50) not null,
		Pieces_of_Luggage_ID int not null,
		foreign key (Pieces_of_Luggage_ID) references Pieces_of_Luggage(ID)
	);
end 
go

---------------------------------------------------------------------

if object_id('Check_In', 'U') is null
begin
	create table Check_In(
		ID int not null identity(1,1) primary key,
		Coupon_id int not null,
		Available_Seat_id int not null,
		foreign key (Available_Seat_id) references Available_Seat(ID),
		foreign key (Coupon_id) references Coupon(ID)
	);
end 
go
