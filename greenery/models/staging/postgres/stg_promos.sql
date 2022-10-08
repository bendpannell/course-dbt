{{
  config(
    materialized='table'
  )
}}

with source as (
  select * from {{ source('postgres', 'promos') }}
),

results as (
  select 
    promo_id,
    discount,
    status

  from source
)

select * from results
