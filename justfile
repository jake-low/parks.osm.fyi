data: download parquet add_states

download:
    curl 'https://download.geofabrik.de/north-america/us-latest.osm.pbf' -o us-latest.osm.pbf

parquet:
    python scripts/parks.py us-latest.osm.pbf parks.parquet
    osmium fileinfo --get header.option.timestamp us-latest.osm.pbf > parks.timestamp

add_states:
    duckdb < scripts/add_states.sql
    rm parks.parquet
    mv parks_with_states.parquet parks.parquet
