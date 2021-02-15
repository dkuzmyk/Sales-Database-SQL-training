-- NAME: Dmytro Kuzmyk NETID: dkuzmy3
-- 3. Filter out only the active orders.
-- Since we want to optimize the delivery services, 
-- from the orders table retrieve all the orders with 'Pending' and 'Processing' status 
-- and return a table with fields ORDER_ID, STATUS, STORE_ZIPCODE, CUSTOMER_ZIPCODE, REQUIRED_DATE. 
-- Order the results by STORE_ZIPCODE (ascending) and then by REQUIRED_DATE (earliest first).
-- The order statuses are as follows
-- Pending: 1 
-- Processing: 2
-- Rejected: 3
-- Completed : 4
-- EXAMPLE
-- 186 rows returned
-- first row
# ORDER_ID, STATUS, STORE_ZIPCODE, CUSTOMER_ZIPCODE, REQUIRED_DATE
# '1432', '2', '11432', '11757', '2018-03-12'

 SELECT orders.order_id AS ORDER_ID, 			-- get all the stuff to display
       orders.order_status AS STATUS,
       stores.zip_code AS STORE_ZIPCODE,
       customers.zip_code AS CUSTOMER_ZIPCODE,
       orders.required_date AS REQUIRED_DATE
       
       
FROM sales.customers, sales.orders, sales.stores	-- select tables
WHERE orders.customer_id = customers.customer_id    -- match id's so the tables allign
AND stores.store_id = orders.store_id				-- match order id so the other 2 tables allign
AND (orders.order_status = 1 OR orders.order_status = 2)	-- only unfinished orders
ORDER BY stores.zip_code ASC, orders.required_date ASC;     -- order
