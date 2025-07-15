{% docs int_local_bike_data_lake__customers %}

## Description

This model enriches customer-level data with order metrics, product quantities, recency of activity, and a dynamic segmentation logic based on quartile distribution of key indicators:

- **Total Amount Spent**
- **Total Items Purchased**
- **Days Since Last Order**

Quartiles are calculated dynamically from the dataset using BigQuery's `APPROX_QUANTILES()` function. Customers are classified into the following segments:

### Segment Logic

| Segment       | Criteria                                                                                                                                         |
|---------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| High Value    | Top 25% in both `total_spent` and `total_items_purchased`, and among the most recent 25% (`days_since_last_order` in bottom quartile)           |
| Engaged       | Above-median values in both `total_spent` and `total_items_purchased`, and moderately recent orders                                             |
| Dormant       | Long time since last order (`days_since_last_order` in top quartile) regardless of spend                                                        |
| Low Value     | All other customers                                                                                                                             |

## Fields

| Field                    | Description                                                       |
|--------------------------|-------------------------------------------------------------------|
| `customer_id`            | Unique identifier for the customer                               |
| `customer_gender`        | Gender inferred from customer's first name                       |
| `customer_email`         | Email address of the customer                                    |
| `customer_city`          | City of residence                                                |
| `customer_state`         | State of residence                                               |
| `store_name`             | Name of the store associated with most orders                    |
| `store_id`               | ID of the store                                                  |
| `total_orders`           | Total distinct orders placed                                     |
| `total_spent`            | Total net value of all orders                                    |
| `avg_order_value`        | Average value per order                                          |
| `first_order_date`       | Date of the first order placed                                   |
| `last_order_date`        | Date of the most recent order placed                             |
| `total_items_purchased`  | Total number of items purchased                                  |
| `days_since_last_order`  | Number of days since the last order                              |
| `customer_segment`       | Segment assigned based on quartile-based classification logic    |

## Dependencies

This model depends on the following staging and intermediate models:

- `stg_local_bike_data_lake__customers`
- `stg_gender_lookups__customers_gender_lookup`
- `int_local_bike_data_lake__orders`

## Notes

- The segmentation logic is fully dynamic and adjusts with underlying data distributions.
- Gender attribution is based on a first-name lookup table.
- Designed for use in reporting dashboards and customer behavior analysis.


{% enddocs %}