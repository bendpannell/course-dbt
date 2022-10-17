{{
  config(
    materialized='view'
  )
}}

with source as (
  select * from {{ source('postgres', 'events') }}
),

results as (
  select
    event_id,
    session_id,
    user_id,
    page_url,
    created_at as event_at,
    event_type,
    order_id,
    product_id

  from source
)

select * from results