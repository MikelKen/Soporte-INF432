create database dataAirport

create table dimTime
(
	id integer identity primary key,
	fecha date,
	year int,
	month varchar(50),
	day int
)

create table dimCustomer
(
	id integer identity primary key,
	name varchar(50),
	type varchar(50),
	loyaltyPoints int,
)

create table dimPayment
(
	id integer identity primary key,
	type varchar(50),
	amount decimal,
	currency varchar(50)
)

create table facReservation
(
	id integer identity primary key,
	time_id integer,
	customer_id integer,
	payment_id integer,
	cantReserveCancellation integer,
	constReserveConfirmend integer,
	porceReserveCancellation decimal,
	porcenReserveConfirmed decimal,
	foreign key(time_id) references dimTime(id),
	foreign key(customer_id) references dimCustomer(id),
	foreign key(payment_id) references dimPayment(id)
)






Delete from dimTime
Delete from dimCustomer
Delete from dimPayment
Delete from facReservation