require "wms_getcapabilities/version"
require 'libxml'
require 'open-uri'
require 'ostruct'

module WmsGetcapabilities
  
  autoload :Parser, "wms_getcapabilities/parser"

  def self.geoserver= geoserver
    @geoserver = geoserver
  end

  def self.process
    dom = open(@geoserver+"?SERVICE=WMS&REQUEST=GetCapabilities")
    caps = Parser.new(dom)
    puts caps.capabilities.inspect
  end

end
