-- NAME: Dmytro Kuzmyk NETID: dkuzmy3
-- 7. For each store, list the percentage of orders which did not ship until after the required_date
-- Retrieve the STORE_NAME, PERCENT_OVERDUE with the greatest first, alphabetic in the case of a tie.
-- EXAMPLE
# STORE_NAME, PERCENT_OVERDUE
# 'Santa Cruz Bikes', '29.3103'
# 'Baldwin Bikes', '27.8134'
# 'Rowlett Bikes', '20.1149'

SELECT  store_name AS STORE_NAME,
		(COUNT(IF (datediff(shipped_date, required_date)>0,1,NULL))/COUNT(orders.order_id))*100 AS PERCENT_OVERDUE 
        -- we count the cases where shipped_date-required_date>0 means it's late and divide by total number of orders and make the %
      
FROM sales.orders, sales.stores
WHERE stores.store_id = orders.store_id
GROUP BY store_name
ORDER BY PERCENT_OVERDUE desc, store_name ASC;
