# Python Data Cleaning — Customer Shopping Trend India

## Overview

This folder contains the Python data cleaning and feature engineering workflow for the **Customer Shopping Trend India** project.

The raw customer shopping dataset was cleaned and transformed using **Pandas and NumPy** to create a reliable, analysis-ready dataset for subsequent **SQL analysis and Power BI dashboard development**.

### Workflow

```text
Raw Dataset
     ↓
Data Inspection
     ↓
Data Cleaning
     ↓
Feature Engineering
     ↓
Data Validation
     ↓
Clean Dataset
     ↓
SQL Analysis
     ↓
Power BI Dashboard

```

### Tools & Libraries
- Python
- Pandas
- NumPy
- Jupyter Notebook

```

---

## 1. Importing Libraries & Loading Dataset

The required Python libraries were imported and the raw dataset was loaded into a Pandas DataFrame.

```text
import pandas as pd
import numpy as np

df = pd.read_csv("../raw_data/customer_shopping_behavior.csv")
```

---

## 2. Initial Data Inspection

The dataset was initially inspected to understand its structure, data types, dimensions, and descriptive statistics.

```text
df.info()
df.describe()

print(f"Initial shape: {df.shape}")
print(df.head(30))
```

The inspection helped identify:

- Number of records and columns
- Data types
- Numerical distributions
- Missing values
- Potential data quality issues

---

## 3. Duplicate Record Check

Duplicate records were checked using:

`df.duplicated().sum()`

#### Result

No duplicate records were found in the dataset.

---

## 4. Data Cleaning

The following cleaning activities were performed:

1. Missing value identification and handling
2. Column renaming
3. Data type correction

### 4.1 Missing Value Analysis

Missing values were identified using:

`df.isnull().sum().sort_values(ascending=False)`

The following columns contained missing values:

| Column	      | Missing Values |
| --------------- | -------------- |
| Festival/Sale   |	6,788          |
| Online Store	  | 2,249          |
| Delivery Speed  |	2,249          |
| Size	          | 1,035          |

Missing values were investigated using unique-value checks and cross-column relationships before deciding how to handle them.

### 4.2 Festival/Sale

**Investigation**

Unique values were inspected:

`df['Festival/Sale'].unique()`

The relationship between `Festival/Sale` and `Online Store` was also examined to understand whether the missing values represented a specific business condition.

**Handling**

Missing values were replaced with:

`Regular Day`

using:

`df['Festival/Sale'] = df['Festival/Sale'].fillna('Regular Day')`

This assumes that a missing festival/sale value represents a normal shopping day.

### 4.3 Online Store

Missing values in `Online Store` were handled based on the `Online/Offline` field.

For transactions identified as offline purchases, missing online store values were replaced with:

`In-Store Purchase`

using:

```text
df.loc[
    (df['Online/Offline'] == 'Offline') &
    (df['Online Store'].isna()),
    'Online Store'
] = 'In-Store Purchase'
```

**Business Logic**

If:

`Online/Offline = Offline`

then an online store is not applicable. Therefore, `"In-Store Purchase"` provides a meaningful categorical value instead of leaving the field blank.

### 4.4 Delivery Speed

Missing `Delivery Speed` values were investigated using delivery time.

Where:

`Delivery Time (Days) = 0`

and `Delivery Speed` was missing, the value was replaced with:

`N/A (Offline)`

```text
df.loc[
    (df['Delivery Time (Days)'] == 0) &
    (df['Delivery Speed'].isna()),
    'Delivery Speed'
] = 'N/A (Offline)'
```

**Business Logic**

A zero-day delivery time combined with a missing delivery speed was treated as a transaction where delivery speed was not applicable, such as an offline purchase.

### 4.5 Size

The categories associated with missing `Size` values were investigated:

`df.loc[df['Size'].isna(), 'Category'].unique()`

The relationship between Category, Item Purchased, and Size was also examined.

No specific sub-category relationship was identified that could reliably determine the missing size.

Therefore, the missing values were replaced with:

`Unknown`

`df['Size'] = df['Size'].fillna('Unknown')`

This avoids making unsupported assumptions about the missing sizes.

---

## 5. Column Renaming

The `Location` column was renamed to `Cities` to make its meaning clearer and improve readability.

```text
df.rename(
    columns={'Location': 'Cities'},
    inplace=True
)
```

## 6. Data Type Correction

The `Purchase Date` column was originally stored as an object/string datatype.

It was converted to a proper datetime datatype:

```text
df['Purchase Date'] = pd.to_datetime(
    df['Purchase Date'],
    errors='coerce'
)
```

The resulting datatype was verified:

`print(df['Purchase Date'].dtype)`

This conversion allows date-based operations and feature extraction using Pandas datetime functionality.

---

## 7. Feature Engineering

The following business-relevant features were created:

- `Region`
- `Footwear_Size`
- `Clothing_Size`
- `Year`
- `Month`
- `Day`
- `Weekday`
- `Age Group`

### 7.1 Region

The `Cities` column was mapped into broader geographical regions.

**Region Mapping**

| Region  | Example Cities                                      |
| ------- | --------------------------------------------------- |
| North	  | Delhi, Noida, Gurgaon, Chandigarh, Jaipur, Lucknow  |
| South   | Chennai, Hyderabad, Visakhapatnam, Kochi, Bangalore |
| West	  | Mumbai, Pune, Ahmedabad, Nagpur, Surat              |
| East	  | Kolkata, Patna, Bhubaneswar                         |
| Central | Indore                                              |

A dictionary mapping was created:

```text
region_map = {
    'Delhi': 'North',
    'Noida': 'North',
    'Gurgaon': 'North',
    'Chandigarh': 'North',
    'Jaipur': 'North',
    'Lucknow': 'North',

    'Chennai': 'South',
    'Hyderabad': 'South',
    'Visakhapatnam': 'South',
    'Kochi': 'South',
    'Bangalore': 'South',

    'Mumbai': 'West',
    'Pune': 'West',
    'Ahmedabad': 'West',
    'Nagpur': 'West',
    'Surat': 'West',

    'Kolkata': 'East',
    'Patna': 'East',
    'Bhubaneswar': 'East',

    'Indore': 'Central'
}
```

The resulting Region column was positioned immediately after Cities.

### 7.2 Category-Specific Size Columns

The original Size column was separated into two analysis-friendly columns:

- `Clothing_Size`
- `Footwear_Size`

**Footwear Size**

```text
Footwear_Size = np.where(
    df['Category'] == 'Footwear',
    df['Size'],
    'Not Applicable'
)
```

**Clothing Size**

```text
Clothing_Size = np.where(
    df['Category'] != 'Footwear',
    df['Size'],
    'Not Applicable'
)
```

The two columns were inserted immediately after the original `Size` column.

After creating the new columns, the original `Size` column was removed.

This structure makes category-specific size analysis easier in SQL and Power BI.

### 7.3 Date Feature Extraction

Several features were extracted from `Purchase Date`:

- Year
- Month
- Day
- Weekday

```text
df.insert(
    purchase_date_loc + 1,
    'Year',
    df['Purchase Date'].dt.year
)

df.insert(
    purchase_date_loc + 2,
    'Month',
    df['Purchase Date'].dt.month
)

df.insert(
    purchase_date_loc + 3,
    'Day',
    df['Purchase Date'].dt.day
)

df.insert(
    purchase_date_loc + 4,
    'Weekday',
    df['Purchase Date'].dt.day_name()
)

```

These fields support time-based analysis such as:

- Monthly revenue
- Yearly revenue
- Seasonal trends
- Weekday performance

### 7.4 Age Group

An `Age Group` feature was created to make customer demographic analysis easier.

```text
def age_group(age):
    if age < 18:
        return 'Under 18'
    elif age <= 25:
        return '18-25'
    elif age <= 35:
        return '26-35'
    elif age <= 45:
        return '36-45'
    elif age <= 60:
        return '46-60'
    else:
        return 'Above 60'
```

The function was applied to the `Age` column:

```text
df.insert(
    age_loc + 1,
    'Age Group',
    df['Age'].apply(age_group)
)
```

---

## 8. Final Data Validation

After cleaning and feature engineering, the dataset was validated again.

**Duplicate Check**

`df.duplicated().sum()`

**Data Types**

`df.dtypes`

**Dataset Information**

`df.info()`

**Remaining Missing Values**

`df.isnull().sum()`

**Final Shape**

`print(f"Shape After Preprocessing: {df.shape}")`

**Sample Records**

`df.head()`

These checks were used to confirm that the preprocessing steps were successfully applied.

---

## 9. Export Clean Dataset

The final cleaned dataset was exported as a CSV file:

```text
df.to_csv(
    "../clean_data/clean_customer_shopping_behavior_india.csv",
    index=False
)
```

The resulting dataset is used as the input for the project's SQL analysis and Power BI dashboard.

---

## 10. Summary of Transformations

| Area	               | Transformation                                |
| -------------------- | --------------------------------------------- |
| Duplicates	       | Checked; no duplicates found                  |
| Festival/Sale	       | Missing → `Regular Day`                       |
| Online Store	       | Offline + missing → `In-Store Purchase`       |
| Delivery Speed	   | Zero delivery time + missing → `N/A (Offline)`|
| Size	               | Missing → `Unknown`                           |
| Location	           | Renamed to `Cities`                           |
| Purchase Date	       | Converted to datetime                         |
| Region	           | Created from city mapping                     |
| Clothing Size	       | Created from `Size`                           |
| Footwear Size	       | Created from `Size`                           |
| Year	               | Extracted from Purchase Date                  |
| Month	               | Extracted from Purchase Date                  |
| Day	               | Extracted from Purchase Date                  |
| Weekday	           | Extracted from Purchase Date                  |
| Age Group	           | Created from `Age`                            |

---

## 11. Conclusion

The raw customer shopping dataset was cleaned and transformed into an analysis-ready dataset.

The preprocessing workflow included:

- Initial dataset inspection
- Duplicate record validation
- Missing value investigation and handling
- Column renaming
- Datatype correction
- Region mapping
- Category-specific size feature engineering
- Date feature extraction
- Customer age segmentation
- Final data validation
- Exporting the cleaned dataset

The cleaned dataset provides a consistent foundation for the next stages of the project:
Python Cleaning --> SQL Analysis --> Power BI Dashboard