USE URB_database_silver;

DROP TABLE IF EXISTS expenses;

CREATE TABLE IF NOT EXISTS expenses (
    account_code VARCHAR(255),
    month DATE,
    value_ron DECIMAL(15,2),
    value_usd DECIMAL(15,2),
    PRIMARY KEY (account_code, month)
);
TRUNCATE TABLE expenses;

INSERT INTO URB_database_silver.expenses
SELECT
    account_code,
    CAST(CASE TRIM(month)
        WHEN 'ian' THEN '2025-01-01'
        WHEN 'feb' THEN '2025-02-01'
        WHEN 'mar' THEN '2025-03-01'
        WHEN 'apr' THEN '2025-04-01'
        WHEN 'may' THEN '2025-05-01'
        WHEN 'jun' THEN '2025-06-01'
        WHEN 'jul' THEN '2025-07-01'
        WHEN 'aug' THEN '2025-08-01'
        WHEN 'sep' THEN '2025-09-01'
        WHEN 'oct' THEN '2025-10-01'
        WHEN 'nov' THEN '2025-11-01'
        WHEN 'dec' THEN '2025-12-01'
    END AS DATE) AS month,
    ROUND(COALESCE(MAX(CASE WHEN currency = 'RON' THEN amount END), 0), 2) AS value_ron,
    ROUND(COALESCE(MAX(CASE WHEN currency = 'USD' THEN amount END), 0), 2) AS value_usd
FROM URB_database_bronze.expenses
WHERE account_code NOT LIKE 'TOTAL%'
AND account_name_en NOT LIKE 'TOTAL%'
AND account_code IS NOT NULL
AND account_code != 'Alte chelt. de expl.'
GROUP BY account_code, URB_database_bronze.expenses.month;

=
