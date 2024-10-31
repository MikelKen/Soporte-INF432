use master

create database martAeroline 

use martAeroline

create table dimFlith
(
	id integer identity primary key,
	id_flith integer,
	state varchar(20),
)

select id_flith
from dimFlith 

create table dimAirplane --avion
(
	id integer identity primary key,
	id_airplane integer,
	state varchar(50),
	model varchar(50),
)

create table factAeroline
(
	id integer identity primary key,
	id_Aeroline integer,
	flith_id integer,
	airplane_id integer,
	cantAirplane integer,
	avgFlithCandelled decimal(10,2),
	motiveCancelledFrecuency varchar(50),
	foreign key (flith_id) references  dimFlith(id),
	foreign key (airplane_id) references dimAirplane(id)

)
Alter table factAeroline
Add name_aeroline Varchar(50)

select * from factAeroline f

