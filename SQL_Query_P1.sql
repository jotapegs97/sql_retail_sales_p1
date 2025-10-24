-- SQL Retail Sales Analysis - P1
CREATE DATABASE SQL_Project_P2;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantity INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);


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
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

-- CÓDIGO DO INSTRUTOR SEM 'CUSTOMER_ID', 'AGE', 'PRICE_PER_UNIT'
select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantity is null
	or
	cogs is null
	or
	total_sale is null

-- Data Cleaning
DELETE FROM retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantity is null
	or
	cogs is null
	or
	total_sale is null

-- Data Exploration 

-- How many sales we have?
SELECT COUNT (*) as total_sale from retail_sales

-- How many unique customers we have?
SELECT COUNT (distinct customer_id) as total_customers 
from retail_sales

-- How many unique category we have?
SELECT COUNT (distinct category) as total_customers 
from retail_sales

SELECT distinct category
from retail_sales

-- Data Analysis & Business Key Problems & Answers

-- Solving questions
-- Q.1 Write a SQL Query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL Query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-22
-- Q.3 Write a SQL Query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL Query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL Query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL Query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL Query to calculate the average sale for each month. Find out the best selling month in each year.
-- Q.8 Write a SQL Query to find the top 5 customers based on the highest total sales.
-- Q.9 Write a SQL Query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a Sql Query to create each shift and number of orders (Ex.: Morning <=12, Afternoon Between 12 & 17, Evening >17)

select * from retail_sales

-- Q.1 Write a SQL Query to retrieve all columns for sales made on '2022-11-05'
select
	*
from
	retail_sales
where
	sale_date = '2022-11-05'
	
-- Q.2 Write a SQL Query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-22
select
	*
from
	retail_sales
where 
	category like 'Clothing'
	and
	quantity >= 4
	and
	sale_date between '2022-11-01' and '2022-11-30'
	
-- Resposta: 17 linhas

-- Q.3 Write a SQL Query to calculate the total sales (total_sale) and total orders for each category.
select 
	category,
	sum(total_sale) as Sale_per_Cat,
	count (*) as total_orders
from
	retail_sales
group by
	category

-- Resposta: Eletro = 313810; Clothing = 311070; Beauty = 286840

-- Q.4 Write a SQL Query to find the average age of customers who purchased items from the 'Beauty' category.
select * from retail_sales

select
	round(avg(age), 0) as Avg_age
from
	retail_sales
where
	category like 'Beauty'

-- Resposta: 40 anos

-- Q.5 Write a SQL Query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales

select
	*
from
	retail_sales
where
	total_sale > 1000
order by
	total_sale desc

-- Resposta: 306 transações.

-- Q.6 Write a SQL Query to find the total number of transactions (transaction_id) made by each gender in each category.

select
	gender,
	category,
	count(transactions_id) as total_orders
from
	retail_sales
group by
	gender,
	category
order by 
	3 desc

-- Resposta: Fem/Bea = 330; Fem/Clo = 347; Fem/Eletr = 340
-- Male/Elet = 344; Male/Clo = 354; Male/Bea = 282

-- Q.7 Write a SQL Query to calculate the average sale for each month. Find out the best selling month in each year.


select 
	"Year",
	"Month",
	round(cast(avg(avg_sale) as numeric), 2)
from
(
select
	extract (year from sale_date) as "Year",
	extract (month from sale_date) as "Month",
	avg(total_sale) as avg_sale,
	rank() over(partition by extract (year from sale_date) order by avg(total_sale) desc) as rank
from
	retail_sales
group by
	1, 2
order by
	1, 3 desc
) as t1

where 
	rank = 1
group by
	t1."Year",
	t1."Month"

-- Resposta: 2022-7 = avg sale 541,34 / 2023-2 = avg sale 535.53

-- Q.8 Write a SQL Query to find the top 5 customers based on the highest total sales.
select
	customer_id,
	sum(total_sale) as total_sale
from retail_sales
group by
	customer_id
order by 2 desc
limit 5

-- Q.9 Write a SQL Query to find the number of unique customers who purchased items from each category.
select * from retail_sales

select
	category,
	count (distinct customer_id) as unique_customer
from
	retail_sales
group by 
	1

-- Q.10 Write a Sql Query to create each shift and number of orders (Ex.: Morning <=12, Afternoon Between 12 & 17, Evening >17)


with hourly_sales
as 
(
select
	*,
	case 
		when extract(hour from sale_time) < 12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from
	retail_sales
)
select
	shift,
	count(*) as total_orders
from
	hourly_sales
group by
	shift
order by
	total_orders desc


-- End of projects


