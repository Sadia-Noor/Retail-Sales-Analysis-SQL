-- ========================================================
-- SQL Retail Sales Analysis Project  
-- ========================================================

-- ========================================================
-- 1. Creating the 'retail_sales' Table  
-- ========================================================
CREATE TABLE retail_sales (  
    transaction_id INT PRIMARY KEY,  -- Unique ID for each transaction  
    sale_date DATE,                  -- Date of the sale  
    sale_time TIME,                  -- Time of the sale  
    customer_id INT,                  -- ID of the customer  
    gender VARCHAR(15),               -- Gender of the customer  
    age INT,                          -- Age of the customer  
    category VARCHAR(15),             -- Product category  
    quantity INT,                     -- Number of items sold  
    price_per_unit FLOAT,             -- Price of a single unit  
    cogs FLOAT,                       -- Cost of goods sold (COGS)  
    total_sale FLOAT                  -- Total amount of sale (price * quantity)  
);  

-- ========================================================
-- 2. Initial Data Inspection  
-- ========================================================

-- Checking the first 10 rows of the table  
SELECT * FROM retail_sales  
LIMIT 10;  

-- Counting the total number of transactions  
SELECT COUNT(*) AS total_transactions FROM retail_sales;  

-- ========================================================
-- 3. Handling Missing Data  
-- ========================================================

-- Checking for NULL values in each column  
SELECT  
    COUNT(*) AS total_rows,  
    COUNT(transaction_id) AS transaction_id_not_null,  
    COUNT(sale_date) AS sale_date_not_null,  
    COUNT(sale_time) AS sale_time_not_null,  
    COUNT(customer_id) AS customer_id_not_null,  
    COUNT(gender) AS gender_not_null,  
    COUNT(age) AS age_not_null,  
    COUNT(category) AS category_not_null,  
    COUNT(quantity) AS quantity_not_null,  
    COUNT(price_per_unit) AS price_per_unit_not_null,  
    COUNT(cogs) AS cogs_not_null,  
    COUNT(total_sale) AS total_sale_not_null  
FROM retail_sales;  

-- Finding rows that contain at least one NULL value  
SELECT * FROM retail_sales  
WHERE transaction_id IS NULL  
   OR sale_date IS NULL  
   OR sale_time IS NULL  
   OR customer_id IS NULL  
   OR gender IS NULL  
   OR age IS NULL  
   OR category IS NULL  
   OR quantity IS NULL  
   OR price_per_unit IS NULL  
   OR cogs IS NULL  
   OR total_sale IS NULL;  

-- Deleting rows where critical columns contain NULL values  
DELETE FROM retail_sales  
WHERE age IS NULL  
   OR quantity IS NULL  
   OR price_per_unit IS NULL  
   OR cogs IS NULL  
   OR total_sale IS NULL;  

-- ========================================================
-- 4. Exploratory Data Analysis (EDA)  
-- ========================================================

-- Retrieve number of unique customers  
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;  

-- Checking unique values in categorical columns  
SELECT DISTINCT gender FROM retail_sales;  
SELECT DISTINCT category FROM retail_sales;  

-- Checking age distribution of customers  
SELECT age, COUNT(*) AS count_per_age  
FROM retail_sales  
GROUP BY age  
ORDER BY age;  

-- Checking sales by gender  
SELECT gender, COUNT(*) AS total_sales, SUM(total_sale) AS total_revenue  
FROM retail_sales  
GROUP BY gender  
ORDER BY total_revenue DESC;  

-- Checking sales trends over time (monthly)  
SELECT  
    EXTRACT(YEAR FROM sale_date) AS year,  
    EXTRACT(MONTH FROM sale_Date) AS month,  
    COUNT(*) AS total_transactions,  
    SUM(total_sale) AS total_revenue  
FROM retail_sales  
GROUP BY year, month  
ORDER BY year, month;  

-- Finding the top 5 customers who spent the most  
SELECT customer_id, SUM(total_sale) AS total_spent  
FROM retail_sales  
GROUP BY customer_id  
ORDER BY total_spent DESC  
LIMIT 5;  

-- Identifying the most frequently purchased quantity  
SELECT quantity, COUNT(*) AS frequency  
FROM retail_sales  
GROUP BY quantity  
ORDER BY frequency DESC  
LIMIT 5;  

-- Calculating the average price per unit across all products  
SELECT AVG(price_per_unit) AS avg_price_per_unit FROM retail_sales;  

-- Finding the highest and lowest sale transactions  
SELECT * FROM retail_sales  
ORDER BY total_sale DESC  
LIMIT 1;  -- Highest Sale  

SELECT * FROM retail_sales  
ORDER BY total_sale ASC  
LIMIT 1;  -- Lowest Sale  

-- Identifying peak sales hours  
SELECT sale_time, COUNT(*) AS total_transactions  
FROM retail_sales  
GROUP BY sale_time  
ORDER BY total_transactions DESC  
LIMIT 5;  

-- Checking Cost of Goods Sold (COGS) impact on total sales  
SELECT  
    category,  
    SUM(cogs) AS total_cogs,  
    SUM(total_sale) AS total_revenue,  
    SUM(total_sale) - SUM(cogs) AS profit  
FROM retail_sales  
GROUP BY category  
ORDER BY profit DESC;  

-- ========================================================
-- 5. Business Insights and Key Queries  
-- ========================================================

-- Q1: Retrieve all columns for sales made on '2022-11-05'  
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';  

-- Q2: Retrieve all transactions where the category is 'Clothing'  
-- and the quantity sold is more than 10 in the month of Nov-2022  
SELECT * FROM retail_sales  
WHERE category = 'Clothing'  
  AND quantity > 10  
  AND EXTRACT(MONTH FROM sale_date) = 11  
  AND EXTRACT(YEAR FROM sale_date) = 2022;  

-- Q3: Calculate the total sales (total_sale) for each category  
SELECT category, SUM(total_sale) AS total_sales  
FROM retail_sales  
GROUP BY category  
ORDER BY total_sales DESC;  

-- Q4: Find the average age of customers who purchased items from the 'Beauty' category  
SELECT AVG(age) AS avg_age  
FROM retail_sales  
WHERE category = 'Beauty';  

-- Q5: Find all transactions where the total_sale is greater than 1000  
SELECT * FROM retail_sales WHERE total_sale > 1000;  

-- Q6: Find the total number of transactions made by each gender in each category  
SELECT gender, category, COUNT(transaction_id) AS total_transactions  
FROM retail_sales  
GROUP BY gender, category  
ORDER BY total_transactions DESC;  

-- Q7: Calculate the average sale for each month and find the best-selling month in each year  
SELECT  
    EXTRACT(YEAR FROM sale_date) AS year,  
    EXTRACT(MONTH FROM sale_date) AS month,  
    AVG(total_sale) AS avg_monthly_sale,  
    SUM(total_sale) AS total_monthly_sales  
FROM retail_sales  
GROUP BY year, month  
ORDER BY total_monthly_sales DESC;  

-- Q8: Find the top 5 customers based on the highest total sales  
SELECT customer_id, SUM(total_sale) AS total_spent  
FROM retail_sales  
GROUP BY customer_id  
ORDER BY total_spent DESC  
LIMIT 5;  

-- Q9: Find the number of unique customers who purchased items from each category  
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers  
FROM retail_sales  
GROUP BY category  
ORDER BY unique_customers DESC;  

-- Q10: Create each shift and find the number of orders in each shift  
-- Morning (<=12), Afternoon (Between 12 & 17), Evening (>17)  
SELECT  
    CASE  
        WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'  
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'  
        ELSE 'Evening'  
    END AS shift,  
    COUNT(transaction_id) AS total_orders  
FROM retail_sales  
GROUP BY shift  
ORDER BY total_orders DESC;  
