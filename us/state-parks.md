---
layout: page
title: State Parks
query: |
  WITH state_parks AS (
    SELECT * FROM 'layercake/parks.parquet'
    WHERE name[1] LIKE '% State Park'
  ),
  states AS (
    SELECT name[1] AS name, geometry
    FROM 'layercake/boundaries.parquet'
    WHERE admin_level = '4' AND \"ISO3166-2\" LIKE 'US-%'
  )
  SELECT sp.*, states.name as state_name
  FROM state_parks sp
  JOIN states ON ST_Intersects(sp.geometry, states.geometry)
  WHERE ST_Area(ST_Intersection(sp.geometry, states.geometry)) / ST_Area(sp.geometry) > 0.25
---

{% assign all_state_parks = page.query | duckdb %}

These are all of the areas in OpenStreetMap that are within the U.S. and are tagged `boundary=protected_area` or `leisure=park` or `leisure=nature_reserve`, whose names end in "State Park". There are {{ all_state_parks | size }} such elements.

Note that this only includes State Parks, and not other state-operated protected areas such as State Forests, State Recreation Areas, etc.

{% assign states_with_parks = all_state_parks | map: "state_name" | uniq | sort %}
{% for state_name in states_with_parks %}

## {{ state_name }}

{% assign parks = all_state_parks | where: "state_name", state_name | sort: "name" %}
{% include table.html data=parks columns="name,protection_title,operator" links=true %}

{% endfor %}
