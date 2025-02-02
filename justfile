data: nps wilderness state_parks

nps:
    #!/bin/sh
    overpass --out geom '''
    rel(id:148838); // USA
    map_to_area;
    
    wr
      [boundary ~ "protected_area|national_park"]
      [operator = "National Park Service"]
      (area);
    ''' \
    | osmtogeojson \
    | scripts/filter-to-usa.py \
    | jq -s 'map(.properties)' \
    > _data/nps.json

wilderness:
    #!/bin/sh
    overpass --out geom '''
    rel(id:148838); // USA
    map_to_area;
    
    wr
      [boundary ~ "protected_area"]
      [protection_title = "Wilderness Area"]
      (area);
    ''' \
    | osmtogeojson \
    | scripts/filter-to-usa.py \
    | jq -s 'map(.properties)' \
    > _data/wilderness.json

state_parks:
    #!/bin/sh
    set -e
    
    overpass --out geom '''
    [timeout:600];
    
    rel(id:148838); // USA
    map_to_area;

    (
      wr[boundary=protected_area][name](area);
      wr[leisure=park][name](area);
      wr[leisure=nature_reserve][name](area);
    );

    wr._
      [name ~ " State Park$", i];
    ''' \
    | osmtogeojson \
    | scripts/filter-to-usa.py \
    | scripts/add-states.py \
    | jq '.properties | select(.boundary == "protected_area" or .leisure == "park" or .leisure == "nature_reserve")' \
    | jq -s '.' \
    > _data/state_parks.json
