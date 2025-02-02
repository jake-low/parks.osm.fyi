#!/usr/bin/env python3
import sys
import json
import shapely

for line in sys.stdin:
    feature = json.loads(line)
    tags = feature["properties"]
    # geom = shapely.make_valid(shapely.geometry.shape(feature["geometry"]))

    checks = []

    if "protection_title" not in tags:
        checks.append({ "tag": "protection_title", "issue": "missing", "message": "no value for protection_title" })
    elif tags["protection_title"] not in tags.get("name", ""):
        checks.append({ "tag": "protection_title", "issue": "suspicious", "message": "protection_title is not a substring of name" })

    feature["properties"]["@checks"] = checks
    print(json.dumps(feature))

# json.dump(geojson, file=sys.stdout)
