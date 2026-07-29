USE URB_database_silver;

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    customer_country VARCHAR(100)
);

TRUNCATE TABLE customers;

INSERT INTO URB_database_silver.customers
SELECT 
    customer_id,
    TRIM(customer_name),
    UPPER(TRIM(customer_country))
FROM URB_database_bronze.customers;

SELECT * FROM customers

