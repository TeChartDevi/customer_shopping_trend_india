
-- Data Preview
select * from cust_shop_trend_ind limit 20;
 
------------- Revenue and Sales Analysis -------------

-- Monthly revenue trend

select
	month,
	Round(
		Sum(
	(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge), 2
	) as monthly_revenue
from cust_shop_trend_ind
group by month
order by month desc;

-- Yearly Revenue

select
	Year,
	ROUND(
		Sum(
			(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge), 2
		) as yearly_revenue
from cust_shop_trend_ind
group by Year
order by Year desc;

-- Highest revenue generating month

select
	Year,
	Month,
	ROUND(
		Sum(
			(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge),2
	) as Monthly_revenue
from cust_shop_trend_ind
group by Year, Month
order by Monthly_revenue desc
Limit 1;
;

-- Average order value

SELECT
    ROUND(
        SUM(
			(purchase_amount * quantity) * (1 - discount / 100.0) + shipping_charge)
        / COUNT(DISTINCT transaction_id),
		2
    ) AS avg_order_value
FROM cust_shop_trend_ind;

-- Total revenue by category

Select
	category,
	Round(
		Sum(
			(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge), 2 
	) AS total_revenue
From cust_shop_trend_ind
group by category
order  by category desc;

-- Revenue by brand

Select
	brand,
	round(
		Sum( 
		(purchase_amount * quantity) * (1 - discount/100.0) + shipping_charge), 2
	) As Revenue
from cust_shop_trend_ind
group by brand
order by brand desc;

-- Revenue by region

Select
	region,
	round(
		Sum( 
		(purchase_amount * quantity) * (1 - discount/100.0) + shipping_charge), 2
	) As Revenue
from cust_shop_trend_ind
group by region
order by region desc;

-- Revenue by city
Select
	cities,
	round(
		Sum( 
		(purchase_amount * quantity) * (1 - discount/100.0) + shipping_charge), 2
	) As Revenue
from cust_shop_trend_ind
group by cities
order by cities desc;

-- Percentage of revenue comes from online vs. offline sales?
With total_revenue as(
	select
		Sum(
			(purchase_amount * quantity) * (1 - discount/ 100.0) + shipping_charge
			) AS total
	from cust_shop_trend_ind
)
select
	c.online_offline,
	round(
		Sum(
			(purchase_amount * quantity) * (1 - discount/ 100.0) + shipping_charge
		), 2
	) AS revenue,
	round(
		100 * SUM(
			(purchase_amount * quantity) * (1 - discount/ 100.0) + shipping_charge			
		) / Max (t.total), 2
	) as revenue_precentage	
from cust_shop_trend_ind c 
cross join total_revenue t
group by c.online_offline
order by revenue desc;

-- or

SELECT
    online_offline,
    ROUND(
        SUM((purchase_amount * quantity) * (1 - discount / 100.0) + shipping_charge),
        2
    ) AS revenue,
    ROUND(
        100 * SUM((purchase_amount * quantity) * (1 - discount / 100.0) + shipping_charge)
        / SUM(SUM((purchase_amount * quantity) * (1 - discount / 100.0) + shipping_charge)) OVER (),
        2
    ) AS revenue_percentage
FROM cust_shop_trend_ind
GROUP BY online_offline
ORDER BY revenue DESC;

-- Most revenue contributing payment methods

Select
	payment_method,
	round(
		Sum( 
		(purchase_amount * quantity) * (1 - discount/100.0) + shipping_charge), 2
	) As Revenue
from cust_shop_trend_ind
group by payment_method
order by payment_method desc;


-- Total Revenue Over The Time
with sales as(
	select
		year,
		month,
		return_status,
		(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge as revenue
	from cust_shop_trend_ind
),
revenue_summary AS(
	Select
		year,
		month,
		round(Sum(case when return_status = 'Returned' then revenue else 0 end)::numeric, 2) as returned_revenue,
		round(Sum(case when return_status = 'Not Returned' then revenue else 0 end)::numeric, 2) as delivered_revenue
	From sales
	group by Year, Month
)
Select
	*,
	Round(delivered_revenue - returned_revenue, 2) as net_revenue,
	round(
		100 * delivered_revenue / NULLIF (delivered_revenue + returned_revenue, 0), 2) as delivered_prct,
	round(
		100 * returned_revenue / NULLIF (delivered_revenue + returned_revenue,0), 2) as returned_prct
from revenue_summary
order by Year, Month;


------------- Customer Analysis -------------

-- Data Preview
select * from cust_shop_trend_ind limit 20;

-- Number of Unique customers
select 
	count (distinct customer_id) as No_of_unique_customers
from  cust_shop_trend_ind;

-- Most spending customers
select
	customer_id,
	round(
		sum(
		(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
		), 2
	) as total_spending
from cust_shop_trend_ind
group by customer_id
limit 1;

-- Most spending age group

select
	age_group,
	round(
		sum(
		(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
		), 2
	) as total_spending
from cust_shop_trend_ind
group by age_group
order by total_spending desc
limit 1;


-- Which gender spends more?

select
	gender,
	round(
		sum(
		(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
		), 2
	)as most_spending_age_group
from cust_shop_trend_ind
group by 1
limit 1;

-- Which customers make the most purchases?
select
	gender,
	age_group,
	round(
		sum(
		(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
		), 2
	) as total_amt
from cust_shop_trend_ind
group by 1, 2
order by total_amt DESC
limit 5;

-- Subscription status affect spending

SELECT
    subscription_status,

    COUNT(customer_id) AS total_customers,

    ROUND(
        SUM((purchase_amount * quantity) * (1 - discount / 100.0) + shipping_charge),
        2
    ) AS total_revenue,

    ROUND(
	    SUM((purchase_amount * quantity) * (1 - discount / 100.0) + shipping_charge)
	    / COUNT(*),
	    2
	) AS avg_spending_per_purchase

FROM cust_shop_trend_ind

GROUP BY subscription_status;

--
select
	Year,
	subscription_status,
	
	round(
		sum(
		(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
		), 2
	)as total_revenue,

	round(
		AVG(
		(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
		), 2
	)as Avg_order_value,

	Count(*) as total_orders
		
from cust_shop_trend_ind
group by Year, subscription_status
order by Year, subscription_status Desc;

-- Which purchase frequency group spends the most?
select
	frequency_of_purchases,
	round(
		sum(
		(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
		), 2
	)as total_revenue
from cust_shop_trend_ind
group by frequency_of_purchases
order by total_revenue desc
limit 1;

-- Highest average order value by age group
select
	age_group,
	round(
		SUM(
			(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge)
			/ count(distinct transaction_id),
			2
		)as avg_order_value
from cust_shop_trend_ind
group by age_group
order by avg_order_value desc
limit 1;

------------- Product Analysis -------------

-- Data Preview
select * from cust_shop_trend_ind limit 50;

-- Which categories generate the highest revenue?

-- Which products are purchased most often?

-- Which brands sell the most?

-- Which colors are most popular?

-- Which sizes are sold the most?

-- What is the average quantity purchased per category?

-- Which products have the highest return rate?


------------- Returns Analysis ------------- 

-- What is the overall return rate?

-- Which category has the highest return rate?

-- Which brand has the highest returns?

-- Which city has the highest returns?

-- Do online orders have higher return rates than offline orders?

-- Does delivery speed affect returns?

-- Do discounts increase return rates?

------------- Discount Analysis ------------- 

-- Which discount ranges generate the most revenue?

-- Do higher discounts increase sales quantity?

-- Which brands offer the highest average discount?

-- Which categories have the highest discounts?

-- Does discount affect customer ratings?


-------------  Delivery & Shipping Analysis ------------- 

-- What is the average delivery time?

-- Which delivery speed is most common?

-- Which region has the fastest delivery?

-- Does faster delivery improve review ratings?

-- Does delivery time affect return rate?

-- What is the average shipping charge by region?

------------- Customer Satisfaction ------------- 

-- What is the average review rating?

-- Which categories have the highest ratings?

-- Which brands receive the best ratings?

-- Does subscription status improve ratings?

-- Do returned items receive lower ratings?

------------- Geographic Analysis ------------- 

-- Which city generates the highest revenue?

-- Which region has the most customers?

-- Which region has the highest average order value?

-- Which cities have the highest return rate?

-- Which regions prefer online shopping?

-------------  Online vs Offline ------------- 

-- Which channel generates more revenue?

-- Which channel has higher average order value?

-- Which online store has the highest sales?

-- Which channel has the higher return rate?

-- Which payment methods are most popular online?

------------- Time-Series Analysis ------------- 

-- Monthly sales trend

-- Monthly return trend

-- Revenue by weekday

-- Best performing month

-- Best performing weekday

-- Festival vs. non-festival sales

-- Seasonal sales trends


------------- Payment Analysis ------------- 

-- Most used payment method

-- Revenue by payment method

-- Average order value by payment method

-- Return rate by payment method


--------- Advanced SQL Queries ---------

-- Rank cities by revenue.
-- Top 5 brands in each category.
-- Running monthly revenue.
-- Month-over-month revenue growth.
-- Cumulative revenue over time.
-- Dense rank products by sales.
-- Identify repeat customers.
-- Calculate customer lifetime value (CLV).
-- Find customers whose spending is above the average.
-- Compute each category's percentage contribution to total revenue.