## Week 2 Project

#### Part 1: Models

1. What is our repeat user rate?
Repeat rate = Users who purchased 2 or more times / users who purchased

76.15%

```
select
    count(case when order_count > 1
                then user_id
                else null
            end)                as repeat_count,

    count(user_id)              as count,
    repeat_count/count * 100    as repeat_rate

from fct_user_orders;
```

2. What are indicators of purchases?

From a high-level, users who spend more time on the sight are more likely to 
purchase. Similarly, users who view more products are more likely to purchase.
Also, over 1/3 of repeat users have used a promo with their order. Of the 
one-off orders, only 1 in 25 used a promo.

Orders vs. Abandons
```
with orders as (
select 
    'orders' as status,
    avg(added_count),
    avg(viewed_count),
    avg(session_length_min),
    avg(product_viewed_count)
from fct_user_events_to_order
),

abandons as (
    select 
        'abandons' as status,
        avg(added_count),
    avg(viewed_count),
    avg(session_length_min),
    avg(product_viewed_count)
    from fct_user_events_abandon
),

results as (
select * from orders
union all 
select * from abandons
)

select * from results;
```

Single vs. Repeat Orders:
```
with singles as (
select 
    '1 purchase' as cohort,
    count(distinct user_id) as user_count,
    sum(promo_count)        as promo_count,
    avg(avg_products_purchased) as ave_products_purchased,
    avg(avg_total_products_purchased)   as avg_total_products,
    avg(avg_order_cost),
    avg(avg_shipping_cost),
    avg(avg_order_total),
    avg(avg_est_delivery_days),
    avg(avg_actual_delivery_days),
    avg(avg_est_delivery_error)
from fct_user_orders   
where order_count = 1
),

repeats as (
select 
    'multi-purchase' as cohort,
    count(distinct user_id),
    sum(promo_count),
    avg(avg_products_purchased),
    avg(avg_total_products_purchased),
    avg(avg_order_cost),
    avg(avg_shipping_cost),
    avg(avg_order_total),
    avg(avg_est_delivery_days),
    avg(avg_actual_delivery_days),
    avg(avg_est_delivery_error)
from fct_user_orders   
where order_count > 1
),

results as (
select * from singles
union all
select * from repeats)

select * from results;
```

DAG:
![Photo of Week 2 DAG](/greenery/Week2_DAG.png)

#### Part 2: Tests

1. Assumptions:
 - I'm assuming that each staging model has a unique, not null primary key at the
    grain of the table.
2. "Bad" Data:
 - I found that I had to create surrogate keys in order to have a unique, non null 
 primary key in my fact tables.

 #### Part 3: Snapshots

 1. Which orders changed?
 Order ids:
 - 914b8929-e04a-40f8-86ee-357f2be3a2a2
 - 05202733-0e17-4726-97c2-0520c024ab85
 - 939767ac-357a-4bec-91f8-a7b25edd46c9
