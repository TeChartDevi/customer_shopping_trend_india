
------------- Time-Series Analysis ------------- 

-- Data Preview
select * from cust_shop_trend_ind limit 20;

-- Monthly sales trend
select
	Year,
	month,
	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		), 2
	) as revenue
from cust_shop_trend_ind
group by 1, 2
order by 2;

-- Monthly return trend
select
	month,

	sum(
		case
			when return_status = 'Returned' then 1
			else 0
		end)
		as total_returned_orders ,

	round(
		100.0 * sum(
			case
				when return_status = 'Returned' then 1
				else 0
			end
		) / count(*), 
		2
	) as return_rate
	
from cust_shop_trend_ind
group by month
order by month;

-- Revenue by weekday

select
	weekday,
	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		), 2
	) as revenue
from cust_shop_trend_ind
group by 1
order by 1;

-- Best performing month
select
	Year,
	month,
	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		), 2
	) as revenue
from cust_shop_trend_ind
group by 1, 2
order by revenue desc
limit 1;

-- Best performing weekday
select
	weekday,
	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		), 2
	) as revenue
from cust_shop_trend_ind
group by 1
order by revenue desc
limit 1;

-- Festival vs. non-festival sales
select
	festival_sale,
	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		), 2
	) as revenue
from cust_shop_trend_ind
group by 1
order by revenue desc;

-- Seasonal sales trends
select
	case
		when month in ('12', '1','2') then 'Winter'
		When month in ('3','4','5') then 'Summer'
		When month in ('6','7','8','9') Then 'Rainy'
		When month in ('10','11') Then 'festive'
	end as Season,

	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		), 2
	) as revenue
	
from cust_shop_trend_ind
group by Season
order by revenue desc;

------------- * End of Analysis * -------------
