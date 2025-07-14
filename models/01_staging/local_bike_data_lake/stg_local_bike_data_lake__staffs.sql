SELECT DISTINCT
      staff_id,
      manager_id,
      first_name,
      {{ hash_256('email') }} AS email,
      {{ hash_256('phone') }} AS phone,

      -- Determine if the current staff_id is referenced as a manager_id elsewhere in the table.
      -- Since manager_id is stored as STRING and staff_id is INT64, we use SAFE_CAST to convert
      -- manager_id to INT64 for a valid comparison. SAFE_CAST ensures that if the value is not
      -- convertible (e.g. non-numeric string), it returns NULL instead of throwing an error.

      CASE
        WHEN staff_id IN (
          SELECT SAFE_CAST(manager_id AS INT64) 
          FROM {{ source("local_bike_data_lake", "staffs") }} 
          WHERE manager_id IS NOT NULL
            AND SAFE_CAST(manager_id AS INT64) IS NOT NULL
        )
        THEN 'Manager' 
        ELSE 'Non Manager'
      END AS role,
      
      active,
      store_id
FROM {{ source("local_bike_data_lake", "staffs") }}
