USE URB_database_gold;

CREATE OR REPLACE VIEW vw_revenue_expenses_overview AS
	WITH 
	revenue_summary AS (
		SELECT
			month,
			SUM(value_usd) AS total_revenue_usd
		FROM URB_database_silver.revenue
		GROUP BY month
	),
	expense_summary AS (
		SELECT 
			month,
			SUM(value_usd) AS total_expenses_usd
		FROM URB_database_silver.expenses
		GROUP BY month
	),
    revenue_expense_combined AS (
		SELECT 
			r.month,
			r.total_revenue_usd,
			e.total_expenses_usd,
			r.total_revenue_usd - e.total_expenses_usd AS net_profit
		FROM revenue_summary AS r
		INNER JOIN expense_summary AS e ON r.month = e.month
	),
    monthly_metrics AS (
    SELECT *,
        LAG(total_revenue_usd)  OVER (ORDER BY month) AS prev_revenue,
        LAG(total_expenses_usd) OVER (ORDER BY month) AS prev_expenses,
        LAG(net_profit)         OVER (ORDER BY month) AS prev_profit
    FROM revenue_expense_combined
)
	SELECT
    month,
    total_revenue_usd,
    total_expenses_usd,
    net_profit,
    -- ratios --
    ROUND((total_expenses_usd / total_revenue_usd) * 100, 2) AS expense_ratio_pct,
    ROUND((net_profit / total_revenue_usd) * 100, 2) AS profit_margin_pct,   
    ROUND((total_revenue_usd / total_expenses_usd) * 100,2) AS efficiency_ratio_pct,
    -- mom absolute change --
    ROUND(total_revenue_usd  - prev_revenue,  2) AS revenue_change_abs,                   
    ROUND(total_expenses_usd - prev_expenses, 2) AS expenses_change_abs,                  
    ROUND(net_profit         - prev_profit,   2) AS profit_change_abs,                 
    -- mom % change --
    ROUND((total_revenue_usd  - prev_revenue)  / NULLIF(prev_revenue,  0) * 100, 2) AS revenue_change_pct,
    ROUND((total_expenses_usd - prev_expenses) / NULLIF(prev_expenses, 0) * 100, 2) AS expenses_change_pct,
    ROUND((net_profit         - prev_profit)   / NULLIF(prev_profit,   0) * 100, 2) AS profit_change_pct,
    -- cumulative --
    SUM(total_revenue_usd)  OVER (ORDER BY month) AS cumulative_revenue,
    SUM(total_expenses_usd) OVER (ORDER BY month) AS cumulative_expenses,
    SUM(net_profit)         OVER (ORDER BY month) AS cumulative_profit

FROM monthly_metrics;

SELECT * FROM vw_revenue_expenses_overview;
