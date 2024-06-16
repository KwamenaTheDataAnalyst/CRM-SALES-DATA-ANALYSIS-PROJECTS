--4. Product Performance Analysis
--	What is the total number of Products sold?
-- What is the total number of products lost?
--	What is the total revenue generated from sales?
-- What is the estimated revenue generated from sales?
--  What is the trend for revenue and product quantity over time?
-- How much is each product contributing to the revenue and profit generated?
-- What are the number of won deals by product?
--	What are the number of lost deals by product?
--	What is the monthly sales trend for each product?
--	Is the company gaining or losing?


--4.	Product Performance Analysis

--	What is the total number of Products sold?
SELECT
	COUNT(product) total_product_sold
FROM sales_pipeline
WHERE deal_stage = 'Won';

-- What is the total number of Products lost?
SELECT
	COUNT(product) total_product_lost
FROM sales_pipeline
WHERE deal_stage = 'Lost';

-- What is the total revenue generated from sales?
SELECT
	SUM(close_value) total_revenue
FROM sales_pipeline
WHERE deal_stage = 'Won';

--3. What is the estimated revenue generated from sales?
WITH t1 AS (										
			SELECT
				sp.product, 
				COUNT(sp.*) quantity,
				p.sales_price AS sales_price,
				(COUNT(sp.*) * p.sales_price) AS total_cost,
				SUM(close_value) total_revenue
			FROM sales_pipeline sp
			JOIN products p
			ON sp.product = p.product
			WHERE deal_stage = 'Won'
			GROUP BY sp.product,3
		)	
SELECT  SUM(total_cost) estimated_total_revenue
FROM t1;

-- Find the revenue and product quantity over time?
SELECT 
	TO_CHAR(close_date, 'Month') AS month,
	COUNT(product) quantity_sold,
	SUM(close_value) revenue
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY 1
ORDER BY MIN(close_date);

-- What are the number of won and lost deals by product?
SELECT 
	t1.product,
	t1.total_won_deals,
	t2.total_lost_deals	
FROM (	SELECT 
	  		product,
			COUNT(*) total_won_deals
	  	FROM sales_pipeline
	  	WHERE deal_stage = 'Won'
		GROUP BY product) AS t1
JOIN
		(SELECT 
			product,
			COUNT(*) total_lost_deals
		FROM sales_pipeline
		WHERE deal_stage = 'Lost'
		GROUP BY product) AS t2
ON t1.product = t2.product
ORDER BY 2 DESC;


-- What is the monthly sales trend for each product?
SELECT 
	TO_CHAR(close_date, 'Month') AS month,
	product,
	SUM(close_value) sales
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY 1,2
ORDER BY MIN(close_date);


--3. What is the revenue and profit generated from each products?
WITH t1 AS (										
			SELECT
				sp.product, 
				COUNT(sp.*) quantity,
				p.sales_price AS sales_price,
				(COUNT(sp.*) * p.sales_price) AS total_cost,
				SUM(close_value) total_revenue
			FROM sales_pipeline sp
			JOIN products p
			ON sp.product = p.product
			WHERE deal_stage = 'Won'
			GROUP BY sp.product,sales_price
		)	
SELECT  product, total_revenue, (total_revenue - total_cost) AS profit
FROM t1
ORDER BY total_revenue DESC;




--	Is the company gaining or losing?
WITH t1 AS (										
			SELECT
				sp.product, 
				COUNT(sp.*) quantity,
				p.sales_price AS sales_price,
				(COUNT(sp.*) * p.sales_price) AS cost,
				SUM(close_value) revenue
			FROM sales_pipeline sp
			JOIN products p
			ON sp.product = p.product
			WHERE deal_stage = 'Won'
			GROUP BY sp.product,sales_price
		)	
SELECT  SUM(revenue) total_revenue,SUM(cost) total_cost,
	SUM(revenue - cost) AS total_profit
FROM t1;





