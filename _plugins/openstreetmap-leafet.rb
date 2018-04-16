require "nokogiri"
require "securerandom"

module Jekyll
  module OpenstreetmapLeaflet
    class RenderOpenstreetmapTag < Liquid::Tag

      def initialize(tag_name, text, tokens)
        super
        @text = text
        @options = Lib.parseOptions(text)
        puts @options
      end

      def has_location?(doc)
        !doc["location"] && !doc["location"].empty?
      end

      def render(context)
        puts "Inserting a map into #{context['page']['path']} - #{context.registers[:page]["title"]}"

        map_locations = []
        if !@options['src'].nil?
          context.registers[:site].collections.each_value do |collection|
            collection.docs.each do |doc|
              if doc.relative_path.start_with?(@options['src'])
                puts "#{doc["title"]} - #{doc.relative_path} - #{doc["location"]}"
                # if has_location?(doc)
                map_locations << doc
                # end
              end
            end
          end
        else
          puts "No src options, using current page"
          # if has_location?(context.registers[:page])
          map_locations << context.registers[:page]
          # end
        end

        puts map_locations.length

        map_icons = []
        map_locations.each do |doc|
          location = doc["location"]

          lat = location["latitude"]
          lon = location["longitude"]

          map_icons << <<ICON
markers.addLayer(L.marker([#{lat}, #{lon}]).bindPopup('A pretty CSS3 popup.<br> Easily customizable.'));
ICON
        end

        puts map_icons.join("\n")

        # Do not indent the text otherwise Jekyll will parse it as a block of code
        # The string ""class="openstreetmap-map"" must appear as that is what
        # we look for later to add in the required scripts
        <<MAP_HTML
<div id="map" class="openstreetmap-leaflet-map" style="height: 400px"></div>
<script type="text/javascript">
var map = L.map('map').setView([51.505, -0.09], 13);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);

map.addControl(new L.Control.Fullscreen());

var geocoder = L.Control.geocoder({
        defaultMarkGeocode: false
    })
    .on('markgeocode', function(e) {
        var bbox = e.geocode.bbox;
        var poly = L.polygon([
             bbox.getSouthEast(),
             bbox.getNorthEast(),
             bbox.getNorthWest(),
             bbox.getSouthWest()
        ])
        map.fitBounds(poly.getBounds());
    })
    .addTo(map);

var markers = L.markerClusterGroup();
#{map_icons.join("\n")}
map.addLayer(markers);

</script>
MAP_HTML

      end
    end

    class Lib
      def self.addHeadJavascriptEntries(page)
        # puts "Doing some stuff!"
        doc = Nokogiri::HTML(page.output)
        # puts "We now have a Nokogiri parsed object"
        # puts "Adding the script tags to HEAD"

        head = doc.xpath("//html//head").first
        if !head.nil?
          head.add_child('<link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css" integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ==" crossorigin=""/>')
          head.add_child('<script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js" integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw==" crossorigin=""></script>')
          head.add_child('<script src="https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/Leaflet.fullscreen.min.js"></script>')
          head.add_child('<link href="https://api.mapbox.com/mapbox.js/plugins/leaflet-fullscreen/v1.0.1/leaflet.fullscreen.css" rel="stylesheet"/>')
          head.add_child('<link rel="stylesheet" href="/css/MarkerCluster.css" />')
          head.add_child('<link rel="stylesheet" href="/css/MarkerCluster.Default.css" />')
          head.add_child('<script src="/js/leaflet.markercluster.js"></script>')
          head.add_child('<link rel="stylesheet" href="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.css" />')
          head.add_child('<script src="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.js"></script>')
        end

        # Format the Nokogiri object back into a string
        page.output = doc.to_s
      end

      def self.parseOptions(text)
        options = {}
        text.scan(%r!([^\s]+)\s*=\s*['"]+([^'"]+)['"]+!).each do |key, value|
          options[key] = value
        end
        return options
      end

    end

  end
end

# Register what to do when an openstreetmap tag is encountered
Liquid::Template.register_tag('openstreetmap_leaflet', Jekyll::OpenstreetmapLeaflet::RenderOpenstreetmapTag)

# For those pages which contain a map, add the appropriate script tags to reference
# the required Javascript
Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # print doc
  # if doc.output =~ %r!#{Jekyll::Maps::GoogleMapTag::JS_LIB_NAME}!
  #   Jekyll::Maps::GoogleMapApi.prepend_api_code(doc)
  # end
  if doc.output =~ %r!class="openstreetmap-leaflet-map!
    Jekyll::OpenstreetmapLeaflet::Lib.addHeadJavascriptEntries(doc)
  end
end
