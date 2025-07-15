-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14
-- ACTION: adding key metrics with customers level, creating user segmentation

{{ config(
    cluster_by=["customer_id", "store_id"]
) }}

WITH customer_orders AS (
    SELECT
        customer_id,
        store_name,
        store_id,
        COUNT(DISTINCT order_id) AS total_orders,
        ROUND(SUM(total_order_net_price), 2) AS total_spent,
        ROUND(AVG(total_order_net_price), 2) AS avg_order_value,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        SUM(total_items) AS total_items_purchased
    FROM {{ ref('int_local_bike_data_lake__orders') }}
    GROUP BY 1, 2, 3
),

customer_metrics AS (
    SELECT
        *,
        DATE_DIFF(CURRENT_DATE(), last_order_date, DAY) AS days_since_last_order
    FROM customer_orders
),

quartiles AS (
    SELECT
        APPROX_QUANTILES(total_spent, 4)[SAFE_OFFSET(1)] AS q1_spent,
        APPROX_QUANTILES(total_spent, 4)[SAFE_OFFSET(2)] AS q2_spent,
        APPROX_QUANTILES(total_spent, 4)[SAFE_OFFSET(3)] AS q3_spent,
        
        APPROX_QUANTILES(total_items_purchased, 4)[SAFE_OFFSET(1)] AS q1_items,
        APPROX_QUANTILES(total_items_purchased, 4)[SAFE_OFFSET(2)] AS q2_items,
        APPROX_QUANTILES(total_items_purchased, 4)[SAFE_OFFSET(3)] AS q3_items,

        APPROX_QUANTILES(days_since_last_order, 4)[SAFE_OFFSET(1)] AS q1_days,
        APPROX_QUANTILES(days_since_last_order, 4)[SAFE_OFFSET(2)] AS q2_days,
        APPROX_QUANTILES(days_since_last_order, 4)[SAFE_OFFSET(3)] AS q3_days
    FROM customer_metrics
),

segmented_customers AS (
    SELECT
        cm.*,
        q.*,

        -- Segment logic based on quartiles
        CASE
            WHEN cm.total_spent >= q.q3_spent AND cm.total_items_purchased >= q.q3_items AND cm.days_since_last_order <= q.q1_days THEN 'High Value'
            WHEN cm.total_spent >= q.q2_spent AND cm.total_items_purchased >= q.q2_items AND cm.days_since_last_order <= q.q2_days THEN 'Engaged'
            WHEN cm.days_since_last_order >= q.q3_days THEN 'Dormant'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_metrics cm
    CROSS JOIN quartiles q
)

SELECT
    c.customer_id,
    g.gender AS customer_gender,
    c.email AS customer_email,
    c.city AS customer_city,
    c.state AS customer_state,
    sc.store_name,
    sc.store_id,
    sc.total_orders,
    sc.total_spent,
    sc.avg_order_value,
    sc.first_order_date,
    sc.last_order_date,
    sc.total_items_purchased,
    sc.days_since_last_order,
    sc.customer_segment
FROM {{ ref("stg_local_bike_data_lake__customers") }} AS c
LEFT JOIN {{ ref("stg_gender_lookups__customers_gender_lookup") }} g ON c.first_name = g.first_name
LEFT JOIN segmented_customers sc ON c.customer_id = sc.customer_id
