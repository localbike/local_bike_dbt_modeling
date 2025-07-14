SELECT DISTINCT 
      first_name
    , gender
FROM {{ source("gender_lookups", "customers_gender")}}