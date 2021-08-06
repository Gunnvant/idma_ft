/* Working with time series data */
select * from retail_sales limit 5;

select DISTINCT (kind_of_business) from retail_sales order by kind_of_business;

/* find out the trend of business activity in Retail and food services sales */
select sales_month, sum(sales) as total_sales from retail_sales
where kind_of_business = 'Retail and food services sales, total'
group by 1;

/* we may want to observer trends over years rather than over months */
with retail_mod as 
(select *, STRFTIME("%Y",sales_month) as year from retail_sales)
select year, sum(sales) as total_sales from retail_mod
where kind_of_business = 'Retail and food services sales, total'
group by year

/* compare the sales in Men's and Women's clothing stores */
SELECT sales_month
,kind_of_business
,sales
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores','Women''s clothing stores')
;
/* can we create a side by side summary of both the groups */
select sales_month, 
case when kind_of_business = 'Men''s clothing stores' then sales end as mens_sales,
case when kind_of_business = 'Women''s clothing stores' then sales end as womens_sales
from retail_sales
WHERE kind_of_business in ('Men''s clothing stores','Women''s clothing stores')

/* we can do it better by doing aggregations */
select sales_month, 
sum(case when kind_of_business = 'Men''s clothing stores' then sales end) as mens_sales,
sum(case when kind_of_business = 'Women''s clothing stores' then sales end) as womens_sales
from retail_sales
group by 1;  

/* can we find out the proportion of women vs men's sales */
select *, cast(mens_sales as float)/cast(womens_sales as float) as pct_sales from
(select sales_month, 
sum(case when kind_of_business = 'Men''s clothing stores' then sales end) as mens_sales,
sum(case when kind_of_business = 'Women''s clothing stores' then sales end) as womens_sales
from retail_sales
group by 1);

/* version 2 */
with retail_mod as 
(select sales_month, 
sum(case when kind_of_business = 'Men''s clothing stores' then sales end) as mens_sales,
sum(case when kind_of_business = 'Women''s clothing stores' then sales end) as womens_sales
from retail_sales
group by 1)
select *, cast(mens_sales as float)/cast(womens_sales as float) as pct_sales from retail_mod;

/* version 3 */
with retail_mod as 
(select sales_month, 
sum(case when kind_of_business = 'Men''s clothing stores' then sales end) as mens_sales,
sum(case when kind_of_business = 'Women''s clothing stores' then sales end) as womens_sales
from retail_sales
group by 1)
select *, (mens_sales*1.0)/(womens_sales) as pct_sales from retail_mod;

/* window functions */
/* Window functions can be used to produce running totals*/
-- Value Window Functions: SUM(), MAX(), MIN(), AVG(). COUNT()
select * from retail_sales;
/* Lets find out the min and max sales for Mens category across years */
with retail_mod AS
(select *, STRFTIME("%Y", sales_month) as year from retail_sales)
select year,
kind_of_business, 
min(sales) as min_sales, 
max(sales) as max_sales,
sum(sales) as total_sales
from retail_mod
group by 1,2;

select * from retail_sales;
/* Lets find out the min and max sales for Mens category across years */
with retail_mod AS
(select *, STRFTIME("%Y", sales_month) as year from retail_sales)
select year,
kind_of_business, 
min(sales) as min_sales, 
max(sales) as max_sales,
sum(sales) as total_sales
from retail_mod
group by 1,2
having kind_of_business = 'Men''s clothing stores';

/* Now what if we wanted to know what percent of sales of men's clothing were over total sales every year*/
SELECT sales_month
,kind_of_business
,sales
,sum(sales) over (partition by STRFTIME('%Y',sales_month), kind_of_business) as yearly_sales
,sales * 100.0 / sum(sales) over (partition by STRFTIME('%Y',sales_month), kind_of_business) as pct_yearly
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores','Women''s clothing stores');

/* Another common usage of window functions is with indexing things using value window functions*/
--- LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE() 

/* use text book example for First_value */


/*make similar examples on lag() and lead() */

