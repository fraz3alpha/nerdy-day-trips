require "nokogiri"
require "securerandom"

module Jekyll
  module Openstreetmap
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
vectorSource.addFeature(new ol.Feature({
  geometry: new
    ol.geom.Point(ol.proj.transform([#{lon}, #{lat}], 'EPSG:4326', 'EPSG:3857')),
  name: 'Some Place',
}));
ICON
        end

        puts map_icons.join("\n")

        # // Add the marker for this place
        # var iconFeature = new ol.Feature({
        #   geometry: new
        #     ol.geom.Point(ol.proj.transform([#{lon}, #{lat}], 'EPSG:4326',   'EPSG:3857')),
        #   name: 'This Place',
        # });
        # vectorSource.addFeature(iconFeature);

        # Do not indent the text otherwise Jekyll will parse it as a block of code
        # The string ""class="openstreetmap-map"" must appear as that is what
        # we look for later to add in the required scripts
        <<MAP_HTML
<div id="map" class="openstreetmap-map"></div>
<script type="text/javascript">

  // Create empty vector to store our markers
  var vectorSource = new ol.source.Vector({
  });

  #{map_icons.join("\n")}

  // Marker style
  var iconStyle = new ol.style.Style({
    image: new ol.style.Icon(/** @type {olx.style.IconOptions} */ ({
      anchor: [0.5, 0.5],
      anchorXUnits: 'fraction',
      anchorYUnits: 'fraction',
      size: [128, 128],
      opacity: 1,
      src: '/images/markers/crosshair-128x128.png',
      scale: 0.25
    }))
  });

  // Add the feature vector to the layer vector, and apply a style to whole layer
  var vectorLayer = new ol.layer.Vector({
    source: vectorSource,
    style: iconStyle
  });

  var map = new ol.Map({
    target: 'map',
    layers: [
      new ol.layer.Tile({
        source: new ol.source.OSM({
          // We need an API key for opencyclemap, so lets just use the default one
          // url: "https://{a-c}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        })
      }),
      vectorLayer
    ],
    view: new ol.View({
      center: ol.proj.fromLonLat([0, 51]),
      zoom: 10
    })
  });
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
          head.add_child('<script src="https://openlayers.org/en/v4.6.5/build/ol.js" type="text/javascript"></script>')
          head.add_child('<link rel="stylesheet" href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">')
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
Liquid::Template.register_tag('openstreetmap', Jekyll::Openstreetmap::RenderOpenstreetmapTag)

# For those pages which contain a map, add the appropriate script tags to reference
# the required Javascript
Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  # print doc
  # if doc.output =~ %r!#{Jekyll::Maps::GoogleMapTag::JS_LIB_NAME}!
  #   Jekyll::Maps::GoogleMapApi.prepend_api_code(doc)
  # end
  if doc.output =~ %r!class="openstreetmap-map!
    Jekyll::Openstreetmap::Lib.addHeadJavascriptEntries(doc)
  end
end
