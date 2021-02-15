-- NAME: Dmytro Kuzmyk NETID: dkuzmy3
-- 10. Identify whether there may be some correlation between
-- the amount ordered and the time it takes to ship the order
-- Compute the average and standard deviation of the time per quantity of each order
-- EXAMPLE
# AVG, STDDEV
# '0.64447607', '0.5703154314602293'

SELECT avg(datediff(shipped_date, order_date)/(SELECT sum(quantity) -- take average of (complition_days / quantity of items per order)
											   FROM sales.order_items -- we filter quantity in a subquery because i was getting error 1111 lol, this way it works
                                               WHERE orders.order_id = order_items.order_id)) AS AVG,
                                               
	   STDDEV(datediff(shipped_date, order_date)/(SELECT sum(quantity) -- take std of (complition_days / quantity of items per order) 
												  FROM sales.order_items
												  WHERE orders.order_id = order_items.order_id)) AS STDDEV
       
FROM sales.orders;

