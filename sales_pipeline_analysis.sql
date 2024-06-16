--	Sales Pipeline Analysis

--	What is the total deals?
SELECT 
	COUNT(*) total_deal
FROM sales_pipeline;

--	What is the status of deals in the sales pipeline?
SELECT
	deal_stage,
	COUNT(*) total_deals,
	ROUND(COUNT(*)*100.0 / (SELECT COUNT(*) FROM sales_pipeline),2) AS percentage_of_deal_stage
FROM sales_pipeline
GROUP BY 1;

-- What is the total deals over time?
SELECT 
	COALESCE(TO_CHAR(engage_date, 'Month'),'No date') months,
	COUNT(*) lead_count
FROM sales_pipeline
GROUP BY 1
ORDER BY MAX(engage_date);


-- What is the status of each deal stage over time?
SELECT 
	COALESCE(TO_CHAR(engage_date, 'Month'), 'No month') months,
	COUNT(*) total_deals,
	SUM(CASE WHEN deal_stage = 'Prospecting' THEN 1 ELSE 0 END) AS prospecting_deals,
	SUM(CASE WHEN deal_stage = 'Engaging' THEN 1 ELSE 0 END) AS engaging_deals,
	SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS lost_deals,
	SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS won_deals
FROM sales_pipeline
GROUP BY 1
ORDER BY MAX(engage_date);

--	what is the status of closed deals over time?
SELECT 
	TO_CHAR(close_date, 'Month') months,
	SUM(CASE WHEN deal_stage = 'Lost' THEN 1 ELSE 0 END) AS close_lost,
	SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END) AS close_won
FROM sales_pipeline
WHERE close_date IS NOT NULL
GROUP BY 1
ORDER BY min(close_date);

-- What is the average deal cycle length?
SELECT	
	AVG(close_date - engage_date) AS avg_deal_length
FROM sales_pipeline
WHERE close_date IS NOT NULL AND engage_date IS NOT NULL;

