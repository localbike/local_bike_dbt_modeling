-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14

SELECT DISTINCT
      customer_id
    , first_name
    , {{ hash_256('phone') }} phone
    , {{ hash_256('email') }} email
    , SUBSTR(street, STRPOS(street, ' ') + 1) as street
    , city
    , state
    , zip_code
FROM {{ source("local_bike_data_lake", "customers") }}