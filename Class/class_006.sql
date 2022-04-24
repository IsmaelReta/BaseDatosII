/* class 6*/
USE sakila;
/*1 List all the actors that share the last name. Show them in order*/
SELECT first_name, last_name
FROM actor a
WHERE EXISTS (SELECT *
				FROM actor a2
				WHERE a.last_name = a2.last_name
				AND a.actor_id != a2.actor_id)
ORDER BY last_name;
/*2 Find actors that don't work in any film*/
SELECT first_name, last_name
FROM actor a
WHERE NOT EXISTS (SELECT *
					FROM film_actor fa
					WHERE a.actor_id != fa.actor_id);
/*3 Find customers that rented only one film*/
SELECT *
FROM customer c
WHERE 1=(SELECT COUNT(*)
				FROM rental r
				WHERE c.customer_id = r.customer_id);
/*4 Find customers that rented more than one film*/
SELECT *
FROM customer c
WHERE 1<(SELECT COUNT(*)
				FROM rental r
				WHERE c.customer_id = r.customer_id);
/*5 List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'*/
SELECT first_name, last_name
FROM actor a
WHERE a.actor_id IN (SELECT actor_id
				FROM film_actor fa
				WHERE fa.film_id IN (SELECT f.film_id
										FROM film f
										WHERE f.title LIKE 'BETRAYED REAR'
										OR f.title LIKE 'CATCH AMISTAD'));
/*6 List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'*/
SELECT first_name, last_name
FROM actor a
WHERE a.actor_id IN (SELECT actor_id
				FROM film_actor fa
				WHERE fa.film_id IN (SELECT f.film_id
										FROM film f
										WHERE f.title LIKE 'BETRAYED REAR'
										AND f.title NOT LIKE 'CATCH AMISTAD'));
/*7 List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'*/
SELECT first_name, last_name
FROM actor a
WHERE a.actor_id IN (SELECT actor_id
				FROM film_actor fa
				WHERE fa.film_id IN (SELECT f.film_id
										FROM film f
										WHERE f.title LIKE 'BETRAYED REAR'
										AND f.title LIKE 'CATCH AMISTAD'));
/*8 List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'*/
SELECT first_name, last_name
FROM actor a
WHERE a.actor_id IN (SELECT actor_id
				FROM film_actor fa
				WHERE fa.film_id IN (SELECT f.film_id
										FROM film f
										WHERE f.title NOT LIKE 'BETRAYED REAR'
										OR f.title NOT LIKE 'CATCH AMISTAD'));