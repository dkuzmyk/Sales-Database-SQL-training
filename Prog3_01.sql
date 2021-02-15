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

