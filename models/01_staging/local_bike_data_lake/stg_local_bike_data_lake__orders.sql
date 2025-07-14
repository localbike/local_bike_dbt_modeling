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
    , order_status
    , order_date
    , required_date
    , shipped_date
    , store_id
    , staff_id
FROM {{ source("local_bike_data_lake", "orders") }}
WHERE order_date IS NOT NULL

