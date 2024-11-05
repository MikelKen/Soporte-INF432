use master
create database ticketMart
use ticketMart
create table dimCategory
(
	id integer identity primary key,
	id_category int,
	price decimal(10,2),
	name varchar(50),
)

--ALTER TABLE dimCategory
--ADD id_category INT,
    --price DECIMAL(10,2);




--ALTER TABLE dimCategory
--DROP COLUMN id_category, price;

--EXEC sp_columns dimCategory;



create table dimPassenger
(
	id integer identity primary key,
	id_passenger int ,
	name varchar(50),
	type varchar(50),
)

create table dimDocument
(
	id integer identity primary key,
	id_document int,
	type varchar(50)
)
--ALTER TABLE dimDocument
--ADD id_Document INT;
--select * from dimCategory

create table factTicket
(
	id integer identity primary key,
	category_id integer,
	passenger_id integer,
	document_id integer,
	cantidadTickets integer,
	ticketNumber int,
	pocentajeTickets decimal(10,2),
	foreign key (category_id) references dimCategory(id),
	foreign key (passenger_id) references dimPassenger(id),
	foreign key (document_id) references dimDocument(id)
)
/*
ALTER TABLE factTicket
ADD ticketNumber INT


EXEC sp_columns factTicketSELECT

select t.ticketNumber FROM factTicket t

/**CONSULTAS*/
DELETE FROM dimCategory
DELETE FROM dimPassenger
DELETE FROM dimDocument
DELETE FROM factTicket
*/
