-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-15

{{ config(
    partition_by={
        "field": "order_date",
        "data_type": "date",
        "granularity": "month"
    },
    cluster_by=["order_status", "store_id", "staff_id"]
) }}

SELECT DISTINCT
      order_id
    , customer_id
    -- , order_status -- Labels unavailable
    , order_date
    , CAST(required_date AS DATE) AS required_date
    , CASE WHEN shipped_date = 'NULL' THEN NULL ELSE CAST(shipped_date AS DATE) END AS shipped_date
    , store_id
    , staff_id
FROM {{ source("local_bike_data_lake", "orders") }}
WHERE order_date IS NOT NULL

