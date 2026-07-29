USE URB_database_gold;

CREATE OR REPLACE VIEW vw_cash_overview AS
	SELECT 
     cf.month,
    -- cash inflows
    cf.opening_cash_balance,
    cf.collections_receivables,
    cf.collections_cash_sales,
    cf.collections_forward_sales,
    cf.collections_capital,
    cf.inflows_bank_loans,
    cf.inflows_other,
    cf.inflows_group_trusts,
    cf.total_cash_available,
    -- cash outflows
    co.outflows_rm_advance,
    co.outflows_rm_forward,
    co.outflows_direct_labor,
    co.outflows_manufacturing_expenses,
    co.outflows_operating_expenses,
    co.outflows_debt_repayments,
    co.outflows_investments,
    co.outflows_financing_costs,
    co.outflows_other,
    co.total_cash_outflows,
    
    -- calculated metrics --
    
    -- cash flow ratio
    ROUND(cf.total_cash_available / NULLIF(co.total_cash_outflows,0),2) AS cash_flow_ratio,
    -- outflow % from cash available
    ROUND(co.total_cash_outflows * 100 / NULLIF(cf.total_cash_available,0),2) AS outflow_percentage,
    -- closing cash balance
    ROUND(cf.total_cash_available - co.total_cash_outflows, 2) AS closing_cash_balance,
    -- previous month net cash inputs
    COALESCE(LAG(cf.total_cash_available - co.total_cash_outflows) OVER (ORDER BY cf.month),0 ) AS previous_month_closing_balance,
    -- month over month difference
    ROUND( COALESCE((cf.total_cash_available - co.total_cash_outflows) - LAG(cf.total_cash_available - co.total_cash_outflows)
		OVER(ORDER BY cf.month), 0), 2) AS net_cash_change,
	-- year total
	ROUND(SUM(cf.total_cash_available - co.total_cash_outflows) 
        OVER (PARTITION BY YEAR(cf.month) ORDER BY cf.month), 2) AS net_cash_year_total
    FROM  URB_database_silver.cash_flow AS cf
    INNER JOIN URB_database_silver.cash_outflows AS co
		ON cf.month = co.month;
        
SELECT * FROM vw_cash_overview;
