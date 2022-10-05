USE sakila;
/*1 Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.*/
SELECT CONCAT_WS(" ",first_name,last_name) as name, address.address, city.city
FROM customer 
	INNER JOIN address USING(address_id)
	INNER JOIN city USING(city_id)
	INNER JOIN country USING(country_id)
WHERE country.country LIKE 'Argentina';
/*2 Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here:
	https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.*/
SELECT title, `language`.name, 
CASE
	WHEN rating = 'G' THEN '(General Audiences) – All ages admitted.'
	WHEN rating = 'PG' THEN '(Parental Guidance Suggested) – Some material may not be suitable for children.'
	WHEN rating = 'PG-13' THEN '(Parents Strongly Cautioned) – Some material may be inappropriate for children under'
	WHEN rating = 'R' THEN '(Restricted) – Under 17 requires accompanying parent or adult guardian.'
	WHEN rating = 'NC-17' THEN '(Adults Only) – No one 17 and under admitted.'
END AS rating_description
  FROM film
 		INNER JOIN `language` USING (language_id);
/*3 Write a search query that shows all the films (title and release year) an actor was part of.
	Assume the actor comes from a text box introduced by hand from a web page.
	Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.*/
SELECT title, release_year
  FROM film 
	INNER JOIN film_actor USING(film_id)
	INNER JOIN actor USING(actor_id)
WHERE CONCAT_WS(" ",first_name,last_name)
LIKE TRIM(UPPER("                                           ed chase                                                                                                                                    "));
/*4 Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not.
	There should be returned column with two possible values 'Yes' and 'No'.*/
SELECT f.title,
	   CONCAT_WS(" ", c.first_name, c.last_name) as name,
	   CASE WHEN r.return_date IS NOT NULL THEN 'Yes'
	   		ELSE 'No'
	   	END AS was_returned,
	   MONTHNAME(r.rental_date) as month
  FROM film f
  	INNER JOIN inventory i USING(film_id)
  	INNER JOIN rental r USING(inventory_id)
  	INNER JOIN customer c USING(customer_id)
WHERE MONTHNAME(r.rental_date) LIKE 'May'
   OR MONTHNAME(r.rental_date) LIKE 'June';
/*5 Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.*/
/*CAST and CONVERT do the same thing, except that CONVERT allows more options, such as changing character set with USING.
	source: https://dba.stackexchange.com/a/12284*/
/*one removes the time, the other one adds the time*/
SELECT CAST(last_update AS DATE) as only_date FROM rental;

SELECT CONVERT("2003-10-01", DATETIME);
/*6 Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do.
	Which ones are not in MySql and write usage examples.*/
/* NVL() and IFNULL() functions work in the same way: 
	they check whether an expression is NULL or not; if it is, they return a second expression (a default value).
	NVL() is an Oracle function, so here is an IFNULL() example:*/
SELECT rental_id, IFNULL(return_date, 'Films not here sorry mate') as return_date FROM rental;

/* ISNULL() function returns 1 if the expression passed is NULL, otherwise it returns 0.*/
SELECT rental_id, ISNULL(return_date) as pelicula_faltante FROM rental;

/* COALESCE() function returns the first non-NULL argument of the passed list.*/
SELECT COALESCE(NULL,
(SELECT return_date FROM rental WHERE rental_id = 12746),
(SELECT f.title FROM film f LIMIT 1)) AS 'da thing';