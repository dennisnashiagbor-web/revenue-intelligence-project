# Revenue Intelligence Dashboard | SQL + Tableau Project

## Overview

This project is an end-to-end business intelligence and analytics workflow built around sales opportunity data. The goal was to create a clean analytics layer in SQL, generate decision-ready KPIs, and design a Tableau dashboard that presents revenue performance in a format business stakeholders can use quickly.

The project focuses on revenue analysis, sales performance, and dashboard storytelling using PostgreSQL, SQL, Python, and Tableau Public.

## Business Objective

The dashboard is designed to answer simple business questions:

- How is revenue performing?
- What is driving it? 
- What should decision-makers pay attention to?

To answer that, the project tracks:

* Won deals
* Total revenue
* Win rate
* Average deal size
* Monthly revenue trend
* Product-level revenue performance

## Tools Used

* PostgreSQL
* SQL
* Python
* Jupyter Notebook
* Tableau Public
* GitHub Pages

## Dataset

Source: Kaggle CRM Sales Opportunities dataset

The original dataset included multiple related CSV files:

* accounts
* products
* sales pipeline
* sales teams

These files were inspected, cleaned, validated, and then loaded into PostgreSQL as separate tables for analysis.

## Project Workflow

### 1. Data Inspection and Cleaning

The raw files were loaded into Jupyter Notebook and reviewed for:

* duplicate records
* missing values
* invalid joins between tables
* incorrect data types
* stage-level data consistency

Key cleaning decisions included:

* removing pipeline rows with null account values
* converting date fields to proper datetime format
* converting revenue fields to numeric
* reconciling product mismatches between the pipeline and product tables

### 2. SQL Data Modeling

The cleaned files were structured into a relational analytics model using:

* `dim_account`
* `dim_product`
* `dim_sales_agent`
* `fact_opportunity`

This created a simple business intelligence schema suitable for KPI reporting and dashboard development.

### 3. KPI and Revenue Analysis in SQL

SQL was used to calculate core business metrics such as:

* total opportunities
* won deals
* lost deals
* total won revenue
* average won deal size
* win rate
* revenue by product
* revenue by sector
* revenue by regional office
* rep-level revenue performance

The project also included time-series analysis using:

* monthly revenue trends
* running total revenue
* month-over-month growth
* sales cycle analysis

### 4. Dashboard Development

A Tableau Public dashboard was built to present the most important outputs in an executive-friendly format.

The final dashboard includes:

* KPI cards for won deals, total revenue, win rate, and average deal size
* monthly won revenue trend
* revenue by product visualization

## Key Results

* **7,375** total opportunities analyzed
* **4,238** won deals
* **$10.0M** in total won revenue
* **63.2%** overall win rate
* **$2,361** average deal size

Top revenue-driving products included:

* GTXPro
* GTX Plus Pro
* MG Advanced

## What This Project Demonstrates

This project was built to show more than just charting ability. It demonstrates:

* SQL for business analysis
* relational data modeling
* data cleaning and validation
* KPI design
* time-series analysis
* dashboard storytelling
* translating raw data into executive-facing insights

## Business Takeaways

A few clear patterns emerged from the analysis:

* Revenue concentration was driven heavily by a small number of products
* Win rates were strong overall, suggesting efficient conversion on closed opportunities
* The dashboard format makes it easier to monitor performance at both headline and product levels

## Live Dashboard

[Tableau Public Dashboard](https://public.tableau.com/views/RevenueIntelligenceDashboardSQLTableauProject/RevenueIntelligenceDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Repository Structure

```text
revenue-intelligence-project/
├── data/
├── notebooks/
├── sql/
│   ├── 01_core_kpis.sql
│   ├── 02_time_series.sql
│   └── 03_sales_performance.sql
├── dashboards/
├── README.md
```

## Author

**Dennis Ashiagbor**
