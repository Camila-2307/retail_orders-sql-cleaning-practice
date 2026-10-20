# retail_orders-sql-cleaning-practice

A small project for learning how to inspect and clean messy data with SQL. The dataset is synthetic and contains 46 intentionally messy retail order records.

## Files
* retail_order_dirty.csv - the original dataset
* retail_orders_practice.md - cleaning exercises
* order_dataset_clean.csv - a cleaned version to compare against
* SQL_retail_dataset_practice.sql - SQL queries for the practice

##How to use
1. Download retail_order_dirty.csv
2. Import it into SQLite as a table named orders_raw
3. Follow the exercises in retail_orders_practice.md, or run clean_orders.sql
4. Compare your results with the example cleaning decisions.

The SQL script keeps the original table unchanged and creates a separate cleaned table named orders_clean.

## Reflection
I practice profiling and cleaning a messy dataset with SQL. I found duplicate order IDs, inconsistent formatting, and invalid values. I kept the raw data unchanged and documentedd the choices I made for the cleaned version.
