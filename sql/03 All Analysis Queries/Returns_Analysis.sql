------------- Returns Analysis ------------- 

-- Data Preview
select * from cust_shop_trend_ind limit 50;

-- What is the overall return rate?
select
	COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN return_status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS returned_orders,

	round(
		100.0 * sum(
			case
				when return_status = 'Returned' then 1
				else 0
			end
		) / count (*),2
	) as overall_return_rate
	
from cust_shop_trend_ind;


-- Which category has the highest return rate?
select
	category,

    SUM(
        CASE
            WHEN return_status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS returned_orders,

	round(
		100.0 * sum(
			case
				when return_status = 'Returned' then 1
				else 0
			end
		) / count (*),2
	) as return_rate
from cust_shop_trend_ind
group by category
order by return_rate desc
limit 1;


-- Which brand has the highest returns?
select
	brand,

    SUM(
        CASE
            WHEN return_status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS returned_orders,

	round(
		100.0 * sum(
			case
				when return_status = 'Returned' then 1
				else 0
			end
		) / count (*),2
	) as return_rate
	
from cust_shop_trend_ind
group by brand
order by return_rate desc
limit 1;

-- Which city has the highest returns?

select
	cities,

    SUM(
        CASE
            WHEN return_status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS returned_orders,

	round(
		100.0 * sum(
			case
				when return_status = 'Returned' then 1
				else 0
			end
		) / count (*),2
	) as return_rate
	
from cust_shop_trend_ind
group by cities
order by return_rate desc
limit 1;

-- Do online orders have higher return rates than offline orders?
select
	online_offline,
	COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN return_status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS returned_orders,
	
	round(
		100.0 * sum(
			case
				when return_status = 'Returned' then 1
				else 0
			end
		) / count (*),2
	) as return_rate
	
from cust_shop_trend_ind
group by online_offline
order by return_rate desc;

-- Does delivery speed affect returns?
select
	delivery_speed,
	COUNT(*) AS total_orders,
	
    SUM(
        CASE
            WHEN return_status = 'Returned' THEN 1
            ELSE 0
        END
    ) AS returned_orders,

	ROUND(
        100.0 * SUM(
            CASE
                WHEN return_status = 'Returned' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS return_rate
	
from cust_shop_trend_ind
group by delivery_speed
order by return_rate desc;


-- Do discounts increase return rates?

select
	count(*) as total_orders,
	
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
	
    sum(
        case
            when return_status = 'Returned' then 1
            else 0
        end
    ) as returned_orders,

	round(
		100.0 * sum(
			case
				when return_status = 'Returned' then 1
				else 0
			end
		) / count (*),2
	) as return_rate
	
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

order by return_rate desc;

------------- * End of Analysis * -------------
