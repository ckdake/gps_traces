ruby mykml2csv.rb

/usr/local/share/npm/lib/node_modules/topojson/bin/topojson -o combined.topojson combined.geojson

for yeargeojson in years/*; do
  /usr/local/share/npm/lib/node_modules/topojson/bin/topojson -o ${yeargeojson/geo/topo} $yeargeojson
done
