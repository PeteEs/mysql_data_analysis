USE mavenfuzzyfactory;

SELECT * FROM website_pageviews;

-- Demo on Building Conversion Funnels

-- BUSINESS CONTEXT
	-- we want to build a mini conversion funnel, from /lander-2 to /cart
    -- we want to know how many people reach each step, and also dropoff rates
    -- for simplicity of the demo, we're looking at /lander-2 traffic only
    -- for simplocty of the demo, we're looking at customers who like Mr Fuzzy only
    
-- STEP 1: select all pageviews for relevant sessions
-- STEP 2: identify each relevant pageview as the specyfic funnel step
-- STEP 3: create the session-level conversion funnel view
-- STEP 4: aggregate the data to assess funnel performance

-- first I will show you all of the pageviews we care about
-- then, I will remove the comments from my flag columns one by one to show you what that looks like

SELECT
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at
    ,CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page
    ,CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page
    ,CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- random timeframe
	AND website_pageviews.pageview_url IN ('/lander-2','/products','/the-original-mr-fuzzy','/cart')
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at;

-- next we will put the previous query inside a subquery (similiar to temporary tables)
-- we will group by website_session_id, and take the MAX() of each of the flags
-- this MAX() becomes a made_it flag for that session, to show the session made it there

SELECT
	website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
	MAX(cart_page) AS cart_made_it
FROM(

SELECT
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at
    ,CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page
    ,CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page
    ,CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- random timeframe
	AND website_pageviews.pageview_url IN ('/lander-2','/products','/the-original-mr-fuzzy','/cart')
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at
    
) AS pageview_level

GROUP BY
	website_session_id;

-- next, we will turn in into a temp table

CREATE TEMPORARY TABLE session_level_made_it_flags_demo
SELECT
	website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
	MAX(cart_page) AS cart_made_it
FROM(

SELECT
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at
    ,CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page
    ,CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page
    ,CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- random timeframe
	AND website_pageviews.pageview_url IN ('/lander-2','/products','/the-original-mr-fuzzy','/cart')
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at
    
) AS pageview_level

GROUP BY
	website_session_id;

-- -------------- 

SELECT * FROM session_level_made_it_flags_demo;

-- then this would produce the final output (part 1)

SELECT
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT
				CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
	COUNT(DISTINCT
				CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
	COUNT(DISTINCT
				CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart
FROM session_level_made_it_flags_demo;

-- then we'll translate those counts to click rates for final output part 2 (click rates)
		-- same query + rates calculation
        
SELECT
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT
				CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) 
						AS clicked_to_products,
	COUNT(DISTINCT
				CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)
						AS clicked_to_mrfuzzy,
	COUNT(DISTINCT
				CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)
						AS clicked_to_cart
FROM session_level_made_it_flags_demo;
        
-- --------------------------------------------------------------------------------------------

-- task 1

SELECT * FROM website_pageviews; -- /products , /the-original-mr-fuzzy , /cart , '/shipping' , '/billing' , '/thank-you-for-your-order'
        
SELECT
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at
    ,CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page
    ,CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page
    ,CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
    ,CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page
    ,CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page
    ,CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
		AND website_sessions.utm_campaign = 'nonbrand'
        AND website_sessions.created_at > '2012-08-05'
        AND website_sessions.created_at < '2012-09-05'
	-- website_sessions.created_at BETWEEN '2014-08-05' AND '2014-09-05' -- random timeframe
	-- AND website_pageviews.pageview_url IN ('/lander-2','/products','/the-original-mr-fuzzy','/cart','/shipping','/billing','/thank-you-for-your-order')
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at;
        
-- ---------------------------------------------------

CREATE TEMPORARY TABLE session_level_made_it_flags_demo_3
SELECT
	website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
	MAX(cart_page) AS cart_made_it,
	MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
	MAX(thankyou_page) AS thankyou_made_it
FROM(

SELECT
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at
    ,CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page
    ,CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page
    ,CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
    ,CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page
    ,CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page
    ,CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.utm_source = 'gsearch'
		AND website_sessions.utm_campaign = 'nonbrand'
        AND website_sessions.created_at > '2012-08-05'
        AND website_sessions.created_at < '2012-09-05'
	-- website_sessions.created_at BETWEEN '2014-08-05' AND '2014-09-05' -- random timeframe
	-- AND website_pageviews.pageview_url IN ('/lander-2','/products','/the-original-mr-fuzzy','/cart','/shipping','/billing','/thank-you-for-your-order')
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at
    
) AS pageview_level

GROUP BY
	website_session_id;

-- ---------------------------------------------------

SELECT
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
	COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
	COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_level_made_it_flags_demo_3;

/* ------------------------------------------------------------------------------------- */

-- task 2

SELECT 
	MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS first_pageview_id
FROM website_pageviews
WHERE pageview_url = '/billing-2'
	AND created_at IS NOT NULL;

-- first_pageview_id = 53550
    
SELECT
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen,
    orders.order_id
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.website_pageview_id >= 53550
        AND website_pageviews.created_at < '2012-11-10'
        AND website_pageviews.pageview_url IN ('/billing','/billing-2');


SELECT
	billing_version_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS billing_to_order_rt
FROM(
SELECT
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen,
    orders.order_id
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.website_pageview_id >= 53550
        AND website_pageviews.created_at < '2012-11-10'
        AND website_pageviews.pageview_url IN ('/billing','/billing-2')
) AS billing_sessions_w_orders
GROUP BY
	billing_version_seen;



