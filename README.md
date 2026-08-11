# Customer Shopping Trend Analysis – India

An end-to-end data analytics project analyzing customer shopping behavior in India using **PostgreSQL, SQL, Power BI, and DAX**.

The project covers data preparation, relational database loading, SQL-based analysis, KPI development, and interactive dashboard creation.

---

## Project Overview

The objective of this project is to analyze customer shopping behavior and identify patterns across:

* Revenue and sales performance
* Product categories
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

The analysis uses a dataset containing **10,000 transaction records**.

---

## Tools & Technologies

| Tool           | Purpose                                          |
| -------------- | ------------------------------------------------ |
| **PostgreSQL** | Database creation, data loading and SQL analysis |
| **SQL**        | Data exploration and business analysis           |
| **Power BI**   | Interactive dashboard and visualization          |
| **DAX**        | KPI and calculated measure development           |
| **Git/GitHub** | Version control and project documentation        |

---

## Repository Structure

```text
customer-shopping-trend-india/
│
├── README.md
│
├── data/
│   └── README.md
│
├── sql/
│   ├── 01_create_table.sql
│   ├── 02_import_data.sql
│   └── 03_analysis_queries.sql
│
├── powerbi/
│   └── DAX_Measures.md
│
├── docs/
│   └── data_dictionary.md
│
└── screenshots/
    └── README.md
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

# Data Workflow

The project follows this workflow:

```text
Raw Dataset
     │
     ▼
Data Cleaning (Python, Numpy, Pandas)
     │
     ├── Imported libraries & loaded the file
     ├── Data Inspection
     ├── Null Value Check & Handling
     ├── Feature Engineering
     ├── Clean Dataset Export
     └── Conclusion
     │
     ▼
PostgreSQL
     │
     ├── Table Creation
     ├── Data Import
     └── SQL Analysis
     │
     ▼
Power BI
     │
     ├── Data Model
     ├── DAX Measures
     └── Dashboard
     │
     ▼
Business Insights
```

---

# Data Cleaning Steps

### 1. Data Loading

The raw customer shopping dataset was loaded into a Pandas DataFrame for inspection and cleaning.

```text
import pandas as pd
import numpy as np

df= pd.read_csv("../raw_data/customer_shopping_behavior.csv")
```

### 2. Initial Data Inspection

The dataset was inspected to understand its structure, data types, missing values, and duplicates

```text
df.head()
df.info()
df.shape
df.describe()
```

### 3. Missing Value Analysis

Missing values were identified across the dataset.

```text
df.isnull().sum().sort_values(ascending=False)
```

Specific columns were also investigated to understand relationships between missing values.

```text
df[
    df[['Festival/Sale', 'Online Store']]
    .isnull()
    .any(axis=1)
][['Festival/Sale', 'Online Store']]
```

This helped determine whether missing values represented actual missing information or valid business cases.

### 4. Conditional Missing Value Handling

Missing values were handled based on business logic rather than blindly replacing all null values.

- Online Store

For offline purchases where the online store was missing:

```text
df.loc[
    (df['Online/Offline'] == 'Offline') &
    (df['Online Store'].isna()),
    'Online Store'
] = 'In-Store Purchase'
```

This distinguishes an actual offline purchase from an unknown online store.

- Delivery Speed

For records with zero delivery time and missing delivery speed:

```text
df.loc[
    (df['Delivery Time (Days)'] == 0) &
    (df['Delivery Speed'].isna()),
    'Delivery Speed'
] = 'N/A (Offline)'
```

This reflects the assumption that a zero-day delivery time represents an offline purchase where delivery speed is not applicable.

### 5. Category-Specific Size Columns

The original Size column contains size information for different product categories.

To make the data easier to analyze, separate columns were created for footwear and non-footwear products.

- Footwear Size

```text
df['Footwear_Size'] = np.where(
    df['Category'] == 'Footwear',
    df['Size'],
    'Not Applicable'
)
```

- Clothing Size

```text
df['Clothing_Size'] = np.where(
    df['Category'] != 'Footwear',
    df['Size'],
    'Not Applicable'
)
```

This allows category-specific analysis in downstream SQL and Power BI analysis.

### 6. Column Organization

The newly created size columns were positioned next to the original Size column to improve dataset readability.

```text
Clothing_Size = np.where(
    df['Category'] != 'Footwear',
    df['Size'],
    'Not Applicable'
)

Footwear_Size = np.where(
    df['Category'] == 'Footwear',
    df['Size'],
    'Not Applicable'
)

size_loc = df.columns.get_loc('Size')

df.insert(
    size_loc + 1,
    'Clothing_Size',
    Clothing_Size
)

df.insert(
    size_loc + 2,
    'Footwear_Size',
    Footwear_Size
)
```




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

# PostgreSQL

The cleaned dataset was loaded into PostgreSQL using a client-side `\copy` command.

The final table is:

```text
public.cust_shop_trend_ind
```

The SQL scripts are organized as follows:

### `01_create_table.sql`

Creates the PostgreSQL table.

### `02_import_data.sql`

Imports the cleaned CSV file using PostgreSQL's `\copy` command.

### `03_analysis_queries.sql`

Contains SQL queries used to answer business questions and validate Power BI calculations.

---

# Revenue Definition

Revenue was calculated at the transaction level using:

```text
Revenue =
(Purchase Amount × Quantity)
× (1 − Discount / 100)
+ Shipping Charge
```

The same logic was implemented in both PostgreSQL and Power BI to ensure that the dashboard calculations could be validated against SQL results.

---

# Power BI

Power BI was used to create an interactive dashboard covering the major business KPIs and trends.

Key measures include:

* Total Revenue
* Total Orders
* Total Customers
* Average Order Value
* Average Orders per Customer
* Returned Orders
* Return Rate
* Previous Month Revenue
* Month-over-Month Revenue Growth

The DAX measures are documented in:

```text
powerbi/DAX_Measures.md
```

---

# Key Validated Results

The following results were validated between PostgreSQL and Power BI.

## Revenue by Category

| Category    |      Total Revenue |
| ----------- | -----------------: |
| Clothing    |      ₹9,980,133.08 |
| Footwear    |      ₹9,402,195.85 |
| Accessories |      ₹3,137,271.75 |
| **Total**   | **₹22,519,600.68** |

Clothing generated the highest revenue among the three categories, followed by Footwear and Accessories.

---

## Return Rate by Delivery Speed

| Delivery Speed | Total Orders | Returned Orders | Return Rate |
| -------------- | -----------: | --------------: | ----------: |
| Standard       |        4,945 |             978 |      19.78% |
| Express        |        2,248 |             370 |      16.46% |
| N/A (Offline)  |        2,249 |             364 |      16.18% |
| Same Day       |          558 |              90 |      16.13% |

Standard delivery has the highest observed return rate at **19.78%**, while Same Day delivery has the lowest at **16.13%** among the listed delivery categories.

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

# SQL → Power BI Validation

A key objective of this project was ensuring that Power BI calculations were consistent with PostgreSQL.

For example, the SQL revenue calculation:

```sql
SUM(
    (purchase_amount * quantity)
    * (1 - discount / 100.0)
    + shipping_charge
)
```

was reproduced in Power BI using `SUMX()`.

This is important because the revenue calculation needs to happen **at the transaction level before the values are aggregated**.

The project also uses SQL `GROUP BY` results to validate Power BI visual-level results.

---

# Filter Context in Power BI

The project distinguishes between:

### Context-aware measures

Measures such as:

```DAX
Revenue =
SUMX(...)
```

respond to filters and slicers in Power BI.

For example, placing `Category` on a chart causes the Revenue measure to calculate revenue separately for each category.

### Overall measures

`ALL()` is only used when an overall dataset benchmark is required.

For example:

```DAX
Overall Revenue =
CALCULATE(
    [Revenue],
    ALL(clean_cust_shopping_behavior_india)
)
```

Using `ALL()` in a normal category-level measure would remove the category filter and cause every category to display the same total.

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

# How to Reproduce the Project

## 1. Prepare the data

Clean the source dataset and ensure the column names and data types are compatible with PostgreSQL.

## 2. Create the PostgreSQL table

Run:

```text
sql/01_create_table.sql
```

## 3. Import the CSV

Update the file path in:

```text
sql/02_import_data.sql
```

Then execute it from `psql`.

## 4. Run the SQL analysis

Use:

```text
sql/03_analysis_queries.sql
```

to reproduce the main analysis.

## 5. Open Power BI

Load the cleaned dataset and create the required data model.

## 6. Add DAX measures

Use the measures documented in:

```text
powerbi/DAX_Measures.md
```

## 7. Validate

Compare Power BI results against the corresponding SQL queries before finalizing dashboard visuals.

---

# Key Learnings

This project provided practical experience with:

* SQL data analysis
* PostgreSQL table creation
* CSV data ingestion
* Data type troubleshooting
* `GROUP BY` analysis
* Conditional aggregation
* Revenue calculations
* Power BI data modeling
* DAX measures
* `SUMX`
* `CALCULATE`
* `DISTINCTCOUNT`
* `DIVIDE`
* `DATEADD`
* Filter context
* `ALL()`
* SQL-to-Power BI validation
* Dashboard development

A particularly important DAX concept learned during the project was understanding how **filter context affects visual-level calculations**.

---

# Author

**[Devi Smita]**

Data Analytics Project
PostgreSQL | SQL | Power BI | DAX

---

## If you found this project useful

Feel free to explore the SQL analysis and Power BI methodology used in the project.
