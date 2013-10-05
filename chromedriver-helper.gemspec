# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "chromedriver-helper"
  s.version     = "0.0.6"
  s.authors     = ["Mike Dalessio", "Sergey Demyanov"]
  s.email       = ["mike@csa.net", "s.demyanov@gmail.com"]
  s.homepage    = ""
  s.summary     = "Easy installation and use of chromedriver, the Chromium project's selenium webdriver adapter."
  s.description = "Easy installation and use of chromedriver, the Chromium project's selenium webdriver adapter."

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "xml-simple"
end
