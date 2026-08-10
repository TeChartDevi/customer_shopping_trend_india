# Power BI DAX Measures

All measures are based on the cleaned Power BI table:

```text
clean_cust_shopping_behavior_india
```

---

## 1. Revenue

Revenue is calculated at the transaction level before aggregation.

```DAX
Revenue =
SUMX(
    clean_cust_shopping_behavior_india,
    (
        clean_cust_shopping_behavior_india[Purchase Amount (₹)]
        *
        clean_cust_shopping_behavior_india[Quantity]
    )
    *
    (
        1
        -
        clean_cust_shopping_behavior_india[Discount (%)] / 100
    )
    +
    clean_cust_shopping_behavior_india[Shipping Charge (₹)]
)
```

### Formula

```text
Revenue =
(Purchase Amount × Quantity)
× (1 − Discount / 100)
+ Shipping Charge
```

---

## 2. Total Orders

```DAX
Total Orders =
DISTINCTCOUNT(
    clean_cust_shopping_behavior_india[Transaction ID]
)
```

---

## 3. Total Customers

```DAX
Total Customers =
DISTINCTCOUNT(
    clean_cust_shopping_behavior_india[Customer ID]
)
```

---

## 4. Average Order Value

```DAX
AOV =
DIVIDE(
    [Revenue],
    [Total Orders]
)
```

---

## 5. Average Orders per Customer

```DAX
Avg Orders per Customer =
DIVIDE(
    [Total Orders],
    [Total Customers]
)
```

---

## 6. Returned Orders

```DAX
Returned Orders =
CALCULATE(
    DISTINCTCOUNT(
        clean_cust_shopping_behavior_india[Transaction ID]
    ),
    clean_cust_shopping_behavior_india[Return Status] = "Returned"
)
```

---

## 7. Return Rate

```DAX
Return Rate =
DIVIDE(
    [Returned Orders],
    [Total Orders],
    0
)
```

Format this measure as **Percentage** in Power BI.

Do not multiply by 100 if the measure is formatted as Percentage.

---

## 8. Average Review Rating

```DAX
Average Review Rating =
AVERAGE(
    clean_cust_shopping_behavior_india[Review Rating]
)
```

This version responds to report filters and slicers.

---

## 9. Previous Month Revenue

A Calendar table should be related to the transaction table through:

```text
Calendar[Date]
        ↓
Purchase Date
```

Use:

```DAX
Previous Month Revenue =
CALCULATE(
    [Revenue],
    DATEADD(
        'Calendar'[Date],
        -1,
        MONTH
    )
)
```

---

## 10. Month-over-Month Revenue %

```DAX
MoM % =
DIVIDE(
    [Revenue] - [Previous Month Revenue],
    [Previous Month Revenue]
)
```

Equivalent version:

```DAX
MoM % =
DIVIDE(
    [Revenue],
    [Previous Month Revenue]
) - 1
```

---

# Filter Context

Most dashboard measures should **not** use:

```DAX
ALL(clean_cust_shopping_behavior_india)
```

because doing so removes filters coming from visual categories, slicers and other report interactions.

For example:

```DAX
Revenue =
SUMX(...)
```

allows a chart with `Category` on the axis to calculate revenue separately for each category.

---

# Overall Revenue

If a fixed overall revenue benchmark is required:

```DAX
Overall Revenue =
CALCULATE(
    [Revenue],
    ALL(clean_cust_shopping_behavior_india)
)
```

This measure intentionally ignores filters on the transaction table.

It should not replace the normal `[Revenue]` measure for category-level charts.

---

# Revenue Percentage of Total

```DAX
Revenue % of Total =
DIVIDE(
    [Revenue],
    [Overall Revenue]
)
```

This is an appropriate use of `ALL()` because the denominator is intentionally the overall dataset revenue.

---

# Validation Methodology

Power BI measures were validated against equivalent PostgreSQL queries.

For example:

### PostgreSQL

```sql
SELECT
    category,
    SUM(
        (purchase_amount * quantity)
        * (1 - discount / 100.0)
        + shipping_charge
    ) AS revenue
FROM cust_shop_trend_ind
GROUP BY category;
```

### Power BI

```DAX
Revenue =
SUMX(
    clean_cust_shopping_behavior_india,
    (
        [Purchase Amount (₹)] * [Quantity]
    )
    *
    (
        1 - [Discount (%)] / 100
    )
    +
    [Shipping Charge (₹)]
)
```

The results were compared at the category level before using the measure in dashboard visuals.

---

# Important DAX Lessons

### `SUMX`

Use `SUMX` when a calculation needs to happen row by row before being aggregated.

### `CALCULATE`

Use `CALCULATE` when modifying filter context.

### `DISTINCTCOUNT`

Useful for counting unique customers and unique transaction IDs.

### `DIVIDE`

Preferred over `/` for ratios because it handles division-by-zero safely.

### `ALL`

Use deliberately when filters should be removed. Do not add it simply because a KPI needs a "total."

---

# Recommended Dashboard Measures

| KPI                 | Measure                     |
| ------------------- | --------------------------- |
| Revenue             | `[Revenue]`                 |
| Orders              | `[Total Orders]`            |
| Customers           | `[Total Customers]`         |
| AOV                 | `[AOV]`                     |
| Orders per Customer | `[Avg Orders per Customer]` |
| Returned Orders     | `[Returned Orders]`         |
| Return Rate         | `[Return Rate]`             |
| MoM Revenue         | `[MoM %]`                   |
| Average Rating      | `[Average Review Rating]`   |
