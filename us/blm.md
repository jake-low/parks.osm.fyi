---
layout: page
---

These are all of the boundaries in OpenStreetMap that have one of the following `operator` values:
- `US Bureau of Land Management`
- `Bureau of Land Management`
- `BLM`

{% assign parks = "operator in ('US Bureau of Land Management', 'Bureau of Land Management', 'BLM')" | duckdb %}
{% assign protection_titles = parks | map: "protection_title" | freq %}

There are {{ parks | size }} boundaries in OSM that meet these criteria.
They are listed below, grouped by their `protection_title` value.

{% for protection_title in protection_titles %}

<h2>{{ protection_title[0] | default: "(none)" }}</h2>

{% assign data = parks | where: "protection_title", protection_title[0] | sort: "name" %}
{% include table.html data=data columns="name,operator" links=true %}

{% endfor %}
