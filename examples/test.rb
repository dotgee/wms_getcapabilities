require "wms_getcapabilities"

geoserver = WmsGetcapabilities::Geoserver.new("http://geo.devel.dotgee.fr/geoserver")
geoserver.get_capabilities
puts geoserver.layers.inspect