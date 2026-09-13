

--Section 5: Business analysis 


--==============================================================================================================================================

--BUSINESS ANALYSIS QUESTIONS ------------

1.--Revenue analysis: Total revenue by month, by room type, by payment method

select 
date_trunc('month', b.check_in_date) as month,
sum(p.total_amount) as total_revenue
from hotel.booking b
join finance.payment p
     on b.booking_id = p.booking_id
group by date_trunc('month', b.check_in_date)
order by month;


2.---2.	Occupancy: Which room types are booked most? Average nights stayed per room type

select 
r.room_type,
count(b.booking_id) as total_bookings,
avg(b.nights_stayed) as average_nights
from hotel.booking b
join hotel.room r
     on b.room_id = r.room_id 
group by r.room_type 
order by total_bookings desc;

3.--Guest insights: Top 10 cities guests come from. Average rating per room type

select 
g.guest_city,
count(*) as guest_count
from hotel.guest g
group by g.guest_city
order by  guest_count desc
limit 10;


select 
r.room_type,
avg(s.guest_rating::numeric) as average_rating
from staging.tembo_hotel_dirty s
join hotel.room r
     on s.room_no = r.room_no
group by r.room_type
order by average_rating desc;


4.--Staff performance: Which staff handled the most bookings? Which department generates most revenue?

select
s.staff_name,
count(b.booking_id) as count_of_bookings
from hotel.booking b 
join staffs.staff s
     on s.staff_id = b.staff_id 
group by s.staff_name 
order by count_of_bookings desc
limit 1;
      

select 
st.staff_department,
sum(p.total_amount) as total_revenue
from hotel.booking b
join staffs.staff st
     on  b.staff_id = st.staff_id
join finance.payment p
     on b.booking_id = p.booking_id
 group by st.staff_department
 order by total_revenue desc;



5.--Trends: Revenue growth month over month (window function). Busiest vs quietest months

select 
date_trunc('month', b.check_in_date) as month,
sum(p.total_amount) as total_revenue,
lag(sum(p.total_amount)) over(
       order by date_trunc ('month', b.check_in_date)
       ) as previous_month_revenue,
       sum(p.total_amount) - lag(sum(p.total_amount)) over (
 order by date_trunc('month', b.check_in_date)
    ) as revenue_growth
from hotel.booking b
join finance.payment p
    on b.booking_id = p.booking_id
group by date_trunc('month', b.check_in_date)
order by month;


select
    date_trunc('month', b.check_in_date) as month,
    count(b.booking_id) as total_bookings
from hotel.booking b
group by date_trunc('month', b.check_in_date)
order by total_bookings desc;


6.--Cancellations: Cancellation rate per room type. Revenue lost from cancellations and no-shows


select
    r.room_type,
    count(*) as total_bookings,
    count(*) filter (where b.booking_status = 'Cancelled') as cancelled_bookings,
    round(
        count(*) filter (where b.booking_status = 'Cancelled') * 100.0
        / count(*),
        2
    ) as cancellation_rate
from hotel.booking b
join hotel.room r
    on b.room_id = r.room_id
group by r.room_type
order by cancellation_rate desc;

