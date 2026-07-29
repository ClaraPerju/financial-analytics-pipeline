USE URB_database_silver;

CREATE TABLE IF NOT EXISTS accounts_revenue (
    account_code VARCHAR(255) PRIMARY KEY,
    account_name_en VARCHAR(255)
);

TRUNCATE TABLE accounts_revenue;

INSERT INTO URB_database_silver.accounts_revenue
SELECT DISTINCT
    account_code,
    account_name_en
FROM URB_database_bronze.revenue
WHERE account_code NOT LIKE 'TOTAL%'
AND account_name_en NOT LIKE 'TOTAL%'
AND account_code NOT IN (
    'Cifra de afaceri (701+...708-709)',
    'din care EXPORT',
    'PROFIT BRUT( V. bilant- Chelt. bilant)',
    'PROFIT NET( Profit brut - ct.691- 698 )',
    'Venituri financiare (761+764+765+766 +767)'
)
AND account_code NOT LIKE 'Venituri din exploatare%'
AND account_code IS NOT NULL;

SELECT * FROM accounts_revenue
