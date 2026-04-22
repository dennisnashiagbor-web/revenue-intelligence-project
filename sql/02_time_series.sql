-- =====================================================
-- Revenue Intelligence Project
-- SQL Time Series Analysis
-- Save as: sql/02_time_series.sql
-- =====================================================


-- =====================================================
-- SECTION 1: MONTHLY WON REVENUE
-- Total revenue from Won deals by month
-- =====================================================

SELECT
    DATE_TRUNC('month', close_date) AS revenue_month,
    SUM(close_value) AS monthly_revenue
FROM fact_opportunity
WHERE deal_stage = 'Won'
  AND close_date IS NOT NULL
GROUP BY DATE_TRUNC('month', close_date)
ORDER BY revenue_month;


-- =====================================================
-- SECTION 2: MONTHLY WON DEAL COUNT
-- Number of Won deals closed each month
-- =====================================================

SELECT
    DATE_TRUNC('month', close_date) AS revenue_month,
    COUNT(*) AS won_deals
FROM fact_opportunity
WHERE deal_stage = 'Won'
  AND close_date IS NOT NULL
GROUP BY DATE_TRUNC('month', close_date)
ORDER BY revenue_month;


-- =====================================================
-- SECTION 3: AVERAGE WON DEAL SIZE BY MONTH
-- Average close_value of Won deals each month
-- =====================================================

SELECT
    DATE_TRUNC('month', close_date) AS revenue_month,
    AVG(close_value) AS avg_deal_size
FROM fact_opportunity
WHERE deal_stage = 'Won'
  AND close_date IS NOT NULL
GROUP BY DATE_TRUNC('month', close_date)
ORDER BY revenue_month;


-- =====================================================
-- SECTION 4: MONTHLY OPPORTUNITIES CREATED
-- Pipeline creation trend using engage_date
-- =====================================================

SELECT
    DATE_TRUNC('month', engage_date) AS engage_month,
    COUNT(*) AS opportunities_created
FROM fact_opportunity
WHERE engage_date IS NOT NULL
GROUP BY DATE_TRUNC('month', engage_date)
ORDER BY engage_month;


-- =====================================================
-- SECTION 5: RUNNING TOTAL REVENUE
-- Cumulative monthly won revenue
-- =====================================================

SELECT
    revenue_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY revenue_month
    ) AS running_total_revenue
FROM (
    SELECT
        DATE_TRUNC('month', close_date) AS revenue_month,
        SUM(close_value) AS monthly_revenue
    FROM fact_opportunity
    WHERE deal_stage = 'Won'
      AND close_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', close_date)
) t
ORDER BY revenue_month;


-- =====================================================
-- SECTION 6: PRIOR MONTH REVENUE
-- Previous month comparison using LAG()
-- =====================================================

SELECT
    revenue_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (
        ORDER BY revenue_month
    ) AS prior_month_revenue
FROM (
    SELECT
        DATE_TRUNC('month', close_date) AS revenue_month,
        SUM(close_value) AS monthly_revenue
    FROM fact_opportunity
    WHERE deal_stage = 'Won'
      AND close_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', close_date)
) t
ORDER BY revenue_month;


-- =====================================================
-- SECTION 7: MONTH-OVER-MONTH REVENUE CHANGE ($)
-- Difference vs prior month
-- =====================================================

SELECT
    revenue_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (
        ORDER BY revenue_month
    ) AS prior_month_revenue,
    monthly_revenue
    - LAG(monthly_revenue) OVER (
        ORDER BY revenue_month
    ) AS mom_revenue_change
FROM (
    SELECT
        DATE_TRUNC('month', close_date) AS revenue_month,
        SUM(close_value) AS monthly_revenue
    FROM fact_opportunity
    WHERE deal_stage = 'Won'
      AND close_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', close_date)
) t
ORDER BY revenue_month;


-- =====================================================
-- SECTION 8: MONTH-OVER-MONTH GROWTH RATE (%)
-- Percent growth vs prior month
-- =====================================================

SELECT
    revenue_month,
    monthly_revenue,
    LAG(monthly_revenue) OVER (
        ORDER BY revenue_month
    ) AS prior_month_revenue,
    ROUND(
        (
            monthly_revenue
            - LAG(monthly_revenue) OVER (
                ORDER BY revenue_month
            )
        )
        /
        NULLIF(
            LAG(monthly_revenue) OVER (
                ORDER BY revenue_month
            ),
            0
        ),
        4
    ) AS mom_growth_rate
FROM (
    SELECT
        DATE_TRUNC('month', close_date) AS revenue_month,
        SUM(close_value) AS monthly_revenue
    FROM fact_opportunity
    WHERE deal_stage = 'Won'
      AND close_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', close_date)
) t
ORDER BY revenue_month;


-- =====================================================
-- SECTION 9: MONTHLY WON REVENUE BY PRODUCT
-- Product trend analysis over time
-- =====================================================

SELECT
    DATE_TRUNC('month', close_date) AS revenue_month,
    product,
    SUM(close_value) AS monthly_revenue
FROM fact_opportunity
WHERE deal_stage = 'Won'
  AND close_date IS NOT NULL
GROUP BY
    DATE_TRUNC('month', close_date),
    product
ORDER BY
    revenue_month,
    monthly_revenue DESC;


-- =====================================================
-- SECTION 10: MONTHLY WON REVENUE BY SECTOR
-- Revenue trends by customer industry
-- =====================================================

SELECT
    DATE_TRUNC('month', f.close_date) AS revenue_month,
    a.sector,
    SUM(f.close_value) AS monthly_revenue
FROM fact_opportunity f
JOIN dim_account a
    ON f.account = a.account
WHERE f.deal_stage = 'Won'
  AND f.close_date IS NOT NULL
GROUP BY
    DATE_TRUNC('month', f.close_date),
    a.sector
ORDER BY
    revenue_month,
    monthly_revenue DESC;
