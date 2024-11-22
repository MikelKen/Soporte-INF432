use master;

create database exam


use  exam
go

create table fligth
(
	id integer identity(1,1) primary key,
	departureTime date not null,  --fecha de salida
	departureHour time not null,  --hora de salida
	arrivalDate date not null,	--fecha de llegada
	arrivalHour time not null,
);

create table tripulation
(
	id integer identity(1,1) primary key,
	name varchar(50),
)

create table role
(
	id int identity(1,1) primary key,
	name varchar(50),
)

create table asignation 
(
	id int identity(1,1) primary key,
	idFligth int not null,
	idTripulation int not null,
	idRole int not null,
	dateAsignation date not null,
	foreign key (idFligth) references fligth(id),
	foreign key (idTripulation) references tripulation(id),
	foreign key (idRole) references role(id),
)



INSERT INTO fligth (departureTime, departureHour, arrivalDate, arrivalHour) VALUES
('2024-11-25', '08:00:00', '2024-11-25', '10:30:00'),
('2024-11-26', '12:00:00', '2024-11-26', '13:00:00'),
('2024-11-27', '14:30:00', '2024-11-27', '15:20:00'),
('2024-11-28', '09:00:00', '2024-11-28', '11:15:00'),
('2024-11-29', '16:00:00', '2024-11-29', '18:30:00'),
('2024-12-01', '07:00:00', '2024-12-01', '09:45:00'),
('2024-12-02', '10:15:00', '2024-12-02', '12:00:00'),
('2024-12-03', '13:45:00', '2024-12-03', '15:30:00'),
('2024-12-04', '18:00:00', '2024-12-04', '20:10:00'),
('2024-12-05', '22:30:00', '2024-12-06', '00:45:00');


INSERT INTO tripulation (name) VALUES
('Juan Pérez'),
('Ana Rodríguez'),
('Luis Fernández'),
('María Gómez'),
('Carlos Sánchez'),
('Sofía Morales'),
('Andrés Castro'),
('Elena Rojas'),
('Jorge Gutiérrez'),
('Laura Delgado');


INSERT INTO role (name) VALUES
('Piloto'),
('Copiloto'),
('Azafata'),
('Técnico de Mantenimiento'),
('Supervisor'),
('Jefe de Cabina'),
('Oficial de Operaciones'),
('Asistente de Vuelo'),
('Coordinador'),
('Auxiliar de Mantenimiento');


INSERT INTO asignation (idFligth, idTripulation, idRole, dateAsignation) VALUES
(1, 1, 1, '2024-11-20'),
(1, 2, 2, '2024-11-20'),
(1, 3, 3, '2024-11-20'),
(2, 4, 1, '2024-11-21'),
(2, 5, 2, '2024-11-21'),
(3, 6, 3, '2024-11-22'),
(3, 7, 4, '2024-11-22'),
(4, 8, 5, '2024-11-23'),
(4, 9, 6, '2024-11-23'),
(5, 10, 7, '2024-11-24');





WITH FlightSegments AS (
    -- Vuelos en la misma fecha
    SELECT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, departureHour, arrivalHour), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM fligth
    WHERE departureTime = arrivalDate

    UNION ALL

    -- Primer segmento: Desde la hora de salida hasta el final del día de salida
    SELECT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        departureTime AS fechaLlegada,
        '23:59:59' AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, departureHour, '23:59:59'), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM fligth
    WHERE departureTime <> arrivalDate

    UNION ALL

    -- Segundo segmento: Desde el inicio del día de llegada hasta la hora de llegada
    SELECT
        id,
        FORMAT(arrivalDate, 'yyyy-MM-dd') AS fechaFligth,
        arrivalDate AS fechaSalida,
        '00:00:00' AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', arrivalHour), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM fligth
    WHERE departureTime <> arrivalDate
)
SELECT *
FROM FlightSegments
ORDER BY id, fechaFligth;







--************************************888
WITH FlightSegments AS (
    -- Vuelos en la misma fecha
    SELECT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, departureHour, arrivalHour), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM fligth
    WHERE departureTime = arrivalDate

    UNION ALL

    -- Primer segmento: Desde la hora de salida hasta el final del día de salida
    SELECT
        id,
        FORMAT(departureTime, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        departureTime AS fechaLlegada,
        arrivalHour AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, departureHour, '23:59:59'), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM fligth
    WHERE departureTime <> arrivalDate

    UNION ALL

    -- Segundo segmento: Desde el inicio del día de llegada hasta la hora de llegada
    SELECT
        id,
        FORMAT(arrivalDate, 'yyyy-MM-dd') AS fechaFligth,
        departureTime AS fechaSalida,
        departureHour AS horaSalida,
        arrivalDate AS fechaLlegada,
        arrivalHour AS horaLlegada,
        FORMAT(DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', arrivalHour), '00:00:00'), 'HH:mm') AS duracionVueloHours
    FROM fligth
    WHERE departureTime <> arrivalDate
)
SELECT *
FROM FlightSegments
ORDER BY id, fechaFligth;


use exam