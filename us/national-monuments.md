---
layout: page
title: National Monuments
---

{% assign parks = "name like '% National Monument'" | duckdb | sort: "name" %}

These are all of the boundaries in OpenStreetMap whose name ends in "National Monument". There are {{ parks | size }} of them. They are grouped below by their `operator`.

Compare with Wikipedia's [List of national monuments of the United States](https://en.wikipedia.org/wiki/List_of_national_monuments_of_the_United_States).


{% assign operators = parks | map: "operator" | freq %}
{% for operator in operators %}

## {{ operator[0] | default: "(none)" }}

{% assign data = parks | where: "operator", operator[0] | sort: "name" %}
{% include table.html data=data columns="name,protect_class,protection_title" links=true %}

{% endfor %}
