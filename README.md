# Retail Sales SQL Analysis

## Project Overview

This project analyzes retail sales data using **SQL** to uncover business insights related to customer behavior, product categories, transaction trends, sales performance, and purchase timing.

The goal of this project is to demonstrate practical **data analysis skills using SQL** by solving real-world business questions from a retail dataset.

---

## Objectives

* Explore and clean retail sales data
* Perform business-focused SQL analysis
* Identify customer and category-level insights
* Analyze sales trends over time
* Generate actionable business findings

---

## Dataset Information

The dataset contains transactional retail sales records with the following fields:

* **transactions_id** – Unique transaction ID
* **sale_date** – Date of sale
* **sale_time** – Time of sale
* **customer_id** – Unique customer ID
* **gender** – Customer gender
* **age** – Customer age
* **category** – Product category
* **quantity** – Quantity purchased
* **price_per_unit** – Price per unit
* **cogs** – Cost of goods sold
* **total_sale** – Total sales amount

---

## Tools & Technologies

* **PostgreSQL**
* **SQL**
* **GitHub**

---

## Database Schema

```sql
create table retail_sales (
    transactions_id int primary key,
    sale_date date,
    sale_time time,
    customer_id int,
    gender varchar(10),
    age int,
    category varchar(100),
    quantity int,
    price_per_unit float,
    cogs float,
    total_sale float
);
```

---

## Data Cleaning

The following data cleaning steps were performed:

* Checked total number of records
* Inspected null values in important columns
* Removed records with missing values
* Verified category and customer-level consistency

### Null Value Check

```sql
select *
from retail_sales
where price_per_unit is null
or cogs is null
or total_sale is null
or quantity is null
or category is null
or age is null
or gender is null
or customer_id is null
or sale_time is null
or sale_date is null
or transactions_id is null;
```

### Remove Null Records

```sql
delete from retail_sales
where price_per_unit is null
or cogs is null
or total_sale is null
or quantity is null
or category is null
or age is null
or gender is null
or customer_id is null
or sale_time is null
or sale_date is null
or transactions_id is null;
```

---

## Data Exploration

### Total Number of Records

```sql
select count(*) from retail_sales;
```

### Total Unique Customers

```sql
select count(distinct customer_id) from retail_sales;
```

### Available Product Categories

```sql
select distinct category from retail_sales;
```

---

## Business Questions Solved

### 1. Retrieve all sales made on `2022-11-05`

```sql
select *
from retail_sales
where sale_date = '2022-11-05';
```

### 2. Retrieve all Clothing transactions where quantity sold is more than 3 in November 2022

```sql
select *
from retail_sales
where category = 'Clothing'
and quantity >= 3
and to_char(sale_date, 'yyyy-mm') = '2022-11'
order by sale_date;
```

### 3. Calculate total sales for each category

```sql
select
    category,
    sum(total_sale) as net_sales,
    count(quantity) as total_qty
from retail_sales
group by category;
```

### 4. Find average age of customers who purchased from the Beauty category

```sql
select
    round(avg(age), 0) as avg_age,
    category
from retail_sales
where category = 'Beauty'
group by category;
```

### 5. Find all transactions where total sales are greater than 1000

```sql
select
    transactions_id
from retail_sales
where total_sale > 1000;
```

### 6. Find total number of transactions made by each gender in each category

```sql
select
    category,
    gender,
    count(transactions_id) as total_transactions
from retail_sales
group by gender, category
order by category;
```

### 7. Find the best-selling month in each year

```sql
with sale_detail as (
    select
        extract(year from sale_date) as years,
        extract(month from sale_date) as months,
        sum(total_sale) as net_sales,
        dense_rank() over (
            partition by extract(year from sale_date)
            order by sum(total_sale) desc
        ) as r_n
    from retail_sales
    group by 1, 2
)
select *
from sale_detail
where r_n = 1;
```

### 8. Find the top 5 customers based on highest total sales

```sql
select
    customer_id,
    sum(total_sale) as ltv
from retail_sales
group by customer_id
order by ltv desc
limit 5;
```

### 9. Find the number of unique customers in each category

```sql
select
    category,
    count(distinct customer_id) as unique_customers
from retail_sales
group by category;
```

### 10. Create sales shifts and count the number of orders in each shift

```sql
select
    case
        when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
    end as shifts,
    count(transactions_id) as total_orders
from retail_sales
group by shifts;
```

---

## Key Insights

Some meaningful insights that can be derived from this project include:

* Identification of top-performing product categories
* Understanding of customer purchase behavior
* Recognition of high-value customers
* Discovery of monthly and yearly sales trends
* Analysis of sales distribution across different times of the day

---

## Business Impact

This analysis can help retail businesses:

* Improve category-level sales strategy
* Target valuable customers more effectively
* Optimize product stocking decisions
* Understand customer demographics better
* Improve sales performance through time-based planning

---

## Project Structure

```bash
Retail-Sales-SQL-Analysis/
│
├── retail_sales_sql_project.sql
├── README.md
└── dataset.csv
```

---

## Learning Outcomes

Through this project, I practiced:

* SQL data cleaning
* Aggregations and grouping
* Filtering and sorting
* Common Table Expressions (CTEs)
* Window functions
* Business problem solving using SQL

---

## Future Improvements

Possible enhancements for this project:

* Build a dashboard using **Power BI** or **Tableau**
* Perform customer segmentation
* Add cohort analysis
* Analyze repeat purchase behavior
* Create KPI reports for decision-making

---

## Author

**Prateek Yadav**

If you found this project useful, feel free to star the repository.
