

----Section 4: Loading_clean_data.sql


-----=======INSERTING THE CLEAN DATA TO THE TABLES-----===========

--Inserting hotel.guest table 

insert into hotel.guest (
      guest_name,
      guest_phone,
      guest_city,
      guest_nationality
)
select distinct 
guest_name,
guest_phone,
guest_city,
guest_nationality
from staging.tembo_hotel_dirty
where guest_name is not null;

select * from hotel.guest;

select count(*) AS total_guests
from hotel.guest; ---# TOTAL GUESTS: 63


---Inserting hotel.room table 

insert into hotel.room (
	room_no,
	room_type,
	room_rate_per_night
)
select distinct 
room_no,
room_type,
room_rate_per_night
from staging.tembo_hotel_dirty 
where room_no is not null;


select * from hotel.room;

select count(*) as total_rooms
from hotel.room;  ---# TOTAL ROOMS: 10



---Inserting into hotel.booking table


insert into hotel.booking (
    booking_id,
    guest_id,
    room_id,
    staff_id,
    service_id,
    check_in_date,
    check_out_date,
    nights_stayed,
    booking_status
)
select distinct on (s.booking_id)
    s.booking_id,
    g.guest_id,
    r.room_id,
    st.staff_id,
    sv.service_id,
    s.check_in_date::date,
    s.check_out_date::date,
    s.nights_stayed::integer,
    s.booking_status
from staging.tembo_hotel_dirty s
join hotel.guest g
    on s.guest_name = g.guest_name
join hotel.room r
    on s.room_no = r.room_no
join staffs.staff st
    on s.staff_name = st.staff_name
join services.service sv
    on s.service_used = sv.service_used
order by s.booking_id;


select count(*) from hotel.booking;


---Inserting the finance.payment table

insert into finance.payment (
booking_id,
payment_method,
total_amount
)
select 
s.booking_id,
s.payment_method,
s.total_amount::numeric
from staging.tembo_hotel_dirty s
join hotel.booking b 
   on s.booking_id = b.booking_id;

select * from finance.payment;


---Inserting the table staffs.staff

insert into staffs.staff (
staff_name, 
staff_department, 
staff_salary
)
select distinct 
s.staff_name,
s.staff_department,
s.staff_salary::numeric
from staging.tembo_hotel_dirty s
where s.staff_name is not null;

select * from staffs.staff;

select count(*) as Number_of_staff
from staffs.staff; --# NUMBER OF STAFF = 8


---Inserting the table services.service 

insert into services.service (
service_used,
service_price
)
select distinct 
s.service_used,
s.service_price::numeric
from staging.tembo_hotel_dirty s
where s.service_used is not null;


select * from services.service;


--==========================================================================================================================================================================
