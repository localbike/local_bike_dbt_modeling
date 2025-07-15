{% docs int_local_bike_data_lake__customers_enriched %}

## Description

This intermediate model enriches customer data by aggregating their order activity and introducing behavioral metrics and segmentation labels. It joins customer demographic information with purchase history from the `orders_enriched` model to create a 360° customer profile.

## Data Sources

- `stg_local_bike_data_lake__customers`: Base customer demographic and location information.
- `int_local_bike_data_lake__orders_enriched`: Aggregated orders, including metrics like `total_order_net_price`, `total_items`, and `order_date`.
- `int_local_bike_data_lake__customers`: Additional customer attributes such as gender.

## Key Metrics

- **total_orders**: Total number of distinct orders placed by a customer.
- **total_spent**: Sum of all net prices of orders.
- **avg_order_value**: Average amount spent per order.
- **first_order_date**: Date of the customer's first purchase.
- **last_order_date**: Date of the customer's most recent purchase.
- **total_items_purchased**: Sum of all items purchased by the customer.
- **days_since_last_order**: Number of days since the last recorded order.

## Customer Segmentation Logic

Customers are segmented based on their purchasing behavior:

- `VIP`: ≥ 10 orders and ≥ $5,000 total spent.
- `Loyal`: ≥ 5 orders and ≥ $2,000 total spent.
- `Regular`: ≥ 2 orders.
- `New`: All others.

## Use Cases

- Identifying high-value customers (`VIP`, `Loyal`) for retention or loyalty campaigns.
- Segmenting customers for targeted marketing or personalized communications.
- Analyzing purchase recency and churn indicators (`days_since_last_order`).
- Linking purchase behavior to demographic traits (e.g., gender, location).

## Materialization

This model is materialized as a **table**, and clustered by:

- `customer_id`
- `store_id` (via `store_name` aggregation)

## Notes

- Missing customer activity will result in `NULL` metrics due to the left join, which is intentional to retain the full customer list.
- Date difference is calculated from the current date to track customer recency.

{% enddocs %}