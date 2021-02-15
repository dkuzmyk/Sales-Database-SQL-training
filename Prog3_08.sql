-- NAME: Dmytro Kuzmyk NETID: dkuzmy3
-- 8. Each store decides to give away free coupons to the customers 
-- who have ordered items from their store more than once. 
-- Retrieve STORE_NAME, CUSTOMER_NAME, NUM_ORDERS
-- CUSTOMER_NAME includes both first and last name appended with with a space character in between. 
-- Only keep the store-customer pairs where more than one order has been made.
-- Sort the results by store name alphabetic, then in decreasing order of NUM_ORDERS, 
-- and alphabetic by last name in the case of ties..
-- EXAMPLE
-- 132 rows returned
-- first row
# STORE_NAME, CUSTOMER_NAME, NUM_ORDERS
# 'Baldwin Bikes', 'Genoveva Baldwin', '3'

SELECT stores.store_name AS STORE_NAME,
	   CONCAT_WS(' ', sales.customers.first_name, sales.customers.last_name) AS CUSTOMER_NAME,
       count(orders.customer_id) AS NUM_ORDERS
       
FROM sales.customers, sales.stores, sales.orders -- strage natural selection
WHERE stores.store_id = orders.store_id			-- match stuff
AND customers.customer_id = orders.customer_id	-- match more stuff
GROUP BY customer_name					-- we group the calculations by customer_name so each customer has his own calc
HAVING NUM_ORDERS > 1					-- filter by num_orders > 1
ORDER BY store_name ASC, NUM_ORDERS desc, last_name;

