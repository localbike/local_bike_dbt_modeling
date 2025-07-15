-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-15
{{ config(cluster_by=["customer_segment"]) }}

select
    c.customer_id,
    c.customer_gender,
    c.total_orders,
    c.total_spent,
    c.avg_order_value,
    c.first_order_date,
    c.last_order_date,
    c.total_items_purchased,
    c.store_name,
    c.store_id,
    c.store_city,
    c.store_state,
    c.customer_segment,
    -- Personalization Metrics
    count(distinct p.category_id) as categories_purchased,
    count(distinct p.brand_id) as brands_purchased
from {{ ref("int_local_bike_data_lake__customers") }} c
left join {{ ref("int_local_bike_data_lake__products") }} p 
    on c.store_id = p.store_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13
