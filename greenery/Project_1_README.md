
### How many users do we have?

130 users

```
select
    count(user_id) as user_count
    
from dev_db.dbt_benpannell.stg_users;
```

### On average, how many orders do we receive per hour?

~ 7.5 orders per hour

```
with orders_per_hour as (
    select distinct
        date_trunc(hour, created_at) as hours,
        count(order_id) as count_orders
    from dev_db.dbt_benpannell.stg_orders
    group by 1
)

select avg(count_orders) as orders_per_hour from orders_per_hour;
```

### On average, how long does an order take from being placed to being delivered?

~ 93.4 hours from order creation to delivery

```
with order_times as (
    select 
        created_at,
        delivered_at,
        datediff(hours, created_at, delivered_at) as elapsed_hours
    from dev_db.dbt_benpannell.stg_orders
)

select avg(elapsed_hours) as average_hours from order_times;
```

### How many users have only made one purchase? Two purchases? Three+ purchases?

- Users with 1 purchase: 25
- Users with 2 purchases: 28
- Users with 3+ purchases: 71

```
with order_counts as (
select 
    user_id,
    count(distinct order_id) as order_counts
from dev_db.dbt_benpannell.stg_orders
group by 1
),

user_counts as (
    select
        count(case when order_counts = 1 then user_id else null end) as one,
        count(case when order_counts = 2 then user_id else null end) as two,
        count(case when order_counts >= 3 then user_id else null end) as three_plus
    from order_counts
)

select * from user_counts;
```

### On average, how many unique sessions do we have per hour?

~ 16.33 sessions per hour

```
with sessions_per_hour as (
    select
        date_trunc(hour, created_at) as hour,
        count(distinct session_id) as session_count
    from dev_db.dbt_benpannell.stg_events
    group by 1
)

select avg(session_count) as avg_sessions from sessions_per_hour;
```