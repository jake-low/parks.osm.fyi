---
layout: page
---

{% assign parks = site.data.wilderness | sort_natural: "name" %}

These are all of the boundaries in OpenStreetMap tagged `protection_title = Wilderness Area`. There are {{ parks | size }} of them.

Compare with Wikipedia's [List of wilderness areas of the United States](https://en.wikipedia.org/wiki/List_of_wilderness_areas_of_the_United_States).

{% assign parks = site.data.wilderness | sort_natural: "name" %}
{% include table.html data=parks columns="name,ownership,operator" %}
