USE URB_database_silver;

CREATE TABLE IF NOT EXISTS production (
    production_id INT PRIMARY KEY,
    product_id INT,
    month DATE,
    value_ron DECIMAL(15,2),
    quantity_pcs DECIMAL(10,2),
    quantity_kg DECIMAL(10,2),
    quantity_tons DECIMAL(10,2)
);

TRUNCATE TABLE production;

INSERT INTO URB_database_silver.production
SELECT 
    production_id,
    product_id,
    CAST(CASE TRIM(month)
        WHEN 'ian.'  THEN '2025-01-01'
        WHEN 'feb.'  THEN '2025-02-01'
        WHEN 'mar.'  THEN '2025-03-01'
        WHEN 'apr.'  THEN '2025-04-01'
        WHEN 'mai'   THEN '2025-05-01'
        WHEN 'iunie' THEN '2025-06-01'
        WHEN 'iulie' THEN '2025-07-01'
        WHEN 'aug.'  THEN '2025-08-01'
        WHEN 'sept.' THEN '2025-09-01'
        WHEN 'oct.'  THEN '2025-10-01'
        WHEN 'nov.'  THEN '2025-11-01'
        WHEN 'dec.'  THEN '2025-12-01'
    END AS DATE) AS month, 
    ROUND(value_ron, 2) AS value_ron,
    ROUND(quantity_pcs, 2) AS quantity_pcs,
	ROUND(quantity_kg, 2) AS quantity_kg,
	ROUND(quantity_tons, 2) AS quantity_tons
FROM URB_database_bronze.production;

SELECT * FROM production;
