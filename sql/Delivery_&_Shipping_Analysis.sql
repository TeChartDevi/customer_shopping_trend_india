-------------  Delivery & Shipping Analysis ------------- 

-- Data Preview
select * from cust_shop_trend_ind limit 20;

-- What is the average delivery time?
select
	round(avg(delivery_time_days), 2) 
from cust_shop_trend_ind;

-- Which delivery speed is most common?
select
	delivery_speed,
	count(delivery_speed) as speed_count
from cust_shop_trend_ind
group by delivery_speed
order by speed_count desc
limit 1;

-- Which region has the fastest delivery?
select
	region,
	delivery_speed,
	min (delivery_time_days) as fastest_delivery
from cust_shop_trend_ind
where delivery_speed <> 'N/A'
group by region, delivery_speed
order by fastest_delivery
limit 1;

-- Does faster delivery improve review ratings?

select
	case
		when delivery_time_days <= 2 then '1-2 Days'
		when delivery_time_days <= 5 then '3-5 Days'
		else '6+ Days'
	end as delivery_time,
	
	count(*) as total_orders,

	round(avg(review_rating), 2) as avg_review_rating
	
from cust_shop_trend_ind
group by
	case
		when delivery_time_days <= 2 then '1-2 Days'
		when delivery_time_days <= 5 then '3-5 Days'
		else '6+ Days'
	end

order by avg_review_rating desc;

-- Does delivery time affect return rate?
select
	case
		when delivery_time_days <= 2 then '1-2 Days'
		when delivery_time_days <= 5 then '3-5 Days'
		else '6+ Days'
	end as delivery_time,
	
	count(*) as total_orders,
	
	sum(
	  	case 
			when return_status = 'Returned' then 1
			else 0
		end
	)  as total_returns,
		
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
group by 
	case
		when delivery_time_days <= 2 then '1-2 Days'
		when delivery_time_days <= 5 then '3-5 Days'
		else '6+ Days'
	end
	
order by return_rate desc;

-- What is the average shipping charge by region?
select
	region,
	round(avg(shipping_charge), 2) as avg_shipping_charge
from cust_shop_trend_ind
where delivery_speed <> 'N/A'
group by region
order by avg_shipping_charge desc;

------------- * End of Analysis * -------------
