USE mavenfuzzyfactory;

SELECT
	pageview_url,
    COUNT(DISTINCT website_pageview_id) AS pvs
FROM website_pageviews
WHERE
	website_pageview_id < 1000 -- arbitrary
GROUP BY pageview_url
ORDER BY pvs DESC;

/* ---------------------------------------------------------- */

CREATE TEMPORARY TABLE first_pageview
SELECT
	website_session_id,
    MIN(website_pageview_id) AS min_pv_id
FROM website_pageviews
WHERE
	website_pageview_id < 1000
GROUP BY
	website_session_id;
    
/* ---------------------------------------------------------- */

SELECT * FROM first_pageview;

SELECT 
	website_pageviews.pageview_url AS landing_page, -- aka 'entry page'
    COUNT(DISTINCT first_pageview.website_session_id) AS session_hitting_this_lander
FROM first_pageview
	LEFT JOIN  website_pageviews
		ON first_pageview.min_pv_id = website_pageviews.website_pageview_id
GROUP BY
	website_pageviews.pageview_url;

/* ---------------------------------------------------------- */

SELECT * FROM website_pageviews;

SELECT
	pageview_url,
    COUNT(DISTINCT website_pageview_id) AS sessions
FROM website_pageviews
WHERE
	created_at < '2012-06-09'
GROUP BY
	pageview_url
ORDER BY
	sessions DESC;

/* ---------------------------------------------------------- */

-- STEP 1: first the first pageview for each session
-- STEP 2: find the url the customer saw on that first view

-- CREATE TEMPORARY TABLE first_pv_per_session
SELECT
	website_session_id,
    MIN(website_pageview_id) AS first_pv_id
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY
	website_session_id;
    
SELECT * FROM first_pv_per_session;

SELECT
	website_pageviews.pageview_url AS landing_page_url,
    COUNT(DISTINCT first_pv_per_session.website_session_id) AS sessions_hitting_page
FROM first_pv_per_session
	LEFT JOIN website_pageviews
		ON first_pv_per_session.website_session_id = website_pageviews.website_session_id
GROUP BY
	website_pageviews.pageview_url
ORDER BY
	2 DESC;

SELECT
*
FROM first_pv_per_session
	LEFT JOIN website_pageviews
		ON first_pv_per_session.website_session_id = website_pageviews.website_session_id;



	


























