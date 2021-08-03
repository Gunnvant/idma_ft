/* Pset 2 */
select * from campaign limit 5;
select * from customers limit 5;   
select * from products limit 5;
select * from transactions limit 5;

/* Q1 */
select products.Product_Category as names,count(*) as cnt from transactions 
left join  products on products.Product_Code  = transactions.Product_Code
group by names
order by cnt desc;
select * from customers;
/* Q2 */
with mod_table as 
(select *, CAST ((julianday(Registration_Date) - julianday(Birth_Date))/365 AS REAL) AS age_yrs
from customers)
select min(age_yrs) from mod_table;

/* Q3 */
with campaign_mod as
(select *, CASE 
when Campaign_Responce='F' then 0
else 1
end as target
from campaign)
select avg(target) from campaign_mod;

/* Q4 0-> Sunday*/
with mod_trans as 
(select strftime('%w', "Timestamp") as dayofweek from transactions)
select dayofweek,count(dayofweek) as cnt from mod_trans
group by dayofweek 
order by cnt desc;

/* Q5 */
with mod_trans as 
(select *, strftime('%w', "Timestamp") as dayofweek from transactions)
select * from mod_trans
order by Items_Amount desc;
