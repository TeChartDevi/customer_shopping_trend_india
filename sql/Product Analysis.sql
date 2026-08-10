------------- Product Analysis -------------

-- Data Preview
select * from cust_shop_trend_ind limit 50;

-- Which categories generate the highest revenue?
select
	category,
	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		), 2
	) as revenue

from cust_shop_trend_ind
group by category
order by revenue desc
limit 1;

-- Which products are purchased most often?
select
	item_purchased,
	count(transaction_id) as product_count
from cust_shop_trend_ind
group by item_purchased
order by product_count desc
limit 1;

-- Which brands sell the most?
select
	brand,
	count(transaction_id) as sale_count
from cust_shop_trend_ind
group by brand
order by sale_count desc
limit 1;
	
-- Which colors are most popular?
select
	color,
	count(transaction_id) as sale_count
from cust_shop_trend_ind
group by color
order by sale_count desc
limit 1;

-- Which sizes are sold the most?
select
	size,
	count(transaction_id) as sale_count
from cust_shop_trend_ind
group by size
order by sale_count desc
limit 1;

-- What is the average quantity purchased per category?
select
	category,
	round(avg(quantity), 2) as avg_quant
from cust_shop_trend_ind
group by category
order by avg_quant desc
limit 1;

-- Which products have the highest return rate?
select
	item_purchased,

	SUM(
        CASE
            WHEN return_status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS total_returned_orders,

	round(
		100.0 * sum(
			case
				when return_status = 'Returned' then 1
				else 0
			end
		) / count (*),2
	) as return_rate

from cust_shop_trend_ind
group by item_purchased
order by return_rate desc
limit 1;
------------- * End of Analysis * -------------
