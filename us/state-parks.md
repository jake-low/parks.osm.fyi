---
layout: page
---

These are all of the areas in OpenStreetMap that are tagged `boundary=protected_area` or `leisure=park` or `leisure=nature_reserve`, whose names end in "State Park". There are {{ site.data.state_parks | size }} such elements.

Note that this only includes State Parks, and not other state-operated protected areas such as State Forests, State Recreation Areas, etc.

{% for state in site.data.states %}

## {{ state.name }}

{% assign parks = site.data.state_parks | where_exp: "park", "park['@states'] contains state.id" | sort: "name" %}
{% include table.html data=parks links=true %}

{% endfor %}
