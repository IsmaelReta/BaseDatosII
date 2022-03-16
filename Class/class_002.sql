CREATE DATABASE imbd;
use imbd;
CREATE TABLE film (
film_id int primary key auto_increment,
title varchar(20),
description varchar(50),
realease_year date
);
CREATE TABLE actor (
actor_id int primary key auto_increment,
first_name varchar(20),
last_name varchar(20)
);
CREATE TABLE film_actor(
actor_id int,
film_id int 
);
ALTER TABLE actor
	ADD last_update date;
ALTER TABLE film_actor
ADD CONSTRAINT actor_id
FOREIGN KEY (actor_id) REFERENCES actor(actor_id);
ALTER TABLE film_actor 
ADD CONSTRAINT film_id
FOREIGN KEY (film_id) REFERENCES film(film_id);

INSERT INTO actor (first_name, last_name) values
('Ewan','McGregor'),
('Robert','Pattinson'),
('William', 'smith')
;
INSERT INTO film (title,description,realease_year) values
('Star Wars: ROTS','Yes','2005-5-19'),
('The batman','El sin padres','2022-3-3')
;
INSERT INTO film_actor values
(1,1),
(2,2);
