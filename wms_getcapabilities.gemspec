# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wms_getcapabilities/version"

Gem::Specification.new do |s|
  s.name        = "wms_getcapabilities"
  s.version     = WmsGetcapabilities::VERSION
  s.authors     = ["Jerome Chapron"]
  s.email       = ["jchapron@dotgee.fr"]
  s.homepage    = "https://github.com/imperYaL/wms_getcapabilities"
  s.summary     = "Interface between ruby and Geoserver WMS GetCapabilities"
  s.description = "Interface between ruby and Geoserver WMS GetCapabilities"

  s.rubyforge_project = "wms_getcapabilities"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
