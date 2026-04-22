-- Core KPI Queries

-- Total opportunities
SELECT COUNT(*) AS total_opportunities
FROM fact_opportunity;

-- Won deals
SELECT COUNT(*) AS won_deals
FROM fact_opportunity
WHERE deal_stage = 'Won';

-- Total won revenue
SELECT SUM(close_value) AS total_won_revenue
FROM fact_opportunity
WHERE deal_stage = 'Won';

-- Revenue by product
SELECT product, SUM(close_value) AS total_revenue
FROM fact_opportunity
WHERE deal_stage = 'Won'
GROUP BY product
ORDER BY total_revenue DESC;

-- Calculate total revenue from won deals
SELECT SUM(close_value)
FROM fact_opportunity
WHERE deal_stage = 'Won';

-- =====================================================
-- Revenue Intelligence Project
-- SQL Queries Written So Far
-- Save as: sql/01_core_kpis.sql
-- =====================================================


-- =====================================================
-- SECTION 1: TABLE PREVIEWS
-- =====================================================

SELECT *
FROM dim_account
LIMIT 5;

SELECT *
FROM dim_product
LIMIT 5;

SELECT *
FROM dim_sales_agent
LIMIT 5;

SELECT *
FROM fact_opportunity
LIMIT 5;


-- =====================================================
-- SECTION 2: SELECT SPECIFIC COLUMNS
-- =====================================================

SELECT
    opportunity_id,
    account,
    product,
    deal_stage,
    close_value
FROM fact_opportunity
LIMIT 10;


-- =====================================================
-- SECTION 3: FILTERING WITH WHERE
-- =====================================================

SELECT
    opportunity_id,
    account,
    product,
    deal_stage,
    close_value
FROM fact_opportunity
WHERE deal_stage = 'Won'
LIMIT 10;


-- =====================================================
-- SECTION 4: SORTING RESULTS
-- =====================================================

SELECT
    opportunity_id,
    account,
    product,
    close_value
FROM fact_opportunity
WHERE deal_stage = 'Won'
ORDER BY close_value DESC
LIMIT 10;


-- =====================================================
-- SECTION 5: CORE COUNTS
-- =====================================================

SELECT COUNT(*) AS total_opportunities
FROM fact_opportunity;

SELECT COUNT(*) AS won_deals
FROM fact_opportunity
WHERE deal_stage = 'Won';

SELECT COUNT(*) AS lost_deals
FROM fact_opportunity
WHERE deal_stage = 'Lost';


-- =====================================================
-- SECTION 6: REVENUE KPIs
-- =====================================================

SELECT SUM(close_value) AS total_won_revenue
FROM fact_opportunity
WHERE deal_stage = 'Won';

SELECT AVG(close_value) AS avg_won_deal_size
FROM fact_opportunity
WHERE deal_stage = 'Won';


-- =====================================================
-- SECTION 7: REVENUE BY PRODUCT
-- =====================================================

SELECT
    product,
    SUM(close_value) AS total_revenue
FROM fact_opportunity
WHERE deal_stage = 'Won'
GROUP BY product
ORDER BY total_revenue DESC;


-- =====================================================
-- SECTION 8: OPPORTUNITIES BY STAGE
-- =====================================================

SELECT
    deal_stage,
    COUNT(*) AS num_opportunities
FROM fact_opportunity
GROUP BY deal_stage
ORDER BY num_opportunities DESC;


-- =====================================================
-- SECTION 9: TOP ACCOUNTS BY REVENUE
-- =====================================================

SELECT
    account,
    SUM(close_value) AS total_revenue
FROM fact_opportunity
WHERE deal_stage = 'Won'
GROUP BY account
ORDER BY total_revenue DESC
LIMIT 10;


-- =====================================================
-- SECTION 10: JOINS - REVENUE BY SECTOR
-- =====================================================

SELECT
    a.sector,
    SUM(f.close_value) AS total_revenue
FROM fact_opportunity f
JOIN dim_account a
    ON f.account = a.account
WHERE f.deal_stage = 'Won'
GROUP BY a.sector
ORDER BY total_revenue DESC;


-- =====================================================
-- SECTION 11: JOINS - REVENUE BY REGIONAL OFFICE
-- =====================================================

SELECT
    s.regional_office,
    SUM(f.close_value) AS total_revenue
FROM fact_opportunity f
JOIN dim_sales_agent s
    ON f.sales_agent = s.sales_agent
WHERE f.deal_stage = 'Won'
GROUP BY s.regional_office
ORDER BY total_revenue DESC;


-- =====================================================
-- SECTION 12: DEAL COUNTS BY SALES AGENT
-- =====================================================

SELECT
    sales_agent,
    COUNT(*) AS total_deals
FROM fact_opportunity
GROUP BY sales_agent
ORDER BY total_deals DESC
LIMIT 10;

SELECT
    sales_agent,
    COUNT(*) AS won_deals
FROM fact_opportunity
WHERE deal_stage = 'Won'
GROUP BY sales_agent
ORDER BY won_deals DESC
LIMIT 10;


-- =====================================================
-- SECTION 13: WIN RATE KPI
-- =====================================================

SELECT
    COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS won_deals,
    COUNT(CASE WHEN deal_stage IN ('Won', 'Lost') THEN 1 END) AS closed_deals,
    ROUND(
        COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END)::NUMERIC
        /
        NULLIF(
            COUNT(CASE WHEN deal_stage IN ('Won', 'Lost') THEN 1 END),
            0
        ),
        4
    ) AS win_rate
FROM fact_opportunity;


-- =====================================================
-- SECTION 14: OPEN PIPELINE (RAW)
-- May return NULL if all close_value values are NULL
-- =====================================================

SELECT SUM(close_value) AS open_pipeline_value
FROM fact_opportunity
WHERE deal_stage IN ('Prospecting', 'Engaging');


-- =====================================================
-- SECTION 15: OPEN PIPELINE WITH COALESCE
-- Converts NULL to 0
-- =====================================================

SELECT COALESCE(SUM(close_value), 0) AS open_pipeline_value
FROM fact_opportunity
WHERE deal_stage IN ('Prospecting', 'Engaging');


-- =====================================================
-- SECTION 16: VALIDATE OPEN PIPELINE NULLS
-- =====================================================

SELECT
    deal_stage,
    COUNT(*) AS rows,
    COUNT(close_value) AS populated_values
FROM fact_opportunity
WHERE deal_stage IN ('Prospecting', 'Engaging')
GROUP BY deal_stage;


-- =====================================================
-- SECTION 17: OPEN DEAL COUNTS
-- =====================================================

SELECT
    deal_stage,
    COUNT(*) AS deals
FROM fact_opportunity
WHERE deal_stage IN ('Prospecting', 'Engaging')
GROUP BY deal_stage
ORDER BY deals DESC;
