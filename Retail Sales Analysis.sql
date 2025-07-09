-- Retail Sales Analysis

-- Create Table
drop table if exists Retail_Sales;
create table Retail_Sales
(
	transactions_id	int primary key,
	sale_date date,
	sale_time time,
	customer_id	int,
	gender varchar(15),
	age	int,
	category varchar(15),	
	quantiy	int,
	price_per_unit float,	
	cogs float,
	total_sale float
);

select * from Retail_Sales;
-- Count of Records/Rows
select count(*) from Retail_Sales;

-- Data Cleaning
-- Check the null values in every column
select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null
;

-- Detele the records with null values
delete from Retail_Sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null
;

-- Data Exploration

--How many sales we have?
select count(*) as Total_Sales from Retail_Sales;

--How many customers we have?
select count(distinct customer_id) from retail_sales;

--How many categories and it's sales
select  distinct category from retail_sales;

--Data Analysis
-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05';

--Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
select * from public.retail_sales
where 
	category = 'Clothing' 
	and 
	to_char(sale_date, 'yyyy-mm')='2022-11'
	and
	quantiy >=4
;

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as net_sales, COUNT(*) as total_orders from public.retail_sales
group by 1;

--Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as Avg_age from public.retail_sales
where category = 'Beauty';

--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000
select * from public.retail_sales
where total_sale>1000;

--Q6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
select gender,category, count(*) as total_trans from public.retail_sales
group by category, gender
order by 1
;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

--Q8. Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

-- Q10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift