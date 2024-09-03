
drop table if exists retail_analysis_p1
	
CREATE table retail_analysis_p1
								(
								transactions_id int primary key,
								sale_date date,
								sale_time time,
								customer_id	int,
								gender	varchar(25),
								age	int,
								category varchar(25),
								quantiy int,
								price_per_unit	float,
								cogs	float,
								total_sale float
								)


-- Data Cleaning
	
select * from retail_analysis_p1
where transactions_id is NULL
	or sale_date is null 
	or sale_time is null
	or customer_id	 is null 
	or gender is null
	or age is null
	or category	 is null
	or quantiy	 is null
	or price_per_unit	 is null
	or cogs is null
	or total_sale is null


delete from retail_analysis_p1
where transactions_id is NULL
	or sale_date is null 
	or sale_time is null
	or customer_id	 is null 
	or gender is null
	or age is null
	or category	 is null
	or quantiy	 is null
	or price_per_unit	 is null
	or cogs is null
	or total_sale is null

	-- Data Exploration
	
-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales


-- -- Data Analysis & Business Key Problems & Answers
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * 
from retail_analysis_p1
where sale_date = '2022-11-05'


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

select 
		*
from retail_analysis_p1
where category = 'Clothing'
		and 
		quantiy >=4
		and
		to_char(sale_date,'YYYY-MM')='2022-11'


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
	category,
	sum(total_sale ) as total_sales
from retail_analysis_p1
group by 1



-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
	category,
	round (avg(age),2)as avg_age__customers
	from retail_analysis_p1
	where category = 'Beauty'
	group by 1



-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select *
from retail_analysis_p1
where total_sale >1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
		gender,
		category,
		count(transactions_id) as total_transactions
from retail_analysis_p1
group by 1,2



-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select 
	year,
	month,
	avg_sales 
from 
(
select 
			extract (month from sale_date)as month,
			extract (year from sale_date) as year,
			avg(total_sale)as avg_sales,
			rank()over(partition by extract (year from sale_date) order by avg(total_sale)  desc ) as rn
from retail_analysis_p1
group by 1,2
) as t1
where rn = 1



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
	customer_id,
	sum(total_sale) as  total_sales
from retail_analysis_p1
group by 1
order by 2 desc
limit 5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
		category,
		count(distinct customer_id) as unique_customers
from retail_analysis_p1
group by 1


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

	-- USING SUBQUERY
	
	select 
	shift,
	count(*) as total_orders
	from 
(
select *,
case
	when extract(hour from sale_time) <=12 then 'morning'
	when extract(hour from sale_time) between 12 and 17 then 'afternoon'
	else 'evening'
end as shift
from retail_analysis_p1
	) as hourly_shift
group by shift


-- USING CTE(COMMON TABLE EXPRESSION)

with cte
	as(

select *,
case
	when extract(hour from sale_time) <=12 then 'morning'
	when extract(hour from sale_time) between 12 and 17 then 'afternoon'
	else 'evening'
end as shift
from retail_analysis_p1
) 
select 
shift,
	count(*) as total_orders
	from cte
group by shift

-- End of project




