use examen
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

INSERT INTO Airplane (Registration_Number, Begin_of_Operation, Plane_Model_ID) VALUES
(12345, '2020-01-01', 1), (67890, '2019-06-15', 2), 
(11223, '2021-03-20', 3), (44556, '2018-07-11', 4),
(77889, '2022-09-08', 5), (99001, '2017-05-30', 6),
(22334, '2020-12-22', 7), (55667, '2019-04-10', 8),
(88990, '2021-11-01', 9), (33445, '2016-08-16', 10);


INSERT INTO Flight_Number (Departure_Time, Type, Airport_Start, Airport_Goal) VALUES
('06:00', 1, 1, 2), ('10:30', 0, 3, 4), 
('14:15', 1, 5, 6), ('18:45', 0, 7, 8),
('20:00', 1, 9, 10), ('09:00', 0, 2, 1),
('13:50', 1, 4, 3), ('17:20', 0, 6, 5),
('22:10', 1, 8, 7), ('07:25', 0, 10, 9);


INSERT INTO Airline (Name, Country_ID) VALUES
('Boliviana de Aviación', 1), ('LATAM Airlines', 3),
('Avianca', 6), ('Aerolineas Argentinas', 4),
('GOL Linhas Aéreas', 5), ('American Airlines', 8),
('Air Canada', 9), ('Volaris', 7),
('Iberia', 10), ('Peruvian Airlines', 2);


INSERT INTO Flight (Boarding_Time,FlightNumber, Flight_Date, Gate, Check_In_Counter, departureTime, departureHour, arrivalDate, arrivalHour, Flight_Number_ID, Plane_ID, Airline_ID) VALUES
('05:30',1000, '2024-12-01', 10, 1, '2024-12-01', '06:00', '2024-12-01', '08:00', 1, 1, 1),
('10:00',1001, '2024-12-02', 5, 1, '2024-12-02', '10:30', '2024-12-02', '12:30', 2, 2, 2),
('13:45',1002, '2024-12-03', 8, 1, '2024-12-03', '14:15', '2024-12-03', '16:15', 3, 3, 3),
('18:15',1003, '2024-12-04', 2, 0, '2024-12-04', '18:45', '2024-12-04', '20:45', 4, 4, 4),
('19:30',1004, '2024-12-05', 12, 1, '2024-12-05', '20:00', '2024-12-05', '22:00', 5, 5, 5),
('08:30',1005, '2024-12-06', 15, 1, '2024-12-06', '09:00', '2024-12-06', '11:00', 6, 6, 6),
('13:30',1006, '2024-12-07', 7, 0, '2024-12-07', '13:50', '2024-12-07', '15:50', 7, 7, 7),
('17:00',1007, '2024-12-08', 3, 1, '2024-12-08', '17:20', '2024-12-08', '19:20', 8, 8, 8),
('21:40',1008, '2024-12-09', 9, 1, '2024-12-09', '22:10', '2024-12-10', '00:10', 9, 9, 9),
('06:55',1009, '2024-12-10', 4, 1, '2024-12-10', '22:30', '2024-12-11', '00:45', 10, 10, 10);
select * from Flight

INSERT INTO Person (Name, Phone, Email, Type) VALUES
('Juan Perez', '123456789', 'juan.perez@mail.com', 'Passenger'),
('Maria Lopez', '987654321', 'maria.lopez@mail.com', 'Customer'),
('Carlos Garcia', '555555555', 'carlos.garcia@mail.com', 'Crew Member'),
('Ana Martinez', '777777777', 'ana.martinez@mail.com', 'Passenger'),
('Luis Hernandez', '666666666', 'luis.hernandez@mail.com', 'Crew Member'),
('Sofia Torres', '999999999', 'sofia.torres@mail.com', 'Passenger'),
('Jorge Ramirez', '444444444', 'jorge.ramirez@mail.com', 'Customer'),
('Elena Flores', '333333333', 'elena.flores@mail.com', 'Passenger'),
('Diego Suarez', '222222222', 'diego.suarez@mail.com', 'Crew Member'),
('Laura Morales', '111111111', 'laura.morales@mail.com', 'Customer');

INSERT INTO Crew_Member (Flying_Hours, Type, Person_ID)
VALUES
(1200, 'Crew Member', 1),
(1500, 'Crew Member', 2),
(800, 'Crew Member', 3),
(2000, 'Crew Member', 4),
(950, 'Crew Member', 5),
(1100, 'Crew Member', 6),
(1300, 'Crew Member', 7),
(1700, 'Crew Member', 8),
(1400, 'Crew Member', 9),
(1600, 'Crew Member', 10);


INSERT INTO Crew_Rol (Name)
VALUES
('Piloto'),
('Co-Pilot'),
('Flight Attendant'),
('Cabin Crew'),
('Flight Engineer'),
('Safety Officer');
--('Ground Staff'),
--('Maintenance Technician'),
--('Flight Operations Manager'),
--('Cabin Supervisor');

select * from Crew_Rol
INSERT INTO Crew_Assigment (Date, Crew_Rol_ID, Flight_ID, Crew_Member_ID)
VALUES
('2024-12-01', 1, 1, 1),
('2024-12-01', 2, 10, 2),
('2024-12-02', 3, 2, 3),
('2024-12-03', 4, 3, 4),
('2024-12-04', 5, 4, 5),
('2024-12-05', 6, 5, 6),
('2024-12-06', 1, 6, 7),
('2024-12-07', 2, 7, 8),
('2024-12-08', 3, 8, 9),
('2024-12-09', 4, 9, 10);
select * from Crew_Assigment