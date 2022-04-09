USE mavenfuzzyfactory;

SELECT *
FROM website_sessions;

SELECT *
FROM orders;

/*
1. First, I’d like to show our volume growth. Can you pull overall session and order volume, 
trended by quarter for the life of the business? Since the most recent quarter is incomplete, 
you can decide how to handle it.
*/ 

SELECT
	YEAR(website_sessions.created_at) yr,
    QUARTER(website_sessions.created_at) qtr,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(orders.order_id)/COUNT(website_sessions.website_session_id) AS orders_to_sessions
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2015-03-20'
GROUP BY
	YEAR(website_sessions.created_at),
	QUARTER(website_sessions.created_at);

/*
2. Next, let’s showcase all of our efficiency improvements. I would love to show quarterly figures 
since we launched, for session-to-order conversion rate, revenue per order, and revenue per session. 
*/

SELECT
	YEAR(website_sessions.created_at) yr,
    QUARTER(website_sessions.created_at) qtr,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    ROUND(COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id),3) AS orders_to_sessions,
    ROUND(SUM(price_usd)/COUNT(DISTINCT orders.order_id),2) AS revenue_per_order,
    ROUND(SUM(price_usd)/COUNT(DISTINCT website_sessions.website_session_id),2) AS revenue_per_session
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2015-03-20'
GROUP BY
	YEAR(website_sessions.created_at),
	QUARTER(website_sessions.created_at);

/*
3. I’d like to show how we’ve grown specific channels. Could you pull a quarterly view of orders 
from Gsearch nonbrand, Bsearch nonbrand, brand search overall, organic search, and direct type-in?
*/

SELECT
	YEAR(website_sessions.created_at) yr,
    QUARTER(website_sessions.created_at) qtr,
  
	COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN order_id ELSE NULL END) AS orders_g_nonbrand,
  	COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN order_id ELSE NULL END) AS orders_b_nonbrand,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN order_id ELSE NULL END) AS orders_brand
  
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2015-03-20'
GROUP BY
	YEAR(website_sessions.created_at),
	QUARTER(website_sessions.created_at);    


/*
4. Next, let’s show the overall session-to-order conversion rate trends for those same channels, 
by quarter. Please also make a note of any periods where we made major improvements or optimizations.
*/

SELECT
	YEAR(website_sessions.created_at) yr,
    QUARTER(website_sessions.created_at) qtr,
  
	COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS orders_g_nonbrand_to_sessions,
  	COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS orders_b_nonbrand_to_sessions,
	COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN orders.order_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) AS orders_brand_to_sessions
  
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE
	website_sessions.created_at < '2015-03-20'
GROUP BY
	YEAR(website_sessions.created_at),
	QUARTER(website_sessions.created_at); 

/*
5. We’ve come a long way since the days of selling a single product. Let’s pull monthly trending for revenue 
and margin by product, along with total sales and revenue. Note anything you notice about seasonality.
*/

SELECT
	YEAR(created_at) yr,
    MONTH(created_at) qtr,

	SUM(price_usd) AS revenue,
    SUM(price_usd - cogs_usd) AS margin
FROM orders
WHERE
	created_at < '2015-03-20'
GROUP BY
	YEAR(created_at),
	MONTH(created_at); 

SELECT
	YEAR(created_at) yr,
    MONTH(created_at) qtr,
    
	SUM(CASE WHEN product_id = 1 THEN price_usd ELSE NULL END) AS mrfuzzy_rev,
    SUM(CASE WHEN product_id = 1 THEN price_usd - cogs_usd ELSE NULL END) AS mrfuzzy_rev,
		
	SUM(price_usd) AS revenue,
    SUM(price_usd - cogs_usd) AS margin
    
FROM order_items
GROUP BY
	YEAR(created_at),
	MONTH(created_at); 




