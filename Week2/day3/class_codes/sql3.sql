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

with retail_mod as 
(select *, STRFTIME("%Y", sales_month) as year from retail_sales
where kind_of_business ='Men''s clothing stores'
)
select *, first_value(sales) over(order by year) as index_sales from retail_mod;

/* now we can index all the sales to 1992, Jan sales*/
with retail_mod as 
(select *, STRFTIME("%Y", sales_month) as year from retail_sales
where kind_of_business ='Men''s clothing stores'
)
select *, 
first_value(sales) over(order by year desc) as index_sales,
sales*1.0/first_value(sales) over(order by year) as sale_adjusted
from retail_mod;

/* A more relevant thing to do would be to aggregate this data at yearly level and then index */
with retail_mod as 
(select sum(sales) as tot_sales, STRFTIME("%Y", sales_month) as year from retail_sales
where kind_of_business = 'Men''s clothing stores'
group by year 
order by year)
select year,
tot_sales,
first_value(tot_sales) over(order by year) as index_sales,
tot_sales*1.0/first_value(tot_sales) over(order by year) as adjusted_sales
from retail_mod;

/* Ranking sales across months in an year  */
with retail_mod as 
(
select *, cast(strftime("%m", sales_month) as FLOAT) as mth,
cast(STRFTIME("%Y", sales_month) as FLOAT) as yr
from retail_sales 
where kind_of_business = 'Men''s clothing stores' and yr in (1992.0,1993.0,1994.0)
)
select yr, mth, sales, 
rank() over (partition by yr order by sales desc) as sales_perf
from retail_mod;

/* We can do more interesting things, lets find out the ranking across two different categories*/
select * from retail_sales;
with retail_mod as 
(
select *, cast(strftime("%m", sales_month) as FLOAT) as mth,
cast(STRFTIME("%Y", sales_month) as FLOAT) as yr
from retail_sales 
where kind_of_business in ('Men''s clothing stores','Automobile dealers') and yr in (1992.0,1993.0,1994.0)
)
select yr,kind_of_business,mth, sales, 
rank() over (partition by yr,kind_of_business order by sales desc) as sales_perf
from retail_mod;

/* We may also want to calculate month over month or, year over year change, this can be done using lead()/lag()*/
with retail_mod as 
(
select *, cast(strftime("%m", sales_month) as FLOAT) as mth,
cast(STRFTIME("%Y", sales_month) as FLOAT) as yr
from retail_sales 
where kind_of_business in ('Men''s clothing stores') and yr in (1992.0,1993.0,1994.0)
)
select yr,mth,sales,
lag(sales, 1) over () as prev_month_sales
from retail_mod;

/* calculate the percentage change month on month */
with retail_mod as 
(
select *, cast(strftime("%m", sales_month) as FLOAT) as mth,
cast(STRFTIME("%Y", sales_month) as FLOAT) as yr
from retail_sales 
where kind_of_business in ('Men''s clothing stores') and yr in (1992.0,1993.0,1994.0)
)
select yr,mth,sales,
lag(sales, 1) over () as prev_month_sales,
((sales*1.0/(lag(sales, 1) over ()))-1.0)*100 as m_o_m
from retail_mod;

/* calculate the percentage change month on month over previous year */
with retail_mod as 
(
select *, cast(strftime("%m", sales_month) as FLOAT) as mth,
cast(STRFTIME("%Y", sales_month) as FLOAT) as yr
from retail_sales 
where kind_of_business in ('Men''s clothing stores')
)
select yr,mth,sales,
lag(sales, 12) over () as prev_month_sales,
((sales*1.0/(lag(sales, 12) over ()))-1.0)*100 as m_o_m
from retail_mod;


/* calculate year over year change */
with retail_mod as 
(
select
cast(STRFTIME("%Y", sales_month) as FLOAT) as yr,
sum(sales) as yearly_sales
from retail_sales 
where kind_of_business in ('Men''s clothing stores')
group by yr
)
select yr, 
yearly_sales,
lag(yearly_sales,1) over() as prev_sales
from retail_mod;

/* calculate the percentage change month on month across categories*/
with retail_mod as 
(
select *, cast(strftime("%m", sales_month) as FLOAT) as mth,
cast(STRFTIME("%Y", sales_month) as FLOAT) as yr
from retail_sales 
where kind_of_business in ('Men''s clothing stores', 'Automobile dealers') and yr in (1992.0,1993.0,1994.0)
)
select yr,mth,sales,kind_of_business,
lag(sales, 1) over (PARTITION by kind_of_business) as prev_month_sales,
(sales*1.0/(lag(sales, 1) over (PARTITION by kind_of_business))-1.0)*100 as m_o_m
from retail_mod;


/* content on UNBOUNDED PRECEDING
offset PRECEDING
CURRENT ROW
offset FOLLOWING
UNBOUNDED FOLLOWING*/


/* Now assume we wanted to know which months there is more sale in an year and what percent of total sale*/
with t as (
with s as (
SELECT sales_month
,kind_of_business
,sales
,STRFTIME('%Y',sales_month) as year,
STRFTIME("%m", sales_month) as month
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores','Women''s clothing stores')
)
select 
year,
month,
kind_of_business,
sales, 
sum(sales) over (partition by year,kind_of_business rows between UNBOUNDED preceding and current row) as running_sum
from s)
select *,
last_value(running_sum) over (partition by year,kind_of_business) as test,
running_sum*1.0/last_value(running_sum) over (partition by year,kind_of_business) as pareto
from t;

/* we can also use the rows between to find moving averages*/
with s as (
SELECT sales_month
,kind_of_business
,sales
,STRFTIME('%Y',sales_month) as year,
STRFTIME("%m", sales_month) as month
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores','Women''s clothing stores')
)
select year,
month,
kind_of_business,sales,
sum(sales) over (partition by year,
				kind_of_business
				order by year,kind_of_business
				rows between 1 PRECEDING and 1 FOLLOWING) as three_month_ma
from s;
