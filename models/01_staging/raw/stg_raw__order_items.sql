SELECT * 
FROM {{ source("local_bike_data_lake", "order_items") }}