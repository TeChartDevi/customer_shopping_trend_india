# Customer Shopping Trend Analysis – India

An end-to-end data analytics project analyzing customer shopping behavior in India using **Python, PostgreSQL, SQL, Power BI, and DAX**.

The project covers the complete analytics workflow, from raw data cleaning and feature engineering to SQL-based business analysis, KPI development, and interactive Power BI dashboard creation.

---

## Project Overview

The objective of this project is to analyze customer shopping behavior and identify patterns across:

* Revenue and sales performance
* Product categories and brands
* Customer purchasing behavior
* Online vs. offline shopping
* Customer demographics
* Discounts and shipping charges
* Delivery performance
* Return behavior
* Customer reviews
* Payment methods
* Subscription status
* Monthly revenue trends

The analysis is based on **10,000 transaction records**.

---

## Tools & Technologies

| Tool           | Purpose                                                                  |      
| -------------- | ------------------------------------------------------------------------ |
| **Python**     | Data cleaning, null value handling, feature engineering, data validation |
| **Pandas**     | Data manipulation and preprocessing                                      |
| **NumPy**      | Conditional transformations and feature creation                         |
| **PostgreSQL** | Database creation, data loading and SQL analysis                         |
| **SQL**        | Data exploration and business analysis                                   |
| **Power BI**   | Interactive dashboard and visualization                                  |
| **DAX**        | KPI and calculated measure development and                               |
| **Git/GitHub** | Version control and project documentation                                |

---

## Project Workflow


![Project Workflow](https://github.com/TeChartDevi/customer_shopping_trend_india/blob/main/Images/Data%20Flow%20(Customer%20Shopping%20Trend%20India).drawio.png)


---
## Repository Structure

```text
customer-shopping-trend-india/
│
├── README.md
│
├── raw_data/
│   └── customer_shopping_behavior_india.csv
│
├── clean_data/
│   └── clean_customer_shopping_behavior_india.csv
│
├── python_cleaning/
│   ├── data_cleaning.ipynb
│   └── README.md
│
├── sql/
│   │
│   ├── 01 create_table.sql
│   │   └── Script.sql
│   │
│   ├── 02_import_data.sql
│   │   └── import_data.sql
│   │
│   └── 03_analysis_queries.sql
│       ├── Customer_Analysis.sql
│       ├── Customer_Satisfaction.sql
│       ├── Delivery_&_Shipping_Analysis.sql
│       ├── Discount_Analysis.sql
│       ├── Geographic_Analysis.sql
│       ├── Online_vs_Offline_Analysis.sql
│       ├── Overview.sql
│       ├── Payment_Analysis.sql
│       ├── Product_Analysis.sql
│       ├── Returns_analysis.sql
│       ├── Revenue_&_Sales_Analysis.sql
│       └── Time-Series_Analysis.sql
│
├── powerbi/
│   ├── customer_shopping_trend_india.pbix
│   ├── DAX_Measures.md
│   └── README.md
│
├── Images/
│   ├── Customer & Operations Analysis.png
│   ├── Data Flow (Customer Shopping Trend India).drawio
│   ├── Data Flow (Customer Shopping Trend India).drawio.png
│   ├── Overview.png
│   └── Sales Analysis.png
│
├── docs/
│   └── data_dictionary.md
│
└── screenshots/
    ├── dashboard_overview.png
    ├── sales_analysis.png
    └── customer_analysis.png
```

---

# Dataset

The dataset contains customer shopping transactions with information covering:

* Transaction and customer identification
* Purchase date
* Customer demographics
* Location
* Online/offline channel
* Product category
* Product and brand
* Quantity
* Purchase amount
* Discount
* Shipping charge
* Delivery speed
* Delivery time
* Subscription status
* Payment method
* Review rating
* Return status
* Previous purchases
* Purchase frequency

### Dataset size

* **Rows:** 10,000
* **Unique customers:** 2,581

---

1. Data Cleaning – Python

Python was used as the first stage of the data pipeline to inspect, clean and prepare the raw dataset.

The main libraries used were:

```text
import pandas as pd
import numpy as np
```

---

# Data Cleaning Activities

The following steps were performed:


## Data Inspection

- Inspected dataset structure using .info()
- Reviewed statistical information using .describe()
- Checked dataset dimensions
- Reviewed sample records
- Checked duplicate records

## Missing Value Handling

Missing values were identified and handled using business logic.

Columns requiring treatment included:

-- `Festival/Sale`
-- `Online Store`
-- `Delivery Speed`
-- `Size`

For example, offline transactions with a missing online store were classified as:
`In-Store Purchase`

Similarly, records with zero delivery time and missing delivery speed were classified as:
`N/A (Offline)`

## Data Type Correction

`Purchase Date` was converted from an object/string field to a proper datetime datatype.

## Column Renaming

The `Location` column was renamed to:

`Cities`

## Feature Engineering

Several business-relevant columns were created:

- `Region`
- `Clothing_Size`
- `Footwear_Size`
- `Year`
- `Month`
- `Day`
- `Weekday`
- `Age Group`

The detailed Python cleaning process is documented in:

`python_cleaning/README.md`

### Objective

The objective of the Python cleaning stage is to ensure that the raw dataset is:

- Clean
- Consistent
- Reliable
- Properly structured
- Ready for SQL analysis
- Ready for Power BI visualization

The cleaned dataset serves as the foundation for the subsequent SQL analytics and Power BI dashboard stages of the project.

---

2. PostgreSQL & SQL Analysis

The cleaned dataset was loaded into PostgreSQL for structured analysis.

The final table is:

`cust_shop_trend_ind`

## SQL Scripts

`01_create_table.sql`

Creates the PostgreSQL table.

`02_import_data.sql`

Imports the cleaned CSV using PostgreSQL's \copy command.

`03_all_analysis_queries.sql`

Contains SQL queries used to answer business questions and calculate analytical metrics.

The detailed SQL documentation is available in:

`sql/README.md`


## Revenue Definition

Revenue was calculated consistently across SQL and Power BI using:

```text
Revenue =
(Purchase Amount × Quantity)
× (1 − Discount / 100)
+ Shipping Charge
```

SQL implementation:

```sql
SUM(
    (purchase_amount * quantity)
    * (1 - discount / 100.0)
    + shipping_charge
)
```
This calculation is performed at the **transaction level before aggregation** so that the discount is correctly applied to each transaction.

---


3. Power BI Dashboard

Power BI was used to transform the cleaned dataset and analytical results into an interactive business dashboard.

The dashboard contains KPIs covering:

### Sales Performance
- Total Revenue
- Total Orders
- Average Order Value
- Revenue by Category
- Monthly Revenue
- MoM Revenue Growth

### Customer Analysis
- Total Customers
- Average Orders per Customer
- Age Group
- Purchase Frequency
- Subscription Status

### Operations
- Delivery Speed
- Delivery Time
- Return Rate
- Returned Orders
- Online vs. Offline Shopping

### Customer Experience
- Review Ratings
- Payment Methods
- Return Behavior
- Discount Analysis

## DAX & Time Intelligence

DAX measures were created for the major KPIs.

Examples include:

```text
AOV =
DIVIDE(
    [Revenue],
    [Total Orders]
)
```

```text
Return Rate =
DIVIDE(
    [Returned Orders],
    [Total Orders]
) * 100
```

Previous month revenue was calculated using a separate Calendar table:

```text
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

Month-over-month revenue growth:

```text
MoM Growth % =
DIVIDE(
    [Revenue] - [Previous Month Revenue],
    [Previous Month Revenue]
) * 100
```

Detailed DAX measures are documented in:

```text
powerbi/DAX_Measures.md
```

---

4. SQL → Power BI Validation

PostgreSQL and Power BI were used together to validate the analytical results.

The same business logic was implemented in both systems.

For example, SQL calculates revenue using:

```sql
SUM(
    (purchase_amount * quantity)
    * (1 - discount / 100.0)
    + shipping_charge
)
```

Power BI calculates the same logic using SUMX().

Selected SQL GROUP BY results were compared with Power BI visual-level results to ensure that the dashboard calculations were consistent with the SQL analysis.

This validation helps reduce calculation discrepancies between the database analysis and dashboard.

---

# Key Analysis Results

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

Standard delivery recorded the highest observed return rate at **19.78%**, while Same Day delivery has the lowest at **16.13%** among the listed delivery categories.

These results indicate an **association** between delivery speed and return rate in this dataset, but they do not establish causation.

---

# Business Questions

The project addresses questions such as:

1. Which product categories generate the most revenue?
2. How many unique customers are represented in the dataset?
3. What is the average order value?
4. How many orders are returned?
5. Which delivery speed has the highest return rate?
6. How does revenue change month over month?
7. How does online performance compare with offline shopping?
8. Which customer groups contribute most to purchasing activity?
9. How do discounts affect revenue?
10. What payment methods are most commonly used?
11. How does subscription status relate to purchasing behavior?
12. How does delivery performance relate to returns?

---

# Dashboard Preview

## Overview
![Overview](https://github.com/TeChartDevi/customer_shopping_trend_india/blob/main/Images/Overview.png)

## Sales Analysis
![Sales Analysis](https://github.com/TeChartDevi/customer_shopping_trend_india/blob/main/Images/Sales%20Analysis.png)

## Customer & Operations Analysis
![Customer & Operations Analysis](https://github.com/TeChartDevi/customer_shopping_trend_india/blob/main/Images/Customer%20%26%20Operations%20Analysis.png)

---

# Key Learnings

This project provided practical experience with the complete analytics workflow:

# Python
- Data inspection
- Missing value analysis
- Conditional data cleaning
- Datatype conversion
- Feature engineering
- Data validation

# PostgreSQL & SQL
- Table creation
- CSV data loading
- Aggregations
- GROUP BY
- Conditional aggregation
- CTEs
- Window functions
- Ranking
- Time-based analysis
- Business KPI calculations

# Power BI & DAX
- Data modeling
- Calendar tables
- Measures
- Filter context
- SUMX()
- CALCULATE()
- DIVIDE()
- DISTINCTCOUNT()
- DATEADD()
- Previous-period analysis
- MoM growth
- Interactive dashboard design

---

# How to Reproduce the Project

## Step 1 — Clean the Dataset

Run the Python notebook:

`python_cleaning/data_cleaning.ipynb`

This produces the cleaned dataset in:

`clean_data/`

## Step 2 — Create the PostgreSQL Table

Run the Scipt in:

`01 Table Creation`

## Step 3 — Import the Data

Run the Scipt in:

`02 Importing Data`

using PostgreSQL/psql.

## Step 4 — Run SQL Analysis

Execute queries in:

`All Analysis Queries`

## Step 5 — Open the Power BI Dashboard

Open:

`powerbi/customer_shopping_trend_india.pbix`

## Step 6 — Review DAX Measures

Refer to:

`powerbi/DAX_Measures.md`

---


## 7. Validate

Compare Power BI results against the corresponding SQL queries before finalizing dashboard visuals.


---

# Conclusion

This project demonstrates an end-to-end approach to data analytics, starting with raw customer transaction data and progressing through:

```text
Data Cleaning
      ↓
Feature Engineering
      ↓
PostgreSQL
      ↓
SQL Analysis
      ↓
DAX & Power BI
      ↓
Dashboard
      ↓
Business Insights
```

The project combines technical data preparation with business-focused analysis to understand sales performance, customer behavior, delivery operations, and return patterns.

---

# Author

**[Devi Smita]**

Data Analytics Project
PostgreSQL | SQL | Power BI | DAX

---

## If you found this project useful

Feel free to explore the SQL analysis and Power BI methodology used in the project.
