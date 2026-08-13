
-- Create Table

```sql
DROP TABLE IF EXISTS cust_shop_trend_ind CASCADE;

CREATE TABLE cust_shop_trend_ind(
	Transaction_ID VARCHAR(10),
	Customer_ID VARCHAR(10),
	Purchase_Date DATE,
	Year SMALLINT,
	Month SMALLINT,
	Day SMALLINT,
	Weekday VARCHAR(10),
	Age SMALLINT,
	Age_Group VARCHAR(10),
	Gender VARCHAR(10),
	Cities VARCHAR(50),
	Region VARCHAR(20),	
	Online_Offline VARCHAR(10),
	Online_Store VARCHAR(50),
	Category VARCHAR(50),
	Item_Purchased VARCHAR(50),
	Brand VARCHAR(50),
	Color VARCHAR(20),
	Clothing_Size VARCHAR(20),
	Footwear_Size VARCHAR(20),
	Quantity SMALLINT,
	Purchase_Amount INT,
	Discount SMALLINT,
	Festival_Sale VARCHAR(50),
	Shipping_Charge SMALLINT,
	Delivery_Speed VARCHAR(20),
	Delivery_Time_Days SMALLINT,
	Subscription_Status VARCHAR(5),
	Payment_Method VARCHAR(20),
	Review_Rating SMALLINT,
	Return_Status VARCHAR(20),
	Previous_Purchases SMALLINT,
	Frequency_of_Purchases VARCHAR(30)
);
```