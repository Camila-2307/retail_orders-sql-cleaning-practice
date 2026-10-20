
SELECT COUNT(*) AS row_count
FROM orders_raw;

SELECT
  SUM(CASE WHEN order_date IS NULL OR TRIM(order_date) = '' THEN 1 ELSE 0 END) AS missing_order_date,
  SUM(CASE WHEN customer_name IS NULL OR TRIM(customer_name) = '' THEN 1 ELSE 0 END) AS missing_customer_name,
  SUM(CASE WHEN email IS NULL OR TRIM(email) = '' THEN 1 ELSE 0 END) AS missing_email,
  SUM(CASE WHEN city IS NULL OR TRIM(city) = '' THEN 1 ELSE 0 END) AS missing_city
FROM orders_raw;

SELECT order_status, COUNT(*) AS rows
FROM orders_raw
GROUP BY order_status
ORDER BY rows DESC;

SELECT
  order_id, order_date, customer_name, email, city, state,
  product, quantity, unit_price, discount_pct, payment_method, order_status,
  COUNT(*) AS copies
FROM orders_raw
GROUP BY
  order_id, order_date, customer_name, email, city, state,
  product, quantity, unit_price, discount_pct, payment_method, order_status
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*) AS rows_with_this_id
FROM orders_raw
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT *
FROM orders_raw
WHERE order_id IN (1005, 1006)
ORDER BY order_id;

SELECT *
FROM orders_raw
WHERE order_id = 1005;

SELECT COUNT(*) AS copies
FROM orders_raw
WHERE order_id = 1005;

-- Checking 
SELECT *
FROM orders_raw
WHERE order_id = 1008;

SELECT order_id, COUNT (*) AS row_count
FROM orders_raw
GROUP BY order_id
HAVING count(*) > 1;

SELECT order_id, quantity, unit_price, discount_pct
FROM orders_raw
WHERE
  quantity <= 0
  OR unit_price < 0
  OR discount_pct < 0
  OR discount_pct > 100;
  
  SELECT payment_method, COUNT(*) AS row_count
  FROM orders_raw
  GROUP BY payment_method
  ORDER BY payment_method;

SELECT
  UPPER(TRIM(order_status)) AS normalized_status,
  COUNT(*) AS row_count
FROM orders_raw
GROUP BY UPPER(TRIM(order_status))
ORDER BY row_count DESC;

SELECT TRIM(product) AS product, COUNT(*) AS row_count
FROM orders_raw
GROUP BY TRIM(product)
ORDER BY product;

SELECT order_id, order_date
FROM orders_raw
WHERE date(order_date) IS NULL;

SELECT DISTINCT state FROM orders_raw ORDER BY state;
SELECT DISTINCT city FROM orders_raw ORDER BY city;
SELECT DISTINCT email FROM orders_raw WHERE email IS NULL OR TRIM(email) = ' ' OR email NOT LIKE '%_@_%._%';
SELECT DISTINCT unit_price FROM orders_raw ORDER BY unit_price;
SELECT DISTINCT quantity FROM orders_raw ORDER BY quantity;

SELECT order_id, quantity
FROM orders_raw
WHERE
	quantity IS NULL
	OR TRIM(quantity) = ' '
	OR quantity NOT GLOB '[0-9]*'
	OR CAST (quantity AS INTEGER) <= 0;
	
SELECT order_id, email
FROM orders_raw
WHERE email IS NULL
	OR TRIM(email) = ' '
	OR email NOT LIKE '%_@_%._%';
	
SELECT order_id, unit_price, typeof(unit_price) AS stored_type
FROM orders_raw
WHERE unit_price IS NULL
	OR TRIM(unit_price) = ' ' 
	OR typeof(unit_price) NOT IN ('integer', 'real')
	OR CAST(unit_price AS REAL) < 0;
	
SELECT order_id, discount_pct
FROM orders_raw
WHERE discount_pct IS NULL
	OR TRIM(discount_pct) = ' ' 
	OR CAST(discount_pct AS REAL) < 0
	OR CAST(discount_pct AS REAL) > 100;
	
SELECT UPPER(TRIM(state)) AS state_value, COUNT(*) AS row_count
FROM orders_raw
GROUP BY UPPER(TRIM(state))
ORDER BY state_value;

SELECT UPPER(TRIM(city)) AS city_value, COUNT(*) AS row_count
FROM orders_raw
GROUP BY UPPER(TRIM(city))
ORDER BY city_value;

--Checked for order_clean already existing
-- Dropped the pre-existing orders_clean
  
CREATE TABLE orders_clean AS
WITH ranked AS (
  SELECT
    rowid AS source_row,
    *,
    ROW_NUMBER() OVER (
      PARTITION BY
        order_id, order_date, customer_name, email, city, state,
        product, quantity, unit_price, discount_pct,
        payment_method, order_status
      ORDER BY rowid
    ) AS duplicate_number
  FROM orders_raw
)
SELECT
  order_id,
  CASE
    WHEN TRIM(order_date) = '01/04/2025' THEN '2025-01-04'
    WHEN TRIM(order_date) = '2025/01/22' THEN '2025-01-22'
    ELSE date(order_date)
  END AS order_date,
  TRIM(customer_name) AS customer_name,
  LOWER(TRIM(email)) AS email,
  UPPER(TRIM(city)) AS city,
  CASE
    WHEN UPPER(TRIM(state)) = 'CALIFORNIA' THEN 'CA'
    ELSE UPPER(TRIM(state))
  END AS state,
  CASE
    WHEN UPPER(TRIM(product)) = 'DESK LAMP' THEN 'Desk Lamp'
    ELSE TRIM(product)
  END AS product,
  CAST(quantity AS INTEGER) AS quantity,
  CASE
    WHEN TRIM(unit_price) = '34.99 USD' THEN 34.99
    ELSE CAST(unit_price AS REAL)
  END AS unit_price,
  CAST(discount_pct AS REAL) AS discount_pct,
  CASE
    WHEN UPPER(TRIM(payment_method)) = 'CREDIT CARD' THEN 'Credit Card'
    ELSE TRIM(payment_method)
  END AS payment_method,
  UPPER(TRIM(order_status)) AS order_status
FROM ranked
WHERE duplicate_number = 1
  AND order_id NOT IN (
    1008, 1024, 1028, 1029, 1030, 1032,
    1033, 1034, 1038, 1041, 1042, 1043
  );
  
-------

 SELECT COUNT(*) AS cleaned_rows
 FROM orders_clean;
 
 SELECT*
 FROM orders_clean
 LIMIT 10;
 

SELECT COUNT(*) FROM orders_clean;


SELECT order_id, COUNT(*)
FROM orders_clean
GROUP BY order_id
HAVING COUNT(*) > 1;


SELECT *
FROM orders_clean
WHERE quantity <= 0
   OR unit_price < 0
   OR discount_pct < 0
   OR discount_pct > 100;


SELECT *
FROM orders_clean
WHERE order_date IS NULL;
  