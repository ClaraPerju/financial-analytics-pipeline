USE URB_database_gold;

CREATE OR REPLACE VIEW vw_financial_ratios AS
WITH bs AS (
    SELECT
        MAX(CASE WHEN item_description = 'TOTAL NON-CURRENT ASSETS' THEN balance_31_12_2025 END) AS total_non_current_assets,
        MAX(CASE WHEN item_description = 'TOTAL CURRENT ASSETS' THEN balance_31_12_2025 END) AS total_current_assets,
        MAX(CASE WHEN item_description = 'TOTAL CURRENT LIABILITIES' THEN balance_31_12_2025 END) AS total_current_liabilities,
        MAX(CASE WHEN item_description = 'TOTAL NON-CURRENT LIABILITIES' THEN balance_31_12_2025 END) AS total_non_current_liabilities,
        MAX(CASE WHEN item_description = 'TOTAL EQUITY' THEN balance_31_12_2025 END) AS total_equity,
        MAX(CASE WHEN item_description = 'TOTAL INVENTORIES' THEN balance_31_12_2025 END) AS total_inventories,
        MAX(CASE WHEN item_description = 'IV. CASH AND BANK ACCOUNTS' THEN balance_31_12_2025 END) AS cash
    FROM URB_database_silver.balance_sheet
),
pl AS (
    SELECT
        MAX(CASE WHEN item_description = 'TOTAL OPERATING REVENUE' THEN financial_year_2025 END) AS total_revenue,
        MAX(CASE WHEN item_description = 'TOTAL OPERATING EXPENSES' THEN financial_year_2025 END) AS total_expenses,
        MAX(CASE WHEN item_description = 'OPERATING PROFIT' THEN financial_year_2025 END) AS operating_profit,
        MAX(CASE WHEN item_description = 'OPERATING LOSS' THEN financial_year_2025 END) AS operating_loss,
        MAX(CASE WHEN item_description = 'GROSS PROFIT' THEN financial_year_2025 END) AS gross_profit,
		MAX(CASE WHEN item_description = 'GROSS LOSS' THEN financial_year_2025 END) AS gross_loss,
        MAX(CASE WHEN item_description = 'NET PROFIT FOR THE FINANCIAL YEAR' THEN financial_year_2025 END) AS net_profit,
        MAX(CASE WHEN item_description = 'NET LOSS FOR THE FINANCIAL YEAR' THEN financial_year_2025 END) AS net_loss,
        MAX(CASE WHEN item_description = '  a.1) Depreciation and Amortization Expenses' THEN financial_year_2025 END) AS depreciation,
        MAX(CASE WHEN item_description = '18. Interest Expenses' THEN financial_year_2025 END) AS interest_expenses
    FROM URB_database_silver.profit_loss_annual
)
SELECT
    -- ── PROFITABILITY RATIOS ──────────────────────────────
    ROUND((pl.gross_profit - pl.gross_loss) / NULLIF(pl.total_revenue, 0) * 100, 2) AS gross_margin_pct,
    ROUND((pl.operating_profit - pl.operating_loss) / NULLIF(pl.total_revenue, 0) * 100, 2) AS operating_margin_pct,
    ROUND((pl.net_profit - pl.net_loss) / NULLIF(pl.total_revenue, 0) * 100, 2) AS net_margin_pct,
    ROUND((pl.net_profit - pl.net_loss) / NULLIF(bs.total_equity, 0) * 100, 2) AS roe_pct,
    ROUND((pl.net_profit - pl.net_loss) / NULLIF(bs.total_non_current_assets + bs.total_current_assets, 0) * 100, 2) AS roa_pct,

    -- ── EBITDA ───────────────────────────────────────────
    ROUND((pl.operating_profit - pl.operating_loss) + COALESCE(pl.depreciation, 0), 2) AS ebitda,
    ROUND(((pl.operating_profit - pl.operating_loss) + COALESCE(pl.depreciation, 0)) / NULLIF(pl.total_revenue, 0) * 100, 2) AS ebitda_margin_pct,

    -- ── LIQUIDITY RATIOS ─────────────────────────────────
    ROUND(bs.total_current_assets / NULLIF(bs.total_current_liabilities, 0), 2) AS current_ratio,
    ROUND((bs.total_current_assets - bs.total_inventories) / NULLIF(bs.total_current_liabilities, 0), 2) AS quick_ratio,
    ROUND(bs.cash / NULLIF(bs.total_current_liabilities, 0), 2) AS cash_ratio,
    ROUND(bs.total_current_assets - bs.total_current_liabilities, 2) AS working_capital,
    ROUND((bs.total_current_liabilities + bs.total_non_current_liabilities) - bs.cash, 2) AS net_debt,

    -- ── LEVERAGE RATIOS ──────────────────────────────────
    ROUND((bs.total_current_liabilities + bs.total_non_current_liabilities) / NULLIF(bs.total_equity, 0), 2) AS debt_to_equity,
    ROUND((bs.total_current_liabilities + bs.total_non_current_liabilities) / NULLIF(bs.total_current_assets + bs.total_non_current_assets, 0), 2) AS debt_to_assets,
    ROUND(bs.total_non_current_liabilities / NULLIF(bs.total_equity, 0), 2) AS long_term_debt_to_equity,
    ROUND(bs.total_equity / NULLIF(bs.total_current_assets + bs.total_non_current_assets, 0) * 100, 2) AS equity_ratio_pct,

    -- ── COVERAGE RATIOS ──────────────────────────────────
    ROUND(bs.total_non_current_assets / NULLIF(bs.total_non_current_liabilities, 0), 2) AS non_current_asset_coverage

FROM bs CROSS JOIN pl;

SELECT * FROM vw_financial_ratios;



