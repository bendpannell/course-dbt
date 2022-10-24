{{
    config(
        materialized = 'table'
    )
}}

with events as (
    select * from {{ ref('stg_pg__events') }}
),

order_items as (
    select * from {{ ref('stg_pg__order_items') }}
),

results as (
    select
        {{ dbt_utils.surrogate_key(['events.session_id',
                                    'events.event_at',
                                    'events.event_type']) }}   as unique_key,
        events.session_id,
        events.order_id,
        events.user_id,

        case
            when events.order_id is not null
                then order_items.product_id
            else events.product_id
        end                     as product_id,

        events.event_type,
        events.event_at
    
    
    from events
    left join order_items
        on events.order_id = order_items.order_id
    order by session_id, order_id
)

select * from results