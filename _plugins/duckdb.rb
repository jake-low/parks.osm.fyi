require 'json'

module Jekyll
  module DuckDbFilter
    def duckdb(sql_query)
      out = `duckdb -c "load spatial; copy (#{sql_query}) to stdout (format 'json')"`
      return [] if out.strip.empty?

      out.split("\n").filter_map do |line|
        next if line.strip.empty?
        begin
          JSON.parse(line)
        rescue JSON::ParserError => e
          puts "Warning: Failed to parse JSON line: #{line}"
          puts "Error: #{e}"
          nil
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::DuckDbFilter)
