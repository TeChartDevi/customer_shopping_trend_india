
------------- Customer Analysis -------------

-- Data Preview
select * from cust_shop_trend_ind limit 20;


-- # Number of Unique customers
select 
	count (distinct customer_id) as No_of_unique_customers
from  cust_shop_trend_ind;	-- No_of_unique_customers = 2581

-- # Total Revenue
select
	round(
		sum(
			(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
		), 2
	) as total_rev
from cust_shop_trend_ind;	-- Total Revenue = 22519600.68

-- # Most spending customers
select
	customer_id,
	round(
		sum(
		(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
		), 2
	) as total_spending
from cust_shop_trend_ind
group by customer_id
order by total_spending desc
limit 5;


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
order by most_spending_age_group desc
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

-- Year based Subscription status affect spending

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

------------- * End of Analysis * -------------
