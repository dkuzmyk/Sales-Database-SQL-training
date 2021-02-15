-- NAME: Dmytro Kuzmyk NETID: dkuzmy3
-- 6.  For each store, report the Average turnaround (time from order to shipment)
-- Retrieve the STORE_NAME, AVG_TURNAROUND ordered by the fastest stores first, alphabetic in the case of a tie.
-- EXAMPLE
# STORE_NAME, AVG_TURNAROUND
# 'Rowlett Bikes', '1.9203'
# 'Baldwin Bikes', '1.9766'
# 'Santa Cruz Bikes', '2.0399'

SELECT  store_name AS STORE_NAME,
		avg(datediff(shipped_date, order_date)) AS AVG_TURNAROUND		-- obvious by now
      
FROM sales.orders, sales.stores											-- idk what to say anymore
WHERE stores.store_id = orders.store_id
GROUP BY store_name														-- we group by store name so each store name has its own calculations
ORDER BY AVG_TURNAROUND ASC, store_name ASC;
