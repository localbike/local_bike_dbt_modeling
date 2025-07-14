SELECT DISTINCT 
      category_id
    , category_name
FROM {{ source("local_bike_data_lake", "categories") }}