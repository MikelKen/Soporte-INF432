use airportOrigin;
go
--Insert date country
EXEC InsertCountry;  
go
--select * from Country
--Insert date City
EXEC InsertCity;     
go
--Insert date Airport
EXEC InsertAirport;
go
--Insert date PlanelModel
EXEC InsertPlanelModel;
go
--Insert date state airplane
EXEC InsertStateAirplane;
go
--select * from State_Airplane
--Insert date Airplane
EXEC InsertAirplane @NumberOfRows = 30;
go
--select * from Airplane

--Insert date FlightNumbers
EXEC InsertFlightNumbers @NumberOfRows = 1500;
go
--Insert date Seat
EXEC InsertSeats @NumberOfRows = 200;   --datos no insertados
go
--select * from Seat
--Insert date Airline
EXEC InsertAirline;
go
--Insert date Flight
EXEC InsertFlights @NumberOfRows = 1500;
go
-- select * from Flight
--Insert date Available_Seat
EXEC InsertAvailable_Seat @NumberOfRows = 100;
go
--Insert date Passenger_Type
EXEC InsertPassenger_Type;
go
--Insert date Person
EXEC LoadPersonDataFrom ; --@FilePath = 'C:\Users\usuario\Desktop\uagrm\2-2024\soport\Script\person.csv'--cambiar la ruta del archivo
go   -- No funciona 

--select * from Customer
EXEC InsertDataFromTempToPerson;   --No funciona 
go
--Insert date Passenger
EXEC InsertPassengers @NumberOfRows = 800;
go
--Insert type customer
EXEC InsertTypeCustomer
go
--Insert date Customer
EXEC InsertCustomer @NumberOfRows = 1000;  --hay datos no insertados 
go
--Insert date Crew_Member
EXEC InsertCrew_Member @NumberOfRows = 50;  --hay datos no insertados
go
--Insert date Crew_Rol
EXEC InsertCrew_Rol;
go
--Insert date Crew_Assigment
EXEC InsertCrewAssignments @NumberOfRows = 50;  --hay datos no insertados 
go
--Insert date Frequent_Flyer_Card
EXEC InsertFrequentFlyerCards @NumberOfRows = 200;  --Error
go
--Insert date Flight_Cancellation
EXEC InsertFlightCancellations @NumberOfRows = 50;  --algunos datos no insertados 
go

--Insert date Flight_Reprograming
EXEC InsertFlightReprogramings @NumberOfRows = 40;
go
--Insert date Payment_Type
EXEC InsertPayment_Type;
go
--Insert Currency
EXEC InsertCurrency
go
--Insert date Payment
EXEC InsertPayments @NumberOfRows = 1000;
go
--Insert date Document_Type
EXEC InsertDocument_Type;
go
--Insert date Document
EXEC InsertDocuments @NumberOfRows = 1000;
go
--Insert date Category
EXEC InsertCategory;
go
--Insert date Ticket
EXEC InsertTickets @NumberOfRows = 1000;
go
--select * from Ticket
--Insert date Reserve
EXEC InsertReserves @NumberOfRows = 1000; -- hay datos no insertados
go


--Insert date Coupon
EXEC InsertCoupons @NumberOfRows = 1500;  -- hay datos insertados
go
--Insert date Boarding_Pass
EXEC InsertBoardingPasses @NumberOfRows = 1500; -- hay datos insertados
go
--Insert date Pieces_of_Luggage
EXEC InsertPiecesOfLuggage @NumberOfRows = 1500; -- hay datos insertados
go
--Insert date Baggage_Check_In
EXEC InsertPiecesOfLuggage @NumberOfRows = 750;   -- hay datos insertados
go
--Insert date Check_In
EXEC InsertCheck_In @NumberOfRows = 750;   -- hay datos insertados
go
