---
layout: page
title: National Recreation Areas
---

{% assign parks = "name like '% National Recreation Area'" | duckdb | sort: "name" %}

These are all of the boundaries in OpenStreetMap whose name ends in "National Recreation Area". There are {{ parks | size }} of them. They are grouped below by their `operator`.

Compare with Wikipedia's [List of national recreation areas](https://en.wikipedia.org/wiki/National_recreation_area#List_of_national_recreation_areas).


{% assign operators = parks | map: "operator" | freq %}
{% for operator in operators %}

## {{ operator[0] | default: "(none)" }}

{% assign data = parks | where: "operator", operator[0] | sort: "name" %}
{% include table.html data=data columns="name,protect_class,protection_title" links=true %}

{% endfor %}
