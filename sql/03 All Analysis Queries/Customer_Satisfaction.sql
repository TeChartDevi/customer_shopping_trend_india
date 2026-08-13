------------- Customer Satisfaction ------------- 

-- Data Preview
select * from cust_shop_trend_ind limit 20;

-- What is the average review rating?
select
	round(avg(review_rating), 2) as avg_review_rating
from cust_shop_trend_ind;

-- Which categories have the highest ratings?
select
	category,
	max(review_rating) as higest_review_rating
from cust_shop_trend_ind
group by category;

-- Which brands receive the best ratings?
select
	brand,
	max(review_rating) as best_review_rating
from cust_shop_trend_ind
group by brand;

-- Does subscription status improve ratings?
select
	subscription_status,
	avg(review_rating) as avg_review_rating
from cust_shop_trend_ind
group by subscription_status;

-- Do returned items receive lower ratings?
select
	return_status,
	count(*) as total_orders,
	round(avg(review_rating), 2) as avg_review_rating
from cust_shop_trend_ind
group by return_status;

-- For each review rating, what percentage of orders were returned?
select
	review_rating,
	count(*) as total_orders,
	
	sum(
		case
			when return_status = 'Returned' then 1
			else 0
		end
	) as total_returned_item,

	round(
		100.0 * sum(
			case
				when return_status = 'Returned' then 1
				else 0
			end
		)/ count(*)
	) as return_rate
from cust_shop_trend_ind
group by review_rating
order by return_rate desc;

------------- * End of Analysis * -------------
