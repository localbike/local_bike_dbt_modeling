-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-15

SELECT DISTINCT
      p.product_id
    , p.product_name
    , p.product_gender
    , p.brand_id
    , b.brand_name
    , p.category_id
    , c.category_name
    , p.model_year
    , p.list_price
FROM {{ ref("stg_local_bike_data_lake__products") }} p
LEFT JOIN {{ ref("stg_local_bike_data_lake__categories")}} c ON c.category_id = p.category_id
LEFT JOIN {{ ref("stg_local_bike_data_lake__brands")}} b ON b.brand_id = p.brand_id