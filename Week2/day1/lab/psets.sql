/* Problem Set 1 */
select * from starbucks limit 5;

/* Q1 */
select * from starbucks where Calories <=450 
and Fat<=10 
and Protein <=40
and Carb<=40
and Fiber <=5;

/* Q2 */
select Name from starbucks where Calories <=450 
and Fat<=10 
and Protein <=40
and Carb<=40
and Fiber <=5
order by Carb asc, Protein desc;

/* Q3 */
select * from stores limit 5;

select Region,avg(Sales) as avg_sales, avg(Discount) as avg_discount
from stores 
group by Region order by avg_sales desc, avg_discount asc;

/* Q4 */
select count(DISTINCT(City)) from stores;

/* Q5 */
select count(*) from stores 
where city = 'Dover';

/* Q5 variation */

select status from
(select dover_stores, case when dover_stores >0  then 'Yes' else 'No'
end as status
from
(select count(*) as dover_stores from stores 
where city = 'Dover'));

/* Problem Set 2 */
select * from stores limit 5;

/* Q1 */
select DISTINCT(CustomerName) from stores where Segment  in 
(select Segment from stores where CustomerName = 'Claire Gute');
/* Q2 */

select sales, case 
when sales>10000 then 'high'
when sales<1000 then 'low'
else 'medium'
end as bins
from stores;

/* Q3 */
select bins,count(bins) as cnt from
(select *, case 
when adj_amount>10000 then 'high'
when adj_amount<1000 then 'low'
else 'medium'
end as bins from
(select ShipMode, sales, case 
when ShipMode = 'First Class' then sales-10
else Sales 
end as adj_amount
from stores)) group by bins order by cnt desc;

/* Q4 */
select ProductName, Discount from stores order by Discount desc limit 5;

/* Q5 */
select case 
when dover>0 then 'yes'
else 'no'
end as status from
(select sum(dover_ind) as dover from
(select City, CASE 
when City='Dover' then 1
else 0
end as dover_ind from stores));