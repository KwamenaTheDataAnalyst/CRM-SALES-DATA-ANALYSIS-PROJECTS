5.	Account Analysis
-- What is the total number of accounts in the sales pipeline?
-- Which sector have the most accounts?
-- Which region does are most accounts situated?	
-- What is the revenue and profit generated from each account?
-- What is the revenue and profit generated from each sector?
-- What is the revenue and profit generated from each office location?
-- Which accounts have the highest average revenue per order?
-- What is the distribution of deals for the  account that had the maximum revenue?

	
-- What is the total number of accounts in the sales pipeline?
SELECT 
	COUNT(DISTINCT account) total_account
FROM sales_pipeline
WHERE account IS NOT NULL;

-- Which sector have the most accounts?
SELECT
	a.sector,
	COUNT(DISTINCT sp.account) total_account
FROM sales_pipeline sp
JOIN accounts a ON a.account = sp.account
WHERE sp.account IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

-- Which location are most accounts situated?
SELECT
	a.office_loc locations,
	COUNT(DISTINCT sp.account) total_account
FROM sales_pipeline sp
JOIN accounts a ON a.account = sp.account
WHERE sp.account IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

-- What is the revenue and profit generated from each account?
WITH t1 AS (										
			SELECT
				sp.account,
				sp.product, 
				COUNT(sp.*) quantity,
				p.sales_price AS sales_price,
				(COUNT(sp.*) * p.sales_price) AS cost,
				SUM(close_value) revenue
			FROM sales_pipeline sp
			JOIN products p
			ON sp.product = p.product
			WHERE deal_stage = 'Won'
			GROUP BY sp.account,sp.product,sales_price
		)	
SELECT  account,SUM(revenue) total_revenue,
	SUM(revenue - cost) AS total_profit
FROM t1
GROUP BY 1
ORDER BY total_revenue DESC;


-- What is the revenue and profit generated from each sector?
WITH t1 AS (										
			SELECT
				a.sector,
				sp.product, 
				COUNT(sp.*) quantity,
				p.sales_price AS sales_price,
				(COUNT(sp.*) * p.sales_price) AS cost,
				SUM(close_value) revenue
			FROM sales_pipeline sp
			JOIN products p
			ON sp.product = p.product
			JOIN accounts a
			ON a.account = sp.account
			WHERE deal_stage = 'Won'
			GROUP BY a.sector,sp.product,sales_price
		)	
SELECT  sector,SUM(revenue) total_revenue,
	SUM(revenue - cost) AS total_profit
FROM t1
GROUP BY 1
ORDER BY total_revenue DESC;

-- What is the revenue and profit generated from each office location?
WITH t1 AS (										
			SELECT
				a.office_loc location,
				sp.product, 
				COUNT(sp.*) quantity,
				p.sales_price AS sales_price,
				(COUNT(sp.*) * p.sales_price) AS cost,
				SUM(close_value) revenue
			FROM sales_pipeline sp
			JOIN products p
			ON sp.product = p.product
			JOIN accounts a
			ON a.account = sp.account
			WHERE deal_stage = 'Won'
			GROUP BY location,sp.product,sales_price
		)	
SELECT  location,SUM(revenue) total_revenue,
	SUM(revenue - cost) AS total_profit
FROM t1
GROUP BY 1
ORDER BY total_revenue DESC;

--	Which accounts have the highest average revenue per order?
SELECT
	account,
	ROUND(SUM(close_value) / COUNT(opportunity_id),2) AS avg_revenue_per_order
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;





