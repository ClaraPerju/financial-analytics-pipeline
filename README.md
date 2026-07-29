📊 **Financial Analytics Pipeline — Manufacturing Enterprise**

Engineered an end-to-end data engineering pipeline and analytics warehouse utilizing financial and operational data from a real manufacturing company (anonymized for privacy). The architecture transforms raw, multi-sheet financial Excel reports via Python script into a 3-layer MySQL data warehouse (Bronze, Silver, Gold) featuring automated ingestion, SQL-driven transformations, and executive Tableau dashboards.

Note: All financial and operational metrics originate from a real manufacturing enterprise. To comply with non-disclosure and privacy agreements, company identifiers have been completely anonymised, and public links serve strictly as demonstrative references.

**Tableau Dashboards:** https://public.tableau.com/views/FinancialPerformanceOverview_17853066064960/CustomerSalesProductionStrategyOverview

**Core Architecture & Medallion Design**

The pipeline leverages a 3-tier Medallion Architecture (Bronze, Silver, Gold) to structure and refine company data:
- Data Sources: 4 multi-sheet operational and financial Excel workbooks.
- Ingestion (Python): Python scripts extract raw wide-format data from the multi-sheet Excel files, cleanse and reshape them into structured long formats using pandas, and automatically load the processed records directly into the Bronze layer.

**Storage & Refinement Layers**

- Bronze (Raw Ingestion): Staging tables containing the Excel data loaded via Python.
- Silver (Normalised Schema): A fully normalised relational schema (14 tables) enforced with primary/foreign keys, correct data types, and cleansed values.
- Gold (Analytics Layer): Aggregated business views and analytical tables optimised for high-performance reporting and executive dashboard consumption.

**Key Technical Capabilities**

- Python Data Engineering: Automated ETL scripts using pandas to read multi-sheet Excel files, handle missing values, transform complex wide layouts into normalised long formats, and programmatically insert data into the Bronze database layer.
- Advanced SQL Pipelines: Dynamic data casting, regex string cleaning, conditional aggregation, and complex window functions.
- Financial Calculation Engine: SQL scripts dynamically compute 20+ core business KPIs, including ROE, ROA, EBITDA, and liquidity ratios.
- Executive Dashboards: Tableau views delivering end-to-end coverage of Operations, Cash Flow, P&L, and Customer Analytics.

**Project Links & Deliverables**

- Documentation: comming soon
- Interactive Dashboards: Tableau Public BI Suite
   https://public.tableau.com/views/FinancialPerformanceOverview_17853066064960/CustomerSalesProductionStrategyOverview

**Author**
- Clara Perju — Financial Analyst
- Specialisation: SQL, Python, Business Intelligence (CFI certification)
- Background: BSc in Finance & Banking | MSc in Accounting, Control & Audit
- GitHub: https://github.com/ClaraPerju
