#!/usr/bin/env python3
import sys
import json
import shapely

usa_geojson = json.load(open("boundaries/us.geojson"))
usa_geoms = [shapely.geometry.shape(f["geometry"]) for f in usa_geojson["features"]]
usa_eroded = shapely.buffer(shapely.union_all(usa_geoms), -0.01)

for line in sys.stdin:
    feature = json.loads(line)
    geom = shapely.make_valid(shapely.geometry.shape(feature["geometry"]))
    # feature["bbox"] = shapely.bounds(geom)
    if shapely.intersects(usa_eroded, shapely.make_valid(geom)):
        print(json.dumps(feature))

# json.dump(geojson, file=sys.stdout)
