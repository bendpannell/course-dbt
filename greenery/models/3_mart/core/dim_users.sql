{{
  config(
    materialized='table'
  )
}}

with user_source as (
  select * from {{ ref('int_user_addresses') }}
),

results as (
    select
        user_id,
        first_name,
        last_name,
        full_name,
        email,
        phone_number,
        address,
        zipcode,
        state,
        country,
        created_at,
        updated_at

    from user_source
)

select * from results