-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-15
{{ config(cluster_by=["customer_segment"]) }}

select
    c.customer_id,
    c.total_orders,
    c.total_spent,
    c.avg_order_value,
    c.first_order_date,
    c.last_order_date,
    c.total_items_purchased,
    o.store_name,
    o.store_id,
    o.store_city,
    o.store_state,
    c.customer_segment,
    -- Personalization Metrics
    count(distinct p.category_id) as categories_purchased,
    count(distinct p.brand_id) as brands_purchased,
    -- Diversity Score (0-1)
    safe_divide(
        count(distinct p.category_id),
        (
            select count(distinct category_id)
            from {{ ref("int_local_bike_data_lake__products") }}
        )
    ) as category_diversity_score
from {{ ref("int_local_bike_data_lake__customers") }} c
left join {{ ref("int_local_bike_data_lake__products") }} s on c.store_id = s.store_id
left join {{ ref("int_local_bike_data_lake__orders") }} o on c.customer_id = o.customer_id
left join {{ ref("int_local_bike_data_lake__products") }} p on o.product_id = p.product_id
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
