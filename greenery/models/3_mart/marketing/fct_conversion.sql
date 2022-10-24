{{
  config(
    materialized='table'
  )
}}

with source as(
    select * from {{ ref('int_sessions') }}
),

results as (
    select
        {{ dbt_utils.surrogate_key(['session_id', 'product_id', 'order_id']) }} as unique_key,
        session_id,
        product_id,
        order_id,
        event_type,
        event_at

    from source
)

select * from results