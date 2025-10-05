USE economics;
DROP VIEW IF EXISTS all_about_products ;
CREATE VIEW all_about_products AS 
SELECT p.product_id, p.product_name, p.price, c.cost_materials, c.cost_labor, s. quantity, s. sale_date, r.revenue, e.employee_id
FROM products p
INNER JOIN costs c
ON p.product_id = c.product_id
INNER JOIN sales  s
ON p.product_id = s.product_id
INNER JOIN revenue r
ON s.sale_id = r.sale_id
INNER JOIN employee e
ON p.product_id = e.product_id;

WITH calc_profit AS(
SELECT product_id, product_name, 
 SUM(revenue) AS total_revenue,
 SUM((cost_materials + cost_labor)*quantity ) AS total_cost
FROM all_about_products a
GROUP BY product_id, product_name)
SELECT product_id, product_name,total_revenue,total_cost,
total_revenue - total_cost AS total_profit
FROM calc_profit
ORDER BY total_profit DESC
LIMIT 5;

SELECT product_id, product_name
FROM products
WHERE product_id IN (
    SELECT s.product_id
    FROM sales s
    INNER JOIN revenue r ON s.sale_id = r.sale_id
    WHERE r.revenue > 500 OR s.quantity > 10
);

SELECT product_id, product_name, price, 
SUM(quantity) AS total_quantity
FROM all_about_products
GROUP BY product_id
HAVING total_quantity > 5;

SELECT product_id FROM products
UNION 
SELECT product_id FROM employee;





