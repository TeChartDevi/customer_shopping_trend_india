------------- Discount Analysis ------------- 

-- Data Preview
select * from cust_shop_trend_ind limit 50;

-- Which discount ranges generate the most revenue?
select
	case
		when discount = 0 then 'No Discount'
		when discount Between 1 and 10 then '1-10%'
		when discount Between 11 and 20 then '11-20%'
        when discount Between 21 and 30 then '21-30%'
		when discount Between 31 and 40 then '31-40%'
		when discount Between 41 and 50 then '41-50%'
		when discount Between 51 and 60 then '51-60%'
        else 'Above 60%'
    end as discount_range,

	round(
		sum( 
		(purchase_amount * quantity) *(1 - discount/ 100.0) + shipping_charge		
		), 2
	) as revenue

from cust_shop_trend_ind
group by 
	case
		when discount = 0 then 'No Discount'
		when discount Between 1 and 10 then '1-10%'
		when discount Between 11 and 20 then '11-20%'
        when discount Between 21 and 30 then '21-30%'
		when discount Between 31 and 40 then '31-40%'
		when discount Between 41 and 50 then '41-50%'
		when discount Between 51 and 60 then '51-60%'
        else 'Above 60%'
    end
	
order by revenue desc
limit 1;


-- Do higher discounts increase sales quantity?
with discount_groups as (
    select
        case
			when discount = 0 then 'No Discount'
			when discount Between 1 and 10 then '1-10%'
			when discount Between 11 and 20 then '11-20%'
	        when discount Between 21 and 30 then '21-30%'
			when discount Between 31 and 40 then '31-40%'
			when discount Between 41 and 50 then '41-50%'
			when discount Between 51 and 60 then '51-60%'
	        else 'Above 60%'
	    end as discount_range,
        quantity
    from cust_shop_trend_ind
)
select
    discount_range,
    count(*) as total_orders,
    sum (quantity) as total_quant_sold,
	round(avg (quantity), 2) as avg_quant_sold
from discount_groups
group by  discount_range
order by total_quant_sold desc;

-- Which brands offer the highest average discount?

select
	brand,
	round(avg(discount), 2) as avg_discount
from cust_shop_trend_ind
group by  brand
order by avg_discount desc
limit 1;

-- Which categories have the highest discounts?
select
	category,
	max(discount) as highest_discount
from cust_shop_trend_ind
group by  category
order by highest_discount desc
limit 1;

-- Does discount affect customer ratings?
with discount_groups as (
    select
        case
			when discount = 0 then 'No Discount'
			when discount Between 1 and 10 then '1-10%'
			when discount Between 11 and 20 then '11-20%'
	        when discount Between 21 and 30 then '21-30%'
			when discount Between 31 and 40 then '31-40%'
			when discount Between 41 and 50 then '41-50%'
			when discount Between 51 and 60 then '51-60%'
	        else 'Above 60%'
	    end as discount_range,
		review_rating
    from cust_shop_trend_ind
)
select
    discount_range,
	count(*) as total_review_rating,
	round(avg(review_rating), 2) as avg_review_rating
from discount_groups
group by discount_range
order by avg_review_rating desc;

------------- * End of Analysis * -------------
