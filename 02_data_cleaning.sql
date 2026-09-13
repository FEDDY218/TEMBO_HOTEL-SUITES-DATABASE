
--=====SECTION B: DATA CLEANING =============================


--==========CHECKING ON COLUMNS THAT NEED CLEANING ===============================================================

select distinct booking_id
from staging.tembo_hotel_dirty
order by booking_id;  --# Nothing to clean here.


select distinct guest_name
from staging.tembo_hotel_dirty
order by guest_name;  --# Inconsistent casing and spacing


select distinct guest_phone
from staging.tembo_hotel_dirty 
order by guest_phone;  --# Some numbers start with "07" while others start with "+254", others have "-" between the numbers. Some are blank(no number)


select distinct guest_city
from staging.tembo_hotel_dirty
order by guest_city; --# Inconsistent casing, some are blank


select distinct guest_nationality
from staging.tembo_hotel_dirty 
order by guest_nationality; --# Nothing to clean here


select distinct room_no 
from staging.tembo_hotel_dirty 
order by room_no; --# nothing to clean here


select distinct room_type
from staging.tembo_hotel_dirty 
order by room_type; --# inconsistent casing(deluxe, DLX, standard,std,)


select distinct room_rate_per_night
from staging.tembo_hotel_dirty 
order by room_rate_per_night; --# nothing to clean here


select distinct check_in_date
from staging.tembo_hotel_dirty 
order by check_in_date;  --# Different date formats (01-12-2024, 05/05/2024, 07-18-2023, 06-09-24, 2023-06-12)


select distinct check_out_date
from staging.tembo_hotel_dirty 
order by check_out_date;--# Different date formats (01-17-2024, 02-03-24, 09/03/2024, 2023-07-19, 30-11-24)


select distinct nights_stayed
from staging.tembo_hotel_dirty 
order by nights_stayed; -- # Nothing to clean here 


select distinct staff_name 
from staging.tembo_hotel_dirty 
order by staff_name; ---# Nothing to clean here 


select distinct staff_department
from staging.tembo_hotel_dirty 
order by staff_department; --# nothing to clean here 


select distinct staff_salary
from staging.tembo_hotel_dirty 
order by staff_salary; --# nothing to clean here



select distinct payment_method
from staging.tembo_hotel_dirty 
order by payment_method; --# inconsistent casing (mpesa,M-Pesa)


select distinct booking_status
from staging.tembo_hotel_dirty 
order by booking_status; --# inconsistent casing (checked out, Checked Out)


select distinct total_amount
from staging.tembo_hotel_dirty 
order by total_amount; --# inconsistent format ( KES 75000, 9300, 8,500, ",")


select distinct service_used 
from staging.tembo_hotel_dirty 
order by service_used; --# nothing to clean here


select distinct service_price
from staging.tembo_hotel_dirty 
order by service_price; --# nothing to clean here


select distinct guest_rating
from staging.tembo_hotel_dirty 
order by guest_rating; --# nothing to clean here 



--===================CLEANING THE COLUMNS ==============================================================================

--The guest_name column contains inconsistent capitalization and unnecessary leading, trailing, or repeated spaces.
-- This can cause the same guest to appear as different records during analysis.

update staging.tembo_hotel_dirty 
set guest_name = initcap(trim(guest_name));--#I am removing the spaces using trim  and standardizing names using initcap


select distinct guest_name
from staging.tembo_hotel_dirty 
order by guest_name;



--The guest_phone column contains inconsistent phone number formats, some numbers use local "07" while others use the international "+254" format.
--Some numbers contain hyphens and some records have missing phone numbers.
-- Am going to remove unnecessary separators and convert the'+254' to the local '07'. Missing numbers will be treated as NULL

update staging.tembo_hotel_dirty 
set guest_phone = replace(replace(trim(guest_phone), '-', ''),' ', ''); --# I have removed the spaces and hyphens

update staging.tembo_hotel_dirty
set guest_phone = '0' || substring (guest_phone from 5)
where guest_phone like '+254%'; --# i have changed the '+254' format  to '07' format

update staging.tembo_hotel_dirty 
set guest_phone = null
where trim(guest_phone) = ''; --# I have removed the blanks and put them to NULL


select distinct guest_phone
from staging.tembo_hotel_dirty 
order by guest_phone;


--The guest_city contains blanks and has inconsistent casing

update staging.tembo_hotel_dirty
set guest_city = initcap(trim(guest_city)); --# removes the inconsistent casing and spaces

update staging.tembo_hotel_dirty 
set guest_city = null
where trim(guest_city) = ''; --# removes the blanks and changes them to NULL

select distinct guest_city
from staging.tembo_hotel_dirty
order by guest_city;



--The room_type contains inconsistent casing

update staging.tembo_hotel_dirty
set room_type = initcap(room_type);

update staging.tembo_hotel_dirty 
set room_type = 'Standard'
where lower(trim(room_type)) = 'std';

update staging.tembo_hotel_dirty 
set room_type = 'Deluxe'
where lower(trim(room_type)) ='dlx';

select distinct room_type
from staging.tembo_hotel_dirty
order by room_type;


--In check_in_date there are different date formats (01-12-2024, 05/05/2024, 07-18-2023, 06-09-24, 2023-06-12) 
-- So i have to standardize all valid dates into a single date format.

--converting slash (/) dates to yyyy-mm-dd

update staging.tembo_hotel_dirty
set check_in_date= 
    case 
      	when split_part(check_in_date, '/', 1)::int > 12
      	    then TO_CHAR(to_date(check_in_date,'dd/mm/yyyy'),'yyyy-mm-dd')
      	else TO_CHAR(to_date(check_in_date, 'mm/dd/yyyy'),'yyyy-mm-dd')
    END
where check_in_date ~ '^\d{2}/\d{2}/\d{4}$';
      

--Converting MM-DD-YYYY to yyyy-mm-dd

update staging.tembo_hotel_dirty
set check_in_date =
    to_char(to_date (check_in_date, 'mm-dd-yyyy'), 'yyyy-mm-dd')
where check_in_date ~ '^\d{2}-\d{2}-\d{4}$';


--Convert MM-DD-YY to yyyy-mm-dd

update staging.tembo_hotel_dirty
set check_in_date =
    to_char(to_date(check_in_date, 'dd-mm-yy'), 'yyyy-mm-dd')
where check_in_date ~ '^\d{2}-\d{2}-\d{2}$';


select distinct check_in_date
from staging.tembo_hotel_dirty 
order by check_in_date;




----In check_out_date there are different date formats (01-17-2024, 02-03-24, 09/03/2024, 2023-07-19, 30-11-24) 
-- So i have to standardize all valid dates into a single date format.
    
--Convrting slash dates to yyyy-mm-dd

update staging.tembo_hotel_dirty 
set check_out_date =
    case 
    	when split_part(check_out_date,'/', 1)::int >12
    	     then to_char(to_date(check_out_date, 'dd/mm/yyyy'),'yyyy-mm-dd')
    	  else to_char(to_date(check_out_date, 'mm/dd/yyyy'), 'yyyy-mm-dd')
    end
where check_out_date ~ '^\d{2}/\d{2}/\d{4}$';


--Converting MM-DD-YYY to YYYY-MM-DD

update staging.tembo_hotel_dirty
set check_out_date =
    to_char(to_date(check_out_date, 'mm-dd-yyyy'),'yyyy-mm-dd')
where check_out_date ~ '^\d{2}-\d{2}-\d{4}$';


--Converting MM-DD-YY

update staging.tembo_hotel_dirty 
set check_out_date =
    to_char(to_date(check_out_date, 'dd-mm-yy'), 'yyyy-mm-dd')
where check_out_date ~ '^\d{2}-\d{2}-\d{2}$';


select distinct check_out_date
from staging.tembo_hotel_dirty 
order by check_out_date;


--- In payment_method there is inconsistent casing like M-Pesa and mpesa

update staging.tembo_hotel_dirty
set payment_method = replace(payment_method, 'mpesa','M-Pesa');

select distinct payment_method
from staging.tembo_hotel_dirty 
order by payment_method;


---In booking_status there is inconsitent casing (checked out, Checked Out)

update staging.tembo_hotel_dirty
set booking_status = replace(booking_status, 'checked out','Checked Out');

select distinct booking_status
from staging.tembo_hotel_dirty 
order by booking_status;


--The total_amount column contains inconsistent formats. 
--Some values include the KES currency prefix, some contain commas, and some are stored as plain numbers.
--There are also missing values represented by ",".

update staging.tembo_hotel_dirty
set total_amount = replace(replace(trim(total_amount),'KES ', ''), ',' , '');

UPDATE staging.tembo_hotel_dirty
SET total_amount = NULL
WHERE TRIM(total_amount) = '';

SELECT DISTINCT total_amount
FROM staging.tembo_hotel_dirty
ORDER BY total_amount;


