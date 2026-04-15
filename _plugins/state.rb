require "json"

class StatePageGenerator < Jekyll::Generator
  safe true

  def generate(site)
    site.data["states"].each do |state|
      # puts state.inspect
      site.pages << StatePage.new(site, state)
    end
  end
end

class StatePage < Jekyll::Page
  def initialize(site, state)
    @site = site             # the current site instance.
    @base = site.source      # path to the source directory.
    @dir  = '/us/'           # the directory the page will reside in.

    @basename = state["id"].downcase
    @ext      = '.md'
    @name     = @basename + @ext

    # Use spatial join to find parks within this state
    out = `duckdb -c "
      LOAD spatial;
      COPY (
        WITH state_boundary AS (
          SELECT geometry
          FROM 'layercake/boundaries.parquet'
          WHERE admin_level = '4'
          AND \\\"ISO3166-2\\\" = 'US-#{state["id"]}'
        ),
        parks_in_state AS (
          SELECT parks.*
          FROM 'layercake/parks.parquet' AS parks
          JOIN state_boundary ON ST_Intersects(parks.geometry, state_boundary.geometry)
          WHERE ST_Area(ST_Intersection(parks.geometry, state_boundary.geometry)) / ST_Area(parks.geometry) > 0.25
        )
        SELECT *
        FROM parks_in_state
      ) TO stdout (FORMAT 'json')
    "`
    parks = out.split("\n").map { |line| JSON.parse(line) }

    @data = {
      'layout' => 'page',
      'title' => state["name"],
      'state' => state,
      'parks' => parks,
      # 'protection_titles' => protection_titles,
    }

    @content = <<-EOS
{% assign protection_titles = page.parks | map: "protection_title" | freq %}

There are {{ page.parks | size }} parks in {{ page.state.name }} mapped in OpenStreetMap.
They are listed below, grouped by their `protection_title`.

{% for protection_title in protection_titles %}

## {{ protection_title[0] | default: "(none)" }}

{% assign data = page.parks | where: "protection_title", protection_title[0] | sort: "name" %}
{% include table.html data=data links=true %}

{% endfor %}
EOS

  end
end
