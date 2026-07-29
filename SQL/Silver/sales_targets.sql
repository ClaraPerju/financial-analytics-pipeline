USE URB_database_silver;

CREATE TABLE IF NOT EXISTS sales_targets (
    customer_id INT PRIMARY KEY,
    budget_usd DECIMAL(15,2),
    pct_manufactured_inhouse DECIMAL(5,2),
    pct_assembled_inhouse DECIMAL(5,2),
    pct_fully_outsourced DECIMAL(5,2),
    total_production_sales_usd DECIMAL(15,2),
    total_outsourced_sales_usd DECIMAL(15,2)
);

TRUNCATE TABLE sales_targets;

INSERT INTO URB_database_silver.sales_targets
SELECT
    customer_id,
    ROUND(COALESCE(budget_usd, 0), 2),
    ROUND(COALESCE(pct_manufactured_inhouse, 0) * 100, 2),
    ROUND(COALESCE(pct_assembled_inhouse, 0) * 100, 2),
    ROUND(COALESCE(pct_fully_outsourced, 0) * 100, 2),
    ROUND(COALESCE(total_production_sales_usd, 0), 2),
    ROUND(COALESCE(total_outsourced_sales_usd, 0), 2)
FROM URB_database_bronze.sales_targets;

