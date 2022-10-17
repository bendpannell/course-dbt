{{
  config(
    materialized='view'
  )
}}

with source as (
  select * from {{ source('postgres', 'products') }}
),

results as (
  select 
    product_id,
    name,
    price,
    inventory

  from source
)

select * from results
