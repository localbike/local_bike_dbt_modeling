{% docs int_local_bike_data_lake__orders %}

## Description

This model provides an enriched view of customer orders by joining order details with product information, store metadata, and staff data. It adds valuable business logic such as shipping status classification, shipping duration, and aggregated order metrics. This model supports operational reporting and fulfillment performance tracking.

## Data Sources

- `stg_local_bike_data_lake__orders`: Raw order header data.
- `stg_local_bike_data_lake__order_items`: Line-level item data per order.
- `stg_local_bike_data_lake__stores`: Store dimension containing address and location.
- `int_local_bike_data_lake__staffs`: Enriched staff dimension with roles and metadata.

## Fields

| Field | Description |
|-------|-------------|
| `order_id` | Unique identifier of the order. |
| `customer_id` | Customer who placed the order. |
| `order_date` | Date when the order was placed. |
| `required_date` | Requested delivery date from the customer. |
| `shipped_date` | Actual shipping date. |
| `days_to_ship` | Time (in days) between `order_date` and `shipped_date`. |
| `order_status` | Fulfillment status |
| `product_id` | Product included in the order. |
| `store_id` | Store that processed the order. |
| `store_name` | Name of the store. |
| `store_street` | Street address of the store. |
| `store_city` | City where the store is located. |
| `store_state` | State where the store is located. |
| `store_zip_code` | ZIP/postal code of the store. |
| `staff_id` | Staff member responsible for the order. |
| `staff_role` | Role of the staff member (e.g., Sales Associate, Manager). |
| `total_items` | Total quantity of items in the order. |
| `total_order_net_price` | Total net revenue of the order after discounts. |
| `unique_products` | Number of distinct products in the order. |

## Business Logic

- Orders are categorized as **"On Time"**, **"Late"**, or **"Pending"** based on the relationship between `shipped_date` and `required_date`.
- Aggregates (e.g., `total_items`, `unique_products`, `total_order_net_price`) are computed per order using `GROUP BY`.

## Fulfillment status

- On Time: Shipped on or before `required_date`
- Late: Shipped after `required_date`
- Pending: Not yet shipped

## Use Cases

- Measure fulfillment performance via `days_to_ship` and `order_status`.
- Analyze store or staff performance on order handling.
- Enable order-level KPIs for dashboards (e.g., average basket size, product diversity).
- Support customer 360 views via linkage to customer behavior.

## Notes

- Orders without `shipped_date` are considered pending.
- If line items are missing (`order_items`), totals will be incomplete.
- Double check staff mappings — a missing join may affect `staff_role`.

{% enddocs %}
