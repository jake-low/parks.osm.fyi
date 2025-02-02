---
layout: page
---

These are all of the boundaries in OpenStreetMap tagged `operator=National Park Service`, grouped by their `protection_title` value.

Compare to Wikipedia's [List of areas in the United States National Park System](https://en.wikipedia.org/wiki/List_of_areas_in_the_United_States_National_Park_System).

## National Parks
{% assign parks = site.data.nps | where: "protection_title", "National Park" | sort: "name" %}

There are {{ parks | size }} boundaries in OSM tagged `operator=National Park Service` + `protection_title=National Park`.

{% include table.html data=parks links=true %}

## National Monuments
{% assign monuments = site.data.nps | where: "protection_title", "National Monument" | sort: "name" %}
{% include table.html data=monuments links=true %}

## National Recreation Areas
{% assign rec_areas = site.data.nps | where: "protection_title", "National Recreation Area" | sort: "name" %}
{% include table.html data=rec_areas links=true %}

## National Preserves
{% assign preserves = site.data.nps | where: "protection_title", "National Preserve" | sort: "name" %}
{% include table.html data=preserves links=true %}

## National Historic Sites
{% assign historic_sites = site.data.nps | where: "protection_title", "National Historic Site" | sort: "name" %}
{% include table.html data=historic_sites links=true %}

## National Historical Parks
{% assign historical_parks = site.data.nps | where: "protection_title", "National Historical Park" | sort: "name" %}
{% include table.html data=historical_parks links=true %}

