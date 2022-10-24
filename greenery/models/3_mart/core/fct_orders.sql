{{
  config(
    materialized='table'
  )
}}

with orders_source as (
    select * from {{ ref('int_order_details') }}
),

on_time_delivery as (
    select
        order_id,

        -- Calculations
        datediff('day', created_at, estimated_delivery_at)      as est_days_to_delivery,
        datediff('day', created_at, delivered_at)               as actual_days_to_delivery,
        datediff('day', estimated_delivery_at, delivered_at)    as delivery_estimate_error

    from orders_source
),

results as (
    select
        -- Primary Key
        o.order_id,

        -- Foreign Keys
        o.user_id,
        o.address_id,
        o.tracking_id,

        -- Order Info
        o.order_status,
        o.products_purchased,
        o.total_items_purchased,
        o.promo_name,
        o.promo_discount,
        o.order_cost,
        o.shipping_cost,
        o.total_cost,
        o.carrier,
        o.estimated_delivery_at,
        o.delivered_at,

        case
            when otd.est_days_to_delivery = otd.actual_days_to_delivery
              then 1
            else 0
        end           as is_on_time_delivery

    from orders_source o
    left join on_time_delivery otd
      on o.order_id = otd.order_id
)

select * from results