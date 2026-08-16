
------------- Revenue and Sales Analysis -------------

-- Data Preview
select * from cust_shop_trend_ind limit 20;


--# Total Revenue
select
	round(
		sum(
			(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
		), 2
	) as total_rev
from cust_shop_trend_ind;	-- Total Revenue = 22519600.68

-- Revenue calculation

SELECT
    category,
    COUNT(*) AS rows,
    SUM(purchase_amount * quantity) AS gross_amount,
    SUM(
        (purchase_amount * quantity)
        * (1 - discount / 100.0)
    ) AS discounted_amount,
    SUM(shipping_charge) AS shipping,
    SUM(
        (purchase_amount * quantity)
        * (1 - discount / 100.0)
        + shipping_charge
    ) AS total_revenue
FROM cust_shop_trend_ind
GROUP BY category
ORDER BY category;


-- Monthly Revenue Trend

select
	month,
	Round(
		Sum(
	(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge), 2
	) as monthly_revenue
from cust_shop_trend_ind
group by month
order by monthly_revenue desc;

-- Yearly Revenue

select
	Year,
	ROUND(
		Sum(
			(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge), 2
		) as yearly_revenue
from cust_shop_trend_ind
group by Year
order by yearly_revenue desc;

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

--Average order value by each region.
select
	region,
	round(
		sum(
			(purchase_amount * quantity)
			* (1 - discount /100.0)
			+ shipping_charge
		) / count(distinct transaction_id), 2
	) as aov
from cust_shop_trend_ind
group by region
order by aov desc;
-- Total revenue by category

Select
	category,
	Round(
		Sum(
			(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge), 2 
	) AS total_revenue
From cust_shop_trend_ind
group by category
order  by total_revenue desc;

-- Revenue by brand

Select
	brand,
	round(
		Sum( 
		(purchase_amount * quantity) * (1 - discount/100.0) + shipping_charge), 2
	) As Revenue
from cust_shop_trend_ind
group by brand
order by Revenue desc;

-- Revenue by region

Select
	region,
	round(
		Sum( 
		(purchase_amount * quantity) * (1 - discount/100.0) + shipping_charge), 2
	) As Revenue
from cust_shop_trend_ind
group by region
order by Revenue desc;

-- Revenue by city
Select
	cities,
	round(
		Sum( 
		(purchase_amount * quantity) * (1 - discount/100.0) + shipping_charge), 2
	) As Revenue
from cust_shop_trend_ind
group by cities
order by Revenue desc;

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
order by Revenue desc;

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

------------- * End of Analysis * -------------
