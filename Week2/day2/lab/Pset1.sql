/* Pset 1 */
/* Q1 */
select country, count(*) as cnt
from supplier
group by country
order by cnt desc;

/* Q2 */
select Product.ProductName,count(*) as cnt 
from OrderDetail 
left join Product 
on OrderDetail.ProductId=Product.id
group by ProductName
order by cnt desc

/* Q3 */
with order_mod
as (select * from "order")
select order_mod.ShipCity, count(*) as cnt
from OrderDetail 
left join product
on OrderDetail.ProductId = Product.id
left join order_mod
on order_mod.Id = OrderDetail.OrderId 
where ProductName='Camembert Pierrot'
group by ShipCity order by cnt desc;

/* Q4 */
with order_mod 
as (select * from "order")
select employee.firstname,employee.lastname,count(*) as cnt
from order_mod left join employee on 
order_mod.employeeid=employee.id left join customer 
on order_mod.customerid=customer.id 
where customer.contactname='Hari Kumar' group by employee.firstname
,employee.lastname order by cnt desc;



