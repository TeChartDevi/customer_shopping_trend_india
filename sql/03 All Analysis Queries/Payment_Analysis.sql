
------------- Payment Analysis ------------- 

-- Data Preview
select * from cust_shop_trend_ind limit 20;

-- Most used payment method
select
	payment_method,
	Count(*) as usage_count
from cust_shop_trend_ind
group by payment_method
order by usage_count desc
limit 1;

-- Revenue by payment method
select
	payment_method,
	round(
		sum(
			(purchase_amount * quantity) * (1 - discount/100.0) + shipping_charge
		), 2
	) as revenue
from cust_shop_trend_ind
group by payment_method
order by revenue desc;

-- Average order value by payment method
select
	payment_method,
	round(
		sum(
			(purchase_amount * quantity) * (1 - discount/100.0) + shipping_charge)
		/ count(distinct transaction_id), 2
	) as Avg_order_val
from cust_shop_trend_ind
group by payment_method
order by Avg_order_val desc;

-- Return rate by payment method
select
	payment_method,

	sum (
		case 
			when return_status = 'Returned' then 1
			else 0
		end 
	) as total_returned_orders,
	
	round(
		100.0 * sum (
			case 
				when return_status = 'Returned' then 1
				else 0
			end
		)/ count (*),
		2
	) as return_rate

from cust_shop_trend_ind
group by payment_method
order by return_rate;

------------- * End of Analysis * -------------
