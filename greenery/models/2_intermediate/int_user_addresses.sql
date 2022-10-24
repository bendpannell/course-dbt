{{
    config(
        materialized = 'table'
    )
}}

with users as (
    select * from {{ ref('stg_pg__users') }}
),

addresses as (
    select * from {{ ref('stg_pg__addresses') }}
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

    from users
    left join addresses
        on users.address_id = addresses.address_id
)

select * from results