-- CREATED BY : reusnep@consulting-agency.com
-- LAST UPDATE: 2025-07-14
-- ACTION: adding key metrics with customers level, creating user segmentation
{{ config(cluster_by=["customer_id", "store_id"]) }}

with
    customer_orders as (
        select
            customer_id,
            store_id,
            store_name,
            store_street,
            store_city,
            store_state,
            store_zip_code,
            count(distinct order_id) as total_orders,
            round(sum(total_order_net_price), 2) as total_spent,
            round(avg(total_order_net_price), 2) as avg_order_value,
            min(order_date) as first_order_date,
            max(order_date) as last_order_date,
            sum(total_items) as total_items_purchased
        from {{ ref("int_local_bike_data_lake__orders") }}
        group by 1, 2, 3, 4, 5, 6, 7
    ),

    customer_metrics as (
        select
            *, date_diff(current_date(), last_order_date, day) as days_since_last_order
        from customer_orders
    ),

    quartiles as (
        select
            approx_quantiles(total_spent, 4)[safe_offset(1)] as q1_spent,
            approx_quantiles(total_spent, 4)[safe_offset(2)] as q2_spent,
            approx_quantiles(total_spent, 4)[safe_offset(3)] as q3_spent,

            approx_quantiles(total_items_purchased, 4)[safe_offset(1)] as q1_items,
            approx_quantiles(total_items_purchased, 4)[safe_offset(2)] as q2_items,
            approx_quantiles(total_items_purchased, 4)[safe_offset(3)] as q3_items,

            approx_quantiles(days_since_last_order, 4)[safe_offset(1)] as q1_days,
            approx_quantiles(days_since_last_order, 4)[safe_offset(2)] as q2_days,
            approx_quantiles(days_since_last_order, 4)[safe_offset(3)] as q3_days
        from customer_metrics
    ),

    segmented_customers as (
        select
            cm.*,
            q.*,

            -- Segment logic based on quartiles
            case
                when
                    cm.total_spent >= q.q3_spent
                    and cm.total_items_purchased >= q.q3_items
                    and cm.days_since_last_order <= q.q1_days
                then 'High Value'
                when
                    cm.total_spent >= q.q2_spent
                    and cm.total_items_purchased >= q.q2_items
                    and cm.days_since_last_order <= q.q2_days
                then 'Engaged'
                when cm.days_since_last_order >= q.q3_days
                then 'Dormant'
                else 'Low Value'
            end as customer_segment
        from customer_metrics cm
        cross join quartiles q
    )

select
    c.customer_id,
    g.gender as customer_gender,
    c.email as customer_email,
    c.city as customer_city,
    c.state as customer_state,
    sc.store_id,
    sc.store_name,
    sc.store_street,
    sc.store_city,
    sc.store_state,
    sc.store_zip_code,
    sc.total_orders,
    sc.total_spent,
    sc.avg_order_value,
    sc.first_order_date,
    sc.last_order_date,
    sc.total_items_purchased,
    sc.days_since_last_order,
    sc.customer_segment
from {{ ref("stg_local_bike_data_lake__customers") }} as c
left join
    {{ ref("stg_gender_lookups__customers_gender_lookup") }} g
    on c.first_name = g.first_name
left join segmented_customers sc on c.customer_id = sc.customer_id
