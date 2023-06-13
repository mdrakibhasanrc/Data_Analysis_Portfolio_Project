-- create database
create database project;
use project;
set sql_safe_updates=0;

-- Query All Columns

select * from pizza_sales;

-- Data Cleaning

-- See Columns Length
select
count(*) as col_number from information_schema.columns where table_name='pizza_sales';

-- See all dataset columns describe
describe pizza_sales;

-- See duplicate value
select
   pizza_id,
   count(*) as duplicate_value
from pizza_sales
group by pizza_id
having count(*)>1;

-- Check Null value

select
    *
from pizza_sales
where pizza_id is null;

-- Create Month_name Columns
alter table pizza_sales
add Month_name text;

select 
  order_date,
  monthname(order_date)
from pizza_sales;

-- update order_date column to correct date time
alter table pizza_sales
modify order_date date;

update pizza_sales
set order_date=str_to_date(order_date,'%d-%m-%Y');

-- update month name columns
update pizza_sales
set Month_name=monthname(order_date);

-- Create Day Column and update Day COlumns
alter table pizza_sales
add Day_name text;

update pizza_sales
set Day_name=dayname(order_date);

-- Add Time Columns

alter table pizza_sales
add Time int;

update pizza_sales
set order_date=str_to_date(order_date,'%d-%m-%Y');

select
    order_time,
    substring_index(order_time,':',1)
from pizza_sales;

-- update Time columns
update pizza_sales
set Time=substring_index(order_time,':',1);




-- Data Exploration -------------

-- Total Revenue
select
   sum(total_price) as Revenue
from pizza_sales;

-- Avg order values
select
   sum(total_price)/count(distinct order_id) as Avf_order_value
from pizza_sales;

-- Total Pizza Sold
select
   sum(quantity) as total_pizza_sold
from pizza_sales;

-- Total Order
select
   count(distinct order_id) as Total_Order
from pizza_sales;

-- Avg Pizza Per order

select
  sum(quantity)/count(distinct order_id) as Avg_pizza_per_Order
from pizza_sales;

-- Daily Trend for Total Order
select
    Day_name,
    count(distinct order_id) as Total_order
from pizza_sales
group by Day_name
order by Total_order desc;

-- Hourly  Trend for Total Order
select
    Time,
    count(distinct order_id) as Total_order
from pizza_sales
group by Time
order by Total_order desc;

-- Percentage of Sales by Pizza Category
select
    pizza_category,
    sum(total_price) as Total_sale,
    round((sum(total_price)/(select sum(total_price) from pizza_sales))*100,2) as pct
from pizza_sales
group by pizza_category
order by Total_sale desc;

-- Percentage of Sales by pizza size.
select
    pizza_size,
    sum(total_price) as Total_sale,
    round((sum(total_price)/(select sum(total_price) from pizza_sales))*100,2) as pct
from pizza_sales
group by pizza_size
order by Total_sale desc;

-- Total Pizza Sold by pizza category.
select
    pizza_category,
    sum(quantity) as Total_sold
from pizza_sales
group by pizza_category
order by Total_sold desc;

-- Top 5 Best Sellers by Total Pizza Sold.pizza_name_id
select
    pizza_name,
    sum(quantity) as Total_sold
from pizza_sales
group by pizza_name
order by Total_sold desc
limit 5;

-- Wrost 5 Best Sellers by Total Pizza Sold.pizza_name_id
select
    pizza_name,
    sum(quantity) as Total_sold
from pizza_sales
group by pizza_name
order by Total_sold asc
limit 5;
