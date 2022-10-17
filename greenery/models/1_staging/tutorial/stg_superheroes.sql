{{
  config(
    materialized='table'
  )
}}

SELECT 
    id                  as superhero_id,
    name,
    gender,
    eye_color,
    race,
    hair_color,
    nullif(height, -99) as height,
    publisher,
    skin_color,
    alignment,
    nullif(weight, -99) as weight

FROM {{ source('tutorial', 'superheroes') }}