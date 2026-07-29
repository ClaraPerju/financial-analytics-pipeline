USE URB_database_gold;

CREATE OR REPLACE VIEW vw_production_vs_shipments AS
SELECT 
    p.product_name,
    pr.month,
    pr.value_ron AS produced_ron,
    pr.quantity_pcs AS produced_pcs,
    pr.quantity_kg AS produced_kg,
    pr.quantity_tons AS produced_tons,
    s.value_ron AS shipped_ron,
    s.quantity_pcs AS shipped_pcs,
    s.quantity_kg AS shipped_kg,
    s.quantity_tons AS shipped_tons,
    
    -- calculated metrics --
    
    -- shipment rate(%)
	ROUND(COALESCE((s.value_ron / NULLIF(pr.value_ron, 0)) * 100, 0), 2) AS fill_rate_pct,
    -- inventory build
    ROUND(pr.value_ron - s.value_ron, 2) AS gap_ron,
	ROUND(pr.quantity_pcs - s.quantity_pcs, 2) AS gap_pcs,
    ROUND(pr.quantity_kg - s.quantity_kg,2) AS gap_kg,
	ROUND(pr.quantity_tons - s.quantity_tons,2) AS gap_tons,
    ROUND(COALESCE(((pr.value_ron - s.value_ron)/ NULLIF(pr.value_ron,0)),0) * 100, 2) AS gap_pct,
    -- previous month production
    COALESCE(LAG(pr.value_ron) OVER (PARTITION BY p.product_name ORDER BY pr.month),0) AS previous_month_production,
    ROUND(pr.value_ron -COALESCE(LAG(pr.value_ron)OVER (PARTITION BY p.product_name ORDER BY pr.month),0),2) AS production_change_ron,
    ROUND(COALESCE((pr.value_ron - LAG(pr.value_ron)
			OVER(PARTITION BY p.product_name ORDER BY pr.month))/NULLIF
            (LAG(pr.value_ron)OVER(PARTITION BY p.product_name ORDER BY pr.month),0)*100,0),2) AS production_growth_pct,
    -- year-to-date
    ROUND(SUM(pr.value_ron) OVER (PARTITION BY p.product_name,YEAR(pr.month)ORDER BY pr.month),2) AS produced_ytd,
    ROUND(SUM(s.value_ron) OVER (PARTITION BY p.product_name,YEAR(pr.month)ORDER BY pr.month),2 ) AS shipped_ytd
    
FROM URB_database_silver.production pr
JOIN URB_database_silver.shipments s 
    ON pr.product_id = s.product_id 
    AND pr.month = s.month
JOIN URB_database_silver.products p 
    ON pr.product_id = p.product_id;


SELECT * FROM vw_production_vs_shipments;

