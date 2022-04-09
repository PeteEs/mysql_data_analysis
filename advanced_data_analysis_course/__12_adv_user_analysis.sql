USE mavenfuzzyfactory;

SELECT
	order_items.order_id,
    order_items.order_item_id,
    order_items.price_usd AS price_paid_usd,
    order_items.created_at,
    order_item_refunds.order_item_refund_id,
    order_item_refunds.refund_amount_usd,
    order_item_refunds.created_at,
    DATEDIFF(order_item_refunds.created_at, order_items.created_at) AS days_order_to_refund
    
FROM order_items
	LEFT JOIN order_item_refunds
		ON order_item_refunds.order_item_id = order_items.order_item_id
WHERE order_items.order_id IN (3489,32049,27061);

-- ---------------------------

-- STEP 1: identify the relevant new session
-- STEP 2: user the user_id values from step 1 to find any repeat sessions those users hd
-- STEP 3: analyze the data at the user level
-- STEP 4: aggregate the user-level analysis to generate your behavioral analysis

-- ---------------------------

-- STEP 1: identify the reveland new sessions
-- STEP 2: use the user_id values from step 1 to find any repeat session those users had
-- STEP 3: find the created_at times for first and second sessions
-- STEP 4: find the difference between first and second sessions at a user level
-- STEP 5: aggregate the user level data to find the average, min, max

-- ---------------------------

SELECT
	utm_source,
    utm_campaign,
    http_referer,
	COUNT(DISTINCT CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
    COUNT(DISTINCT CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
FROM website_sessions
WHERE
	created_at >='2014-01-01'
    AND created_at < '2014-11-05'
GROUP BY
	1,2,3
ORDER BY
	5 DESC;

-- ------------

SELECT
	CASE
		WHEN utm_campaign = 'nonbrand' THEN 'nonbrand'
        WHEN utm_campaign  = 'brand' THEN 'brand'
    END AS channel_group,
    
    COUNT(DISTINCT CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
    COUNT(DISTINCT CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
    
FROM website_sessions
WHERE
	created_at >='2014-01-01'
    AND created_at < '2014-11-05'
GROUP BY
	1;
    
-- ---------------------------

SELECT *
FROM orders;


SELECT
	website_sessions.is_repeat_session,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
	COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(price_usd)/COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at <'2014-11-08'
    AND website_sessions.created_at >='2014-01-01'
GROUP BY
	website_sessions.is_repeat_session




















