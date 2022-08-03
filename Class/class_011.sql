USE sakila;

/*4 Find all the film titles that are not in the inventory.*/
SELECT f.title FROM film f
WHERE film_id not in
	(SELECT f2.film_id FROM film f2
		JOIN inventory i USING(film_id));

/*5 Find all the films that are in the inventory but were never rented.
Show title and inventory_id.
This exercise is complicated.
hint: use sub-queries in FROM and in WHERE or use left join and ask if one of the fields is null*/
SELECT f.title, i.inventory_id FROM inventory i
JOIN film f using(film_id)
WHERE f.film_id NOT IN
	(SELECT f2.film_id FROM rental r
		JOIN inventory i2 ON r.rental_id = i2.inventory_id
		JOIN film f2 ON i2.film_id = f2.film_id);

/*6 Generate a report with:
customer (first, last) name, store id, film title,
when the film was rented and returned for each of these customers
order by store_id, customer last_name*/
SELECT c.first_name, c.last_name, s.store_id, f.title, r.rental_date, r.return_date
FROM rental r
JOIN customer c USING(customer_id)
JOIN store s USING(store_id)
JOIN inventory i USING(inventory_id)
JOIN film f USING(film_id)
ORDER BY s.store_id, c.last_name;

/*7 Show sales per store (money of rented films)
show store's city, country, manager info and total sales (money)
(optional) Use concat to show city and country and manager first and last name*/
SELECT sto.store_id,
CONCAT(c.city, " ", c2.country) AS Location, CONCAT(sta.first_name, " ", last_name) AS Manager,
(SELECT sum(amount) FROM payment p2
	WHERE p2.staff_id = sto.manager_staff_id) AS "Pagos"
FROM staff sta
JOIN store sto ON sta.staff_id = sto.manager_staff_id
JOIN address a ON sto.address_id = a.address_id
JOIN city c USING(city_id)
JOIN country c2 USING(country_id);

/*8 Which actor has appeared in the most films?*/
SELECT a.*,COUNT(fa.film_id) AS hm_films FROM actor a #hm how many
JOIN film_actor fa USING(actor_id)
GROUP BY fa.actor_id
ORDER BY hm_films desc
LIMIT 1;