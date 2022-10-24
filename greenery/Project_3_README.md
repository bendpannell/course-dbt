## Week 3 Project

#### Part 1: Create conversion models

- What is our overall conversion rate?
Overall conversion rate: 62.5%

```
select
    count(distinct session_id)  as sessions,
    count(distinct order_id)    as orders,
    orders/sessions * 100       as conversion_rate
from fct_conversion;
```

- What is our conversion rate by product?
```
select
    product_id,
    count(distinct session_id) as sessions,
    count(distinct order_id)    as orders,
    orders/sessions * 100            as conversion_rate
from fct_conversion
group by 1;
```
#### Part 2: Macros
- Created macro `event_type_counts.sql` to aggregate the event types and slice 
  them by an input field.

  #### Part 3: Hooks
  - Created post hook to grant select on my marts models to the reporting role.

  #### Part 4: Packages
  - Installed dbt_utils and used the following:
    - `surrogate_key`
    - `get_column_values`
    - `group_by`

  #### Part 5: Snapshots
  The following orders were updated:
```
ORDER_ID
8385cfcd-2b3f-443a-a676-9756f7eb5404
e24985f3-2fb3-456e-a1aa-aaf88f490d70
5741e351-3124-4de7-9dff-01a448e7dfd4
``` 