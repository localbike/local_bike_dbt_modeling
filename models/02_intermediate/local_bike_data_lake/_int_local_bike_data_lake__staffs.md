{% docs int_local_bike_data_lake__staffs %}

This intermediate model enriches staff data by inferring gender based on the staff member’s first name.

### Purpose
The goal of this model is to provide a cleaned and enriched version of the raw staff data, enhanced with inferred gender information for analytical use.

### Data Sources
- `stg_local_bike_data_lake__staffs`: The staging table containing raw staff records.
- `stg_gender_lookups__staffs_gender_lookup`: A lookup table generated with Python logic to associate first names with genders.

### Transformations
- **Gender Enrichment**: Joins the staff data with the gender lookup table on `first_name` to add a `gender` field.
- **Distinct Rows**: Uses `SELECT DISTINCT` to remove duplicates.
- **Column Selection**: Selects key staff attributes relevant for downstream reporting or modeling.

### Fields
- `staff_id`: Unique identifier for the staff member.
- `manager_id`: Identifier of the staff member’s manager.
- `gender`: Inferred gender based on the first name.
- `email`: Staff member’s email address.
- `phone`: Staff member’s phone number.
- `staff_role`: Job role or title.
- `active`: Indicates if the staff member is currently active.
- `store_id`: Identifier of the store to which the staff belongs.

### Notes
- Gender inference is approximate and based solely on first names, which may not always provide accurate results.
- Unlike the customers model, this version does **not** anonymize sensitive fields like phone or email. If needed, consider applying hashing.

{% enddocs %}
