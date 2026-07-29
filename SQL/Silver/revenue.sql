USE URB_database_silver;
DROP TABLE IF EXISTS revenue;

CREATE TABLE IF NOT EXISTS revenue (
    account_code VARCHAR(255),
    month DATE,
    value_ron DECIMAL(15,2),
    value_usd DECIMAL(15,2),
    PRIMARY KEY (account_code, month)
);

TRUNCATE TABLE revenue;

INSERT INTO URB_database_silver.revenue
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
FROM URB_database_bronze.revenue
WHERE account_code NOT LIKE 'TOTAL%'
AND account_name_en NOT LIKE 'TOTAL%'
AND account_code NOT LIKE 'Venituri din exploatare%'
AND account_code NOT IN (
    'Cifra de afaceri (701+...708-709)',
    'din care EXPORT',
    'PROFIT BRUT( V. bilant- Chelt. bilant)',
    'PROFIT NET( Profit brut - ct.691- 698 )',
    'Venituri financiare (761+764+765+766 +767)'
)
AND account_code IS NOT NULL
GROUP BY account_code, URB_database_bronze.revenue.month;

SELECT * FROM revenue;
