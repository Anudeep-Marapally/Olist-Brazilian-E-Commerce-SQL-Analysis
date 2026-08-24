use e_commerce;

-- Total Revenue
select sum(p.payment_value) as total_revenue from payments p
join orders o
on p.order_id = o.order_id
where o.order_status = 'Delivered';
-- Total Revenue = 15422461.77

-- Total Orders
select count(*) as total_orders from orders
where order_status = 'Delivered';
-- Total Orders = 96478

-- Orders by month
select date_format(order_purchase_timestamp, '%Y-%m') as month_year,
count(*) as orders_count from orders
where order_status = 'Delivered'
group by date_format(order_purchase_timestamp, '%Y-%m')
order by orders_count desc;
-- November 2017 got the highest orders i.e., 7289


-- Total Unique Customers
select count(distinct customer_unique_id) as count from customers;

-- Total Unique Customers = 96096

-- Customer lifetime value
with customers as(
select c.customer_unique_id as customer_unique_id,
sum(i.price) as total_value,
count(c.customer_id) as orders_count from orders o
join customers c on c.customer_id = o.customer_id
join items i on o.order_id = i.order_id
where o.order_status = 'Delivered'
group by c.customer_unique_id
order by total_value asc
)
select customer_unique_id,total_value,orders_count from customers;
-- customer_unique_id 0a0a92112bd4c708ca5fde585afaa872 did total_value of 13440 BLR(brazil currency) with 8 orders
-- customer_unique_id d80730c15c647bc8f2ad77c908ba5ca9 did total_value of 0.85 BLR with 1 order

-- Which month has highest first_purchase count
with month_year as(
select c.customer_unique_id as customer_unique_id,
min(o.order_purchase_timestamp) as first_order
from customers c join orders o 
on c.customer_id = o.customer_id
where o.order_status = 'Delivered'
group by c.customer_unique_id)
select date_format(first_order, '%Y-%m') as month_year,count(*) as orders_count from month_year
group by date_format(first_order, '%Y-%m')
order by orders_count desc;
-- 2017_november got the first_order count with 7060 orders

-- By this most of the orders donw in november 2017 did by new customers or first orders

-- Average Order Value
select sum(p.payment_value) as payment_value,
	   count(distinct o.order_id) as total_orders,
round((sum(p.payment_value))/(count(distinct o.order_id)),2) as average_order_value
from payments p join orders o
on o.order_id = p.order_id
where o.order_status = 'Delivered';
-- average order value 159.86

-- Total Products Sold
describe products;
select count(distinct i.product_id) as products_count from items i
join orders o on o.order_id = i.order_id
where o.order_status = 'Delivered';
-- Total products are 32216

select count(i.product_id) as products_count from items i
join orders o on o.order_id = i.order_id
where o.order_status = 'Delivered';
-- Total products delivered are 110197

-- Total Sellers
select count(seller_id) as total_sellers from sellers;
-- Total sellers were 3095

select count(distinct s.seller_id) as total_sellers from sellers s
join items i on i.seller_id = s.seller_id
join orders o on i.order_id = o.order_id
where o.order_status = 'Delivered';
-- Total sellers were 2970 whose products got delivered

-- Orders by Status
select order_status,count(*) as order_Count from orders
group by order_status
order by count(*) desc;

-- Revenue by Payment Type
describe payments;

select payment_type,
count(distinct order_id) as number_of_transactions
from payments
group by payment_type
order by count(distinct order_id) desc;


-- Average Delivery Time
describe orders;

select count(order_id) from orders
where order_approved_at > order_delivered_carrier_date;

select order_id,order_approved_at,
order_delivered_carrier_date from orders
where order_approved_at > order_delivered_carrier_date;

select round((count(order_id)/(select count(order_id) from orders))*100,2)
as invalid_rows_percentage from orders
where order_approved_at > order_delivered_carrier_date;

use e_commerce;

select order_id,order_approved_at,
order_delivered_carrier_date from orders
where order_approved_at > order_delivered_carrier_date;

select order_id,order_approved_at,
order_delivered_carrier_date,
timestampdiff(minute,order_approved_at,order_delivered_carrier_date) as mins,
timestampdiff(hour,order_approved_at,order_delivered_carrier_date) as hours,
timestampdiff(day,order_approved_at,order_delivered_carrier_date) as days
from orders
where order_approved_at < order_delivered_carrier_date
group by order_id,order_approved_at,order_delivered_carrier_date
order by mins
limit 5;

select avg(timestampdiff(second,order_approved_at,order_delivered_carrier_date)) as avg_in_seconds
from orders
where order_approved_at < order_delivered_carrier_date;

select avg(timestampdiff(Hour,order_approved_at,order_delivered_carrier_date)) as avg_in_hours
from orders
where order_approved_at < order_delivered_carrier_date
and order_status = 'Delivered';

select avg_in_seconds,round(avg_in_seconds/60,2) as avg_in_mins,
round(avg_in_seconds/(60*60),2) as avg_in_hours,
round(avg_in_seconds/(60*60*24),2) as avg_in_days from(
select avg(timestampdiff(second,order_approved_at,order_delivered_carrier_date)) as avg_in_seconds
from orders
where order_approved_at < order_delivered_carrier_date)p;

-- Monthly Revenue Trend
select date_format(o.order_purchase_timestamp, '%Y') as Year,
date_format(o.order_purchase_timestamp, '%m') as Month_number,
date_format(o.order_purchase_timestamp, '%M') as Month,
round(sum(p.payment_value),2) as monthly_Revenue
from orders o
join payments p on o.order_id = p.order_id
where o.order_status = 'Delivered'
group by date_format(o.order_purchase_timestamp, '%Y'),
date_format(o.order_purchase_timestamp, '%m'),
date_format(o.order_purchase_timestamp, '%M')
order by Monthly_revenue desc;
-- 2017 November has highest revenue with 1153393.22 BLR

-- Customer Analysis 
describe customers;
-- Who are the top customers?  
select c.customer_unique_id as customer_unique_id,
count(*) as count from customers c
group by customer_unique_id
order by count desc 
limit 5;

-- Which states generate the highest revenue?  
select s.seller_city as city,sum(i.price) as Total_revenue from items i 
join sellers s on s.seller_id = i.seller_id
join orders o on o.order_id = i.order_id
where o.order_status = 'Delivered'
group by s.seller_city
order by sum(i.price) desc
limit 1;
-- Sao paulo generated highest revenue i.e., 2625634.52

describe orders;
-- New vs. Repeat Customers 
with new as (select c.customer_unique_id as customer_unique_id,
o.order_purchase_timestamp,
row_number()over(partition by c.customer_unique_id 
order by o.order_purchase_timestamp ) as rn
from customers c join orders o
on c.customer_id = o.customer_id
)
select year(order_purchase_timestamp) as year,
month(order_purchase_timestamp) as month,
count(case when rn = 1 then 1 end ) as recent_customers,
count(case when rn > 1 then 1 end ) as Old_customers
from new
group by year(order_purchase_timestamp),
		 month(order_purchase_timestamp)
order by recent_customers desc ,old_customers desc;
-- 2017 November got most number of new use customer


-- Customer Lifetime Value  
select c.customer_unique_id as customer_unique_id,
sum(p.payment_value) as Total_purchase 
 from customers c
join orders o on o.customer_id = c.customer_id
join payments p on o.order_id = p.order_id
where o.order_status = 'Delivered'
group by c.customer_unique_id
order by Total_purchase desc 
limit 5;
-- customer_unique_id 0a0a92112bd4c708ca5fde585afaa872 did 13664.08 total purchase
select order_id from orders o join 
customers c on c.customer_id = o.customer_id
where customer_unique_id =  '0a0a92112bd4c708ca5fde585afaa872'; 

-- Customer Retention
with customer_month as(
select distinct c.customer_unique_id as customer_unique_id,
date_format(o.order_purchase_timestamp, '%Y-%m-01') as purchase_month
from customers c join orders o on o.customer_id = c.customer_id
where o.order_status = 'Delivered'),
retention as (select customer_unique_id,purchase_month,
lead(purchase_month) over(partition by customer_unique_id
order by purchase_month) as next_month_purchase
from customer_month)
select * from retention
where next_month_purchase=date_add(purchase_month, interval 1 month);
-- 471 unique customers did orders in back to back months


with customer_orders as(
select c.customer_unique_id as customer_unique_id,o.order_id as order_id,
date_format(o.order_purchase_timestamp, '%Y-%m-01') as order_month
from customers c join orders o on c.customer_id = o.customer_id
where o.order_status = 'Delivered'),
first_purchase as (select customer_unique_id ,
min(order_month) as cohort_month from customer_orders
group by customer_unique_id),
retention as (select f.cohort_month,o.order_month,
count(distinct o.customer_unique_id) as retained_customers
from first_purchase f join customer_orders o
on f.customer_unique_id = o.customer_unique_id
where o.order_month > f.cohort_month
group by f.cohort_month,o.order_month),
cohort_size as (select cohort_month,count(*) as total_customers
from first_purchase
group by cohort_month)
select r.cohort_month,r.order_month,
r.retained_customers,c.total_customers,
round(r.retained_customers *100.0 / c.total_customers,2) as retention_rate
from retention r join cohort_size c
on r.cohort_month = c.cohort_month
order by r.cohort_month,
r.order_month;

-- Product Analysis 

-- Best-selling products  
select p.product_id as product_id,
pc.product_category_english as product_category,
sum(i.price) as revenue,
count(p.product_id) as count,
round(sum(i.price)/count(p.product_id),2) as avg_price_per_product from items i 
join products p on p.product_id = i.product_id
join orders o on i.order_id = o.order_id
join product_category pc on pc.product_category = p.category_name
where o.order_status = 'Delivered'
group by p.product_id,pc.product_category_english
order by count desc
limit 5;
--  aca2eb7d00ea1a7b8ebd4e68314663af product_id with count 520

-- Highest revenue products 
select p.product_id as product_id,
pc.product_category_english as product_category,
sum(i.price) as revenue,
count(p.product_id) as count,
round(sum(i.price)/count(p.product_id),2) as avg_price_per_product from items i 
join products p on p.product_id = i.product_id
join orders o on i.order_id = o.order_id
join product_category pc on pc.product_category = p.category_name
where o.order_status = 'Delivered'
group by p.product_id,pc.product_category_english
order by revenue desc
limit 5; 
--  bb50f2e236e5eea0100680137654686c product_id has highest revenue with 63560

-- Category-wise revenue
select pc.product_category_english as product_category,
sum((i.price + i.freight_value)) as Revenue_generated 
from products p join items i on i.product_id = p.product_id
join product_category pc on p.category_name = pc.product_category
group by pc.product_category_english
order by Revenue_generated desc;
-- Watches_gifts and health_beauty are generating more revenue other categories

describe orders;

-- Slow-moving products  
select p.product_id as product_id,pc.product_category as product_name,
avg(timestampdiff(Hour,o.order_purchase_timestamp,o.order_delivered_customer_date)) as hours
from products p join items i on i.product_id = p.product_id
join product_category pc on pc.product_category = p.category_name
join orders o on o.order_id = i.order_id
where o.order_approved_at < order_delivered_customer_date
and o.order_approved_at is not null
and o.order_status = 'Delivered'
group by product_id,pc.product_category
order by hours desc;

-- Product size vs. freight cost  
describe products;
describe items;
select p.product_id as product_id,
pc.product_category_english as product_name,
(p.length_cm * p.width_cm * p.height_cm) as volume_cm3,
round(avg(i.freight_value),2) as freight_value
from products p join items i on i.product_id = p.product_id
join product_category pc on pc.product_category = p.category_name
group by p.product_id,(p.length_cm * p.width_cm * p.height_cm)
order by freight_value desc,
volume_cm3 desc;

select 
case 
when (p.length_cm * p.width_cm * p.height_cm) < 500 then 'Small'
when (p.length_cm * p.width_cm * p.height_cm) < 2000 then 'Medium'
else 'Large' end as product_size,
round(avg(i.freight_value),2) as avg_freight_value,
count(*) as total_orders
from products p join items i 
on p.product_id = i.product_id
group by product_size
order by avg_freight_value ;
-- medium and small product_sizes are almost having same freight_value


-- Seller Analysis 
describe sellers;
-- Top-performing sellers  
select i.seller_id as seller_id, count(o.order_id) as orders_count
from items i join orders o on o.order_id = i.order_id
where o.order_status = 'Delivered'
group by i.seller_id
order by count(o.order_id) desc
limit 1;
-- seller_id with 6560211a19b47992c3666cc44a7e94c0 has 1996 orders

describe sellers;

-- Sellers with highest ratings  
select i.seller_id as seller_id,
round(avg(r.review_score),2) as review_score
from orders o join reviews r on o.order_id = r.order_id
join items i on i.order_id = o.order_id
where o.order_status = 'Delivered'
group by i.seller_id
order by review_score desc
limit 5;

-- Sellers with late deliveries  
select i.seller_id as seller_id ,count(*)
from orders o join items i on i.order_id = o.order_id
where o.order_estimated_delivery_date < o.order_delivered_customer_date
and o.order_status = 'Delivered'
group by i.seller_id
order by count(*) desc
limit 5;

-- Seller revenue contribution  
select i.seller_id,sum(i.price) as revenue
from items i join orders o on i.order_id = o.order_id
where o.order_status = 'Delivered'
group by seller_id
order by revenue desc
limit 5;

-- Average Freight Charged by Seller
select i.seller_id,round(avg(i.freight_value),2) as avg_value
from items i join orders o on i.order_id = o.order_id
where o.order_status = 'Delivered'
group by i.seller_id
order by avg_value desc
limit 5;

select i.seller_id,round(avg(i.freight_value),2) as avg_value
from items i join orders o on i.order_id = o.order_id
where o.order_status = 'Delivered'
group by i.seller_id
order by avg_value
limit 5;

-- Average Order Value (AOV) by Seller
select i.seller_id as seller_id,
round(avg(price + freight_Value),2) as avg_order_value
from orders o join items i on i.order_id = o.order_id
group by i.seller_id
order by avg_order_value desc;

-- Number of Unique Customers Served by Each Seller
select i.seller_id,count(c.customer_unique_id) as unique_customers_count
from items i join orders o on i.order_id = o.order_id
join customers c on c.customer_id = o.customer_id
where o.order_status = 'Delivered'
group by i.seller_id
order by unique_customers_count desc;

-- Average Delivery Time by Seller
select i.seller_id as seller_id,
round(avg(timestampdiff(Minute,order_purchase_timestamp,order_delivered_customer_date)),2) as hours_to_deliver
from items i join orders o on i.order_id = o.order_id
where o.order_status = 'Delivered'
group by i.seller_id
order by hours_to_deliver;
describe orders;

-- Logistics Analysis 
describe orders;
select * from orders
limit 2;
-- Average shipping time
select
round(avg(timestampdiff(Day,order_delivered_carrier_date,order_delivered_customer_date)),2) 
as avg_shipping_time_in_days from orders
where order_approved_at < order_delivered_customer_date
and order_status = 'Delivered';

-- Delivery delays  
select count(*) as delayed_orders_count,(select count(*) from orders
where order_status = 'Delivered') as total_orders,
round((count(*)/(select count(*) from orders
where order_status = 'Delivered'))*100,2) as
delayed_orders_percentage from orders
where order_delivered_customer_date > order_estimated_delivery_date
and order_status = 'Delivered';
-- Delayed_order_percentage is 8.11

-- Which states have the longest delivery? 
select s.seller_state as state,
round(avg(timestampdiff(Day,o.order_delivered_carrier_date,o.order_delivered_customer_date)),2) 
as avg_shipping_time_in_days from items i
join sellers s on i.seller_id = s.seller_id
join orders o on o.order_id = i.order_id
where order_approved_at < order_delivered_customer_date
and order_status = 'Delivered'
group by s.seller_state
order by avg_shipping_time_in_days desc
limit 5;
-- AM code state have 44 days 
-- Other state avg was below 14.50


-- Month to Month
with value as (
select date_format(o.order_purchase_timestamp, '%Y-%m-01') as month_year,
round(sum(i.price),2) as Revenue from orders o
join items i on o.order_id = i.order_id
where o.order_purchase_timestamp > '2017-01-01'
group by date_format(o.order_purchase_timestamp, '%Y-%m-01'))
select month_year as month,
revenue,lag(revenue) over(order by month_year) as previous_month_revenue,
round(
(revenue - lag(revenue) over(order by month_year))/lag(revenue) over(order by month_year)*100,2) 
as Month_growth_percent
from value;
-- Since 2016 data was inconsistent i excluded 2016 data

-- Running total
with revenue as (
select date_format(o.order_purchase_timestamp, '%Y-%m-01') as month_year,
sum(i.price) as total_revenue from orders o
join items i on i.order_id = o.order_id
group by date_format(o.order_purchase_timestamp, '%Y-%m-01'))
select month_year,total_revenue,
sum(total_revenue)over(order by month_year) as running_total
from revenue;

-- RFM Analysis
select max(order_purchase_timestamp) from orders;
With rfm as (
select c.customer_unique_id as customer_unique_id,
timestampdiff(Day,max(o.order_purchase_timestamp),'2018-10-17 17:30:00')
as recent,count(distinct o.order_id) as orders_count,
sum(i.price + i.freight_value) as revenue from orders o
join customers c on o.customer_id = c.customer_id
join items i on i.order_id = o.order_id
where o.order_status = 'Delivered'
group by c.customer_unique_id),
quartile as(
select *,ntile(4) over(order by recent asc) as recency_score,
ntile(4) over(order by orders_count desc) as  frequency_score,
ntile(4) over(order by revenue desc) as monetary_score from rfm),
rfm1 as (
select*,concat(recency_score,frequency_score,monetary_score) as rfm from quartile),
naming as(select *,case
when rfm = '444' then 'Best_customers'
when rfm in ('443', '434') then 'Loyal Customers'
when rfm in ('441','442') then 'Big_spenders' 
when rfm in ('344','334','333') then 'Potential Loyalists'
when rfm in ('211','222','212') then 'Needs Attention' 
when rfm = '111'  then 'Lost Customers' else 'Others'
end as Segment from rfm1)
select segment,count(*) as customers,
round((count(*)/(select count(*) from naming))*100,2)
as segment_percentage,sum(revenue) as revenue,
round(sum(revenue)/(select sum(revenue) from naming)*100,2)
as segment_revenue_percentage from naming
group by segment
order by revenue desc;

create view Delivered_orders as (select * from orders
where order_status = 'Delivered');

-- Cohort Analysis
with first_purchase as (select c.customer_unique_id as customer_unique_id,
min(do.order_purchase_timestamp) as first_purchase from delivered_orders do 
join customers c on c.customer_id = do.customer_id
group by c.customer_unique_id),
cohort as (select c.customer_unique_id as customer_unique_id,
date_format(fp.first_purchase,'%Y-%m-01') as first_purchase_month,
date_format(do.order_purchase_timestamp, '%Y-%m-01') as purchase_month
from customers c join first_purchase fp on c.customer_unique_id = fp.customer_unique_id
join delivered_orders do on do.customer_id = c.customer_id
),
cohort_ as (
select customer_unique_id,first_purchase_month,
purchase_month,
timestampdiff(month,first_purchase_month,purchase_month) as cohort_number 
from cohort)
select first_purchase_month AS cohort_month,
    cohort_number AS month_number,
count(distinct customer_unique_id) AS customers,
round(count(distinct customer_unique_id) /
max(count(distinct customer_unique_id)) OVER (
partition by  first_purchase_month) * 100,2) AS retention_rate
from cohort_
group by first_purchase_month,cohort_number
order by first_purchase_month,cohort_number;


















