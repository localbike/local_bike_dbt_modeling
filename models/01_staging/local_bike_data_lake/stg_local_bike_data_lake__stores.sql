-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14

SELECT DISTINCT
      store_id
    , store_name
    , {{ hash_256('phone') }} as phone
    , {{ hash_256('email') }} as email
    , SUBSTR(street, STRPOS(street, ' ') + 1) as store_street
    , city as store_city
    , state as store_state
    , zip_code as store_zip_code
FROM {{ source("local_bike_data_lake", "stores") }}