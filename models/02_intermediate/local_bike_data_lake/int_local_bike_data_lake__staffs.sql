-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14
-- ACTION: Join with stg_gender_lookups__customers_staffs_lookup to replace first_name field by gender field

SELECT DISTINCT

        s.staff_id
      , s.manager_id
      , g.gender
      , s.email
      , s.phone
      , s.staff_role
      , s.active
      , s.store_id

FROM {{ ref("stg_local_bike_data_lake__staffs") }} s
    LEFT JOIN {{ ref("stg_gender_lookups__staffs_gender_lookup") }} g 
    ON s.first_name = g.first_name
