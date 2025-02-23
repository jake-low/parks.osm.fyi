import sys
import json
import binascii

import osmium
import pyarrow
import pyarrow.parquet
import shapely
import shapely.wkb

wkbfactory = osmium.geom.WKBFactory()

metadata = {
    "geo": json.dumps({
        "version": "1.1.0",
        "primary_column": "geometry",
        "columns": {
            "geometry": {
                "encoding": "WKB",
                "geometry_types": [],
                "covering": {
                    "bbox": {
                        "xmin": ["bbox", "xmin"],
                        "ymin": ["bbox", "ymin"],
                        "xmax": ["bbox", "xmax"],
                        "ymax": ["bbox", "ymax"]
                    }
                }
            }
        }
    })
}

TAGS = [
    'boundary',
    'protected_area',
    'protection_title',
    'name',
    'protect_class',
    'operator',
    'ownership',
    'website',
    'wikidata',
    'wikipedia',
]
    


bbox_schema =  pyarrow.struct([
        ("xmin", pyarrow.float32()),
        ("ymin", pyarrow.float32()),
        ("xmax", pyarrow.float32()),
        ("ymax", pyarrow.float32()),
    ])

schema = pyarrow.schema([
    ('@type', pyarrow.string()),
    ('@id', pyarrow.int64()),
    *[(tag, pyarrow.string()) for tag in TAGS],
    ('bbox', bbox_schema),
    ('geometry', pyarrow.binary()),
], metadata=metadata)


class GeoParquetWriter(osmium.SimpleHandler):

    def __init__(self, filename):
        super().__init__()
        self.filename = filename
        self.writer = pyarrow.parquet.ParquetWriter(filename, schema)
        self.chunk = []

    def finish(self):
        if self.chunk:
            self.flush()
        self.writer.close()

    def node(self, o):
        try:
            self.append("node", o.id, o.tags, wkbfactory.create_point(o))
        except RuntimeError as e:
            print(e, file=sys.stderr)

    # def way(self, o):
    #     if not o.is_closed():
    #         try:
    #             self.append(o.id, o.tags, wkbfactory.create_linestring(o))
    #         except RuntimeError as e:
    #             print(e, file=sys.stderr)

    def area(self, o):
        try:
            self.append(
                "way" if o.from_way() else "relation",
                o.orig_id(),
                o.tags,
                wkbfactory.create_multipolygon(o)
            )
        except RuntimeError as e:
            print(e, file=sys.stderr)

    def append(self, type, id, tags, wkb_hex):
        geom = shapely.wkb.loads(wkb_hex, hex=True)
        wkb = binascii.unhexlify(wkb_hex)
        
        attrs = {
            key: tags.get(key) for key in TAGS
        }

        bbox = dict(zip(["xmin", "ymin", "xmax", "ymax"], shapely.bounds(geom)))

        self.chunk.append({ "@type": type, "@id": id, **attrs, "bbox": bbox, "geometry": wkb })

        if len(self.chunk) >= 1000:
            self.flush()

    def flush(self):
        table = pyarrow.Table.from_pylist(self.chunk, schema=schema) # .cast(schema)
        self.writer.write_table(table)
        self.chunk = []
        


def main(osm_file, parquet_file):
    handler = GeoParquetWriter(parquet_file)

    handler.apply_file(
        osm_file,
        filters=[
            osmium.filter.EmptyTagFilter(),
            osmium.filter.TagFilter(
                ("boundary", "national_park"),
                ("boundary", "protected_area"),
                ("leisure", "park"),
                ("leisure", "nature_reserve"),
            )
        ]
    )

    handler.finish()
    return 0


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python %s OSM_FILE PARQUET_FILE" % sys.argv[0])
        sys.exit(-1)
    sys.exit(main(sys.argv[1], sys.argv[2]))
