USE sakila;

/*1 Create a user data_analyst*/
CREATE USER data_analyst IDENTIFIED BY 'topsecret';

/*2 Grant permissions only to SELECT, UPDATE and DELETE to all sakila tables to it.*/
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'%';

/*3 Login with this user and try to create a table. Show the result of that operation.*/
mysql> USE sakila;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> CREATE TABLE for193(
    -> id INT NOT NULL AUTO_INCREMENT
    -> );
ERROR 1142 (42000): CREATE command denied to user 'data_analyst'@'localhost' for table 'for193'
mysql>

/*4 Try to update a title of a film. Write the update script.*/
mysql> UPDATE film SET title = 'Crazy feminist bitch' WHERE film_id = 1;
Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0
;
select * from film f where film_id = 1;


/*5 With root or any admin user revoke the UPDATE permission. Write the command*/
mysql> REVOKE UPDATE ON sakila.* FROM data_analyst;
Query OK, 0 rows affected (0.00 sec)

/*6 Login again with data_analyst and try again the update done in step 4. Show the result.*/
mysql> UPDATE film SET title = 'Crazy feminist bitch 2' WHERE film_id = 1;
ERROR 1142 (42000): UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'