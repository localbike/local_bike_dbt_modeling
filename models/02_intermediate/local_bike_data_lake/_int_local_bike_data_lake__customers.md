{% docs int_local_bike_data_lake__customers %}

## Description

This model enriches customer data by combining personal information with order behavior and inferred gender. It enables advanced customer analytics such as segmentation, lifetime value estimation, and retention analysis.

The model calculates **aggregated metrics per customer**, including total spending, order frequency, average order value, and recency. It also includes a **proposed customer segmentation** based on transaction history.

## Data Sources

- `int_local_bike_data_lake__orders_enriched`: Aggregated order-level data with financial and fulfillment metrics.
- `stg_local_bike_data_lake__customers`: Base customer data, including contact info and location.
- `stg_gender_lookups__customers_gender_lookup`: Lookup table that infers gender based on first name.

## Fields

| Field | Description |
|-------|-------------|
| `customer_id` | Unique identifier for each customer. |
| `gender` | Inferred gender from the customer's first name using a lookup table. |
| `email` | Email address of the customer. |
| `city` | Customer's city of residence. |
| `state` | Customer's state of residence. |
| `store_name` | Name of the store where the customer placed orders. |
| `store_id` | Identifier of the store where purchases were made. |
| `total_orders` | Number of unique orders placed by the customer. |
| `total_spent` | Total monetary value spent by the customer across all orders. |
| `avg_order_value` | Average order value (total spent / total orders). |
| `first_order_date` | Date of the customer's first order. |
| `last_order_date` | Date of the most recent order placed by the customer. |
| `total_items_purchased` | Sum of all items purchased by the customer. |
| `days_since_last_order` | Number of days since the last order (recency metric). |
| `customer_segment` | Proposed customer classification. |

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

- Gender is inferred and may not always be accurate.
- If no orders exist for a customer, financial and segmentation fields will be `NULL`.
- Can be extended with churn scoring or RFM metrics.

---

Souhaites-tu aussi une version `.yml` pour ce modèle, afin d'intégrer la documentation dans `dbt docs` et activer les tooltips dans le lineage ?

{% enddocs %}