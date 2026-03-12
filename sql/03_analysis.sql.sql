-- =====================================================
-- DATABASE SELECTION
-- =====================================================

USE retail_project;
-- =====================================================
-- Retail Sales Performance Analysis
-- =====================================================

-- Dataset Size: 2000 Transactions
-- Objective: Analyze retail sales performance and customer purchasing behavior


-- =====================================================
-- SECTION 1: Executive Overview
-- =====================================================


-- =====================================================
-- Business Question 1
-- What is the total number of transactions and total revenue generated?
-- =====================================================

SELECT
COUNT(*) AS total_transactions,
SUM(TotalPrice) AS total_revenue_generated
FROM retail_transactions;

-- Insight:
-- The dataset includes 2000 transactions generating total revenue of 2,207,643.55,
-- indicating the overall business scale for the analyzed time period.


-- =====================================================
-- Business Question 2
-- What is the average transaction value, and what does it indicate about customer spending behavior?
-- =====================================================

SELECT
AVG(TotalPrice) AS average_transaction_value
FROM retail_transactions;

-- Insight:
-- The average transaction value is 1103.82 per purchase, indicating the typical amount
-- customers spend in a single order and highlighting overall customer purchasing behavior.


-- =====================================================
-- Business Question 3
-- What is the revenue distribution range (minimum vs maximum transaction value)?
-- =====================================================

SELECT 
MIN(TotalPrice) AS min_transaction_value,
MAX(TotalPrice) AS max_transaction_value
FROM retail_transactions;

-- Insight:
-- The minimum transaction value is 5.74 while the maximum transaction value is 3997.40,
-- showing the range of spending between the smallest and highest value purchases.


-- =====================================================
-- Business Question 4
-- What is the total quantity of products sold across all stores?
-- =====================================================

SELECT 
SUM(Quantity) AS total_units_sold
FROM retail_transactions;

-- Insight:
-- A total of 11057 units were sold across all transactions in the dataset,
-- indicating the overall product demand and sales volume during the period.


-- =====================================================
-- Business Question 5
-- What is the date range covered in the dataset?
-- =====================================================

SELECT 
MIN(Date) AS start_date,
MAX(Date) AS end_date
FROM retail_transactions;

-- Insight:
-- The dataset includes transactions from 2023-01-01 to 2025-06-30,
-- defining the time period covered in the sales analysis.


-- =====================================================
-- SECTION 2: Store Performance Analysis
-- =====================================================

-- =====================================================
-- Business Question 6
-- Rank all stores by total revenue generated
-- =====================================================

SELECT 
StoreID,
SUM(TotalPrice) AS store_total_revenue,
RANK() OVER (ORDER BY SUM(TotalPrice) DESC) AS revenue_rank
FROM retail_transactions
GROUP BY StoreID;

-- Insight:
-- Stores are ranked based on total revenue generated during the analysis period.
-- Higher-ranked stores contribute more to overall sales and indicate stronger store performance.

-- =====================================================
-- Business Question 7
-- Which store has the highest average transaction value?
-- =====================================================

SELECT 
StoreID,
AVG(TotalPrice) AS Highest_Store_Avg_Transaction
FROM retail_transactions
GROUP BY StoreID
ORDER BY Highest_Store_Avg_Transaction DESC
LIMIT 1;

-- Insight:
-- Store S8 has the highest average transaction value of 1174.45.
-- This indicates stronger per-transaction revenue compared to other stores.

-- =====================================================
-- Business Question 8
-- What percentage of total revenue does each store contribute?
-- =====================================================

SELECT 
StoreID,
SUM(TotalPrice) AS store_total_revenue,
(SUM(TotalPrice) / (SELECT SUM(TotalPrice) FROM retail_transactions)) * 100 AS revenue_percentage
FROM retail_transactions
GROUP BY StoreID
ORDER BY StoreID;

-- Insight:
-- Store S8 contributes the highest revenue share at 11.12%, while Store S2 contributes the lowest at 8.84%.
-- Revenue contribution across stores is relatively balanced, with most stores contributing around 9–11% of total sales.

-- =====================================================
-- Business Question 9
-- Which store records the highest number of transactions?
-- =====================================================

SELECT 
StoreID,
COUNT(TransactionID) AS number_of_transactions
FROM retail_transactions
GROUP BY StoreID
ORDER BY number_of_transactions DESC
LIMIT 1;

-- Insight:
-- Store S8 records the highest number of transactions with 209 purchases.
-- This indicates the store with the highest customer activity in the dataset.

-- =====================================================
-- Business Question 10
-- Compare revenue performance across stores over time (monthly trend)
-- =====================================================

SELECT 
StoreID,
YEAR(Date) AS sales_year,
MONTH(Date) AS sales_month,
SUM(TotalPrice) AS monthly_revenue
FROM retail_transactions
GROUP BY StoreID, YEAR(Date), MONTH(Date);

-- Insight:
-- Monthly revenue trends show how each store performs over different months.
-- This helps identify seasonal patterns and revenue fluctuations across stores.

-- =====================================================
-- Business Question 11
-- Identify the most consistent performing store (least revenue fluctuation)
-- =====================================================

SELECT
StoreID,
STDDEV(monthly_revenue) AS revenue_fluctuation
FROM (
SELECT 
StoreID,
YEAR(Date),
MONTH(Date),
SUM(TotalPrice) AS monthly_revenue
FROM retail_transactions
GROUP BY StoreID, YEAR(Date), MONTH(Date)
) AS monthly_data
GROUP BY StoreID
ORDER BY revenue_fluctuation ASC
LIMIT 1;

-- Insight:
-- Store S2 shows the lowest revenue fluctuation with a standard deviation of 2787.66.
-- This indicates the most stable and consistent store performance over time.


-- =====================================================
-- SECTION 3: Product Performance Analysis
-- =====================================================

-- =====================================================
-- Business Question 12
-- Identify the top 5 revenue-generating products
-- =====================================================

SELECT 
Product,
SUM(TotalPrice) AS top_revenue_generating_product
FROM retail_transactions
GROUP BY Product
ORDER BY top_revenue_generating_product DESC
LIMIT 5;

-- Insight:
-- The top 5 products generate the highest revenue in the dataset.
-- These products contribute significantly to overall sales performance.

-- =====================================================
-- Business Question 13
-- Identify the top 5 products by quantity sold
-- =====================================================

SELECT 
Product,
SUM(Quantity) AS product_quantity
FROM retail_transactions
GROUP BY Product
ORDER BY product_quantity DESC
LIMIT 5;

-- Insight:
-- The top 5 products by quantity represent the most frequently purchased items.
-- These products reflect strong customer demand and high sales volume.

-- =====================================================
-- Business Question 14
-- What percentage of total revenue comes from the top 5 products?
-- =====================================================

SELECT 
((SUM(Product_Revenue)) / (SELECT SUM(TotalPrice) FROM retail_transactions)) * 100
AS top5_revenue_percentage
FROM (
SELECT 
Product,
SUM(TotalPrice) AS Product_Revenue
FROM retail_transactions
GROUP BY Product
ORDER BY Product_Revenue DESC
LIMIT 5
) AS Top5;

-- Insight:
-- The top 5 products contribute 73.79% of the total revenue.
-- This shows the level of revenue concentration among the best-performing products.
 
-- =====================================================
-- Business Question 15
-- Identify products generating below-average revenue
-- =====================================================

SELECT *
FROM (
SELECT 
Product,
SUM(TotalPrice) AS product_revenue
FROM retail_transactions
GROUP BY Product
) T
WHERE product_revenue < (
SELECT AVG(Product_Revenue)
FROM (
SELECT 
Product,
SUM(TotalPrice) AS Product_Revenue
FROM retail_transactions
GROUP BY Product
) X
);

-- Insight:
-- Products with revenue below the average product revenue are identified.
-- These products may indicate weaker sales performance compared to others.


-- =====================================================
-- Business Question 16
-- Determine whether revenue follows the Pareto principle (top 20% products contribution)
-- =====================================================

SELECT  
ROUND(
((SUM(top_product_rev)) / (SELECT SUM(TotalPrice) FROM retail_transactions)) * 100, 2
) AS top_20percent_products_revenue_percentage
FROM ( 
SELECT 
Product,
SUM(TotalPrice) AS top_product_rev,
RANK() OVER (ORDER BY SUM(TotalPrice) DESC) AS top_product_rev_rank
FROM retail_transactions
GROUP BY Product
) AS product_data
WHERE top_product_rev_rank <= (
SELECT CEIL(COUNT(DISTINCT Product) * 0.20)
FROM retail_transactions
);

-- Insight:
-- The top 20% revenue-generating products contribute 30.54% of total revenue.
-- This helps evaluate whether product sales follow the Pareto (80/20) principle.

-- =====================================================
-- Business Question 17
-- Analyze product revenue trend over time
-- =====================================================

SELECT
Product,
YEAR(Date) AS sales_year,
MONTH(Date) AS sales_month,
ROUND(SUM(TotalPrice), 2) AS product_revenue_trend
FROM retail_transactions
GROUP BY Product, YEAR(Date), MONTH(Date)
ORDER BY Product, YEAR(Date), MONTH(Date) ASC;

-- Insight:
-- Product revenue trends show how sales for each product change across months.
-- This helps identify seasonal demand patterns and consistent high-performing products.

-- =====================================================
-- SECTION 4: Time-Based Sales Analysis
-- =====================================================

-- =====================================================
-- Business Question 18
-- Which day of the week generates the highest revenue?
-- =====================================================

SELECT
DAYNAME(Date) AS weekday,
ROUND(SUM(TotalPrice), 2) AS highest_rev_day
FROM retail_transactions
GROUP BY DAYNAME(Date)
ORDER BY highest_rev_day DESC
LIMIT 1;

-- Insight:
-- Tuesday generates the highest revenue with total sales of 358667.3.
-- This indicates the most profitable day of the week for the business.

-- =====================================================
-- Business Question 19
-- Which time of day generates the highest revenue?
-- =====================================================

SELECT
HOUR(Time) AS hour_of_day,
ROUND(SUM(TotalPrice), 2) AS highest_revenue
FROM retail_transactions
GROUP BY HOUR(Time)
ORDER BY highest_revenue DESC
LIMIT 1;

-- Insight:
-- The hour 20 generates the highest revenue of 207202.89.
-- This represents the most profitable time of day for sales activity.

-- =====================================================
-- Business Question 20
-- Identify the peak sales hour
-- =====================================================

SELECT 
HOUR(Time) AS hour_of_day,
COUNT(TransactionID) AS total_transactions
FROM retail_transactions
GROUP BY HOUR(Time)
ORDER BY total_transactions DESC
LIMIT 1;

-- Insight:
-- The peak sales hour is 20 with 183 transactions recorded.
-- This indicates the time period with the highest customer activity.


-- =====================================================
-- Business Question 21
-- Compare weekday vs weekend revenue
-- =====================================================

SELECT
CASE 
WHEN DAYNAME(Date) IN ('Saturday', 'Sunday') THEN 'Weekend'
ELSE 'Weekday'
END AS day_type,
SUM(TotalPrice) AS total_revenue
FROM retail_transactions
GROUP BY day_type
ORDER BY total_revenue DESC;

-- Insight:
-- Weekday generates higher revenue compared to Weekend.
-- This comparison highlights customer purchasing patterns across weekdays and weekends.



-- =====================================================
-- Business Question 22
-- Analyze daily revenue trend over time
-- =====================================================

SELECT 
Date,
ROUND(SUM(TotalPrice), 2) AS daily_revenue
FROM retail_transactions
GROUP BY Date
ORDER BY Date ASC;

-- Insight:
-- Daily revenue trends show how sales fluctuate over different days.
-- This helps identify growth patterns and potential seasonal demand changes.

-- =====================================================
-- Business Question 23
-- Calculate day-over-day revenue growth
-- =====================================================

SELECT
Date,
daily_rev,
LAG(daily_rev) OVER (ORDER BY Date) AS previous_rev,
ROUND(daily_rev - LAG(daily_rev) OVER (ORDER BY Date), 2) AS daily_growth_amount,
ROUND((daily_rev - LAG(daily_rev) OVER (ORDER BY Date)) / 
LAG(daily_rev) OVER (ORDER BY Date) * 100, 2) AS daily_growth_percent
FROM (
SELECT
Date,
ROUND(SUM(TotalPrice), 2) AS daily_rev
FROM retail_transactions
GROUP BY Date
ORDER BY Date
) AS daily_rev_data;

-- Insight:
-- Day-over-day revenue growth measures the change in sales compared to the previous day.
-- Positive growth indicates increasing sales momentum, while negative growth shows decline.

-- =====================================================
-- SECTION 5: Payment & Workforce Analysis
-- =====================================================

-- =====================================================
-- Business Question 24
-- Which payment method contributes the highest revenue?
-- =====================================================

SELECT 
PaymentType,
SUM(TotalPrice) AS rev_per_payment_method
FROM retail_transactions
GROUP BY PaymentType
ORDER BY rev_per_payment_method DESC
LIMIT 1;

-- Insight:
-- The payment method Debit Card generates the highest revenue of 498721.24.
-- This indicates the most preferred payment option among customers.


-- =====================================================
-- Business Question 25
-- What is the percentage revenue distribution by payment type?
-- =====================================================

SELECT 
PaymentType,
ROUND(SUM(TotalPrice) / (SELECT SUM(TotalPrice) FROM retail_transactions) * 100, 2) AS percentage_share
FROM retail_transactions
GROUP BY PaymentType
ORDER BY percentage_share DESC;

-- Insight:
-- Debit Card contributes the highest revenue share at 22.59%, while Gift Card contributes the lowest at 17.32%.
-- Revenue distribution across payment methods is fairly balanced, with each method contributing between 17% and 23% of total sales.

-- =====================================================
-- Business Question 26
-- Rank cashiers by total revenue handled
-- =====================================================

SELECT  
Cashier,
ROUND(SUM(TotalPrice), 2) AS rev_per_cashier
FROM retail_transactions
GROUP BY Cashier
ORDER BY rev_per_cashier DESC;

-- Insight:
-- Cashiers are ranked based on the total revenue they processed.
-- Higher values indicate greater transaction handling responsibility.

-- =====================================================
-- Business Question 27
-- Identify top 3 cashiers within each store
-- =====================================================

SELECT 
*
FROM (
SELECT
StoreID,
Cashier,
ROUND(SUM(TotalPrice), 2) AS rev_per_cashier,
RANK() OVER (PARTITION BY StoreID ORDER BY SUM(TotalPrice) DESC) AS cashier_rank
FROM retail_transactions
GROUP BY StoreID, Cashier
) AS ranked_cashier
WHERE cashier_rank <= 3;

-- Insight:
-- The top three cashiers in each store are identified based on revenue handled.
-- This highlights the highest-performing staff members across stores.


-- =====================================================
-- SECTION 6: Advanced Analytical Insights
-- =====================================================

-- =====================================================
-- Business Question 28
-- Calculate running total revenue over time
-- =====================================================

SELECT
Date,
ROUND(daily_revenue, 2) AS daily_rev,
ROUND(SUM(daily_revenue) OVER (ORDER BY Date), 2) AS cumulative_rev
FROM (
SELECT
Date,
SUM(TotalPrice) AS daily_revenue
FROM retail_transactions
GROUP BY Date
ORDER BY Date
) AS daily_sales
ORDER BY Date;

-- Insight:
-- The running total shows how revenue accumulates over time.
-- This helps track overall sales growth and identify periods of rapid revenue increase.

-- =====================================================
-- Business Question 29
-- Identify top 20% highest revenue transactions
-- =====================================================

SELECT 
COUNT(TransactionID) AS trans_count,
ROUND(SUM(rev), 2) AS trans_rev_amt,
ROUND((SUM(rev) / (SELECT SUM(TotalPrice) FROM retail_transactions)) * 100, 2) AS trans_rev_percent
FROM (
SELECT
TransactionID,
SUM(TotalPrice) AS rev,
RANK() OVER (ORDER BY SUM(TotalPrice) DESC) AS tran_rev_rank
FROM retail_transactions
GROUP BY TransactionID
) AS trans_data
WHERE tran_rev_rank <= (
SELECT CEIL(COUNT(DISTINCT TransactionID) * 0.20)
FROM retail_transactions
);

-- Insight:
-- The top 20% highest-value transactions generate 47.33% of the total revenue.
-- This highlights the concentration of revenue among high-value purchases.


-- =====================================================
-- Business Question 30
-- Detect unusually high-value transactions compared to average
-- =====================================================

SELECT 
*
FROM (
SELECT
TransactionID,
SUM(TotalPrice) AS rev
FROM retail_transactions
GROUP BY TransactionID
) AS rev_data
WHERE rev > (
SELECT
AVG(rev_avg)
FROM (
SELECT 
TransactionID,
SUM(TotalPrice) AS rev_avg
FROM retail_transactions
GROUP BY TransactionID
) AS avg_data
);

-- Insight:
-- Transactions with revenue above the average transaction value are identified.
-- These represent unusually high-value purchases compared to typical transactions.


-- =====================================================
-- KEY BUSINESS INSIGHTS
-- =====================================================
-- 1. The dataset contains 2000 transactions generating total revenue of 2,207,643.55,
-- indicating the overall scale of sales during the analyzed period.

-- 2. The average transaction value is 1103.82, representing the typical customer
-- spending amount per purchase.

-- 3. Transaction values range from 5.74 to 3997.40, showing significant variation
-- in customer purchase sizes.

-- 4. Store performance analysis shows that revenue contribution across stores is
-- relatively balanced, with most stores contributing around 9–11% of total revenue.

-- 5. Product analysis reveals that a small number of top-performing products
-- generate a significant share of total sales.

-- 6. Time-based analysis identifies specific hours and days that produce the
-- highest revenue and transaction activity.

-- 7. Payment analysis indicates that Debit Card is the most commonly used
-- payment method, contributing the highest share of revenue.

-- 8. Cashier performance analysis highlights employees handling the highest
-- transaction revenue within each store.

-- 9. Revenue concentration analysis confirms that a relatively small portion of
-- products and transactions contribute a large share of total revenue.

-- 10. Overall sales performance appears stable across stores, with some stores
-- showing more consistent revenue patterns than others.


-- =====================================================
-- PROJECT CONCLUSION
-- =====================================================
-- This SQL project analyzed retail sales performance using multiple analytical
-- dimensions including store performance, product contribution, time-based sales
-- patterns, payment behavior, and workforce performance.

-- The analysis demonstrates how SQL can be used to extract meaningful business
-- insights from transactional data and support data-driven decision making.


-- =====================================================
-- SQL SKILLS DEMONSTRATED
-- =====================================================
-- Aggregations (SUM, AVG, COUNT)
-- Grouping and filtering (GROUP BY, HAVING)
-- Window functions (RANK, LAG, running totals)
-- Revenue contribution calculations
-- Time-based analysis (YEAR, MONTH, DAYNAME, HOUR)
-- Subqueries and nested queries
-- Business KPI calculations