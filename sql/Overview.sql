--------- Overview ---------

-- Data Preview
select * from cust_shop_trend_ind limit 20;

-- Rank cities by revenue.
with total_rev as(
	select
		cities,
		round(
			sum(
				(purchase_amount * quantity) * (1 - discount / 100.0) + shipping_charge), 2
				) as revenue
	from cust_shop_trend_ind
	group by cities
)
select 
	cities, 
	revenue,
	dense_rank() over(order by revenue desc) as city_rank
from total_rev;

-- Top 5 brands in each category.
with brand_rev as(
	select
		category,
		brand,
		round(
			sum(
				(purchase_amount * quantity) * (1 - discount / 100.0) + shipping_charge
			), 2
		) as revenue
	from cust_shop_trend_ind
	group by category, brand
),
ranked as (
	select
		category,
		brand,
		revenue,
		dense_rank() over(
			partition by category 
			order by revenue desc
		) as brand_rank
	from brand_rev
)
select * from ranked
where brand_rank <=5
order by category, brand_rank;

-- Running monthly revenue.
with rev as (
	select
		month,
		round(
			sum(
				(purchase_amount * quantity) * (1 - discount / 100.0) + shipping_charge
				), 2
		) as revenue
	from cust_shop_trend_ind
	group by month
)
select
	month,
	revenue,
	sum(revenue) over(
		order by month desc
		) as running_monthly_revenue
from rev;

-- Month-over-month revenue growth.
with rev as (
	select
		month,
		round(
			sum(
				(purchase_amount * quantity) * (1 - discount / 100.0) + shipping_charge
				), 2
		) as revenue
	from cust_shop_trend_ind
	group by month
)
select
	month,
	revenue,
	lag(revenue) over(order by month) as previous_month_revenue,

	round(
		100.0 * (
			revenue - lag(revenue) over(order by month))
			/ lag(revenue) over (order by month)
		, 2
	) as MoM_growth_prct
from rev;
	
	
-- Cumulative revenue over time.

WITH monthly_revenue AS (
    SELECT
        year,
        month,
        ROUND(
            SUM(
                (purchase_amount * quantity) * (1 - discount / 100.0)
                + shipping_charge
            ),
            2
        ) AS revenue
    FROM cust_shop_trend_ind
    GROUP BY year, month
)
SELECT
    year,
    month,
    revenue,

    SUM(revenue) OVER (
        ORDER BY year, month
    ) AS cumulative_revenue

FROM monthly_revenue
ORDER BY year, month;

-- Dense rank products by sales.
with prod_rev as(
	select
		item_purchased,
		round(
			sum(
				(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
			),2
		) as sale
	from cust_shop_trend_ind
	group by item_purchased
)
select
	item_purchased,
	sale,
	dense_rank() over(order by sale desc) as prod_sale_rank
from prod_rev;

-- Identifing repeat customers.
select
	customer_id,
	count(*) as total_orders
from cust_shop_trend_ind
group by customer_id
having count(*) > 1
order by total_orders desc;

-- Calculate customer lifetime value (CLV).
select
	customer_id,
	count(*) as total_orders,
	
	round(
		sum(
			(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
		),2
	) as CLV
from cust_shop_trend_ind
group by customer_id
order by CLV desc

-- 
SELECT
    customer_id,

    ROUND(
        SUM(
            (purchase_amount * quantity) * (1 - discount / 100.0)
            + shipping_charge
        ),
        2
    ) AS total_revenue,

    COUNT(DISTINCT transaction_id) AS total_orders,

    ROUND(
        SUM(
            (purchase_amount * quantity) * (1 - discount / 100.0)
            + shipping_charge
        ) / COUNT(DISTINCT transaction_id),
        2
    ) AS avg_order_value

FROM cust_shop_trend_ind
GROUP BY customer_id;

-- Find customers whose spending is above the average.
with rev as(
	select
		customer_id,
		round(
			sum(
				(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
			),2
		) as spending
	from cust_shop_trend_ind
	group by customer_id
)
select
	customer_id,
	spending
from rev
group by customer_id, spending
having spending > (
	select avg(spending) from rev)
order by spending;


-- Compute each category's percentage contribution to total revenue.
with cat_rev as(
	select
		category,
		round(
			sum(
				(purchase_amount * quantity) * ( 1 - discount/100.0) + shipping_charge
			),2
		) as revenue
	from cust_shop_trend_ind
	group by category
)
select
	category,
	revenue,
	round(
		100.0 * revenue / sum(revenue) over()
		, 2
	) as revenue_prct
from cat_rev
order by revenue desc;


------------- * End of Analysis * -------------
