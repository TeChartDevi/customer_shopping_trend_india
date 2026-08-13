
-- Import Data

For a local PostgreSQL/psql installation, use the client-side `\copy` command.

```sql
\copy cust_shop_trend_ind
FROM 'C:\Users\user\OneDrive\Desktop\Customer Shopping Trend India\clean_data\clean_customer_shopping_behavior_india.csv'
WITH (
    FORMAT csv,
    HEADER true,
    DELIMITER ','
);
```

### Notes

`\copy` is used instead of server-side `COPY` because `\copy` reads the file from the computer running the `psql` client.

The file path should be changed to the location of the CSV on the user's machine.
