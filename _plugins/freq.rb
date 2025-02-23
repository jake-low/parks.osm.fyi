module Jekyll
  module FreqFilter
    def freq(array)
      # puts array.inspect
      array.tally.sort_by {|k,v| k ? [-v, k] : [0, k] }
    end
  end
end

Liquid::Template.register_filter(Jekyll::FreqFilter)
