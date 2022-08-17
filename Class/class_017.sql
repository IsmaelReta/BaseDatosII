/*For all the exercises include the queries in the class file.*/

/*1 Create two or three queries using address table in sakila db:
include postal_code in where (try with in/not it operator)
eventually join the table with city/country tables.
measure execution time.
Then create an index for postal_code on address table.
measure execution time again and compare with the previous ones.
Explain the results*/
SELECT *
FROM address a
WHERE postal_code BETWEEN 1000 and 50000; /*7ms sin index, 5ms con index*/

SELECT *
FROM address a 
	INNER JOIN city c USING(city_id)
	INNER JOIN country c2 USING(country_id)
WHERE postal_code like '%13%'; /*5ms sin index, 3ms con index*/

CREATE INDEX postalCode ON address(postal_code);
show index from address;
DROP INDEX postalCode ON address;

/*2 Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?*/
SHOW INDEX FROM actor; /*actor cuanta con idx_actor_last_name, un index por lo que puede hacer la queries de manera mas rapida*/

SELECT a.first_name 
FROM actor a
ORDER BY a.first_name DESC;/*4ms */

SELECT a2.last_name
FROM actor a2
ORDER BY a2.last_name DESC;/*2ms */


/*3 Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.*/

SELECT f.description
FROM film f
WHERE f.description LIKE '%Documentary%';/*4ms*/

show index from film;
CREATE FULLTEXT INDEX desc_index ON film(description);

SELECT f.description 
FROM film f 
WHERE MATCH(f.description) AGAINST('%Documentary%');/*3ms*/
/*de esta manera utiliza el index por lo que logra ser mas rapida*/


/*por algun motivo las mismas query ejecutas en diferentes momentos tienen diferente timpo de respuesta, los milisegundos que dejo anotados
	son unos de la variedad que vi de cada query*/