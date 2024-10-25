use master
create database ticketMart
use ticketMart
create table dimCategory
(
	id integer identity primary key,
	name varchar(50),
)

create table dimPassenger
(
	id integer identity primary key,
	name varchar(50),
	type varchar(50),
)
select * from dimPassenger
create table dimDocument
(
	id integer identity primary key,
	type varchar(50)
)

create table factTicket
(
	id integer identity primary key,
	category_id integer,
	passenger_id integer,
	document_id integer,
	cantidadTickets integer,
	pocentajeTickets decimal(10,2),
	foreign key (category_id) references dimCategory(id),
	foreign key (passenger_id) references dimPassenger(id),
	foreign key (document_id) references dimDocument(id)
)
SELECT * FROM factTicket

/**CONSULTAS*/
DELETE FROM dimCategory
DELETE FROM dimPassenger
DELETE FROM dimDocument
DELETE FROM factTicket
