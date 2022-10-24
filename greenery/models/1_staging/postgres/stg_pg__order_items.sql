{{
  config(
    materialized='view'
  )
}}

with source as (
  select * from {{ source('postgres', 'order_items') }}
),

results as (
    select
        order_id,
        product_id,
        quantity

    from source
)

select * from results