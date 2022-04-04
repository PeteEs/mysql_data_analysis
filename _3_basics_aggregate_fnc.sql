USE mavenmovies;

SELECT
	title,
    description
FROM film
WHERE description LIKE '%Dentist%';

SELECT
	title,
    description
FROM film
WHERE description LIKE '%Epic%';

SELECT
	title,
    description
FROM film
WHERE description LIKE '%China';

SELECT
	title,
    description
FROM film
WHERE title LIKE '_LADDIN CALENDA_';

SELECT
	title,
    special_features
FROM film
WHERE special_features LIKE '%Behind the Scenes%';

SELECT
	rating,
    COUNT(film_id)
FROM film
GROUP BY
	rating;

SELECT
	rating,
    COUNT(film_id),
    COUNT(film_id) AS films_with_this_rating
FROM film
GROUP BY
	rating;

SELECT
	rental_duration,
    COUNT(film_id) AS films_with_this_rental_duration
FROM film
GROUP BY
	rental_duration;

SELECT
	rating,
    rental_duration,
    COUNT(film_id) AS count_of_films
FROM film
GROUP BY
	rating,
    rental_duration;

SELECT
	rating,
    rental_duration,
    replacement_cost,
    COUNT(film_id) AS count_of_films
FROM film
GROUP BY
	rating,
    rental_duration,
    replacement_cost;
    
SELECT
	rating,
    COUNT(film_id) AS count_of_films,
    MIN(length) AS shortest_film,
    MAX(length) AS longest_film,
    AVG(length) AS average_length_of_film,
    -- SUM(length) AS total_minutes
    AVG(rental_duration) AS average_rental_duration
FROM film
GROUP BY
	rating;

SELECT
	replacement_cost,
	COUNT(film_id) AS number_of_films,
    MIN(rental_rate) AS cheapest_rental,
    MAX(rental_rate) AS most_expensive_rental,
	AVG(rental_rate) AS average_rental
FROM film
GROUP BY
	replacement_cost
ORDER BY
	replacement_cost DESC;

SELECT
	customer_id,
    COUNT(*) AS total_rental
FROM rental
GROUP BY
	customer_id
HAVING COUNT(*) >= 30;

SELECT
	customer_id,
    COUNT(rental_id) AS total_rentals
FROM rental
GROUP BY
	customer_id
HAVING COUNT(rental_id) >= 30;

SELECT
	customer_id,
    COUNT(rental_id) AS total_rentals
FROM rental
GROUP BY
	customer_id
HAVING COUNT(rental_id) < 15;

SELECT
	customer_id,
    rental_id,
    amount,
    payment_date
FROM payment
ORDER BY amount DESC, customer_id;

SELECT
	customer_id,
	SUM(amount) AS total_payment_amount
FROM payment
GROUP BY
	customer_id
ORDER BY
	SUM(amount) DESC;

SELECT
	title,
    length,
    rental_rate
FROM film
ORDER BY
	length DESC;






























