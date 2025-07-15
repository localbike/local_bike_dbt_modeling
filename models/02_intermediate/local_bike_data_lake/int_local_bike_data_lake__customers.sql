-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-15
-- ACTION: Join with stg_gender_lookups__customers_gender_lookup to replace first_name field by gender field


SELECT DISTINCT
      c.customer_id
    , g.gender
    , c.phone
    , c.email
    , c.street
    , c.city
    , c.state
    , c.zip_code
FROM {{ ref("stg_local_bike_data_lake__customers") }} c 
    LEFT JOIN {{ ref("stg_gender_lookups__customers_gender_lookup") }} g 
    ON c.first_name = g.first_name