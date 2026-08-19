# Power BI

Power BI was used to transform the cleaned dataset into an interactive dashboard for analyzing customer shopping behavior, sales performance, customer behavior, and operational performance.

The dashboard was developed using **Power BI and DAX**.

---

## Dashboard KPIs

The dashboard includes the following key measures:

* Total Revenue
* Total Orders
* Total Customers
* Average Order Value
* Returned Orders
* Return Rate


The DAX measures are documented in:

```text
powerbi/DAX_measures.md
```

---
# Dashboard

The Power BI dashboard is designed to provide an overview of:

### Sales Performance

* Total Revenue
* Total Orders
* Average Order Value
* Revenue by Category
* Revenue trends over time

### Customer Analysis

* Unique Customers
* Average Orders per Customer
* Customer demographics
* Purchase frequency
* Subscription status

### Operational Analysis

* Return Rate
* Returned Orders
* Return Rate by Delivery Speed
* Delivery performance
* Online vs. Offline performance

### Customer Experience

* Review ratings
* Payment methods
* Return behavior
* Delivery speed

---

# DAX Measures

The dashboard uses DAX measures to calculate business KPIs dynamically based on the current filter context.

Examples include:

```DAX
Revenue =
SUMX(
    clean_cust_shopping_behavior_india,
    (clean_cust_shopping_behavior_india[Purchase Amount (₹)]
    * clean_cust_shopping_behavior_india[Quantity])
    * (1 - clean_cust_shopping_behavior_india[Discount (%)] / 100)
    + clean_cust_shopping_behavior_india[Shipping Charge (₹)]
)
```

### Average Order Value

```
AOV =
DIVIDE(
    [Revenue],
    [Total Orders]
)
```

### Return Rate

```
Return Rate =
DIVIDE(
    [Returned Orders],
    [Total Orders]
) * 100

```

### Previous Month Revenue

```
Previous Month Revenue =
CALCULATE(
    [Revenue],
    DATEADD(
        Calender[Date],
        -1,
        MONTH
    )
)
```

### Month-over-Month Revenue Growth

```
MoM Growth % =
DIVIDE(
    [Revenue] - [Previous Month Revenue],
    [Previous Month Revenue]
) * 100
```

---

# Time Intelligence

A separate Calendar table was used for time-based analysis.

The Calendar table contains a continuous date range and is related to the Purchase Date column in the main transaction table.

This enables time-intelligence calculations such as:

* Previous Month Revenue
* MoM Revenue Growth
* Monthly Revenue Trends
* Year-over-Year comparisons

---


# Key Analysis Results

The following results were compared between PostgreSQL and Power BI to ensure consistency in the underlying business calculations.

## Revenue by Category

| Category    |      Total Revenue |
| ----------- | -----------------: |
| Clothing    |      ₹9,980,133.08 |
| Footwear    |      ₹9,402,195.85 |
| Accessories |      ₹3,137,271.75 |
| **Total**   | **₹22,519,600.68** |

### Insight

**Clothing** generated the highest revenue, followed by **Footwear** and **Accessories**.

Clothing contributed approximately **44.32%** of total revenue.
---

## Return Rate by Delivery Speed

| Delivery Speed | Total Orders | Returned Orders | Return Rate |
| -------------- | -----------: | --------------: | ----------: |
| Standard       |        4,945 |             978 |      19.78% |
| Express        |        2,248 |             370 |      16.46% |
| N/A (Offline)  |        2,249 |             364 |      16.18% |
| Same Day       |          558 |              90 |      16.13% |

### Insight

**Standard delivery** recorded the highest observed return rate at **19.78%**.

**Same Day delivery** recorded the lowest return rate at **16.13%** among the listed delivery categories.

These results indicate an association between delivery speed and return rates in the dataset, but they do not establish that delivery speed directly causes returns.

---

# PostgreSQL → Power BI Validation

PostgreSQL was used as a reference point for validating selected Power BI calculations.

For example, revenue was calculated in SQL as:

```sql
SUM(
    (purchase_amount * quantity)
    * (1 - discount / 100.0)
    + shipping_charge
)
```

The same business logic was implemented in Power BI using SUMX().

This ensures that:

1. Revenue is calculated at the transaction level.
2. Discounts are applied before aggregation.
3. Shipping charges are included consistently.
4. PostgreSQL and Power BI use the same revenue definition.

Selected `GROUP BY` results from PostgreSQL were also compared against Power BI visual-level results to verify KPI consistency.

---

# Dashboard Features

The dashboard provides interactive filtering through slicers and visual-level filters.

Users can explore the data by dimensions such as:

* Year
* Month
* Region
* Category
* Online/Offline
* Payment Method
* Delivery Speed
* Subscription Status
* Age Group

The dashboard allows users to move from high-level KPIs into more detailed sales, customer, product, delivery, and return analysis.

---

# Dashboard Preview

## Overview
![Overview](https://github.com/TeChartDevi/customer_shopping_trend_india/blob/main/Images/Overview.png)

## Sales Analysis
![Sales Analysis](https://github.com/TeChartDevi/customer_shopping_trend_india/blob/main/Images/Sales%20Analysis.png)

## Customer & Operations Analysis
![Customer & Operations Analysis](https://github.com/TeChartDevi/customer_shopping_trend_india/blob/main/Images/Customer%20%26%20Operations%20Analysis.png)
