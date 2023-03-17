require 'nokogiri'
require 'json'

doc = Nokogiri::XML(File.open('./fmrideatl.kml'))

combined = { type: 'MultiLineString', coordinates: [] }
years = {}
months = {}

doc.css('Placemark').each do |p|
  name = p.css('name').text
  coordinates_strings = p.css('coordinates').first.text.split(' ').collect{|i| i.split(',')}


  coordinates = coordinates_strings.map { |a| a.map { |b| b.to_f} }

  combined[:coordinates] << coordinates

  year = name
  years[year] ||= []
  years[year] << coordinates

  open("fmrideatl/#{name}.geojson", 'w') { |f|
    f.puts({ type: 'LineString', coordinates: coordinates }.to_json)
  }
end

open("fmrideatl.geojson", 'w') { |f| f.puts combined.to_json }

