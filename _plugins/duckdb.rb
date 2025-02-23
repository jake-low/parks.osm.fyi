require 'json'

module Jekyll
  module DuckDbFilter
    def duckdb(where_clause)
      out = `duckdb -c "copy(select * exclude(bbox, geometry) from 'parks.parquet' where #{where_clause}) to stdout (format 'json')"`
      out.split("\n").map {|line| JSON.parse(line) }
    end
  end
end

Liquid::Template.register_filter(Jekyll::DuckDbFilter)
