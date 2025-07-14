-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14

SELECT DISTINCT
      brand_id
    , brand_name
FROM {{ source("local_bike_data_lake", "brands") }}