
------------- Geographic Analysis ------------- 

-- Data Preview
select * from cust_shop_trend_ind limit 20;

-- Which city generates the highest revenue?
select
	cities,

	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		), 2
	) as revenue

from cust_shop_trend_ind
group by cities
order by revenue desc
limit 1;


-- Which region has the most customers?
select
	region,
	count (customer_id) as total_customers,
	count (distinct customer_id) AS distinct_customers
from cust_shop_trend_ind
group by region
order by total_customers desc
limit 1;


-- Which region has the highest average order value?
select
	region,

	round(
		sum( 
			(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
			) / count (distinct transaction_id)
		, 2
	) as avg_order_val

from cust_shop_trend_ind
group by region
order by avg_order_val desc
limit 1;


-- Which cities have the highest return rate?
select
	cities,

	sum(
		case
			when return_status = 'Returned' then 1
			else 0
		end
	) as total_returned_prod,

	round(
		100.0 * sum(
			case
				when return_status = 'Returned' then 1
				else 0
			end
		) / count(*), 2
	) as return_rate
	
from cust_shop_trend_ind
group by cities
order by return_rate desc
limit 1;

-- Which regions prefer online shopping?

select
	region,
	count (*) as total_online_ord
from cust_shop_trend_ind
where online_offline = 'Online'
group by region
order by total_online_ord desc;

------------- * End of Analysis * -------------
