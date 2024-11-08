use master;

create database martPayment;
use martPayment;

-----------------------------------------------------------------

create table dimTime(
	id int primary key identity,
	fecha date,
	year int,
	month varchar(50),
	day varchar(50),
);


create table dimCustomer(
	id int primary key identity,
	id_customer int,
	name VARCHAR(50),
	type VARCHAR(50),
	loyaltyPoints int,
);
--alter table dimCustomer add loyaltyPoints int

create table dimTypePayment(
	id int primary key identity,
	id_typePayment int,
	typePayment VARCHAR(40)
);

create table dimMontoPayment(
	id int primary key identity,
	id_montoPayment int,
	monto int
);

create table factPayment(
	id int primary key identity,
	time_id int,
	customer_id int,
	typePayment_id int,
	MontoTotalPago int,
	CantPagoRealizado int
	foreign key (time_id) references dimTime(id),
	foreign key (customer_id) references dimCustomer(id),
	foreign key (typePayment_id) references dimTypePayment(id),
);

