USE URB_database_silver;

CREATE TABLE IF NOT EXISTS accounts_expenses (
    account_code VARCHAR(255) PRIMARY KEY,
    account_name_en VARCHAR(255)
);
TRUNCATE TABLE accounts_expenses;
INSERT INTO URB_database_silver.accounts_expenses
SELECT DISTINCT
    account_code,
    account_name_en
FROM URB_database_bronze.expenses
WHERE account_code NOT LIKE 'TOTAL%'
AND account_name_en NOT LIKE 'TOTAL%'
AND account_code IS NOT NULL
AND account_name_en IS NOT NULL
AND account_code != 'Alte chelt. de expl.';

SELECT * FROM accounts_expenses;

