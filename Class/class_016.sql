USE sakila;

/*1- Insert a new employee to , but with an null email. Explain what happens.*/
INSERT INTO employees (employeeNumber,lastName,firstName,extension,email,officeCode,reportsTo,jobTitle)
VALUES (1138,'Skywalker','Anakin','x1138',NULL,'1',NULL,'chosen one');

/*
SQL Error [1048] [23000]: Column 'email' cannot be null
basicamente la columna email no acepta nulls.
 */

/*2- Run the first the query*/
UPDATE employees SET employeeNumber = employeeNumber - 20;
/*What did happen? Explain. Then run this other
pregunta si estoy seguro, ya que como no tiene un where es una query que va a modificar todos los employees, se ejecuta.
*/

UPDATE employees SET employeeNumber = employeeNumber + 20;
/*Explain this case also.
En esta pasa lo mismo pero no se logra ejectuar ya que employee 1036 pasaria a 1056 y no puede hacerlo porque ya hay un 1056, a pesar de que 1056
 cambiaria a 1076 primero intenta ejecutar el primero y devuelve un error*/


/*3- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.*/
ALTER TABLE employees 
ADD age TINYINT,
ADD CONSTRAINT ageCheck CHECK(age >= 16 and age <= 70);

/*4- Describe the referential integrity between tables film, actor and film_actor in sakila db.

film_actor contiene ids de actors y films, pudiendo ver que actores actuan en que peliculas

*/

/*5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations.
Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row
(assume multiple users, other than root, can connect to MySQL and change this table).*/
select * FROM employees;

ALTER TABLE employees 
ADD lastUpdate DATETIME;
ALTER TABLE employees
ADD lastUpdateUser VARCHAR(30);

CREATE TRIGGER employees_before_update
	BEFORE UPDATE ON employees
	FOR EACH ROW
BEGIN
	SET NEW.lastUpdate = NOW();
	SET NEW.lastUpdateUser = SESSION_USER();
END;

/* next lines to test if it works, and it does*/
INSERT INTO employees (employeeNumber,lastName,firstName,extension,email,officeCode,reportsTo,jobTitle)
VALUES (1138,'Skywalker','Anakin','x1138','ademail@email.com','1',NULL,'chosen one');
UPDATE employees set lastName = 'Darth', firstName = 'Vader' WHERE employeeNumber = 1138;
UPDATE employees set lastName = 'Skywalker', firstName = 'Anakin' WHERE employeeNumber = 1138;




/*6- Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.*/

-- sakila.film_text definition
CREATE TABLE `film_text` (
  `film_id` smallint(6) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  PRIMARY KEY (`film_id`),
  FULLTEXT KEY `idx_title_description` (`title`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*triggers: */
CREATE DEFINER=`user`@`%` TRIGGER `ins_film` AFTER INSERT ON `film` FOR EACH ROW BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END
/*cuando se agrega una film se agrega tambien en sakila.film_tex */

CREATE DEFINER=`user`@`%` TRIGGER `upd_film` AFTER UPDATE ON `film` FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END
/*cuando se actualiza una film se actualiza tambien en sakila.film_tex*/

CREATE DEFINER=`user`@`%` TRIGGER `del_film` AFTER DELETE ON `film` FOR EACH ROW BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END
/*cuando se elimina una film se elimina tambien en sakila.film_tex*/




