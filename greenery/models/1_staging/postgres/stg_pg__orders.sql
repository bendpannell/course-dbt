{{
  config(
    materialized='view'
  )
}}

with source as (
  select * from {{ source('postgres', 'orders') }}
),

results as (
  select 
    order_id,
    user_id,
    promo_id,
    address_id,
    created_at,
    order_cost,
    shipping_cost,
    order_total             as total_cost,
    tracking_id,
    shipping_service        as carrier,
    estimated_delivery_at,
    delivered_at,
    status                  as order_status

  from source
)

select * from results
