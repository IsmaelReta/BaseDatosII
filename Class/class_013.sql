USE sakila;
/*1 Add a new customer
To store 1
For address use an existing address. The one that has the biggest address_id in 'United States'*/
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
SELECT 1, 'Obi Wan', 'Kenobi', 'obiwankenobi@gmail.com', MAX(a.address_id), 1
FROM address a
WHERE (SELECT c.country_id
		FROM country c, city c1
		WHERE c.country = "United States"
		AND c.country_id = c1.country_id
		AND c1.city_id = a.city_id);
SELECT * FROM customer
WHERE last_name = "Kenobi";

/*2 Add a rental
Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
Select any staff_id from Store 2.*/
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
SELECT CURRENT_TIMESTAMP, 
		(SELECT MAX(r.inventory_id)
			FROM inventory r
		 	INNER JOIN film USING(film_id)
		 WHERE film.title = "ARABIA DOGMA" LIMIT 1), 600, NULL,
		 (SELECT staff_id
		  FROM staff
		  INNER JOIN store USING(store_id)
		  WHERE store.store_id = 2 LIMIT 1);
/*3 Update film year based on the rating
For example if rating is 'G' release date will be '2001'
You can choose the mapping between rating and year.
Write as many statements are needed.*/
UPDATE film
SET release_year='2001'
WHERE rating = "G";

UPDATE film
SET release_year='2002'
WHERE rating = "PG";

UPDATE film
SET release_year='2003'
WHERE rating = "PG-13";

UPDATE film
SET release_year='2004'
WHERE rating = "R";

UPDATE film
SET release_year='2005'
WHERE rating = "NC-17";
		 
/*4 Return a film
Write the necessary statements and queries for the following steps.
Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
Use the id to return the film.*/
SELECT rental_id, rental_rate, customer_id, staff_id
FROM film
INNER JOIN inventory USING(film_id)
INNER JOIN rental USING(inventory_id)
WHERE rental.return_date IS NULL LIMIT 1;

UPDATE sakila.rental
SET  return_date=CURRENT_TIMESTAMP
WHERE rental_id=11496;


/*5 Try to delete a film
Check what happens, describe what to do.
Write all the necessary delete statements to entirely remove the film from the DB.*/
DELETE FROM inventory WHERE film_id = 1;
/*SQL Error [1451] [23000]: Cannot delete or update a parent row:
a foreign key constraint fails (`sakila`.`rental`, CONSTRAINT `fk_rental_inventory`
FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`) ON UPDATE CASCADE)

*basicamente no se puede borrar por que hay otra row que tiene una referencia con esta row,
haciendo que no se pueda borrar*/
DELETE FROM payment
 WHERE rental_id IN (SELECT rental_id 
                       FROM rental
                      INNER JOIN inventory USING (inventory_id) 
                      WHERE film_id = 1);
DELETE FROM rental
 WHERE inventory_id IN (SELECT inventory_id 
                         FROM inventory
                        WHERE film_id = 1);
DELETE FROM inventory WHERE film_id = 1;

/*6 Rent a film
Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
Add a rental entry
Add a payment entry
Use sub-queries for everything, except for the inventory id that can be used directly in the queries.*/
SELECT inventory_id, film_id
FROM inventory
WHERE inventory_id NOT IN (SELECT inventory_id
								FROM inventory
								INNER JOIN rental USING (inventory_id)
								WHERE return_date IS NULL)
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
	VALUES(
			CURRENT_DATE(), 10,
			(SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),
			(SELECT staff_id FROM staff WHERE store_id = (SELECT store_id FROM inventory WHERE inventory_id = 10))
	);
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
	VALUES(
			(SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),
			(SELECT staff_id FROM staff LIMIT 1),
			(SELECT rental_id FROM rental ORDER BY rental_id DESC LIMIT 1) ,
			(SELECT rental_rate FROM film WHERE film_id = 2),
			CURRENT_DATE());
