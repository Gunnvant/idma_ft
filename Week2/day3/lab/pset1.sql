/*Q1 */
with retail_mod 
as
(
select *, cast(strftime("%Y", sales_month) as float) as year,
CASE 
	when cast(strftime("%m", sales_month) as FLOAT) Between 1 and 3 then "Q1"
	when cast(strftime("%m", sales_month) as FLOAT) Between 4 and 6 then "Q2"
	when cast(strftime("%m", sales_month) as FLOAT) Between 7 and 9 then "Q3"
	when cast(strftime("%m", sales_month) as FLOAT) Between 10 and 12 then "Q4"
end as qtr 
from retail_sales
where kind_of_business = 'Men''s clothing stores' and year BETWEEN 1992 and 1995
)
select year,qtr,sales,
min(sales) over (partition by year,qtr) as min_sales_qtr,
min(sales) over () as min_sales_global,
max(sales) over (partition by year,qtr) as max_sales_qtr,
max(sales) over () as max_sales_global
from retail_mod;

/*Q2*/
with retail_mod 
as
(
select *, cast(strftime("%Y", sales_month) as float) as year,
cast(strftime("%m",sales_month) as FLOAT) as month,
CASE 
	when cast(strftime("%m", sales_month) as FLOAT) Between 1 and 3 then "Q1"
	when cast(strftime("%m", sales_month) as FLOAT) Between 4 and 6 then "Q2"
	when cast(strftime("%m", sales_month) as FLOAT) Between 7 and 9 then "Q3"
	when cast(strftime("%m", sales_month) as FLOAT) Between 10 and 12 then "Q4"
end as qtr 
from retail_sales
where kind_of_business = 'Men''s clothing stores' and year BETWEEN 1992 and 1995
)
select year,month,qtr,sales,
rank() over (partition by year,qtr order by sales desc) as qtr_perf
from retail_mod;

/*Q3*/
select * from transactions;
with t as 
(select 
strftime("%m",Timestamp) as month,
Payment_Method,
count(*) as num_transactions
from transactions
group by month, Payment_Method 
)
select month,
Payment_Method,
num_transactions,
lag(num_transactions,1) over (partition by Payment_Method) as lagged_count,
((num_transactions*1.0/(lag(num_transactions,1) over (partition by Payment_Method)))-1.0)*100 as perc_change
from t;

