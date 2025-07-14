SELECT DISTINCT
      product_id
      -- Deleting year model from product name
    , REGEXP_REPLACE(product_name, r'\s*-\s*\d{4}(\/\d{4})?$', '') AS product_name
    , SPLIT(product_name, ' ')[OFFSET(0)] AS brand_name
    , brand_id
    , category_id
    , model_year
    , list_price
FROM {{ source("local_bike_data_lake", "products") }}