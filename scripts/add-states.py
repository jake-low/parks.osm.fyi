#!/usr/bin/env python3
import sys
import json
import shapely

states_geojson = json.load(open("boundaries/us-states.geojson"))
states = {
    f["properties"]["iso_3166_2"][3:]: shapely.buffer(shapely.geometry.shape(f["geometry"]), -0.01)
    for f in states_geojson["features"]
}

for line in sys.stdin:
    feature = json.loads(line)
    geom = shapely.make_valid(shapely.geometry.shape(feature["geometry"]))
    # feature["bbox"] = shapely.bounds(geom)
    is_in_states = []
    for state_id, state_geom in states.items():
        if shapely.intersects(geom, state_geom):
            is_in_states.append(state_id)
    
    feature["properties"]["@states"] = ",".join(is_in_states)
    print(json.dumps(feature))

# json.dump(geojson, file=sys.stdout)
