use master
create database martReserve
use martReserve
create table dimTime
(
	id integer identity(1,1) primary key,
	fecha date,
	year int,
	month varchar(50),
	day int
)
select fecha from dimTime
create table dimCustomer
(
	id integer identity(1,1) primary key,
	id_customer integer,
	name varchar(50),
	type varchar(50),
	loyaltyPoints int,
)
truncate table dimCustomer  
create table dimPayment
(
	id integer identity(1,1) primary key,
	id_payment int,
	type varchar(50),
	amount decimal,
	currency varchar(50),
)
select * from dimPayment
--alter table dimPayment add id_payment int
create table dimStatusReserve
(
	id int identity(1,1) primary key,
	name varchar(50)
)

create table facReservation
(
	id integer identity primary key,
	time_id integer,
	customer_id integer,
	payment_id integer,
	status_id integer,
	count_reserve integer,
	total_amount decimal(10,2),
	foreign key(time_id) references dimTime(id),
	foreign key(customer_id) references dimCustomer(id),
	foreign key(payment_id) references dimPayment(id),
	foreign key(status_id) references dimStatusReserve(id)
)

