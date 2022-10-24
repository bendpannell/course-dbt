{{
  config(
    materialized='table'
  )
}}

with users as (
    select * from {{ ref('dim_users') }}
),

orders as (
    select * from {{ ref('fct_orders') }}
),

aggs as (
    select
        user_id,
        count(distinct order_id)    as order_count,
        sum(is_on_time_delivery)    as total_on_time_deliveries,
        sum(products_purchased)     as total_unique_products_purchased,
        sum(total_items_purchased)  as total_items_purchased,
        sum(promo_discount)         as total_discount,
        sum(order_cost)             as total_revenue,
        sum(shipping_cost)          as total_shipping_paid,
        sum(total_cost)             as total_paid

    from  orders
    group by 1     
),

results as (
    select distinct
        u.user_id,
        u.first_name,
        u.last_name,
        u.full_name,
        u.zipcode,
        u.state,
        u.country,

        aggs.order_count,
        aggs.total_unique_products_purchased,
        aggs.total_items_purchased,
        aggs.total_discount,
        aggs.total_revenue,
        aggs.total_shipping_paid,
        aggs.total_paid,
        aggs.total_on_time_deliveries/aggs.order_count as otd_rate

    from users u
    left join orders o
        on u.user_id = o.user_id
    left join aggs
        on u.user_id = aggs.user_id

)

select * from results