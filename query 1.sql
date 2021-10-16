/*create database AIRLINE; */
/*use AIRLINE; */

show databases;
create table COMPANY
(
	company_id char(3) primary key,
    company_name char(30)
     
);

create table AIRPORT
(
	airport_code char(3) primary key,
    airport_name char (20),
    city char(10),
    state char(15)
);
create table FLIGHT
(
	flight_number char(10) primary key,
    airline_name char(20),
    weekdays char(15),
    foreign key (airline_name) references airline(airline_name)
);

create table FLIGHT_LEG
(
	flight_number char(10),
    leg_num tinyint ,							
    dep_airport_code char(3),
    sched_depart_time time,
    sched_arrival_time time,
    arr_airport_code char(3),
    foreign key (flight_number) references flight(flight_number),
    foreign key (arr_airport_code,dep_airport_code) references airport(airport_code),
    primary key(flight_number,leg_num)
    
); 

create table leg_instance
(
	flight_number char(8),
    leg_num tinyint,	
    flight_date date ,
    num_availible_seat smallint,
    airplane_id char(8),
	dep_airport_code char(3),
    dep_time time,
    arr_airport_code char(3),
    arr_time time,
    foreign key (flight_number,leg_num) references flight_leg(flight_number,leg_num),
	
    foreign key (airplane_id) references airplane(airplane_id),
	foreign key (arr_airport_code, dep_airport_code) references airport(airport_code),
    primary key ( flight_number,leg_num,flight_date)
);

create table FARE
(
	flight_number char(8),
    fare_code char(1),
    amount double ,
    restriction char(15),
	foreign key (flight_number) references flight(flight_number),
    primary key ( flight_number, fare_code)
);

create table AIRPLANE_TYPE
(
	airplane_type_name char(5)  primary key,
    max_seats smallint
);
create table CAN_LAND
(
	airplane_type_name char(5) ,
    airport_code char(3),
    foreign key (airport_code) references airport(airport_code),
	foreign key (airplane_type_name) references airplane_type(airplane_type_name),
    primary key(airplane_type_name,airport_code)
);


create table AIRPLANE
(
    airplane_id char(8) primary key ,
    total_num_of_seats smallint,
    airplane_type_name char(5),
    company_id char(3),
    foreign key (airplane_type_name) references airplane_type(airplane_type_name)
    
);

create table SEAT_RESERVATION
(
	flight_number char(10),
    leg_num tinyint ,	
    flight_date date ,
    seat_number char(4) ,
    passport_no char(10) ,
    foreign key (passport_no) references customer(passport_no),
    foreign key (flight_number,leg_num,flight_date) references leg_instance(flight_number,leg_num,flight_date),
    primary key ( flight_number, leg_num, flight_date, seat_number)
);


create table FFC
(
	
    passport_no char(10),
    ffc_id char(10),
    total_mileage smallint,
    foreign key (passport_no) references customer(passport_no),
    primary key(passport_no,ffc_id)
    
);

create table CUSTOMER
(
	passport_no char(15) primary key,
    customer_name char (25),
    country char (25),
    customer_phone bigint,
    address char(50),
    email char(40)
);

create table AIRLINE
(
	airline_name char(20) primary key,
	company_id char(3),
    foreign key (company_id) references Company (company_id)
);

create table single_ffc
(
	mileage smallint,
    singleFFC_no tinyint primary key,
    flight_date date,
	leg_num tinyint,
    passport_no char(10) not null,
	ffc_id char(10) not null,
    flight_number char(8),
    fare_code char(1),
    foreign key (passport_no,ffc_id) references ffc(passport_no,ffc_id),
    foreign key (flight_number,leg_num,flight_date) references leg_instance(flight_number,leg_num,flight_date)
    
);

	
select * from company;
SELECT * from airport;
select * from flight;
select * from  flight_leg;
select * from leg_instance;
select * from fare;
select * from airplane_type;
select * from can_land;
select * from airplane;
select * from seat_reservation;
select * from ffc;
select * from customer;
select * from single_ffc;
show tables from airline; 
select * from airline;

select *
 from airline, flight ;
 

/* constraints */

alter table airplane
add check (total_num_of_seats > 0);

ALTER TABLE single_ffc
ADD CHECK (mileage>0);

ALTER TABLE fare
ADD CHECK (amount>0);

alter table ffc
add check ( total_mileage > 0);

alter table airplane_type 
add check ( max_seats > 0) ;

/* INSERT UPDATE DELET */

INSERT into airplane_type
values ( 'A350', 180);
select * from airplane_type;

update airplane_type
set Max_seats=200
where airplane_type_name = 'A350';

delete from airplane_type
where airplane_type_name ='A350';

INSERT into customer
values ( 'D13400034','yamato', 'Japan',78451239000,'13 st tokyo ','yamato@yahoo.com');    /* no action on update */
select * from customer;

update customer
set customer_name='Yoshida'
where passport_no = 'D13400034';

delete from customer
where passport_no = 'D13400034';


select can_land.airplane_type_name
from can_land
where airport_code = 'DXB' ;

 /* retirieve the name of companies and that have airplanes with total number of seats more than 200*/
select c.company_name, a.total_num_of_seats
from company as c , airplane as a
where total_num_of_seats > 200 and c.company_id =a.company_id;

/* retriev all the cities where flight departed accordingly with schedualed departure time */
select distinct city,l.dep_time, fli.sched_depart_time
from airport, flight_leg as fli, leg_instance as l
where l.dep_time = fli.sched_depart_time
and l.dep_airport_code = airport.airport_code;

/* customer names and seat numbers who are flying from SAW airport */
select C.customer_name, S.seat_number
from customer as c , seat_reservation as S , leg_instance as l
where dep_airport_code = 'saw' 
and l.flight_number = s.flight_number
and l.leg_num = s.leg_num 
and l.flight_date = s.flight_date
and s.passport_no = c.passport_no;

select distinct s.mileage , c.customer_name, se.seat_number
FROM single_ffc as s , customer as c , seat_reservation as se , ffc
where s.mileage > 1000
and s.ffc_id = ffc.ffc_id
and  c.passport_no = se.passport_no;

show tables;




    

    

    