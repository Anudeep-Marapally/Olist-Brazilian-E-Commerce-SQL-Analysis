use e_commerce;

-- Checking every table basic information 
-- Customers,items,orders,payments,sellers
-- products,product category,reviews

-- Customers
describe customers;

select count(customer_id) as customers_count from customers;
-- 99441  customers

select customer_id,count(*) as cnt from customers
group by customer_id
having count(*) >1;
-- Response -- 0 row(s) returned
-- Since customer_id is primary key, no id is repeated.

select distinct customer_unique_id,count(*) as unique_cnt from customers
group by customer_unique_id
having count(*)>1;
-- 2997 unique customers have placed more than one order (i.e., they have multiple customer_id values).

select count(distinct customer_unique_id) as unique_customers_count from customers;
-- 96096 unique customers

select distinct customer_unique_id,count(*) as unique_cnt from customers
group by customer_unique_id
having count(*)>1
order by count(*) desc
limit 10;
-- customer_unique_id(8d50f5eadf50201ccdcedfb9e2ac8455) is the most frequent customer(17 times)

describe customers;
-- Checking zip code,city,state
select customer_zip_code_prefix,customer_city,customer_state from customers
limit 5;
select count(distinct customer_zip_code_prefix) as count_of_zip_codes,
	count(customer_city) as count_of_cities from customers;
select customer_zip_code_prefix,count(customer_city) as city_count from customers
group by customer_zip_code_prefix
order by count(customer_city) desc
limit 5;
-- Each zip_code can have multiple cities.

select customer_state,count(*) customers_per_state from customers
group by customer_state
order by count(*) desc
limit 5;
-- SP(sao paulo) state have most number of customers (41746)
-- Rj next state with 12852

describe customers;

describe items;
select * from items
where price < 0 ;
select * from items
where freight_value < 0;
select * from payments
where payment_value < 0;
select * from products
where weight_g < 0
   or length_cm < 0
   or height_cm < 0
   or width_cm < 0
   or photos_qty < 0;

select order_id,count(order_id) as orders_count from items
group by order_id
order by count(order_id) desc
limit 5 ;

select * from items
limit 2;

select order_id,order_item_id,price,freight_value from items
order by price desc
limit 5;

describe orders;

select * from orders
limit 2;

select distinct order_status from orders;

select max(year(order_purchase_timestamp)) as recent_year,
	   min(year(order_purchase_timestamp)) as start_year 
from orders
where order_status = 'Delivered';
-- Orders done between 2016 and 2018

select max(year(order_delivered_customer_date)) as last_year,
	   min(year(order_delivered_customer_date)) as first_year
from orders
where order_status = 'Delivered';

select count(*) from orders
where order_status = 'Delivered';

select round((count(*)/(select count(*) from orders))* 100,2) as delivered_order_percentage from orders
where order_status = 'Delivered';
--  delivered_order_percent is 97.02

select order_status,count(*) as order_status_count,
	   round((count(*)/(select count(*) from orders))*100,3) as percentage 
from orders
group by order_status
order by order_status_count desc;

describe payments;

select distinct payment_type from payments;

select payment_type,count(*) as payment_type_count,
	   round((count(*)/(select count(*) from payments))*100,2) as percentage 
from payments
group by payment_type
order by payment_type_count desc;
-- Most of the users using credit_card to pay with percentage of 73.92

select payment_type,count(*) as payment_type_count,
	   round((count(*)/(select count(*) from payments))*100,2) as transaction_percentage,
       sum(payment_value) as payment_value,
       round((sum(payment_value)/(select sum(payment_value) from payments))*100,2) as revenue_percentage
from payments
group by payment_type
order by payment_type_count desc;

describe payments;
select distinct payment_installments from payments;

describe product_category;

describe products;

select * from products 
limit 2;

select product_id,count(*) from products
group by product_id
having count(*) > 1;

select category_name,count(*) as count_per_category from products
group by category_name
order by count(*) desc
limit 5;


select count(distinct category_name) as category_count from products;
-- 73 categories

describe reviews;
select * from reviews
where review_score not between 1 and 5;

select * from reviews
where review_score is null;

select max(year(creation_date)) as recent_review_year,
	   min(year(creation_date)) as first_review_year
from reviews;

select year(creation_date) as review_year,count(*) as reviws_count
from reviews
group by year(creation_date)
order by count(*) desc;

describe orders;
select max(year(order_purchase_timestamp)) as latest_order_year
from orders;

select year(creation_date) as year_creation,count(*) as reviews_count
from reviews
where year(creation_date) > year(current_date())
group by year(creation_date)
order by count(*);

select count(*) from reviews;

select count(*) from reviews
where creation_date > current_timestamp();

select count(*) as reviews_count,round((count(*)/
(select count(*) from reviews))*100,2) as invalid_reviews,
(select count(*) from reviews) as total_count
from reviews
where creation_date > current_timestamp();

describe reviews;

select creation_date from reviews
where creation_date > current_timestamp()
limit 20;

select current_timestamp();

select count(*) from reviews
where creation_date < '2016-09-04 00:00:00'
  or creation_date > '2026-07-21 00:00:00';

select min(order_purchase_timestamp) as first_order,
	   max(order_purchase_timestamp) as last_order
from orders;

select count(*),(select count(*) from reviews) as total_count,
round((count(*)/(select count(*) from reviews)*100),2) as invalid_percentage
from reviews
where creation_date < '2016-09-04 21:15:00'
  or creation_date > '2018-10-17 17:30:00';
  
select count(*),(select count(*) from reviews) as total_count,
round((count(*)/(select count(*) from reviews)*100),2) as invalid_percentage
from reviews
where creation_date < '2016-09-04 21:15:00'
  or creation_date > '2026-07-21 21:33:00';
  
describe reviews;
select creation_date from reviews
limit 5;
describe orders;

select order_approved_at from orders
where year(order_approved_at) < 2016
or year(order_approved_at) >2018;

select order_purchase_timestamp from orders
where year(order_purchase_timestamp) < 2016
or year(order_purchase_timestamp) >2018;

select order_delivered_carrier_date from orders
where year(order_delivered_carrier_date) < 2016
or year(order_delivered_carrier_date) >2018;

select order_delivered_customer_date from orders
where year(order_delivered_customer_date) < 2016
or year(order_delivered_customer_date) >2018;

select order_estimated_delivery_date from orders
where year(order_estimated_delivery_date) < 2016
or year(order_estimated_delivery_date) >2018;


select creation_date from reviews
order by creation_date desc
limit 20;

describe items;
select shipping_limit_date from items
where year(shipping_limit_date) < 2016
or year(shipping_limit_date) >2018;

describe payments;
describe sellers;

-- problem with items table and reviews table

1drop table items;
1drop table reviews;

describe reviews;
select max(year(review_creation_date)) as recent_review_year,
	   min(year(review_creation_date)) as first_review_year
from reviews;

select year(review_creation_date) as review_year,count(*) as reviws_count
from reviews
group by year(review_creation_date)
order by count(*) desc;

describe orders;
select max(year(order_purchase_timestamp)) as latest_order_year
from orders;

select year(review_creation_date) as year_creation,count(*) as reviews_count
from reviews
where year(review_creation_date) > year(current_date())
group by year(review_creation_date)
order by count(*);

select count(*) from reviews;

select count(*) from reviews
where review_creation_date > current_timestamp();

select count(*) as reviews_count,round((count(*)/
(select count(*) from reviews))*100,2) as invalid_reviews,
(select count(*) from reviews) as total_count
from reviews
where review_creation_date > current_timestamp();

describe reviews;

select review_creation_date from reviews
where review_creation_date > current_timestamp()
limit 20;

select current_timestamp();

select count(*) from reviews
where creation_date < '2016-09-04 00:00:00'
  or creation_date > '2026-07-21 00:00:00';

use e_commerce;
describe orders;
select count(*) from orders
where order_status = 'Canceled';

describe items;
select i.seller_id as seller_id,
count(o.order_id) as orders_count from orders o
join items i on o.order_id = i.order_id
where o.order_status = 'Canceled'
group by i.seller_id
order by count(o.order_id) desc;

describe customers;

select c.customer_state as customer_state,
count(o.order_id) as orders_count,
(round((count(o.order_id)/(select count(*) from orders
where order_status = 'Canceled'))*100,2)) as percentage
from customers c join orders o
on c.customer_id = o.customer_id
where o.order_status = 'Canceled'
group by c.customer_state
order by count(o.order_id) desc;
describe orders;
With monthly as (
select date_format(order_purchase_timestamp,'%Y-%m-01') as month_year,
	count(order_id) as orders_count from orders
    where order_status = 'Canceled'
    group by date_format(order_purchase_timestamp,'%Y-%m-01')
)
select month_year,orders_count,
round((orders_count/(select sum(orders_count) from monthly))*100,2) as percentage
from monthly
group by month_year
order by percentage desc;

With yearly as (
select date_format(order_purchase_timestamp,'%Y-01-01') as year,
	count(order_id) as orders_count from orders
    where order_status = 'Canceled'
    group by date_format(order_purchase_timestamp,'%Y-01-01')
)
select year,orders_count,
round((orders_count/(select sum(orders_count) from yearly))*100,2) as percentage
from yearly
group by year
order by percentage desc;

select count(order_id) as orders_count from orders
where order_status = 'Canceled';


select count(distinct customer_city) as city_Count,
count(distinct customer_state) as state_count from customers;













