CREATE DATABASE coffee
;

USE coffee
;

CREATE TABLE coffee_data
(
hour_purchased INT,
payment VARCHAR(20),
total_transaction FLOAT,
coffee_type VARCHAR(50),
time_purchased VARCHAR(30),
day_purchased VARCHAR(20),
month_purchased VARCHAR(20),
day_number INT,
month_number INT,
date_purchased DATE);

USE coffee;

#IMPORT DATA
#COFFEE_DATAA TABLES > TABLE IMPORT WIZARD > SELECT DATA FILE > EXECUTE

# SHOW PREVIEW DATA
SELECT *
FROM coffee_data;

#DATA CLEANING

#DROP COLUMN THAT WILL NOT BE USED (NOT IMPORTANT)
ALTER TABLE coffee_data
DROP COLUMN day_number,
DROP COLUMN month_number
;

#CHECKING DUPLICATES
WITH duplicate_cte AS
( SELECT *,
ROW_NUMBER() OVER(
PARTITION BY hour_purchased, payment, total_transaction, coffee_type, time_purchased, day_purchased, month_purchased, date_purchased) AS rownumber
FROM coffee_data
)
SELECT *
FROM duplicate_cte
WHERE rownumber > 1
;

#UPDATE DATA
CREATE TABLE coffee_data2
(
hour_purchased INT,
payment VARCHAR(20),
total_transaction FLOAT,
coffee_type VARCHAR(50),
time_purchased VARCHAR(30),
day_purchased VARCHAR(20),
month_purchased VARCHAR(20),
date_purchased DATE,
rownum INT);

#INSERT ROW NUMBER INTO DATA
INSERT INTO coffee_data2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY hour_purchased, payment, total_transaction, coffee_type, time_purchased, day_purchased, month_purchased, date_purchased) AS rownum
FROM coffee_data
;

#DELETE DUPLICATES DATA
DELETE
FROM coffee_data2
WHERE rownum > 1
;

#UPDATE DATA AFTER CLEANING DUPLICATES VALUE
SELECT * 
FROM coffee_data2
;

#CHECKING MISSING VALUES
SELECT *
FROM coffee_data2
WHERE hour_purchased IS NULL
OR payment IS NULL
OR total_transaction IS NULL
OR coffee_type IS NULL
OR time_purchased IS NULL
OR day_purchased IS NULL
OR month_purchased IS NULL
OR date_purchased IS NULL
OR rownum IS NULL
;

#EXPLORATORY DATA ANALYSIS (EDA)

SELECT MAX(total_transaction), MIN(total_transaction), SUM(total_transaction), AVG(total_transaction)
FROM coffee_data2
;

SELECT DISTINCT(payment)
FROM coffee_data2
;

# PAYMENT ONLY HAD 1 VALUE SO IT WILL BE DROP THE COLUMN
ALTER TABLE coffee_data2
DROP COLUMN payment
;

SELECT DISTINCT(coffee_type)
FROM coffee_data2
;

SELECT *
FROM coffee_data2
WHERE total_transaction > 25
ORDER BY total_transaction DESC
;

SELECT coffee_type,
COUNT(*) AS total_order
FROM coffee_data2
GROUP BY coffee_type
ORDER BY total_order DESC
;

SELECT hour_purchased,
COUNT(*) AS total_order_hourly
FROM coffee_data2
GROUP BY hour_purchased
ORDER BY total_order_hourly DESC
;

SELECT time_purchased,
COUNT(*) AS total_order_time
FROM coffee_data2
GROUP BY time_purchased
ORDER BY total_order_time DESC
;

SELECT month_purchased,
COUNT(*) AS total_order_month
FROM coffee_data2
GROUP BY month_purchased
ORDER BY total_order_month DESC
;

SELECT day_purchased,
COUNT(*) AS total_order_day
FROM coffee_data2
GROUP BY day_purchased
ORDER BY total_order_day DESC
;

SELECT YEAR(date_purchased), SUM(total_transaction)
FROM coffee_data2
GROUP BY YEAR(date_purchased)
ORDER BY 1 DESC
;

SELECT YEAR(date_purchased), MAX(total_transaction), MIN(total_transaction), SUM(total_transaction), AVG(total_transaction)
FROM coffee_data2
GROUP BY YEAR(date_purchased)
;


SELECT YEAR(date_purchased),
COUNT(*) AS total_order_year
FROM coffee_data2
GROUP BY YEAR(date_purchased)
ORDER BY total_order_year DESC
;
