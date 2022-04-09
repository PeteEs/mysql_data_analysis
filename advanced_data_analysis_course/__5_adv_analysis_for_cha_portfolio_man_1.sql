USE mavenfuzzyfactory;

SELECT DISTINCT 
*
FROM website_sessions;

SELECT DISTINCT
	is_repeat_session,
    device_type
FROM website_sessions;

SELECT
	website_sessions.utm_content,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conversion_rate -- aka 'conversion rate'
    
FROM website_sessions
	LEFT JOIN orders
		ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- arbitrary

GROUP BY 1
ORDER BY sessions DESC;

-- ----------------------------------------------------------------------------------------

SELECT
	MIN(DATE(created_at)) AS week_start_date,
	COUNT(DISTINCT website_session_id) AS sessions,
    
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch_sessions
    
FROM website_sessions
	WHERE created_at > '2012-08-22' 
    AND created_at < '2012-11-29'
    AND utm_campaign = 'nonbrand'
GROUP BY
	YEAR(created_at),
	WEEK(created_at);

-- ----------------------------------------------------------------------------------------

SELECT *
FROM website_sessions;

SELECT 
	utm_source,
	COUNT( website_session_id) AS sessions,
	COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id = 1 ELSE NULL END) AS mobile_sessions,
	COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id = 1 ELSE NULL END)/COUNT( website_session_id) AS pct_mobile

FROM website_sessions
	WHERE created_at > '2012-08-22' 
    AND created_at < '2012-11-30'
    AND utm_campaign = 'nonbrand'
GROUP BY
	utm_source;

-- ----------------------------------------------------------------------------------------

SELECT 

	website_sessions.device_type,
	website_sessions.utm_source,
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id)/COUNT(website_sessions.website_session_id) AS conv_rate
	-- COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id = 1 ELSE NULL END) AS mobile_sessions,
	-- COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id = 1 ELSE NULL END)/COUNT( website_session_id) AS pct_mobile

FROM website_sessions
LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id
    
WHERE website_sessions.created_at > '2012-08-22' 
    AND website_sessions.created_at < '2012-09-19'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY
	website_sessions.device_type,
    website_sessions.utm_source
ORDER BY
	website_sessions.device_type,
    website_sessions.utm_source;

-- ----------------------------------------------------------------------------------------

SELECT

	MIN(DATE(created_at)) AS week_start_date,
	-- COUNT(DISTINCT website_session_id) AS sessions
    
    COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'gsearch' THEN website_session_id = 1 ELSE NULL END) AS g_dtop_sessions,
	COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'bsearch' THEN website_session_id = 1 ELSE NULL END) AS b_dtop_sessions,

	COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'bsearch' THEN website_session_id = 1 ELSE NULL END)/
	COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'gsearch' THEN website_session_id = 1 ELSE NULL END) AS b_pct_of_g_dtop,
    
    COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'gsearch' THEN website_session_id = 1 ELSE NULL END) AS g_dtop_sessions,
	COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'bsearch' THEN website_session_id = 1 ELSE NULL END) AS b_dtop_sessions,
    
    COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'bsearch' THEN website_session_id = 1 ELSE NULL END)/
    COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'gsearch' THEN website_session_id = 1 ELSE NULL END) AS b_pct_of_g_mob

FROM website_sessions
	WHERE created_at > '2012-11-04' 
    AND created_at < '2012-12-22'
    AND utm_campaign = 'nonbrand'
GROUP BY
	YEAR(created_at),
	WEEK(created_at);













