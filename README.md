*PROGRAMACIÓN DE SCRIPT SQL PARA EJERCICIO DE EVALUACIÓN DEL MÓDULO 2 DE DATA ANALYSIS*

En el presente repositorio podrá encontrar el documento en formato .sql llamado "Ejercicio_Evaluacion_Modulo_2" con el programa elaborado para realizar 24 queries/consultas o subqueries/subconsultas relacionadas con la popular base de datos (BBDD) Sakila.

    *Sobre la Base de Datos Sakila*

    Sakila es una BBDD muy común ya que permite practicar consultas con una estructura realista. En este ejercicio se han explorado sus datos para evaluar conocimientos en SQL, desde consultas básicas hasta operaciones más avanzadas con JOINs, subconsultas, funciones de agregación y condiciones de filtrado.

    *Enfoque del Análisis*

    En base a los datos organizados en tablas de la BBDD hemos sido capaces de establecer relaciones y entender la lógica del Diagrama EER de Sakila.

    - film: Contiene información sobre las películas.
    - film_actor: Relaciona películas con actores.
    - actor: Lista de actores y actrices.
    - film_category: Relaciona películas con sus categorías.
    - category: Contiene los géneros de películas.
    - rental: Registra los alquileres de películas.
    - inventory: Relaciona películas con copias disponibles en las tiendas.
    - customer: Información sobre los clientes.

    *Objetivos del Análisis*
    - Búsqueda y limpieza de datos para mejorar la calidad de la información.
    - Realización de consultas avanzadas utilizando JOINs, subconsultas y agrupaciones.
    - Clasificación de información según distintos criterios, como duración de películas, número de         alquileres o categorías más populares.
    - Obtención de estadísticas clave, como la cantidad de películas alquiladas por categoría o el número de actores que han participado en más de un cierto número de películas.
    - Uso de funciones SQL (COUNT, AVG, DATEDIFF, GROUP BY, HAVING, etc.) para obtener insights relevantes.


        *Ejemplo de ejercicio y su consulta*
    19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la
        tabla film. */

        Solución:


         SELECT title AS nombre_pelicula
            FROM film
            wHERE length > 120 AND rating LIKE "%R"

        *** Al ejecutar se muestra una tabla con el nombre de las películas solicitadas
        

    Por último, puede encontrar a continuación un esquema para entender mejor el script:

                +---------------+       +------------------+       +--------------+       
|   customer    |       |      rental      |       |   inventory  |       
+---------------+       +------------------+       +--------------+       
| customer_id PK|──┬──▶ | rental_id  PK    | ──┬──▶ | inventory_id PK |  
| first_name    |  |    | customer_id FK   |    |   | film_id  FK      |  
| last_name     |  |    | inventory_id FK  |    |   |                |  
| email         |  |    | rental_date      |    |   +--------------+   
+---------------+  |    | return_date      |    |   
                   |    +------------------+    |  
                   |                             |  
                   ▼                             ▼  
              +------------------+          
              |      film        |          
              +------------------+          
              | film_id     PK   |          
              | title            |          
              | rental_duration  |          
              +------------------+          
                     ▲  
                     |  
      +---------------------------+  
      |      film_category        |  
      +---------------------------+  
      | film_id     FK            |  
      | category_id FK            |  
      +---------------------------+  
                     ▲  
                     |  
          +----------------+  
          |    category    |  
          +----------------+  
          | category_id PK |  
          | name          |  
          +----------------+  


