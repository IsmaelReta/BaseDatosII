use sakila;
SELECT title, special_features from film f WHERE rating LIKE 'PG-13';
SELECT DISTINCT(`length`) FROM film f;
SELECT title, rental_rate, replacement_cost FROM film f WHERE replacement_cost BETWEEN 20 AND 24;

SELECT f.title, fc.*, f.rating  FROM film f JOIN film_category fc ON f.film_id = fc.film_id
WHERE f.special_features LIKE 'Behind the Scenes';

SELECT a.first_name, a.last_name
FROM film_actor fa JOIN actor a ON fa.actor_id = a.actor_id JOIN film f ON f.film_id = fa.film_id
WHERE f.title LIKE 'ZOOLANDER FICTION';

SELECT a.address, c.city, c2.country
FROM store s JOIN address a ON s.address_id = a.address_id JOIN city c ON a.city_id = c.city_id
JOIN country c2 ON c.country_id = c2.country_id
WHERE store_id = 1;

SELECT rating, title FROM film f GROUP BY rating, title;

SELECT f.title, s2.first_name, s2.last_name FROM film f JOIN inventory i ON f.film_id = i.film_id JOIN store s ON i.store_id = s.store_id
JOIN staff s2 ON s.store_id = s2.store_id
WHERE s.store_id = 2;