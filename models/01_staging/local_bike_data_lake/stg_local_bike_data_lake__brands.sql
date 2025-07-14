SELECT DISTINCT
      brand_id
    , brand_name
FROM {{ source("local_bike_data_lake", "brands") }}