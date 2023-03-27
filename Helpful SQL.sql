SELECT
  customer_id,
  order_date,
  SUM(order_total) OVER (PARTITION BY customer_id ORDER BY order_date) as running_total
FROM
  orders
HAVING
  running_total > 1000;


WITH customer_region AS (
    SELECT c.customer_id, r.region_name
    FROM customers c
    JOIN addresses a ON c.address_id = a.address_id
    JOIN regions r ON a.region_id = r.region_id
),
monthly_sales AS (
    SELECT p.product_id, p.product_name, SUM(sales_amount) AS total_sales, EXTRACT(MONTH FROM sales_date) AS sales_month, EXTRACT(YEAR FROM sales_date) AS sales_year
    FROM fact_daily_sales fds
    JOIN products p ON fds.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, sales_month, sales_year
),
monthly_sales_targets AS (
    SELECT product_id, sales_target, EXTRACT(MONTH FROM target_date) AS target_month, EXTRACT(YEAR FROM target_date) AS target_year
    FROM fact_monthly_targets
),
sales_vs_targets AS (
    SELECT ms.product_id, ms.product_name, ms.sales_month, ms.sales_year, ms.total_sales, mst.sales_target, (ms.total_sales / mst.sales_target) * 100 AS sales_target_percentage
    FROM monthly_sales ms
    JOIN monthly_sales_targets mst ON ms.product_id = mst.product_id AND ms.sales_month = mst.target_month AND ms.sales_year = mst.target_year
)

SELECT cr.region_name, svt.product_name, svt.sales_year, ROUND(AVG(svt.sales_target_percentage), 2) AS avg_sales_target_percentage
FROM sales_vs_targets svt
JOIN fact_daily_sales fds ON svt.product_id = fds.product_id
JOIN customer_region cr ON fds.customer_id = cr.customer_id
GROUP BY cr.region_name, svt.product_name, svt.sales_year
HAVING AVG(svt.sales_target_percentage) < 100
ORDER BY cr.region_name, svt.product_name, svt.sales_year;

