/*
Query 1: WHERE subquery returning one value
Write a query that uses a subquery in the WHERE clause to count the number of payments that are greater than the
average.
*/
SELECT COUNT(*) AS payment_above_avg
FROM payment
WHERE amount > 
	(
    SELECT AVG(amount)
        FROM payment
	);
/*
Query 2: WHERE clause using IN operator subquery returning a list
2.A Write a query that uses a subquery in the WHERE clause using the IN operator to displays all payments for
customers associated with store id 2. Order by customer id and payment date.
*/
SELECT customer_id, payment_date, amount
FROM payment
WHERE customer_id IN  
(
SELECT customer_id
FROM customer
WHERE store_id = 2
)
ORDER BY customer_id, payment_date DESC;
/*
2.B Rewrite the query to use a INNER JOIN (default join type) instead of a subquery
*/
SELECT p.customer_id, payment_date, amount
FROM payment p JOIN customer c 
	ON p.customer_id = c.customer_id
WHERE store_id = 2
ORDER BY customer_id, payment_date DESC;
/*
Query 3: WHERE clause using the ALL operator subquery returning a list
3.A Write a query that uses a subquery in the WHERE clause using the ALL operator to display all customer's payments
where the amount is greater than all of customer 1's payments. Order by customer id and payment date.
*/
SELECT customer_id, payment_date, amount
FROM payment
WHERE amount > ALL
(
SELECT amount
FROM payment
WHERE customer_id = 1
);
/*
3.B Rewrite the query to use a subquery using the MAX aggerated function instead of ALL operator.
*/
SELECT customer_id, payment_date, amount
FROM payment
WHERE amount > 
(
SELECT MAX(amount)
FROM payment
WHERE customer_id = 1
);
/*
Query 4: WHERE correlated subquery running multiple times (once for each outer
row)
4.A Write a query that uses the AVG aggerated function to display each customer's average amount paid
*/
SELECT customer_id, AVG(amount)
FROM payment
GROUP BY customer_id;
/*
4.B Write a query that uses a correlated subquery in the WHERE clause to count all customer's payments greater than
the customer's average payment.
*/
SELECT customer_id, COUNT(amount) AS count_over_avg_payment
FROM payment p
WHERE amount >
	(
	SELECT AVG(amount)
	FROM payment
    WHERE customer_id = p.customer_id
    )
GROUP BY customer_id;
/*
Query 5: WHERE subquery using EXISTS operator returning a Boolean value
NOTE: create a new customer so that there is at least one customer without a payment
5.A Write a query that uses a subquery in the WHERE clause with the NOT EXISTS operator for customers who do not
have any payments. Order by customer id.
*/
#INSERT customer VALUES (default, 2, "JOE", "MAMA", NULL, 300, 1, NULL, NULL);

SELECT customer_id, first_name, last_name
FROM customer c 
WHERE NOT EXISTS
(
SELECT customer_id
FROM payment 
WHERE customer_id = c.customer_id 
)
ORDER BY customer_id;
/*
5.B Rewrite the query to use a LEFT JOIN instead of a subquery
*/
SELECT c.customer_id, first_name, last_name
FROM customer c LEFT JOIN payment p ON p.customer_id = c.customer_id 
WHERE p.customer_id IS NULL
ORDER BY c.customer_id;
/*
Query 6: SELECT subquery returning a single value
6.A Write a query that uses a correlated subquery in the SELECT clause displaying each customer's MAX payment date.
Order by customer id DESC.
*/
SELECT customer_id, first_name, last_name,
	(
		SELECT MAX(payment_date) FROM payment
        WHERE customer_id = c.customer_id
    ) AS latest_payment
FROM customer c
ORDER BY customer_id DESC;
/*
6.B Rewrite the query to use a LEFT JOIN instead of a subquery
*/
SELECT c.customer_id, c.first_name, c.last_name, MAX(p.payment_date) AS latest_payment
FROM customer c LEFT JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id DESC;
/*
Query 7: FROM subquery returning a inline view (temporary table)
7.A Write a query that display the top customer based on total amount paid. To do this, group the payment table by
customer, sort descending by total amount paid and limit the query to only display the first record.
*/
SELECT customer_id, SUM(amount) AS total_paid
FROM payment
GROUP BY customer_id
ORDER BY total_paid DESC
LIMIT 1;
/*
7.B Write a query that displays all the payments for the top customer by joining 7.A query to the payment table sorting
by payment date.
*/    
SELECT t.customer_id, amount, payment_date
FROM
(
	SELECT customer_id, SUM(amount) AS total_paid
	FROM payment 
	GROUP BY customer_id
	ORDER BY total_paid DESC
	LIMIT 1
) t JOIN payment p ON t.customer_id = p.customer_id
