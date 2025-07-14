-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14

SELECT DISTINCT
      store_id
    , product_id
    , quantity
FROM {{ source("local_bike_data_lake", "stocks") }}