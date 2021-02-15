-- NAME: Dmytro Kuzmyk NETID: dkuzmy3
-- 9. List information about each order.
-- Retrieve NAME, ORDER_ID, TOTAL_PRICE_BEFORE_DISCOUT, TOTAL_DISCOUNT
-- NAME includes both first and last customer name appended with with a space character in between. 
-- TOTAL_PRICE_BEFORE_DISCOUNT is the number of items multiplied by the list prices of those items, added up over all items in the order
-- TOTAL_DISCOUNT is the sum of the discount applied item by item to the total prices calculated in the prior linee
-- Order results by order_id
-- EXAMPLE 
-- 1615 rows reutrned
-- first row
# NAME, ORDER_ID, TOTAL_PRICE_BEFORE_DISCOUT, TOTAL_DISCOUNT
# 'Johnathan Velazquez', '1', '11397.94', '1166.8936'

SELECT CONCAT_WS(' ', sales.customers.first_name, sales.customers.last_name) AS NAME,
	   orders.order_id AS ORDER_ID,
       sum(list_price*quantity) AS TOTAL_PRICE_BEFORE_DISCOUNT,		-- calculations for total price
       sum(list_price*quantity*discount) AS TOTAL_DISCOUNT			-- calculations for discount

FROM sales.orders, sales.customers, sales.order_items
WHERE orders.order_id = order_items.order_id						-- match stuff
AND orders.customer_id = customers.customer_id
GROUP BY order_id													-- group by orders so each order is calculated separately for its items
ORDER BY order_id;													-- group by orders

