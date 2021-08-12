select * from track;

select * from track limit 5;

select Name,Composer from track limit 5;

/* find the top 5 most expensive tracks */
select * from track
order by UnitPrice desc limit 5;

/* find the 10 shortest tracks in the list*/
select * from track
order by Milliseconds asc limit 10;

/* find 10 tracks that are expensive but Short*/
select  * from track 
order by UnitPrice desc, Milliseconds asc limit 10;

/* find out tracks that cost between 0.99 to 1.10, both the limits are inclusive*/
select * from track
where UnitPrice between 0.99 and 1.10;

/* find out the number of tracks that cost between 0.99 to 1.10, both the limits are inclusive*/
select count(*) from track
where UnitPrice between 0.99 and 1.10;

/* find out the unique values in GenreId*/
select DISTINCT GenreId from Track;

/* find out the number of unique values in GenreId*/
select count(DISTINCT GenreId) from track;

/* find out the tracks in GenreId 2,13,16,18*/
select * from Track
where GenreId=2 or GenreId=13 
or GenreId=16 or GenreId=18;

select * from track 
where GenreId in (2,13,16,18);

/* find out the songs that are between 3Mb to 6MB*/
select * from track 
where Milliseconds>1024*1024*3 and Milliseconds<1024*1024*6;

select * from invoice;

/*Find the total amount invoiced for all the customers who made the transcation
from the same city as made on Invoice Id 23*/
select total from Invoice
where BillingCity = 
(select BillingCity FROM Invoice
WHERE InvoiceId=23); 

/* Sometimes the inner query can return more than one unique value*/
select BillingCity from invoice
where BillingCountry='India';

select * from invoice 
where InvoiceId=23;

select BillingCity,InvoiceId from invoice 
where BillingCity = (Select BillingCity from invoice 
where BillingCountry='India');

/* use the in operator to do a set search */
select BillingCity,InvoiceId from invoice 
where BillingCity in (Select BillingCity from invoice 
where BillingCountry='India');

/* Find average total revenue by Billing city */
select BillingCity,avg(Total) as Mean_rev from Invoice 
group by BillingCity order by Mean_rev desc;

/* Find average total revenue by Country and City */
select BillingCountry,BillingCity,avg(Total) as Mean_rev from Invoice 
group by BillingCountry,BillingCity order by BillingCountry,BillingCity, Mean_rev desc;

/* can we filter the group by results*/
select BillingCity,avg(Total) as Mean_rev from Invoice 
group by BillingCity 
having BillingCity='Bangalore';

/* can we filter more than one row*/
select BillingCity,avg(Total) as Mean_rev from Invoice 
group by BillingCity 
having avg(Total)>5;
/* There can be instance when we need to use intermediate table results
 * for computation downstream, we can use Table Expressions, CTE or 
 * Views */

select billingcity, count(billingcity) as cnt, avg(total) as avg_sales
from invoice
group by billingcity order by cnt desc;

/* Assume we want to find out min and max avg_sales*/
select min(avg_sales) as min_avg,max(avg_sales) as max_avg
from 
(select billingcity, count(billingcity) as cnt, avg(total) as avg_sales
from invoice
group by billingcity order by cnt desc) as T;

select min(avg_sales) as min_avg,max(avg_sales) as max_avg
from 
(select billingcity, count(billingcity) as cnt, avg(total) as avg_sales
from invoice
group by billingcity) as T;

/* we can do some procedural programming using case statements*/
select min(total),max(total),avg(total) from invoice;

select total,
case 
when total<4 then 'low'
when (total>=4 and total<=13) then 'medium'
else 'high'
end as status 
from invoice;

/* Can we find out how many low, medium and high transactions*/
select status,count(status) as cnt, avg(total) as avg_tot
from 
(select total,
case 
when total<4 then 'low'
when (total>=4 and total<=13) then 'medium'
else 'high'
end as status 
from invoice) as D 
group by status order by cnt desc;
