USE URB_database_silver;
   
DROP TABLE IF EXISTS balance_sheet;

CREATE TABLE balance_sheet (
    item_description VARCHAR(500),
    balance_01_01_2025 DECIMAL(15,2),
    balance_31_12_2025 DECIMAL(15,2)
);

TRUNCATE TABLE balance_sheet;

INSERT INTO URB_database_silver.balance_sheet
SELECT
    item_description,
    ROUND(COALESCE(balance_01_01_2025, 0), 2),
    ROUND(COALESCE(balance_31_12_2025, 0), 2)
FROM URB_database_bronze.balance_sheet
WHERE balance_01_01_2025 IS NOT NULL
OR balance_31_12_2025 IS NOT NULL;

SELECT * FROM balance_sheet;
