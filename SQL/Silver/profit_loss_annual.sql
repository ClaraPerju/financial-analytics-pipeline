USE URB_database_silver;

DROP TABLE IF EXISTS profit_loss_annual;

CREATE TABLE profit_loss_annual (
    item_description VARCHAR(500),
    financial_year_2024 DECIMAL(15,2),
    financial_year_2025 DECIMAL(15,2)
);

TRUNCATE TABLE profit_loss_annual;

INSERT INTO URB_database_silver.profit_loss_annual
SELECT
    item_description,
    ROUND(COALESCE(financial_year_2024, 0), 2),
    ROUND(COALESCE(financial_year_2025, 0), 2)
FROM URB_database_bronze.profit_loss_annual
WHERE financial_year_2024 IS NOT NULL
OR financial_year_2025 IS NOT NULL;

SELECT * FROM profit_loss_annual;
