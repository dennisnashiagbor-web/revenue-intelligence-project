-- =====================================================
-- Revenue Intelligence Project
-- Sales Performance Analysis
-- Save as: sql/03_sales_performance.sql
-- =====================================================


-- =====================================================
-- SECTION 1: SALES CYCLE DETAIL
-- Days from engage_date to close_date for Won deals
-- =====================================================

SELECT
    opportunity_id,
    account,
    sales_agent,
    product,
    engage_date,
    close_date,
    (close_date - engage_date) AS sales_cycle_days
FROM fact_opportunity
WHERE deal_stage = 'Won'
  AND engage_date IS NOT NULL
  AND close_date IS NOT NULL
ORDER BY sales_cycle_days DESC;


-- =====================================================
-- SECTION 2: AVERAGE SALES CYCLE LENGTH
-- Average number of days to close Won deals
-- =====================================================

SELECT
    ROUND(
        AVG(close_date - engage_date),
        2
    ) AS avg_sales_cycle_days
FROM fact_opportunity
WHERE deal_stage = 'Won'
  AND engage_date IS NOT NULL
  AND close_date IS NOT NULL;


-- =====================================================
-- SECTION 3: AVERAGE SALES CYCLE BY PRODUCT
-- Which products take longest to close?
-- =====================================================

SELECT
    product,
    ROUND(
        AVG(close_date - engage_date),
        2
    ) AS avg_sales_cycle_days
FROM fact_opportunity
WHERE deal_stage = 'Won'
  AND engage_date IS NOT NULL
  AND close_date IS NOT NULL
GROUP BY product
ORDER BY avg_sales_cycle_days DESC;


-- =====================================================
-- SECTION 4: FASTEST SALES REPS TO CLOSE DEALS
-- Lowest average close cycle
-- =====================================================

SELECT
    sales_agent,
    ROUND(
        AVG(close_date - engage_date),
        2
    ) AS avg_sales_cycle_days
FROM fact_opportunity
WHERE deal_stage = 'Won'
  AND engage_date IS NOT NULL
  AND close_date IS NOT NULL
GROUP BY sales_agent
ORDER BY avg_sales_cycle_days ASC
LIMIT 10;


-- =====================================================
-- SECTION 5: FUNNEL COUNTS BY DEAL STAGE
-- Opportunity distribution across stages
-- =====================================================

SELECT
    deal_stage,
    COUNT(*) AS deals
FROM fact_opportunity
GROUP BY deal_stage
ORDER BY deals DESC;


-- =====================================================
-- SECTION 6: WIN RATE BY SALES REP
-- Won deals divided by all closed deals
-- =====================================================

SELECT
    sales_agent,
    COUNT(
        CASE
            WHEN deal_stage = 'Won' THEN 1
        END
    ) AS won_deals,

    COUNT(
        CASE
            WHEN deal_stage IN ('Won', 'Lost') THEN 1
        END
    ) AS closed_deals,

    ROUND(
        COUNT(
            CASE
                WHEN deal_stage = 'Won' THEN 1
            END
        )::NUMERIC
        /
        NULLIF(
            COUNT(
                CASE
                    WHEN deal_stage IN ('Won', 'Lost') THEN 1
                END
            ),
            0
        ),
        4
    ) AS win_rate

FROM fact_opportunity
GROUP BY sales_agent
ORDER BY win_rate DESC;


-- =====================================================
-- SECTION 7: TOP REPS BY WON REVENUE
-- Highest revenue-producing reps
-- =====================================================

SELECT
    sales_agent,
    SUM(close_value) AS won_revenue
FROM fact_opportunity
WHERE deal_stage = 'Won'
GROUP BY sales_agent
ORDER BY won_revenue DESC
LIMIT 10;


-- =====================================================
-- SECTION 8: AVERAGE WON DEAL VALUE BY REP
-- Revenue efficiency per closed-won deal
-- =====================================================

SELECT
    sales_agent,
    ROUND(
        AVG(close_value),
        2
    ) AS avg_won_deal_value
FROM fact_opportunity
WHERE deal_stage = 'Won'
GROUP BY sales_agent
ORDER BY avg_won_deal_value DESC;


-- =====================================================
-- SECTION 9: SECTOR WIN RATE
-- Which industries convert best?
-- =====================================================

SELECT
    a.sector,

    COUNT(
        CASE
            WHEN f.deal_stage = 'Won' THEN 1
        END
    ) AS won_deals,

    COUNT(
        CASE
            WHEN f.deal_stage IN ('Won', 'Lost') THEN 1
        END
    ) AS closed_deals,

    ROUND(
        COUNT(
            CASE
                WHEN f.deal_stage = 'Won' THEN 1
            END
        )::NUMERIC
        /
        NULLIF(
            COUNT(
                CASE
                    WHEN f.deal_stage IN ('Won', 'Lost') THEN 1
                END
            ),
            0
        ),
        4
    ) AS win_rate

FROM fact_opportunity f
JOIN dim_account a
    ON f.account = a.account

GROUP BY a.sector
ORDER BY win_rate DESC;


-- =====================================================
-- SECTION 10: LARGE DEAL ANALYSIS
-- Won deals above threshold
-- =====================================================

SELECT
    COUNT(*) AS large_deals,
    SUM(close_value) AS large_deal_revenue
FROM fact_opportunity
WHERE deal_stage = 'Won'
  AND close_value >= 10000;


-- =====================================================
-- SECTION 11: LARGE DEALS BY REP
-- Which reps close the most large deals?
-- =====================================================

SELECT
    sales_agent,
    COUNT(*) AS large_deals,
    SUM(close_value) AS large_deal_revenue
FROM fact_opportunity
WHERE deal_stage = 'Won'
  AND close_value >= 10000
GROUP BY sales_agent
ORDER BY large_deal_revenue DESC;


-- =====================================================
-- SECTION 12: REGIONAL OFFICE PERFORMANCE
-- Revenue by office location
-- =====================================================

SELECT
    s.regional_office,
    SUM(f.close_value) AS won_revenue,
    COUNT(*) AS won_deals
FROM fact_opportunity f
JOIN dim_sales_agent s
    ON f.sales_agent = s.sales_agent
WHERE f.deal_stage = 'Won'
GROUP BY s.regional_office
ORDER BY won_revenue DESC;


-- =====================================================
-- SECTION 13: PRODUCT PERFORMANCE BY REP
-- Top rep-product combinations
-- =====================================================

SELECT
    sales_agent,
    product,
    SUM(close_value) AS won_revenue
FROM fact_opportunity
WHERE deal_stage = 'Won'
GROUP BY sales_agent, product
ORDER BY won_revenue DESC
LIMIT 20;
