CREATE DATABASE crm;

--creates the Accounts table
CREATE TABLE accounts (
  account varchar PRIMARY KEY,
  sector varchar,
  year_established varchar,
  revenue decimal(10,2),
  employees varchar,
  office_loc varchar,
  subsidiary_of varchar
);
--creates the Products table
CREATE TABLE products (
  product varchar PRIMARY KEY,
  series varchar,
  sales_price Decimal(10,2)
);

--creates the sales_teams table
CREATE TABLE sales_teams (
  sales_agent varchar PRIMARY KEY,
  manager varchar,
  regional_office varchar
);

--Creates the sales_pipeline table
CREATE TABLE sales_pipeline (
  opportunity_id varchar PRIMARY KEY,
  sales_agent varchar,
  product varchar,
  account varchar,
  deal_stage varchar,
  engage_date date,
  close_date date,
  close_value decimal(10,2)
);



--count the total rows for each table
SELECT 'account' AS table_name, COUNT(*) AS total_rows 
FROM accounts
UNION
SELECT 'products', COUNT(*)
FROM products
UNION
SELECT 'sales_pipeline', COUNT(*) 
FROM sales_pipeline 
UNION
SELECT 'sales_teams', COUNT(*)  
FROM sales_teams;

--checking for spelling errors in 
SELECT DISTINCT product
FROM sales_pipeline;

--update column were spelling error was detected
UPDATE sales_pipeline
SET product = 'GTX Pro'
WHERE product = 'GTXPro';



--Establish relationship between Entities and attributes
ALTER TABLE sales_pipeline ADD FOREIGN KEY (account) REFERENCES accounts (account);

ALTER TABLE sales_pipeline ADD FOREIGN KEY (sales_agent) REFERENCES sales_teams (sales_agent);

ALTER TABLE sales_pipeline ADD FOREIGN KEY (product) REFERENCES products (product);
