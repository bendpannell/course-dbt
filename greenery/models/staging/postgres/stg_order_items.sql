{{
  config(
    materialized='table'
  )
}}

with source as (
  select * from {{ source('postgres', 'order_items') }}
),

results as (
  SELECT 
    order_id,
    product_id,
    quantity

  from source
)

select * from results
