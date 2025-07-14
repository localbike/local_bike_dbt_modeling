SELECT DISTINCT
      store_id
    , store_name
    , {{ hash_256('phone') }} as phone
    , {{ hash_256('email') }} as email
    , SUBSTR(street, STRPOS(street, ' ') + 1) as street
    , city
    , state
    , zip_code
FROM {{ source("local_bike_data_lake", "stores") }}