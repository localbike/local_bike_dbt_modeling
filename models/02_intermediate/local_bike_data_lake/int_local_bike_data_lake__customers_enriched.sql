-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14
-- ACTION: adding key metrics with customers level, creating user segmentation

{{ config(
    materialized='table',
    cluster_by=["customer_id", "store_id"]
) }}

WITH customer_orders AS (
    SELECT
      customer_id
    , store_name
    , store_id
    , COUNT(DISTINCT order_id) as total_orders
    , SUM(total_order_net_price) as total_spent
    , ROUND(AVG(total_order_net_price), 2) as avg_order_value
    , MIN(order_date) as first_order_date
    , MAX(order_date) as last_order_date
    , SUM(total_items) as total_items_purchased
    FROM {{ ref('int_local_bike_data_lake__orders_enriched') }}
    GROUP BY 1, 2, 3
)

SELECT
      c.customer_id
    , c.gender
    , c.email
    , c.city
    , c.state
    , co.store_name
    , co.store_id
    , co.total_orders
    , co.total_spent
    , co.avg_order_value
    , co.first_order_date
    , co.last_order_date
    , co.total_items_purchased
    , DATE_DIFF(CURRENT_DATE(), co.last_order_date, DAY) as days_since_last_order
    -- Customer segmentation proposal
    , CASE 
        WHEN co.total_orders >= 10 AND co.total_spent >= 5000 THEN 'VIP'
        WHEN co.total_orders >= 5 AND co.total_spent >= 2000 THEN 'Loyal'
        WHEN co.total_orders >= 2 THEN 'Regular'
        ELSE 'New'
       END as customer_segment
FROM {{ ref("int_local_bike_data_lake__customers") }} AS c
LEFT JOIN customer_orders AS co ON c.customer_id = co.customer_id