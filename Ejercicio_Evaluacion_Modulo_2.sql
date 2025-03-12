USE sakila;

/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. */

SELECT DISTINCT title AS nombre_pelicula
	FROM film;

/* 2. Muestra los nombres de todas las películas que tengan una clasificación de PG-13. */

SELECT title AS nombre_pelicula
	FROM film
    WHERE rating = "PG-13";

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción. */

SELECT title AS nombre_pelicula, description AS descripcion
	FROM film
	WHERE description LIKE "%amazing%";    

/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */

SELECT title AS nombre_pelicula
	FROM film
	WHERE length > 120;
    
/* 5. Recupera los nombres de todos los actores. */

SELECT DISTINCT CONCAT(first_name, " ", last_name) AS nombre_actor
	FROM actor;

/* 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido. */

SELECT first_name AS nombre, last_name AS apellido
	FROM actor
	WHERE last_name = "Gibson";

/* 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20. */

SELECT CONCAT(first_name, " ", last_name) AS nombre_actor
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20;
    
/* 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación. */

-- Solución:
SELECT title AS nombre_película
	FROM film
	WHERE rating NOT IN ('R', 'PG-13');

-- Otra solución pero más compleja:
SELECT title AS nombre_película
	FROM film
	WHERE rating <> 'R' AND rating <> 'PG-13';

/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film 
y muestra la clasificación junto con el recuento. */

SELECT rating AS clasificacion , COUNT(film_id) AS total_peliculas
	FROM film
	GROUP BY rating;
    
/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y 
muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas. */

-- Observación de tablas para hacer relación:
SELECT customer_id, first_name, last_name 
	FROM customer;
SELECT customer_id, rental_id
	FROM rental;
    
-- Solución:
SELECT c.customer_id AS ID_cliente, c.first_name AS nombre, c.last_name AS apellido, COUNT(r.rental_id) AS total_peliculas_alquiladas
	FROM customer AS c LEFT JOIN rental AS r 
    ON c.customer_id = r.customer_id -- Especificamos la relación entre las tablas
    GROUP BY c.customer_id, c.first_name, c.last_name; -- Agrupamos por cliente

/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto
con el recuento de alquileres. */

-- Entendiendo la lógica:
SELECT inventory_id, rental_id
	FROM rental; -- Nos interesa el conectar los alquileres con el inventario
SELECT film_id, inventory_id
	FROM inventory; -- Nos interesa conectar el inventario con las películas
SELECT film_id
	FROM film; -- Nos interesa conectar los id de las películas con sus categorías usando tabla conectora
SELECT film_id, category_id
	FROM film_category; -- Nos interesa conectar los id de las películas con los id de categorías
SELECT category_id, c.name
	FROM category; -- Nos interesa conectar los id de categorías con sus nombres.

-- Solución:
SELECT COUNT(r.rental_id) AS total_peliculas_alquiladas, c.name AS nombre_categoría
FROM rental AS r
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name;

/* 12. Encuentra el promedio de duración de las películas para cada
clasificación de la tabla film y muestra la clasificación junto con el promedio de duración. */

-- Pasos previos:
SELECT length, film_id, title, rating
FROM film;

-- Solución:
SELECT ROUND(AVG(length)) promedio_duracion, rating AS clasificacion_pelicula
FROM film
GROUP by rating;

/* 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love" */

-- Entendiendo la lógica:
SELECT title, film_id
FROM film;

SELECT film_id, actor_id
FROM film_actor; -- Tabla conectora de películas y actores

SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a; 

-- Buscamos la película y sus datos:
SELECT *
FROM film 
WHERE title LIKE "%Indian Love%";

-- Solución:
SELECT  a.first_name AS nombre, a.last_name AS apellido
FROM film AS f
INNER JOIN film_actor AS fa ON f.film_id = fa.film_id
INNER JOIN actor AS a ON fa.actor_id = a.actor_id
WHERE f.title = "Indian Love";

/* 14. Muestra el título de todas las películas que contengan la palabra  "dog" o "cat" en su descripción. */

SELECT title AS nombre_pelicula
FROM film
WHERE description LIKE "%dog%" OR "%cat%";

/* 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.*/

-- Solución:
SELECT DISTINCT CONCAT(a.first_name, " ", a.last_name) AS nombre_actor
	FROM actor AS a LEFT JOIN film_actor AS fa
	ON a.actor_id = fa.actor_id
	WHERE fa.actor_id IS NULL;
    
-- Otra forma de hacerlo:
SELECT DISTINCT CONCAT(a.first_name, " ", a.last_name) AS nombre_actor
FROM actor AS a
WHERE NOT EXISTS (
    SELECT 1 
    FROM film_actor AS fa
    WHERE fa.actor_id = a.actor_id
);

/* 16. Encuentra el tículo de todas las películas que fueron lanzadas entre el año 2005 y 2010 */

SELECT title AS nombre_pelicula
	FROM film
	WHERE release_year BETWEEN 2005 AND 2010;

/* 17. Encuentra el título de todas las películas que son de la misma categoría que "Family" */

SELECT f.title AS nombre_categoría_family
	FROM film AS f INNER JOIN film_category USING (film_id)
				INNER JOIN category USING (category_id)
	WHERE name = "Family";
    
-- Otra forma más larga:
SELECT f.title AS nombre_categoría_family
	FROM film AS f INNER JOIN film_category AS fc USING (film_id)
				INNER JOIN category AS c USING (category_id)
	WHERE c.category_id = (
							SELECT category_id 
							FROM category 
							WHERE name = "Family"
	);

/* 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas. */

-- Hemos visto que es necesario unir las film_id en ambas tablas para observar correspondencias,
-- Actor con id X aparece en Y peliculas 

-- Solución:
SELECT a.first_name AS nombre, a.last_name AS apellido
FROM actor AS a INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) > 10;


-- Forma más compleja usando CTEs, teniendo en cuenta tabla film:
WITH condicion_peli_por_actor AS (
    SELECT fa.actor_id, COUNT(fa.film_id) 
    FROM film_actor AS fa
    GROUP BY fa.actor_id
    HAVING COUNT(fa.film_id) > 10)
SELECT a.first_name, a.last_name
FROM actor AS a
INNER JOIN condicion_peli_por_actor AS pa
ON a.actor_id = pa.actor_id;

/* 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la
tabla film. */

-- 2 horas son 120 minutos

SELECT title AS nombre_pelicula
FROM film
wHERE length > 120 AND rating LIKE "%R";

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y
muestra el nombre de la categoría junto con el promedio de duración */

-- Pasos previos: Unir tabla "category", "film_category" y "film"
		-- "category" contiene el nombre de la categoría que nos interesa mostrar
        -- "film" contiene la duración, "length" de cada película, agrupar
        -- "film_category" conecta ambos conjuntos de datos
        -- Vamos primero a clasificar por categorías las películas y hacer un promedio por categoría usando AVG(COUNT())
        -- Por último extraemos las categorías con el promedio > 120 minutos
        
SELECT c.name AS categoria , ROUND(AVG(f.length)) AS promedio_duracion
	FROM film AS f
    INNER JOIN film_category AS fc USING (film_id)
    INNER JOIN category AS c USING (category_id)
    GROUP BY name
	HAVING AVG(f.length) > 120;

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto
con la cantidad de películas en las que han actuado.*/

-- Entendiendo la lógica:
	-- Primer paso:
		-- El objetivo primero es ver en cuántas películas ha actuado cada actor
SELECT DISTINCT CONCAT(first_name, " ", last_name) AS nombre_actor, COUNT(film_id) AS peliculas_actuado
	FROM actor INNER JOIN film_actor USING (actor_id)
	GROUP BY actor_id;
    
	-- Solución completa:
-- Extraer los que han hecho al menos (>=) 5 películas
SELECT DISTINCT CONCAT(first_name, " ", last_name) AS nombre_actor, COUNT(film_id) AS peliculas_actuado
	FROM actor INNER JOIN film_actor USING (actor_id)
            GROUP BY actor_id
			HAVING COUNT(film_id) >= 5;

/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una
	subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las
	películas correspondientes. */
    
-- Las únicas columnmas que nos pueden dar la cantidad de días que se han alquilado las películas son 
-- rental_date y return_date en tabla rental. Hay que calcular la diferencia entre las fechas.
             
SELECT f.title AS nombre_pelicula_Mas5_días_alquilada, customer_id AS ID_cliente
FROM film AS f INNER JOIN inventory AS i USING (film_id)
				INNER JOIN rental AS r USING (inventory_id)
               WHERE r.rental_id IN (SELECT r.rental_id
										FROM rental
                                        WHERE DATEDIFF(r.return_date, r.rental_date) > 5);
                                        
-- * Vamos a añadir un DISTINCT a title al final para ver las películas alquiladas más de 5 días sin duplicados
-- pero la query completa anterior nos sirve en caso de querer identificar otros datos como: rental_id, inventory_id, customer_id, ...

-- Solución:

SELECT DISTINCT f.title AS nombre_pelicula_Mas5_días_alquilada
FROM film AS f INNER JOIN inventory AS i USING (film_id)
				INNER JOIN rental AS r USING (inventory_id)
               WHERE r.rental_id IN (SELECT r.rental_id
										FROM rental
                                        WHERE DATEDIFF(r.return_date, r.rental_date) > 5);                     
                                        
/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría
"Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la
categoría "Horror" y luego exclúyelos de la lista de actores. */

-- Pasos previos:
SELECT * FROM actor; -- dato que buscamos

SELECT * FROM category; -- condición WHERE

SELECT * FROM film_category; 

SELECT * FROM film_actor;

-- Primero obtenemos los actores que han actuado en las películas de horror (subconsulta):

SELECT DISTINCT CONCAT(a.first_name, " ", a.last_name) AS actores_horror
FROM actor AS a INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
				INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
				INNER JOIN category AS c ON fc.category_id = c.category_id
				WHERE c.name = "Horror";
                
-- Realizamos la consulta principal con la subconsulta

-- Solución:
SELECT CONCAT(first_name, " ", last_name) AS actores_no_horror
FROM actor
WHERE CONCAT(first_name, " ", last_name) NOT IN ( 
						SELECT DISTINCT CONCAT(a.first_name, " ", a.last_name)
						FROM actor AS a INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
						INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
						INNER JOIN category AS c ON fc.category_id = c.category_id
						WHERE c.name = "Horror"
						);

/* 24.  Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en
la tabla film. */

SELECT * FROM film; -- extraer title y usar duración como condición

SELECT * FROM film_category; 

SELECT * FROM category; -- clasificar en base a esta tabla

-- Solución:   

SELECT f.title AS titulo_pelicula, c.name AS categoria, length
	FROM film AS f INNER JOIN film_category AS fc ON f.film_id = fc.film_id
					INNER JOIN category AS c ON fc.category_id = c.category_id
                    WHERE name = "Comedy" AND length > 180;
