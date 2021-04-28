require 'nokogiri'
require 'json'

doc = Nokogiri::XML(File.open('/Users/ckdake/Library/Application Support/Google Earth/myplaces.kml'))

combined = { type: 'MultiLineString', coordinates: [] }
years = {}
months = {}

doc.css('Placemark').each do |p|
  name = p.css('name').text
  if /\d\d\d\d\.\d\d\.\d\d/.match(name)
    name = name.gsub(/[^\w\s_-]+/, '')
               .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
               .gsub(/\s+/, '_')
    coordinates = p.css('coordinates').first.text.split(' ').collect{|i| i.split(',')}
    combined[:coordinates] << coordinates

    year = name[0,4]
    years[year] ||= []
    years[year] << coordinates
    
    month = name[0,6]
    months[month] ||= []
    months[month] << coordinates

    open("split/#{name}.geojson", 'w') { |f|
      f.puts({ type: 'LineString', coordinates: coordinates }.to_json)
    }
  end
end

combined_feature_collection = {
  type: "FeatureCollection",
  features: [{
    type: "Feature",
    properties: {},
    geometry: combined
  }]
}

open("combined.geojson", 'w') { |f| f.puts combined_feature_collection.to_json }

years.each_pair do |year,coordinates|
  years_feature_collection = {
    type: "FeatureCollection",
    features: [{
      type: "Feature",
      properties: {},
      geometry: {
        type: "MultiLineString",
        coordinates: coordinates
      }
    }]
  }
  open("years/#{year}.geojson", 'w') { |f|
    f.puts(years_feature_collection.to_json)
  }
end

months.each_pair do |month,coordinates|
  months_feature_collection = {
    type: "FeatureCollection",
    features: [{
      type: "Feature",
      properties: {},
      geometry: {
        type: "MultiLineString",
        coordinates: coordinates
      }
    }]
  }
  open("months/#{month}.geojson", 'w') { |f|
    f.puts(months_feature_collection.to_json)
  }
end