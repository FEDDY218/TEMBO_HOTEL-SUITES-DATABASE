


--=======Section C: 03_database_design.sql



---=====================CREATING NEW SCHEMAS ==========================================================================================


--Creating a table hotel.guest


create table hotel.guest (
guest_id serial primary key,
guest_name varchar(50),
guest_phone varchar(20),
guest_city varchar(20),
guest_nationality  varchar(20)
);


--Creating table hotel.room

create table hotel.room (
room_id serial primary key,
room_no integer,
room_type varchar(50),
room_rate_per_night numeric(10,2)
);



--Creating table finance.payment


create table finance.payment(
payment_id serial primary key,
booking_id varchar(20),
payment_method varchar(50),
total_amount numeric(12,2)
);


--Creating table staffs.staff
 
create table staffs.staff(
staff_id serial primary key,
staff_name    varchar(50),
staff_department  varchar(50),
staff_salary  numeric(12,2)
);


--Creating table services.service 

create table services.service (
service_id serial primary key,
service_used varchar(100),
service_price numeric(10,2)
);


--Creating a table hotel.booking

create table hotel.booking (
	booking_id  varchar(20) primary key,
	guest_id  integer,
	room_id    integer,
	staff_id   integer,
	service_id      integer,
	check_in_date   date,
	check_out_date  date,
	nights_stayed   integer,
	booking_status   varchar(50),
 	foreign key (guest_id)
	    references hotel.guest(guest_id),
	foreign key(room_id)
	    references hotel.room(room_id),
	foreign key(staff_id)
	    references staffs.staff(staff_id),
	foreign key(service_id)
	    references services.service(service_id)
);


--=============================================================================================================================================================






--=============================================================================================================================================================