-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14

SELECT DISTINCT 
      first_name
    , gender
FROM {{ source("gender_lookups", "staffs_gender")}}