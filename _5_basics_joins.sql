SELECT DISTINCT
	inventory.inventory_id,
    inventory.store_id,
    film.title,
    film.description
FROM film
	INNER JOIN inventory
		ON film.film_id = inventory.film_id;
        
SELECT DISTINCT
	inventory.inventory_id
FROM inventory
	INNER JOIN rental
		ON inventory.inventory_id = rental.inventory_id
LIMIT 5000;

SELECT DISTINCT
	inventory.inventory_id,
    inventory.store_id,
    film.title,
    film.description
FROM inventory
	INNER JOIN film
		ON inventory.film_id = film.film_id;
        
SELECT
	actor.first_name,
    actor.last_name,
    COUNT(film_actor.film_id) AS number_of_films
FROM actor
	LEFT JOIN film_actor
		ON actor.actor_id = film_actor.actor_id
GROUP BY
	actor.first_name,
    actor.last_name
ORDER BY
	COUNT(film_actor.film_id) DESC;
        
SELECT
	film.title,
    COUNT(DISTINCT film_actor.actor_id) AS number_of_actors
FROM film
	LEFT JOIN film_actor
		ON film.film_id = film_actor.film_id
GROUP BY
	film.title
ORDER BY
	COUNT(DISTINCT film_actor.actor_id) DESC;
        
/* --------------------------------------------------------------- */

SELECT
	film.film_id,
    film.title,
    category.name AS category_name
FROM film
	INNER JOIN film_category
		ON film.film_id = film_category.film_id
	INNER JOIN category
		ON film_category.category_id = category.category_id;

SELECT
	actor.first_name,
    actor.last_name,
    film.title
FROM film
	INNER JOIN film_actor
		ON film.film_id = film_actor.film_id
	INNER JOIN actor
		ON film_actor.actor_id = actor.actor_id
ORDER BY last_name, first_name, title;

SELECT
	film.film_id,
    film.title,
    film.rating,
    category.name
FROM film
	INNER JOIN film_category
		ON film.film_id = film_category.film_id
	INNER JOIN category
		ON film_category.category_id = category.category_id
WHERE category.name = 'horror'
ORDER BY
	film_id;

SELECT
	film.film_id,
    film.title,
    film.rating,
    category.name
FROM film
	INNER JOIN film_category
		ON film.film_id = film_category.film_id
	INNER JOIN category
		ON film_category.category_id = category.category_id
		AND category.name = 'horror'
ORDER BY
	film_id;

SELECT DISTINCT
	film.title,
    film.description
FROM film
	INNER JOIN inventory
		ON film.film_id = inventory.film_id
	INNER JOIN store
		ON inventory.store_id = store.store_id
        AND store.store_id = 2;
	
SELECT DISTINCT
	film.title,
    film.description
FROM film
	INNER JOIN inventory
		ON film.film_id = inventory.film_id
		AND inventory.store_id = 2;
        
SELECT
	'advisor' AS type,
    first_name,
    last_name
FROM advisor

UNION

SELECT
	'investor' AS type,
    first_name,
    last_name
FROM investor;

SELECT
	'advisor' AS type,
    first_name,
    last_name
FROM advisor

UNION

SELECT
	'staff' AS type,
    first_name,
    last_name
FROM staff;





        
        
        
        
        
        
