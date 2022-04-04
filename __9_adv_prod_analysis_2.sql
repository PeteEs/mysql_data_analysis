USE mavenfuzzyfactory;

SELECT DISTINCT
	pageview_url
FROM website_pageviews
WHERE created_at BETWEEN '2013-02-01' AND '2013-03-01';

SELECT
	-- website_session_id,
    website_pageviews.pageview_url,
    COUNT(DISTINCT website_pageviews.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_pageviews.website_session_id) AS viewed_product_to_order_rate
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at BETWEEN '2013-02-01' AND '2013-03-01'
	AND website_pageviews.pageview_url IN ('/the-original-mr-fuzzy','/the-forever-love-bear')
GROUP BY
	1;

-- ---------------------------------------------------------------

SELECT * 
FROM website_sessions;

SELECT *
FROM website_pageviews;

-- ------------------------------

SELECT 
	'A.Pre_product_2' AS time_period,
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at > '2012-10-06'
		AND created_at < '2013-01-06'

UNION

SELECT 
	'B.Post_product_2' AS time_period,
	COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE created_at > '2013-01-06'
		AND created_at < '2013-04-06';
        
-- ------------------------------

-- task 1:

-- Assignment_Product_Pathing_Analysis

-- Step 1: find the relevant /products pageviews with website session_id
-- Step 2: find the next pageview id that occurs AFTER the product pageview
-- Step 3: find the pageview_url associated with any appplicable next pageview_id
-- Step 4: summarize the data and analyze the pre vs post periods

-- Step 1: find the relevant /products pageviews with website session_id
CREATE TEMPORARY TABLE products_pageviews
SELECT
	website_session_id,
    website_pageview_id,
    created_at,
    CASE
		WHEN created_at < '2013-01-06' THEN 'A. Pre_Product_2'
        WHEN created_at >= '2013-01-06' THEN 'B. Post_Product_2'
        ELSE 'uh oh ... check logic'
	END AS time_period
FROM website_pageviews
WHERE created_at < '2013-04-06'
	AND created_at > '2012-10-06'
	AND pageview_url = '/products';

-- Step 2: find the next pageview id that occurs AFTER the product pageview
CREATE TEMPORARY TABLE sessions_w_next_pageview_id
SELECT
	products_pageviews.time_period,
    products_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_next_pageview_id
FROM products_pageviews
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = products_pageviews.website_session_id
        AND website_pageviews.website_pageview_id > products_pageviews.website_pageview_id
GROUP BY
	1,2;

-- Step 3: find the pageview_url associated with any appplicable next pageview_id
CREATE TEMPORARY TABLE sessions_w_next_pageview_url
SELECT
	sessions_w_next_pageview_id.time_period,
    sessions_w_next_pageview_id.website_session_id,
    website_pageviews.pageview_url AS next_pageview_url
FROM sessions_w_next_pageview_id
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = sessions_w_next_pageview_id.min_next_pageview_id;

-- Step 4: summarize the data and analyze the pre vs post periods

SELECT
	time_period,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id ELSE NULL END) AS w_next_pg,
    COUNT(DISTINCT CASE WHEN next_pageview_url IS NOT NULL THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS pct_w_next_pg,
    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-original-mr-fuzzy' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS pct_to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END) AS to_lovebear,
    COUNT(DISTINCT CASE WHEN next_pageview_url = '/the-forever-love-bear' THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS pct_to_lovebear
FROM sessions_w_next_pageview_url
GROUP BY
	time_period;

-- -----------------------------------------------------------------------------------------------------------------------------------

-- task 2:

















