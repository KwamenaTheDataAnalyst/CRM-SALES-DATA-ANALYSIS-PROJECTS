--3. Sales Team Performance:
--  What is total number of staffs at each regional office?
--	Who are the top-performing sales agents?
--	Who are the most effective managers?
--	Which regional offices are under-performing?
--	Which sales manager is most effective at selling a specific product?

--  What is total number of active staffs at each regional office?
SELECT   
	st.regional_office,
	COUNT(DISTINCT sp.sales_agent) agents_count,
	COUNT(DISTINCT st.manager) managers_count
FROM sales_pipeline sp
 LEFT JOIN sales_teams st
ON sp.sales_agent = st.sales_agent
GROUP BY 1



-- Who are the top-performing sales agents?
	--with respect to total deal count.
SELECT
	sales_agent,
	COUNT(*) total_deals_count,
	SUM(CASE WHEN deal_stage = 'Prospecting' THEN 1 ELSE 0 END) AS prospecting_deals,
	SUM(CASE WHEN deal_stage = 'Engaging' THEN 1 ELSE 0 END) AS engaging_deals,
	SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_deals,
	SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals
FROM sales_pipeline
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

	--Sales agents performance by revenue and profit
WITH t1 AS (
			SELECT
				sales_agent,product, 
				COUNT(*) quantity, SUM(close_value) total_revenue
			FROM sales_pipeline
			WHERE deal_stage = 'Won'
			GROUP BY 1, 2),	
	t2 AS (
			SELECT DISTINCT
				sp.sales_agent,
				sp.product,
				p.sales_price
			FROM sales_pipeline sp
			JOIN products p ON sp.product = p.product)	
SELECT
	t1.sales_agent,SUM(t1.total_revenue) total_revenue,
	SUM(t1.total_revenue - (t1.quantity * t2.sales_price)) AS total_profit  
FROM t1
JOIN t2 ON t1.sales_agent = t2.sales_agent AND t1.product = t2.product
GROUP BY 1
ORDER BY total_profit DESC
LIMIT 5;

-- Who are the most effective managers?
SELECT
	st.manager,
	COUNT(sp.*) number_of_deals,
	SUM(CASE WHEN sp.deal_stage = 'Prospecting' THEN 1 ELSE 0 END) AS prospecting_deals,
	SUM(CASE WHEN sp.deal_stage = 'Engaging' THEN 1 ELSE 0 END) AS engaging_deals,
	SUM(CASE WHEN sp.deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_deals,
	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals
FROM sales_teams st
JOIN sales_pipeline sp
ON st.sales_agent = sp.sales_agent
GROUP BY 1
ORDER BY number_of_deals DESC;



-- Sales managers' performance according to revenue and profit
WITH t1 AS (
			SELECT
				st.manager,
				sp.product, 
				COUNT(*) quantity,				
				SUM(close_value) total_revenue
			FROM sales_teams st
			JOIN sales_pipeline sp ON sp.sales_agent = st.sales_agent 
			WHERE deal_stage = 'Won'
			GROUP BY 1, 2),	
	t2 AS (
			SELECT DISTINCT
				st.manager,
				sp.product,
				p.sales_price
			FROM sales_teams st
			JOIN sales_pipeline sp ON st.sales_agent = sp.sales_agent
			JOIN products p ON p.product = sp.product)	
SELECT
	t1.manager, SUM(t1.total_revenue) total_revenue, 
	SUM(t1.total_revenue - (t1.quantity * t2.sales_price)) AS total_profit  
FROM t1
JOIN t2 ON t1.manager = t2.manager AND t1.product = t2.product
GROUP BY 1
ORDER BY total_revenue DESC;

-- What is the performance of each regional office?
	-- regional office performance by deal stages
SELECT
	st.regional_office,
	COUNT(sp.*) number_of_deals,
	SUM(CASE WHEN sp.deal_stage = 'Prospecting' THEN 1 ELSE 0 END) AS prospecting_deals,
	SUM(CASE WHEN sp.deal_stage = 'Engaging' THEN 1 ELSE 0 END) AS engaging_deals,
	SUM(CASE WHEN sp.deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_deals,
	SUM(CASE WHEN sp.deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals
FROM sales_teams st
JOIN sales_pipeline sp
ON st.sales_agent = sp.sales_agent
GROUP BY 1
ORDER BY number_of_deals DESC;


--Regional office performance according to revenue and profit
WITH t1 AS (
			SELECT
				st.regional_office,
				sp.product, 
				COUNT(*) quantity,				
				SUM(close_value) total_revenue
			FROM sales_teams st
			JOIN sales_pipeline sp ON sp.sales_agent = st.sales_agent 
			WHERE deal_stage = 'Won'
			GROUP BY 1, 2),	
	t2 AS (
			SELECT DISTINCT
				st.regional_office,
				sp.product,
				p.sales_price
			FROM sales_teams st
			JOIN sales_pipeline sp ON st.sales_agent = sp.sales_agent
			JOIN products p ON p.product = sp.product)	
SELECT
	t1.regional_office,	SUM(t1.total_revenue) total_revenue, 
	SUM(t1.total_revenue - (t1.quantity * t2.sales_price)) AS total_profit  
FROM t1
JOIN t2 ON t1.regional_office = t2.regional_office AND t1.product = t2.product
GROUP BY 1
ORDER BY total_revenue DESC;

-- Which sales agent is most effective at selling a specific product
WITH sub1 AS (
				SELECT 
					sales_agent,
					product,
					COUNT(*) quantity,
					SUM(close_value) revenue
				FROM sales_pipeline
				WHERE deal_stage = 'Won'
				GROUP BY 1,2
	),
	sub2 AS	(
			 	SELECT
					product, Max(revenue) max_revenue 
	  			FROM sub1
				GROUP BY product
	)

SELECT sub1.sales_agent, sub1.product,
	sub1.quantity, sub2.max_revenue
FROM sub1
JOIN sub2
ON sub1.product = sub2.product 
	AND sub1.revenue = sub2.max_revenue;





