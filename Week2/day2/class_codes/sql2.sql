/* Joins use sakila db */
/* sql is designed to work with more than one table, joins are very essential
 * component of sql *
/* find out the films that have been returned */
select rental.rental_id, rental.return_date, inventory.film_id,inventory.inventory_id
from rental left join inventory on rental.inventory_id=inventory.inventory_id;

/* get film names which are still on rent */
select rental.rental_id, rental.return_date, inventory.film_id,inventory.inventory_id,film.title
from rental left join inventory on rental.inventory_id=inventory.inventory_id left join 
film on inventory.film_id=film.film_id where return_date is null;

/* Which movie is most famous in India */
select film.title,country.country,count(film.title) as cnt from rental left join inventory on 
rental.inventory_id=inventory.inventory_id left join film on inventory.film_id=film.film_id left join customer 
on rental.customer_id=customer.customer_id left join address on customer.address_id=address.address_id 
left join city on address.city_id=city.city_id left join country on city.country_id=country.country_id 
where rental_date is not null group by country.country,film.title having country='India' order by cnt desc;

/* which actor has been most popular in the category of action films */
select actor.first_name, actor.last_name, category.name, count(*) as cnt from film 
left join film_actor on film_actor.film_id = film.film_id
left join film_category on film_category.film_id = film.film_id
left join actor on actor.actor_id = film_actor.actor_id 
left join category on category.category_id = film_category.category_id
where category.name = 'Action' 
group by actor.first_name, actor.last_name
order by cnt desc;

/* customers from which city have the most rentals */
select city.city, count(city.city) as cnt from rental 
left join customer on customer.customer_id = rental.customer_id 
left join address  on customer.address_id = address.address_id
left join city on city.city_id = address.city_id
group by city
order by cnt desc;

/* add date examples here */

/* add cte examples also */
