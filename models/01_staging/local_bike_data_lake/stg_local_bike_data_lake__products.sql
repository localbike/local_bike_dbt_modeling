-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-15

SELECT DISTINCT
      product_id
      -- Deleting year model from product name
    , REGEXP_REPLACE(product_name, r'\s*-\s*\d{4}(\/\d{4})?\s*$', '') AS product_name
    , CASE
        WHEN LOWER(product_name) LIKE '%girl%' THEN 'Female'
        WHEN LOWER(product_name) LIKE '%boy%' THEN 'Male'
        ELSE 'Unisex'
      END AS product_gender
    -- , SPLIT(product_name, ' ')[OFFSET(0)] AS brand_name -- Possible to found the brand_name from here if needed
    , brand_id
    , category_id
    , model_year
    , list_price
FROM {{ source("local_bike_data_lake", "products") }}