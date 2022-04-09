USE mavenmovies;

SELECT * 
FROM rental;

SELECT *
FROM inventory;

SELECT
	customer_id,
    rental_date
FROM rental;

SELECT
	first_name,
    last_name,
    email
FROM customer;

SELECT DISTINCT
	rating
FROM film;

SELECT DISTINCT
	rental_duration
FROM film;







