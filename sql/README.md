# PostgreSQL & SQL Analysis

The cleaned dataset was loaded into PostgreSQL for structured data analysis and business-focused SQL queries.

The final PostgreSQL table is:

```text
cust_shop_trend_ind
```

# SQL Scripts
The SQL scripts are organized as follows:

### `01_create_table.sql`

Creates the PostgreSQL table.

### `02_import_data.sql`

Imports the cleaned CSV file using PostgreSQL using the client-side `\copy` command.

### `03_all_analysis_queries.sql`

Contains SQL queries used to perform exploratory analysis, answer business questions, calculate KPIs, and validate Power BI results.

---

# Revenue Definition

Revenue was calculated at the transaction level using the following formula:

```text
Revenue =
(Purchase Amount × Quantity)
× (1 − Discount / 100)
+ Shipping Charge
```

The SQL implementation is:

```sql
ROUND(
    SUM(
        (purchase_amount * quantity)
        * (1 - discount / 100.0)
        + shipping_charge
    )
)
```

Calculating revenue at the transaction level ensures that the discount is applied to each transaction before the results are aggregated.

- NOTE:
The same logic was implemented in Power BI using SUMX() to ensure that the dashboard calculations could be validated against SQL results.

---

# Key Analysis Results

The following results were validated between PostgreSQL and Power BI.

## Revenue by Category

| Category    |      Total Revenue |
| ----------- | -----------------: |
| Clothing    |      ₹9,980,133.08 |
| Footwear    |      ₹9,402,195.85 |
| Accessories |      ₹3,137,271.75 |
| **Total**   | **₹22,519,600.68** |

### Insight

**Clothing** generated the highest revenue, followed by **Footwear** and **Accessories**.

Clothing contributed approximately **44.32%** of total revenue, while Footwear contributed approximately **41.76%**.

---

## Return Rate by Delivery Speed

| Delivery Speed | Total Orders | Returned Orders | Return Rate |
| -------------- | -----------: | --------------: | ----------: |
| Standard       |        4,945 |             978 |      19.78% |
| Express        |        2,248 |             370 |      16.46% |
| N/A (Offline)  |        2,249 |             364 |      16.18% |
| Same Day       |          558 |              90 |      16.13% |

### Insight

**Standard delivery** has the highest observed return rate at **19.78%**.

**Same Day delivery** has the lowest return rate at **16.13%** among the listed delivery categories.

The results indicate an association between delivery speed and return rates in this dataset, although this analysis alone does not establish that delivery speed causes returns.

---

# SQL → Power BI Validation

A key objective of the project was to ensure consistency between PostgreSQL analysis and Power BI calculations.

For example, the SQL revenue calculation:

```sql
SUM(
    (purchase_amount * quantity)
    * (1 - discount / 100.0)
    + shipping_charge
)
```

was reproduced in Power BI using `SUMX()`.

This is important because the revenue calculation needs to be performed at the **transaction level before aggregation**.

SQL `GROUP BY` results were also used to compare and validate Power BI visual-level results for selected KPIs and business questions.

This cross-validation helped ensure that the dashboard calculations were based on the same business logic as the underlying SQL analysis.
