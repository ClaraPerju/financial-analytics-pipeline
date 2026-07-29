USE URB_database_silver;

CREATE TABLE IF NOT EXISTS cash_outflows (
    month DATE PRIMARY KEY,
    outflows_rm_advance DECIMAL(15,2),
    outflows_rm_forward DECIMAL(15,2),
    outflows_direct_labor DECIMAL(15,2),
    outflows_manufacturing_expenses DECIMAL(15,2),
    outflows_operating_expenses DECIMAL(15,2),
    outflows_debt_repayments DECIMAL(15,2),
    outflows_investments DECIMAL(15,2),
    outflows_financing_costs DECIMAL(15,2),
    outflows_other DECIMAL(15,2),
    total_cash_outflows DECIMAL(15,2)
);

TRUNCATE TABLE cash_outflows;

INSERT INTO URB_database_silver.cash_outflows
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
    ROUND(COALESCE(outflows_rm_advance, 0), 2),
    ROUND(COALESCE(outflows_rm_forward, 0), 2),
    ROUND(COALESCE(outflows_direct_labor, 0), 2),
    ROUND(COALESCE(outflows_manufacturing_expenses, 0), 2),
    ROUND(COALESCE(outflows_operating_expenses, 0), 2),
    ROUND(COALESCE(outflows_debt_repayments, 0), 2),
    ROUND(COALESCE(outflows_investments, 0), 2),
    ROUND(COALESCE(outflows_financing_costs, 0), 2),
    ROUND(COALESCE(outflows_other, 0), 2),
    ROUND(COALESCE(total_cash_outflows, 0), 2)
FROM URB_database_bronze.cash_outflows;

