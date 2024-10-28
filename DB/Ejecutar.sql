
--Insert date country
EXEC InsertCountry;
select * from Country
--Insert date City
EXEC InsertCity;

--Insert date Airport
EXEC InsertAirport;

--Insert date PlanelModel
EXEC InsertPlanelModel;

--Insert date Airplane
EXEC InsertAirplane @NumberOfRows = 30;


--Insert date FlightNumbers
EXEC InsertFlightNumbers @NumberOfRows = 1500;

--Insert date Seat
EXEC InsertSeats @NumberOfRows = 200;

--Insert date Airline
EXEC InsertAirline;

--Insert date Flight
EXEC InsertFlights @NumberOfRows = 1500;

--Insert date Available_Seat
EXEC InsertAvailable_Seat @NumberOfRows = 100;

--Insert date Passenger_Type
EXEC InsertPassenger_Type;

--Insert date Person
EXEC LoadPersonDataFrom ;--@FilePath = 'C:\Users\usuario\Desktop\uagrm\2-2024\soport\Script\person.csv'--cambiar la ruta del archivo
EXEC InsertDataFromTempToPerson;

--Insert date Passenger
EXEC InsertPassengers @NumberOfRows = 800;

--Insert date Customer
EXEC InsertCustomer @NumberOfRows = 400;

--Insert date Crew_Member
EXEC InsertCrew_Member @NumberOfRows = 50;

--Insert date Crew_Rol
EXEC InsertCrew_Rol;

--Insert date Crew_Assigment
EXEC InsertCrewAssignments @NumberOfRows = 50;

--Insert date Frequent_Flyer_Card
EXEC InsertFrequentFlyerCards @NumberOfRows = 200;

--Insert date Flight_Cancellation
EXEC InsertFlightCancellations @NumberOfRows = 50;
select * from Flight_Cancellation
--Insert date Flight_Reprograming
EXEC InsertFlightReprogramings @NumberOfRows = 40;

--Insert date Payment_Type
EXEC InsertPayment_Type;

--Insert date Payment
EXEC InsertPayments @NumberOfRows = 300;

--Insert date Document_Type
EXEC InsertDocument_Type;

--Insert date Document
EXEC InsertDocuments @NumberOfRows = 100;

--Insert date Category
EXEC InsertCategory;

--Insert date Ticket
EXEC InsertTickets @NumberOfRows = 500;

--Insert date Reserve
EXEC InsertReserves @NumberOfRows = 500;

--Insert date Confirmation
EXEC InsertConfirmation @NumberOfRows = 450;

--Insert date Cancellation
EXEC InsertCancellations @NumberOfRows = 50;

--Insert date Coupon
EXEC InsertCoupons @NumberOfRows = 800;

--Insert date Boarding_Pass
EXEC InsertBoardingPasses @NumberOfRows = 750;

--Insert date Pieces_of_Luggage
EXEC InsertPiecesOfLuggage @NumberOfRows = 750;

--Insert date Baggage_Check_In
EXEC InsertPiecesOfLuggage @NumberOfRows = 750;

--Insert date Check_In
EXEC InsertCheck_In @NumberOfRows = 750;














/*
select * from Country
select * from City
select * from Airport
select * from Plane_Model
select * from Airplane
select * from Flight_Number
select * from Seat
select * from Airline
select * from Flight
select * from Available_Seat
select * from Passenger_Type
select * from Person
--
select * from TempPersonData
drop table TempPersonData
--
select * from Passenger
select * from Customer
select * from Crew_Member
select * from Crew_Rol
select * from Crew_Assigment
select * from Frequent_Flyer_Card
select * from Flight_Cancellation
select * from Flight_Reprograming
select * from Payment_Type
select * from Payment
select * from Document_Type
select * from Document
select * from Category
select * from Ticket
select * from Reserve
select * from Confirmation
select * from Cancellation
select * from Coupon
select * from Boarding_Pass
select * from Pieces_of_Luggage
select * from Baggage_Check_In
select * from Check_In

*/



select * from dimPassenger

truncate table dimPassenger


-- Insertar 20 aviones aleatorios
EXEC InsertAirplanes @NumberOfRows = 20;

-- Insertar 10 números de seats aleatorios
EXEC InsertFlightNumbers @NumberOfRows = 20;


-- Crear una tabla temporal para cargar los datos desde el CSV
CREATE TABLE #TempPersonData (
    Name VARCHAR(50),
    Phone VARCHAR(20),
    Email VARCHAR(50)
);

-- Cargar los datos del CSV a la tabla temporal
BULK INSERT #TempPersonData
FROM 'C:\Users\usuario\Desktop\uagrm\2-2024\soport\Script\person.csv'--cambiar la ruta del archivo
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2 -- Asume que la primera fila es el encabezado
);
Go