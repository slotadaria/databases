USE economics;

WITH all_about_products AS(
SELECT p.product_id, p.product_name, p.price, c.cost_materials, c.cost_labor, s. quantity, s. sale_date, r.revenue, e.employee_id
FROM products p
INNER JOIN costs c
ON p.product_id = c.product_id
INNER JOIN sales  s
ON p.product_id = s.product_id
INNER JOIN revenue r
ON s.sale_id = r.sale_id
INNER JOIN employee e
ON p.product_id = e.product_id)
-- I'm using inner join, because I need rows that match from different tables,
-- here I could have also used other joins since I have same product_id and sale_id, and each product_id has information needed in each table
(SELECT a.product_id, a.product_name, 
 SUM(a.revenue) AS total_revenue,
 SUM((a.cost_materials + a.cost_labor)*a.quantity ) AS total_cost,
 SUM(a.revenue) - SUM((a.cost_materials + a.cost_labor)*a.quantity) AS total_profit
FROM all_about_products a
WHERE product_id IN (
    SELECT s.product_id
    FROM sales s
    INNER JOIN revenue r ON s.sale_id = r.sale_id
    WHERE r.revenue > 500 OR s.quantity > 10
)
GROUP BY a.product_id, a.product_name
HAVING SUM(a.quantity) > 5
ORDER BY total_profit DESC
LIMIT 5)
-- I calculated profit using CTE calc_profit, after - grouped so each product had one total quantity/profit. Then, put it in descending order using order by
-- Also, limited it to 5 so it showed only 5 products with biggest profut
UNION 
SELECT product_id, product_name, 
NULL AS total_revenue ,
NULL AS total_cost ,
NULL AS total_profit 
FROM products;




