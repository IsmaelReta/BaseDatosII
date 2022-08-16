USE sakila;
/*1 Create a view named list_of_customers, it should contain the following columns:
customer id
customer full name,
address
zip code
phone
city
country
status (when active column is 1 show it as 'active', otherwise is 'inactive')
store id*/
CREATE OR REPLACE VIEW list_of_customers AS
  SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name), a.address, a.postal_code, a.phone, c2.city, c3.country,
  	CASE
  		WHEN c.active = 1 THEN 'active'
  		ELSE 'inactive'
  	END AS status
  FROM customer c
  	INNER JOIN address a USING(address_id)
  	INNER JOIN city c2 USING(city_id)
  	INNER JOIN country c3 USING(country_id);

  
/*2 Create a view named film_details, it should contain the following columns:
	film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT*/
CREATE OR REPLACE VIEW film_details AS
	SELECT f.film_id, f.title, f.description, f.rental_rate, f.`length`, f.rating, GROUP_CONCAT(CONCAT_WS(" ", a.first_name, a.last_name) SEPARATOR ",") AS actors 
	FROM film f 
		INNER JOIN film_category fc USING(film_id)
		INNER JOIN category c USING(category_id)
		INNER JOIN film_actor fa USING(film_id)
		INNER JOIN actor a USING(actor_id)
	GROUP BY film_id;

/*SELECT * FROM film_details;
SHOW VARIABLES LIKE 'sql_mode';
set global sql_mode='';
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));*/

/*3 Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.*/
CREATE OR REPLACE VIEW sales_by_films_category AS
	SELECT DISTINCT c.name, SUM(p.amount) as total_rental
	FROM category c
		INNER JOIN film_category fc USING(category_id)
		INNER JOIN film f USING(film_id)
		INNER JOIN inventory i USING(film_id)
		INNER JOIN rental r USING(inventory_id)
		INNER JOIN payment p USING(rental_id)
	GROUP BY c.name;

/*4 Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.*/
CREATE OR REPLACE VIEW actor_information AS
	SELECT a.actor_id, CONCAT_WS(" ", a.first_name, a.last_name) AS 'full name',
	(SELECT COUNT(f.film_id)
		FROM film f
			INNER JOIN film_actor fa USING(film_id)
			INNER JOIN actor a2 USING(actor_id)
		WHERE a2.actor_id = a.actor_id) AS 'amount of films he/she acted on'
	FROM actor a;

/*5 Analyze view actor_info, explain the entire query and specially how the sub query works.
	Be very specific, take some time and decompose each part and give an explanation for each.

primero crea la view con ALGORITHM = UNDEFINED lo que hace que mysql elija entre MERGE y TEMPTABLE, afectando como mysql procesa la view.
en el select trae id y nombre del actor y posteriormente en la cuarta columna muestra todas las peliculas en las que actuo dicho actor
pero agrupadas segun la categoria a la que pertenecen. Al ultimo esta el from y joins necesarios y un group by para agrupar por el actor.
*/ SELECT * FROM actor_info ai;

/*6 Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.

Materialized view es una forma de ver resultados de una query, diferenciandose por ser tablas que almacenan los resultados de una query.
se usan por una mejor performance en una variedad de sistemas de manejo de bases de datos (dbms), pero no en mysql por lo que una alternativa
seria usar triggers o hacerlo con stored procedures.


*/
