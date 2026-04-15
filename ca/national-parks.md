---
layout: page
title: National Parks
query: |
    WITH country AS (
        SELECT geometry
        FROM 'layercake/boundaries.parquet'
        WHERE contains(name, 'Canada')
    ) 
    SELECT parks.*
    FROM 'layercake/parks.parquet' AS parks
    JOIN country ON ST_Intersects(parks.geometry, country.geometry)
    WHERE ST_Area(ST_Intersection(parks.geometry, country.geometry)) / ST_Area(parks.geometry) > 0.25
      AND protection_title = 'National Park'
---

{% assign parks = page.query | duckdb | sort: "name" %}

These are all of the OpenStreetMap boundaries in Canada tagged `protection_title = National Park`. There are {{ parks | size }} of them.

Compare with Wikipedia's [List of national parks in Canada](https://en.wikipedia.org/wiki/List_of_national_parks_of_Canada).

{% include table.html data=parks columns="name,ownership,operator" links=true %}
