USE sakila;
/*1 Write a function that returns the amount of copies of a film in a store in sakila-db.
	Pass either the film id or the film name and the store id.*/
DELIMITER $
DROP PROCEDURE IF EXISTS get_amount_films $
CREATE FUNCTION get_amount_films(f_id INT, st_id INT) RETURNS 
INT DETERMINISTIC 
BEGIN 
	DECLARE cant INT;
	SELECT
	    COUNT(i.inventory_id) INTO cant
	FROM film f
	    INNER JOIN inventory i USING(film_id)
	    INNER JOIN store st USING(store_id)
	WHERE
	    f.film_id = f_id
	    AND st.store_id = st_id;
	RETURN (cant);
	END$ 

DELIMITER ;

SELECT get_amount_films(75,2);

/*2 Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";",
that live in a certain country. You pass the country it gives you the list of people living there. USE A CURSOR,
do not use any aggregation function (ike CONTCAT_WS.*/
DELIMITER $
DROP PROCEDURE IF EXISTS list_procedure $
CREATE PROCEDURE list_procedure(IN co_name VARCHAR(250), OUT list VARCHAR(500)) 
BEGIN 
	DECLARE finished INT DEFAULT 0;
	DECLARE f_name VARCHAR(250) DEFAULT ''; 
	DECLARE l_name VARCHAR(250) DEFAULT '';
	DECLARE coun VARCHAR(250) DEFAULT '';

	DECLARE cursList CURSOR FOR
	SELECT
	    co.country,
	    c.first_name,
	    c.last_name
	FROM customer c
	    INNER JOIN address a USING(address_id)
	    INNER JOIN city cy USING(city_id)
	    INNER JOIN country co USING(country_id);
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

	OPEN cursList;

	looplabel: LOOP
		FETCH cursList INTO coun, f_name, l_name;
		IF finished = 1 THEN
			LEAVE looplabel;
		END IF;

		IF coun = co_name THEN
			SET list = CONCAT(f_name,';',l_name);
		END IF;
		
	END LOOP looplabel;
	CLOSE cursList;
END $
DELIMITER ;

set @list = '';
CALL list_procedure('Argentina',@list);
SELECT @list;
/*3 Review the function inventory_in_stock A and the procedure film_in_stock B explain the code, write usage examples.*/
/*A*/
CREATE DEFINER=`user`@`%` FUNCTION `sakila`.`inventory_in_stock`(p_inventory_id INT) RETURNS tinyint(1)
    READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;
    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END
/*
esta funcion se fija si en cierto inventario hay stock o no
*/;
SELECT inventory_in_stock(1138);

/*B*/
CREATE DEFINER=`user`@`%` PROCEDURE `sakila`.`film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
    READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END
/*
este procedimiento muestra la cantidad de una pelicula que hay una determinada store
*/
;
set @thing = '';
CALL film_in_stock(6,9,@thing);
SELECT @thing;