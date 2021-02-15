-- NAME: Dmytro Kuzmyk NETID: dkuzmy3
-- 5. Based on the calculation in 4 (use the computed value, not a hard coded one),
-- return the orders which are in 'Pending' or 'Processing' states (question 3)
-- which are exceeding the average from the current date stored in @today
-- and may require expedited priority.
-- The table should return the columns 
-- ORDER_ID, DAYS_SINCE_ORDER
-- sorted starting from the longest DAYS_SINCE_ORDER. 
-- EXAMPLE
-- input: SET @today = '2018-03-21'
-- 22 rows returned
-- first row
# ORDER_ID, DAYS_SINCE_ORDER
# '1430', '11'

-- SET @today = '2018-03-21';
SET @average = (SELECT avg(datediff(shipped_date, order_date)) FROM sales.orders);  -- we do the average of dates of complition

SELECT order_id AS ORDER_ID, 														-- magic happens
       datediff(@today, order_date) AS DAYS_SINCE_ORDER
       -- avg(datediff(shipped_date, order_date)) AS AVG_DAYS
       
FROM sales.orders
WHERE (orders.order_status = 1 OR orders.order_status = 2)
-- GROUP BY DAYS_SINCE_ORDER
-- HAVING DAYS_SINCE_ORDER > avg(datediff(orders.shipped_date, orders.order_date));
HAVING DAYS_SINCE_ORDER >= @average;												-- we only show the id's that have completion days higher than the average days of complition