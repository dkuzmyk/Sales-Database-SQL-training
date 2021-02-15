-- NAME: Dmytro Kuzmyk NETID: dkuzmy3
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

-- SET @oid = 1115;


SELECT CONCAT_WS(' ', sales.customers.first_name, sales.customers.last_name) AS NAME,	-- same as q1
	   CONCAT_WS(', ',CONCAT_WS(' ', sales.customers.street, sales.customers.city), sales.customers.state, sales.customers.zip_code ) AS ADDRESS,
       CONCAT_WS(', ',CONCAT_WS(' ','Email:', IFNULL(sales.customers.email, 'N/A')), CONCAT_WS(' ','Phone:', IFNULL(sales.customers.phone, 'N/A')) ) AS CONTACT_DETAILS
       -- orders.order_id AS ORDER_ID
       
FROM sales.customers, sales.orders
WHERE orders.customer_id = customers.customer_id AND @oid = orders.order_id;	-- match the order id we want to review
            
