{{ config(
    partition_by={
        "field": "order_date",
        "data_type": "date",
        "granularity": "month"
    },
    cluster_by=["store_id", "order_status"]
) }}


SELECT
    order_id,
    customer_id,
    order_status,
    CAST(order_date AS DATE) as order_date,
    CAST(required_date AS DATE) as required_date,
    CAST(shipped_date AS DATE) as shipped_date,
    store_id,
    staff_id
FROM {{ source("local_bike_data_lake", "orders") }}
WHERE order_date IS NOT NULL

