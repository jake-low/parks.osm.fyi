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

    out = `duckdb -c "copy(select * exclude(bbox, geometry) from 'parks.parquet' where \\"@states\\" like '%#{state["id"]}%') to stdout (format 'json')"`
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

All parks in {{ page.state.name }}, grouped by their `protection_title`.

{% for protection_title in protection_titles %}

## {{ protection_title[0] | default: "(none)" }}

{% assign data = page.parks | where: "protection_title", protection_title[0] | sort: "name" %}
{% include table.html data=data links=true %}

{% endfor %}
EOS

  end
end
