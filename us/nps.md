---
layout: page
title: National Park Service areas
---

{% assign parks = "operator = 'National Park Service'" | duckdb %}
{% assign protection_titles = parks | map: "protection_title" | freq %}

These are all of the boundaries in OpenStreetMap tagged `operator=National Park Service`. There are {{ parks | size }} boundaries in OSM that meet these criteria, listed below in groups by their `protection_title`.

Compare to Wikipedia's [List of areas in the United States National Park System](https://en.wikipedia.org/wiki/List_of_areas_in_the_United_States_National_Park_System).

{% for protection_title in protection_titles %}

## {{ protection_title[0] | default: "(none)" }}

{% assign data = parks | where: "protection_title", protection_title[0] | sort: "name" %}
{% include table.html data=data links=true %}

{% endfor %}

