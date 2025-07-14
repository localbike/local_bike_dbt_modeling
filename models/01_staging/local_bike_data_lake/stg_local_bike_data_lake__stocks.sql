SELECT DISTINCT
      store_id
    , product_id
    , quantity
FROM {{ source("local_bike_data_lake", "stocks") }}