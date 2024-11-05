create database customerMart;
use customerMart;

create table dimReserve(
	id INT identity primary key,
	id_Reserve INT,
	Reservation_Date date not null,
	state BIT not null default 1
);

-- create table dimTypeCustomer(
--	id INT identity primary key,
--	id_TypeCustomer INT,
--	name VARCHAR not null,
--);

create table dimTypePayment(
	id INT identity primary key,
	id_TypePayment INT,
	name VARCHAR NOT NULL,
);

create table factCustomer(
	id INT identity primary key,
	reserve_id INT,
	typePayment_id INT,
	CantCustomer INT,
	CantReserveCancelled INT,
	useFrec DECIMAL(10,2)
	foreign key (reserve_id) references dimReserve(id),
	foreign key (typePayment_id) references dimTypePayment(id)
);