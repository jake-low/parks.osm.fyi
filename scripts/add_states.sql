LOAD spatial;

CREATE TABLE parks_with_states AS (
WITH
  states AS (
    SELECT
      properties.ref AS id,
      ST_GeomFromGeoJSON (geometry) AS geometry
    FROM
      'boundaries/us-states.ndjson'
  ),
  parks AS (
    SELECT
      parks.*,
      STRING_AGG (DISTINCT states.id, ',') AS "@states"
    FROM
      'parks.parquet' AS parks
      LEFT JOIN states ON ST_Intersects (parks.geometry, states.geometry)
    WHERE
      ST_Area (ST_Intersection (parks.geometry, states.geometry)) / ST_Area (parks.geometry) > 0.25
    GROUP BY
      parks.*
  )
  SELECT * FROM parks
);

COPY (SELECT * from parks_with_states) TO 'parks_with_states.parquet' (FORMAT parquet);
