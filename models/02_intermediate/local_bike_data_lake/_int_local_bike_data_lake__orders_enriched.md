{% docs int_local_bike_data_lake__orders_enriched %}

### Overview

This model provides an aggregated summary of customer orders, enriched with shipment and delivery details. It joins the base orders data with order items to compute useful business metrics such as:

- Number of items in the order
- Total net price of the order
- Number of distinct products in the order
- Delivery delay
- Delivery status classification

It uses partitioning by `order_date` (monthly granularity) and clustering by `store_id` and `customer_id` to improve query performance in BigQuery.

---

### Fields

| Field Name            | Description |
|-----------------------|-------------|
| `order_id`            | Unique identifier for each order |
| `customer_id`         | Identifier of the customer who placed the order |
| `order_date`          | Date when the order was placed |
| `required_date`       | Date by which the order was expected to be shipped |
| `shipped_date`        | Actual date the order was shipped |
| `order_status`        | Status of the order (e.g., placed, shipped, delivered) |
| `store_id`            | Identifier of the store that processed the order |
| `staff_id`            | Identifier of the staff member who handled the order |
| `total_items`         | Total quantity of items in the order |
| `total_order_net_price` | Total net price of all items in the order, rounded to 2 decimal places |
| `unique_products`     | Number of unique products included in the order |
| `days_to_ship`        | Number of days between the order and the shipment date (NULL if not shipped) |
| `delivery_status`     | Categorization of the delivery as `On Time`, `Late`, or `Pending` based on comparison of `shipped_date` and `required_date` |

---

### Logic

- **Join logic:** The model performs a `LEFT JOIN` between the `orders` and `order_items` staging models using `order_id`.
- **Aggregations:** Uses `SUM`, `COUNT(DISTINCT)` and `ROUND` to compute order-level metrics.
- **Date logic:** `days_to_ship` uses `DATE_DIFF`, with null-safe logic. `delivery_status` uses a conditional `CASE` statement to classify the delivery.

---

### Partitioning and Clustering

- **Partitioned by:** `order_date` (monthly)
- **Clustered by:** `store_id`, `customer_id`

These configurations help reduce scan costs and improve query speed in BigQuery.

{% enddocs %}
