require 'nokogiri'
require 'json'

doc = Nokogiri::XML(File.open('/Users/ckdake/Library/Application Support/Google Earth/myplaces.kml'))

combined = { type: 'MultiLineString', coordinates: [] }

doc.css('Placemark').each do |p|
  name = p.css('name').text
  if /\d\d\d\d\.\d\d\.\d\d/.match(name)
    name = name.gsub(/[^\w\s_-]+/, '')
               .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
               .gsub(/\s+/, '_')
    coordinates = p.css('coordinates').first.text.split(' ').collect{|i| i.split(',')}
    combined[:coordinates] += coordinates
    open("split/#{name}.geojson", 'w') { |f|
      f.puts({ type: 'LineString', coordinates: coordinates }.to_json)
    }
  end
end
open("combined.geojson", 'w') { |f| f.puts combined.to_json }
