{{
  config(
    materialized='view'
  )
}}

with source as (
  select * from {{ source('postgres', 'addresses') }}
),

results as (
  select
    address_id,
    address,
    zipcode,
    state,
    country

  from source
)

select * from results
