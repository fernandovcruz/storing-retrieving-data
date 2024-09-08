USE cube_smasher;

# F.
# 1- List all the customer’s names, dates, and products rented by these customers in a range of two dates

# QUERY EXECUTION PLAN: Using only primary and foreign keys, the optimizer optimizes the query as much as possible choosing one table
# as the starting point of the inner joins. The table choosen to start with is not constant and varies with the number of records in each table
# among other factors. All the joins are perfomed using foreign keys, which have an automatic index attributed if there is not an index yet.
# Therefore, the matches on the joins are direct and only one row (per match on the inner join) needs to be processed when joining two tables.
# THE PROBLEM: The rental_date verification is performed for every row retrieved by the joins, so a lot of unnecessary records are
# processed to check if they belong to the date interval.
# OPTIMIZATION SUGGESTION: Creating an index on RENTAL.rental_date will make the optimizer always choose RENTAL as the starting point for
# the joins, with the records within the dates already filtered directly using the index. This way, no unnecessary verifications will
# be perfomed and the nr of rows being processed will always be the same number of records of RENTAL that lie within that dates interval.
# This way, the query will be as optimized as possible.

-- EXPLAIN
SELECT r.rental_date, CONCAT(c.first_name, ' ', c.last_name) AS ClientName , rp.copy_id, m.`name` AS MovieName
FROM RENTAL r
JOIN RENTAL_PRODUCT rp ON r.rental_id = rp.rental_id
JOIN MOVIE m ON rp.movie_id = m.movie_id
JOIN `CLIENT` c ON r.client_id = c.client_id
WHERE r.rental_date BETWEEN '2020-01-10' AND '2020-07-30'; # change here the range of dates

ALTER TABLE RENTAL ADD INDEX (rental_date); # run this line to optimize the query above
DROP INDEX rental_date ON RENTAL;

# 2 - List the best three customers -> the ones with highest total expenditure

# QUERY EXECUTION PLAN:  The query performs inner joins on tables CLIENT, RENTAL and RENTAL_PRODUCT using foreign keys. The matches done in this
# inner joins are direct and can not be further optimized. At the end, a GROUP BY is perfomed on a primary key (already ordered), followed by an
# ORDER BY and then a LIMIT, which can only be calculated after the entire set of TotalExpenditure has been calculated for each client_id.
# OPTIMIZATION SUGGESTION: There is no optimization to be done for this query. All processed need necessarily to be processed because the
# query does not have any condition to meet.

-- EXPLAIN
SELECT c.client_id, CONCAT(c.first_name,' ',c.last_name) AS ClientName, SUM(rp.price) AS TotalExpenditure
FROM `CLIENT` c
JOIN RENTAL r ON c.client_id = r.client_id
JOIN  RENTAL_PRODUCT rp ON rp.rental_id = r.rental_id
GROUP BY c.client_id
ORDER BY TotalExpenditure DESC
LIMIT 3;

# 3 - Get the average amount of sales/bookings/rents/deliveries for a period that involves 2 or more years, as in the following example. This query only returns one record:

# QUERY EXECUTION PLAN: Again, RENTAL.rental_date is being filtered and has no index associated with it.
# This way, all rows in RENTAL are scaned and then this rows are inner joined with the RENTAL_PRODUCT table, in which
# only the foreign key is needed. Then, maths are performed in the outer query. Here is no optimization to be done since
# the inner query only returns one record and the maths are performed using that same query only.
# THE PROBLEM: As in Question 1, the rental_date verification is perfomed for every row, so a lot of unnecessary records are processed
# to check if they belong to the date interval.
# OPTIMIZATION SUGGESTION: Create an index in RENTAL.rental_date so that only the rows within the dates interval are scanned.

# NOTE: we assumed that the yearly and monthly averages are calculated using the nr of completed years and months between the two dates.
# Therefore, we assume that, for example, 2.4 years or 11.75 months are not valid, using in these cases 2 years and 11 months instead.

# Doing maths on the TotalSales field retrieved on the inner query
-- EXPLAIN
SELECT CONCAT('2020/02/17', ' - ', '2022/03/08') AS PeriodOfSales,
	   TotalSales,
       ROUND(TotalSales / TIMESTAMPDIFF(YEAR, '2020-02-17', '2022-03-08'), 2) AS YearlyAverage,
       ROUND(TotalSales / TIMESTAMPDIFF(MONTH, '2020-02-17', '2022-03-08'), 2) AS MonthlyAverage
FROM (
	# Getting TotalSales between two dates
	SELECT SUM(rp.price) AS TotalSales
    FROM RENTAL r
    JOIN RENTAL_PRODUCT rp ON r.rental_id = rp.rental_id
    WHERE r.rental_date BETWEEN '2020-02-17' AND '2022-03-08'
) AS tot_sales;

ALTER TABLE RENTAL ADD INDEX (rental_date);
DROP INDEX rental_date ON RENTAL;

# 4 - Get the total rentals by geographical location -> We chose state as geographical location.

# QUERY EXECUTION PLAN: The query performs a series of inner joins using foreign keys, which already have indexes associated with.
# To do this, the optimizer chooses one of the tables to start with and scans all its rows, performing the inner joins for each row.
# In the end, a group by is done in a primary key column.
# OPTIMIZATION SUGGESTION: There is no way to optimize the query.

# we can access the location of the store where the rental occured by getting the store where the employee that registered the rental works
-- EXPLAIN
SELECT sta.state_id, sta.state_name, COUNT(1) AS NrSales
FROM RENTAL r
JOIN EMPLOYEE e on e.employee_id = r.employee_id
JOIN STORE sto on sto.store_id = e.store_id
JOIN LOCATION l on l.location_id = sto.location_id
JOIN STATE sta on sta.state_id = l.state_id
GROUP BY sta.state_id;

# 5 - List all the locations where products were sold, and the product has customer’s ratings

# QUERY EXECUTION PLAN: The query performs a series of inner joins using foreign keys. To do this, the optimizer chooses one of
# the tables to start with and scans all its rows, performing the inner joins for each row. At the end, a filter in RENTAL_PRODUCT.rating is
# applied to find the rows with this field as not NULL.
# THE PROBLEM: RENTAL_PRODUCT.rating does not have an index. Because of that, all the rows retrieved are considered and the condition is checked.
# This makes the query inefficient since not all the rows needed to be scaned necessarily.
# OPTIMIZATION SUGGESTION: Creating an index in RENTAL_PRODUCT.rating will make the rows scaned equal to the rows returned,
# reducing this unnecessary checking.

# NOTES: ratings are given to copies and not movies, given that a copy is the actual physical product that is rented
-- EXPLAIN
SELECT DISTINCT state_id, street_address, zip_code, city
FROM LOCATION l
JOIN STORE s ON l.location_id = s.location_id
JOIN COPY c ON s.store_id = c.store_id
JOIN RENTAL_PRODUCT rp ON c.copy_id = rp.copy_id AND c.movie_id = rp.movie_id
WHERE rp.rating IS NOT NULL;

ALTER TABLE RENTAL_PRODUCT ADD INDEX (rating);
DROP INDEX rating ON RENTAL_PRODUCT;

# G

# View with the products details
CREATE VIEW invoice_details AS
SELECT rp.rental_id, m.`name` AS MovieName, ROUND(SUM(rp.price) / COUNT(1), 2) AS UnitCost, COUNT(1) AS QTY, SUM(rp.price) AS Amount
FROM RENTAL_PRODUCT rp
JOIN MOVIE m ON m.movie_id = rp.movie_id
WHERE rp.rental_id = 1 # change here the invoice nr we want to generate
GROUP BY m.movie_id;

SELECT * FROM invoice_details;
DROP VIEW invoice_details;

# View with head and totals
# Both STORE and CLIENT have a foreign key to LOCATION and we want to get the locations of both store and client.
# Given this, we need to do two joins with LOCATION separately. We chose to get the location of each the client first
# and only then we joined the client's information with the rest of the tables.

CREATE VIEW invoice_head_totals AS
SELECT r.rental_id AS InvoiceNr,
       r.rental_date AS DateOfIssue,
       ClientName,
       ClientAddress,
       SUM(Amount) AS SubTotal,
       0.23 AS TAX,
       SUM(Amount) * 1.23 AS Total,
       "CubeSmasher" as CompanyName,
       CONCAT(l.street_address, ' ', l.zip_code, ', ', l.state_id) AS StoreAddress,
       s.store_email AS StoreEmail,
	   CONCAT("Please return the products until ",  DATE_ADD(r.rental_date, INTERVAL 30 DAY), " or a fine will be aplied") AS Terms
FROM RENTAL r
JOIN invoice_details d ON d.rental_id = r.rental_id # with this join we do not need to select the rental_id we want again because it was already selected in the invoice_details view
JOIN EMPLOYEE e ON r.employee_id = e.employee_id
JOIN STORE s ON e.store_id = s.store_id
JOIN LOCATION l ON l.location_id = s.location_id # get store's location
JOIN (
	# get clients' locations
	SELECT client_id, CONCAT(c.first_name, ' ', c.last_name) AS ClientName, 
    CONCAT(l.street_address, ' ', l.zip_code, ', ', l.state_id) AS ClientAddress
    FROM `CLIENT` c
    JOIN LOCATION l ON l.location_id = c.location_id
) AS clients_locations ON clients_locations.client_id = r.client_id # get client of that rental along with his address that has already been retrieved
GROUP BY r.rental_id;

SELECT * FROM invoice_head_totals;
DROP VIEW invoice_head_totals;