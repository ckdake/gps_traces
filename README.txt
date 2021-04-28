ruby mykml2csv.rb

/usr/local/share/npm/lib/node_modules/topojson/bin/topojson -o combined.topojson combined.geojson

for yeargeojson in years/*; do
  /usr/local/share/npm/lib/node_modules/topojson/bin/topojson -o ${yeargeojson/geo/topo} $yeargeojson
done

# https://developer.here.com/blog/working-with-geojson-and-visual-studio-code is helpful.