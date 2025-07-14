-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14

SELECT DISTINCT 
      category_id
    , category_name
FROM {{ source("local_bike_data_lake", "categories") }}