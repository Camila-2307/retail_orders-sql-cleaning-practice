# Retail orders data cleaning practice

Use `retail_orders_dirty.csv` with SQL or Python. It contains **46 rows** of deliberately messy order data. The file is raw input: keep a copy unchanged before cleaning.

## Practice tasks
1. Profile row counts, null/blank values, distinct values, and numeric ranges.
2. Standardize dates, names, email casing, city/state names, product names, payment methods, and order statuses.
3. Find exact duplicate rows and order IDs that appear more than once. Decide how to handle conflicting duplicates.
4. Validate quantity, price, discount, email, date, and allowed category values.
5. Choose and document a policy for missing or invalid values; do not silently guess.
6. Produce a cleaned dataset and a short quality report (rows kept, fixed, removed, or flagged).

## Suggested schema
- `order_id`: integer identifier
- `order_date`: ISO date (`YYYY-MM-DD`)
- `customer_name`, `email`, `city`, `state`, `product`: text
- `quantity`: positive integer
- `unit_price`: nonnegative decimal
- `discount_pct`: number from 0 to 100
- `payment_method`, `order_status`: standardized categories

There is no single correct cleaning policy. Preserve questionable records in a separate exceptions file or flag them, and explain your choices.
