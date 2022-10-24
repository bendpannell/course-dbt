{{
  config(
    materialized='table'
  )
}}



with sessions as (
    select * from {{ ref('int_sessions') }}
),

orders as (
    select distinct
        session_id,
        count(distinct order_id) as is_order

    from sessions
    group by 1
),

aggs as (
    select
        session_id,
        {{ event_type_counts('int_sessions', 'event_type', 'session_id') }},
        
        count(distinct 
                case
                    when order_id is null
                        then product_id
                    else null
                end)                    as unique_products_viewed,

        count(distinct
                case
                    when order_id is not null
                        then product_id
                    else null
                end)                    as unique_products_purchased,
        min(event_at)                   as session_start_at,
        max(event_at)                   as session_end_at,
        datediff(minutes, session_start_at, session_end_at) as session_duration_min

    from sessions
    group by 1
),

results as (
    select distinct
        s.session_id,
        o.is_order,

        -- Event counts
        aggs.page_view_count,
        aggs.add_to_cart_count,
        aggs.checkout_count,
        aggs.package_shipped_count,

        -- Product counts
        aggs.unique_products_viewed,
        aggs.unique_products_purchased,

        -- -- Timestamp analysis
        aggs.session_duration_min

    from sessions s
    left join orders o
        on s.session_id = o.session_id
    left join aggs
        on s.session_id = aggs.session_id
    
)

select * from results