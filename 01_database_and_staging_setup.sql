--=========================================================================================================================================================================

--=========Tembo Hotel & Suites Database============================================================================

--  created on 13 September 2026 by Feddy Mwanjumwa Matata.

--==================================================================================================================

--Section A: Database and staging setup 


create database Tembo_Hotel_Suites;
create schema staging;
create schema hotel;
create schema finance;
create schema staffs;
create schema services;

set search_path to Tembo_Hotel_Suites;



create table staging.tembo_hotel_dirty(
booking_id text,
guest_name text,
guest_phone text,
guest_city  text,
guest_nationality text,
room_no  text,
room_type text,
room_rate_per_night text,
check_in_date text,
check_out_date text,
nights_stayed  text,
staff_name  text,
staff_department text,
staff_salary text,
payment_method text,
booking_status text,
total_amount  text,
service_used  text,
service_price text,
guest_rating  text
);


select * from staging.tembo_hotel_dirty;


select count(*) as total_rows
from staging.tembo_hotel_dirty;




