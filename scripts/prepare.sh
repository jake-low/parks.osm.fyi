#!/bin/sh

set -x

# Download Layercake data
mkdir -p layercake
curl -o layercake/parks.parquet https://data.openstreetmap.us/layercake/parks.parquet
curl -o layercake/boundaries.parquet https://data.openstreetmap.us/layercake/boundaries.parquet

# Extract timestamp from Layercake metadata
curl -s https://data.openstreetmap.us/layercake/metadata.json | jq -r '.timestamp' > parks.timestamp

# Update Jekyll data file with timestamp
mkdir -p _data
echo "\"$(cat parks.timestamp)\"" > _data/last_updated.json
