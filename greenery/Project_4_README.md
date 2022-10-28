## Week 4 Project

#### Part 1: dbt Snapshots
The following order_ids changed from Week 3 to Week 4:
- 8385cfcd-2b3f-443a-a676-9756f7eb5404
- e24985f3-2fb3-456e-a1aa-aaf88f490d70
- 5741e351-3124-4de7-9dff-01a448e7dfd4

#### Part 2: Modeling

- How are users moving through the product funnel?
Query:
```
with session_counts as (
    select
        date_trunc('day', event_at) as date,
        count(distinct session_id)  as sessions,
        
        count(distinct
            case
                when event_type = 'page_view'
                    then session_id
            end)                    as page_views,
        
        count(distinct
            case
                when event_type = 'add_to_cart'
            end)                    as add_to_carts,
        
        count(distinct
            case
                when event_type = 'checkout'
            end)                    as checkouts
    from fct_conversion
    group by 1
),

results as (
    select
        date,
        page_views/sessions     as view_conversion,
        add_to_cart/sessions    as add_conversion,
        checkouts/sessions      as checkout_conversion
    from session_counts
)

select * from results;
```

When viewing a daily trend of the product funnel, its clear some users have a session on one day and return the next day to complete the transaction.
Daily view of product funnel:

| Date | View Conversion | Add Conversion | Checkout Conversion |
| :--: | :-------------: | :------------: | :-----------------: |
| 2021-02-09 | 1 | 1 | 0 |
| 2021-02-10 | 0.989 | 0.994 | 1 |
| 2021-02-11 | 0.907 | 0.656 | 0.416 |
| 2021-02-12 | 0 | 0 | 0 |


- Which steps in the funnel have largest drop off points?

The overall funnel (not daily) looks like the following:
```
with session_counts as (
    select
        count(distinct session_id)  as sessions,
        
        count(distinct
            case
                when event_type = 'page_view'
                    then session_id
            end)                    as page_views,
        
        count(distinct
            case
                when event_type = 'add_to_cart'
            end)                    as add_to_carts,
        
        count(distinct
            case
                when event_type = 'checkout'
            end)                    as checkouts
    from fct_conversion
),

results as (
    select
        page_views/sessions     as view_conversion,
        add_to_cart/sessions    as add_conversion,
        checkouts/sessions      as checkout_conversion
    from session_counts
)

select * from results;
```

Table:
| View Conversion | Add Conversion | Checkout Conversion |
| :-------------: | :------------: | :-----------------: |
| 1 | 0.808 | 0.625 |


The largest drop-off is between Views and Adds. Focusing on areas to promote 'Add-to-carts' will strengthen this funnel.

