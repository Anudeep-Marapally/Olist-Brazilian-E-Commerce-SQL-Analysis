create database E_Commerce;
use E_commerce;
select count(*) from customers;
select * from customers
limit 10;

select count(*) from order_payments;
select * from order_payments;
select * from customers
limit 5;
describe customers;
alter table customers
modify column customer_id varchar(50) primary key,
modify column customer_unique_id varchar(50),
modify column customer_zip_code_prefix int,
modify column customer_city varchar(50),
modify column customer_state varchar(50); 

-- Checking nulls

select count(*) - count(customer_id) as customer_id_nulls_count,
count(*) - count(customer_unique_id) as customer_unique_nulls_count,
count(*) - count(customer_zip_code_prefix) as zip_code_nulls_count,
count(*) - count(customer_city) as city_nulls_count,
count(*) - count(customer_state) as state_nulls_counts 
from customers;

select * from order_items
limit 5;
alter table order_items
modify column order_id varchar(50),
modify column order_item_id int,
modify column product_id varchar(50),
modify column seller_id varchar(50),
modify column shipping_limit_date datetime,
modify column price int,
modify column freight_value decimal(10,2) default 0;

-- Checking nulls 
select count(*) - count(order_id) as order_id_nulls_count,
count(*) - count(order_item_id) as order_item_id_nulls_count,
count(*) - count(product_id) as product_id_nulls_count,
count(*) - count(seller_id) as seller_id_nulls_count,
count(*) - count(shipping_limit_date) as shipping_limit_date_nulls_counts,
count(*) - count(price) as price_nulls_count,
count(*) - count(freight_value) as freight_value_nulls_count
from order_items;

select count(*) from order_items
where price < 0 
or freight_Value < 0;
select max(price) as max_price,
max(freight_value) as max_frieght_Value,
min(price) as min_price,
min(freight_value) as min_freight_value
from order_items;

select * from order_items
where freight_value = 0;

alter table order_items
add primary key (order_id);

select * from order_items 
limit 10;
select order_item_id,count(order_item_id) as count from order_items
group by order_item_id
having count(order_item_id) > 1;

select * from order_payments
limit 5;
rename table order_items to items;
rename table order_payments to payments;
rename table product_category_name_translation to product_category;

select * from orders
limit 5 offset 5;
alter table orders
modify column customer_id varchar(50),
modify column order_status varchar(20);

-- Remaining columns are not in correct constraint
set sql_safe_updates = 0 ; 
update orders
set order_purchase_timestamp= 
str_to_date(order_purchase_timestamp,'%d-%m-%Y %H:%i');

set sql_safe_updates = 1;

describe orders;

set sql_safe_updates = 0;

update orders
set order_purchase_timestamp =
str_to_date(order_purchase_timestamp, "%Y-%m-%d %H:%i:%s");
alter table orders
modify order_purchase_timestamp datetime;
select * from orders
limit 10;
update orders
set order_approved_at =
str_to_date(order_approved_at, "%d-%m-%y %H:%i");

SELECT order_approved_at
FROM orders
WHERE STR_TO_DATE(order_approved_at, '%d-%m-%y %H:%i') IS NULL
AND order_approved_at IS NOT NULL
limit 20 offset 80;
update orders
set order_approved_at = NULL
where order_approved_at = '';
select * from orders
limit 2;
update orders
set order_approved_at = 
str_to_date(order_approved_at, '%d-%m-%Y %H:%i');
alter table orders
modify column order_approved_at datetime;
select * from orders
limit 10;
select count(*) from orders 
where order_delivered_carrier_date ='';
update orders
set order_delivered_carrier_date= order_delivered_carrier_date is null
where order_delivered_carrier_date ='';
select count(*) from orders
where order_delivered_carrier_date = 0;
update orders
set  order_delivered_carrier_date = null 
where order_delivered_carrier_date = 0;
update orders
set order_delivered_carrier_date = 
str_to_date(order_delivered_carrier_date, '%d-%m-%Y %H:%i');
alter table orders
modify column order_delivered_carrier_date datetime;

select * from orders
limit 10;
update orders
set order_delivered_customer_date =
str_to_date(order_delivered_customer_date, '%d-%m-%y %H:%i');
select count(*) from orders
where order_delivered_customer_date = 0;
update orders
set order_delivered_customer_date = null
where order_delivered_customer_date = 0;

update orders
set order_delivered_customer_date = 
str_to_date(order_delivered_customer_date, '%d-%m-%y %H:%i');
alter table orders
modify column order_delivered_customer_date datetime;
select * from orders
limit 10;
update orders
set order_estimated_delivery_date = 
str_to_date(order_estimated_delivery_date, '%d-%m-%y %H:%i');
alter table orders
modify column order_estimated_delivery_date datetime;
describe payments;
select * from payments
limit 10;

alter table payments
modify column order_id varchar(50),
modify column payment_sequential int,
modify column payment_type varchar(20),
modify column payment_installments int,
modify column payment_value decimal(8,2);

select * from  product_category
limit 1 offset 25;
alter table product_category
rename column ï»¿product_category_name to product_category;
alter table product_category
rename column product_category_name_english to product_category_english;
alter table product_category
modify column product_category varchar(50),
modify column product_category_english varchar(50);

select * from products 
limit 2;
alter table products
rename column product_category_name to category_name,
rename column product_description_lenght to description_length,
rename column product_photos_qty to photos_qty,
rename column product_weight_g to weight_g,
rename column product_length_cm to length_cm,
rename column product_height_cm to height_cm,
rename column product_width_cm to width_cm;
alter table products
modify column  product_id varchar(50),
modify column category_name varchar(50),
modify column product_name_lenght int,
modify column description_length int,
modify column photos_qty int,
modify column weight_g int,
modify column length_cm int,
modify column height_cm int,
modify column width_cm int;
select count(*) from products;
drop table products;

select * from sellers
limit 5;
alter table sellers
modify column seller_id varchar(50),
modify column seller_zip_code_prefix int,
modify column seller_city varchar(50),
modify column seller_state varchar(5);


select customer_id,count(customer_id) from customers
group by customer_id
having count(customer_id) > 1;

describe items;
select * from items
limit 5;
select order_id,count(order_id) from items
group by order_id
having count(order_id) > 1;

select product_id,count(product_id) from items
group by product_id
having count(product_id) > 1;

select order_item_id,count(order_item_id) from items
group by order_item_id
having count(order_item_id) > 1;
describe products;
select * from products
limit 2;
create table products1(
product_id varchar(100),
category_name varchar(60),
name_length varchar(100),
description_length varchar(100),
photos_qty varchar(100),
weight_g varchar(100),
length_cm varchar(100),
height_cm varchar(100),
width_cm varchar(100));

select * from products
where name_length = ''
or description_length = ''
or photos_qty = ''
or weight_g = ''
or length_cm = ''
or height_cm = ''
or width_cm = '';

select sum(name_length = '') as name_length,
sum(description_length = '') as descr,
sum(photos_qty = '') as pho,
sum(weight_g = '') as weight,
sum(length_cm = '') as length,
sum(height_cm = '') as height,
sum(width_cm = '') as width from products;

-- Filling blanks with null 
set sql_safe_updates = 0;
update products
set name_length = NULLIF(name_length, ''),
    description_length = NULLIF(description_length, ''),
    photos_qty = NULLIF(photos_qty, ''),
    weight_g = NULLIF(weight_g, ''),
    length_cm = NULLIF(length_cm, ''),
    height_cm = NULLIF(height_cm, ''),
    width_cm = NULLIF(width_cm, '');
set sql_safe_updates = 1;

alter table products
modify column name_length int;
alter table products
modify column description_length int;
alter table products
modify column photos_qty int;
alter table products
modify column weight_g int;
alter table products
modify column length_cm int;
alter table products
modify column height_cm int;
alter table products
modify column width_cm int;


describe reviews;
alter table reviews
rename column ï»¿review_id to review_id,
rename column review_score to score,
rename column review_creation_date to creation_date,
rename column review_answer_timestamp to answer_timestamp;
select count(*) from reviews;
alter table reviews
modify column review_id varchar(100),
modify column order_id varchar(100),
modify column score int,
modify column creation_date datetime,
modify column answer_timestamp datetime;

drop table products;

rename table products1 to products;

----------------------------------------------------------------------------------

describe sellers;

-- Checking for primary key 

select seller_id,count(seller_id) from sellers
group by seller_id
having count(seller_id) >1;

alter table sellers
add constraint primary key(seller_id);

-------------------------------------------------------------------------------------

describe reviews;
select review_id,count(review_id) from reviews
where review_id  = 0
group by review_id
having count(review_id) >1;

SELECT review_id, COUNT(*)
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

select review_id,count(*) ,count(distinct order_id) as cnt from reviews
group by review_id
having count(*) > 1;

select order_id,count(order_id) from reviews
group by order_id
having count(order_id) >1; 

select * from reviews
where review_id = (
select review_id from reviews
group by review_id
having count(*) >1
limit 1);
select * from reviews
where order_id = (
select order_id from reviews
group by order_id
having count(*) > 1
limit 1);


select review_id,order_id,count(*) from reviews
group by review_id,order_id
having count(*) >1 ;

alter table reviews
add constraint primary key (review_id, order_id);
------------------------------------------------------------------------------------

describe products;

select product_id,count(product_id) from products
group by product_id
having count(product_id) >1;

alter table products
add constraint primary key(product_id);

-------------------------------------------------------------------------------------

describe product_category;
select product_category,count(product_category) from product_category
group by product_category
having count(product_category) >1;
alter table product_category
add constraint primary key(product_category);
--------------------------------------------------------------------------------------
describe payments;
select order_id,count(order_id) from payments
group by order_id
having count(order_id) >1;

select payment_sequential,count(payment_sequential) from payments
group by payment_sequential
having count(payment_sequential) >1;

alter table payments
add constraint primary key(order_id, payment_sequential);


---------------------------------------------------------------------------------------

describe orders;

alter table orders
modify column order_id varchar(100);
select order_id,count(order_id) from orders
group by order_id
order by order_id asc
limit 3;

alter table orders
add constraint primary key(order_id);

-----------------------------------------------------------------------------------------
describe items;
select order_id,count(order_id) from items
group by order_id
having count(order_id)>1;

alter table items 
add constraint primary key(order_id, order_item_id);

------------------------------------------------------------------
-- Adding foreign keys for Entity-Relationships

-- Attaching foreign key to orders table

alter table orders
add constraint fk_customer_id
foreign key(customer_id)
references customers(customer_id);

-- Attaching foreign key to items table

alter table items
add constraint fk_seller_id
foreign key(seller_id)
references sellers(seller_id);

alter table items
add constraint fk_product_id
foreign key(product_id)
references products(product_id);

alter table items
add constraint fk_o_id
foreign key(order_id)
references orders(order_id);

-- 112650 row(s) affected Records: 112650  Duplicates: 0  Warnings: 0


-- Attaching foreign key to payments table

alter table payments
add constraint fk_order_id
foreign key(order_id)
references orders(order_id);

-- Attaching foreign key to reviews table

alter table reviews
add constraint fk_order_id1
foreign key(order_id)
references orders(order_id);
describe orders;

-- Attaching foreign key to products table

alter table products
add constraint fk_product_name
foreign key (category_name)
references product_category(product_category);

alter table product_category
modify column product_category varchar(60),
modify column product_category_english varchar(60);

select  p.product_id as product_id,p.category_name as category_name,
		pc.product_category as product 
        from products p
        left join product_category pc
        on pc.product_category = p.category_name
        where pc.product_category is null;

select distinct category_name from products
where category_name not in (
select product_category from product_category );

select * from products
where category_name = '';

set sql_safe_updates = 0;

update products
set category_name = category_name is null
where  category_name = 0;

set sql_safe_updates = 1;

SELECT COUNT(*)
FROM products
WHERE category_name = '0';

set sql_safe_updates = 0;

update products
set category_name = null
where category_name = '0';

set sql_safe_updates = 1;

select count(*) from products
where category_name = '0';

select count(*) from products
where category_name is null;

select distinct category_name from products
where category_name not in (select product_category from product_category);

select count(*) from products
where category_name = 'gamer_pc';

select * from products
limit 1;

select * from product_category
where product_category= '%gamer%'
or product_category = '%portateis%' ;

-- 0 row(s) returned

insert into product_category
(product_category, product_category_english)
values
('pc_gamer' ,'pc_gamer'),
('portateis_cozinha_e_preparadores_de_alimentos' , 'portable kitchen and food preparers');

-- 0 row(s) returned

-- now we can attach primary key for products

alter table products
add constraint fk_p_id
foreign key(category_name)
references product_category(product_category);

-- 32951 row(s) affected Records: 32951  Duplicates: 0  Warnings: 0


-- checking everything
describe customers;
select customer_id,count(*) from customers
group by customer_id
having count(*) > 1;
-- 0 row(s) returned

describe items;
select  order_id,order_item_id,count(*) from items
group by order_id,order_item_id
having count(*) > 1;
-- 0 row(s) returned

describe orders;
select order_id,count(*) from orders
group by order_id
having count(*) > 1;
-- 0 row(s) returned

describe payments;
select order_id,payment_sequential,count(*) from payments
group by order_id,payment_sequential
having count(*)>1;
-- 0 row(s) returned

describe product_category;
select product_category,count(*) from product_category
group by product_category
having count(*) > 1;
-- 0 row(s) returned

describe products;
select product_id,count(*) from products
group by product_id
having count(*) >1;
-- 0 row(s) returned

describe reviews;
select review_id,order_id,count(*) from reviews
group by review_id,order_id
having count(*) >1;

describe sellers;
select seller_id,count(*) from sellers
group by seller_id
having count(*) > 1;


describe reviews;
select min(review_creation_date),max(review_creation_date) from reviews;
describe order_items;
select min(shipping_limit_date),max(shipping_limit_date) from order_items;

-- Re-imported items and reviews tables data got damaged while changing datatime data type

use e_commerce;
describe reviews; 
alter table reviews
rename column ï»¿review_id to review_id;

describe reviews;
select review_creation_date,review_answer_timestamp 
from reviews
limit 5;
update reviews
set review_creation_date = 
str_to_date(review_creation_date, '%d-%m-%y %h:%i');
set sql_safe_updates = 0;

select review_creation_date from reviews
where review_creation_date is null;
-- 0 rows
select review_creation_date from reviews
where review_creation_date = 0;
-- 0 rows
select review_creation_date from reviews
where review_creation_date ='0';
-- 0 rows
update reviews
set review_creation_date = 
str_to_date(review_creation_date, '%d-%m-%y %H:%i');

set sql_safe_updates = 1;

alter table reviews
modify column review_creation_date datetime;

select min(review_creation_date),
		max(review_creation_date) 
from reviews;

describe reviews;

alter table reviews
modify column review_answer_timestamp datetime;

describe reviews;
select  min(review_answer_timestamp),
		max(review_answer_timestamp)
from reviews;

describe reviews;
select review_id,count(*) as count from reviews
group by review_id
having count(*) > 1;

select order_id,count(*) from reviews
group by order_id
having count(*) > 1;
-- since we dont have single primary key, we have to use composite primary key

select review_id,order_id,count(*) from reviews
group by review_id,order_id
having count(*) > 1;

describe reviews;
select * from reviews
limit 3;

alter table reviews
add constraint
primary key(review_id,order_id);

alter table reviews
modify column review_id varchar(100),
modify column order_id varchar(100),
modify column review_score int;

describe reviews;
alter table reviews
add constraint fk_order
foreign key(order_id)
references orders(order_id);

describe order_items;
-- renaming table
rename table order_items to items;
describe items;

select * from items
limit 8;
alter table items
modify column order_id varchar(100),
modify column order_item_id int,
modify column product_id varchar(100),
modify column seller_id varchar(100),
modify column price decimal(6,2),
modify column freight_value decimal(6,2);

set sql_safe_updates =0 ;

describe  items;

select * from items
limit 5;
update items
set shipping_limit_date = 
str_to_date(shipping_limit_date, '%d-%m-%y %H:%i');

select min(shipping_limit_date),
	   max(shipping_limit_date) 
from items;

alter table items
modify column shipping_limit_date datetime;

set sql_safe_updates = 1;

describe items;

select order_id,count(*) as count from items
group by order_id
having count(*) > 1;

select order_item_id,count(*) as count from items
group by order_item_id
having count(*) > 1
limit 3;

select order_id,order_item_id,
count(*) as count from items
group by order_id,order_item_id
having count(*)>1
limit 3;

alter table items
add constraint primary key(order_id,order_item_id);

alter table items
add constraint fk_o_id
foreign key(order_id)
references orders(order_id);

describe items;
alter table items
add constraint fk_k_id
foreign key(product_id)
references products(product_id);

alter table items
add constraint fk_fk_fk
foreign key(seller_id)
references sellers(seller_id);













