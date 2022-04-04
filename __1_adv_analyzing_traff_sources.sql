SELECT *
FROM website_sessions
WHERE website_session_id = 1059;

SELECT *
FROM website_pageviews
WHERE website_session_id = 1059;

SELECT *
FROM orders
WHERE website_session_id = 1059;

SELECT DISTINCT
	utm_source,
    utm_campaign
FROM website_sessions;

SELECT *
FROM website_sessions
WHERE website_session_id BETWEEN 1000 AND 2000;

SELECT
	utm_content,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE website_session_id BETWEEN 1000 AND 2000
GROUP BY
	utm_content -- column position may be used here
ORDER BY
	COUNT(DISTINCT website_session_id) DESC;

SELECT
	utm_content,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE website_session_id BETWEEN 1000 AND 2000
GROUP BY
	1
ORDER BY
	2 DESC;

/* -------------------------------------------------------------------------- */

SELECT
	website_sessions.utm_content,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rt
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.website_session_id BETWEEN 1000 AND 2000
GROUP BY
	1
ORDER BY
	2 DESC;

/* -------------------------------------------------------------------------- */

SELECT
	utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE
	created_at < '2012-04-12'
GROUP BY
	utm_source,utm_campaign,http_referer
ORDER BY
	COUNT(DISTINCT website_session_id) DESC;

/* -------------------------------------------------------------------------- */

SELECT
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
	COUNT(DISTINCT orders.order_id) AS orders,
	COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE 
	website_sessions.created_at < '2012-04-12'
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand';

/* -------------------------------------------------------------------------- */

SELECT
    WEEK(created_at),
    YEAR(created_at),
    MIN(DATE(created_at)) AS week_start,
    COUNT(DISTINCT website_session_id) AS sessions
    
FROM website_sessions
WHERE website_session_id BETWEEN 100000 AND 115000 -- arbitrary;
	GROUP BY
		1,2;

/* -------------------------------------------------------------------------- */

SELECT
	primary_product_id,
    COUNT(DISTINCT CASE
					WHEN items_purchased = 1 THEN order_id ELSE NULL END)
								AS orders_w_1_item,
	COUNT(DISTINCT CASE
					WHEN items_purchased = 2 THEN order_id ELSE NULL END) 
								AS orders_w_2_item,
	COUNT(DISTINCT order_id) AS total_orders
FROM orders
WHERE order_id BETWEEN 31000 AND 32000
GROUP BY
	1;
    
/* -------------------------------------------------------------------------- */

SELECT 
	MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT website_session_id) AS sessions
FROM  website_sessions
WHERE
	created_at < '2012-05-10'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY
	YEAR(created_at),
	WEEK(created_at);

/* -------------------------------------------------------------------------- */

SELECT
	website_sessions.device_type,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
	COUNT(DISTINCT orders.order_id) AS orders,
	COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate    
FROM website_sessions
LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE
	website_sessions.created_at < '2012-05-11'
	AND website_sessions.utm_source = 'gsearch'
	AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY
	website_sessions.device_type;
    
/* -------------------------------------------------------------------------- */
				
SELECT 
	MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT website_session_id) AS total_sessions,
    COUNT(CASE
			WHEN device_type = 'desktop' THEN website_session_id = 1 ELSE NULL END)
								AS dtop_sessions,
	COUNT(CASE
			WHEN device_type = 'mobile' THEN website_session_id = 1 ELSE NULL END)
								AS mob_sessions
FROM  website_sessions
WHERE
	created_at < '2012-06-09'
    AND created_at > '2012-04-15'
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
GROUP BY
	YEAR(created_at),
	WEEK(created_at);

/* -------------------------------------------------------------------------- */












