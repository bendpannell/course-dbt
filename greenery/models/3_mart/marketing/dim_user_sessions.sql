{{
    config(
        materialized = 'table'
    )
}}

with users as (
    select * from {{ ref('dim_users') }}
),

sessions as (
    select * from {{ ref('int_sessions') }}
),

aggs as (
    select
        user_id,

        {{ event_type_counts('int_sessions', 'event_type', 'user_id') }},
        min(event_at)                   as session_start_at,
        max(event_at)                   as session_end_at,
        datediff(minutes, session_start_at, session_end_at) as session_duration_min

    from sessions
    group by 1

),

results as (
    select distinct
        {{ dbt_utils.surrogate_key(['s.user_id', 's.session_id', 's.order_id']) }}  as unique_key,
        s.user_id,
        s.session_id,
        s.order_id,
        u.first_name,
        u.last_name,
        u.full_name,
        u.zipcode,
        u.state,
        u.country,

        aggs.page_view_count,
        aggs.add_to_cart_count,
        aggs.checkout_count,
        aggs.package_shipped_count,
        aggs.session_duration_min

    from sessions s
    left join users u
        on s.user_id = u.user_id
    left join aggs
        on s.user_id = aggs.user_id

)

select * from results