# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wms_getcapabilities/version"

Gem::Specification.new do |s|
  s.name        = "wms_getcapabilities"
  s.version     = WmsGetcapabilities::VERSION
  s.authors     = ["Jerome Chapron"]
  s.email       = ["jchapron@dotgee.fr"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "wms_getcapabilities"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
