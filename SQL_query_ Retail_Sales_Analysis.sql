
create table retail_sales (
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(10),
	age	int,
	category varchar(100),
	quantity int,
	price_per_unit float,
	cogs float,
	total_sale float
);
select count(*) from retail_sales

--
select * from retail_sales

order by sale_date
where price_per_unit is null
or
cogs is null
or
total_sale  is null
or
quantiy  is null
or
category  is null
or
age  is null
or
gender  is null
or
customer_id  is null
or
sale_time  is null
or
sale_date  is null
or
transactions_id  is null

delete from retail_sales
where 
	price_per_unit is null
	or
	cogs is null
	or
	total_sale  is null
	or
	quantiy  is null
	or
	category  is null
	or
	age  is null
	or
	gender  is null
	or
	customer_id  is null
	or
	sale_time  is null
	or
	sale_date  is null
	or
	transactions_id  is null

-- Data Exploration

-- how many customers we have 
select count(distinct customer_id) from retail_sales

--All categories
select distinct category from retail_sales

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)




-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

	select * from retail_sales where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

	select *
	from retail_sales
	where category='Clothing'
	and quantiy>=3
	and to_char(sale_date,'yyyy-mm') = '2022-11'
	order by sale_date

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

	select category,
	sum(total_sale) as net_sales,
	count(quantity) as total_qty
	from retail_sales
	group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
	
	select
		round(avg(age),0) as avg_age,
		category
	from retail_sales
	where category='Beauty'
	group by category

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

	select transactions_id
	from retail_sales
	where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

	select 
		category,
		gender,
		count(transactions_id) as counting
	from retail_sales
	group by gender,category
	order by category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

	with sale_detail as 
		(
			select 
			extract(year from sale_date) as years,
			extract(month from sale_date) as months,
			sum(total_sale) as net_sales,
			dense_rank()over(partition by extract(year from sale_date) order by sum(total_sale) desc) as r_n
			from retail_sales
			group by 1,2
		)
	select *
	from sale_detail
	where r_n =1 	
	
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

	with ltv_sales as
	(select 
		customer_id,
		sum(total_sale) as ltv
	from retail_sales
	group by 1)

	select * from ltv_sales order by ltv desc
	limit 5

	-- or 
	
	select 
		customer_id,
		sum(total_sale) as ltv,
		dense_rank()over( order by sum(total_sale) desc) as r_n
	from retail_sales
	group by 1
	limit 5


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


	select category,
	 count(distinct customer_id) as unique_customers
	from retail_sales
	group by 1


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

	select
     case
		when extract(hours from sale_time)<=12 then 'Morning'
		when extract(hours from sale_time) Between 12 and 17 then 'Afternoon'
		when extract(hours from sale_time)>17 then 'Evening'
		end as shifts,
		count(transactions_id) as counter
	from retail_sales 
	group by shifts

	-- or

	with sale_data as
	(
	select
     case
		when extract(hours from sale_time)<=12 then 'Morning'
		when extract(hours from sale_time) Between 12 and 17 then 'Afternoon'
		when extract(hours from sale_time)>17 then 'Evening'
		end as shifts
	from retail_sales 
	)

	select shifts,count(*)
	from sale_data
	group by 1