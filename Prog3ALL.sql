-- NAME: Dmytro Kuzmyk NETID: dkuzmy3
-- 1. Generate a table containing nicely formatted customer information.
-- Retrieve the name, address and contact details of the customer 
-- as NAME, ADDRESS, CONTACT_DETAILS, ORDER_ID, ordered by last name. 
-- NAME includes both first and last name appended with with a space character in between. 
-- ADDRESS is calculated in the following way: <street> <city>, <state>, <zip_code>. 
-- CONTACT_DETAILS contains the string as: "Email: <email>, Phone: <phone>". 
-- If either of the email or the phone of the customer is null string, replace it with the string "N/A".
-- EXAMPLE 
-- 1445 rows returned
-- first row
# NAME, ADDRESS, CONTACT_DETAILS
#'Penny Acevedo', '318 Mulberry Drive  Ballston Spa, NY, 12020', 'Email: penny.acevedo@yahoo.com, Phone: N/A'

SELECT CONCAT_WS(' ', sales.customers.first_name, sales.customers.last_name) AS NAME,		-- unify name and last name with the function concat, put a space between
	   CONCAT_WS(', ',CONCAT_WS(' ', sales.customers.street, sales.customers.city), sales.customers.state, sales.customers.zip_code ) AS ADDRESS,
       CONCAT_WS(', ',CONCAT_WS(' ','Email:', IFNULL(sales.customers.email, 'N/A')), CONCAT_WS(' ','Phone:', IFNULL(sales.customers.phone, 'N/A')) ) AS CONTACT_DETAILS -- nested concat
       -- orders.order_id AS ORDER_ID -- unknown whether we use this or not, the example doesn't have this field but it's indicated in the description
       
FROM sales.customers, sales.orders	-- select the tables
WHERE orders.customer_id = customers.customer_id	-- match the customer_id so we allign the tables
ORDER BY last_name ASC;								-- order by last name




-- 2. Find the contact information for a particular customer.
-- Retrieve the name, address and contact details of the customer 
-- for the order_id stored in @oid as NAME, ADDRESS, CONTACT_DETAILS, ORDER_ID. 
-- Format is the same as question one, just output for a single order instead of all customers.
-- NAME includes both first and last name appended with with a space character in between. 
-- ADDRESS is calculated in the following way: <street> <city>, <state>, <zip_code>. 
-- CONTACT_DETAILS contains the string as: "Email: <email>, Phone: <phone>". 
-- If either of the email or the phone of the customer is null string, replace it with the string "N/A".
-- EXAMPLE 
-- input: set @oid = 5
# NAME, ADDRESS, CONTACT_DETAILS
# 'Arla Ellis', '127 Crescent Ave.  Utica, NY, 13501', 'Email: arla.ellis@yahoo.com, Phone: N/A'

SELECT CONCAT_WS(' ', sales.customers.first_name, sales.customers.last_name) AS NAME,	-- same as q1
	   CONCAT_WS(', ',CONCAT_WS(' ', sales.customers.street, sales.customers.city), sales.customers.state, sales.customers.zip_code ) AS ADDRESS,
       CONCAT_WS(', ',CONCAT_WS(' ','Email:', IFNULL(sales.customers.email, 'N/A')), CONCAT_WS(' ','Phone:', IFNULL(sales.customers.phone, 'N/A')) ) AS CONTACT_DETAILS
       -- orders.order_id AS ORDER_ID
       
FROM sales.customers, sales.orders
WHERE orders.customer_id = customers.customer_id AND @oid = orders.order_id;	-- match the order id we want to review
            



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

-- 4. Investigate how long it takes in general (average number of days) for an order to get completed (time from order to shipping). 
-- Calculate the value as AVG_DAYS.
-- note that the - operand may produce strange values for different months/years
-- EXAMPLE
# AVG_DAYS
# '1.9835'

SELECT avg(datediff(shipped_date, order_date)) AS AVG_DAYS	-- use datediff function that calculates dates on its own
FROM sales.orders;


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



-- 6.  For each store, report the Average turnaround (time from order to shipment).
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



-- 7. For each store, list the percentage of orders which did not ship until after the required_date.
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


-- 8. Each store decides to give away free coupons to the customers 
-- who have ordered items from their store more than once. 
-- Retrieve STORE_NAME, CUSTOMER_NAME, NUM_ORDERS
-- CUSTOMER_NAME includes both first and last name appended with with a space character in between. 
-- Only keep the store-customer pairs where more than one order has been made.
-- Sort the results by store name alphabetic, then in decreasing order of NUM_ORDERS, 
-- and alphabetic by last name in the case of ties.
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



-- 9. List information about each order.
-- Retrieve NAME, ORDER_ID, TOTAL_PRICE_BEFORE_DISCOUT, TOTAL_DISCOUNT
-- NAME includes both first and last customer name appended with with a space character in between. 
-- TOTAL_PRICE_BEFORE_DISCOUNT is the number of items multiplied by the list prices of those items, added up over all items in the order
-- TOTAL_DISCOUNT is the sum of the discount applied item by item to the total prices calculated in the prior linee
-- Order results by order_id
-- EXAMPLE 
-- 1615 rows returned
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


