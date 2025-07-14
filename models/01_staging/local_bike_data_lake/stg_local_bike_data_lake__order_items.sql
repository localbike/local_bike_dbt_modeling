-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14

{{ config(
    cluster_by=["product_id", "order_id"]
) }}

SELECT DISTINCT
      order_id
    , item_id
    , product_id
    , quantity
    , list_price as price
    , discount as discount
    , {{ calculate_total_order_net_price('list_price', 'quantity', 'discount') }}  AS total_order_net_price
FROM {{ source("local_bike_data_lake", "order_items") }}
WHERE quantity > 0