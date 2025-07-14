SELECT * 
FROM {{ source("raw", "order_items") }}