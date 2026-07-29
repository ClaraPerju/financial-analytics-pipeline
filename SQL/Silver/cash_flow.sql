USE URB_database_silver;

CREATE TABLE IF NOT EXISTS cash_flow (
    month DATE PRIMARY KEY,
    opening_cash_balance DECIMAL(15,2),
    cash_inputs DECIMAL(15,2),
    collections_receivables DECIMAL(15,2),
    collections_cash_sales DECIMAL(15,2),
    collections_forward_sales DECIMAL(15,2),
    collections_capital DECIMAL(15,2),
    inflows_bank_loans DECIMAL(15,2),
    inflows_other DECIMAL(15,2),
    inflows_group_trusts DECIMAL(15,2),
    total_cash_available DECIMAL(15,2)
);

TRUNCATE TABLE cash_flow;

INSERT INTO URB_database_silver.cash_flow
SELECT
    CAST(CASE 
        WHEN TRIM(month) LIKE 'Jan%' THEN CONCAT(RIGHT(TRIM(month),4), '-01-01')
        WHEN TRIM(month) LIKE 'Feb%' THEN CONCAT(RIGHT(TRIM(month),4), '-02-01')
        WHEN TRIM(month) LIKE 'Mar%' THEN CONCAT(RIGHT(TRIM(month),4), '-03-01')
        WHEN TRIM(month) LIKE 'Apr%' THEN CONCAT(RIGHT(TRIM(month),4), '-04-01')
        WHEN TRIM(month) LIKE 'May%' THEN CONCAT(RIGHT(TRIM(month),4), '-05-01')
        WHEN TRIM(month) LIKE 'Jun%' THEN CONCAT(RIGHT(TRIM(month),4), '-06-01')
        WHEN TRIM(month) LIKE 'Jul%' THEN CONCAT(RIGHT(TRIM(month),4), '-07-01')
        WHEN TRIM(month) LIKE 'Aug%' THEN CONCAT(RIGHT(TRIM(month),4), '-08-01')
        WHEN TRIM(month) LIKE 'Sep%' THEN CONCAT(RIGHT(TRIM(month),4), '-09-01')
        WHEN TRIM(month) LIKE 'Oct%' THEN CONCAT(RIGHT(TRIM(month),4), '-10-01')
        WHEN TRIM(month) LIKE 'Nov%' THEN CONCAT(RIGHT(TRIM(month),4), '-11-01')
        WHEN TRIM(month) LIKE 'Dec%' THEN CONCAT(RIGHT(TRIM(month),4), '-12-01')
    END AS DATE) AS month,
    ROUND(COALESCE(opening_cash_balance, 0), 2),
    ROUND(COALESCE(cash_inputs, 0), 2),
    ROUND(COALESCE(collections_receivables, 0), 2),
    ROUND(COALESCE(collections_cash_sales, 0), 2),
    ROUND(COALESCE(collections_forward_sales, 0), 2),
    ROUND(COALESCE(collections_capital, 0), 2),
    ROUND(COALESCE(inflows_bank_loans, 0), 2),
    ROUND(COALESCE(inflows_other, 0), 2),
    ROUND(COALESCE(inflows_group_trusts, 0), 2),
    ROUND(COALESCE(total_cash_available, 0), 2)
FROM URB_database_bronze.cash_flow;

