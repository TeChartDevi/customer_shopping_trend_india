
------------- Online vs Offline Analysis ------------- 

-- Data Preview
select * from cust_shop_trend_ind limit 20;

-- Which channel generates more revenue?

select 
	online_offline,

	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		), 2
	) as revenue

from cust_shop_trend_ind
group by online_offline
order by revenue desc;

-- Which channel has higher average order value?
select 
	online_offline,
	COUNT(DISTINCT transaction_id) AS total_orders,

	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		) / count(distinct transaction_id)
		, 2
	) as avg_order_val

from cust_shop_trend_ind
group by online_offline
order by avg_order_val desc;

-- Which online store has the highest sales?
select 
	online_store,

	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		), 2
	) as revenue

from cust_shop_trend_ind
group by online_store
order by revenue desc
limit 1;


-- Which channel has the higher return rate?
select 
	online_offline,

	sum(
  		case 
		  	when return_status = 'Returned' then 1
			else 0
		end
	)  as total_returned_product,
	
	round(
		100.0 * sum(
	  		case 
			  	when return_status = 'Returned' then 1
				else 0
			end
		) / count (*)
		, 2
	) return_rate

from cust_shop_trend_ind
group by online_offline
order by return_rate desc
limit 1;


-- Which payment methods are most popular online?
select
	payment_method,
	count(*) as total_transaction
from cust_shop_trend_ind
where online_offline = 'Online'
group by payment_method
order by total_transaction desc;


------------- * End of Analysis * -------------
