use master
go
create database martTicket
go
use martTicket
go
create table dimCategory
(
	id integer identity primary key,
	id_category int,
	price decimal(10,2),
	name varchar(50),
)
go
create table dimPassenger
(
	id integer identity primary key,
	id_passenger int ,
	name varchar(50),
	type varchar(50),
)
go
create table dimDocument
(
	id integer identity primary key,
	id_document int,
	date_issue date,
	valid_date date,
	type varchar(50)
)
go
create table dimTime
(
	id integer identity(1,1) primary key,
	fecha date,
	year int,
	month varchar(50),
	day int
)
go

create table factTicket
(
	id integer identity primary key,
	category_id integer,
	passenger_id integer,
	document_id integer,
	time_id integer,
	ticketNumber integer,
	ticket_count int,
	total_price decimal(10,2),
	foreign key (category_id) references dimCategory(id),
	foreign key (passenger_id) references dimPassenger(id),
	foreign key (document_id) references dimDocument(id),
	foreign key (time_id) references dimTime(id)
)

select * from factTicket
truncate table factTicket
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
