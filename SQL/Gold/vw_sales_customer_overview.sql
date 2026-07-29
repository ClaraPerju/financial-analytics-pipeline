USE URB_database_gold;

CREATE OR REPLACE VIEW vw_sales_customer_overview AS
	SELECT 
	c.customer_name,
	c.customer_country,
	-- targets
	st.budget_usd,
	-- production model
	st.pct_manufactured_inhouse,
	st.pct_assembled_inhouse,
	st.pct_fully_outsourced,
	-- sales values
	st.total_production_sales_usd,
	st.total_outsourced_sales_usd,

	-- calculated metrics -- 

	-- total sales value--
	ROUND(st.total_production_sales_usd + st.total_outsourced_sales_usd,2) AS total_sales_usd,
	-- in-house sales percentage -- 
	ROUND(st.total_production_sales_usd/NULLIF(st.total_production_sales_usd + st.total_outsourced_sales_usd,0) * 100,2) AS inhouse_sales_percentage,
	ROUND(st.total_outsourced_sales_usd/NULLIF(st.total_production_sales_usd + st.total_outsourced_sales_usd,0) * 100,2) AS outsourced_sales_percentage,
	-- sales raking --
	DENSE_RANK() OVER (ORDER BY (st.total_production_sales_usd + st.total_outsourced_sales_usd) DESC ) AS customer_sales_rank,
	-- production strategy --
	CASE
		WHEN st.pct_manufactured_inhouse >= 75 THEN 'In-house'
		WHEN st.pct_fully_outsourced >= 80  THEN 'Outsourced'
		ELSE 'Hybrid'
	END AS production_strategy,
	-- customer segment--
	CASE
		WHEN (st.total_production_sales_usd + st.total_outsourced_sales_usd) >= 900000 THEN 'High Value'
		WHEN (st.total_production_sales_usd + st.total_outsourced_sales_usd) >= 100000 THEN 'Medium Value'
		ELSE 'Low Value'
	END AS customer_segment

	FROM URB_database_silver.customers AS c
	INNER JOIN URB_database_silver.sales_targets AS st
		ON c.customer_id = st.customer_id;
    
SELECT * FROM vw_sales_customer_overview;

