{% docs mart_customer_360 %}

# Description

This model creates a 360-degree view of each customer, combining purchase behavior, store data, and personalization insights. It aggregates order-level and product-level data to build a single customer record enriched with engagement and diversity metrics.

## Use Cases

The `mart_customer_360` model serves as a customer-centric mart that includes:

- Basic customer KPIs (orders, spending, items purchased)
- Store-level metadata
- Purchase diversity indicators
- Personalization metrics

---

## Fields

| Field Name                 | Description                                                                 |
|----------------------------|-----------------------------------------------------------------------------|
| `customer_id`              | Unique identifier of the customer.                                          |
| `customer_gender`          | Gender estimated of the customer.                                          |
| `total_orders`             | Total number of orders made by the customer.                                |
| `total_spent`              | Total amount spent by the customer.                                         |
| `avg_order_value`          | Average value of orders.                                                    |
| `first_order_date`         | Timestamp of the customer’s first recorded order.                           |
| `last_order_date`          | Timestamp of the customer’s most recent order.                              |
| `total_items_purchased`    | Total number of items purchased by the customer.                            |
| `store_name`               | Name of the store associated with the customer’s order.                     |
| `store_id`                 | Identifier of the store.                                                    |
| `store_city`               | City where the store is located.                                            |
| `store_state`              | State or region of the store.                                               |
| `categories_purchased`     | Number of distinct product categories the customer has purchased from.      |
| `brands_purchased`         | Number of distinct brands the customer has purchased from.                  |

---

{% enddocs %}