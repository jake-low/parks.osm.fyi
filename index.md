---
layout: home
---

Welcome to [parks.osm.fyi](/). This website lists parks, nature reserves, and protected area boundaries from [OpenStreetMap](https://openstreetmap.org). It is intended to help contributors check for data errors and missing boundaries.

## United States

### by federal agency

- [National Park Service areas](/us/nps)
- [Bureau of Land Management areas](/us/blm)
- [US Forest Service areas](/us/usfs)

### by kind

- [Wilderness Areas](/us/wilderness)
- [National Monuments](/us/national-monuments)
- [State Parks](/us/state-parks)

### by state

<ul style="column-count: 3">
{%- for state in site.data.states %}
<li><a href="/us/{{ state.id | lower }}">{{ state.name }}</a></li>
{%- endfor %}
</ul>
