USE mavenfuzzyfactory;

SELECT *
FROM orders;

SELECT *
FROM order_item_refunds;

SELECT
	order_items.order_id,
    order_items.order_item_id,
    order_items.price_usd AS price_paid_usd,
    order_items.created_at,
    order_item_refunds.order_item_refund_id,
    order_item_refunds.refund_amount_usd,
    order_item_refunds.created_at
FROM order_items
	LEFT JOIN order_item_refunds
		ON order_item_refunds.order_item_id = order_items.order_item_id
WHERE order_items.order_id IN (3489,32049,27061);

-- -----------------------------------------------------------------

SELECT * 
FROM order_items;

SELECT * 
FROM orders;

SELECT
	YEAR(order_items.created_at) AS yr,
    MONTH(order_items.created_at) AS mo,
    COUNT(CASE WHEN order_items.product_id = 1 THEN order_items.order_item_id ELSE NULL END) AS p1_orders,
	COUNT(CASE WHEN order_items.product_id = 1 THEN order_item_refunds.order_item_refund_id ELSE NULL END) AS p1_refunds,
    
    COUNT(CASE WHEN order_items.product_id = 1 THEN order_item_refunds.order_item_refund_id ELSE NULL END)/
    COUNT(CASE WHEN order_items.product_id = 1 THEN order_items.order_item_id ELSE NULL END) AS p1_refund_rt
FROM order_items
	LEFT JOIN order_item_refunds
		ON order_item_refunds.order_item_id = order_items.order_item_id
WHERE 
    order_items.created_at < '2014-10-15'
GROUP BY
	1,2;


















