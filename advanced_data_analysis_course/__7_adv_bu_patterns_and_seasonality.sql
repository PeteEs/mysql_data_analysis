USE mavenfuzzyfactory;

SELECT
	website_session_id,
    created_at,
    HOUR(created_at) AS hr,
    WEEKDAY(created_at) AS wkday, -- 0 = Monday, 1 = Tuesday ..
    CASE
		WHEN WEEKDAY(created_at) = 0 THEN 'Monday'
        WHEN WEEKDAY(created_at) = 1 THEN 'Tuesday'
        ELSE 'other_day'
	END AS cleand_weekday,
    QUARTER(created_at) AS qtr,
    MONTH(created_at) AS mo,
    DATE(created_at) AS date,
    WEEK(created_at) AS wk
    
FROM website_sessions

WHERE website_session_id BETWEEN 150000 AND 155000; -- arbitrary

-- --------------------------------------------------------------------------------------

SELECT
	YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at)AS mo,
	
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders
FROM website_sessions
LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id
WHERE
	website_sessions.created_at < '2013-01-02'
GROUP BY
	YEAR(website_sessions.created_at),
    MONTH(website_sessions.created_at);
	
-- ---------------------------

SELECT
	MIN(DATE(website_sessions.created_at)) AS week_start_date,
	
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders
FROM website_sessions
LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id
WHERE
	website_sessions.created_at < '2013-01-02'
GROUP BY
	YEAR(website_sessions.created_at),
    MONTH(website_sessions.created_at),
    WEEK(website_sessions.created_at);

-- --------------------------------------------------------------------------------------

SELECT
	website_session_id,
	WEEKDAY(created_at)
FROM website_sessions
WHERE
	WEEKDAY(created_at) = 0;

-- ------------------------------

SELECT
	DATE(created_at) AS created_date,
    WEEKDAY(created_at) AS wkday,
    HOUR(created_at) AS hr,
    COUNT(DISTINCT website_session_id) AS website_sessions
FROM website_sessions
WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY
	1,2,3;

-- ----------------------------------

SELECT 
	hr,
    ROUND(AVG(website_sessions),1) AS avg_sessions,
    ROUND(AVG(CASE WHEN wkday = 0 THEN website_sessions ELSE NULL END),1) AS mon,
    ROUND(AVG(CASE WHEN wkday = 1 THEN website_sessions ELSE NULL END),1) AS tue,
    ROUND(AVG(CASE WHEN wkday = 2 THEN website_sessions ELSE NULL END),1) AS wed,
    ROUND(AVG(CASE WHEN wkday = 3 THEN website_sessions ELSE NULL END),1) AS thu,
    ROUND(AVG(CASE WHEN wkday = 4 THEN website_sessions ELSE NULL END),1) AS fri,
    ROUND(AVG(CASE WHEN wkday = 5 THEN website_sessions ELSE NULL END),1) AS sat,
    ROUND(AVG(CASE WHEN wkday = 6 THEN website_sessions ELSE NULL END),1) AS sun
FROM (
SELECT
	DATE(created_at) AS created_date,
    WEEKDAY(created_at) AS wkday,
    HOUR(created_at) AS hr,
    COUNT(DISTINCT website_session_id) AS website_sessions
FROM website_sessions
WHERE 
	created_at > '2012-09-15' 
    AND created_at < '2012-11-15'
GROUP BY
	1,2,3    
) AS daily_hourly_sessions
GROUP BY 1;
















