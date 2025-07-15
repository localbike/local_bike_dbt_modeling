-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14
-- ACTION: Calculate total_items, total_order_net_price, unique_products aggregated metrics, adding days_to_ship & delivery_status

{{ config(
    partition_by={
        "field": "order_date",
        "data_type": "date",
        "granularity": "month"
    },
    cluster_by=["store_id", "customer_id"]
) }}

SELECT
      o.order_id
    , o.customer_id
    , o.order_date
    , o.required_date
    , o.shipped_date
    , CASE WHEN o.shipped_date IS NOT NULL AND o.order_date IS NOT NULL THEN DATE_DIFF(o.shipped_date, o.order_date, DAY) END AS days_to_ship
    , CASE 
        WHEN o.shipped_date IS NOT NULL AND o.required_date IS NOT NULL AND o.shipped_date <= o.required_date THEN 'On Time'
        WHEN o.shipped_date IS NOT NULL AND o.required_date IS NOT NULL AND o.shipped_date > o.required_date THEN 'Late'
      ELSE 'Pending'
      END AS order_status
    , oi.product_id
    , st.store_id
    , st.store_name
    , st.store_street
    , st.store_city
    , st.store_state
    , st.store_zip_code
    , s.staff_id
    , s.staff_role
    , SUM(oi.quantity) AS total_items
    , ROUND(SUM(oi.total_order_net_price), 2) AS total_order_net_price
    , COUNT(DISTINCT oi.product_id) AS unique_products
FROM {{ ref('stg_local_bike_data_lake__orders') }} AS o
LEFT JOIN {{ ref('stg_local_bike_data_lake__order_items') }} AS oi ON oi.order_id = o.order_id
LEFT JOIN {{ ref('stg_local_bike_data_lake__stores') }} AS st ON st.store_id = o.store_id
LEFT JOIN {{ ref('int_local_bike_data_lake__staffs')}} AS s ON s.staff_id = o.staff_id
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 15, 16