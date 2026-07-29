USE URB_database_silver;

CREATE TABLE IF NOT EXISTS products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(255)
);

TRUNCATE TABLE URB_database_silver.products;

INSERT INTO URB_database_silver.products (product_id, product_name)
SELECT product_id, TRIM(product_name)
FROM URB_database_bronze.products
WHERE product_id IS NOT NULL;

