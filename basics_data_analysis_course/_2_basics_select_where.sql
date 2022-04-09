USE mavenmovies;

SELECT
	customer_id,
    rental_id,
    amount,
    payment_date
FROM payment
WHERE amount = 0.99;

SELECT
	customer_id,
    rental_id,
    amount,
    payment_date
FROM payment
WHERE payment_date > '2006-01-01';

SELECT *
FROM payment
WHERE customer_id < 101;

SELECT
	customer_id,
    rental_id,
    amount,
    payment_date
FROM payment
WHERE amount = 0.99
	AND payment_date > '2006-01-01';

SELECT
* FROM payment
WHERE customer_id <= 100
	AND amount >= 5
    AND payment_date >= '2006-01-10';

SELECT
	customer_id,
    rental_id,
    amount,
    payment_date
FROM payment
WHERE customer_id = 5
	OR customer_id = 11
    OR customer_id = 29;

SELECT 
* FROM payment
WHERE customer_id = 42
	OR customer_id = 53
    OR customer_id = 60
    OR customer_id = 73
    AND amount >= 5;

SELECT
	customer_id,
    rental_id,
	amount,
    payment_date
FROM payment
WHERE amount > 5
	OR customer_id IN (42,53,60,75);
