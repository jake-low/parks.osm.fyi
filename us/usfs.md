---
layout: page
---

These are all of the boundaries in OpenStreetMap that have one of the following `operator` values:
- `US Forest Service`
- `United States Forest Service`
- `USFS`

{% assign parks = "operator in ('US Forest Service', 'United States Forest Service', 'USFS')" | duckdb %}
{% assign protection_titles = parks | map: "protection_title" | freq %}

There are {{ parks | size }} boundaries in OSM that meet these criteria.
They are listed below, grouped by their `protection_title` value.

{% for protection_title in protection_titles %}

## {{ protection_title[0] | default: "(none)" }}

{% assign data = parks | where: "protection_title", protection_title[0] | sort: "name" %}
{% include table.html data=data columns="name,operator" links=true %}

{% endfor %}
