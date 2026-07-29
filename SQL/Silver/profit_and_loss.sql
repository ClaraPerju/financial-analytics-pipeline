USE URB_database_silver;

DROP TABLE IF EXISTS profit_and_loss;

CREATE TABLE IF NOT EXISTS profit_and_loss (
    account_name_en VARCHAR(255), 
    amount DECIMAL(15,2),
    period DATE,
    scenario VARCHAR(50),
    PRIMARY KEY (account_name_en, period, scenario)
);

TRUNCATE TABLE profit_and_loss;

INSERT INTO URB_database_silver.profit_and_loss
SELECT
    CONCAT(
        UPPER(LEFT(
            TRIM(REGEXP_REPLACE(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(account_name_en, '^[a-z]\\)-', ''),
                '\\s*\\(\\s*-\\s*\\)\\s*$', ''),
            '\\s*%$', '')),
        1)),
        LOWER(SUBSTRING(
            TRIM(REGEXP_REPLACE(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(account_name_en, '^[a-z]\\)-', ''),
                '\\s*\\(\\s*-\\s*\\)\\s*$', ''),
            '\\s*%$', '')),
        2))
    ) AS account_name_en,
    ROUND(COALESCE(amount, 0), 2),
    STR_TO_DATE(period, '%d.%m.%Y') AS period,
    scenario
FROM URB_database_bronze.profit_and_loss
WHERE period NOT LIKE '%Total%'
AND period NOT LIKE '%Q%';



