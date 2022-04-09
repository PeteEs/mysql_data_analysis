USE mavenfuzzyfactory;

SELECT 

	CASE 
		WHEN http_referer IS NULL THEN 'direct_type_in'
		WHEN http_referer = 'https://www.gsearch.com' AND utm_source IS NULL THEN 'gsearch_organic'
        WHEN http_referer = 'https://www.bsearch.com' AND utm_source IS NULL THEN 'bsearch_organic'
		ELSE 'other'
	END AS additional,
    
    COUNT(DISTINCT website_session_id) AS sessions
    
FROM website_sessions

WHERE website_session_id BETWEEN 100000 AND 115000 -- arbitrary range
	-- AND utm_source IS NULL
    
GROUP BY
	1
ORDER BY
	2 DESC;



SELECT
*
FROM website_sessions;

SELECT
	YEAR(created_at) AS yr,
    MONTH(created_at) AS mo,
    -- COUNT(DISTINCT website_session_id) AS sessions,
    
    COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id = 1 ELSE NULL END) AS nonbrand,
    COUNT(CASE WHEN utm_campaign = 'brand' THEN website_session_id = 1 ELSE NULL END) AS brand,
    COUNT(CASE WHEN utm_campaign = 'brand' THEN website_session_id = 1 ELSE NULL END)/
    COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id = 1 ELSE NULL END) AS brand_pct_of_nonbrand,
    
    COUNT(CASE WHEN http_referer IS NULL THEN website_session_id = 1 ELSE NULL END) AS direct,
    COUNT(CASE WHEN http_referer IS NULL THEN website_session_id = 1 ELSE NULL END)/
    COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id = 1 ELSE NULL END) AS d_pct_of_nonbrand,
    
    COUNT(CASE WHEN http_referer IN('https://www.gsearch.com','https://www.bsearch.com') 
    AND utm_source IS NULL THEN website_session_id = 1 ELSE NULL END) AS orgainc,
    COUNT(CASE WHEN http_referer IN('https://www.gsearch.com','https://www.bsearch.com') 
    AND utm_source IS NULL THEN website_session_id = 1 ELSE NULL END)/
    COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id = 1 ELSE NULL END) AS o_pct_of_nonbrand
    
FROM website_sessions
WHERE
	created_at < '2012-12-23'
GROUP BY
	YEAR(created_at),
    MONTH(created_at);
    




















