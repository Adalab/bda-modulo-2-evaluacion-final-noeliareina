USE sakila;

/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. */

SELECT DISTINCT title
	FROM film;

/* 2. Muestra los nombres de todas las películas que tengan una clasificación de PG-13. */

SELECT title
	FROM film
    WHERE rating = "PG-13";

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción. */

SELECT title, description
	FROM film
	WHERE description LIKE "%amazing%";    

/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */

-- Solución correcta:
SELECT title
	FROM film
	WHERE length > 120;
    
/* 5. Recupera los nombres de todos los actores. */
# -- Solución correcta con nombre completo:
SELECT CONCAT(first_name, " ", last_name)
	FROM actor;

/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido. */
-- Solución correcta:
SELECT first_name, last_name
	FROM actor
	WHERE last_name = "Gibson";

/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20. */
-- Solución correcta:
SELECT CONCAT(first_name, " ", last_name), actor_id
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20;
    
/* 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación. */
-- Solución correcta:
SELECT title AS titulo_peliculas
	FROM film
	WHERE rating NOT IN ('R', 'PG-13');

-- Otra solución pero más compleja:
SELECT title AS titulo_peliculas
	FROM film
	WHERE rating <> 'R' AND rating <> 'PG-13';

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film 
y muestra la clasificación junto con el recuento. */
-- Solución correcta:
SELECT rating, COUNT(*) AS total_peliculas
	FROM film
	GROUP BY rating;
    
/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y 
muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas. */

-- Observación de tablas para hacer relación:
SELECT c.customer_id, c.first_name, c.last_name
	FROM customer AS c;
SELECT r.inventory_id, r.customer_id
	FROM rental AS r;
    
-- Solución correcta:
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.inventory_id) AS total_alquiladas
	FROM customer AS c
	INNER JOIN rental AS r
    ON c.customer_id = r.customer_id -- Especificamos la relación entre las tablas
    GROUP BY c.customer_id, c.first_name, c.last_name; -- Agrupamos por cliente
    
/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto
con el recuento de alquileres. */