{{
  config(
    materialized='table'
  )
}}

with order_items_source as (
    select * from {{ ref('stg_pg__order_items') }}
),

results as (
    select
        order_id,
        product_id,
        quantity

    from order_items_source
)

select * from results